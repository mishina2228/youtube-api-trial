# frozen_string_literal: true

module SystemTestSupport
  def capture(filename: nil)
    filename ||= "screenshot-#{Time.current.strftime('%Y%m%dT%H%M%S%L')}.png"
    path = Rails.root.join("tmp/screenshots/#{filename}")
    page.save_screenshot(path)
    puts "Saved screenshot to #{path}"
  end
end
