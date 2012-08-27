$mocha_options = (ENV['MOCHA_OPTIONS'] || '').split(',').inject({}) { |hash, key| hash[key] = true; hash }

def debug_puts(message)
  $stderr.puts(message) if $mocha_options['debug']
end
