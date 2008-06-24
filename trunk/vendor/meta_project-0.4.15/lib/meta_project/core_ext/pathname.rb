require 'pathname'

# TODO: extend this to find comments
# http://ostermiller.org/findcomment.html

module PathnameIterator
 def iterate(proc, &block)
   if directory?
     children.each do |c|
       c.iterate(proc)
     end
   else
     proc.call(self, &block)
   end
 end

 def egrep(regexp, &block)
   proc = Proc.new do |file|
     file.open do |io|
       count = 0
       while line = io.gets
         count += 1
         if line =~ regexp
           block.call("#{file.cleanpath}:#{count}:#{line}")
         end
       end
     end
   end
   iterate(proc, &block)
 end

end

class Pathname
 include PathnameIterator
end
