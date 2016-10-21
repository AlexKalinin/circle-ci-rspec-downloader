class Init < ActiveRecord::Migration[4.2]
  def change
    create_table :builds do |t|
      t.integer :number
      t.integer :total_tests
      t.integer :total_failures
      t.integer :total_errors
      t.float :total_time
      t.timestamp :build_date
    end

    create_table :specs do |t|
      t.string :name
      t.float :time
      t.string :classname
      t.string :file
      t.references :build, index: true
      t.boolean :failed
      t.string :failue_message
      t.string :failue_type
      t.text :failue_text
    end
  end
end