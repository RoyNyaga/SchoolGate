class Charts::DataParsing
  def self.revenue_per_class_over_time(school_classes)
    main_data = []
    school_classes.each do |s_c|
      class_data = {}
      class_data["name"] = s_c.name
      update_records = s_c.fees.map(&:update_records).flatten
      update_records = update_records.map { |r| eval(r) }
      data = {}
      update_records.each do |record|
        data[record[:date]] = data[record[:date]].to_i + record[:changes].last.to_i
      end
      class_data["data"] = data
      main_data << class_data
      p "this is main data"
      p "this is main data"
      p "this is main data"
      p "this is main data"
      p "this is main data"
      p main_data
    end
    main_data
  end
end
