Tree = Struct.new(:height, :x, :y) do
  def edge_tree?
    x == 0 || x == grid_width ||
      y == 0 || y == grid_height
  end
end

def tree_map
  File.read('input/treemap.txt')
end

def tree_grid
  tree_map.each_line.map { |l| l.split('')[0..-2].map(&:to_i) }
end

def grid_width
  tree_grid.first.size - 1
end

def grid_height
  tree_grid.size - 1
end

def visible_from?(tree, direction)
  return true if tree.edge_tree?

  case direction
  when :top
    coord_set = (tree.y - 1..0).map { |r| [r, tree.x] }
  when :bottom
    coord_set = (tree.y + 1..grid_width).map { |r| [r, tree.x] }
  when :left
    coord_set = (tree.x - 1..00).map { |r| [tree.y, r] }
  when :right
    coord_set = (tree.x + 1..grid_height).map { |r| [tree.y, r] }
  end

  coord_set.each do |coords|
    comp_height = tree_grid.dig(*coords)
    # pp ['COMPCHECK', coords, comp_height, tree.height, comp_height >= tree.height]
    return false if comp_height >= tree.height
  end
  # puts "#{[tree.x, tree.y]} visible from #{direction}? #{visible}"
  return true
end

def tree_visible?(tree)
  visible_from?(tree, :top) ||
    visible_from?(tree, :bottom) ||
    visible_from?(tree, :left) ||
    visible_from?(tree, :right)
end

def count_tree_visibility
  vis_count = 0
  tree_grid.each_with_index do |row, y|
    row.each_with_index do |height, x|
      tree = Tree.new(height, x, y)
      # pp ["NEXT CHECK", x, y]
      vis_count += 1 if tree_visible?(tree)
      # puts vis_count
    end
  end
  vis_count
end

pp count_tree_visibility
