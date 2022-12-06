class ItemScorer
  LOWER_A_ORD = 97
  LOWER_Z_ORD = 122
  UPPER_A_ORD = 65

  def initialize(item: nil)
    @item = item
  end

  def score
    char_score(@item)
  end

  private

  def char_score(char)
    return (char.ord - LOWER_A_ORD + 1) if (LOWER_A_ORD..LOWER_Z_ORD).include?(char.ord)
    char.ord - UPPER_A_ORD + 27
  end
end

class RucksackGroup
  attr_reader :rucksacks

  def initialize(rucksacks: [])
    @rucksacks = rucksacks
  end

  def print_rucksacks
    puts rucksacks
    puts shared_item
    puts shared_item_score
    puts '\n\n'
  end

  def shared_item
    rucksacks.first.each_char do |rc|
      return rc if rucksacks[1].include?(rc) && rucksacks[2].include?(rc)
    end
  end

  def shared_item_score
    ItemScorer.new(item: shared_item).score
  end
end

def rucksack_groups
  rucksack_raw.each_line.each_slice(3).map do |group|
    RucksackGroup.new(rucksacks: group)
  end
end

def rucksack_raw
  File.read('rucksack.txt')
end

puts rucksack_groups.map { |rg| rg.print_rucksacks; rg.shared_item_score }.sum
