class RDF
    @@vocabular = {
      type: '<http://www.w3.org/1999/02/22-rdf-syntax-ns#type>',
      foafPerson: '<http://xmlns.com/foaf/0.1/Person>',
      vcardType: '<http://www.w3.org/2006/vcard/ns#Kind>',
      emailType: '<http://www.w3.org/2006/vcard/ns#Email>',
      addressType: '<http://www.w3.org/2006/vcard/ns#Address>',
      titleType: '<http://www.w3.org/2006/vcard/ns#Title>',
      nameType: '<http://www.w3.org/2006/vcard/ns#Name>',
      rdfsLabel: '<http://www.w3.org/2000/01/rdf-schema#label>',
      familyName: '<http://www.w3.org/2006/vcard/ns#familyName>',
      givenName: '<http://www.w3.org/2006/vcard/ns#givenName>',
      firstName: '<http://xmlns.com/foaf/0.1/firstname> ',
      lastName: '<http://xmlns.com/foaf/0.1/lastname> ',
      lookupName: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#lookupName>',
      externalAuthId: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#externalAuthId>',
      country: '<http://www.w3.org/2006/vcard/ns#country>',
      locality: '<http://www.w3.org/2006/vcard/ns#locality>',
      postalCode: '<http://www.w3.org/2006/vcard/ns#postalCode>',
      streetAddress: '<http://www.w3.org/2006/vcard/ns#streetAddress>',
      relatedBy: '<http://vivoweb.org/ontology/core#relatedBy>',
      relates: '<http://vivoweb.org/ontology/core#relates>',
      hasRoom: '<http://purl.obolibrary.org/obo/RO_0001025>',
      hasContactInformation: '<http://purl.obolibrary.org/obo/ARG_2000028>',
      bearerOf: '<http://purl.obolibrary.org/obo/RO_0000053>',
      hasEmail: '<http://www.w3.org/2006/vcard/ns#hasEmail>',
      hasAddress: '<http://www.w3.org/2006/vcard/ns#hasAddress>',
      hasTitle: '<http://www.w3.org/2006/vcard/ns#hasTitle>',
      hasName: '<http://www.w3.org/2006/vcard/ns#hasName>',
      contactInformationOf: '<http://purl.obolibrary.org/obo/ARG_2000029>',
      locatedIn: '<http://purl.obolibrary.org/obo/RO_0001025>',
      locationOf: '<http://purl.obolibrary.org/obo/RO_0001015>',
      email: '<http://www.w3.org/2006/vcard/ns#email>',
      title: '<http://www.w3.org/2006/vcard/ns#title>',
      positionType: '<http://vivoweb.org/ontology/core#Position>',
      profilePhoto: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#profilePhoto>',
      hasPhone: '<http://www.w3.org/2006/vcard/ns#hasTelephone>',
      phoneType: '<http://www.w3.org/2006/vcard/ns#Telephone>',
      phone: '<http://www.w3.org/2006/vcard/ns#telephone>',
      workType: '<http://www.w3.org/2006/vcard/ns#Work>',
      hasURL: '<http://www.w3.org/2006/vcard/ns#hasURL>',
      urlType: '<http://www.w3.org/2006/vcard/ns#URL>',
      url: '<http://www.w3.org/2006/vcard/ns#url>',
      hsmwSchutzrecht: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Schutzrecht>',
      hsmwPatent: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Patent>',
      hsmwGebrauchsmuster: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Gebrauchsmuster>',
      hsmwSchutzrechtAKZ: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#SchutzrechtAKZ>',
      hsmwSchutzrechtDocNumber: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#SchutzrechtDocNumber>',
      hsmwDokumentLink: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#DokumentLink>',
      hsmwOffenlegungstag: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Offenlegungstag>',
      hsmwAnmeldetag: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Anmeldetag>',
      hsmwVeroeffentlichungstag: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Veroeffentlichungstag>',
      hsmwBekanntmachungstag: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Bekanntmachungstag>',
      hsmwEintragungstag: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Eintragungstag>',
      hsmwRolleDesErfinders: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#RolleDesErfinders>',
      hsmwSchutzrechtstatus: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#SchutzrechtStatus>',
      hsmwVerfahrensstand: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#Verfahrensstand>',
      hsmwVerknuepftesPatent: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#verknuepftesPatent>',
      biboAbstract: '<http://purl.org/ontology/bibo/abstract>',
      idmValue: '<https://vivo.hs-mittweida.de/vivo/ontology/hsmw#idmValue>',
      authUserAccount: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#UserAccount>',
      authEmailAddress: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#emailAddress>',
      authExternalId: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#externalAuthId>',
      authExternalOnly: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#externalAuthOnly>',
      authFirstName: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#firstName>',
      authLastName: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#lastName>',
      authPermissionSet: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#hasPermissionSet>',
      authSelfEditor: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#SELF_EDITOR>',
      authStatus: '<http://vitro.mannlib.cornell.edu/ns/vitro/authorization#status>'
  
    }
  
    def self.format_triples(triples)
      result = ''
      triples.each do |triplet|
        p triplet  
        if !triplet[2].match(/^\<http/) && !triplet[2].match(/^\"/) then
              triplet[2] = '"' + triplet[2] + '"'
          end
        result += triplet.join(' ') + " .\n"
      end
      result
    end
  
    def self.sym(mnemnonic)
      @@vocabular[mnemnonic]
    end
  end