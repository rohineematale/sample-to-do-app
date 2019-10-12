class TasksController < ApplicationController
  before_action :get_task, only: [:show, :edit, :update, :update_task, :destroy]

  def index
    all_tasks = current_user.tasks.order("sequence ASC")
    @pending_tasks = all_tasks.select{|task| (task.status == 'pending') && (task.due_date != Date.today)}
    @due_tasks = all_tasks.select{|task| (task.status == 'pending') && (task.due_date == Date.today)}
    @closed_tasks = all_tasks.select{|task| task.status == 'completed'}
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(tasks_params)
    if @task.save
      redirect_to tasks_path
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @task.update_attributes(tasks_params)
      redirect_to tasks_path
    else
      render :edit
    end
  end

  def update_task
    if @task.update_seq_status(params)
      render json: { success: true, sequence: @task.sequence, status: @task.status }
    else
      render json: { success: false, error: @task.errors.full_messages }
    end
  end

  def destroy
    if @task.destroy
      redirect_to tasks_path
    else
      redirect_to tasks_path
    end
  end

  private
    def tasks_params
      params.require(:task).permit(:id, :title, :description, :due_date, :status, :sequence)
    end

    def get_task
      @task = current_user.tasks.find(params[:id])
    end
end
