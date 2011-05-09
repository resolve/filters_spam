class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.string   "author"
      t.string   "email"
      t.string   "phone"
      t.text     "message"
      t.boolean  "spam",  :default => false
      t.timestamps
    end
  end
end
