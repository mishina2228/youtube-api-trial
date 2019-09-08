require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def test_print_number
    assert_equal '123', print_number(123)
    assert_equal '1,234', print_number(1234)
    assert_nil print_number(nil)
  end

  def test_print_link
    assert_dom_equal %{<a href="https://example.com">body</a>},
                     print_link('body', 'https://example.com')
    assert_dom_equal %{<a href="https://example.com">alternate</a>},
                     print_link('', 'https://example.com', 'alternate')
    assert_dom_equal %{<a href="https://example.com">body is missing</a>},
                     print_link('', 'https://example.com')
  end
end
