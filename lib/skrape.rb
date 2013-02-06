module Skrape

  def self.define(&block)
    scraper = Scraper.new
    scraper.instance_exec(&block)
    scraper
  end


  class Scraper

    class Selector
      attr_accessor :selector, :mapping

      def initialize(selector, mapping, options = {}, block = nil)
        @selector = selector
        @mapping = mapping
        @options = options
        @scraper = Scraper.new(block) if block
      end

      def apply(html, object)
        selection = html.css(selector)
        #if it's not the end of the chain
        if @scraper
          result = apply_inner_scraper(selection)
        else
          result = selection.text
          result.strip! if @options[:trim]
        end

        # if no mapping was given, sets directly to object
        if mapping
          object[mapping] = result
        else
          object = result
        end
        object
      end

      private

        def apply_inner_scraper(selection)
          scraped_obj = []

          # tries to apply sub-scrapers to each item found in the
          # selection
          selection.each do |sel|
            scraped_obj << @scraper.scrape(sel)
          end

          # just trim out the result(s)
          scraped_obj.size == 1 ? scraped_obj.first : scraped_obj

        end
    end

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
