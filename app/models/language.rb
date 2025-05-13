# frozen_string_literal: true

ATTRIBUTES = {}.freeze

class Language
  include ActiveModel::Model
  include ActiveModel::Attributes

  POSSIBLE_LANGUAGES = %w[
    af
    ar
    az
    ba
    be
    bg
    ca
    cs
    cy
    da
    de
    el
    en
    en-us
    es
    ja
    et
    fa
    fi
    fo
    fr
    gl
    gu
    he
    hi
    hr
    hu
    hy
    id
    is
    it
    lt
    pt
    pt-br
    sk
    sv
    tr].freeze

  attribute :acronym, :string
  attribute :name, :string

  validates :acronym, presence: true, inclusion: { in: POSSIBLE_LANGUAGES }
  validates :name, presence: true

  def initialize(attributes = ATTRIBUTES)
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
