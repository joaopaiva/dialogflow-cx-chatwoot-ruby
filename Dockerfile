# Environment variables
ENV PROJECT_ID="your-project-id"
ENV AGENT_ID="your-agent-id"
ENV GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service_account.json"
ENV CHATWOOT_API_KEY="your-chatwoot-api-key"
ENV CHATWOOT_URL="https://your-chatwoot-instance"

# Use the official Ruby base image
FROM ruby:3.1

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install the required gems
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Expose port 4567 (the default port for Sinatra)
EXPOSE 4567

# Run the application using Sinatra's built-in server
CMD ["ruby", "app.rb"]
