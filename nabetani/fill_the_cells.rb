def dlog variables, method = ""
  if ARGV.include?("-dlog")
    tmp = ""
    variables.each do |key, value|
      tmp += "#{key}: #{value}, "
    end
    p tmp[0..tmp.length-3]
  end
end

class Solver
  DIRECTION = {:horizonal => "H", :vertical => "V"}
  Order = Struct.new(:direction, :x, :y, :length)
  MergedPos = Struct.new(:start_pos, :end_pos)

  def initialize orders
    @orders = orders.map{|order| Order.new(*order.map.with_index{|item, i| i == 0 ? item : item.to_i})}
  end

  def merge targets, get_start_pos, create_order
    merged_positions = []
    targets.sort_by{|order| get_start_pos.call(order)}.each do |order|
      start_pos = get_start_pos.call(order)
      end_pos = start_pos + order.length - 1
      # dlog({:start_pos => start_pos, :end_pos => end_pos})

      merged = false
      merged_positions.each do |merged_pos|
        if merged_pos.start_pos <= start_pos && start_pos <= merged_pos.end_pos
          merged = true
          if end_pos > merged_pos.end_pos
            merged_pos.end_pos = end_pos
          end
        elsif merged_pos.start_pos <= end_pos && end_pos <= merged_pos.end_pos
          if start_pos < merged_pos.start_pos
            merged_pos.start_pos = start_pos
          end
          merged = true
        end
      end
      merged_positions << MergedPos.new(start_pos, end_pos) if !merged
    end

    merged_positions.map{|merged_pos| create_order.call(merged_pos)}
  end

  def prepare direction, getx, gety, get_start_pos, get_key
    targets = @orders.select{|order| order.direction == direction}.sort_by{|order| get_key.call(order)}
    targets.group_by{|order| get_key.call(order)}.inject([]) do |acc, g_targets|
      acc.concat(
        merge(g_targets[1], 
          lambda{|order| get_start_pos.call(order)}, 
          lambda{|pos| Order.new(direction, 
            getx.call(pos, g_targets[0]), 
            gety.call(pos, g_targets[0]), 
            pos.end_pos - pos.start_pos + 1)}
          )
        )
    end
  end

  def solve
    # dlog({:orders => @orders})

    rows = prepare(DIRECTION[:horizonal], lambda{|pos, key| pos.start_pos}, lambda{|pos, key| key}, lambda{|order| order.x}, lambda{|order| order.y})
    columns = prepare(DIRECTION[:vertical], lambda{|pos, key| key}, lambda{|pos, key| pos.start_pos}, lambda{|order| order.y}, lambda{|order| order.x})
    dlog({:rows => rows})
    dlog({:columns => columns})

    answer = rows.inject(0){|acc, row| acc += row.length; acc}
    answer = columns.inject(answer) do |acc, column|
      acc += column.length
      adjust = rows.inject(0) do |acc_inner, row|
        # dlog({:column_x => column.x, :column_y_s => column.y, :column_y_e => column.y + column.length - 1})
        acc_inner += 1 if (row.x <= column.x && column.x <= row.x + row.length - 1) && (column.y <= row.y && row.y <= column.y + column.length - 1)
        acc_inner
      end
      acc - adjust
    end

    answer
  end
end

input_str = STDIN.gets.chomp
# input_str = "H,1,2,8 V,4,1,8 H,1,7,5 V,7,7,2"
# input_str = "V,3,9,4 H,0,4,13 H,4,10,2 V,8,2,11"
# input_str = "V,8,7,2 H,8,10,6 V,9,9,7 H,10,14,4 H,11,0,3"
# input_str = "H,1,2,8 H,2,2,1 H,6,2,4"
# input_str = "V,7,0,1 V,4,0,1 V,1,0,1 H,2,0,1 H,5,0,4 H,1,0,8 H,4,0,3 H,4,0,5 H,4,0,6 H,8,0,2"
orders = input_str.split(" ").map{|order| order.split(",")}

solver = Solver.new(orders)
puts solver.solve
