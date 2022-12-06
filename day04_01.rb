
def assignment_overlaps
end

class AssignmentPair
  def initialize(input)
    @first = input.split(',')[0]
    @second = input.split(',')[1]
  end

  def fully_contains?
    first_range = build_range(@first) 
    second_range = build_range(@second) 

    puts first_range
    puts second_range

    range_contains?(first_range, second_range) || range_contains?(second_range, first_range)
  end

  def contains_some?
    first_range = build_range(@first) 
    second_range = build_range(@second) 

    range_contains?(first_range, second_range, fully: false) || range_contains?(second_range, first_range, fully: false)
  end

  private

  def range_contains?(one_range, other_range, fully: true)
    return other_range.all? { |fi| one_range.include? fi } if fully
    other_range.any? { |fi| one_range.include? fi }
  end

  def build_range(rangetext)
    start = rangetext.split('-')[0].to_i
    ind = rangetext.split('-')[1].to_i
    (start..ind)
  end
end

def assignment_pairs
  File.read('pair_assignments.txt').each_line.map do |line|
    AssignmentPair.new(line)
  end
end

puts assignment_pairs.map(&:fully_contains?).select { |bool| bool == true }.size
puts assignment_pairs.map(&:contains_some?).select { |bool| bool == true }.size
