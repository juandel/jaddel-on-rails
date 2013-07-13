class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
    	#t.integer "subject_id"
    	t.references :subject
    	t.string "name", :limit => 20
    	t.string "permalink", :limit => 10
    	t.integer "position"
    	t.boolean "visible", :default => false
      t.timestamps
    end
    add_index("pages","subject_id")
    add_index("pages", "permalink")
  end
end



# Pages
#   name 
#   permalink
#   position
#   visible