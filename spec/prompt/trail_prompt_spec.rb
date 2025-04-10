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
  let(:language) { Language.new(acronym: 'en') }

  context 'validations' do
    context 'is valid with valid attributes' do
      let(:trail_prompt) { described_class.new(language: language) }

      it do
        expect(trail_prompt).to be_valid
      end
    end

    context 'is invalid with invalid attributes' do
      let(:trail_prompt) do
        described_class.new(language: Language.new(acronym: 'any_language'))
      end

      it do
        expect(trail_prompt.errors.full_messages).to eq(['Linguagem não está incluído na lista'])
      end
    end
  end

  context 'prompt' do
    let(:trail_prompt) { described_class.new(language: language) }

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
}")
    end
  end

  Language::POSSIBLE_LANGUAGES.each do |language|
    context "with #{language} language" do
      let(:trail_prompt) do
        described_class.new(language: Language.new(acronym: language))
      end

      it do
        expect(trail_prompt).to be_valid
      end
    end
  end
end
