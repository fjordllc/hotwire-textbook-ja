class Task < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true
  has_many :comments, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  enum :status, { todo: 0, in_progress: 1, done: 2 }, default: :todo, validate: true

  validates :title, presence: true

  # 一覧条件は受信者ごとに異なるので、行を一律に配信しない。
  after_commit :announce_change
  after_create_commit :notify_assignee
  after_update_commit :notify_assignee, if: :saved_change_to_assignee_id?

  private

  def announce_change
    Turbo::StreamsChannel.broadcast_update_to :tasks, target: "task_changes",
      partial: "tasks/change"
  end

  def notify_assignee
    return unless assignee
    Turbo::StreamsChannel.broadcast_append_to assignee, target: "toasts",
      partial: "toasts/toast", locals: { message: "新しいタスクが割り当てられました。" }
  end
end
