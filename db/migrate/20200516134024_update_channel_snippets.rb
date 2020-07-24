class UpdateChannelSnippets < ActiveRecord::Migration[6.0]
  def up
    Channel.transaction do
      Channel.find_each do |channel|
        if channel.title.blank? || channel.description.blank? ||
          channel.thumbnail_url.blank?
          next
        end
        channel.channel_snippets.create!(
          title: channel.title, description: channel.description,
          thumbnail_url: channel.thumbnail_url
        )
      end
    end
  end

  def down
    ChannelSnippet.destroy_all
  end
end
