#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${BUCKET_NAME:-}" ]]; then
  echo "ERROR: BUCKET_NAME is not set."
  echo "Set it explicitly to the project bucket before running cleanup."
  exit 1
fi

if [[ "${CONFIRM_DESTROY:-}" != "$BUCKET_NAME" ]]; then
  echo "ERROR: Destructive confirmation is missing."
  echo "To confirm, set CONFIRM_DESTROY to the exact bucket name."
  exit 1
fi

echo "Target bucket: $BUCKET_NAME"
echo "This script will remove objects from this bucket and delete it."

aws s3 rm "s3://$BUCKET_NAME" --recursive
aws s3api delete-bucket --bucket "$BUCKET_NAME" --region "${AWS_REGION:-us-east-1}"

echo "S3 bucket cleanup completed."
echo "IAM and OIDC resources must be cleaned up separately."
