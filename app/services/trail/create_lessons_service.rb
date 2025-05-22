# frozen_string_literal: true

class Trail::CreateLessonsService < Trail::TrailService
  CHOICE_LESSON_PRIORITY = 3
  CHOICE_LESSON_MAX_PRIORITY = 6
  COMMON_LESSON_PRIORITY = 1
  TOTAL_LESSONS = 15

  MAPPED_ACTIVITY_PRIORITY = {
    'multiple_choice' => %w[reading writing],
    'translation' => %w[writing],
  }.freeze

  def initialize(trail:, user:)
    @trail = trail
    @user = user
  end

  def call
    @lessons = []
    summary = ''

    TOTAL_LESSONS.times do
      selected_class, selected_prompt = select_lesson_prompt_by_priority

      is_practical = ::Lesson::PRACTICAL_ACTIVITY_TYPES.include?(selected_prompt.to_s)
      index = is_practical ? total_practical : total_theorical
      index += 1

      prompt = selected_class.new(
        trail: @trail,
        summary: summary,
        lesson_number: index
      ).prompt

      response = generate_json_response(prompt: prompt)

      summary += get_summary(response, index, is_practical)

      lesson = @trail.lessons.create!(response.except('summary', 'options').merge(activity_type: selected_prompt.to_sym))
      create_lesson_options(lesson, response)

      @lessons << lesson
    end
  end

  private

  def get_summary(response, index, is_practical)
    return '' if response['summary'].blank?

    if is_practical
      "Resumo da aula prática #{index}: #{response['summary']}"
    else
      "Resumo da aula teórica #{index}: #{response['summary']}"
    end
  end

  def total_theorical
    @lessons.count { |lesson| lesson.activity_type == 'theorical' }
  end

  def total_practical
    @lessons.count { |lesson| lesson.is_practical? }
  end

  def create_lesson_options(lesson, response)
    return unless lesson.activity_type == 'multiple_choice'

    options = response['options'].map do |option|
      option['lesson_id'] = lesson.id
      option
    end

    Option.create!(options)
  end

  def select_lesson_prompt_by_priority
    return [lesson_prompt_class('theorical'), 'theorical'] if @lessons.size.zero? || @lessons.last.is_practical?

    list = priority_map.flat_map { |activity_type, priority| [activity_type] * priority }

    selected_prompt = list.sample

    if priority_map[selected_prompt] < CHOICE_LESSON_MAX_PRIORITY
      priority_map[selected_prompt] += 1
    end

    selected_class = lesson_prompt_class(selected_prompt)

    [selected_class, selected_prompt]
  end

  def lesson_prompt_class(activity_type)
    "Lesson::#{activity_type.to_s.classify}LessonPrompt".constantize
  end

  def priority_map
    trail_developments = @trail.developments.split(',')

    @priority_map ||= Lesson::PRACTICAL_ACTIVITY_TYPES.each_with_object({}) do |activity_type, map|
      has_priority = MAPPED_ACTIVITY_PRIORITY[activity_type].any? { |development| trail_developments.include?(development) }

      map[activity_type] = has_priority ? CHOICE_LESSON_PRIORITY : COMMON_LESSON_PRIORITY
    end
  end
end
