require 'rdoc/generator'
require 'rdoc/rdoc'
require 'erb'

class RDoc::Generator::Horo
  RDoc::RDoc.add_generator self

  class << self
    alias :for :new
  end

  def initialize options
    @options  = options
    @files    = nil
    @classes  = nil
    @methods  = nil
    @app_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    @op_dir   = File.expand_path options.op_dir
  end

  def generate top_levels
    @files = top_levels
    @classes = RDoc::TopLevel.all_classes_and_modules
    @methods = @classes.map { |x| x.method_list }.flatten

    write_index
  end

  private
  def write_index
    filename = File.join @app_root, 'app', 'views', 'root', 'index.html.erb'
    ctx = TemplateContext.new @options
    ctx.extend IndexHelper
    File.open(File.join(@op_dir, 'index.html'), 'wb') do |fh|
      fh.write ctx.eval File.read(filename), filename
    end
  end

  module IndexHelper
    def title
      options.title
    end

    def charset
      options.charset
    end

    def main_page
      options.main_page + ".html"
    end
  end

  class TemplateContext < Struct.new :options
    def eval src, filename
      template = ERB.new src
      template.filename = filename
      template.result binding
    end
  end
end
