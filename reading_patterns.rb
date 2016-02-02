@memo_patterns = Hash.new
@pages_by_day = []

def solve_reading_patterns pages, limit, previous
  if limit == 1
    @pages_by_day << pages
    # p @pages_by_day if @pages_by_day.length == 4
    @pages_by_day.pop
    return 1 if limit == 1
  end
  key = "#{pages}:#{limit}:#{previous}"
  return @memo_patterns[key] if @memo_patterns.include? key 

  limit_tmp = pages - (limit * (limit - 1)) / 2
  todays_limit = previous - 1 < limit_tmp ? previous - 1 : limit_tmp
  todays_quota = ((limit.to_f**2-limit+2*pages)/(2*limit)).ceil

  # p "****pages: #{pages}, limit: #{limit}****"
  # p "limit: #{todays_limit}"
  # p "quota: #{todays_quota}"

  patterns = 0
  (todays_quota..todays_limit).each do |page|
    @pages_by_day << page
    patterns += solve_reading_patterns pages-page, limit-1, page
    @pages_by_day.pop
  end

  @memo_patterns[key] = patterns
  patterns
end

pages, limit = STDIN.gets.chomp!.split(',').map{|num| num.to_i}

answer = 0
(1..limit).each do |days|
  answer += solve_reading_patterns pages, days, Float::INFINITY
end
puts answer