require 'sinatra'
require 'google/cloud/dialogflow/cx'
require 'google/apis/dialogflow_v3'
require 'json'
require 'net/http'
require 'uri'

# Load environment variables
project_id = ENV['PROJECT_ID']
agent_id = ENV['AGENT_ID']
google_application_credential = ENV['GOOGLE_APPLICATION_CREDENTIALS']
chatwoot_api_key = ENV['CHATWOOT_API_KEY']
chatwoot_url = ENV['CHATWOOT_URL']


# Dialogflow API setup
# dialogflow_service = Google::Apis::DialogflowV3::DialogflowService.new
# # Load the service account key
# Google::Cloud::Dialogflow::CX::V3.configure do |config|
#     config.credentials = JSON.parse(File.read('service_account.json'))
# end
# dialogflow_service.authorization = Google::Auth.get_application_default(['https://www.googleapis.com/auth/cloud-platform'])

# Dialogflow API setup
Google::Cloud::Dialogflow::CX.configure do |config|
    config.credentials = Google::Auth::ServiceAccountCredentials.make_creds(
      key_file: google_application_credential,
      scope: ['https://www.googleapis.com/auth/cloud-platform']
    )
end

dialogflow_service = Google::Apis::DialogflowV3::DialogflowService.new

# Chatwoot Webhook route
post '/chatwoot-webhook' do
    request_data = JSON.parse(request.body.read)
    message = request_data['content']
    sender_id = request_data['sender']['id']

    # Send message to Dialogflow
    session_id = "session_#{sender_id}"
    response_text = send_message_to_dialogflow(session_id, message)

    # Send reply back to Chatwoot
    send_reply_to_chatwoot(sender_id, response_text)
end

def send_message_to_dialogflow(session_id, message)
    project_id = ENV['PROJECT_ID']
    agent_id = ENV['AGENT_ID']

    session_path = "projects/#{project_id}/locations/global/agents/#{agent_id}/sessions/#{session_id}"
    request = Google::Apis::DialogflowV3::GoogleCloudDialogflowCxV3DetectIntentRequest.new(
            query_input: {
            text: {
                text: message
            },
            language_code: 'en'
            }
    )

    response = dialogflow_service.detect_session_intent(session_path, request)
    response.query_result.fulfillment_messages.map(&:text).join("\n")
end

def send_reply_to_chatwoot(sender_id, response_message)
    uri = URI.parse("#{chatwoot_url}/api/v1/conversations/#{sender_id}/messages")
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{chatwoot_api_key}"

    request.body = JSON.dump({
        "content" => response_message,
        "message_type" => "outgoing"
    })

    req_options = { use_ssl: uri.scheme == 'https' }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
    end

    response.body
end
