module Attend
  class Admin::FinancialMonthsController < Admin::BaseController
    before_action :set_financial_month, only: [:show, :events, :attendance_setting, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! default_params

      @financial_months = FinancialMonth.default_where(q_params).page(params[:page])
    end

    def events
    end

    def new
      @financial_month = FinancialMonth.new
    end

    def create
      @financial_month = FinancialMonth.new(financial_month_params)

      if @financial_month.save
        render 'create'
      else
        render :new
      end
    end

    def attendance_setting
      @financial_month.reset_attendance_settings
    end

    def show
    end

    def edit
    end

    def update
      @financial_month.assign_attributes(financial_month_params)

      if @financial_month.save
        render 'update'
      else
        render :edit
      end
    end

    def destroy
      @financial_month.destroy
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
      p.merge! default_form_params
    end

  end
end
