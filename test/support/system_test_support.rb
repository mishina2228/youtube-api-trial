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

  def wait_for_turbo(timeout = nil)
    return unless has_css?('.turbo-progress-bar', visible: true, wait: 0.25.seconds)

    has_no_css?('.turbo-progress-bar', wait: timeout.presence || 5.seconds)
  end

  def wait_for_turbo_frame(selector = 'turbo-frame', timeout = nil)
    return unless has_selector?("#{selector}[busy]", visible: true, wait: 0.25.seconds)

    has_no_selector?("#{selector}[busy]", wait: timeout.presence || 5.seconds)
  end
end
