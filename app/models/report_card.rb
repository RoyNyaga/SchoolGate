class ReportCard < ApplicationRecord
  include DataTrans
  belongs_to :school
  belongs_to :school_class
  belongs_to :term
  belongs_to :student
  belongs_to :academic_year
  validates :student_id, uniqueness: { scope: :term_id,
                                       message: "This student already has a report for this term" }

  def generate_chart_data
    arr = ReportCard.string_to_hash_arr(details)
    main_data = [
      { "name" => "first_seq_mark", "data" => {} },
      { "name" => "second_seq_mark", "data" => {} },
    ]
    arr.each do |subject, index|
      seq_obj = {
        "first_seq_mark_data" => { "#{subject[:name][0..3]}" => subject[:first_seq_mark] },
        "second_seq_mark_data" => { "#{subject[:name][0..3]}" => subject[:second_seq_mark] },
      }

      main_data.each_with_index do |obj, index|
        current_key = index == 0 ? "first_seq_mark_data" : "second_seq_mark_data"
        obj["data"] = obj["data"].merge(seq_obj[current_key])
      end
    end
    main_data
  end

  def long_title
    "#{term.term_type} #{term.academic_year} #{school_class.name}"
  end

  def details_for(subject)
    ReportCard.string_to_hash_arr(details).find { |d| d["name"] == subject.name }
  end
end
