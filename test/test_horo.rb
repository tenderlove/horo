require 'test/unit'
require 'rdoc/generator/horo'
require 'tempfile'
require 'nokogiri'

class TestHoro < Test::Unit::TestCase
  def setup
    $-w = false
    rdoc    = RDoc::RDoc.new

    @title    = 'Ruby on Rails Documentation'
    @encoding = 'utf-8'
    @main     = 'README.rdoc'

    rdoc.document [
      '-q',
      '-f', 'horo',
      '--title', @title,
      '--main', @main,
      '--charset', @encoding,
    ]
    $-w = true
  end

  def test_index
    doc = html_doc 'doc/index.html'

    assert_equal @title, doc.css('title').first.content
    assert_equal @encoding, doc.encoding
    main_frame = doc.at_css 'frame[name = "docwin"]'
    assert_equal "files/#{@main.gsub(/\./, '_')}.html", main_frame['src']
  end

  def test_file_index
    doc = html_doc 'doc/index.html'
    assert doc.at_css('frame[src="fr_file_index.html"]'), "index links to files"
    assert_file 'doc/fr_file_index.html'
  end

  def test_class_index
    doc = html_doc 'doc/index.html'
    assert doc.at_css('frame[src="fr_class_index.html"]'), "missing frame"
    assert_file 'doc/fr_class_index.html'
  end

  def teardown
    FileUtils.rm_rf(File.join(File.dirname(__FILE__), '..', 'doc'))
  end

  private
  def html_doc file
    assert_file file
    doc = File.open(file, 'rb') { |f| Nokogiri.HTML f }
  end

  def assert_file name
    assert File.exists?(name), "missing file: #{name}"
  end
end
