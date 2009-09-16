module ActiveDocument
  
  class DocumentData
    @meta_data = {}
    @body = []
    @parser_args = {}
  
    def initialize body,  meta_data = {}, parser_added_args = {}
      @body = body
      @meta_data = meta_data
      @parser_added_args = parser_added_args
    end
  
    attr_accessor :meta_data, :body, :parser_added_args
  end
  
end