# ValidatesExistence

This plugin adds a new `validates_existence_of` method to `ActiveRecord::Base`.

The `validates_existence_of` validator checks that a foreign key in a `belongs_to`
association points to an existing record. If `:allow_nil => true`, then the key
itself may be nil. A non-nil key requires that the foreign object must exist.
Works with polymorphic `belongs_to`.

The default error message is "does not exist".

## Example

    class Person < ActiveRecord::Base
      belongs_to :address
      validates_existence_of :address_id
    end

Note that this validation performs a query to see if the record in question exists.

*Copyright (c) 2007-2008 Josh Susser. Released under the MIT license.*
