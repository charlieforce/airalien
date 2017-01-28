class AddProfilePictureToUser < ActiveRecord::Migration[5.0]
  def self.up
    change_table :users do |t|
      t.attachment :profile_picture
    end
  end

  def self.down
    remove_attachment :photos, :profile_picture
  end
end
