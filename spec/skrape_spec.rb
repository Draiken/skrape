require 'spec_helper'

describe Skrape do

  describe "#define" do
    it "should create a new scraper with the defined block" do

      scraper = Skrape.define do
        sel "h1", :title
        sel "ul.items > li", :items do
          sel "span.title", :title
        end
      end

      scraper.should be_a Skrape::Scraper
    end
  end

end
