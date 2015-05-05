module CapybaraHelpers
  def waitFor
    start = Time.now
    while true
      break if yield
      fail "Timeout in #{__FILE__}" if Time.now > start + 5.seconds
      sleep 0.5
    end
  end
end
