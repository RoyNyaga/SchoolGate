arr = [1, 2, 3, 4, 5, 6, 7]

arr.each do |v|
  p "first loop #{v}"
  arr.each do |sl|
    next if sl == 5
    p "second loop #{sl}"
  end
end
