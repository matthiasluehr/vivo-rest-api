class V1::UsersController < ApplicationController

    def index
        vivo = VIVO.new
        query = "
            SELECT
                ?uri
                WHERE {
                    ?uri a foaf:Person .
                    ?uri <http://vitro.mannlib.cornell.edu/ns/vitro/authorization#externalAuthId> \"#{params[:id]}\" .
                }
        "
        puts query
        r = vivo.query(query)
        if r.size > 0 
            result = {
                id: vivo.get_id(r[0]['uri']),
                uri: r[0]['uri'],
                api_uri: "https://vivo-rest-api.hs-mittweida.de/v1/persons/#{vivo.get_id(r[0]['uri'])}"
            }
            render json: result.to_json
        else
            head(:not_found)
        end
    end


end