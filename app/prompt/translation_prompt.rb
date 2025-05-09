# frozen_string_literal: true

ATTRIBUTES = {}.freeze

class TranslationPrompt
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  attr_accessor :from_language, :to_language

  validates :from_language, presence: true
  validates :to_language, presence: true

  def initialize(attributes = ATTRIBUTES)
    super
    validate_languages
  end

  def prompt
    "Traduza de #{from_language.name} para #{to_language.name}.
Por favor, forneça-nos apenas o texto traduzido, e nada mais."
  end

  private

  def validate_languages
    from_language.errors.each { |error| self.errors.add(:from_language, error.message) } if from_language.invalid?
    to_language.errors.each { |error| self.errors.add(:to_language, error.message) } if to_language.invalid?

    return unless from_language.acronym == to_language.acronym

    same_language_error = I18n.t('activemodel.errors.translation_prompt.same_language')
    to_language_error = I18n.t('activemodel.attributes.translation_prompt.to_language')

    self.errors.add(:from_language, "#{same_language_error} #{to_language_error}")
  end
end
