class Term < ApplicationRecord
  belongs_to :school
  has_many :sequences
  has_many :report_cards
  belongs_to :academic_year

  validates :term_type, presence: true, uniqueness: { scope: :academic_year_id,
                                                      message: "Term already exist for this academic year" }
  enum term_type: { first_term: 1, second_term: 2, third_term: 3 }

  def title
    "#{term_type.humanize} - #{academic_year.year}"
  end

  def sum_sequence_subject_marks(subject_id) # returns an array of marks hases with the sum of first sequence and second sequence marks
    first_seq, second_seq = sequences.where(subject_id: subject_id).order(:seq_num)
    subject = Subject.find(subject_id)

    result = []
    first_seq_marks = first_seq.hashed_marks
    second_seq_marks = second_seq.hashed_marks

    first_seq_marks.each do |first_seq_mark|
      matching_hash = second_seq_marks.find { |second_seq_mark| second_seq_mark["id"] == first_seq_mark["id"] }

      if matching_hash
        sum_mark = first_seq_mark["mark"] + matching_hash["mark"]
        result << { "id" => first_seq_mark["id"], "name" => first_seq_mark["name"], "mark" => sum_mark }
      else
        # Handle the case where there is no matching hash in second_seq_marks
        result << first_seq_mark
      end
    end

    # Add any remaining hashes from second_seq_marks that were not matched in first_seq_marks
    second_seq_marks.each do |second_seq_mark|
      unless result.any? { |result_hash| result_hash["id"] == second_seq_mark["id"] }
        result << second_seq_mark
      end
    end
    # binding.break
    result
  end

  def calc_sequence_averages(sequence_marks)
    sequence_marks.map { |mark| { "id" => mark["id"], "name" => mark["name"], "mark" => mark["mark"] / 2 } }
  end

  def classes_with_report_cards
    SchoolClass.joins(:report_cards).where(report_cards: { term_id: id }).distinct
  end
end
