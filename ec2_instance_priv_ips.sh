aws ec2 describe-instances --region us-east-1 --filter Name=tag:Name,Values=YOURCOOLINSTANCENAME --query "Reservations[].Instances[].PrivateIpAddress" --output text | tr " " "\n"
