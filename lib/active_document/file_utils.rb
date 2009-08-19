module ActiveDocument

  module FileUtils
    def self.open path_to_file
      File.open File.join(path_to_file) 
    end
  end
  
end