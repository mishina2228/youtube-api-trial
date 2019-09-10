require 'test_helper'

class Channel::UpdateAllSnippetsJobTest < ActiveSupport::TestCase
  def test_perform
    [channels(:エラーチャンネル), channels(:存在しないチャンネル)].each(&:destroy)

    assert_nothing_raised do
      Channel::UpdateAllSnippetsJob.perform
    end
  end
end
