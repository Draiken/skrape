require 'spec_helper'

require 'nokogiri'
describe Skrape::Scraper do

  describe "#sel" do
    it "should add a selector with a mapping" do

      Skrape::Selector.should_receive(:new).twice

      scraper = Skrape.define do
        sel "h1", :title
        sel "ul.items > li", :items do
          sel "span.title", :title
        end
      end

      scraper.selectors.size.should == 2
    end
  end

  describe "#scrape" do
    it "should scrape the html with its defined selector/maps" do
      scraper = Skrape.define do
        sel "h1", :title
        sel "ul.items > li", :items do
          sel "span.title", :title
          sel ".thing", :thing do
            sel ".one", :one
            sel ".two", :two
          end
        end
      end

      html = "<html>
          <body>
            <h1>My title</h1>
            <ul class=\"items\">
              <li>
                <span class=\"title\">First title</span>
                <div class=\"thing\">
                  <span class=\"one\">One</span>
                  <span class=\"two\">Two</span>
                </div>
              </li>
              <li>
                <span class=\"title\">Last title</span>
                <div class=\"thing\">
                  <span class=\"one\">One</span>
                  <span class=\"two\">Two</span>
                </div>
              </li>
            </ul>
          </body>
        </html>"
        parsed_html = ::Nokogiri::HTML(html)

        object = scraper.scrape(parsed_html)

        object[:title].should == "My title"
        object[:items].should be_a Array
        object[:items].count.should == 2
        item = object[:items].last
        item[:title].should == "Last title"
        item[:thing][:one].should == "One"
    end

    context "when receiving pure text" do
      it "should wrap it with nokogiri and work as usual" do
        scraper = Skrape.define { sel "h1" }
        html = "<h1>test</h1>"
        scraper.scrape(html).should == "test"
      end
    end
  end
end
