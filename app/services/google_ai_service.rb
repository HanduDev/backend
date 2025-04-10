# frozen_string_literal: true

require 'gemini-ai'

class GoogleAiService
  def initialize(user:)
    @client = GeminiAi::Client.new(
      api_key: ENV.fetch('GEMINI_AI_API_KEY', nil)
    )
    @current_user = user
  end

  def generate_text(prompt:, system_prompt: '')
    contents = {
      contents: {
        role: 'user',
        parts: {
          text: "#{system_prompt}\n#{prompt}"
        }
      }
    }

    response = @client.generate_content(
      contents,
      model: 'gemini-2.0-flash'
    )

    message = response['candidates']&.first&.[]('content')&.[]('parts')&.first&.[]('text')

    raise(CustomException, 'No response from Google AI') if message.nil?

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
