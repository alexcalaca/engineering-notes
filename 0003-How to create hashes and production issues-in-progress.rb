1. The literal way (Most common)
user = { name: "Alice", role: "Admin" }
user.default = 'default'

2. The Hash.new way (Great for default values)
counts = Hash.new(0) # Default value is 0 instead of nil counts[:apples] += 1

3. The bracket syntax (Creating from an array of pairs)
pairs = Hash[ [[:id, 1], [:status, "active"]] ]

From array of arrays to a hash
[[1, 2], 3].to_h
  

Mutable defaults
Duplicate keys
Missing versus nil
Merge precedence
Key normalization
Mutable keys
