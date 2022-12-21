class Shape
  def initialize(shape_letter)
    @shape_letter = shape_letter
  end

  def name
    return :rock if ['A', 'X'].include? @shape_letter
    return :paper if ['B', 'Y'].include? @shape_letter
    :scissors
  end

  def shape_score
    return 1 if name == :rock
    return 2 if name == :paper
    3
  end

  def score_against(their_shape)
    return 6 if beats_shape == their_shape.name
    return 3 if name == their_shape.name
    return 0
  end

  private

  def beats_shape
    return :rock if name == :paper
    return :paper if name == :scissors
    return :scissors
  end
end

def round_score(round)
  round[:me].shape_score + round[:me].score_against(round[:them])
end

def rounds
  # not sure why I can't split by \n...
  rounds_raw.gsub(/\n/, 'r').gsub(/ /, '').split('r').map do |r|
    {
      them: Shape.new(r[0]),
      me: Shape.new(r[1])
    }
  end
end

def rounds_raw
  File.read('input/stratguide.txt')
end

puts rounds.map {|r| round_score(r) }.sum
