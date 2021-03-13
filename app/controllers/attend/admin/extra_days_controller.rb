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
        render 'create'
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      @extra_day.assign_attributes(extra_day_params)

      if @extra_day.save
        render 'update'
      else
        render :edit
      end
    end

    def destroy
      @extra_day.destroy
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
