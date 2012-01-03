require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Shrt' do
  
  describe "#initiailize" do
    before(:all) do
      if File.exists?(File.expand_path('~/.bitly'))
        # Ensure zero collisions
        @path_for_back     = "~/.bitly.#{rand(Time.now.to_i)}.bak"
        @path_for_original = "~/.bitly"
        @contents          = File.read(File.expand_path(@path_for_original))          
        File.rename(File.expand_path(@path_for_original), File.expand_path(@path_for_back))         
      end  
    end
   
    it "should raise config not found error if the file is not present" do
      lambda { Shrt.new("bs") }.should raise_error(MissingConfiguration)
    end
    
    it "should raise and error if the correct keys are not found or do contain their values" do
      # SHOULD NOT exists , we already backed up what was there if there was something so this is not sometthing we care about
      File.delete(File.expand_path(@path_for_original)) if File.exists?(File.expand_path(@path_for_original))
      File.open(File.expand_path(@path_for_original), 'a') { |f| f.puts "--- \n:keys: meaningssomeorin\n:name: kuNAL\n" }
      lambda { Shrt.new("bs") }.should raise_error(InvalidConfiguration)
    end

    it "should only accept correctly formed URIS or raise an error" do
      # Temporarily give a good config
      File.rename(File.expand_path(@path_for_back), File.expand_path(@path_for_original)) 
      
      lambda { Shrt.new("bs") }.should raise_error(MalformedURL)
      # Then take it away
       File.rename(File.expand_path(@path_for_original),File.expand_path(@path_for_back)) 
    end
    
    after(:all) do
      File.rename(File.expand_path(@path_for_back), File.expand_path(@path_for_original)) 
    end
  end
  
  describe "#shorten_it!" do
    it "should have a client stored with for accessing bitly at this point" do
      Shrt.new("http://www.google.com").shorten_it!


    end
    
    
  end
  
  
end