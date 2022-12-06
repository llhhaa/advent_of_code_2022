Move = Struct.new(:qty, :orig, :dest, keyword_init: true)

class CrateMover
  def initialize(stacks, moves)
    @stacks = stacks
    @moves = moves
  end

end

def crates_raw
  File.read('input/crates.txt')
end

def crate_stacks
  stacks = crates_raw.match(/(\s*\[.*\n)*/).to_s.each_line.each_with_object({}) do |line, hash|
    line.chars.each_slice(4).with_index do |s, i|
      hash[i + 1] = (hash[i + 1] || []) << s.join('').match(/\w/).to_s
    end
  end
  stacks.values.map(&:reverse!)
  stacks.each { |k, v| v.reject! { |el| el.empty? } }
  stacks
end

def crate_moves
  crates_raw.match(/move(.*\n)*/).to_s.each_line.each_with_object([]) do |line, arr|
    qty, orig, dest = line.scan(/\d+/).flatten.map(&:to_i)
    arr << Move.new(
      qty: qty,
      orig: orig,
      dest: dest
    )
  end
end

def apply_moves(stacks, model_9001: false)
  crate_moves.each do |move|
    pp stacks if stacks[move.orig].nil?
    pp move if stacks[move.orig].nil?
    moved = stacks[move.orig].pop(move.qty).reverse
    moved.reverse! if model_9001
    stacks[move.dest].concat(moved).reject { |el| el.empty? }
  end
  stacks
end

def top_of_each_stack
  apply_moves(crate_stacks, model_9001: true).each_value.with_object([]) do |v, arr|
    arr << v.reject{ |el| el.empty? }.last
  end
end

pp top_of_each_stack.join('')
