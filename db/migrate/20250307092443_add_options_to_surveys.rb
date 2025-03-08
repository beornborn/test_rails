# frozen_string_literal: true

class AddOptionsToSurveys < ActiveRecord::Migration[7.1]
  def change
    add_column :surveys, :options, :json, null: false, default: []
  end
end
