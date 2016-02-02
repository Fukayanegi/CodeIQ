@memo_patterns = Hash.new

def solve_reading_patterns pages, limit
  return 1 if limit == 1
  key = "#{pages}:#{limit}"
  return @memo_patterns[key] if @memo_patterns.include? key 

  todays_limit = pages - (limit * (limit - 1)) / 2
  todays_quota = ((limit.to_f**2-limit+2*pages)/(2*limit)).ceil

  # p "****pages: #{pages}, limit: #{limit}****"
  # p "limit: #{todays_limit}"
  # p "quota: #{todays_quota}"

  patterns = 0
  (todays_quota..todays_limit).each do |page|
    patterns += solve_reading_patterns pages-page, limit-1
  end

  @memo_patterns[key] = patterns
  patterns
end

pages, limit = STDIN.gets.chomp!.split(',').map{|num| num.to_i}

answer = 0
(1..limit).each do |days|
  answer += solve_reading_patterns pages, days
end
puts answer