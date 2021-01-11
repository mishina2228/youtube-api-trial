require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  def test_sortable
    # TODO: refactor
  end

  test 'print_link' do
    assert_dom_equal %{<a href="https://example.com">body</a>},
                     print_link('body', 'https://example.com')
    assert_dom_equal %{<a href="https://example.com">alternate</a>},
                     print_link('', 'https://example.com', 'alternate')
    assert_dom_equal %{<a href="https://example.com">body is missing</a>},
                     print_link('', 'https://example.com')
    assert_dom_equal %{<a target="_blank" href="https://example.com">body</a>},
                     print_link('body', 'https://example.com', nil, target: '_blank')
    assert_dom_equal %{<a target="_blank" rel="noopener" href="https://example.com">body</a>},
                     print_link('body', 'https://example.com', nil, target: '_blank', rel: 'noopener')
  end

  test 'print_number' do
    assert_equal '123', print_number(123)
    assert_equal '1,234', print_number(1234)
    assert_nil print_number(nil)
  end

  test 'print_diff_numbers' do
    assert_nil print_diff_numbers(nil, nil)
    assert_nil print_diff_numbers(nil, 1)
    assert_nil print_diff_numbers(1, nil)

    assert '+10,001', print_diff_numbers(10_000, 1)
    assert '±0', print_diff_numbers(10_000, 10_000)
    assert '-9,999', print_diff_numbers(1, 10_000)
  end

  test 'print_diff_datetimes' do
    print_diff_datetimes(nil, nil)
    print_diff_datetimes(nil, Time.zone.now)
    print_diff_datetimes(Time.zone.now, nil)

    actual = print_diff_datetimes(Time.zone.now - 3.days, Time.zone.now)
    expected = distance_of_time_in_words(Time.zone.now - 3.days, Time.zone.now)
    assert_equal expected, actual
  end

  test 'text_url_to_link' do
    assert_nil text_url_to_link(nil)
    assert_nil text_url_to_link('')

    assert_equal 'abc', text_url_to_link('abc')
    input = 'https://example.com'
    expected = %{<a target="_blank" rel="noopener" href="https://example.com">https://example.com</a>}
    assert_dom_equal expected, text_url_to_link(input)
    input = 'My URL: https://example.com'
    expected = %{My URL: <a target="_blank" rel="noopener" href="https://example.com">https://example.com</a>}
    assert_dom_equal expected, text_url_to_link(input)
  end
end
