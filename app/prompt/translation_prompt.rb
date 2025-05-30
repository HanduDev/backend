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
    if from_language.acronym == 'libras'
      return "Você recebeu uma foto em que o usuário está fazendo uma letra em LIBRAS.

Você deve identificar os gestos do usuário e traduzí-los para PT-BR.
Identifique como sendo somente a letra que o usuário está fazendo.

Por favor, forneça-nos apenas A LETRA traduzida para PT-BR, e nada mais."
    end

    "Traduza de #{from_language.name} para #{to_language.name}.

Se você receber uma imagem, traduza todo o texto da imagem para a linguagem de destino.
Lembre-se: Traduza sempre o texto, de #{from_language.name} para #{to_language.name}.

Por favor, forneça-nos apenas o texto traduzido para #{to_language.name}, e nada mais."
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
