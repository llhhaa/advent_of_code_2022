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

def scene_score_from(tree, direction)
  return 0 if tree.edge_tree?

  case direction
  when :top
    range = (0..(tree.y - 1)).to_a.reverse
    coord_set = range.map { |r| [r, tree.x] }
  when :bottom
    coord_set = ((tree.y + 1)..grid_width).map { |r| [r, tree.x] }
  when :left
    range = (0..(tree.x - 1)).to_a.reverse
    coord_set = range.map { |r| [tree.y, r] }
  when :right
    coord_set = ((tree.x + 1)..grid_height).map { |r| [tree.y, r] }
  end

  scene_score = 0
  # pp [direction, coord_set]
  coord_set.each do |coords|
    comp_height = tree_grid.dig(*coords)
    scene_score += 1 # always increment, include the blocking tree
    return scene_score if comp_height >= tree.height
  end
  scene_score
end

def scene_score(tree)
  scores = [
    scene_score_from(tree, :top),
    scene_score_from(tree, :bottom),
    scene_score_from(tree, :left),
    scene_score_from(tree, :right)
  ]
  # pp ['scene scores', [tree.x, tree.y],  scores]
  scores.reduce(&:*)
end

def count_tree_visibility
  max_scene_score = 0
  tree_grid.each_with_index do |row, y|
    row.each_with_index do |height, x|
      tree = Tree.new(height, x, y)
      max_scene_score = [max_scene_score, scene_score(tree)].max
    end
  end
  max_scene_score
end

pp count_tree_visibility
