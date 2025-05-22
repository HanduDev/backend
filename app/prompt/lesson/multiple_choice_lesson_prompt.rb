# frozen_string_literal: true

class Lesson::MultipleChoiceLessonPrompt < Lesson::LessonPrompt
  def prompt
    "#{initialize_prompt}

Sua resposta deve conter as seguintes informações:
1. Nome da aula (curto e objetivo), siga o padrão de Aula 1: Nome da aula (curto e objetivo, no máximo 3 palavras)
2. Questão da aula (frase em português (BR))
3. Opções de resposta (4 opções de resposta)
4. Resumo da aula. (Um texto bem curto sobre o conteúdo da aula, no máximo 100 caracteres)

Lembre-se, a questão e as opções de resposta devem ter relação com o aprendizado em #{trail.lang.name}

Retorne a resposta SOMENTE em formato JSON, sem comentários, seguindo o seguinte exemplo: (apenas uma opção deve ser correta)
{
  \"name\": \"Nome da aula prática\",
  \"question\": \"Questão da aula prática\",
  \"summary\": \"Resumo da aula\",
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
}"
  end
end
