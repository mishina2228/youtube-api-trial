require 'test_helper'

module Channel
  class BuildAllStatisticsJobTest < ActiveSupport::TestCase
    def test_before_enqueue
      assert Channel::BuildAllStatisticsJob.before_enqueue

      jobs = [{'class' => Channel::BuildAllStatisticsJob.name}]
      JobUtils.stub(:peek, jobs) do
        assert_not Channel::BuildAllStatisticsJob.before_enqueue
      end
    end

    def test_perform
      [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

      assert_nothing_raised do
        Channel::BuildAllStatisticsJob.perform
      end
    end
  end
end
