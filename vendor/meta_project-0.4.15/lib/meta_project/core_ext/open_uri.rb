require 'open-uri'

# Wrapper around Kernel.open from open-uri
# that can retry and report better errors
def better_open(url, headers=nil, retries=2, &block)
  begin
    # open-uri's open
    headers.nil? ? Kernel.open(url, &block) : Kernel.open(url, headers, &block)
  rescue Errno::ECONNREFUSED, EOFError => e
    if(retries > 0)
      STDERR.puts "Connection refused to #{url} - retrying in 1 sec."
      sleep 1
      better_open(url, headers, retries-1, &block)
    else
      e.message << " (URL:#{url})"
      raise e
    end
  rescue OpenURI::HTTPError => e
    e.message << " (URL:#{url})"
    raise e
  end
end
