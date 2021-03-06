module HydraPbcore::Datastream
class Document < ActiveFedora::OmDatastream

  include HydraPbcore::Methods
  include HydraPbcore::Templates
  
  set_terminology do |t|
    t.root(:path=>"pbcoreDescriptionDocument")

    t.pbc_id(:path=>"pbcoreIdentifier", :type => :string, :attributes=>{ :source=>"NOLA Code" }, :index_as => [:displayable])

    t.title(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Main" }, :index_as => [:facetable, :stored_searchable, :displayable])

    t.series(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Series"}, :index_as => [:facetable, :stored_searchable, :displayable])

    t.program(:path => "pbcoreTitle", :attributes=>{:titleType=>"Program"}, :index_as => [:facetable, :stored_searchable, :displayable])

    t.chapter(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Chapter" }, :index_as => [:facetable, :stored_searchable, :displayable])

    t.episode(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Episode" }, :index_as => [:facetable, :stored_searchable, :displayable])
    
    t.element(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Element" }, :index_as => [:facetable, :stored_searchable, :displayable])
    
    t.clip(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Clip" }, :index_as => [:facetable, :stored_searchable, :displayable])
    
    t.label(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Label" }, :index_as => [:stored_searchable, :displayable])
    
    t.segment(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Segment" }, :index_as => [:stored_searchable, :displayable])
    
    t.subtitle(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Subtitle" }, :index_as => [:stored_searchable, :displayable])
    
    t.track(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Track" }, :index_as => [:stored_searchable, :displayable])
    
    t.item(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Item" }, :index_as => [:stored_searchable, :displayable])

    t.image(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Image" }, :index_as => [:stored_searchable, :displayable])
    
    t.translation(:path=>"pbcoreTitle", :attributes=>{ :titleType=>"Translation" }, :index_as => [:stored_searchable, :displayable])

    t.category(:path=>"pbcoreSubject", :attributes=>{:subjectType=>"Category"},:index_as => [:facetable, :displayable])

    t.asset_date(:path=>"pbcoreAssetDate", :type => :string, :index_as => [:facetable, :stored_searchable, :displayable])

    #This is only to display all subjects
    t.subject(:path=>"pbcoreSubject") do
      t.name_(:path=>"subject")
      t.authority_(:path=>'subjectAuthorityUsed')
    end
    t.subject_name(:ref=>[:subject, :name], :index_as => [:stored_searchable, :facetable, :displayable])

    #Individual subject types defined for entry
    t.lc_subject(:path=>"pbcoreSubject", 
      :attributes=>{ 
        :source=>"Library of Congress Subject Headings", 
        :ref=>"http://id.loc.gov/authorities/subjects.html"
      },
      :index_as => [:displayable]
    )
    t.lc_name(:path=>"pbcoreSubject",
      :attributes=>{ :source=>"Library of Congress Name Authority File", :ref=>"http://id.loc.gov/authorities/names" },
      :index_as => [:displayable]
    )
    t.rh_subject(:path=>"pbcoreSubject", 
      :attributes=>{ :source=>HydraPbcore.config["institution"] },
      :index_as => [:displayable]
    )

    t.description(:path => 'pbcoreDescription', :index_as => [:stored_searchable, :displayable]) {
      t.type(:path => {:attribute => 'descriptionType'})
    }

    t.contents(:path=>"pbcoreDescription", 
      :attributes=>{ 
        :descriptionType=>"Table of Contents",
        :descriptionTypeRef=>"http://metadataregistry.org/concept/show/id/1702.html"
      },
      :index_as => [:stored_searchable, :displayable]
    )

    # This is only to display all genres
    t.genre(:path=>"pbcoreGenre", :index_as => [:facetable])

    t.asset_type(:path=>"pbcoreAssetType", :index_as => [:stored_searchable, :facetable])

    # Individual genre types defined for entry
    t.getty_genre(:path=>"pbcoreGenre", 
      :attributes=>{ 
        :source=>"The Getty Research Institute Art and Architecture Thesaurus",
        :ref=>"http://www.getty.edu/research/tools/vocabularies/aat/index.html"
      },
      :index_as => [:displayable] 
    )
    t.lc_genre(:path=>"pbcoreGenre",
      :attributes=>{
        :source=>"Library of Congress Genre/Form Terms", 
        :ref=>"http://id.loc.gov/authorities/genreForms.html"
      },
      :index_as => [:displayable]
    )
    t.lc_subject_genre(:path=>"pbcoreGenre",
      :attributes=>{
        :source=>"Library of Congress Subject Headings",
        :ref=>"http://id.loc.gov/authorities/subjects.html"
      },
      :index_as => [:displayable]    
    )

    # PBCore relation fields
    t.pbcoreRelation do
      t.event_series(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Event Series" })
      t.arch_coll(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Archival Collection" })
      t.arch_ser(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Archival Series" })
      t.coll_num(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Collection Number" })
      t.acc_num(:path=>"pbcoreRelationIdentifier", :attributes=>{ :annotation=>"Accession Number" })
    end
    

    t.collection(:ref=>[:pbcoreRelation, :arch_coll], :index_as => [:stored_searchable, :displayable, :facetable])
    t.archival_series(:ref=>[:pbcoreRelation, :arch_ser], :index_as => [:stored_searchable, :displayable])
    t.collection_number(:ref=>[:pbcoreRelation, :coll_num], :index_as => [:stored_searchable, :displayable])
    t.accession_number(:ref=>[:pbcoreRelation, :acc_num], :index_as => [:stored_searchable, :displayable])

    t.pbcoreCoverage
    # Terms for time and place
    t.event_place(:path=>"pbcoreCoverage/coverage", 
      :attributes => {:annotation=>"Event Place"},
      :index_as => [:stored_searchable, :displayable]
    )
    t.event_date(:path=>"pbcoreCoverage/coverage", 
      :attributes => {:annotation=>"Event Date"},
      :index_as => [:dateable, :displayable]
    )

      # Creator names and roles
      t.creator(:path=>"pbcoreCreator") do
        t.creator
        t.role_(:path=>"creatorRole", :attributes=>{ :ref=>"http://metadataregistry.org/concept/show/id/1425.html" })
      end
      t.creator_name(:ref=>[:creator, :creator], :type => :string, :index_as => [:stored_searchable, :displayable])
      t.creator_role(:ref=>[:creator, :role], :type => :string, :index_as => [:stored_searchable, :displayable])

    # Contributor names and roles
    t.contributor(:path=>"pbcoreContributor") do
      t.name_(:path=>"contributor")
      t.role_(:path=>"contributorRole", :attributes=>{ :source=>HydraPbcore.config["relator"] })
    end
    t.contributor_name(:ref=>[:contributor, :name], :index_as => [:stored_searchable, :facetable])
    t.contributor_role(:ref=>[:contributor, :role], :index_as => [:stored_searchable, :displayable])

    # Publisher names and roles
    t.publisher(:path=>"pbcorePublisher") do
      t.name_(:path=>"publisher")
      t.role_(:path=>"publisherRole", :attributes=>{ :source=>"PBCore publisherRole" })
    end
    t.publisher_name(:ref=>[:publisher, :name], :index_as => [:stored_searchable, :facetable, :displayable])
    t.publisher_role(:ref=>[:publisher, :role], :index_as => [:stored_searchable, :displayable])

    t.note(:path=>"pbcoreAnnotation", :atttributes=>{ :annotationType=>"Notes" }, :index_as => [:stored_searchable, :displayable])

    t.pbcoreRightsSummary do
      t.rightsSummary
    end
    t.rights_summary(:ref => [:pbcoreRightsSummary, :rightsSummary], :index_as => [:stored_searchable, :displayable])

  end

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.pbcoreDescriptionDocument("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {
        xml.pbcoreIdentifier(:source=>HydraPbcore.config["institution"], :annotation=>"PID")        
      }

      # xml.pbcoreDescriptionDocument("xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
      #   "xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {

      #   xml.pbcoreIdentifier(:source=>HydraPbcore.config["institution"], :annotation=>"PID")
      #   xml.pbcoreTitle(:titleType=>"Program")
      #   xml.pbcoreDescription(:descriptionType=>"Program",
      #     :descriptionTypeSource=>"pbcoreDescription/descriptionType",
      #     :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#description",
      #     :annotation=>"Summary"
      #   )
      #   xml.pbcoreDescription(:descriptionType=>"Table of Contents",
      #     :descriptionTypeSource=>"pbcoreDescription/descriptionType",
      #     :descriptionTypeRef=>"http://pbcore.org/vocabularies/pbcoreDescription/descriptionType#table-of-contents",
      #     :annotation=>"Parts List"
      #   )
      #   xml.pbcoreRightsSummary {
      #     xml.rightsSummary
      #   }
      #   xml.pbcoreAnnotation(:annotationType=>"Notes")

      # }

    end
    return builder.doc
  end

end
end
