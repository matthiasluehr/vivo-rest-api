class Project < ActiveRecord::Base
    self.table_name = 'projects'

    def Project.sync_from_vivo
        vivo = VIVO.new

        query = "SELECT ?uri ?label WHERE { ?uri a kdsf:Drittmittelprojekt . ?uri rdfs:label ?label . }"
        r = vivo.query(query)
        r.each do |project|
            uri = "<#{project['uri']}>"
            label = project['label']
            if !p = Project.find_by_vivo_uri(uri) then
                p = Project.new
                p.vivo_uri = uri
                p.label = label
                p.save
                p.set_researchers
            else
                # TODO: update

            end

        end
    end

    def set_researchers
        # TODO: add role type in order of type of role (prinicipal and co-investigator, just researcher)
        vivo = VIVO.new

        query = "SELECT ?uri ?label WHERE {
            #{self.vivo_uri} vivo:relates ?investigator_role .
            ?investigator_role a vivo:PrincipalInvestigatorRole .
            ?investigator_role obo:RO_0000052 ?uri .
            ?uri a foaf:Person .
            ?uri rdfs:label ?label
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
        self.researchers = result.to_json
        self.save
    end

end