# Dialogflow CX (v3) to Chatwoot Integration

This repository contains a Ruby-based solution to integrate **Dialogflow CX (v3)** with **Chatwoot** using webhooks. The integration allows you to forward incoming messages from Chatwoot to Dialogflow CX and send back responses from Dialogflow to the customer, all wrapped within a Docker container for easy deployment.

## Features
- Receive messages from Chatwoot and forward them to Dialogflow CX (v3).
- Handle Dialogflow CX (v3) responses and send them back to Chatwoot as replies.
- Dockerized for easy deployment on any platform.
  
## Prerequisites
- **Ruby 3.1 or higher**
- **Docker** installed on your local machine
- A **Dialogflow CX (v3)** agent with API access enabled
- **Chatwoot** instance with an API key and webhook configured

## Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/joaopaiva/dialogflow-cx-chatwoot.git
cd dialogflow-cx-chatwoot
```

### 2. Install dependencies
Ensure you have Ruby installed, and then run:

```bash
bundle install
```

### 3. Configure Dialogflow CX (v3)
1. In your Google Cloud Console, create a Dialogflow CX (v3) agent.
2. Note down the **Project ID** and **Agent ID**.

### 4. Configure Chatwoot Webhook
1. Go to your **Chatwoot** instance settings and add a new webhook to the desired inbox.
2. Use the following format for the webhook URL (replace `your-server-ip` with your actual server IP/domain):
   ```
   http://your-server-ip:4567/chatwoot-webhook
   ```

### 5. Environment Variables
Instead of hardcoding sensitive values, you can pass them as environment variables.

Set the following environment variables in the `.env` file or when running Docker:
- `PROJECT_ID`: Your Google Cloud Project ID for Dialogflow CX (v3).
- `AGENT_ID`: The Agent ID for your Dialogflow CX (v3) agent.
- `CHATWOOT_API_KEY`: Your Chatwoot API key to send responses back.
- `CHATWOOT_URL`: The URL of your Chatwoot instance (e.g., https://chatwoot.example.com).

### 6. Running Locally

#### Running with Ruby
You can run the Ruby app locally for testing:
```bash
ruby app.rb
```

The app will start a server on `http://localhost:4567`. Make sure to point the Chatwoot webhook to your local server if testing locally.

### 7. Docker Setup

#### Build the Docker Image
To package the app into a Docker image, run:
```bash
docker build -t dialogflow-cx-chatwoot-bot .
```

#### Run the Docker Container
After building the image, you can run the container with the following command:

```bash
docker run -d -p 4567:4567 \
  -e PROJECT_ID="your-project-id" \
  -e AGENT_ID="your-agent-id" \
  -e CHATWOOT_API_KEY="your-chatwoot-api-key" \
  -e CHATWOOT_URL="https://your-chatwoot-instance-url" \
  dialogflow-cx-chatwoot-bot
```

This will run the container in the background and expose it on port 4567.

### 8. Deploying to Cloud

You can deploy the Docker container to cloud platforms like:
- **Google Cloud Run**
- **Heroku**
- **AWS Elastic Beanstalk**
- **DigitalOcean**

Follow the specific cloud provider's instructions to deploy a Docker container.

## Project Structure

```
dialogflow-cx-chatwoot/
├── app.rb             # Main application logic (webhook handling, Dialogflow, Chatwoot interaction)
├── Gemfile            # Ruby dependencies
├── Dockerfile         # Dockerfile for building the container
└── README.md          # Project documentation
```

## Usage

- Once the webhook is set up, any message received in the specified Chatwoot inbox will trigger a request to the webhook.
- The message will be sent to Dialogflow CX (v3), and the bot’s response will be automatically sent back to the customer via Chatwoot.

## Environment Variables

- **`PROJECT_ID`**: Your Google Cloud Project ID for Dialogflow CX (v3).
- **`AGENT_ID`**: The Dialogflow CX (v3) Agent ID.
- **`CHATWOOT_API_KEY`**: The API key for Chatwoot to send messages back to customers.
- **`CHATWOOT_URL`**: The URL of your Chatwoot instance (e.g., https://chatwoot.example.com).

## Troubleshooting

1. **Message not forwarded**: Ensure the webhook URL is correctly set up in Chatwoot and the server is reachable.
2. **Dialogflow response issues**: Double-check your Dialogflow API credentials and ensure that the API is enabled.
3. **Error 500**: Review the logs to debug the application by running the container without the `-d` option to see the logs.

```bash
docker run -p 4567:4567 \
  -e PROJECT_ID="your-project-id" \
  -e AGENT_ID="your-agent-id" \
  -e CHATWOOT_API_KEY="your-chatwoot-api-key" \
  dialogflow-cx-chatwoot-bot
```

## Contributing

1. Fork this repository.
2. Create a new branch for your feature or bugfix.
3. Send a pull request.

## License
This project is licensed under the MIT License. See the `LICENSE` file for more details.