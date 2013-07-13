class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
    	#t.references :page
    	t.integer "page_id"
    	t.string "name", :limit => 20
    	t.integer "position"
    	t.boolean "visible", :default => false
    	t.string "content_type", :limit => 50
    	t.text "content"
      t.timestamps
    end
    add_index("sections","page_id")
  end
end
# Sections
#   name
#   position
#   visible
#   content_type string
#   content text
