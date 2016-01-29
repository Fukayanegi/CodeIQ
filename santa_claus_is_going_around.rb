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
  # return [11,1,10,2,9,3,6,4,7,5,8] if houses == [1,2,3,4,5,6,7,8,9,10,11]

  min_energy = Float::INFINITY
  key = "#{present}:#{houses.sort.join("")}"
  best_route = []

  # p "#{key}, #{houses}"
  # sleep(1)

  if @memo.include? key
    best_route = @memo[key] 
  else
    (0..c_houses-1).each do |next_i|

      next_house = houses.slice! next_i
      route = ([] << next_house).concat(calc_best_route houses, next_house)
      energy = present * next_house * route.inject(:+) + calc_energy(route)

      # p "route: #{route} ,#{next_house}, #{route} : #{energy}" #if next_house == 4 && houses.length == 3
      min_energy, best_route = [energy, route] if min_energy > energy

      houses.insert next_i, next_house
      # p "best_route: #{best_route}" if c_houses == 5
      # p min_energy      
    end

    # p "#{key} ::  #{best_route}"
    @memo[key] = best_route
  end

  best_route
end

def calc_min_energy frist, rest
  route = ([]<<first).concat(rest)
  key = route.sort.join("")
  if @memo.include? key
    calc_energy @memo[key]
  else
    min_energy = Float::INFINITY
    rest.permutaiton.each do |perm|
      energy = calc_energy [[]<<first].concat(perm)
      min_energy = energy if min_energy > energy
    end
    min_energy
  end
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

p route
puts calc_energy route