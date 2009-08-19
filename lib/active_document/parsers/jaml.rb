module ActiveDocument
  module Parsers
    class Jaml
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
		
    		ActiveDocument::DocumentData.new doc_body, doc_meta_data
    	end
    end
  end
end