# frozen_string_literal: true

class Api::V1::TranslateTextController < ApplicationController
  def create
    ai = GoogleAiService.new(user: @current_user)

    raise(CustomException, prompt.errors.full_messages.to_sentence) unless prompt.errors.empty?

    print "Prompt: #{prompt.prompt}"

    @message_response = ai.generate_text(
      prompt: text,
      image: image,
      system_prompt: prompt.prompt
    )
  end

  private

  def image
    image_param = translate_params[:image]

    return nil if image_param.blank? || translate_params[:text].present?

    image_param
  end

  def text
    text_param = translate_params[:text]

    return nil if text_param.blank? || translate_params[:image].present?

    text_param
  end

  def translate_params
    params.require(:translate).permit(
      :text,
      :from_language,
      :to_language,
      :image
    )
  end

  def prompt
    TranslationPrompt.new(
      from_language: Language.new(acronym: translate_params[:from_language]),
      to_language: Language.new(acronym: translate_params[:to_language])
    )
  end
end
