# frozen_string_literal: true

ATTRIBUTES = {}.freeze

class TrailPrompt
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  attr_accessor :language

  validates :language, presence: true

  def initialize(attributes = ATTRIBUTES)
    super
    validate_languages
  end

  def prompt
    "Você é um professor especialista e fluente em #{language.name}.
Você deve criar uma trilha de aprendizado para o aluno.
Sua resposta deve conter as seguintes informações:
1. Nome da trilha
2. Descrição da trilha

Retorne a resposta em formato JSON, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da trilha\",
  \"description\": \"Descrição da trilha\"
}

Os dados devem todos ser respondidos em português (BR)."
  end

  private

  def validate_languages
    language.errors.each { |error| self.errors.add(:language, error.message) } if language.invalid?
  end
end
