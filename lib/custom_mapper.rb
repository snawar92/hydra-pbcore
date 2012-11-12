class Solrizer::FieldMapper::Default

  id_field 'id'
  index_as :searchable, :default => true do |t|
    t.default :suffix => '_t'
    t.date :suffix => '_dt' do |value|
      DateTime.parse(pbcore_date(value)).to_time.utc.iso8601
    end
    t.string  :suffix => '_t'
    t.text    :suffix => '_t'
    t.symbol  :suffix => '_s'
    t.integer :suffix => '_i'
    t.long    :suffix => '_l'
    t.boolean :suffix => '_b'
    t.float   :suffix => '_f'
    t.double  :suffix => '_d'
  end
  index_as :displayable,          :suffix => '_display'
  index_as :facetable,            :suffix => '_facet'
  index_as :sortable,             :suffix => '_sort'
  index_as :unstemmed_searchable, :suffix => '_unstem_search'

  # We assume that all dates are in ISO 8601 format, but sometimes users may only
  # specify a year or a year and month.  This method adds a -01-01 or -01 respectively
  # defaulting to Jan. 1st for dates that are only a year, and the first day of the 
  # month for dates that are only a year and a month.
  # NOTE: This only applies to the date as it is stored in solr.  The original value
  # as entered by the user is still maintained in the xml.
  def pbcore_date(date, value = String.new)
    if date.match(/^[0-9]{4,4}$/)
      value = date + "-01-01"
    elsif date.match(/^[0-9]{4,4}-[0-9]{2,2}$/)
      value = date + "-01"
    else 
      value = date  
    end
    return value
  end

end