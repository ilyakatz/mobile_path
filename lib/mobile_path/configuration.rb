#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

#
# The configuration class gives you a means to define a config block
# to override the defaults provided in the gem.  You can configure the
# mobile subdomain, the view path, and the regex for recognizing mobile
# devices. 
#
# @author Patrick Robertson

require 'singleton'

module MobilePath
  class Configuration
    include Singleton
    
    @@defaults = {
      :subdomain => 'm',
      :mobile_view_path => "mobile_views",
      :mobile_device_regex => /('palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                          'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                          'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                          'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                          'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|' +
                          'mobile')/i
    }
    
    def self.defaults
      @@defaults
    end
    
    def initialize
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end
    
    attr_accessor :subdomain, :mobile_view_path, :mobile_device_regex
    
  end
  
  def self.config
    Configuration.instance
  end
  
  def self.configure
    yield config
  end
end