RSpec.configure do |config|
  config.include SunspotMatchers
  config.before do
    Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)
  end
end
