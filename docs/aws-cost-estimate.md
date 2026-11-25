# AWS Monthly Cost Estimate – Staging

## 1. Purpose

This document estimates the monthly cost of running the staging environment continuously in AWS Mumbai (ap-south-1). Values are approximate USD planning figures, not a quotation or guaranteed bill.

## 2. Workload Assumptions

- Region: ap-south-1 (Mumbai).
- Billing period: 730 hours per month.
- ECS launch type: AWS Fargate, Linux x86.
- Four minimum running ECS tasks: two frontend and two backend.
- Each task: 0.25 vCPU and 0.5 GB memory.
- ECS autoscaling: minimum 2 and maximum 6 tasks per service.
- One internet-facing Application Load Balancer across two Availability Zones.
- Four ECS task public IPv4 addresses and two ALB public IPv4 addresses.
- One RDS MySQL Single-AZ instance: db.t3.micro.
- RDS storage: 20 GB gp3, encrypted.
- CloudWatch log groups with 14-day retention.
- No NAT Gateway is provisioned by the current networking module.

## 3. Estimated Monthly Cost

| AWS Service | Calculation / Assumption | Estimated USD per month |
|---|---|---:|
| ECS Fargate | 4 tasks × 730 hours; 0.25 vCPU and 0.5 GB each | $41.45 |
| Application Load Balancer | 730 hours × $0.0239 plus 1 average LCU × 730 hours × $0.008 | $23.29 |
| Public IPv4 addresses | 6 addresses × 730 hours × $0.005 | $21.90 |
| RDS MySQL instance | db.t3.micro × 730 hours × $0.025 | $18.25 |
| RDS gp3 storage | 20 GB × $0.131 per GB-month | $2.62 |
| Secrets Manager | One managed database secret, approximate monthly charge | $0.40 |
| CloudWatch | Small log ingestion and storage allowance | $1–3 |
| **Estimated baseline** | **Before variable usage and taxes** | **Approximately $110** |

## 4. Calculation Details

### Fargate

Mumbai Linux x86 planning rates used: $0.04656 per vCPU-hour and $0.00511 per GB-hour.

Per task per hour: (0.25 × $0.04656) + (0.5 × $0.00511) = approximately $0.014195.
Four tasks × 730 hours × $0.014195 = approximately $41.45 per month.

### Application Load Balancer

The estimate assumes one ALB running for 730 hours and an average of one LCU. Actual LCU usage depends on new connections, active connections, processed bytes and rule evaluations.

### Public IPv4

The estimate includes four ECS task addresses because the ECS services assign public IP addresses, plus two public addresses for the internet-facing load balancer.

### RDS

The estimate uses the configured Single-AZ db.t3.micro instance and 20 GB gp3 storage. Additional backup storage, database CPU credit charges, data transfer or changes in storage size may increase the bill.

## 5. Cost Factors Not Fully Included

The actual AWS invoice may be higher due to internet data transfer, higher ALB LCU usage, increased CloudWatch log volume, Container Insights metrics, ECR image storage, additional database backup storage, KMS requests, taxes or changes in AWS prices.

The estimate assumes the minimum of two tasks per service. If both services scale to six tasks each, Fargate runtime and public IPv4 charges will increase.

Development resources are not included in this staging-only estimate. Running development and staging at the same time results in additional charges.

## 6. Cost Optimization

- Keep only the environments needed for active testing.
- After collecting submission evidence, destroy unused staging resources if they are no longer required.
- Review ECS desired counts and autoscaling limits.
- Remove unused ECR image tags and old images according to a retention policy.
- Monitor CloudWatch log ingestion and retention.
- Use AWS Cost Explorer and AWS Budgets to monitor actual usage.
- Review the Terraform plan before creating or deleting resources.

## 7. Pricing References

- AWS Fargate pricing: https://aws.amazon.com/fargate/pricing/
- AWS Elastic Load Balancing pricing: https://aws.amazon.com/elasticloadbalancing/pricing/
- AWS VPC and public IPv4 pricing: https://aws.amazon.com/vpc/pricing/
- Amazon RDS for MySQL pricing: https://aws.amazon.com/rds/mysql/pricing/
- Amazon CloudWatch pricing: https://aws.amazon.com/cloudwatch/pricing/
- AWS Secrets Manager pricing: https://aws.amazon.com/secrets-manager/pricing/
- Mumbai Fargate rate reference: https://neatjson.com/aws-fargate-cost-calculator
- Mumbai regional price-list references: https://clowdey.ai/aws-bill/elastic-load-balancing/loadbalancerusage/ and https://clowdey.ai/aws-bill/rds/rds-gp3-storage/

## 8. Disclaimer

This is an approximate educational estimate using the stated workload and regional rates checked on 25 November 2026. It is not an AWS Pricing Calculator quote. Actual billing depends on resource uptime, traffic, usage, account credits, taxes and current AWS prices.
