require 'meta_project/http/multipart'
require 'meta_project/core_ext/string'
require 'meta_project/core_ext/pathname'
require 'meta_project/core_ext/open_uri'
require 'meta_project/project_analyzer'
require 'meta_project/patois'
require 'meta_project/project'
require 'meta_project/tracker'
require 'meta_project/scm_web'
require 'meta_project/version_parser'
require 'rake/contrib/xforge'

module MetaProject
   DEFAULT_POST_OPTIONS = {
    "Content-Type" => "application/x-www-form-urlencoded",
    "User-Agent" => "curl/7.13.1 (powerpc-apple-darwin8.0) libcurl/7.13.1 OpenSSL/0.9.7i zlib/1.2.3",
    "Pragma" => "no-cache"
  }
end