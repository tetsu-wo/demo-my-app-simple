terraform {
  backend "s3" {
    bucket = "demo-myapp-simple-938868825847-ap-northeast-1-an"
    key    = "ecs-demo/terraform.tfstate" # 保存されるファイル名（任意）
    region = "ap-northeast-1"
  }
}

# これが「名前空間」を作る本体です
resource "aws_service_discovery_http_namespace" "this" {
  name        = "example"
  description = "Cloud Map namespace for ECS Service Connect"
}


# 1. VPCモジュール：ネットワークを作る
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true # コスト削減のため
}


# 2. ALBモジュール：受け口を作る（module.alb が必要だった理由）
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name    = "my-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  security_group_ingress_rules = {
  all_http = {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    description = "HTTP web traffic"
    cidr_ipv4   = "0.0.0.0/0"
  } 
}

  # 外部からポート80でアクセス
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward  = {
        target_group_key = "frontend"

        # パスベースの振り分けルール（/api/はJavaへ）
        rules = {
          api_routing = {
            actions = [{
              type = "forward"
              target_group_key = "backend"
            }]
            conditions = [{
              path_pattern = {values = ["/api/*"]}
            }]
          }
        }  
      }
    }
  }

  target_groups = {
    frontend = {
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"

    # ECSサービス側でALBと紐付けるため、ALBモジュール側でのターゲット指定は不要です
      create_attachment = false

      health_check     = { path = "/"}
    }

    backend = {
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "ip"

    # ECSサービス側でALBと紐付けるため、ALBモジュール側でのターゲット指定は不要です
      create_attachment = false

      health_check     = { path = "/api/health"}
    }
  }
}




# 3. ECSモジュール：アプリの器を作る
module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "6.0.0"

  cluster_name = "ecs-integrated"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  default_capacity_provider_strategy = {
    FARGATE      = { weight = 50, base = 20 }
    FARGATE_SPOT = { weight = 50 }
  }

  depends_on = [module.alb]

  services = {
    # --- フロントエンド ---
    frontend = {
      cpu    = 1024
      memory = 4096
      container_definitions = {
        frontend-app = {
      image     = "938868825847.dkr.ecr.ap-northeast-1.amazonaws.com/my-app-frontend"
      container_name = "frontend-app"
      port_mappings = [
        {
          name          = "frontend-app"
          container_port = 3000
          protocol      = "tcp"
        }
      ]

    # ログ設定をコンテナ定義の中に移動（正しい階層）
    enable_cloudwatch_logging = true
    log_configuration = {
      log_driver = "awslogs"
      options = {
        "awslogs-group"         = "/aws/ecs/ecs-integrated/frontend"
        "awslogs-region"        = "ap-northeast-1"
        "awslogs-stream-prefix" = "ecs"
      }
    }
        }}
        
      

    service_connect_configuration = {
      namespace = aws_service_discovery_http_namespace.this.name
      service = [{
        client_alias   = { port = 80, dns_name = "frontend-api" }
        port_name      = "frontend-app"
        discovery_name = "frontend"
      }]
    }

    load_balancer = {
      service = {
        target_group_arn = module.alb.target_groups["frontend"].arn
        container_name   = "frontend-app"
        container_port   = 3000
      }
    }

    subnet_ids = module.vpc.private_subnets
    security_group_ingress_rules = {
      alb_3000 = {
        from_port   = 3000
        to_port     = 3000
        ip_protocol = "tcp"
        referenced_security_group_id = module.alb.security_group_id
      }
    }
    security_group_egress_rules = {
      all = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
    }
}

    # --- バックエンド ---
    backend = {
      cpu    = 1024
      memory = 4096
      container_definitions = {
        backend-app = {
      
      image     = "938868825847.dkr.ecr.ap-northeast-1.amazonaws.com/my-app-backend"
      container_name = "backend-app"
      port_mappings = [
        {
          name          = "backend-app"
          container_port = 8080
          protocol      = "tcp"
        }
      ]
      # ログ設定をコンテナ定義の中に移動（正しい階層）
      enable_cloudwatch_logging = true
      log_configuration = {
        log_driver = "awslogs"
        options = {
          "awslogs-group"         = "/aws/ecs/ecs-integrated/backend"
          "awslogs-region"        = "ap-northeast-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
        }}
        
      

      service_connect_configuration = {
        namespace = aws_service_discovery_http_namespace.this.name
        service = [{
          client_alias   = { port = 80, dns_name = "backend-api" }
          port_name      = "backend-app"
          discovery_name = "backend"
        }]
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["backend"].arn
          container_name   = "backend-app"
          container_port   = 8080
        }
      }

      subnet_ids = module.vpc.private_subnets
      security_group_ingress_rules = {
        alb_8080 = {
          from_port   = 8080
          to_port     = 8080
          ip_protocol = "tcp"
          referenced_security_group_id = module.alb.security_group_id
        }
      }
      security_group_egress_rules = {
        all = { ip_protocol = "-1", cidr_ipv4 = "0.0.0.0/0" }
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}
































