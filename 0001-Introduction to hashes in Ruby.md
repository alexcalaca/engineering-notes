CRUD operations

## Creation
### 1. The literal way (Most common)
user = { name: "Alice", role: "Admin" }

### 2. The Hash.new way (Great for default values)
counts = Hash.new(0) # Default value is 0 instead of nil
counts[:apples] += 1 

### 3. The bracket syntax (Creating from an array of pairs)
pairs = Hash[ [[:id, 1], [:status, "active"]] ]

### From array of arrays to a hash
[[1, 2], 3].to_h

---

## Read
config = { db: { host: "localhost", port: 5432 }, retries: 3, status: "active" }

### 1. Standard bracket lookup (Returns nil if the key is missing)
config[:retries] 

### 2. Fetch method (Raises a KeyError if the key is missing)
config.fetch(:status) 
config.fetch(:missing) { "generated value" }

# rails exmple port = ENV.fetch("PORT")
### 3. Fetch with a default fallback (Returns "default_value" if key is missing)
config.fetch(:timeout, 30) 

### 4. Dig method (Safely traverses nested hashes without raising NoMethodError for nil)
config.dig(:db, :host) 

### 5. Values_at method (Retrieves an array of values for the specified multiple keys)
config.values_at(:retries, :status)

### 6 Set defalt value when result is `nil`
config.default = "My default value"

---
## Update
scores = { math: 90, english: 85, history: 88 }

### 1. Direct reassignment (Overwrites the existing value for a specific key)
scores[:math] = 95 

### 2. Transform_values! (Mutates the hash by applying a block to update every single value)
scores.transform_values! { |score| score + 5 } 

### 3. Transform_keys! (Mutates the hash by applying a block to update every single key)
scores.transform_keys!(&:to_s) 

### 4. Merge! with existing keys (Overwrites specific existing keys with new values)
scores.merge!(english: 92, history: 90) 

### 5. Replace method (Replaces the entire contents of the hash with the contents of another)
scores.replace({ physics: 100 })

---



