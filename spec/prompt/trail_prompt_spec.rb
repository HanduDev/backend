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

RSpec.describe TrailPrompt, type: :model do
  let(:trail) { build(:trail, language: language) }
  let(:language) { 'en' }

  context 'validations' do
    context 'is valid with valid attributes' do
      let(:trail_prompt) { described_class.new(trail: trail) }

      it do
        expect(trail_prompt).to be_valid
      end
    end

    context 'is invalid with invalid attributes' do
      let(:trail_prompt) do
        described_class.new(trail: trail)
      end

      let(:language) { 'invalid_language' }

      it do
        expect(trail).to be_invalid
      end
    end
  end

  context 'prompt' do
    let(:trail_prompt) { described_class.new(trail: trail) }

    it do
      expect(trail_prompt.prompt).to eq("Você é um professor especialista e fluente em Inglês.
Você deve criar uma trilha de aprendizado para o aluno.
Sua resposta deve conter as seguintes informações:
1. Nome da trilha
2. Descrição da trilha

Retorne a resposta em formato JSON, seguindo o seguinte exemplo:
{
  \"name\": \"Nome da trilha\",
  \"description\": \"Descrição da trilha\"
}

O usuário forneceu as seguintes preferências, siga-as rigorosamente:
<preferencias>
  1. Nível de conhecimento do aluno: #{trail.level}
  2. Temas de interesse: #{trail.themes} (fale sobre esses temas)
  3. Tempo total da trilha deve ser: #{trail.time_to_learn}
  4. Tempo para estudar diariamente: #{trail.time_to_study}
  5. O que o usuário quer desenvolver: #{trail.developments}
</preferencias>

Os dados devem todos ser respondidos em português (BR).")
    end
  end

  Language::POSSIBLE_LANGUAGES.each do |language|
    context "with #{language} language" do
      let(:language) { language }
      let(:trail_prompt) do
        described_class.new(trail: trail)
      end

      it do
        expect(trail_prompt).to be_valid
      end
    end
  end
end
