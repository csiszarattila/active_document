# Introduction

ActiveDocument provides an unique way to handle your text files, much like using the ActiveRecord pattern when dealing with database records.

In ActiveDocument files are just documents, with both text and meta data.
ActiveDocument helps you to manipulate (currently only reading up) those documents directly from models.

All right, I know you want some examples.

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

    doc = Document.find(sample_document)
      => #<Document:0x37f7e4>
    
    doc.title  
      => Yaml is great for meta-data
    
    doc.body
      =>  <h1>Coding in Haml</h1
          <p>Is awesome</p1>
    


# Step by step

First, you have to create a delegate class for your models, extending ActiveDocument::Base :

    class Article < ActiveDocument::Base
      has_items_in "/real/path/to/article/documents"
      document_parser ActiveDocument::Parsers::Jaml
    end

As you can see you also have to set the path where your document files reside, using the has_item_in macro.

    You have to use an absolute path, otherwise ActiveDocument will not able to find your document files correctly.
    
Secondly, you must have to define a parser with document_parser macro. 

The parsers' task are to read and parse your specially formatted text files (documents) so it can be converted into a __model__ object. You can read more about parsers - using and creating them - later.

After set parser and documents path you can start fetching documents using ActiveRecord like finders:

    Article.find("sample_post") # will return a Post instance
    Article.all() # => [Post, Post, Post, Post, ... , Post] 

    Currently only _all_ and _find_ implemented. The latter expects a filename parameter to find the desired document.

If you don't want to set the parser and path every time - in all of your models - ActiveDocument has a global configuration setting to do that.

    ActiveDocument::Base.has_documents_in "/real/path/to/your/documents"
    
line will be define a global directory for your models and after setting the global setup, you can leave out the has_items_in macro in your models, since now ActiveDocument uses a standard name conventions.

For example create a Post model class after declaring a global document path:

    ActiveDocument::Base.has_documents_in "/real/path/to/your/documents"

    class Post < ActiveDocument::Base
    end

And then Post's documents will be searching in /real/path/to/your/documents/documents/__posts__ directory.
    
This is the same rule when setting a global parser:
  
    ActiveDocument::Base.document_parser ActiveDocument::Parsers::Jaml
    
will be define a standard Parser across document models.

# Parsers - your best friends... no, really

As I said, for ActiveDocument files are just specially marked documents, contains both text and meta-data. To extract those informations models have to define and use a parser.

Currently only one parser implemented for ActiveDocuments, the Jaml parser. Jaml is a mix of meta data in Yaml format, an text formatted in HAML.

A sample document for that:

    ---
    title: Yaml is great for meta-data
    author: Csiszár Attila
    ---
 
    %h1 Coding in Haml*
      %p Is awesome

To use different document formats you must have to create an own parser. Creating an own parser is very straightforward if you fullfill the requirements for ActiveDocument's parsers.

Firstly your parser must have a parse method, which called by ActiveDocument automatically when reading up your documents. ActiveDocument then given it one parameter when calling it: an IO object of the actually opened file.

You can use this IO object to read meta_data, text content, or anything from file and manipulate it, after finish it then you only have to return with a DocumentData object.

    DocumentData just represent a simple specification which helps for ActiveDocument to create new model object from the readed and parsed files content.
    
The returned DocumentData object must have contain three attributes when created. The first one is the actual body text of your document, the second contained the meta-data in a key-value paired hash, the third is an optional one for additional parameters, which could be added by the parser.

    ActiveDocument::DocumentData.new doc_body, doc_meta_data, parser_args

ActiveDocument then creates a model object for each of your document, where meta-datas and additional parser parameters became instance methods, while file contenct will be availably by the body, setter and getter method. 

# RTFT - Read the fucking tests

For full examples, - or how an earth this library might works - read throught the <del>non-existed manual</del> the spec tests (for those who dont already know, spec tests is like a working manual, as ones said).
