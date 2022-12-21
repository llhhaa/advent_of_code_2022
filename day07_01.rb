MAX_DIR_SIZE = 100000
TOTAL_SPACE = 70000000
TARGET_SPACE = 30000000

def terminal_output
  File.read('input/filesystem.txt').each_line
end

def file_tree
  @file_tree ||= {}
end

def dir_stack(name = nil)
  @dir_stack ||= []

  return @dir_stack unless name

  if name.match /\.\./
    @dir_stack.pop
  else
    @dir_stack.push(name)
  end
end

def add_file(file_disp)
  # defensively build the directory tree
  current_dir ||= file_tree
  dir_stack.each do |dir|
    current_dir[dir] ||= {}
    current_dir = current_dir[dir]
  end

  # then add the file to its spot in the tree
  size, file_name = file_disp
  pp dir_stack
  file_tree.dig(*dir_stack)[file_name] = size.to_i
end

def build_file_tree
  terminal_output.each do |line|
    line_words = line.split(' ')
    case line_words[0]
    when '$'
      dir_stack(line_words[2]) if line_words[1].match(/cd/)
    when /\d+/
      add_file(line_words)
    end
  end
  file_tree
end

def traverse_dir(name, contents, collector)
  total_size = 0
  contents.each do |k, val|
    if (val.is_a? Integer)
      total_size += val 
    else
      total_size += traverse_dir(k, val, collector)
    end
  end
  name_and_size = "#{name}_#{total_size}"
  collector.call(name_and_size, total_size)
  total_size
end

def dirs_less_100k
  @dirs_less_100k ||= {}
  @dirs_less_100k
end

def less_100k_total
  less_100k_collector = ->(name, size) { dirs_less_100k[name] = size if size <= MAX_DIR_SIZE }
  build_file_tree
  traverse_dir('/', file_tree, less_100k_collector)
  dirs_less_100k.values.sum
end

puts less_100k_total

def total_disk_size
  empty_collector = ->(name, size) { nil }
  traverse_dir('/', file_tree, empty_collector)
end

puts total_disk_size

def dirs_to_free_target
  @dirs_to_free_target ||= {}
  @dirs_to_free_target
end

def smallest_to_free_space
  unused_space = TOTAL_SPACE - total_disk_size
  target_dir_size = TARGET_SPACE - unused_space
  will_free_target = ->(name, size) { pp [name, size]; dirs_to_free_target[name] = size if size >= target_dir_size }
  traverse_dir('/', file_tree, will_free_target)
  dirs_to_free_target.values.sort.first
end

pp smallest_to_free_space
