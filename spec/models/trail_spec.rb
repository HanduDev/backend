# frozen_string_literal: true

# == Schema Information
#
# Table name: trails
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  started_at  :date
#  language    :string           not null
#  description :text             not null
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_trails_on_user_id  (user_id)
#

RSpec.describe Trail, type: :model do
  context 'validations' do
    context 'is valid with valid attributes' do
      let(:trail) { create(:trail) }

      it do
        expect(trail).to be_valid
      end
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:language) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to validate_inclusion_of(:language).in_array(Language::POSSIBLE_LANGUAGES) }
  end

  context 'associations' do
    it { is_expected.to belong_to(:user).optional }
  end
end
