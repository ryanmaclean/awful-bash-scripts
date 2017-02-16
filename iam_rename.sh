#!/bin/env bash

## Rename IAM user(s) in AWS for a specific profile

export OLDIAM = test
export NEWIAM = testnew
export PROFILE = yourawsaccount

aws iam update-user --user-name $OLDIAM --new-user-name $NEWIAM --profile $PROFILE
