#http://redhanded.hobix.com/bits/hashCollect.html
module Enumerable
 def build_hash
   result = {}
   self.each do |elt|
     key, value = yield elt
     result[key] = value
   end
   result
 end
end

class Hash
 alias collect build_hash

 def collect!( &blk )
   self.replace( build_hash( &blk ) )
 end
 alias map! collect!
end