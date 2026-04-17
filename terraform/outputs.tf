################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "ARN that identifies the cluster"
  value       = module.ecs_cluster.arn
}

output "cluster_id" {
  description = "ID that identifies the cluster"
  value       = module.ecs_cluster.id
}

output "cluster_name" {
  description = "Name that identifies the cluster"
  value       = module.ecs_cluster.name
}

output "cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group created"
  value       = module.ecs_cluster.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of CloudWatch log group created"
  value       = module.ecs_cluster.cloudwatch_log_group_arn
}

output "cluster_capacity_providers" {
  description = "Map of cluster capacity providers attributes"
  value       = module.ecs_cluster.cluster_capacity_providers
}

output "capacity_providers" {
  description = "Map of autoscaling capacity providers created and their attributes"
  value       = module.ecs_cluster.capacity_providers
}

output "task_exec_iam_role_name" {
  description = "Task execution IAM role name"
  value       = module.ecs_cluster.task_exec_iam_role_name
}

output "task_exec_iam_role_arn" {
  description = "Task execution IAM role ARN"
  value       = module.ecs_cluster.task_exec_iam_role_arn
}

output "task_exec_iam_role_unique_id" {
  description = "Stable and unique string identifying the task execution IAM role"
  value       = module.ecs_cluster.task_exec_iam_role_unique_id
}

output "infrastructure_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.ecs_cluster.infrastructure_iam_role_arn
}

output "infrastructure_iam_role_name" {
  description = "IAM role name"
  value       = module.ecs_cluster.infrastructure_iam_role_name
}

output "infrastructure_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.ecs_cluster.infrastructure_iam_role_unique_id
}

output "node_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = module.ecs_cluster.node_iam_role_arn
}

output "node_iam_role_name" {
  description = "IAM role name"
  value       = module.ecs_cluster.node_iam_role_name
}

output "node_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.ecs_cluster.node_iam_role_unique_id
}

output "node_iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = module.ecs_cluster.node_iam_instance_profile_arn
}

output "node_iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = module.ecs_cluster.node_iam_instance_profile_id
}

output "node_iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = module.ecs_cluster.node_iam_instance_profile_unique
}

################################################################################
# Service
################################################################################

output "frontend_service_id" {
  description = "ARN that identifies the frontend_service"
  value       = module.ecs_service_frontend.id
}

output "backend_service_id" {
  description = "ARN that identifies the backend_service"
  value       = module.ecs_service_backend.id
}

output "frontend_service_name" {
  description = "Name of the frontend_service"
  value       = module.ecs_service_frontend.name
}

output "backend_service_name" {
  description = "Name of the backend_service"
  value       = module.ecs_service_backend.name
}

output "frontend_service_iam_role_name" {
  description = "Frontend Service IAM role name"
  value       = module.ecs_service_frontend.iam_role_name
}

output "backend_service_iam_role_name" {
  description = "Service IAM role name"
  value       = module.ecs_service_backend.iam_role_name
}

output "frontend_service_iam_role_unique_id" {
  description = "Stable and unique string identifying the frontend service IAM role"
  value       = module.ecs_service_frontend.iam_role_unique_id
}

output "backend_service_iam_role_unique_id" {
  description = "Stable and unique string identifying the backend service IAM role"
  value       = module.ecs_service_backend.iam_role_unique_id
}

output "frontend_service_container_definitions" {
  description = "Frontend Service Container definitions"
  value       = module.ecs_service_frontend.container_definitions
}

output "backend_service_container_definitions" {
  description = "Backend Service Container definitions"
  value       = module.ecs_service_backend.container_definitions
}

output "frontend_service_task_definition_arn" {
  description = "Full ARN of the Task Definition (including both `family` and `revision`)"
  value       = module.ecs_service_frontend.task_definition_arn
}

output "backend_service_task_definition_arn" {
  description = "Full ARN of the Task Definition (including both `family` and `revision`)"
  value       = module.ecs_service_backend.task_definition_arn
}

output "frontend_service_task_definition_family" {
  description = "The unique name of the task definition"
  value       = module.ecs_service_frontend.task_definition_family
}

output "backend_service_task_definition_family" {
  description = "The unique name of the task definition"
  value       = module.ecs_service_backend.task_definition_family
}

output "frontend_service_task_exec_iam_role_name" {
  description = "Task execution IAM role name"
  value       = module.ecs_service_frontend.task_exec_iam_role_name
}

output "backend_service_task_exec_iam_role_name" {
  description = "Task execution IAM role name"
  value       = module.ecs_service_backend.task_exec_iam_role_name
}

output "frontend_service_task_exec_iam_role_arn" {
  description = "Frontend Service Task execution IAM role ARN"
  value       = module.ecs_service_frontend.task_exec_iam_role_arn
}

output "backend_service_task_exec_iam_role_arn" {
  description = "Backend Service Task execution IAM role ARN"
  value       = module.ecs_service_backend.task_exec_iam_role_arn
}

output "frontend_service_task_exec_iam_role_unique_id" {
  description = "Stable and unique string identifying the frontend service task execution IAM role"
  value       = module.ecs_service_frontend.task_exec_iam_role_unique_id
}

output "backend_service_task_exec_iam_role_unique_id" {
  description = "Stable and unique string identifying the backend service task execution IAM role"
  value       = module.ecs_service_backend.task_exec_iam_role_unique_id
}

output "frontend_service_tasks_iam_role_name" {
  description = "Frontend Service Tasks IAM role name"
  value       = module.ecs_service_frontend.tasks_iam_role_name
}

output "backend_service_tasks_iam_role_name" {
  description = "Backend Service Tasks IAM role name"
  value       = module.ecs_service_backend.tasks_iam_role_name
}

output "frontend_service_tasks_iam_role_unique_id" {
  description = "Stable and unique string identifying the frontend service tasks IAM role"
  value       = module.ecs_service_frontend.tasks_iam_role_unique_id
}

output "backend_service_tasks_iam_role_unique_id" {
  description = "Stable and unique string identifying the backend service tasks IAM role"
  value       = module.ecs_service_backend.tasks_iam_role_unique_id
}

output "frontend_service_task_set_id" {
  description = "The ID of the frontend service task set"
  value       = module.ecs_service_frontend.task_set_id
}

output "backend_service_task_set_id" {
  description = "The ID of the backend service task set"
  value       = module.ecs_service_backend.task_set_id
}

output "frontend_service_task_set_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the frontend service task set"
  value       = module.ecs_service_frontend.task_set_arn
}

output "backend_service_task_set_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the backend service task set"
  value       = module.ecs_service_backend.task_set_arn
}

output "frontend_service_task_set_stability_status" {
  description = "The stability status. This indicates whether the task set has reached a steady state"
  value       = module.ecs_service_frontend.task_set_stability_status
}

output "backend_service_task_set_stability_status" {
  description = "The stability status. This indicates whether the task set has reached a steady state"
  value       = module.ecs_service_backend.task_set_stability_status
}

output "frontend_service_task_set_status" {
  description = "The status of the frontend service task set"
  value       = module.ecs_service_frontend.task_set_status
}

output "backend_service_task_set_status" {
  description = "The status of the backend service task set"
  value       = module.ecs_service_backend.task_set_status
}

output "frontend_service_autoscaling_policies" {
  description = "Map of autoscaling policies and their attributes"
  value       = module.ecs_service_frontend.autoscaling_policies
}

output "backend_service_autoscaling_policies" {
  description = "Map of autoscaling policies and their attributes"
  value       = module.ecs_service_backend.autoscaling_policies
}

output "frontend_service_autoscaling_scheduled_actions" {
  description = "Map of autoscaling scheduled actions and their attributes"
  value       = module.ecs_service_frontend.autoscaling_scheduled_actions
}

output "backend_service_autoscaling_scheduled_actions" {
  description = "Map of autoscaling scheduled actions and their attributes"
  value       = module.ecs_service_backend.autoscaling_scheduled_actions
}

output "frontend_service_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the frontend service security group"
  value       = module.ecs_service_frontend.security_group_arn
}

output "backend_service_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the backend service security group"
  value       = module.ecs_service_backend.security_group_arn
}

output "frontend_service_security_group_id" {
  description = "ID of the frontend service security group"
  value       = module.ecs_service_frontend.security_group_id
}

output "backend_service_security_group_id" {
  description = "ID of the backend service security group"
  value       = module.ecs_service_backend.security_group_id
}

################################################################################
# Standalone Task Definition (w/o Service)
################################################################################

output "task_definition_run_task_command" {
  description = "awscli command to run the standalone task"
  value       = <<EOT
    aws ecs run-task --cluster ${module.ecs_cluster.name} \
      --task-definition ${module.ecs_task_definition.task_definition_family}:${module.ecs_task_definition.task_definition_revision} \
      --network-configuration "awsvpcConfiguration={subnets=[${join(",", module.vpc.private_subnets)}],securityGroups=[${module.ecs_task_definition.security_group_id}]}" \
      --region ${local.region}
  EOT
}

################################################################################
# Application Load Balancer
################################################################################

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = module.alb.dns_name
}
