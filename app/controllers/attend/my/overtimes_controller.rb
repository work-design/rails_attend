class Attend::My::OvertimesController < Attend::My::BaseController
  before_action :set_overtime, only: [:show, :edit, :update, :destroy]

  def index
    q_params = params.fetch(:q, {}).permit!
    @overtimes = current_member.overtimes.default_where(q_params).page(params[:page])
  end

  def new
    @overtime = current_member.overtimes.build
  end

  def create
    @overtime = current_member.overtimes.build(overtime_params)

    if @overtime.save
      redirect_to my_overtimes_url, notice: 'Overtime was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    @overtime.assign_attributes(overtime_params)
    @overtime.state = 'init' if @overtime.changed?

    if @overtime.save
      redirect_to my_overtimes_url, notice: 'Overtime was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @overtime.destroy
    redirect_to my_overtimes_url, notice: 'Overtime was successfully destroyed.'
  end

  private
  def set_overtime
    @overtime = Overtime.find(params[:id])
  end

  def overtime_params
    q = params.fetch(:overtime, {}).permit(
      :start_at,
      :finish_at,
      :note,
      :cc_emails
    )
    q[:cc_emails] = q[:cc_emails].to_s.split(/[,，]\s*/)
    q
  end

end
