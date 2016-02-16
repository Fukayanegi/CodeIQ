YUKA = "X"
Y = "Y"

def print_schedule schedules
  schedules.each do |day, schedule|
    schedule.each do |k, v|
      p "#{k}: #{format("%.108b", v)}"
    end
  end
end

# 入力値の処理
# 5分単位前提
schedules = Hash.new
while schedule = STDIN.gets do
  who, day, from, to = schedule.split(",")

  schedules[day] = Hash.new(0) if !schedules.include? day

  from_hour = from.split(":")[0].to_i
  from_min = from_hour * 12 + from.split(":")[1].to_i / 5
  to_hour = to.split(":")[0].to_i
  to_min = to_hour * 12 + to.split(":")[1].to_i / 5
  (from_min..to_min - 1).each do |min|
    schedules[day][who] += 1 << -1 * (min - 18 * 12 + 1)
  end
  # p format("%.108b", schedules[day][who])
end
# print_schedule schedules

# 日付ごとにXとYと昼休みのor演算
# 0始まりまたは10と続くパターンが会議出席依頼を出さなければいけないところ
requests = 0
schedules.each do |day, schedule|
  # p "X: #{format("%.108b", schedule[YUKA])}"
  # p "Y: #{format("%.108b", schedule[Y])}"
  blank_times = format("%.108b", schedule[YUKA] | schedule[Y] | 2 ** 12 - 1 << -1 * (13 * 12 - 18 * 12))
  # p "#{day}: #{blank_times}"
  requests += blank_times.scan(/10/).length
  requests += blank_times.scan(/^0/).length
end
p requests