require File.dirname(__FILE__) + '/helper'

describe ActiveDocument::Parsers::Jaml do
  before :each do
    @sample_doc_for_parsing_name = "sample_for_jaml_parser.haml"
    @sample_doc_for_parsing = File.join( FIXTURES_ROOT, 'parser' ,@sample_doc_for_parsing_name )
  end
  
  it "should have a parse method" do
    io = File.open @sample_post
    ActiveDocument::Parsers::Jaml.parse io
  end
  
  it "should raise an ArgumentError if parse first argument not an IO" do
    
    io = File.open @sample_post
    ActiveDocument::Parsers::Jaml.parse io
    
    io = "file"
    lambda{ ActiveDocument::Parsers::Jaml.parse io}.should raise_error(ArgumentError)
  end
  
  it "should have to parse a document with yaml meta data and haml text body" do
    io = File.open @sample_doc_for_parsing
    parsed_document_data = ActiveDocument::Parsers::Jaml.parse io
    parsed_document_data.should be_a_kind_of(ActiveDocument::DocumentData)
  end
end