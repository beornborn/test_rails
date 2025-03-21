# frozen_string_literal: true

class AddUserToSurveys < ActiveRecord::Migration[7.1]
  def change
    add_reference :surveys, :user, null: false, foreign_key: true
  end
end
