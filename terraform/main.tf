terraform {
  backend "s3" {
    bucket = "demo-myapp-simple-938868825847-ap-northeast-1-an"
    key    = "ecs-demo/terraform.tfstate" # 保存されるファイル名（任意）
    region = "ap-northeast-1"
  }
}

# これが「電話帳」本体の定義
resource "aws_service_discovery_http_namespace" "this" {
  name        = "example" # ここを "example" にすれば今のエラーは消えます
  description = "Cloud Map namespace for ECS Service Connect"
}

# main.tf のどこでも良いので追記
import {
  to = aws_service_discovery_http_namespace.this
  id = "ns-rbxcs4unbxj2abqi" # AWSコンソールで確認したNamespace ID
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

  # 外部からポート80でアクセス
  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward  = {
        target_group_key = "ecs-target"
      }
    }
  }

  target_groups = {
    ecs-target = {
      backend_protocol = "HTTP"
      backend_port     = 8080 # アプリのポート
      target_type      = "ip"

      # ECSサービス側でALBと紐付けるため、ALBモジュール側でのターゲット指定は不要です
      create_attachment = false 
    }
  }
}




# 3. ECSモジュール：アプリの器を作る
module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
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

  # Cluster capacity providers
  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 50
      base   = 20
    }
    FARGATE_SPOT = {
      weight = 50
    }
  }

  services = {
    ecsdemo-frontend = {
      cpu    = 1024
      memory = 4096

      # Container definition(s)
      container_definitions = {

        fluent-bit = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "906394416424.dkr.ecr.us-west-2.amazonaws.com/aws-for-fluent-bit:stable"
          firelensConfiguration = {
            type = "fluentbit"
          }
          memoryReservation = 50
        }

        ecs-sample = {
          cpu       = 512
          memory    = 1024
          essential = true
          image     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
          portMappings = [
            {
              name          = "ecs-sample"
              containerPort = 80
              protocol      = "tcp"
            }
          ]

          # Example image used requires access to write to root filesystem
          readonlyRootFilesystem = false

          dependsOn = [{
            containerName = "fluent-bit"
            condition     = "START"
          }]

          enable_cloudwatch_logging = false
          logConfiguration = {
            logDriver = "awsfirelens"
            options = {
              Name                    = "firehose"
              region                  = "eu-west-1"
              delivery_stream         = "my-stream"
              log-driver-buffer-limit = "2097152"
            }
          }
          memoryReservation = 100
        }
      }

      # 外部（インターネット）からのリクエストを受けるなら基本はALB
      # システム内部のコンテナ同士の通信を効率化したいならServiceConnect
      service_connect_configuration = {
        namespace = "example"
        service = [{
          client_alias = {
            port     = 80
            dns_name = "ecs-sample"
          }
          port_name      = "ecs-sample"
          discovery_name = "ecs-sample"
        }]
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["ecs-target"].arn
          container_name   = "ecs-sample"
          container_port   = 80
        }
      }

      subnet_ids = module.vpc.private_subnets
      security_group_ingress_rules = {
        alb_3000 = {
          description                  = "Service port"
          from_port                    = local.container_port
          ip_protocol                  = "tcp"
          referenced_security_group_id = "sg-12345678"
        }
      }
      security_group_egress_rules = {
        all = {
          ip_protocol = "-1"
          cidr_ipv4   = "0.0.0.0/0"
        }
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "Example"
  }
}









