require File.dirname(__FILE__) + '/../lib/active_document'

TEST_ROOT = File.expand_path(File.dirname(__FILE__))
FIXTURES_ROOT =  TEST_ROOT + '/fixtures'

Spec::Runner.configure do |config|
  config.before(:all) do
    @sample_post_name = "sample_post.haml"
    @sample_post_name_without_extension = "sample_post"
    @sample_post = File.join(FIXTURES_ROOT,@sample_post_name)
    
    parsed_body = "Some kind of sample post\n body."
    parsed_meta_data = { 
       "date" => "2009-08-06", 
       "author" => "Csiszár Attila",
       "title" => "Why's Poignant Guide to Ruby"
    }
    added_parser_args = { "parsing_date" => Date.today }
    
    @document_data_mock = ActiveDocument::DocumentData.new parsed_body, parsed_meta_data, added_parser_args
    
  end
end