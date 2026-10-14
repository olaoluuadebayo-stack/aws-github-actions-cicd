# GitHub Actions CI/CD for AWS

An automated static website deployment pipeline using GitHub Actions, OpenID Connect (OIDC), AWS IAM, and Amazon S3.

## Project Objective

This project demonstrates how to validate website files and deploy changes to AWS automatically when code is pushed to the `main` branch of a GitHub repository.

It also demonstrates how GitHub Actions can authenticate to AWS using temporary credentials rather than long-lived access keys stored in GitHub.

## Architecture

Developer
    |
    v
GitHub Repository
    |
    v
GitHub Actions Workflow
    |
    +--> Validate website files
    |
    v
GitHub OIDC Identity Token
    |
    v
AWS IAM Deployment Role
    |
    v
Amazon S3 Static Website

## Technologies

- Git and GitHub
- GitHub Actions
- AWS IAM
- OpenID Connect (OIDC)
- Amazon S3
- Bash
- HTML and CSS

## Repository Structure

aws-github-actions-cicd/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── website/
│   ├── index.html
│   └── style.css
├── scripts/
│   ├── verify.sh
│   └── destroy.sh
├── README.md
├── PROJECT_PLAN.md
└── .gitignore

## Security Design

- GitHub Actions authenticates through AWS OIDC federation.
- AWS access keys are not stored as long-lived GitHub secrets.
- The deployment role is restricted to the intended repository and branch.
- AWS permissions are scoped to the deployment bucket and required operations.
- Only public website assets are deployed to the static website.

## Validation and Testing

The local verification script checks that the HTML and CSS files exist and that the HTML contains basic structural elements.

The pipeline will also be tested for successful deployment, HTTP response, expected page content, and failure handling.

## Cost Management

The project avoids EC2 instances and uses a small static website.

Amazon S3 storage, requests, and data transfer may incur charges. After testing, the bucket will be emptied and deleted, and project-specific IAM resources will be removed when no longer required.

Cleanup will be verified independently.

## Limitations

Direct S3 static website hosting does not provide HTTPS by itself. A production design would normally consider CloudFront with Origin Access Control and HTTPS.

This project is intended to demonstrate CI/CD and secure workload authentication, not to serve as a complete production hosting platform.

## Project Status

- [x] Project plan documented
- [x] Static website created
- [x] Local verification script implemented and tested
- [ ] GitHub repository published
- [ ] GitHub Actions workflow configured
- [ ] AWS OIDC and IAM permissions configured
- [ ] S3 deployment tested
- [ ] Cleanup completed and verified