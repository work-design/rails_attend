class Attend::Admin::AbsenceStatsController < Attend::Admin::BaseController
  before_action :set_absence_stat, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}.with_indifferent_access
    q_params.merge! params.fetch(:q, {}).permit!
    @absence_stats = AbsenceStat.default_where(q_params).page(params[:page])
  end

  def new
    @absence_stat = AbsenceStat.new
  end

  def create
    @absence_stat = AbsenceStat.new(absence_stat_params)

    if @absence_stat.save
      redirect_to admin_absence_stats_url, notice: 'Absence stat was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @absence_stat.update(absence_stat_params)
      redirect_to admin_absence_stats_url, notice: 'Absence stat was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @absence_stat.destroy
    redirect_to admin_absence_stats_url, notice: 'Absence stat was successfully destroyed.'
  end

  private
  def set_absence_stat
    @absence_stat = AbsenceStat.find(params[:id])
  end

  def absence_stat_params
    params.fetch(:absence_stat, {}).permit(
      :member_id,
      :annual_days,
      :annual_add,
      :year
    )
  end

end
