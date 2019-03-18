class Attend::Admin::FinancialMonthsController < Attend::Admin::BaseController
  before_action :set_financial_month, only: [:show, :attendance_setting, :edit, :update, :destroy]

  def index
    q_params = default_params
    @financial_months = FinancialMonth.default_where(q_params).page(params[:page])
  end

  def events
    @financial_month = FinancialMonth.default_where('begin_date-gte': params[:start], 'end_date-lte': params[:end]).first

    if @financial_month
      render 'events'
    else
      render json: { events: [] }
    end
  end

  def new
    @financial_month = FinancialMonth.new
  end

  def create
    @financial_month = FinancialMonth.new(financial_month_params)

    if @financial_month.save
      redirect_to admin_financial_months_url, notice: 'Financial month was successfully created.'
    else
      render :new
    end
  end

  def attendance_setting
    @financial_month.reset_attendance_settings
    redirect_to admin_financial_months_url, notice: 'Financial month was successfully reset attendance setting.'
  end

  def show
  end

  def edit
  end

  def update
    if @financial_month.update(financial_month_params)
      redirect_to admin_financial_months_url, notice: 'Financial month was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @financial_month.destroy
    redirect_to admin_financial_months_url, notice: 'Financial month was successfully destroyed.'
  end

  private
  def set_financial_month
    @financial_month = FinancialMonth.find(params[:id])
  end

  def financial_month_params
    p = params.fetch(:financial_month, {}).permit(
      :begin_date,
      :end_date,
      :color,
      :working_days
    )
    p.merge! default_params
  end

end
