module Attend
  class Admin::ExtraDaysController < Admin::BaseController
    before_action :set_extra_day, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! default_params

      @extra_days = ExtraDay.default_where(q_params).page(params[:page])
    end

    def new
      @extra_day = ExtraDay.new
    end

    def create
      @extra_day = ExtraDay.new(extra_day_params)

      if @extra_day.save
        redirect_to admin_extra_days_url
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
        redirect_to admin_extra_days_url
      else
        render :edit
      end
    end

    def destroy
      @extra_day.destroy
      redirect_to admin_extra_days_url
    end

    private
    def set_extra_day
      @extra_day = ExtraDay.find(params[:id])
    end

    def extra_day_params
      p = params.fetch(:extra_day, {}).permit(
        :name,
        :the_day,
        :kind,
        :scope,
        :country
      )
      p.merge! default_form_params
    end

  end
end
