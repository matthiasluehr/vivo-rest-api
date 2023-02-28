class Publication < ActiveRecord::Base
    self.table_name = 'publications'
    has_many :authorships, :class_name => 'Author', :foreign_key => 'publication_id'

    def Publication.sync_from_vivo
        vivo = VIVO.new

        query = "SELECT ?uri ?label WHERE { ?uri a bibo:Document . ?uri rdfs:label ?label . }"
        r = vivo.query(query)
        r.each do |publication|
            uri = "<#{publication['uri']}>"
            label = publication['label']
            if !pub = Publication.find_by_vivo_uri(uri) then
                pub = Publication.new
                pub.vivo_uri = uri
                pub.label = label
                pub.save
                pub.set_authors
                # TODO: add editors, companies

            else
                # TODO: update information
                # pub.set_authors
                pub.set_info

            end
        end
    end



    def set_authors
        vivo = VIVO.new

        # TODO (in general): copy ranks of authorships
        query = "SELECT ?uri ?label WHERE {
            #{self.vivo_uri} vivo:relatedBy ?authorship .
            ?authorship  a vivo:Authorship .
            ?authorship vivo:relates ?uri .
            ?uri a foaf:Person .
            ?uri rdfs:label ?label .
        }"
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
        self.authors = result.to_json
        self.save

#        # TODO: 2nd query for vcard individuals (split result in two arrays (:persons, :vcards))

    end

    def set_info
        # bibo:abstract
        # place_of_ublication
        # bibo:volume
        # bibo:edition
        # bibo:page_start
        # bibo:page_end
        # bibo:num_pages
        # bibo:doi
        # bibo:pmid
        # vivo-de:urn
        # bibo:isbn13
        # publication_venue
        # year_of_publication
        # Listen: editors, publication_venue_for
        vivo = VIVO.new
        query = "
            SELECT
                ?abstract ?place_of_publication ?volume ?edition ?page_start ?page_end ?num_pages
                ?doi ?pmid ?urn ?isbn13
                ?publication_venue_uri ?publication_venue_label
                ?publication_venue_for_uri ?publication_venue_for_label
                ?presented_at_uri ?presented_at_label
                ?editor_uri ?editor_label
            WHERE {
                OPTIONAL {
                    #{self.vivo_uri} bibo:abstract ?abstract .
                }
                OPTIONAL {
                    #{self.vivo_uri} vivo:placeOfPublication ?place_of_publication .
                }
                OPTIONAL {
                    #{self.vivo_uri} bibo:volume ?volume .
                }
                OPTIONAL {
                    #{self.vivo_uri} bibo:edition ?edition .
                }
                OPTIONAL {
                    #{self.vivo_uri} bibo:pageStart ?page_start .
                }
                OPTIONAL {
                    #{self.vivo_uri} bibo:pageEnd ?page_end .
                }
                OPTIONAL {
                    #{self.vivo_uri} bibo:numPages ?num_pages .
                }
                OPTIONAL {
                    #{self.vivo_uri} bibo:doi ?doi .
                }
                OPTIONAL {
                    #{self.vivo_uri} bibo:pmid ?pmid .
                }
                OPTIONAL {
                    #{self.vivo_uri} <http://vivoweb.org/ontology/core/de#urn> ?urn .
                }
                OPTIONAL {
                    #{self.vivo_uri} bibo:isbn13 ?isbn13 .
                }
                OPTIONAL {
                    #{self.vivo_uri} <http://vivoweb.org/ontology/core#hasPublicationVenue> ?publication_venue_uri .
                    ?publication_venue_uri rdfs:label ?publication_venue_label .
                }
                OPTIONAL {
                    #{self.vivo_uri} <http://vivoweb.org/ontology/core#publicationVenueFor> ?publication_venue_for_uri .
                    ?publication_venue_for_uri rdfs:label ?publication_venue_for_label .
                }
            }
        "
        pubvenue_for = []
        row = vivo.query(query)
        # single values
        info = {
            abstract: row[0]['abstract'],
            place_of_publication: row[0]['place_of_publication'],
            volume: row[0]['volume'],
            edition: row[0]['edition'],
            page_start: row[0]['page_start'],
            page_end: row[0]['page_end'],
            num_pages: row[0]['num_pages'],
            doi: row[0]['doi'],
            pmid: row[0]['pmid'],
            urn: row[0]['urn'],
            isbn13: row[0]['isbn13'],
            published_in: {
                label: row[0]['publication_venue_label'],
                uri: row[0]['publication_venue_uri']
            }
        }
        # collect publication venues
        venue_for = []
        row.each do |pv|
            venue_for.push({
                label: pv['publication_venue_for_label'],
                uri: pv['publication_venue_for_uri']
            })
        end
        info['publication_venue_for'] = venue_for.uniq
        self.info = info.to_json
        self.save
    end


end