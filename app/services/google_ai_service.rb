# frozen_string_literal: true


class GoogleAiService
  def initialize(user:)
    @url = "#{ENV.fetch('GEMINI_AI_URL', nil)}"
  end

  def generate_text(prompt:, system_prompt: '')
    contents = "#{system_prompt}\n#{prompt}"

    params = {}
    params[:key] = ENV.fetch('GEMINI_AI_API_KEY', nil)

    uri = URI(@url)
    uri.query = URI.encode_www_form(params) if params.present?

    response = Faraday.post(uri.to_s) do |req|
      req.body = {
        contents: [
          {
            parts: [
              {
                text: contents
              }
            ]
          }
        ]
      }.to_json

      req.headers['Content-Type'] = 'application/json'
    end

    puts "Response Status: #{response.status}"
    puts "Response Headers: #{response.headers}"
    puts "Response Body: #{response.body}"

    raise(CustomException, response.body) unless response.success?

    message = JSON.parse(response.body, symbolize_names: true)[:candidates].first[:content][:parts].first[:text]

    raise(CustomException, 'No response from Google AI') if message.blank?

    formatted_response = {
      message: message.strip,
      metadata: {
        prompt_tokens: response['usageMetadata']['promptTokenCount'],
        candidate_tokens: response['usageMetadata']['candidatesTokenCount'],
        model: response['modelVersion']
      }
    }

    @current_user.ai_responses.create!(
      user_prompt: prompt,
      system_prompt: system_prompt,
      output: formatted_response[:message],
      total_tokens: formatted_response[:metadata][:candidate_tokens],
      model: formatted_response[:metadata][:model]
    )

    formatted_response[:message]
  end
end
