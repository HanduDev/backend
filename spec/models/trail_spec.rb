# frozen_string_literal: true

# == Schema Information
#
# Table name: trails
#
#  id          :integer          not null, primary key
#  description :text             not null
#  language    :string           not null
#  name        :string           not null
#  started_at  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_trails_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#

require 'spec_helper'

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
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:lessons) }
    it { is_expected.to validate_inclusion_of(:language).in_array(Language::POSSIBLE_LANGUAGES) }
  end

  context 'progress' do
    let(:trail) { create(:trail) }
    let!(:finished_lesson) { create(:lesson, trail: trail, has_finished: true) }
    let!(:unfinished_lesson) { create(:lesson, trail: trail, has_finished: false) }

    it 'calculates the progress correctly' do
      expect(trail.progress).to eq(50.0)
    end

    context 'when there are no lessons' do
      before do
        trail.lessons.destroy_all
      end

      it 'returns 0' do
        expect(trail.progress).to eq(0)
      end
    end
  end
end
