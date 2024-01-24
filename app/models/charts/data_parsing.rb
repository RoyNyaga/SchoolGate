class Charts::DataParsing
  def self.revenue_per_class_over_time(school_classes, academic_year)
    main_data = []
    school_classes.each do |s_c|
      class_data = {}
      class_data["name"] = s_c.name
      update_records = s_c.fees.where(academic_year: academic_year).map(&:update_records).flatten
      update_records = update_records.map { |r| eval(r) }
      data = {}
      update_records.each do |record|
        data[record[:date]] = data[record[:date]].to_i + record[:changes].last.to_i
      end
      class_data["data"] = data
      main_data << class_data
    end
    main_data
  end

  def self.completeness_fee_per_class(academic_year, complete_type, current_school)
    data = {}
    school_classes = current_school.school_classes.includes(:fees)
    school_classes.each do |s_c|
      data["#{s_c.name}"] = s_c.fees.send(complete_type).where(academic_year: academic_year).count # fees should be in the context of the academic year selected
    end
    data
  end
end
