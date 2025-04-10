# frozen_string_literal: true

class Api::V1::TranslateTextController < ApplicationController
  def create
    ai = GoogleAiService.new(user: @current_user)

    system_prompt = TranslationPrompt.new(
      from_language: Language.new(acronym: translate_params[:from_language]),
      to_language: Language.new(acronym: translate_params[:to_language])
    )

    raise(CustomException, system_prompt.errors.full_messages.to_sentence) unless system_prompt.errors.empty?

    text = translate_params[:text]
    @message_response = ai.generate_text(prompt: text, system_prompt: system_prompt.prompt)
  end

  private

  def translate_params
    params.require(:translate).permit(
      :text,
      :from_language,
      :to_language
    )
  end
end
