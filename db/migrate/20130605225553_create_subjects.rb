class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
    	t.string "name", :limit => 20
    	t.integer "position"
    	t.boolean "visible", :default => false
      t.timestamps
    end
  end
end
# subject
#   name string
#   position int
#   visible boolean
