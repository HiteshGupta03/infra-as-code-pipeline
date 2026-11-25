# Deployment Runbook â€“ MbeautyCakes

## 1. Purpose

This runbook explains how to deploy, monitor, troubleshoot and recover the MbeautyCakes application on AWS ECS Fargate.

## 2. Environment Status

| Environment | Status | Deployment method |
|---|---|---|
| Dev | Provisioned and tested | Manual GitHub Actions dispatch |
| Staging | Provisioned and tested | Pull Request to main or manual dispatch |
| Production | Not provisioned | Main branch push with GitHub approval protection |

## 3. Prerequisites

- AWS CLI configured with an authorized AWS account.
- Terraform 1.10 or newer.
- Docker Desktop and Git.
- Access to the GitHub repository.
- GitHub Actions OIDC roles and environment configuration.
- AWS region: ap-south-1.

## 4. Infrastructure Setup

Navigate to the infrastructure directory:

```powershell
cd infrastructure
terraform init
terraform workspace list
```

Select the required environment workspace before planning. For example, development:

```powershell
terraform workspace select dev
terraform plan -var-file=environments/dev.tfvars
```

Review the Terraform plan carefully before applying changes. Apply only when the resource changes and estimated costs are understood:

```powershell
terraform apply -var-file=environments/dev.tfvars
```

For staging, select the staging workspace and use its variable file. Do not apply production configuration until production prerequisites, account restrictions and costs have been reviewed.

## 5. Application Deployment

### Development

1. Open the GitHub repository and select Actions.
2. Select the Deploy to AWS ECS workflow.
3. Select the feature/terraform-bootstrap branch.
4. Run the workflow and set confirm_deploy to yes.
5. Monitor the build, ECR push, database migration and ECS deployment steps.

### Staging

1. Create or update a non-draft Pull Request targeting main from the same repository.
2. The staging workflow runs CI quality checks.
3. After successful checks, it builds and pushes staging images to ECR.
4. The workflow captures previous task definitions and runs database migration.
5. It deploys backend and frontend services to ECS.
6. It verifies the homepage and cake API.

### Production

Production infrastructure is not provisioned yet. The deployment job requires repository variable `ENABLE_PRODUCTION_DEPLOYMENT` to equal `true`. With this variable unset, main pushes will not start the production deployment job. The GitHub production Environment also requires reviewer approval.
Before enabling deployment, provision and verify the production IAM role, ECS cluster, services, ECR repositories and application URL. Configure `PRODUCTION_APPLICATION_URL` in the production GitHub Environment. Only after these prerequisites are verified, set the repository variable `ENABLE_PRODUCTION_DEPLOYMENT` to `true`. For a manual deployment, dispatch from `main` with `confirm_deploy` set to `yes`.

## 6. Deployment Verification

Check ECS services:

```powershell
aws ecs describe-services --cluster infra-as-code-pipeline-dev-cluster --services infra-as-code-pipeline-dev-frontend infra-as-code-pipeline-dev-backend --region ap-south-1 --query "services[].{Service:serviceName,Status:status,Desired:desiredCount,Running:runningCount}" --output table
```

Test the application using the environment ALB URL:

```powershell
curl.exe -f http://<ALB-DNS>/
curl.exe -f http://<ALB-DNS>/api/cakes
```

The homepage should return HTTP success. The cake API should return the six seeded cake records.

## 7. Monitoring and Logs

View development backend logs:

```powershell
aws logs tail /ecs/infra-as-code-pipeline-dev/backend --since 30m --follow --region ap-south-1
```

View staging backend logs:

```powershell
aws logs tail /ecs/infra-as-code-pipeline-staging/backend --since 30m --follow --region ap-south-1
```

Use the AWS ECS console to inspect service events, task status, stopped reasons and deployment health. Use CloudWatch Logs to investigate application and migration errors.

## 8. Database Migration

The deployment workflow runs backend/migrate.js as a standalone ECS task before deploying the new backend. The workflow checks that the task reaches STOPPED and the backend container exits with code 0. If migration fails, application deployment stops.

The migration uses CREATE TABLE IF NOT EXISTS and INSERT IGNORE statements. These make the initial schema and seed operation safe to repeat. Do not execute database/schema.sql as a deployment migration because it contains destructive DROP statements.

## 9. Rollback and Recovery

The GitHub Actions deployment workflows capture the previous frontend and backend task definition ARNs before deployment. If a post-deployment step fails after backend deployment starts, the workflow attempts to restore both previous ECS task definitions and waits for service stability. ECS deployment circuit breakers are also enabled with rollback.

For manual recovery, first inspect the failed GitHub Actions run and identify the exact previous task definition ARN from its captured output. Never guess a revision.

Example backend rollback command:

```powershell
aws ecs update-service --cluster infra-as-code-pipeline-dev-cluster --service infra-as-code-pipeline-dev-backend --task-definition <PREVIOUS_BACKEND_TASK_DEFINITION_ARN> --region ap-south-1
aws ecs wait services-stable --cluster infra-as-code-pipeline-dev-cluster --services infra-as-code-pipeline-dev-backend --region ap-south-1
```

Repeat for the frontend service using its previous task definition ARN if necessary. Verify both services and the application after recovery.

Rollback recovery time has not yet been measured against the project 60-second target.

## 10. Troubleshooting

| Issue | Recommended action |
|---|---|
| ECS task fails to start | Inspect stopped reason and container logs in ECS and CloudWatch. |
| Database connection fails | Check DB_HOST, database security group, RDS status and secret permissions. |
| Migration fails | Inspect migration task exit code and backend CloudWatch logs. |
| ALB target unhealthy | Check ECS task health, target group health checks and security groups. |
| GitHub OIDC authentication fails | Verify IAM role trust policy, GitHub environment name and OIDC subject. |
| Application API fails | Inspect backend logs and test the /health endpoint. |

## 11. Security and Operational Notes

- Store JWT secrets in AWS Systems Manager Parameter Store.
- Use the RDS-managed database secret through AWS Secrets Manager.
- Use GitHub OIDC rather than long-lived AWS access keys in GitHub Actions.
- Never commit .env files, passwords, access keys or Terraform state files.
- Review Terraform plans before applying infrastructure changes.
- Check AWS costs before leaving development or staging resources running.
- Keep production deployment protected by GitHub Environment approval.

## 12. Evidence

Successful deployment evidence is stored in docs/evidence/:

- dev-migration-evidence.txt
- staging-deployment-evidence.txt
