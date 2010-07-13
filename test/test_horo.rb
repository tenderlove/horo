require 'test/unit'
require 'rdoc/generator/horo'
require 'tempfile'
require 'nokogiri'

class TestHoro < Test::Unit::TestCase
  def setup
    $-w = false
    rdoc    = RDoc::RDoc.new
    @title = 'Ruby on Rails Documentation'

    rdoc.document [
      '-q',
      '-f', 'horo',
      '--title', @title,
      '--main', 'railties/README',
      '--charset', 'utf-8',
    ]
    $-w = true
  end

  def test_index
    assert_file 'doc/index.html'
    doc = File.open('doc/index.html', 'rb') { |f| Nokogiri.HTML f }
    assert_equal @title, doc.css('title').first.content
  end

  def teardown
    FileUtils.rm_rf(File.join(File.dirname(__FILE__), '..', 'doc'))
  end

  private
  def assert_file name
    assert File.exists?(name), "missing file: #{name}"
  end
end
