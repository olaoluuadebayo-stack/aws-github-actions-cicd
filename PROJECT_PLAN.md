# Project Plan: GitHub Actions CI/CD for AWS

## 1. Objective

Build an automated deployment pipeline that validates website files and deploys them to Amazon S3 when changes are pushed to the `main` branch of a GitHub repository.

The project demonstrates continuous integration, continuous deployment, workload identity federation, and least-privilege access to AWS.

## 2. Architecture

**Flow:** Developer → GitHub repository → GitHub Actions workflow → GitHub OIDC → AWS IAM role → Amazon S3.

- **Source control:** Git and GitHub.
- **Automation:** GitHub Actions.
- **Authentication:** OpenID Connect (OIDC) federation between GitHub Actions and AWS IAM.
- **Authorization:** A dedicated IAM role restricted to the deployment bucket and required actions.
- **Deployment target:** Amazon S3 static website hosting.
- **AWS Region:** `us-east-1`.

## 3. Workflow

1. A developer changes the website files.
2. The changes are committed and pushed to `main`.
3. GitHub Actions checks out the repository.
4. The workflow validates the website files.
5. GitHub Actions requests temporary AWS credentials through OIDC.
6. The workflow uploads the website files to the designated S3 bucket.
7. The deployment is verified through HTTP and workflow logs.

## 4. Security Requirements

- Do not store long-lived AWS access keys in GitHub.
- Restrict the OIDC trust policy to the intended GitHub repository and branch.
- Grant only the AWS permissions required for deployment.
- Restrict deployment permissions to the project bucket.
- Never publish credentials, state files, or private data in the website directory.

## 5. Cost Controls

- Avoid EC2 instances and other unnecessary running resources.
- Keep the website small and use minimal S3 storage.
- Review the AWS resources and potential charges before creating them.
- Empty and delete the S3 bucket after testing.
- Remove project-specific IAM resources when no longer needed.
- Verify that cleanup has succeeded.

S3 requests, storage, and public data transfer may incur charges. A zero-spend budget is an alerting/control preference, not a guarantee that every resource is free.

## 6. Testing

- Confirm that the workflow starts after a push to `main`.
- Verify that invalid website files fail validation.
- Confirm that valid files are deployed.
- Verify the published website response and content.
- Inspect workflow logs and AWS permissions.
- Confirm that cleanup removes the project resources.

## 7. Deliverables

- A working GitHub Actions workflow.
- A static website deployed to S3.
- OIDC-based AWS authentication without long-lived access keys.
- A least-privilege IAM role.
- Verification and cleanup scripts.
- GitHub documentation describing the architecture, deployment, security, testing, and cleanup.

## 8. Scope Limitations

This is a learning project, not a production hosting architecture. Direct S3 website hosting does not provide HTTPS by itself. A production implementation would normally consider CloudFront with Origin Access Control, HTTPS, monitoring, and additional deployment safeguards.
