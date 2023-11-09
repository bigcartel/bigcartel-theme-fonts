require 'spec_helper'

describe ThemeFont do
  before(:each) do
    # Start fresh each time, so stubs work
    ThemeFont.send(:remove_class_variable, :@@source) rescue nil
    ThemeFont.send(:remove_class_variable, :@@all) rescue nil
    ThemeFont.send(:remove_class_variable, :@@options) rescue nil
    ThemeFont.send(:remove_class_variable, :@@google_fonts) rescue nil
  end

  describe ".all" do
    it "should return all theme fonts" do
      ThemeFont.all.should_not be_nil
    end

    it "should be in alphabetical order" do
      ThemeFont.all.first.name.should == 'Abril Fatface'
      ThemeFont.all.last.name.should == 'Work Sans'
    end
  end

  describe ".options" do
    before(:each) do
      stub(ThemeFont).all {[
        ThemeFont.new('One'),
        ThemeFont.new('Two'),
        ThemeFont.new('Three')
      ]}
    end

    it "should return an array of all font names" do
      ThemeFont.options.should == ['One', 'Two', 'Three']
    end
  end

  describe ".find_by_name" do
    it "should return a font by its name" do
      georgia = ThemeFont.find_by_name('Georgia')
      georgia.name.should == 'Georgia'
      georgia.family.should == 'Georgia, "Times New Roman", Times, serif'
      georgia.collection.should == 'default'
    end

    it "should return nil if the font doesn't exist" do
      ThemeFont.find_by_name('Blah').should be_nil
    end
  end

  describe ".find_family_by_name" do
    it "should return the font family by its name" do
      ThemeFont.find_family_by_name('Georgia').should == 'Georgia, "Times New Roman", Times, serif'
    end

    it "should return the font name if no font is found" do
      ThemeFont.find_family_by_name('Blah').should == 'Blah'
    end
  end

  describe ".google_font_names" do
    before(:each) do
      stub(ThemeFont).all {[
        ThemeFont.new('One Font', 'One Family', nil, 'google'),
        ThemeFont.new('Two', 'Two Family', nil, 'default'),
        ThemeFont.new('Three', 'Three Families', nil, 'google')
      ]}
    end

    it "returns a sorted array of font names in the google collection" do
      ThemeFont.google_font_names.should == ['One Font', 'Three']
    end
  end

  describe ".google_font_url_for_fonts" do
    it "should return a url for a given array of font names" do
      ThemeFont.google_font_url_for_fonts(['Oh Hey', 'Buddy', 'Yeah']).should == "//fonts.googleapis.com/css?family=Oh+Hey|Buddy|Yeah&display=swap"
    end

    it "should return a url for a singular font in an array" do
      ThemeFont.google_font_url_for_fonts(['Oh Hey']).should == "//fonts.googleapis.com/css?family=Oh+Hey&display=swap"
    end

    it "should only use unique font names" do
      ThemeFont.google_font_url_for_fonts(['Yeah', 'Buddy', 'Yeah']).should == "//fonts.googleapis.com/css?family=Yeah|Buddy&display=swap"
    end

    context "when the fonts are an array of ThemeFonts" do
      let(:fonts) do
        [
          ThemeFont.new('One Font', 'One Family', '400,500', 'google'),
          ThemeFont.new('Two Font', 'Two Families', '500,700,800', 'google')
        ]
      end

      it "includes font weights in the URL" do
        ThemeFont.google_font_url_for_fonts(fonts).should == "//fonts.googleapis.com/css?family=One+Font:400,500|Two+Font:500,700,800&display=swap"
      end
    end
  end

  describe ".google_font_url_for_all_fonts" do
    before(:each) do
      stub(ThemeFont).all {[
        ThemeFont.new('One Font', 'One Family', nil, 'google'),
        ThemeFont.new('Two', 'Two Family', nil, 'default'),
        ThemeFont.new('Three', 'Three Family', '400,600', 'google')
      ]}
    end

    it "should return a URL for all Google fonts" do
      ThemeFont.google_font_url_for_all_fonts.should == "//fonts.googleapis.com/css?family=One+Font|Three:400,600&display=swap"
    end
  end

  describe ".google_font_url_for_theme" do
    let(:fonts) {{ :header_font => {}, :body_font => {}, :paragraph_font => {} }}

    before(:each) do
      stub(ThemeFont).all {[
        ThemeFont.new('One Font', 'One Family', '400,700', 'google'),
        ThemeFont.new('Two', 'Two Family', nil, 'default'),
        ThemeFont.new('Three', 'Three Family', nil, 'google')
      ]}
    end

    it "should return a URL if a theme has multiple" do
      settings = { :header_font => 'One Font', :body_font => 'Two', :paragraph_font => 'Three' }
      ThemeFont.google_font_url_for_theme(fonts, settings).should == "//fonts.googleapis.com/css?family=One+Font:400,700|Three&display=swap"
    end

    it "should return single font name if a theme has one" do
      settings = { :header_font => 'One Font', :body_font => 'Two' }
      ThemeFont.google_font_url_for_theme(fonts, settings).should == "//fonts.googleapis.com/css?family=One+Font:400,700&display=swap"
    end

    it "should dedup" do
      settings = { :header_font => 'One Font', :body_font => 'One Font' }
      ThemeFont.google_font_url_for_theme(fonts, settings).should == "//fonts.googleapis.com/css?family=One+Font:400,700&display=swap"
    end

    it "should return nil if a theme has none" do
      settings = { :body_font => 'Two' }
      ThemeFont.google_font_url_for_theme(fonts, settings).should be_nil
    end
  end
end
