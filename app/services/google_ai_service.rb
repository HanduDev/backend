# frozen_string_literal: true


class GoogleAiService
  def initialize(user:)
    @url = "#{ENV.fetch('GEMINI_AI_URL', nil)}"
    @user = user
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

    raise(CustomException, response.body) unless response.success?

    json_response = JSON.parse(response.body, symbolize_names: true)
    puts "Response Body: #{json_response[:candidates].first[:content][:parts].first[:text]}"
    message = json_response[:candidates].first[:content][:parts].first[:text]

    raise(CustomException, 'No response from Google AI') if message.blank?

    formatted_response = {
      message: message.strip,
      metadata: {
        prompt_tokens: json_response[:usageMetadata][:promptTokenCount],
        candidate_tokens: json_response[:usageMetadata][:candidatesTokenCount],
        model: json_response[:modelVersion]
      }
    }

    @user.ai_responses.create!(
      user_prompt: prompt,
      system_prompt: system_prompt,
      output: formatted_response[:message],
      total_tokens: formatted_response[:metadata][:candidate_tokens],
      model: formatted_response[:metadata][:model]
    )

    formatted_response[:message]
  end
end
