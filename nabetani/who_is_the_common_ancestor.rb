children = STDIN.gets.chomp.split(",").map{|v| v.to_i}
child_max = children.max

def max_number depth
  prev_num = 0
  num = 1
  num_by_depth = [num]
  while depth > 0 do
    diff = num - prev_num
    is_odd_f, is_even_f = (prev_num+1).odd? ? [1,0] : [0,1]
    prev_num = num
    num_by_depth << num + 1
    num = prev_num + (diff+is_odd_f)/2 * 3 + (diff+is_even_f)/2 * 2
    depth -= 1
  end
  return num_by_depth
end

def calc_number_by_depth child_max
  depth = 0
  num_by_depth = []
  while (num_by_depth = (max_number depth)).max <= child_max
    depth += 1
  end
  num_by_depth
end

def calc_depth child, num_by_depth
  depth = 0
  while num_by_depth[depth] <= child do
    depth += 1
  end
  depth -= 1
end

def calc_ancestor_index child, depth, ancestor_f_num
  return -1 if child == 1

  syo = (child-depth+1) / 5
  amari = (child-depth+1) % 5
  even_f = ancestor_f_num.even? ? 1 : 0
  i_ancestor = 2*syo if amari == 0
  i_ancestor = 2*syo+1 if amari > 0 && amari <= 2
  i_ancestor = 2*syo+1+even_f if amari == 3
  i_ancestor = 2*syo+2 if amari >= 4

  i_ancestor
end

num_by_depth = calc_number_by_depth child_max

tree = {}
children.each do |child|
  key = child
  tree[key] = []

  while child != -1 do
    tree[key] << child if child != key
    i_depth = calc_depth child, num_by_depth
    child_f_num = num_by_depth[i_depth]
    i_ancestor = calc_ancestor_index child, child_f_num, num_by_depth[i_depth-1]
    ancestor = i_ancestor == -1 ? -1 : (num_by_depth[i_depth-1]+i_ancestor-1)

    child = ancestor
  end
end

p tree.values.inject{|prev, this| prev & this}.max
