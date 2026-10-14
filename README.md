# GitHub Actions CI/CD for AWS

An automated static website deployment pipeline using GitHub Actions, OpenID Connect (OIDC), AWS IAM, and Amazon S3.

## Project Objective

This project demonstrates how to validate website files and automatically deploy website changes to AWS when code is pushed to the `main` branch of a GitHub repository.

It also demonstrates how GitHub Actions can authenticate to AWS using temporary credentials instead of long-lived AWS access keys stored in GitHub.

## Architecture

```text
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
```

## Technologies

- Git and GitHub
- GitHub Actions
- AWS IAM
- OpenID Connect (OIDC)
- Amazon S3
- Bash
- HTML and CSS

## Repository Structure

```text
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
├── iam/
│   ├── trust-policy.json
│   ├── s3-deploy-policy.json
│   └── website-read-policy.json
├── README.md
├── PROJECT_PLAN.md
└── .gitignore
```

## Security Design

- GitHub Actions authenticates to AWS through OIDC federation.
- Long-lived AWS access keys are not stored in GitHub repository secrets for deployment.
- The IAM trust policy restricts role assumption to the intended GitHub repository and the `main` branch using GitHub's immutable OIDC subject claim.
- The deployment role has narrowly scoped S3 permissions for listing the deployment bucket and uploading or deleting its objects.
- Public read access is restricted to website objects in the dedicated bucket.
- The workflow grants `id-token: write` only to the deployment job that needs to request an OIDC token.
- The bucket must contain public website assets only. Secrets and private data must never be uploaded.

## Validation and Testing

The local verification script checks that the HTML and CSS files exist, verifies basic HTML structure, and confirms the stylesheet reference.

The following tests were completed:

- [x] Local website validation passed.
- [x] Validation correctly failed when the stylesheet was temporarily removed.
- [x] Validation passed after the stylesheet was restored.
- [x] GitHub Actions successfully executed the validation job.
- [x] GitHub Actions authenticated to AWS through OIDC.
- [x] The deployment job uploaded website files to S3 successfully.
- [x] The hosted website returned HTTP 200.
- [x] The expected website content was verified through an HTTP request.
- [x] A subsequent website change was committed and pushed to `main`.
- [x] GitHub Actions automatically redeployed the change.
- [x] The updated content was verified on the live S3 website.
- [x] GitHub Actions action versions were updated to remove the Node.js 20 deprecation warnings.

## Cost Management

This project avoids EC2 instances and uses Amazon S3 for static website hosting.

S3 storage, requests, and data transfer may incur charges. The project is intended to be short-lived for learning and portfolio demonstration.

After testing, the S3 bucket and its objects will be deleted, along with the project-specific IAM deployment role and inline policies. The shared GitHub OIDC identity provider will be retained because other projects may depend on it.

Cleanup must be verified independently through AWS CLI checks.

## Limitations

- Direct S3 static website hosting uses an HTTP website endpoint and does not provide HTTPS by itself.
- The website is publicly readable while hosting is enabled.
- The workflow depends on the target bucket and IAM role existing. After AWS resources are removed, the deployment infrastructure must be recreated before deployment can run again.
- A production architecture would normally use CloudFront with Origin Access Control and HTTPS, with the S3 bucket kept private.

This project demonstrates CI/CD automation and federated AWS authentication. It is not intended to be a complete production hosting platform.

## Project Status

- [x] Project plan documented
- [x] Static website created
- [x] Local verification script implemented and tested
- [x] GitHub repository published
- [x] GitHub Actions workflow configured
- [x] AWS OIDC federation and IAM permissions configured
- [x] S3 static website hosting configured
- [x] Initial automated deployment tested
- [x] Automated redeployment tested
- [ ] AWS cleanup completed and independently verified
