class RenamerecepientTorecipientInConversations < ActiveRecord::Migration[5.0]
  def change
    rename_column(:conversations, :recepient_id, :recipient_id)
  end
end
