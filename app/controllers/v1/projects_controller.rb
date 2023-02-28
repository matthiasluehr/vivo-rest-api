class V1::ProjectsController < ApplicationController

    def index
        result = []
        Project.all.each do |p|
            result.push({
                id: p.vivo_uri.gsub(/\>$/, '').split(/\//).pop,
                uri: p.vivo_uri,
                label: p.label
            })
        end
        render json: result.to_json
    end

    def get_attribute
        p = Project.find_by_vivo_uri("<https://vivo.hs-mittweida.de/vivo/individual/#{params['id']}>")
        render json: p.send(params['attribute'])
    end

end