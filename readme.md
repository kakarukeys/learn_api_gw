https://docs.aws.amazon.com/lambda/latest/dg/python-image.html#python-image-instructions

```bash
poetry export -f requirements.txt --output requirements.txt
docker build --platform linux/amd64 -t lambda-image:latest .
```

test it

```bash
docker run --platform linux/amd64 -p 9000:8080 lambda-image:test
curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"payload":"hello world!"}'
```

log in to ECR from docker. these docker publication commands are not used in CI, if AWS was set up properly to trust github action using github oidc, and github action can assume an IAM role to run docker commands against ECR. You just need to use aws-actions to login and push the image.

```bash
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 572512847063.dkr.ecr.ap-southeast-1.amazonaws.com
```

run terraform script to create ECR, and note the repository url in output `572512847063.dkr.ecr.ap-southeast-1.amazonaws.com/my-ecr-repository`.

```bash
docker tag lambda-image:test 572512847063.dkr.ecr.ap-southeast-1.amazonaws.com/my-ecr-repository:1.1.1
docker push 572512847063.dkr.ecr.ap-southeast-1.amazonaws.com/my-ecr-repository:1.1.1
```

run the complete terraform script
