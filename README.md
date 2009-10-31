# Introduction

ActiveDocument provides an unique way to handle your text files, much like using the ActiveRecord pattern when dealing with database records.

In ActiveDocument files are just documents, with both text and meta data.
ActiveDocument helps you to manipulate (currently only reading up) those documents directly from models.

Lets starts with some examples...

# Running throught - for those who doesn't have time to read

Suppose you have documents in a following format:

    # sample_document.haml
    ---
    title: Yaml is great for meta-data
    author: Csiszár Attila
    ---
 
    %h1 Coding in Haml
      %p Is awesome

And you want to read it throught objects / models:

    class Document < ActiveDocument::Base
      has_items_in "/path/to/documents"
      document_parser ActiveDocument::Parsers::Jaml
    end

    doc = Document.find("sample_document")
      => #<Document:0x37f7e4>
    
    doc.title  
      => "Yaml is great for meta-data"
    
    doc.body
      =>  "<h1>Coding in Haml</h1
          <p>Is awesome</p1>"
    


# How its works exactly - Step by step introduction

First, you have to create a delegate class for your models, extending __ActiveDocument::Base__ :

    class Article < ActiveDocument::Base
      has_items_in "/real/path/to/article/documents"
      document_parser ActiveDocument::Parsers::Jaml
    end

As you can see you also have to set the path where your document files reside, using the __has_items_in__ 'macro'.

    Important: You have to use an absolute path, otherwise ActiveDocument will not able to find your document files correctly.
    
Secondly, you must have to define a parser with the __document_parser__ macro. 

The parsers' task is to read and parse your specially formatted text files (documents) so it can be converted into a __model__ __object__. _You can read more about parsers - using and creating them - later_.

After set parser and documents' path you can start fetching documents using ActiveRecord like finders:

    Article.find("sample_post") 
    => #<Article:0x37f7e4>
    
    Article.all() # => [Article, Article, Article, ... , Article] 

Currently only __all__ and __find__ finders are implemented: the latter expects a filename to find the desired document.

If you don't want to set the parser and path every time - in all of your models - ActiveDocument has a global configuration setting to do that.

    ActiveDocument::Base.has_documents_in "/real/path/to/your/documents"
    
line will be define a global directory for your models. After setting the global setup, you can leave out the __has_items_in__ macro in your models, since now __ActiveDocument__ uses a standard name conventions.

For example create a Post model class after declaring a global document path:

    ActiveDocument::Base.has_documents_in "/real/path/to/your/documents"

    class Post < ActiveDocument::Base
    end

And then Posts' documents will be searching in /real/path/to/your/documents/documents/__posts__ directory.
    
This is the same rule when setting a global parser:
  
    ActiveDocument::Base.document_parser ActiveDocument::Parsers::Jaml
    
will be define a standard Parser across document models.

# Parsers - your best friends... no, really

As I said, for ActiveDocument files are just specially marked documents, contains both text and meta-data. To extract those informations into models you need parsers.

Currently only two kind of parser implemented in ActiveDocument - Jaml and Yamd parsers. 

Jaml documents is a mix of meta data in Yaml and content in HAML format, while Yamd contains Yaml meta-data and Markdown formatted content body.

This is a very simple example for a Jaml formatted document:

    ---
    title: Yaml is great for meta-data
    author: Csiszár Attila
    ---
 
    %h1 Coding in Haml
      %p Is awesome

To use different document formats you must have to create an own parser for that. However creating an own parser is very straightforward if you fullfill the basic requirements for ActiveDocument parsers.

Your parser must be __a class__ which contains:
  
* a public method named __parser__
   
Which will be called by the ActiveDocument automatically when translating your documents into models. 
ActiveDocument call parser method with one parameter: an standard Ruby IO object of the actually opened document. You can use this IO object to read meta_data, text content, or anything from the file, and manipulate it. When that it finished: 

* parser method have to return with a __DocumentData__ object.

DocumentData just represent a simple specification which helps for ActiveDocument to create new model object from the readed and parsed files.
    
The returned DocumentData object must contain three attributes when created. 
    
    ActiveDocument::DocumentData.new "", {}, {}
  
The first one is the actual content text of your document, the second contained the meta-data in a key-value hash, the third is an optional one: for additional parameters which could be added by the parser.

    ActiveDocument::DocumentData.new doc_body, doc_meta_data, parser_args

ActiveDocument then creates a model object for each of your document, where meta-datas and additional parser parameters became instance methods, while file contenct will be available by the body method.

In the built-in Jaml parser all of that looks like this:

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
		
            parser_args = {}
            parser_args["haml_body"] = doc_body
    
            doc_body = parse_haml(doc_body)
    
            ActiveDocument::DocumentData.new doc_body, doc_meta_data, parser_args
          end
          
        end
      end
    end


# RTFT - Read the fucking tests

For full examples, - or how an earth this library might works - read throught the <del>non-existed manual</del> the spec tests (for those who dont already know: spec tests is like a working manual, at least as ones said).

# Contact

For any thought, suggestion, tips and tricks email me:

    csiszar[dot]ati[at]gmail[dot]com

Happy ActiveDocumenting,
Csiszár Attila