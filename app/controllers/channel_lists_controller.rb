# frozen_string_literal: true

class ChannelListsController < ApplicationController
  private

  def search_condition
    cond = ::Search::ChannelListCondition.new(search_params)
    cond.per ||= ChannelList::DEFAULT_PER
    cond
  end

  def search_params
    raise 'Must be implemented in an inherited class.'
  end
end
