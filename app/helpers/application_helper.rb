module ApplicationHelper
  def render_notices
    render partial: 'partials/notices'
  end

  def print_link(body, url, alt = 'body is missing')
    if body.present?
      link_to body, url
    else
      link_to alt, url
    end
  end
end
