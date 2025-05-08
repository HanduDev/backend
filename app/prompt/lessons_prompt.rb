# frozen_string_literal: true

ATTRIBUTES = {}.freeze

class LessonsPrompt
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  NUMBER_OF_LESSONS = 3

  attr_accessor :trail

  validates :trail, presence: true

  def initialize(attributes = ATTRIBUTES)
    super
  end

  def prompt
    "Você é um professor especialista e fluente em #{trail.lang.name}.
Você deve criar #{NUMBER_OF_LESSONS} aulas para o aluno aprender #{trail.lang.name}.
O aluno está aprendendo através de um aplicativo, portanto, não há professores incluídos no processo.

Os dados da trilha são:
Nome: #{trail.name}
Descrição: #{trail.description}
A trilha é composta por #{NUMBER_OF_LESSONS} aulas, cada uma com um nome e conteúdo.

Sua resposta deve conter as seguintes informações:
1. Nome da aula
2. Conteúdo da aula (em markdown)

Lembre-se que as aulas devem estar em formato cronológico.

Entre as #{NUMBER_OF_LESSONS} aulas, coloque pelo menos 2 aulas práticas (totalizando #{NUMBER_OF_LESSONS + 2} aulas no total), onde o aluno deve praticar o que aprendeu.
As aulas práticas devem conter um exercício prático e uma solução.
As aulas práticas devem ser numeradas como 'Aula Prática 1', 'Aula Prática 2', etc.

O usuário forneceu as seguintes preferências, siga-as rigorosamente:
<preferencias>
  1. Nível de conhecimento do aluno: #{trail.level}
  2. Temas de interesse: #{trail.themes} (fale sobre esses temas)
  3. Tempo total da trilha deve ser: #{trail.time_to_learn}
  4. Tempo para estudar diariamente: #{trail.time_to_study}
  5. O que o usuário quer desenvolver: #{trail.developments}
</preferencias>

Lembre-se que você deve criar #{NUMBER_OF_LESSONS} aulas, então a resposta deve conter #{NUMBER_OF_LESSONS} objetos JSON (array), cada um representando uma aula.
Você está criando o plano para o aluno, e não para o professor, então torne o texto o mais didático possível para todos conseguirem entender.
Os dados devem todos ser respondidos em português (BR).

Os conteúdos devem ser extremamente detalhados e completos, com exemplos práticos.

Para as aulas comuns, retorne a resposta em formato JSON, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da aula\",
  \"markdown_content\": \"Descrição da aula em markdown\"
}

Para as aulas práticas, escolha a que você achar mais adequada para o aluno aprender (considere as preferências do usuário):
1- Tradução
Aqui, a questão deve ser uma frase em português (BR) e a resposta esperada deve ser a tradução dessa frase para o idioma da trilha.
Lembre-se, você deve fornecer a questão e a resposta esperada! Nunca diga que o professor irá fazer algo
Forneça somente a questão e a resposta esperada, não forneça nenhuma outra coisa.
Forneça somente uma frase para a questão e uma frase para a resposta esperada.
Retorne a resposta em formato JSON, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da aula prática\",
  \"activity_type\": \"translation\",
  \"question\": \"Questão da aula prática\",
  \"expected_answer\": \"Resposta esperada para a questão\",
}

2- Múltipla escolha
Aqui, a questão deve ser uma frase em português (BR) e as opções de resposta devem ser 4 opções de resposta em português (BR).
Retorne a resposta em formato JSON, seguindo o seguinte exemplo: (apenas uma opção deve ser correta)
{
  \"name\": \"Nome da aula prática\",
  \"activity_type\": \"multiple_choice\",
  \"question\": \"Questão da aula prática\",
  \"options\": [
    {
      \"content\": \"Opção 1\",
      \"correct\": \"Valor booleano se a opção é correta ou não\"
    },
    {
      \"content\": \"Opção 2\",
      \"correct\": \"Valor booleano se a opção é correta ou não\"
    },
    {
      \"content\": \"Opção 3\",
      \"correct\": \"Valor booleano se a opção é correta ou não\"
    },
    {
      \"content\": \"Opção 4\",
      \"correct\": \"Valor booleano se a opção é correta ou não\"
    }
  ]
}

3- Áudio
Aqui, a questão deve ser uma frase em português (BR) e a resposta esperada deve ser um áudio em português (BR).
Retorne a resposta em formato JSON, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da aula prática\",
  \"activity_type\": \"audio\",
  \"question\": \"Questão da aula prática\",
  \"expected_answer\": \"Resposta esperada para a questão\",
}"
  end
end
