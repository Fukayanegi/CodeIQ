c_houses_all = STDIN.gets.chomp.to_i
houses = []
@memo = Hash.new
@memo2 = Hash.new

c_houses_all.times do
  houses << STDIN.gets.chomp.to_i
end

def calc_best_route houses
  # p "houses: #{houses}"
  c_houses = houses.length
  return [] if c_houses == 0
  return houses if c_houses == 1
  # return [11,1,10,2,9,3,4,5,6,7,8] if houses == [1,2,3,4,5,6,7,8,9,10,11]

  min_energy = Float::INFINITY
  key_all = houses.sort.join("")
  best_route = []

  if @memo2.include? key_all
    best_route = @memo2[key_all] 
    # min_energy = calc_energy best_route
  else
    # p "c_houses: #{c_houses}"
    c_houses.times do |target_i|

      target = houses.slice!(target_i-1)

      (c_houses-1).times do |visit_i|
        # p "#{target}, #{houses[0..visit_i]}, #{houses[visit_i+1..(c_houses-2)]}"
        # key = create_key houses[0..visit_i], target, houses[visit_i+1..(c_houses-2)]

        # if @memo.include? key
        #   route = @memo[key]
          # p "#{key} : #{route}"
        # else
          passed = calc_best_route houses[0..visit_i]
          rest = calc_best_route houses[visit_i+1..(c_houses-2)]
          route = ([].concat(passed) << target).concat(rest)      
          # @memo[key] = route
          # p "add memo << #{key} : #{route}"
        # end

        energy = calc_energy route
        min_energy, best_route = [energy, route] if min_energy > energy
      end

      houses.insert target_i-1, target
      # p "best_route: #{best_route}"
      # p min_energy      
    end
    @memo2[key_all] = best_route
  end

  best_route
end

def create_key passed, nxt, rest
  "#{passed.sort.join("")}:#{nxt}:#{rest.sort.join("")}"
end

def calc_energy route
    energy = 0
    route.length.times do |route_i|
      from = route_i > 0 ? route[route_i-1] : 0
      to = route[route_i]
      energy += from * to * route[route_i..route.length].inject(:+)
    end

    energy
end

route = calc_best_route houses

# p route
puts calc_energy route