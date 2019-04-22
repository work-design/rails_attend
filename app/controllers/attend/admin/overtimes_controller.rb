class Attend::Admin::OvertimesController < Attend::Admin::BaseController
  before_action :set_overtime, only: [:show, :edit, :update, :trigger, :destroy]

  def index
    q_params = params.fetch(:q, {}).permit!
    @overtimes = Overtime.default_where(q_params).order(id: :desc).page(params[:page])
  end

  def my
    q_params = {
      member_id: current_member.child_ids
    }.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit('member.name')
    q_params.merge! params.permit(:member_id)

    @overtimes = Overtime.default_where(q_params).order(id: :desc).page(params[:page])

    render :my, layout: 'my'
  end

  def show
  end

  def edit
  end

  def update
    if @overtime.update(overtime_params)
      redirect_to admin_overtimes_url
    else
      render :edit
    end
  end

  def trigger
    @overtime.do_trigger(state: params[:state], auditor_id: current_member.id)
    redirect_to admin_overtimes_url(member_id: @overtime.member_id)
  end

  def destroy
    @overtime.destroy
    redirect_to admin_overtimes_url
  end

  private
  def set_overtime
    @overtime = Overtime.find(params[:id])
  end

  def overtime_params
    params.fetch(:overtime, {}).permit(
      :state,
      :note
    )
  end

end
