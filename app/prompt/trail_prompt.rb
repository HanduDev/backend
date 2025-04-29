# frozen_string_literal: true

ATTRIBUTES = {}.freeze

class TrailPrompt
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  attr_accessor :trail

  validates :trail, presence: true

  def initialize(attributes = ATTRIBUTES)
    super
    validate_languages
  end

  def prompt
    "Você é um professor especialista e fluente em #{trail.lang.name}.
Você deve criar uma trilha de aprendizado para o aluno.
Sua resposta deve conter as seguintes informações:
1. Nome da trilha (curto e objetivo)
2. Descrição da trilha

O usuário forneceu as seguintes preferências, siga-as rigorosamente:
<preferencias>
  1. Nível de conhecimento do aluno: #{trail.level}
  2. Temas de interesse: #{trail.themes} (fale sobre esses temas)
  3. Tempo total da trilha deve ser: #{trail.time_to_learn}
  4. Tempo para estudar diariamente: #{trail.time_to_study}
  5. O que o usuário quer desenvolver: #{trail.developments}
</preferencias>

Os dados devem todos ser respondidos em português (BR).

Retorne a resposta em formato JSON, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da trilha\",
  \"description\": \"Descrição da trilha\"
}"
  end

  private

  def validate_languages
    trail.lang.errors.each { |error| self.errors.add(:language, error.message) } if trail.lang.invalid?
  end
end
