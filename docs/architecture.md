# AWS Architecture – MbeautyCakes

## 1. Overview

MbeautyCakes is a containerized web application deployed on AWS using Terraform and Amazon ECS Fargate.

The architecture uses separate development and staging environments. Production deployment configuration and approval protection are prepared, but production infrastructure has not yet been provisioned.

## 2. Architecture Diagram

```mermaid
flowchart TB
    U["Users / Internet"]

    subgraph VPC["AWS VPC"]
        subgraph PUBLIC["Public Subnets"]
            ALB["Application Load Balancer<br/>HTTP Port 80"]
            FE["ECS Fargate Frontend<br/>React + Nginx"]
            BE["ECS Fargate Backend<br/>Node.js API"]
        end

        subgraph PRIVATE["Private Subnets"]
            DB[("Amazon RDS<br/>MySQL Database")]
        end
    end

    U --> ALB
    ALB -->|"Default route /"| FE
    ALB -->|"/api/*"| BE
    BE -->|"MySQL Port 3306"| DB

    ECR["Amazon ECR<br/>Frontend and Backend Images"]
    ECR --> FE
    ECR --> BE

    CW["Amazon CloudWatch<br/>Container Logs"]
    FE --> CW
    BE --> CW

    SSM["AWS Systems Manager<br/>JWT Secret"]
    SM["AWS Secrets Manager<br/>Database Password"]
    SSM --> BE
    SM --> BE
```
