# frozen_string_literal: true

ATTRIBUTES = {}.freeze

class LessonsPrompt
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  attr_accessor :trail

  validates :trail, presence: true

  def initialize(attributes = ATTRIBUTES)
    super
  end

  def prompt
    "Você é um professor especialista e fluente em #{trail.lang.name}.
Você deve criar 10 aulas para o aluno aprender #{trail.lang.name}.

Os dados da trilha são:
Nome: #{trail.name}
Descrição: #{trail.description}
A trilha é composta por 10 aulas, cada uma com um nome e conteúdo.

Sua resposta deve conter as seguintes informações:
1. Nome da aula
2. Conteúdo da aula (em markdown)

Lembre-se que as aulas devem estar em formato cronológico.

Entre as 10 aulas, coloque pelo menos 2 aulas práticas, onde o aluno deve praticar o que aprendeu.
As aulas práticas devem conter um exercício prático e uma solução.
As aulas práticas devem ser numeradas como 'Aula Prática 1', 'Aula Prática 2', etc.

Retorne a resposta em formato JSON, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da aula\",
  \"markdown_content\": \"Descrição da aula em markdown\"
}

Lembre-se que você deve criar 10 aulas, então a resposta deve conter 10 objetos JSON (array), cada um representando uma aula.

Os dados devem todos ser respondidos em português (BR)."
  end
end
