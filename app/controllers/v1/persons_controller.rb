class V1::PersonsController < ApplicationController

    def index
        result = []
        Person.all.each do |p|
            result.push({
                id: p.vivo_uri.gsub(/\>$/, '').split(/\//).pop,
                uri: p.vivo_uri,
                label: p.label
            })
        end
        render json: result
    end

    def make_vivo_uri(id)
        "<https://vivo.hs-mittweida.de/vivo/individual/#{id}>"
    end

    def get_person

        p = Person.find_by_vivo_uri(make_vivo_uri(params[:id]))
        render json: {
                id: p.vivo_uri.gsub(/\>$/, '').split(/\//).pop,
                uri: p.vivo_uri,
                label: p.label,
                info: p.info,
                contact_information: p.contact_information
            }
    end

    def get_attribute
        p = Person.find_by_vivo_uri(make_vivo_uri(params[:id]))
        render json: p.send(params[:attribute])
    end

#    def publications
#        p = Person.find_by_vivo_uri(make_vivo_uri(params[:id]))
#        render json: p.publications
#    end
#
#    def projects
#        p = Person.find_by_vivo_uri(make_vivo_uri(params[:id]))
#        render json: p.projects
#    end

end