# Project Plan: GitHub Actions CI/CD for AWS

## 1. Objective

Build an automated deployment pipeline that validates website files and deploys them to Amazon S3 when changes are pushed to the `main` branch of a GitHub repository.

The project demonstrates continuous integration, continuous deployment, workload identity federation, and least-privilege access to AWS.

The deployment pipeline was tested end to end. After testing, project-specific AWS resources were removed to control costs.

## 2. Architecture

**Deployment flow:** Developer → GitHub repository → GitHub Actions workflow → GitHub OIDC → AWS IAM role → Amazon S3.

- **Source control:** Git and GitHub.
- **Automation:** GitHub Actions.
- **Authentication:** OpenID Connect (OIDC) federation between GitHub Actions and AWS IAM.
- **Authorization:** A dedicated IAM role restricted to the deployment bucket and required actions.
- **Deployment target:** Amazon S3 static website hosting.
- **AWS Region:** `us-east-1`.

### Final operational state

The original deployment architecture was implemented and tested. The S3 bucket and dedicated deployment role have since been deleted.

The workflow remains in the repository, but deployment is opt-in through the GitHub repository variable `DEPLOY_TO_S3`. Unless this variable is set to the string `true`, the deployment job is skipped. Validation continues to run on pushes and pull requests targeting `main`.

Before enabling deployment again, the S3 bucket, its website configuration and policies, and the IAM deployment role must be recreated.

## 3. Workflow

The tested deployment workflow operated as follows:

1. A developer changes the website files.
2. Changes are committed and pushed to `main`.
3. GitHub Actions checks out the repository.
4. The workflow validates the website files.
5. GitHub Actions requests temporary AWS credentials through OIDC.
6. The workflow uploads website files to the designated S3 bucket.
7. The deployment is verified through HTTP responses and workflow logs.

A subsequent website change was committed and pushed. GitHub Actions redeployed it successfully, and the updated content was verified on the hosted website.

Following AWS cleanup, the deployment job was changed to opt-in so future pushes do not attempt to deploy to a deleted bucket.

## 4. Security Requirements and Implementation

- Do not store long-lived AWS access keys in GitHub for deployment.
- Restrict the OIDC trust policy to the intended GitHub repository and branch.
- Use GitHub's immutable OIDC subject claim in the role trust policy.
- Grant only the AWS permissions required for deployment.
- Restrict deployment permissions to the project bucket and required object operations.
- Limit `id-token: write` permission to the deployment job.
- Never publish credentials, state files, or private data in the website directory.
- Restrict public read access to website objects only while public hosting is enabled.

The website used direct S3 static website hosting, which requires publicly readable website objects. The bucket was for demonstration only and must not contain secrets or private data.

## 5. Cost Controls

- Avoid EC2 instances and other unnecessary running resources.
- Keep the website small and use minimal S3 storage.
- Review AWS resources and potential charges before creating them.
- Empty and delete the S3 bucket after testing.
- Remove project-specific IAM resources when no longer needed.
- Verify that cleanup has succeeded independently.
- Preserve shared resources that may be used by other projects.

S3 requests, storage, and public data transfer may incur charges. A zero-spend budget is an alerting or control preference, not a guarantee that every resource is free.

### Cleanup results

- [x] S3 website objects deleted.
- [x] S3 bucket deleted.
- [x] Project-specific IAM inline deployment policy deleted.
- [x] `GitHubActionsS3DeployRole` deleted.
- [x] Bucket absence verified through AWS CLI.
- [x] Deployment role absence verified through AWS CLI.
- [x] Shared GitHub OIDC provider retained.
- [x] `GitHubActionsSSMDeployRole` from the previous project retained.
- [x] Workflow changed to skip deployment unless explicitly enabled.
- [x] Post-cleanup GitHub Actions run passed.

## 6. Testing Results

- [x] Workflow triggered after a push to `main`.
- [x] Valid website files passed local and GitHub Actions validation.
- [x] Validation failed when the stylesheet was temporarily removed.
- [x] Validation passed after the stylesheet was restored.
- [x] GitHub Actions authenticated to AWS through OIDC.
- [x] Website files were deployed to S3.
- [x] Hosted website returned HTTP 200.
- [x] Expected website content was verified.
- [x] A subsequent change was automatically redeployed and verified.
- [x] Node.js 20 deprecation warnings were addressed by updating action versions.
- [x] AWS cleanup was independently verified.
- [x] Post-cleanup workflow run passed with deployment skipped.

## 7. Deliverables

- GitHub Actions workflow for validation and deployment.
- Static website files in HTML and CSS.
- OIDC-based AWS authentication without long-lived deployment access keys.
- Least-privilege IAM trust and permission policies.
- Local verification and cleanup scripts.
- Project documentation covering architecture, deployment, security, testing, cost controls, and cleanup.

## 8. Scope Limitations

This is a learning project, not a production hosting architecture.

Direct S3 website hosting does not provide HTTPS by itself. A production implementation would normally consider CloudFront with Origin Access Control, HTTPS, monitoring, and additional deployment safeguards.

The current AWS resources have been removed to control costs. The deployment workflow can be reactivated only after the required AWS infrastructure is recreated and the repository's `DEPLOY_TO_S3` variable is explicitly set to `true`.
