module ActiveDocument
  
  class Base
    
    @@base_doc_path = nil
    @@docs_path = ""
    @@document_parser = nil
  
    def initialize document_data
      raise ArgumentError,"Expected ActiveDocument::DocumentData" unless document_data.kind_of? DocumentData
    
      (document_data.meta_data.merge document_data.parser_added_args).each_pair do |meta, value|
        self.class.send(:attr_accessor, meta)
        self.send("#{meta}=", value)
      end
    
      @body = document_data.body
    end
    
    def prettify_filename
      ActiveDocument::Base.prettify_filename(self.filename)
    end

    attr_accessor :body
    
    class << self
    
      def inherited(child)
        if not documents_from.nil?
          child.has_items_in File.join( self.documents_from, child.name.downcase + "s" )
        end
        super
      end
    
      def has_documents_in directory
        @@base_doc_path = File.expand_path(directory)
      end
  
      def documents_from
        @@base_doc_path
      end

      def has_items_in directory
        @docs_path = File.expand_path(directory)
      end
  
      def items_from
        @docs_path
      end
  
      def docs_path
        @docs_path
      end
    
      def document_parser parser_const
        @@document_parser = parser_const
      end
      
      def parser
        @@document_parser
      end

      # Checks if a document exists at a given path
      def document_exists? path_to_document
        File.exists? path_to_document
      end

      # Try to read document from a given filename,
      # raise error if document not found
      # 
      # Method requires only a file name of document instead of a full file path to document
      # Because paths for documents is resolved using document's already setted
      # model's path  - docs_path
      def read document_file_name
        path_to_document = File.join(items_from, document_file_name)
      
        raise DocumentNotFound unless document_exists? path_to_document
        
        ActiveDocument::FileUtils.open path_to_document
      end
    
      # Creates a document data set from an already opened document file
      def parse document_file_name
        raise ParserNotDefined if @@document_parser.nil?

        io = read(document_file_name)
        document_data = @@document_parser.parse(io)
        document_data.parser_added_args[:filename] = document_file_name
        
        new document_data
      end
      
      def prettify_filename(file_name, prettifier = "-")
    		/(.+)?\..*/.match(file_name)
    		file_name_without_extension = $1
    		file_name_without_extension.gsub(/[_ -]/,prettifier)
    	end

    	def convert_prettified_title_to_filename(title, prettified_with = /-/)
    		title.gsub(prettified_with, "_") << "." + parser.file_extension_name
    	end

      def find(name)
        raise ArgumentError unless name.kind_of?(String)
        document_filename = parser.add_document_extension_to(name)
        parse document_filename
      end
      
      # Collects all document from docs_path
      def all
      	FileUtils.collect_files_from(docs_path).collect do |document_filename|
      	  parse document_filename
    	  end
      end
      
      def find_by_prettified_title(prettified_title)
        document_filename = convert_prettified_title_to_filename(prettified_title)
        parse document_filename
      end
    end
    
  end
  
end