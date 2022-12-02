class Shape
  attr_reader :shape_name
  attr_reader :shape_letter

  def initialize(shape_letter: nil, shape_name: nil)
    @shape_name = shape_name
    @shape_letter = shape_letter
  end

  def name
    raise 'missing input' unless shape_name || shape_letter

    return @shape_name if shape_name
    return :rock if ['A', 'X'].include? shape_letter
    return :paper if ['B', 'Y'].include? shape_letter
    return :scissors if ['C', 'Z'].include? shape_letter
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

  def shape_for_opponent_outcome(outcome)
    Shape.new(shape_name: shape_name_for_opponent_outcome(outcome))
  end

  private

  def beats_shape
    return :rock if name == :paper
    return :paper if name == :scissors
    return :scissors
  end

  def shape_name_for_opponent_outcome(outcome)
    return :rock if outcome == :win && name == :scissors
    return :rock if outcome == :draw && name == :rock
    return :rock if outcome == :lose && name == :paper

    return :paper if outcome == :win && name == :rock
    return :paper if outcome == :draw && name == :paper
    return :paper if outcome == :lose && name == :scissors

    return :scissors if outcome == :win && name == :paper
    return :scissors if outcome == :draw && name == :scissors
    return :scissors if outcome == :lose && name == :rock
  end
end

def round_outcome(outcome_letter)
  return :lose if outcome_letter == 'X'
  return :draw if outcome_letter == 'Y'
  :win
end

def round_score(round)
  my_shape = round[:them].shape_for_opponent_outcome(round[:outcome])
  my_shape.shape_score + my_shape.score_against(round[:them])
end

def rounds
  # not sure why I can't split by \n...
  rounds_raw.gsub(/\n/, 'r').gsub(/ /, '').split('r').map do |r|
    puts r
    hash = {
      them: Shape.new(shape_letter: r[0]),
      outcome: round_outcome(r[1])
    }
    puts hash[:them].name
    puts hash[:outcome]
    hash
  end
end

def rounds_raw
  File.read('stratguide.txt')
end

puts rounds.map {|r| round_score(r) }.sum
