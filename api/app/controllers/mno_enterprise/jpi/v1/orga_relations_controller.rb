module MnoEnterprise
  class Jpi::V1::OrgaRelationsController < Jpi::V1::BaseResourceController

    # GET /mnoe/jpi/v1/orga_relations
    def index
      if params[:terms]
        # For search mode
        @orga_relations = []
        JSON.parse(params[:terms]).map { |t| @orga_relations = @orga_relations | orga_relations.where(Hash[*t]) }
        response.headers['X-Total-Count'] = @orga_relations.count
      else
        @orga_relations = orga_relations
        @orga_relations = @orga_relations.limit(params[:limit]) if params[:limit]
        @orga_relations = @orga_relations.skip(params[:offset]) if params[:offset]
        @orga_relations = @orga_relations.order_by(params[:order_by]) if params[:order_by]
        @orga_relations = @orga_relations.where(params[:where]) if params[:where]
        @orga_relations = @orga_relations.all.fetch
        response.headers['X-Total-Count'] = @orga_relations.metadata[:pagination][:count]
      end
    end

    # GET /mnoe/jpi/v1/orga_relations/1
    def show
      orga_relation
      render_not_found('orga relation') unless @orga_relation
    end

    private

    def orga_relations
      @orga_relations ||= MnoEnterprise::OrgaRelation
    end

    def orga_relation
      @orga_relation ||= MnoEnterprise::OrgaRelation.find(params[:id].to_i)
    end
  end
end