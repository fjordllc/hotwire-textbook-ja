class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  PER_PAGE = 20

  def index
    @task = Task.new
    scope = filtered_tasks
    @total_count = scope.count
    @page = [ params[:page].to_i, 1 ].max
    @paged_tasks = scope.offset((@page - 1) * PER_PAGE).limit(PER_PAGE)
    @next_page = @page + 1 if @total_count > @page * PER_PAGE
    @mode = %w[more infinite].include?(params[:mode]) ? params[:mode] : "pages"
    respond_to do |format|
      format.html
      format.turbo_stream do
        if @mode != "pages" && params[:page].present?
          render :index
        else
          render :index, formats: [ :html ], content_type: "text/html"
        end
      end
    end
  end

  def show
    @comment = Comment.new
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "タスクを作成しました。" }
        format.html { redirect_to @task, notice: "タスクを作成しました。", status: :see_other }
      end
    elsif turbo_frame_request_id == "modal"
      render :new, formats: [ :html ], status: :unprocessable_entity
    elsif params[:form_context] == "inline" && request.format.turbo_stream?
      render turbo_stream: turbo_stream.update("new_task_form", partial: "tasks/form",
        locals: { task: @task, context: "inline" }), status: :unprocessable_entity
    else
      render :new, formats: [ :html ], status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream { flash.now[:notice] = "タスクを更新しました。" }
        format.html { redirect_to @task, notice: "タスクを更新しました。", status: :see_other }
      end
    else
      render :edit, formats: [ :html ], status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy!
    respond_to do |format|
      format.turbo_stream { flash.now[:notice] = "タスクを削除しました。" }
      format.html { redirect_to tasks_path, notice: "タスクを削除しました。", status: :see_other }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.expect(task: [ :project_id, :title, :description, :status, :due_on, :assignee_id, tag_ids: [] ])
  end

  def filtered_tasks
    scope = Task.includes(:assignee, :tags).order(id: :desc)
    if params[:q].present?
      scope = scope.where("title LIKE ? ESCAPE ?", "%#{Task.sanitize_sql_like(params[:q])}%", "\\")
    end
    scope = scope.where(status: params[:status]) if params[:status].present?
    scope = scope.where(project_id: params[:project_id]) if params[:project_id].present?
    scope = scope.joins(:taggings).where(taggings: { tag_id: params[:tag_id] }).distinct if params[:tag_id].present?
    scope
  end
end
