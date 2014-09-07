require 'spec_helper'
require 'active_record'
require 'rygsaek/enclosure'

module Rygsaek
  
  describe Enclosure do
    before :each do
      ActiveRecord::Base.establish_connection( adapter: 'sqlite3', database: ':memory:')
      ActiveRecord::Schema.define do
        create_table :posts, froce: true do |t|
          t.string :title, default: 'post'
        end
        create_table :attachables, force: true do |t|
          t.integer :attachment_id
          t.integer :attachable_id
          t.string  :attachable_type
        end
        create_table :attachment, force: true do |t|
          t.string :title, default: 'attachment'
        end
          
      end
    end
    
    describe "self.manage_enclosures" do
      before :each do
        class ::Post < ActiveRecord::Base
          has_enclosures
        end
      end
      
      it "returns records belonging to one particular Post" do
        post1 = Post.create
        post1.attachables << Attachment.create
        expect(Post.all.count).to eq(1)
        expect(Post.attachables.all.count).to eq(1)
        expect(post1.attachments.all.count).to eq(1)
      end
    end
  end
end