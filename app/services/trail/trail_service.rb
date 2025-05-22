class Trail::TrailService
  def call
    raise NotImplementedError, 'Subclasses must implement the call method'
  end

  protected

  def ai_service
    @ai_service ||= ::GoogleAiService.new(user: @trail.user)
  end

  def generate_json_response(prompt:)
    ai_response = ai_service.generate_text(prompt: prompt)

    ai_response = ai_response.gsub('```json', '').gsub('```', '').strip

    JSON.parse(ai_response)
  end
end
