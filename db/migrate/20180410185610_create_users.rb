class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true}
      t.string :password, null: false
      t.string :name
      t.text :description
      t.timestamps
    end
  end
end
