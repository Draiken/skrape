require 'skrape/selector'
require 'skrape/scraper'

module Skrape

  def self.define(&block)
    scraper = Scraper.new
    scraper.instance_exec(&block)
    scraper
  end
end # Skrape
