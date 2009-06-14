# Load some files from lib/ which aren't picked up by const_missing
require File.join(RAILS_ROOT, 'lib/core_extensions')
require File.join(RAILS_ROOT, 'lib/rfc822')
