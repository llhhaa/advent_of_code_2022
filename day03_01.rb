class Rucksack
  def initialize(contents: nil)
    @contents = contents
  end

  def print_contents
    puts "[#{first_compartment}, #{second_compartment}]"
    puts "shared_items: #{shared_items}"
  end

  def shared_items
    shared_items = []
    (0...compartment_size).each do |i|
      shared_items << first_compartment[i]  if second_compartment.include? first_compartment[i]
    end
    shared_items.uniq
  end

  def compartment_size
    @contents.size / 2
  end

  def first_compartment
    @contents[0..compartment_size]
  end

  def second_compartment
    @contents[compartment_size..-1]
  end
end

class RucksackScorer
  LOWER_A_ORD = 97
  LOWER_Z_ORD = 122
  UPPER_A_ORD = 65

  def initialize(rucksack: nil)
    @rucksack = rucksack
  end

  def score
    @rucksack.shared_items.map { |si| char_score(si) }.sum
  end

  private

  def char_score(char)
    return (char.ord - LOWER_A_ORD + 1) if (LOWER_A_ORD..LOWER_Z_ORD).include?(char.ord)
    char.ord - UPPER_A_ORD + 27
  end
end

def rucksacks
  rucksack_raw.each_line.map do |rrl|
    Rucksack.new(contents: rrl)
  end
end

def rucksack_total_scores
  scores = rucksacks.map do |r|
    RucksackScorer.new(rucksack: r).score
  end
  scores.sum
end

def rucksack_raw
  File.read('input/rucksack.txt')
end

puts rucksack_total_scores
