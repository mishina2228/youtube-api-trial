# frozen_string_literal: true

module SystemTestSupport
  def capture(filename: nil)
    filename ||= "screenshot-#{Time.current.strftime('%Y%m%dT%H%M%S%L')}.png"
    path = Rails.root.join("tmp/screenshots/#{filename}")
    page.save_screenshot(path)
    puts "Saved screenshot to #{path}"
  end

  def javascript_errors
    page.driver.browser.logs.get(:browser).map(&:message)
  end
end
