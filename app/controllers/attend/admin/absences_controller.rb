class Attend::Admin::AbsencesController < Attend::Admin::BaseController
  before_action :set_absence, only: [:show, :trigger, :edit, :update, :destroy]

  def index
    q_params = params.fetch(:q, {}).permit('member.name')
    q_params.merge! params.permit(:member_id, :id)

    @absences = Absence.default_where(q_params).order(id: :desc).page(params[:page])
  end

  def my
    q_params = {
      member_id: current_member.child_ids
    }.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit('member.name')
    q_params.merge! params.permit(:member_id, :id)

    @absences = Absence.default_where(q_params).order(id: :desc).page(params[:page])

    render :my, layout: 'my'
  end

  def new
    @absence = Absence.new
  end

  def create
    @absence = Absence.new(absence_params)

    if @absence.save
      redirect_to admin_absences_url, notice: 'Absence was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def trigger
    @absence.do_trigger(state: params[:state], auditor_id: current_member.id)
    redirect_to admin_absences_url(member_id: @absence.member_id)
  end

  def edit
  end

  def update
    if @absence.update(absence_params)
      redirect_to admin_absences_url, notice: 'Absence was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @absence.destroy
    redirect_to admin_absences_url, notice: 'Absence was successfully destroyed.'
  end

  private
  def set_absence
    @absence = Absence.find(params[:id])
  end

  def absence_params
    params.fetch(:absence, {}).permit(
      :state,
      :start_at,
      :finish_at,
      :note
    )
  end

end
