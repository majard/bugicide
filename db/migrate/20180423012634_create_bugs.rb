class CreateBugs < ActiveRecord::Migration[5.0]
  def change
    create_table :bugs do |t|
      t.string :name
      t.text :description
      t.boolean :solved
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
