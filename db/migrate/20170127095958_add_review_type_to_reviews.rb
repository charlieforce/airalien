class AddReviewTypeToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :review_type, :string , :default => "room review"
  end
end
