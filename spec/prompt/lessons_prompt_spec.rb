# frozen_string_literal: true

# == Schema Information
#
# Table name: ai_responses
#
#  id            :integer          not null, primary key
#  user_prompt   :text             not null
#  system_prompt :text
#  output        :text             not null
#  total_tokens  :integer          not null
#  model         :string           not null
#  user_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_ai_responses_on_user_id  (user_id)
#

require 'spec_helper'

RSpec.describe LessonsPrompt, type: :model do
  let(:trail) { create(:trail) }

  context 'validations' do
    context 'is valid with valid attributes' do
      let(:lessons_prompt) { described_class.new(trail: trail) }

      it do
        expect(lessons_prompt).to be_valid
      end
    end
  end

  context 'prompt' do
    let(:lessons_prompt) { described_class.new(trail: trail) }

    it do
      expect(lessons_prompt.prompt).to eq("Você é um professor especialista e fluente em Inglês.
Você deve criar 10 aulas para o aluno aprender Inglês.

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

O usuário forneceu as seguintes preferências, siga-as rigorosamente:
<preferencias>
  1. Nível de conhecimento do aluno: #{trail.level}
  2. Temas de interesse: #{trail.themes} (fale sobre esses temas)
  3. Tempo total da trilha deve ser: #{trail.time_to_learn}
  4. Tempo para estudar diariamente: #{trail.time_to_study}
  5. O que o usuário quer desenvolver: #{trail.developments}
</preferencias>

Lembre-se que você deve criar 10 aulas, então a resposta deve conter 10 objetos JSON (array), cada um representando uma aula.
Você está criando o plano para o aluno, e não para o professor, então torne o texto o mais didático possível para todos conseguirem entender.
Os dados devem todos ser respondidos em português (BR).

Os conteúdos devem ser extremamente detalhados e completos, com exemplos práticos.
Cada markdown deve ter no mínimo 500 palavras.

Retorne a resposta em formato JSON, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da aula\",
  \"markdown_content\": \"Descrição da aula em markdown\"
}")
    end
  end
end
