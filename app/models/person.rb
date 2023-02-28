class Person < ActiveRecord::Base
    self.table_name = 'persons'

    def Person.sync_from_vivo
        vivo = VIVO.new

        query = "SELECT ?uri ?label WHERE { ?uri a foaf:Person . ?uri rdfs:label ?label . }"
        result = vivo.query(query)

        result.each do |person|
            uri = "<#{person['uri']}>"
            label = person['label']
            if !p = Person.find_by_vivo_uri(uri)
                p = Person.new
                p.vivo_uri = uri
                p.label = label
                p.save
                p.set_info
                p.set_contact_information
                p.set_publications
                p.set_projects
                # p.set_events
            else
                # TODO: perform update
                puts "Updating person #{uri}."
                p.set_info
                p.set_contact_information
                # p.set_publications
                # p.set_projects
                # p.set_events
            end

        end

    end


    def set_publications
        vivo = VIVO.new
        query = "
            SELECT ?uri ?label WHERE
            {
                #{self.vivo_uri} vivo:relatedBy ?authorship  .
                ?authorship a vivo:Authorship .
                ?authorship vivo:relates ?uri .
                ?uri a bibo:Document .
                ?uri rdfs:label ?label .
            }
        "
        result = []
        vivo.query(query).each do |row|
            id = row['uri'].split(/\//).pop
            uri = "<#{row['uri']}>"
            label = row['label']
            result.push({
                id: id,
                uri: uri,
                label: label
            })
        end
        self.publications = result.to_json
        self.save
    end


    def set_projects
        vivo = VIVO.new
        query = "
            SELECT ?uri ?label WHERE
            {
                #{self.vivo_uri} obo:RO_0000053 ?rr  .
                ?rr a vivo:ResearcherRole .
                ?rr vivo:relatedBy ?uri .
                ?uri a <http://kerndatensatz-forschung.de/owl/Basis#Drittmittelprojekt> .
                ?uri rdfs:label ?label .
            }
        "
        result = []
        vivo.query(query).each do |row|
            id = row['uri'].split(/\//).pop
            uri = "<#{row['uri']}>"
            label = row['label']
            result.push({
                id: id,
                uri: uri,
                label: label
            })
        end
        self.projects = result.to_json
        self.save
    end

    def set_info
        vivo = VIVO.new
        query = "
            SELECT ?overview ?researchOverview WHERE
            {
              OPTIONAL {  
                #{self.vivo_uri} vivo:overview ?overview .
              }
              OPTIONAL { 
               #{self.vivo_uri} vivo:researchOverview ?researchOverview .
              }
          }
        "
        row = vivo.query(query)
        if row then
          self.info = {
                overview: row[0]['overview'],
                research_overview: row[0]['researchOverview']
          }
          self.save
        end
    end

    def set_contact_information
        vivo = VIVO.new
        emails = []
        phones = []
        home_pages = []
        adresses = []
        query = "
            SELECT
                ?first_name ?last_name
                ?title
                ?room
                ?email
                ?phone
                ?home_page_url
                ?home_page_title
                ?zip
                ?locality
                ?street
            WHERE {
                OPTIONAL {
                    #{self.vivo_uri} <http://purl.obolibrary.org/obo/ARG_2000028> ?vcard .
                    ?vcard a <http://www.w3.org/2006/vcard/ns#Individual> .
                    OPTIONAL {
                        ?vcard <http://www.w3.org/2006/vcard/ns#hasName> ?vcardName .
                        ?vcardName <http://www.w3.org/2006/vcard/ns#givenName> ?firstName .
                        ?vcardName <http://www.w3.org/2006/vcard/ns#familyName> ?lastName .
                    }
                    OPTIONAL {
                        ?vcard <http://www.w3.org/2006/vcard/ns#hasTitle> ?vcardTitle .
                        ?vcardTitle <http://www.w3.org/2006/vcard/ns#title> ?title .
                    }
                    OPTIONAL {
                        ?vcard <http://www.w3.org/2006/vcard/ns#hasEmail> ?vcardEmail .
                        ?vcardEmail <http://www.w3.org/2006/vcard/ns#email> ?email .
                    }
                    OPTIONAL {
                        ?vcard <http://www.w3.org/2006/vcard/ns#hasTelephone> ?vcardPhone .
                        ?vcardPhone <http://www.w3.org/2006/vcard/ns#telephone> ?phone .
                    }
                    OPTIONAL {
                        ?vcard <http://www.w3.org/2006/vcard/ns#hasURL> ?vcardURL .
                        ?vcardURL <http://www.w3.org/2006/vcard/ns#url> ?home_page_url .
                        ?vcardURL rdfs:label ?home_page_title .
                    }
                    OPTIONAL {
                        ?vcard <http://www.w3.org/2006/vcard/ns#hasAddress> ?vcardAddress .
                        ?vcardAddress <http://www.w3.org/2006/vcard/ns#postalCode> ?zip .
                        ?vcardAddress <http://www.w3.org/2006/vcard/ns#locality> ?locality .
                        ?vcardAddress <http://www.w3.org/2006/vcard/ns#streetAddress> ?street .
                    }
                }
                OPTIONAL {
                    #{self.vivo_uri} <http://purl.obolibrary.org/obo/RO_0001025> ?roomUri .
                    ?roomUri a vivo:Room .
                    ?roomUri rdfs:label ?room .
                }
            }
        "
        ci = {}
        vivo.query(query).each do |row|
            emails.push(row['email']) if row['email']
            phones.push(row['phone']) if row['phone']
            if row['home_page_url'] then
                home_pages.push({
                    url: row['home_page_url'],
                    title: row['home_page_title']
                })
            end
            ci['title'] = row['title'] if row['title']
            ci['first_name'] = row['title'] if row['first_name']
            ci['last_name'] = row['title'] if row['last_name']
            ci['room'] = row['room'] if row['room']
            ci['zip'] = row['zip'] if row['zip']
            ci['locality'] = row['locality'] if row['locality']
            ci['street'] = row['street'] if row['street']
        end
        ci['emails'] = emails.uniq
        ci['phones'] = phones.uniq
        ci['home_pages'] = home_pages.uniq 
        self.contact_information = ci.to_json
        self.save
    end

    def set_events

    end


    #def initialize(id)
    #    @vivo = VIVO.new
    #    @id = id
    #    @uri = @vivo.make_uri(id)
    #end

end
