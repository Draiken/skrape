module Skrape
  class Selector
    attr_reader :selector, :mapping, :options, :scraper

    def initialize(selector, mapping = nil, options = {}, block_or_scraper = nil)
      @selector = selector
      @mapping = mapping
      @options = options
      if block_or_scraper
        if block_or_scraper.is_a? Scraper
          @scraper = block_or_scraper 
        else
          @scraper = Scraper.new(block_or_scraper) 
        end
      end
    end

    def apply(html, object)
      selection = html.css(selector)

      # returns if nothing was found on the html
      return nil unless selection

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
end
