require File.dirname(__FILE__) + '/helper'

describe ActiveDocument::Base do
   
  it "should have a document path" do
    class Article < ActiveDocument::Base
      has_items_in FIXTURES_ROOT
    end
    
    Article.items_from.should match(FIXTURES_ROOT)
    Article.docs_path.should match(FIXTURES_ROOT) # alias for items_from?
    
    class Article < ActiveDocument::Base
      has_items_in TEST_ROOT + "/../fixtures/"
    end
    
    fictional_full_fixtures_path = File.expand_path TEST_ROOT + "/../fixtures"
    Article.items_from.should match(fictional_full_fixtures_path)
  end
  
  it "should be able to use a default document path" do
    
    ActiveDocument::Base.has_documents_in TEST_ROOT
    
    class Post < ActiveDocument::Base
    end

    Post.items_from.should match( TEST_ROOT + "/posts" )
    
    class Card < ActiveDocument::Base
    end
    
    Card.items_from.should match( TEST_ROOT + "/cards" )
    
    Post.items_from.should match( TEST_ROOT + "/posts" )
  end
  
  it "should read a document from a file" do
    
    class Post < ActiveDocument::Base
      has_items_in TEST_ROOT + "/fixtures"
    end
    
    not_existed_file_name = "not_existed.haml"
    
    lambda { Post.read(not_existed_file_name) }.should raise_error(ActiveDocument::DocumentNotFound)
    
    Post.read(@sample_post_name).should be_kind_of File
  end
  
  it "should have a parser" do
    
    class Post < ActiveDocument::Base
    end
  
    lambda{ Post.parse("") }.should raise_error(ActiveDocument::ParserNotDefined)
    
    # First define a DocumentHandler
    class Post < ActiveDocument::Base
      document_parser ActiveDocument::Parsers::Jaml
    end
  end
  
  it "should not create Post if constructor does not get ActiveDocument::DocumentData as argument" do

    not_document_data = nil
    lambda { Post.new not_document_data }.should raise_error(ArgumentError, "Expected ActiveDocument::DocumentData")  
    
  end
  
  it "should create a Post object from ActiveDocument::DocumentData" do 
        
    class Post < ActiveDocument::Base
      document_parser ActiveDocument::Parsers::Jaml
    end
      
    post = Post.new @document_data_mock
    
    post.author.should match("Csiszár Attila")
    post.title.should match("Why's Poignant Guide to Ruby")
    post.parsing_date.to_s.should match( Date.today.to_s )
    post.body.should be_a_kind_of(String)
  end
  
  it "should parse a document from readed file" do
    
    class Post < ActiveDocument::Base
      document_parser ActiveDocument::Parsers::Jaml
    end

    post = Post.parse @sample_post_name
    
    post.should be_a_kind_of(Post)
    post.author.should match("Csiszár Attila")
    post.title.should match("A Rails session kezelése")
    post.body.should be_a_kind_of(String)
  end
  
  it "should find a document by name" do
    class Post < ActiveDocument::Base
      has_items_in TEST_ROOT + "/fixtures"
    end

    post = Post.find(@sample_post_name_without_extension)
    post.should be_a_kind_of(Post)
    
    lambda{ Post.find(22) }.should raise_error(ArgumentError)
  end
  
  it "should have filename attribute" do
    post = Post.find(@sample_post_name_without_extension)
    post.send(:filename).should match(@sample_post_name)
  end
  
  it "should translate a filename to pretty title" do
    
    k = Class.new( ActiveDocument::Base )
    
    filename = "rails_session_handling.haml"
    expected_title = "rails-session-handling"

    ActiveDocument::Base.prettify_filename(filename).should match(expected_title)

    ActiveDocument::Base.prettify_filename("file name.rb").should match("file-name")
    
    ActiveDocument::Base.prettify_filename("file-name.rb", " ").should match("file name")
  end

  it "should convert back a pretty title to filename" do
    k = Class.new( ActiveDocument::Base )

    jaml_parser = mock("jaml_parser")
    jaml_parser.should_receive(:file_extension_name).any_number_of_times.and_return("haml")
    k.should_receive(:parser).any_number_of_times.and_return(jaml_parser)

    title = "post-about-rails-session-handling"
    filename = "post_about_rails_session_handling.rb"

    k.convert_prettified_title_to_filename(title).should_not match(filename)
    
    title = "post about rails session handling"
    expected_filename = "post_about_rails_session_handling.haml"

    k.convert_prettified_title_to_filename(title, / /).should match(expected_filename)
  end
  
  it "instance should have filename translate to pretty title" do
    
    k = Class.new( ActiveDocument::Base )
    post = k.new @document_data_mock
    post.should_receive(:filename).and_return("post_about_rails_session_handling.rb")
    
    expected_title = "post-about-rails-session-handling"
    
    post.prettify_filename.should match(expected_title)
  end
    
  it "should collect all documents" do
    
    ActiveDocument::Base.has_documents_in FIXTURES_ROOT
    
    class Collection < ActiveDocument::Base
    end
    
    Collection.all.should be_kind_of(Array)
    Collection.all.should have(2).items
    Collection.all.first.should be_kind_of(Collection)
  end
  
  it "should have to find an exact document by prettified title" do
    jaml_parser = mock("jaml_parser")
    jaml_parser.should_receive(:file_extension_name).any_number_of_times.and_return("haml")
    Collection.should_receive(:parser).any_number_of_times.and_return(jaml_parser)
    
    prettified_title = "chunky-bacon"
    c = Collection.find_by_prettified_title(prettified_title)
    
    c.should be_kind_of(Collection)
    c.id.should be_equal(24)
  end

  it "should have models more than one type of parser" do
    class MultiParser < ActiveDocument::Base
      document_parsers( {".haml" => ActiveDocument::Parsers::Jaml, ".md" => ActiveDocument::Parsers::Yamd})
    end
    
    MultiParser.parsers.should have(2).items
  end
  
  it "should have document and parser type association" do
    assoc = {
      ".haml" => ActiveDocument::Parsers::Jaml, 
      ".md" => ActiveDocument::Parsers::Yamd
    }
    
    #MultiParser.parser_document_assoc.should be_equal(assoc) 
  end
  
  it "should return parser for document type" do
    MultiParser.parser_for_extension(".md").should equal(ActiveDocument::Parsers::Yamd)
  end
  
  it "should parse documents according to parser-document type association" do
    MultiParser.has_items_in FIXTURES_ROOT + "/parser"
    
    MultiParser.all.should be_kind_of(Array)
    MultiParser.all.should have(2).items
    MultiParser.all.first.should be_kind_of(MultiParser)
    MultiParser.all.first.haml_body
    MultiParser.all.first.yaml_body
  end
end