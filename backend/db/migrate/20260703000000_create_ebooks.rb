class CreateEbooks < ActiveRecord::Migration[7.1]
  def change
    create_table :ebooks do |t|
      t.string :title, null: false
      t.string :author, null: false

      t.timestamps
    end
  end
end
