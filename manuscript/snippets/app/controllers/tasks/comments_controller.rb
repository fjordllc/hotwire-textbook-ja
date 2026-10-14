# 第16章: コメントの追加・削除を Turbo Streams で
class Tasks::CommentsController < ApplicationController
  before_action :set_task

  def create
    @comment = @task.comments.build(comment_params.merge(user: Current.user))
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(helpers.dom_id(@task, :comment_form),
            partial: "comments/form", locals: { task: @task, comment: @comment }), status: :unprocessable_entity
        end
        format.html { render "tasks/show", status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = @task.comments.find(params[:id])
    @comment.destroy!
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@comment) }
      format.html { redirect_to @task }
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.expect(comment: [ :body ])
  end
end
