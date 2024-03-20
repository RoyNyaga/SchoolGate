class Person
  attr_accessor :name, :gender

  def initialize(name, gender)
    @name = name
    @gender = gender
  end

  def full_name
    name + "other names"
  end
end

pe = Person.new("Andre", "male")
puts pe.name
puts pe.full_name
