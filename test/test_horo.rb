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
    @main     = 'railties/README'

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
    assert_file 'doc/index.html'
    doc = File.open('doc/index.html', 'rb') { |f| Nokogiri.HTML f }

    assert_equal @title, doc.css('title').first.content
    assert_equal @encoding, doc.encoding
    main_frame = doc.at_css 'frame[name = "docwin"]'
    assert_equal "#{@main}.html", main_frame['src']
  end

  def teardown
    FileUtils.rm_rf(File.join(File.dirname(__FILE__), '..', 'doc'))
  end

  private
  def assert_file name
    assert File.exists?(name), "missing file: #{name}"
  end
end
