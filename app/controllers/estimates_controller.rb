class EstimatesController < ApplicationController
  before_action :authenticate_user!
  def new
    @estimate = Estimate.new
    @contractor = Contractor.find(params[:contractor_id])
  end

  def create
    @contractor = Contractor.find(params[:contractor_id])
    @estimate = @contractor.estimates.new(estimate_params)
    @estimate.user = current_user
    @estimate.save!
    flash[:notice] = "Orçamento solicitado com sucesso!"
    redirect_to @estimate
  end

  def show
    @estimate = Estimate.find_by(params[:id])
    authorize_estimate(@estimate)
  end

  private

  def estimate_params
    params.require(:estimate).permit(:title, :description, :location, :service_date, :day_shift, :photo)
  end

  def authorize_estimate(estimate)
    return if estimate.user == current_user
    
    redirect_to root_path
    flash[:alert] = 'Não é possível acessar este orçamento'
  end
end
