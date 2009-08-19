require File.dirname(__FILE__) + '/helper'

describe ActiveDocument::Base do
  
  it "should find a document by title" do
  end
  
  it "should convert a title to filename" do
  end
  
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

    Article.items_from.should match( TEST_ROOT + "/posts")
    
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
    lambda { Post.new not_document_data }.should raise_error(ArgumentError)  
    
  end
  
  it "should create a Post object from ActiveDocument::DocumentData" do 
  
    parsed_body = "Some kind of sample post\n body."
    parsed_meta_data = { 
      "date" => "2009-08-06", 
      "author" => "Csiszár Attila",
      "title" => "Why's Poignant Guide to Ruby"
    }
    added_parser_args = { "parsing_date" => Date.today }
    document_data = ActiveDocument::DocumentData.new parsed_body, parsed_meta_data, added_parser_args
    
    class Post < ActiveDocument::Base
      document_parser ActiveDocument::Parsers::Jaml
    end
      
    post = Post.new document_data
    
    post.author.should match("Csiszár Attila")
    post.title.should match("Why's Poignant Guide to Ruby")
    post.parsing_date.to_s.should match( Date.today.to_s )
    post.body.should be_a_kind_of(String)
  end
  
  it "should parse a document from readed file" do
    
    class Post < ActiveDocument::Base
      document_parser ActiveDocument::Parsers::Jaml
    end
    
    readed_post_file = Post.read(@sample_post_name)
    post = Post.parse readed_post_file
    
    post.should be_a_kind_of(Post)
    post.author.should match("Csiszár Attila")
    post.title.should match("A Rails session kezelése")
    post.body.should be_a_kind_of(String)
  end
end