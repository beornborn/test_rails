# frozen_string_literal: true

class AddParanoiaToResponses < ActiveRecord::Migration[7.1]
  def change
    add_column :responses, :deleted_at, :datetime
    add_index :responses, :deleted_at
  end
end
