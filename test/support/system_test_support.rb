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

  def filtered_javascript_errors
    ignore_error_messages = [
      'Failed to load resource: the server responded with a status of 404 ()',
      'Failed to load resource: the server responded with a status of 422 (Unprocessable Content)'
    ]
    javascript_errors.reject do |message|
      ignore_error_messages.any? {|ignore| message.include?(ignore)}
    end
  end
end
