c_houses_all = STDIN.gets.chomp.to_i
houses = []
@memo = Hash.new

c_houses_all.times do
  houses << STDIN.gets.chomp.to_i
end

def calc_best_route houses, present
  c_houses = houses.length
  return [] if c_houses == 0
  return houses.dup if c_houses == 1

  min_energy = Float::INFINITY
  key = "#{present}:#{houses.sort.join(",")}"
  best_route = []

  if @memo.include? key
    best_route = @memo[key] 
  else
    (0..c_houses-1).each do |next_i|

      next_house = houses.slice! next_i
      route = ([] << next_house).concat(calc_best_route houses, next_house)
      energy = present * next_house * route.inject(:+) + calc_energy(route)

      # p "route: #{route} ,#{next_house}, #{route} : #{energy}"
      min_energy, best_route = [energy, route] if min_energy > energy

      houses.insert next_i, next_house
    end

    # p "#{key} ::  #{best_route}" if c_houses == 11
    @memo[key] = best_route
  end

  best_route
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

route = calc_best_route houses, 0

# p route
puts calc_energy route