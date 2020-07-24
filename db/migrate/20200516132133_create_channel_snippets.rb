class CreateChannelSnippets < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_snippets do |t|
      t.belongs_to :channel, index: true, null: false
      t.string :title
      t.string :description
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
