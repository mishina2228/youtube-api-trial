require 'test_helper'

class Channel::BuildAllStatisticsJobTest < ActiveSupport::TestCase
  def test_perform
    [channels(:エラーチャンネル), channels(:存在しないチャンネル)].each(&:destroy)

    assert_nothing_raised do
      Channel::BuildAllStatisticsJob.perform
    end
  end
end
