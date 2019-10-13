class TasksController < ApplicationController
  before_action :get_task, only: [:show, :edit, :update, :update_task, :destroy]

  def index
    all_tasks = current_user.tasks.order("sequence ASC")
    @pending_tasks = all_tasks.select{|task| (task.status == 'pending') && (task.due_date != Date.today)}
    @due_tasks = all_tasks.select{|task| (task.status == 'pending') && (task.due_date == Date.today)}
    @closed_tasks = all_tasks.select{|task| task.status == 'completed'}
    respond_to do |format|
      format.html
    end
  end

  def new
    @task = Task.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @task = current_user.tasks.build(tasks_params)
    respond_to do |format|
      if @task.save
        flash[:notice] = "Task successfully created"
        format.html{redirect_to tasks_path}
      else
        format.html{render :new}
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    respond_to do |format|
      if @task.update_attributes(tasks_params)
        flash[:notice] = "Task successfully updated"
        format.html{redirect_to tasks_path}
      else
        format.html{render :edit}
      end
    end
  end

  def update_task
    respond_to do |format|
      if @task.update_seq_status(params)
        response = {success: true, sequence: @task.sequence, status: @task.status, due_date: @task.formatted_date }
        format.json{render json: response}
      else
        response = { success: false, error: @task.errors.full_messages }
        format.json{render json: response}
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.js
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
