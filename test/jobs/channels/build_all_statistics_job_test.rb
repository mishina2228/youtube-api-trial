require 'test_helper'

module Channels
  class BuildAllStatisticsJobTest < ActiveSupport::TestCase
    def test_before_enqueue
      assert Channels::BuildAllStatisticsJob.before_enqueue

      jobs = [{'class' => Channels::BuildAllStatisticsJob.name}]
      JobUtils.stub(:peek, jobs) do
        assert_not Channels::BuildAllStatisticsJob.before_enqueue
      end
    end

    def test_perform
      [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

      assert_nothing_raised do
        Channels::BuildAllStatisticsJob.perform
      end
    end
  end
end
