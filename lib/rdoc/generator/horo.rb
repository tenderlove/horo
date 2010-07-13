require 'rdoc/generator'
require 'rdoc/rdoc'
require 'erb'

class RDoc::Generator::Horo
  RDoc::RDoc.add_generator self

  class << self
    alias :for :new
  end

  attr_accessor :file_dir, :class_dir

  def initialize options
    @options   = options
    @files     = nil
    @classes   = nil
    @methods   = nil
    @file_dir  = 'files'
    @class_dir = 'classes'
    @app_root  = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
    @op_dir    = File.expand_path options.op_dir
  end

  def generate top_levels
    @files = top_levels
    @classes = RDoc::TopLevel.all_classes_and_modules
    @methods = @classes.map { |x| x.method_list }.flatten

    write_index
    write_file_index
    write_class_index
    write_method_index
  end

  private
  def write_method_index
    filename = File.join @app_root, 'app', 'views', 'methods', 'index.html.erb'
    ctx = TemplateContext.new @options, @methods

    ctx.extend FileIndexHelper
    ctx.list_title = 'Methods'

    File.open(File.join(@op_dir, 'fr_method_index.html'), 'wb') do |fh|
      fh.write ctx.eval File.read(filename), filename
    end
  end

  def write_class_index
    filename = File.join @app_root, 'app', 'views', 'classes', 'index.html.erb'
    ctx = TemplateContext.new @options, @classes

    ctx.extend FileIndexHelper
    ctx.list_title = 'Classes'

    File.open(File.join(@op_dir, 'fr_class_index.html'), 'wb') do |fh|
      fh.write ctx.eval File.read(filename), filename
    end
  end

  def write_file_index
    filename = File.join @app_root, 'app', 'views', 'files', 'index.html.erb'
    ctx = TemplateContext.new @options, @files

    ctx.extend FileIndexHelper
    ctx.list_title = 'Files'

    File.open(File.join(@op_dir, 'fr_file_index.html'), 'wb') do |fh|
      fh.write ctx.eval File.read(filename), filename
    end
  end

  def write_index
    filename = File.join @app_root, 'app', 'views', 'root', 'index.html.erb'
    ctx = TemplateContext.new @options, @files

    File.open(File.join(@op_dir, 'index.html'), 'wb') do |fh|
      fh.write ctx.eval File.read(filename), filename
    end
  end

  module FileIndexHelper
    attr_accessor :list_title
  end

  class TemplateContext < Struct.new :options, :files
    def eval src, filename
      template = ERB.new src, nil, '><'
      template.filename = filename
      template.result binding
    end

    def title
      options.title
    end

    def charset
      options.charset
    end

    def main_page
      files.find { |x| x.name == options.main_page }
    end
  end
end
