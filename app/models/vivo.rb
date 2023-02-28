require 'i18n'
require 'rdf'
require 'securerandom'
require 'rest_client'
require 'json'


class VIVO
  KBGRAPH= '<http://vitro.mannlib.cornell.edu/default/vitro-kb-2>'
  USERACCOUNTSGRAPH = '<http://vitro.mannlib.cornell.edu/default/vitro-kb-userAccounts>'

  def get_id(uri)
    uri.split(/\//).pop
  end

  def make_uri(id)
    "<https://vivo.hs-mittweida.de/vivo/individual/#{id}>"
  end

  def initialize
    base_url = 'https://vivo.hs-mittweida.de/vivo'
    @update_url = "#{base_url}/api/sparqlUpdate"
    @query_url = "#{base_url}/api/sparqlQuery"
    @username = ""
    @password = ""
  end

  def new_resource
    "<https://vivo.hs-mittweida.de/vivo/individual/#{SecureRandom.uuid}>"
  end

  def insert(triples, graph = KBGRAPH)
    # http = Net::HTTP.new("vivo-development.hs-mittweida.de", 443)
    # http.use_ssl = true

    # request = Net::HTTP::Post.new('/vivo/api/sparqlQuery')

    query = "INSERT DATA {\n
      GRAPH #{graph} {\n" + RDF.format_triples(triples) +
            "}\n
            }"

    p query

    begin
      response = RestClient.post(@update_url, { email: @username, password: @password, update: query })
    rescue StandardError => e
      p e
    end
    response
  end

  def delete(triples, graph = KBGRAPH)
    # http = Net::HTTP.new("vivo-development.hs-mittweida.de", 443)
    # http.use_ssl = true

    # request = Net::HTTP::Post.new('/vivo/api/sparqlQuery')

    # scan for strings to delete and add type-casted triple to make sure
    # that we get rid of that darn string once and for all
    
    delete_really = []
    triples.each do |triple|
      delete_really.push(triple)
      if triple[2].match(/^"[^"]*"$/)
        delete_really.push([triple[0], triple[1], "#{triple[2]}^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#langString>"])
      end
      # push object once again in "<>" and tread it as URI if it's not already a URI (starts with "<http")
      if !triple[2].match(/^\<http/) then
        delete_really.push([triple[0], triple[1], "<#{triple[2]}>"])
      end
    end

    puts "DELETE"
    p delete_really
    query = "DELETE DATA {\n
      GRAPH #{graph} {\n" + RDF.format_triples(delete_really) +
            "}\n
            }"

    begin
      response = RestClient.post(@update_url, { email: @username, password: @password, update: query })
    rescue StandardError => e
      p e
    end
    response
  end

  def update(triples)
    oldtriples = []
    newtriples = []

    triples.each do |triple|
      oldtriples << [triple[0], triple[1], triple[2][0]]
      newtriples << [triple[0], triple[1], triple[2][1]]
    end

    delete(oldtriples)
    insert(newtriples)
  end

  def query(query)
    sparqlprefix = <<~__EOP__
      PREFIX rdf:      <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
      PREFIX rdfs:     <http://www.w3.org/2000/01/rdf-schema#>
      PREFIX xsd:      <http://www.w3.org/2001/XMLSchema#>
      PREFIX owl:      <http://www.w3.org/2002/07/owl#>
      PREFIX swrl:     <http://www.w3.org/2003/11/swrl#>
      PREFIX swrlb:    <http://www.w3.org/2003/11/swrlb#>
      PREFIX vitro:    <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>
      PREFIX bibo:     <http://purl.org/ontology/bibo/>
      PREFIX c4o:      <http://purl.org/spar/c4o/>
      PREFIX cito:     <http://purl.org/spar/cito/>
      PREFIX dcterms:  <http://purl.org/dc/terms/>
      PREFIX event:    <http://purl.org/NET/c4dm/event.owl#>
      PREFIX fabio:    <http://purl.org/spar/fabio/>
      PREFIX foaf:     <http://xmlns.com/foaf/0.1/>
      PREFIX geo:      <http://aims.fao.org/aos/geopolitical.owl#>
      PREFIX hsmw:     <https://vivo.hs-mittweida.de/vivo/ontology/hsmw#>
      PREFIX kdsf-meta: <http://kerndatensatz-forschung.de/owl/Meta#>
      PREFIX kdsf:     <http://kerndatensatz-forschung.de/owl/Basis#>
      PREFIX kdsf-vivo: <http://lod.tib.eu/onto/kdsf/>
      PREFIX obo:      <http://purl.obolibrary.org/obo/>
      PREFIX ocrer:    <http://purl.org/net/OCRe/research.owl#>
      PREFIX ocresst:  <http://purl.org/net/OCRe/statistics.owl#>
      PREFIX ocresd:   <http://purl.org/net/OCRe/study_design.owl#>
      PREFIX ocresp:   <http://purl.org/net/OCRe/study_protocol.owl#>
      PREFIX ro:       <http://purl.obolibrary.org/obo/ro.owl#>
      PREFIX skos:     <http://www.w3.org/2004/02/skos/core#>
      PREFIX swo:      <http://www.ebi.ac.uk/efo/swo/>
      PREFIX vcard:    <http://www.w3.org/2006/vcard/ns#>
      PREFIX vitro-public: <http://vitro.mannlib.cornell.edu/ns/vitro/public#>
      PREFIX vivo:     <http://vivoweb.org/ontology/core#>
      PREFIX scires:   <http://vivoweb.org/ontology/scientific-research#>
      PREFIX vann:     <http://purl.org/vocab/vann/>
    __EOP__

    response = RestClient.post(@query_url,
                               { email: @username, password: @password, query: sparqlprefix + "\n" + query }, headers = { 'Accept' => 'application/sparql-results+json' })

    bindings = JSON.parse(response.body)['results']['bindings']

    result = []
    bindings.each do |item|
      ih = {}
      item.each do |k, v|
        ih[k] = v['value']
      end
      result.push(ih)
    end
    result
  end
 
end
