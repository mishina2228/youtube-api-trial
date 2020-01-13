require 'test_helper'

class Channel::UpdateAllSnippetsJobTest < ActiveSupport::TestCase
  def test_before_enqueue
    assert Channel::UpdateAllSnippetsJob.before_enqueue

    jobs = [{'class' => Channel::UpdateAllSnippetsJob.name}]
    JobUtils.stub(:peek, jobs) do
      assert_not Channel::UpdateAllSnippetsJob.before_enqueue
    end
  end

  def test_perform
    [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

    assert_nothing_raised do
      Channel::UpdateAllSnippetsJob.perform
    end
  end
end
