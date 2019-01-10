class Oa::Admin::ExtraDaysController < Oa::Admin::BaseController
  before_action :set_extra_day, only: [:show, :edit, :update, :destroy]

  def index
    q_params = params.fetch(:q, {}).permit!
    @extra_days = ExtraDay.default_where(q_params).page(params[:page])
  end

  def new
    @extra_day = ExtraDay.new
  end

  def create
    @extra_day = ExtraDay.new(extra_day_params)

    if @extra_day.save
      redirect_to admin_extra_days_url, notice: 'Extra day was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @extra_day.update(extra_day_params)
      redirect_to admin_extra_days_url, notice: 'Extra day was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @extra_day.destroy
    redirect_to admin_extra_days_url, notice: 'Extra day was successfully destroyed.'
  end

  private
  def set_extra_day
    @extra_day = ExtraDay.find(params[:id])
  end

  def extra_day_params
    params.fetch(:extra_day, {}).permit(
      :name,
      :the_day,
      :kind,
      :scope,
      :country
    )
  end

end
