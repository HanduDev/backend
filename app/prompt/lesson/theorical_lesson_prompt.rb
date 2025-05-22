# frozen_string_literal: true

class Lesson::TheoricalLessonPrompt < Lesson::LessonPrompt
  def prompt
    "#{initialize_prompt}

Sua resposta deve conter as seguintes informações:
1. Nome da aula (curto e objetivo), siga o padrão de Aula 1: Nome da aula (curto e objetivo, no máximo 8 palavras)
2. Conteúdo da aula (em markdown)
3. Resumo da aula. (Um texto bem curto sobre o conteúdo da aula, no máximo 100 caracteres)

Você está criando o plano para o aluno, e não para o professor, então torne o texto o mais didático possível para que ele consiga entender.
Os dados devem todos ser respondidos em português (BR).

Não diga que o professor irá fazer algo, ou que você irá fazer algo, ou que o aplicativo irá fazer algo, você deve informar todas as informações necessárias para o aluno.

Retorne a resposta SOMENTE em formato JSON, sem comentários, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da aula\",
  \"markdown_content\": \"Descrição da aula em markdown\",
  \"summary\": \"Resumo da aula\"
}"
  end
end
