#!/bin/env bash

## Rename IAM user(s) in AWS for a specific profile

OLDIAM=test
NEWIAM=testnew
PROFILE=yourawsaccount

aws iam update-user --user-name $OLDIAM --new-user-name $NEWIAM --profile $PROFILE
