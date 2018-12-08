# CircleCI -> Slack private notification

This ruby lambda notifies privately the author of a failed commit on CircleCi.

## Configuration

### Dependencies

- Node.js (& npm) : `brew install node`
- Serverless : `npm install serverless -g`
- AWS CLI : `brew install awscli`
- Ruby

### Installation

```bash
git clone git@github.com:honestica/lambda-circleci-notifications-example.git
cd lambda-circleci-notifications-example
bundle install
```

### AWS configuration

```bash
sls config credentials --provider aws --key AWS_KEY --secret AWS_SECRET
```

#### SSM environment variables

```bash
aws --region eu-west-1 ssm put-parameter --name circleci-notifications-slack-token --value top-secret-value --type String
```

```bash
aws --region eu-west-1 ssm put-parameter --cli-input-json '{
  "Name": "circleci-notifications-sentry-dsn",
  "Value": "https://secret.url",
  "Type": "String"
}'
```

## Usage

### Specs

```bash
bundle exec rspec spec
```

### Deploys

You will need to run `bundle install --deployment` before deploying from your laptop.

### Dev
- *Initial deploy :* `sls deploy -s dev`
- *Function only deploy :* `sls deploy function -f circleciNotifications -s dev`

### Prod
- *Initial deploy :* `sls deploy -s prod`
- *Function only deploy :* `sls deploy function -f circleciNotifications -s prod`
