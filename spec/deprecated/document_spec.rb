require "spec_helper"

describe HydraPbcore::Datastream::Deprecated::Document do

  before(:each) do
    @object_ds = HydraPbcore::Datastream::Deprecated::Document.new(nil, nil)
  end

  describe ".update_indexed_attributes" do
    it "should update all of the fields in #xml_template and fields not requiring additional inserted nodes" do
      [
        [:pbc_id],
        [:title],
        [:alternative_title],
        [:chapter],
        [:episode],
        [:label],
        [:segment],
        [:subtitle],
        [:track],
        [:translation],
        [:summary],
        [:contents],
        [:lc_subject],
        [:lc_name],
        [:rh_subject],
        [:getty_genre],
        [:lc_genre],
        [:lc_subject_genre],
        [:series],
        [:event_place],
        [:contributor_name],
        [:contributor_role],
        [:publisher_name],
        [:publisher_role],
        [:note],
        [:barcode],
        [:repository],
        [:media_format],
        [:standard],
        [:media_type],
        [:generation],
        [:language],
        [:colors],
        [:collection],
        [:archival_series],
        [:collection_number],
        [:accession_number],
        [:access],
        [:condition_note],
        [:cleaning_note]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_values( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end

    it "should work for fields that require added xml nodes" do
      @object_ds.insert_publisher
      @object_ds.insert_contributor
      [
        [:publisher_name],
        [:publisher_role],
        [:contributor_name],
        [:contributor_role]
      ].each do |pointer|
        test_val = "#{pointer.last.to_s} value"
        @object_ds.update_indexed_attributes( {pointer=>{"0"=>test_val}} )
        @object_ds.get_values(pointer).first.should == test_val
        @object_ds.get_values(pointer).length.should == 1
      end
    end

    it "should differentiate between multiple added nodes" do
      @object_ds.insert_contributor
      @object_ds.insert_contributor
      @object_ds.update_indexed_attributes( {[:contributor_name] => { 0 => "first contributor" }} )
      @object_ds.update_indexed_attributes( {[:contributor_name] => { 1 => "second contributor" }} )
      @object_ds.update_indexed_attributes( {[:contributor_role] => { 0 => "first contributor role" }} )
      @object_ds.update_indexed_attributes( {[:contributor_role] => { 1 => "second contributor role" }} )
      @object_ds.get_values(:contributor).length.should == 2
      @object_ds.get_values(:contributor_name)[0].should == "first contributor"
      @object_ds.get_values(:contributor_name)[1].should == "second contributor"
      @object_ds.get_values(:contributor_role)[0].should == "first contributor role"
      @object_ds.get_values(:contributor_role)[1].should == "second contributor role"
    end

  end

  describe "#xml_template" do
    it "should return an empty xml document matching a valid exmplar" do
      # insert additional nodes
      @object_ds.insert_publisher("inserted", "inserted")
      @object_ds.insert_contributor("inserted", "inserted")
      @object_ds.insert_publisher("inserted")
      @object_ds.insert_contributor("inserted")
      @object_ds.insert_contributor

      # update additional nodes that OM will insert automatically
      @object_ds.update_indexed_attributes({ [:alternative_title] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:chapter] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:episode] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:label] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:segment] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:subtitle] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:track] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:translation] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:lc_subject] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:lc_name] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:rh_subject] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:getty_genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:lc_genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:lc_subject_genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:subject] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:condition_note] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:cleaning_note] => { 0 => "inserted" }} )

      # Load example deprecated_fixture
      f = deprecated_fixture "pbcore_document_template.xml"
      ref_node = Nokogiri::XML(f)
      f.close

      # Nokogiri-fy our sample document and reorder nodes
      sample_node = Nokogiri::XML(@object_ds.to_xml)
      reordered = HydraPbcore::Behaviors.reorder_document(sample_node)

      # Save this for later...
      out = File.new("tmp/pbcore_document_sample.xml", "w")
      out.write(reordered.to_s)
      out.close

      EquivalentXml.equivalent?(ref_node, reordered, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
      HydraPbcore::Behaviors.validate(reordered).should be_empty

    end
  end

  describe ".remove_node" do
    it "should remove a node a given type and index" do
      ["publisher", "contributor"].each do |type|
        @object_ds.send("insert_"+type)
        @object_ds.send("insert_"+type)
        @object_ds.find_by_terms(type.to_sym).count.should == 2
        @object_ds.remove_node(type.to_sym, "1")
        @object_ds.find_by_terms(type.to_sym).count.should == 1
        @object_ds.remove_node(type.to_sym, "0")
        @object_ds.find_by_terms(type.to_sym).count.should == 0
      end
    end

  end

  describe "default fields" do

    it "such as media type should be 'Moving image'" do
      @object_ds.get_values([:media_type]).first.should == "Moving image"
    end

    it "such as colors should be 'Color'" do
      @object_ds.get_values([:colors]).first.should == "Color"
    end

    it "such as generation should be 'Original'" do
      @object_ds.get_values([:generation]).first.should == "Original"
    end

  end

  describe ".to_solr" do

    before(:each) do
      # insert additional nodes
      @object_ds.insert_publisher
      @object_ds.insert_contributor
      [
        "title",
        "alternative_title",
        "chapter",
        "episode",
        "label",
        "segment",
        "subtitle",
        "track",
        "translation",
        "summary",
        "contents",
        "lc_subject",
        "lc_name",
        "rh_subject",
        "getty_genre",
        "lc_genre",
        "lc_subject_genre",
        "series",
        "event_place",
        "event_date",
        "contributor_name",
        "contributor_role",
        "publisher_name",
        "publisher_role",
        "note",
        "creation_date",
        "barcode",
        "repository",
        "media_format",
        "standard",
        "media_type",
        "generation",
        "language",
        "colors",
        "collection",
        "archival_series",
        "collection_number",
        "accession_number",
        "access",
        "condition_note",
        "cleaning_note"
      ].each do |field|
        @object_ds.send("#{field}=".to_sym, field)
      end
      # update additional nodes that OM will insert automatically
      @object_ds.update_indexed_attributes({ [:alternative_title] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:chapter] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:episode] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:label] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:segment] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:subtitle] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:track] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:translation] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:lc_subject] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:lc_name] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:rh_subject] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:getty_genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:lc_genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:lc_subject_genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:subject] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:genre] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:condition_note] => { 0 => "inserted" }} )
      @object_ds.update_indexed_attributes({ [:cleaning_note] => { 0 => "inserted" }} )

      # Use ISO 8601 dates
      @object_ds.event_date    = "2012-11-11"
      @object_ds.creation_date = "2012"
    end

    it "should match an exmplar" do
      # Load example deprecated_fixture
      f = deprecated_fixture "pbcore_solr_document_template.xml"
      ref_node = Nokogiri::XML(f)
      f.close

      # Nokogiri-fy our sample document
      sample_node = Nokogiri::XML(@object_ds.to_solr.to_xml)

      # Save this for later...
      out = File.new("tmp/pbcore_solr_document_sample.xml", "w")
      out.write(sample_node.to_s)
      out.close

      EquivalentXml.equivalent?(ref_node, sample_node, opts = { :element_order => false, :normalize_whitespace => true }).should be_true
    end

    it "should display dates as they were entered" do
      @object_ds.to_solr["creation_date_display"].should == ["2012"]
      @object_ds.to_solr["event_date_display"].should    == ["2012-11-11"]
    end

    it "should have dates converted to ISO 8601" do
      @object_ds.to_solr["creation_date_dt"].should      == ["2012-01-01T00:00:00Z"]
      @object_ds.to_solr["event_date_dt"].should         == ["2012-11-11T00:00:00Z"]
    end

    it "should not index dates as text" do
      @object_ds.to_solr["creation_date_t"].should be_nil
      @object_ds.to_solr["event_date_t"].should be_nil
    end

  end

end
