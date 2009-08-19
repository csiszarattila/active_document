require File.dirname(__FILE__) + '/helper'

describe ActiveDocument::DocumentData do
  it "should have body, meta data and additional parser arguments" do
    parsed_body = "Some kind of sample post\n body."
    parsed_meta_data = { 
      "date" => "2009-08-06", 
      "author" => "Csiszár Attila",
      "title" => "Why's Poignant Guide to Ruby"
    }
    added_parser_args = { "parsing_date" => Date.today() }
    document_data = ActiveDocument::DocumentData.new parsed_body, parsed_meta_data, added_parser_args
    
    document_data.body.should be_a_kind_of(String)
    document_data.meta_data.should be_a_kind_of(Hash)
    document_data.parser_added_args.should be_a_kind_of(Hash)
  end 
end