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
cost = 200
price = 500
waste = 10
quantity = [
    300, 500, 700, 900
]
demand_dist = [
    [200, 0.2],
    [450, 0.3],
    [700, 0.4],
    [950, 0.1],
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