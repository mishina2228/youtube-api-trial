# frozen_string_literal: true

class TagsController < ApplicationController
  def index
    tags = ActsAsTaggableOn::Tag.named_like(params[:tag_name] || '').order(:name).pluck(:name)
    render json: tags.to_json
  end
end
