require 'skrape/selector'

module Skrape

  def self.define(&block)
    scraper = Scraper.new
    scraper.instance_exec(&block)
    scraper
  end


  class Scraper
    attr_accessor :selectors

    def initialize(block = nil)
      @selectors = []
      if block
        instance_exec(&block)
      end
    end

    def sel(selector, mapping = nil, options = {}, &block)
      selectors << Selector.new(selector, mapping, options, block)
    end

    def scrape(html, object = {})
      selectors.each do |sel|
        object = sel.apply(html, object)
      end
      object
    end


  end

end # Skrape
