# sample
# cost = 150
# price = 300
# waste = 30
# quantity = [
#     10000, 20000, 40000, 60000
# ]
# demand_dist = [
#     [10000, 0.1],
#     [20000, 0.35],
#     [40000, 0.3],
#     [60000, 0.25],
# ]

# q1
# cost = 200
# price = 500
# waste = 10
# quantity = [
#     300, 500, 700, 900
# ]
# demand_dist = [
#     [200, 0.2],
#     [450, 0.3],
#     [700, 0.4],
#     [950, 0.1],
# ]

# q2
# cost = 20
# price = 100
# waste = 10
# quantity = [
#     10000, 12000, 14000, 18000, 20000
# ]
# demand_dist = [
#     [2400, 0.1],
#     [6000, 0.5],
#     [12000, 0.3],
#     [24000, 0.1],
# ]

# q3
cost = 80
price = 400
waste = 20
quantity = [
    2000, 4000, 6000, 8000, 10000
]
demand_dist = [
    [1000, 0.4],
    [2000, 0.1],
    [7000, 0.3],
    [10000, 0.2],
]

answer = quantity.inject({}) do |h, q|
  prof = 0
  demand_dist.each do |demand, prob|
    s = (demand > q ? q : demand) * price
    q_p = q * cost
    x = (demand > q ? 0 : q - demand) * waste
    # p "#{demand}, #{prob}, #{s}, #{q_p}, #{x}"
    prof += (s - q_p - x) * prob
  end
  h[q] = prof
  h
end
p answer
m = answer.values.max
p answer.select{|k, v| v == m}.keys[0]