class Init < ActiveRecord::Migration[4.2]
  def change
    create_table :test_cases do |t|
      t.string :name
      t.float :time
      t.string :classname
      t.string :file
    end

    create_table :builds do |t|
      t.integer :number
      t.integer :tests
      t.integer :failures
      t.integer :errors
      t.float :time
      t.timestamp :datetime
      t.references :test_cases
    end
  end
end