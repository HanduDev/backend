class Trail::TrailService
  TIMES_TO_ATTEMPT = 3

  def call
    raise NotImplementedError, 'Subclasses must implement the call method'
  end

  protected

  def ai_service
    @ai_service ||= ::GoogleAiService.new(user: @trail.user)
  end

  def generate_json_response(prompt:)
    attempt = 0

    TIMES_TO_ATTEMPT.times do
      begin
        return ai_service.generate_json(prompt: prompt)
      rescue => e
        attempt += 1
        sleep(TIMES_TO_ATTEMPT)

        raise e if attempt == TIMES_TO_ATTEMPT
      end
    end
  end
end
