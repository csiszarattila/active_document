require File.dirname(__FILE__) + '/helper'

describe ActiveDocument::FileUtils do
  
  before :all do
    @collection_directory =  FIXTURES_ROOT + "/collections"
  end
  
  it "should have to open a file" do
    existed_file_name = @sample_post
    
    lambda{ ActiveDocument::FileUtils.open existed_file_name }.should_not raise_error
    file = ActiveDocument::FileUtils.open existed_file_name
    file.should be_an_instance_of File
  end
  
  it "should collect files from a directory" do
    file_collection = ActiveDocument::FileUtils.collect_files_from @collection_directory
    
    file_collection.should have(2).items
    file_collection.first.should match("chunky_bacon.haml")
    file_collection[1].should match("sample_post.haml")  
  end
  
  it "should select files from a directory" do
    select_only = lambda{ |filename| filename =~ /chunky_bacon.haml/ }
    file_collection = ActiveDocument::FileUtils.select_files_from @collection_directory, &select_only
    
    file_collection.should_not have(2).items
    file_collection.first.should match("chunky_bacon.haml")
    
    select_only = lambda{ |filename| filename =~ /.haml/ }
    file_collection = ActiveDocument::FileUtils.select_files_from @collection_directory, &select_only
    
    file_collection.should have(2).items
    file_collection.first.should match("chunky_bacon.haml")
    file_collection[1].should match("sample_post.haml")  
  end
end
