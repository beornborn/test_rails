# frozen_string_literal: true

class AddParanoiaToSurveys < ActiveRecord::Migration[7.1]
  def change
    add_column :surveys, :deleted_at, :datetime
    add_index :surveys, :deleted_at
  end
end
