module ActiveDocument

  module FileUtils
    def self.open path_to_file
      File.open File.join(path_to_file) 
    end
    
    # Collect all files from a given dir only excluding filenames starts with . and _ 
    def self.collect_files_from path_to_files, excluder = /(^\..*)|(^_.*)/
      Dir.entries(path_to_files).select do |filename|
    		filename unless filename =~ excluder
    	end
    end
    
    def self.select_files_from path_to_files, &select_with_block
      Dir.entries(path_to_files).select &select_with_block
    end
  end
  
end