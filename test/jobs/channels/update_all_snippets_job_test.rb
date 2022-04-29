# frozen_string_literal: true

require 'test_helper'

module Channels
  class UpdateAllSnippetsJobTest < ActiveSupport::TestCase
    def test_before_enqueue
      assert Channels::UpdateAllSnippetsJob.before_enqueue

      jobs = [{'class' => Channels::UpdateAllSnippetsJob.name}]
      JobUtils.stub(:peek, jobs) do
        assert_not Channels::UpdateAllSnippetsJob.before_enqueue
      end
    end

    def test_perform
      [channels(:error_channel), channels(:non_existing_channel)].each(&:destroy)

      assert_nothing_raised do
        Channels::UpdateAllSnippetsJob.perform
      end
    end
  end
end
