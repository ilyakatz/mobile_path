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
# MobilePath determines when a request comes from a mobile device, redirects to a 
# mobile subdomain, and then prepends the view rendering path with app/mobile_views.  A mobile
# device can override this by using a html param of full_site=true.  
#
# @author Patrick Robertson
# @todo Split redirecting and prepending responsibilities.

require 'active_support/concern'
require 'mobile_path/configuration'

module MobilePath

  extend ActiveSupport::Concern

  included do
    before_filter :toggle_mobile_preference_cookie
    before_filter :redirect_to_mobile_if_applicable
    before_filter :prepend_view_path_if_mobile
  end


  module InstanceMethods

    private

    #
    # checks if the requesting user agent is a mobile browser. The devices
    # that return true can be configured with the mobile_device_regex.
    def mobile_browser?
      user_agent && user_agent[MobilePath.config.mobile_device_regex].present?
    end

    #
    # Checks if the incoming request is using the mobile subdomain.
    def mobile_request?
      (mobile_subdomain.present? and request.subdomains.first == mobile_subdomain) || mobile_browser?
    end

    #
    # The subdomain for the application can be configured.  This method
    # just caches the subdomain in case it is used more than once per request.
    def mobile_subdomain
      @mobile_subdomain ||= MobilePath.config.subdomain
    end


    #
    # The view path that is prepended can be configured with mobile_view_path.
    def mobile_view_path
      @mobile_view_path ||= MobilePath.config.mobile_view_path
    end

    #
    # If the request is for a mobile device, prepend the configured mobile view
    # path to the view paths.
    def prepend_view_path_if_mobile
      if mobile_request?
        prepend_view_path Rails.root + 'app' + mobile_view_path
      end
    end

    #
    # Remove the mobile sudomain from the request path and redirect.
    # Make sure to set the correct told lenght in environment configuration
    #   lvh.me
    #   config.action_dispatch.tld_length=1
    #   staging.mysite.com
    #   config.action_dispatch.tld_length=2
    def redirect_to_full_site
      redirect_to [request.protocol, request.domain, request.port_string, request.fullpath].join and return
    end

    #
    # Remove www. and add the mobile submomain to the request and redirect
    def redirect_to_mobile
      redirect_to [request.protocol,
                   mobile_subdomain, "." ,
                   request.domain,
                   request.port_string,
                   request.fullpath].join and return if mobile_subdomain.present?
    end

    #
    # If a request is mobile and the user doesn't prefer the full-site, redirect to the mobile site.
    def redirect_to_mobile_if_applicable
      unless !mobile_request? || cookies[:prefer_full_site].present?
        redirect_to_mobile and return
      end
    end

    #
    # Switch to either the mobile or the full site based upon parameters.
    def toggle_mobile_preference_cookie
      if params[:mobile_site]
        cookies.delete(:prefer_full_site)
      elsif params[:full_site]
        cookies.permanent[:prefer_full_site] = 1
      end
    end

    #
    # wrapper for the request HTTP user agent.
    def user_agent
      @user_agent ||= request.env["HTTP_USER_AGENT"]
    end
  end

end