module Attend
  class Me::CalendarsController < Me::BaseController

    def show
      q_params = {
        department_id: current_member.department_id
      }
      q_params.merge! Department.extract_multi_attributes q_params

      @department = Department.find @query_params[:department_id]
    end

    def events
      @financial_months = FinancialMonth.default_where('end_date-gte': params[:start], 'begin_date-lte': params[:end])
      department = Department.find params[:department_id] if params[:department_id]
      department ||= current_member.department
      department_ids = department.self_and_descendant_ids
      @absence_events = Absence.current_range_events(params[:start], params[:end], department_ids)

      if @financial_months
        render 'events'
      else
        render json: { events: [] }
      end
    end

    private
    def calendar_params
      params.fetch(:calendar, {}).permit()
    end

  end
end
