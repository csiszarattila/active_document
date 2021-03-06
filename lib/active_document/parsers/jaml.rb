require 'rubygems'
require 'haml'

module ActiveDocument
  module Parsers
    class Jaml
      
      @@file_extension_name = "haml"
      
      def self.parse io
        raise ArgumentError unless io.kind_of? IO
   
        io.readline # step over first line ( '---' )
    		meta_data = ""
    		io.each_line do |line|
    			break if line =~ /---/
    			meta_data << line
    		end

    		doc_meta_data = YAML::load(meta_data)
    		doc_body = io.read
		
    		io.close
    		
    		parser_args = {}
    		parser_args["haml_body"] = doc_body
        
        doc_body = parse_haml(doc_body)
        
    		ActiveDocument::DocumentData.new doc_body, doc_meta_data, parser_args
    	end
    	
    	def self.file_extension_name
    	  @@file_extension_name
  	  end
    	
    	def self.add_document_extension_to(str)
    	  str + "." + file_extension_name
  	  end
  	  
  	  def self.parse_haml(text)
  	    Haml::Engine.new(text).to_html
	    end
    end
  end
end