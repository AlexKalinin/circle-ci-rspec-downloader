class AddBuildDataInfo < ActiveRecord::Migration[4.2]
  def change
    change_table(:builds) do |t|
      t.string :compare_url
      t.string :vcs_revision
      t.text :json_data
    end
  end
end