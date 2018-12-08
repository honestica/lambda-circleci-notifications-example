require 'json'
require 'slack-ruby-client'
require 'sentry-raven'

Slack.configure do |config|
  config.token = ENV['SLACK_TOKEN']
end

SLACK_USERS = {
  'EtienneDepaulis' => 'etienne'
}.freeze

def handler(event:, context:)
  body = JSON.parse(event['body'])
  payload = body['payload']

  if payload['failed']
    user = payload['user']
    github_login = user['login']
    slack_login = SLACK_USERS.fetch github_login

    reponame = payload['reponame']
    build_url = payload['build_url']
    branch = payload['branch']

    attachments = [
      {
        "fallback": 'Failed build',
        "title": 'Failed build',
        "color": "#d02323",
        "fields": [
          {
            "title": "Repo",
            "value": reponame,
            "short": true
          },
          {
            "title": "Branch",
            "value": branch,
            "short": true
          }
        ]
      },
      {
        "fallback": 'Failed build',
        "actions": [
          {
            "type": "button",
            "text": "Check on CircleCi :circleci:",
            "url": build_url
          }
        ]
      }
    ]

    client = Slack::Web::Client.new
    client.chat_postMessage(channel: "@#{slack_login}", attachments: attachments)

    message = 'Failure detected'
  else
    message = 'No failure detected'
  end

  { statusCode: 200, body: JSON.generate({ message: message }) }
end
