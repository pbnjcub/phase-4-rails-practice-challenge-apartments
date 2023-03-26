class TenantsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        tenants = Tenant.all
        render json: tenants, include: :apartments
    end

    def show
        tenant = find_tenant
        render json: tenant, include: :apartments
    end

    def create
        tenant = Tenant.create!(tenant_params)
        if tenant.valid?
            render json: tenant, status: :created
        else
            render json: { errors: tenant.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        tenant = find_tenant
        tenant.update!(tenant_params)
        render json: tenant
    end

    def destroy
        tenant = find_tenant
        tenant.destroy
        head :no_content
    end

    private

    def find_tenant
        Tenant.find(params[:id])
    end

    def tenant_params
        params.permit(:name, :age, :apartment_id)
    end

    def render_not_found_response
        render json: { error: "Tenant not found" }, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end
