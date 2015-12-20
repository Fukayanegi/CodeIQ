Dir[File.expand_path('./', __FILE__) << '/*.rb'].each do |file|
  require file
end

require 'minitest/autorun'

class TestMayoiDoro < MiniTest::Unit::TestCase
  def setup
  end

  def tear_down
  end

  def test_0
  end
end
