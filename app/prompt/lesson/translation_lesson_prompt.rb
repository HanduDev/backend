# frozen_string_literal: true

class Lesson::TranslationLessonPrompt < Lesson::LessonPrompt
  def prompt
    "#{initialize_prompt}

Você está criando a atividade prática para o aluno, e não para o professor, então torne-a o mais didático possível para que ele consiga entender.
Os dados devem todos ser respondidos em português (BR).

A questão deve ser uma frase em português (BR) e a resposta esperada deve ser a tradução dessa frase para o idioma #{trail.lang.name}.
Lembre-se, você deve fornecer a questão e a resposta esperada! Nunca diga que o professor irá fazer algo, ou que você irá fazer algo, ou que o aplicativo irá fazer algo.
Forneça somente a questão e a resposta esperada, não forneça nenhuma outra coisa.
Forneça somente uma frase para a questão e uma frase para a resposta esperada.

Retorne a resposta SOMENTE em formato JSON, sem comentários, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da aula prática\",
  \"question\": \"Questão da aula prática\",
  \"summary\": \"Resumo da aula em até 100 caracteres\",
  \"expected_answer\": \"Resposta esperada para a questão\",
}"
  end
end
