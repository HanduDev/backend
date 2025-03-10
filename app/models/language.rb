# frozen_string_literal: true

class Language
  include ActiveModel::Model
  include ActiveModel::Attributes

  POSSIBLE_LANGUAGES = %w[en es fr de it ja ko pt ru zh].freeze

  attribute :acronym, :string
  attribute :name, :string

  validates :acronym, presence: true, inclusion: { in: POSSIBLE_LANGUAGES }
  validates :name, presence: true

  def initialize(attributes = {})
    super
    set_name
  end

  def set_name
    self.name = acronym_to_language(acronym)
  end

  def self.all
    POSSIBLE_LANGUAGES.map { |acronym| Language.new(acronym: acronym) }
  end

  private

  def acronym_to_language(acronym)
    I18n.t("languages.#{acronym}")
  end
end
