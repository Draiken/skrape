require 'spec_helper'

describe Skrape::Selector do

  describe "#initialize" do
    context "with defaults" do
      subject { Skrape::Selector.new("some selector") }
      its(:selector) { should == "some selector" }
      its(:mapping)  { should == nil }
      its(:options)  { should == {} }
      its(:scraper)  { should == nil }
    end
  end

  describe "#apply" do
    subject { Skrape::Selector.new("some selector") }
    let(:html) { 
      ::Nokogiri::HTML("<html>
                          <ul>
                            <li class=\"item\"><a>link 1</a></li>
                            <li class=\"item\"><a>link 2</a></li>
                          </ul>
                        </html>") }

    it "should apply it's selector on the html" do
      html.should_receive(:css).with(subject.selector)
      subject.apply(html, {})
    end

    context "with inner scraper" do
      let(:inner_scraper) { Skrape.define { sel "a" }}
      subject { Skrape::Selector.new("li", nil, {}, inner_scraper) }
      it "should apply the inner scraper to each selected element" do
        inner_scraper.should_receive(:scrape).twice
        subject.apply(html, {})
      end
    end

    context "with mapping" do
      subject { Skrape::Selector.new("li", :lala, {}, nil) }

      it "should set the mapping on parent object with the result" do
        object = {}
        object.should_receive("[]=").with(:lala, anything)
        subject.apply(html, object)
      end
    end

    context "without mapping" do
      subject { Skrape::Selector.new("li", nil, {}, nil) }

      it "should set the object with the result" do
        obj = subject.apply(html, {})
        obj.should == "link 1link 2"
      end
    end

    context "with attr option" do
      subject { Skrape::Selector.new("li", nil, {attr: :class}, nil) }

      it "should select the item's given attribute" do
        obj = subject.apply(html, {})
        obj.should == "item"
      end
    end
  end

end
