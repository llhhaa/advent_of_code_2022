require 'set'

def signal
  File.read('input/commsignal.txt')
end

def detect_marker(signal, charcount)
  signal.chars.each_with_index do |c, i|
    start = [(i - charcount), 0].max # for the very start of the array, where we don't have 4 chars yet
    set = Set.new(signal.chars[start..i])
    return i + 1 if set.size == charcount
  end
  return 'NO MARKER'
end

puts detect_marker(signal, 4)
puts detect_marker(signal, 14)
