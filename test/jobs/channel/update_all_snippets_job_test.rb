require 'test_helper'

class Channel::UpdateAllSnippetsJobTest < ActiveSupport::TestCase
  def test_perform
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

    assert_nothing_raised do
      Channel::UpdateAllSnippetsJob.perform
    end
  end
end
