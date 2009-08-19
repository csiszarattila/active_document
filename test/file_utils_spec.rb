require File.dirname(__FILE__) + '/helper'

describe ActiveDocument::FileUtils do
  
  it "should have to open a file" do
    existed_file_name = @sample_post
    
    lambda{ ActiveDocument::FileUtils.open existed_file_name }.should_not raise_error
    file = ActiveDocument::FileUtils.open existed_file_name
    file.should be_an_instance_of File
  end
end
