require File.dirname(__FILE__) + '/../lib/active_document'

TEST_ROOT = File.expand_path(File.dirname(__FILE__))
FIXTURES_ROOT =  TEST_ROOT + '/fixtures'

Spec::Runner.configure do |config|
  config.before(:all) do
    @sample_post_name = "sample_post.haml"
    @sample_post = File.join(FIXTURES_ROOT,@sample_post_name)
  end
end