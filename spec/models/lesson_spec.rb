# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id               :integer          not null, primary key
#  activity_type    :string
#  expected_answer  :string
#  finished_at      :datetime
#  has_finished     :boolean          default(FALSE), not null
#  markdown_content :text             default("")
#  name             :string           not null
#  question         :string
#  user_answer      :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  trail_id         :integer          not null
#
# Indexes
#
#  index_lessons_on_trail_id  (trail_id)
#
# Foreign Keys
#
#  trail_id  (trail_id => trails.id)
#
require 'spec_helper'

RSpec.describe Lesson, type: :model do
  context 'validations' do
    context 'is valid with valid attributes' do
      let(:lesson) { create(:lesson) }

      it do
        expect(lesson).to be_valid
      end
    end

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:markdown_content) }
    it { is_expected.to validate_inclusion_of(:has_finished).in_array([true, false]) }
    it { is_expected.to belong_to(:trail) }
  end

  context 'callbacks' do
    before do
      allow(Time).to receive(:current).and_return(Time.new(2023, 10, 1, 12, 0, 0, '+00:00'))
    end

    describe 'set_finished_at' do
      let!(:lesson) { create(:lesson, has_finished: false, finished_at: nil) }

      it 'sets finished_at to current time' do
        current_time = Time.current
        expect { lesson.update!(has_finished: true) }.to change { lesson.reload.finished_at }.from(nil).to(current_time)
      end
    end
  end
end
