module Skrape

  def self.define(&block)
    scraper = Scraper.new
    scraper.instance_exec(&block)
    scraper
  end


  class Scraper

    class Selector
      attr_accessor :selector, :mapping

      def initialize(selector, mapping, block)
        @selector = selector
        @mapping = mapping
        @scraper = Scraper.new(block) if block
      end

      def apply(html, object)
        selection = html.css(selector)
        if @scraper
        scraped_obj = []
        selection.each do |sel|
            scraped_obj << @scraper.scrape(sel, ::OpenStruct.new)
          end
          object.send("#{mapping}=", scraped_obj.size == 1 ? scraped_obj.first : scraped_obj)
        else
          object.send("#{mapping}=", selection.text)
        end
        object
      end
    end

    attr_accessor :selectors

    def initialize(block = nil)
      @selectors = []
      if block
        instance_exec(&block)
      end
    end

    def sel(selector, mapping, &block)
      #block = @block if @block && block.nil?
      selectors << Selector.new(selector, mapping, block)
    end

    def scrape(html, object)
      selectors.each do |sel|
        object = sel.apply(html, object)
      end
      object
    end

  end

end # Skrape
