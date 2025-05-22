# frozen_string_literal: true

class Lesson::TranslationCorrectorPrompt
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations::Callbacks

  attr_accessor :lesson

  validates :lesson, presence: true

  def prompt
    trail = lesson.trail

    "Você é um tradutor e corretor para o idioma #{trail.lang.acronym}.

    O usuário respondeu uma questão de tradução.

    A questão a ser traduzida é:
    #{lesson.question}

    O usuário respondeu:
    #{lesson.user_answer}

    A resposta correta é:
    #{lesson.expected_answer}

    A resposta do usuário não precisa necessariamente ser IDENTICA, mas deve ser uma tradução CORRETA do texto da questão e deve estar sintaticamente correta.
    Lembre-se que algumas palavras podem ter mais de uma tradução, mas a resposta do usuário deve ser uma tradução CORRETA.

    Responda somente com 'true' ou 'false' para indicar se a resposta do usuário está correta."
  end
end
