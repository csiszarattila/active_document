require File.dirname(__FILE__) + '/helper'

describe ActiveDocument::Parsers::Yamd do
  before :each do
    @sample_doc_for_parsing_name = "sample_for_yamd_parser.md"
    @sample_doc_for_parsing = File.join( FIXTURES_ROOT, 'parser' ,@sample_doc_for_parsing_name )
  end
  
  it "should have a parse method" do
    io = File.open @sample_doc_for_parsing
    ActiveDocument::Parsers::Yamd.parse io
  end
  
  it "should raise an ArgumentError if parse first argument not an IO" do
    
    io = File.open @sample_doc_for_parsing
    ActiveDocument::Parsers::Yamd.parse io
    
    io = "file"
    lambda{ ActiveDocument::Parsers::Yamd.parse io}.should raise_error(ArgumentError)
  end
  
  it "should have to parse a document with yaml meta data and markdown text body" do
    io = File.open @sample_doc_for_parsing
    parsed_document_data = ActiveDocument::Parsers::Yamd.parse io
    parsed_document_data.should be_a_kind_of(ActiveDocument::DocumentData)
  end
  
  it "should translate Markdown body into html" do
    io = File.open @sample_doc_for_parsing
    parsed_document_data = ActiveDocument::Parsers::Yamd.parse io
    parsed_document_data.should be_a_kind_of(ActiveDocument::DocumentData)
    
    html_from_markdown = "<h1 id='sample_body_for_a'>Sample body for a</h1>\n\n<p>tiny little sample post.</p>"
    parsed_document_data.body.should match(html_from_markdown)
    parsed_document_data.parser_added_args["yaml_body"].should match("\n# Sample body for a \n\ntiny little sample post.")
  end
end