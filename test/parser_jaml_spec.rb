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
  
  it "should translate Haml body into html" do
    io = File.open @sample_doc_for_parsing
    parsed_document_data = ActiveDocument::Parsers::Jaml.parse io
    parsed_document_data.should be_a_kind_of(ActiveDocument::DocumentData)
    
    html_from_haml = "<h1>Sample body for a</h1>\n<p>tiny little sample post.</p>"
    parsed_document_data.body.should match(html_from_haml)
    parsed_document_data.parser_added_args["haml_body"].should match("\n%h1 Sample body for a \n%p tiny little sample post.")
  end
end