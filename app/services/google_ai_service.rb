# frozen_string_literal: true


class GoogleAiService
  def initialize(user:)
    @url = "#{ENV.fetch('GEMINI_AI_URL', nil)}"
    @user = user
  end

  TIMES_TO_ATTEMPT = 3

  def generate_text(prompt: nil, image: nil, video: nil, system_prompt: '')
    raise(CustomException, 'Prompt or image is required') if image.nil? && prompt.nil?

    contents = "#{system_prompt}\n#{prompt}"

    params = {}
    params[:key] = ENV.fetch('GEMINI_AI_API_KEY', nil)

    uri = URI(@url)
    uri.query = URI.encode_www_form(params) if params.present?

    parts = []

    parts << { text: contents }

    parts << {
      inlineData: {
        data: Base64.strict_encode64(image.read),
        mimeType: image.content_type
      }
    } if image.present?

    response = nil

    attempt = 0

    TIMES_TO_ATTEMPT.times do
      begin
        response = Faraday.post(uri.to_s) do |req|

        req.body = {
          contents: [
            {
              parts: parts
            }
          ]
        }.to_json

        req.headers['Content-Type'] = 'application/json'
      rescue => e
        attempt += 1
        sleep(TIMES_TO_ATTEMPT)

        raise(CustomException, response.body) if attempt == TIMES_TO_ATTEMPT
      end
    end


    end

    raise(CustomException, response.body) unless response.success?

    json_response = JSON.parse(response.body, symbolize_names: true)
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
      user_prompt: prompt || 'imagem',
      system_prompt: system_prompt,
      output: formatted_response[:message],
      total_tokens: formatted_response[:metadata][:candidate_tokens],
      model: formatted_response[:metadata][:model]
    )

    formatted_response[:message]
  end

  def generate_json(prompt: nil, image: nil, system_prompt: '')
    raise(CustomException, 'Prompt or image is required') if image.nil? && prompt.nil?

    text = generate_text(prompt: prompt, image: image, system_prompt: system_prompt)

    JSON.parse(text.gsub('```json', '').gsub('```', '').strip)
  rescue JSON::ParserError
    raise(CustomException, 'Resposta inválida')
  end
end
