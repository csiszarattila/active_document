
path = File.expand_path(File.dirname(__FILE__))
$:.unshift(path) unless $:.include?(path)

module ActiveDocument
  
  VERSION = [0,1,0]
  
  def self.version
    VERSION.join(".")
  end
  
  autoload :Base, 'active_document/base'
  autoload :DocumentData, 'active_document/document_data'
  autoload :FileUtils, 'active_document/file_utils'
  
  module Parsers
    autoload :Jaml, 'active_document/parsers/jaml'
  end
  
  class DocumentNotFound < StandardError
  end
    
  class ParserNotDefined < StandardError
  end
end