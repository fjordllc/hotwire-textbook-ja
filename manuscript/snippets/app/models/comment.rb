class Comment < ApplicationRecord
  belongs_to :task
  belongs_to :user

  after_create_commit -> { broadcast_append_to task, :comments,
    target: ActionView::RecordIdentifier.dom_id(task, :comments) }
  after_destroy_commit -> { broadcast_remove_to task, :comments }

  validates :body, presence: true
end
