class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.float :percent_complete
      t.integer :number

      t.timestamps
    end
  end
end
