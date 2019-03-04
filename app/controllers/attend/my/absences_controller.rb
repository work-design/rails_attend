class Attend::My::AbsencesController < Attend::My::BaseController
  before_action :set_absence, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:redeeming] #todo removed

  def index
    @absences = current_member.absences.order(id: :desc).page(params[:page])
  end

  def dashboard
    current_month = FinancialMonth.current_month
    @month_count = current_member.absences.current_range_stat(current_month&.begin_date, current_month&.end_date)
    @year_stat = current_member.absent
  end

  def new
    @absence = current_member.absences.build
  end

  def create
    @absence = current_member.absences.build(absence_params)

    if @absence.save
      redirect_to my_absences_url, notice: 'Absence was successfully created.'
    else
      render :new
    end
  end

  def redeeming
    @absence = Absence.new(type: params[:type])
  end

  def show
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
  end

  def update
    @absence.assign_attributes(absence_params)
    @absence.state = 'init' if @absence.changed?

    if @absence.save
      redirect_to my_absences_url, notice: 'Absence was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @absence.destroy
    redirect_to my_absences_url, notice: 'Absence was successfully destroyed.'
  end

  private
  def set_absence
    @absence = Absence.find(params[:id])
  end

  def absence_params
    q = params.fetch(:absence, {}).permit(
      :kind,
      :type,
      :start_at,
      :finish_at,
      :note,
      :cc_emails,
      :updated_at,
      redeeming_days: []
    )
    q[:cc_emails] = q[:cc_emails].to_s.split(/[,，]\s*/)
    q.fetch(:redeeming_days, []).reject! { |i| i.blank? }
    q
  end

end
