class V1::PublicationsController < ApplicationController

    def index
        result = []
        Publication.all.each do |p|
            result.push({
                id: p.vivo_uri.gsub(/\>$/, '').split(/\//).pop,
                uri: p.vivo_uri,
                label: p.label
            })
        end
        render json: result
    end

    def show
        p = Publication.find_by_vivo_uri("<https://vivo.hs-mittweida.de/vivo/individual/#{params['id']}>")
        render json: p.info
    end

    def get_attribute
        p = Publication.find_by_vivo_uri("<https://vivo.hs-mittweida.de/vivo/individual/#{params['id']}>")
        render json: p.send(params['attribute'])
    end

end