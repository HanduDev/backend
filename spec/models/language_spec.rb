# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Language, type: :model do
  Language::POSSIBLE_LANGUAGES.each do |language|
    context "with #{language} language" do
      let(:language_class) { described_class.new(acronym: language) }

      it do
        expect(language_class).to be_valid
      end

      it 'has the correct name' do
        expect(language_class.name).not_to include('Translation missing')
      end
    end
  end

  context 'when acronym is invalid' do
    let(:language) { described_class.new(acronym: 'any_language') }

    it do
      expect(language).not_to be_valid
    end
  end
end
