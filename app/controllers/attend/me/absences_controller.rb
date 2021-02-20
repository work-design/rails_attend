module Attend
  class Me::AbsencesController < Me::BaseController
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

      unless @absence.save
        render :new, locals: { model: @absence }, status: :unprocessable_entity
      end
    end

    def redeeming
      @absence = Absence.new(type: params[:type])
    end

    def show
    end

    def edit
    end

    def update
      @absence.assign_attributes(absence_params)
      @absence.state = 'init' if @absence.changed?

      unless @absence.save
        render :edit, locals: { model: @absence }, status: :unprocessable_entity
      end
    end

    def destroy
      @absence.destroy
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
        :updated_at,
        redeeming_days: []
      )
      q.fetch(:redeeming_days, []).reject! { |i| i.blank? }
      q
    end

  end
end
