# This migration comes from faalis (originally 20131020124701)
class CreateFaalisGroups < ActiveRecord::Migration
  def change
    create_table :faalis_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
