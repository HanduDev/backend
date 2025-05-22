# frozen_string_literal: true

class Lesson::LessonPrompt
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  ATTRIBUTES = {}.freeze

  attr_accessor :trail, :lesson_number, :summary

  validates :trail, presence: true

  def initialize(attributes = ATTRIBUTES)
    super
  end

  def prompt
    raise NotImplementedError, "Subclasses must implement the prompt method"
  end

  protected

  def initialize_prompt
    previous_prompt = lesson_number > 1 ? "Os dados das aulas anteriores são:

#{summary}" : ""

    "Você é um professor especialista e fluente em #{trail.lang.name}.
O aluno está aprendendo através de um aplicativo, portanto, não há professores incluídos no processo.

Esta é a aula #{lesson_number}.

#{previous_prompt}

O usuário forneceu as seguintes preferências, siga-as rigorosamente:
<preferencias>
  1. Nível de conhecimento do aluno: #{trail.level}
  2. Temas de interesse: #{trail.themes} (o usuarío tem esses temas com interesse, porém não desvie o foco! A aula é sobre o idioma #{trail.lang.name})
  3. Tempo para estudar diariamente: #{trail.time_to_study}
  4. O que o usuário quer desenvolver: #{trail.developments}
</preferencias>"
  end
end
