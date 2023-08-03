# frozen_string_literal: true

require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  test 'should get tag names that match parameters' do
    sign_in admin

    get tags_path(tag_name: 'c'), xhr: true
    assert_response :success
    tag_names = response.parsed_body
    assert_includes tag_names, 'science'
    assert_includes tag_names, 'technology'

    get tags_path(tag_name: 'science'), xhr: true
    assert_response :success
    tag_names = response.parsed_body
    assert_includes tag_names, 'science'
    assert_not_includes tag_names, 'technology'
  end

  test 'should get all tag names when no tag_name param' do
    sign_in admin

    get tags_path, xhr: true
    assert_response :success
    tag_names = response.parsed_body
    assert tag_names.present?
    expected = ActsAsTaggableOn::Tag.all.order(:name).pluck(:name)
    assert_equal expected, tag_names.sort
  end

  test 'should get all tag names when tag_name param is blank' do
    sign_in admin

    [nil, ''].each do |param|
      get tags_path(tag_name: param), xhr: true
      assert_response :success
      tag_names = response.parsed_body
      assert tag_names.present?
      expected = ActsAsTaggableOn::Tag.all.order(:name).pluck(:name)
      assert_equal expected, tag_names.sort
    end
  end

  test 'should not get tag names unless logged in' do
    assert_raise ActionController::RoutingError do
      get tags_path, xhr: true
    end
  end

  test 'should not get tag names if logged in as an user' do
    sign_in user

    assert_raise ActionController::RoutingError do
      get tags_path, xhr: true
    end
  end
end
