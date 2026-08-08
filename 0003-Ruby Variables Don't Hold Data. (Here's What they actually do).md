### Why Does This Happen?

```
a = "Ruby"
b = a

b << "!"

puts a # => "Ruby!"
puts b # => "Ruby!"
```

Output:
```
Ruby!
Ruby!
```

Both `a` and `b` reference the exact same String object in memory. The `<<`  method mutates that underlying object in place rather than allocating a new one, so both variables observe the exact same change.

---

### Variables
A Ruby variable never actually "holds" data directly; it stores a memory reference pointing to an object.

```
name = "Ruby"
```

Think of a variable as a sticky note or a label attached to an object. Moving or copying the label doesn't duplicate the item it’s attached to.

---


### Objects
Objects are the real data residing in memory. Virtually everything in Ruby is an object—from primitive primitives to complex structures.

```
1       # Integer
"Ruby"  # String
[]      # Array
{}      # Hash
true    # TrueClass
nil     # NilClass
```

---


### References
When you assign one variable to another, Ruby copies the reference (the pointer), not the underlying object itself.

```
a = "any object"
b = a

puts a.object_id # e.g., 70120
puts b.object_id # e.g., 70120 (Identical ID means identical object)
```

---


### Memory Allocation
Ruby allocates space for objects in heap memory. Variables live on the stack or local execution contexts as simple memory addresses pointing to those heap locations.

```
str1 = "Ruby"
str2 = "Ruby"

# Two separate objects created in heap memory, despite having equal values
puts str1.object_id == str2.object_id # => false
```

---


### Object Lifecycle
An object is created in memory, used during execution, and eventually swept up by Ruby’s Garbage Collector (GC) when no variables reference it anymore.

```
# Object created
data = "temporary"

# The original reference is broken; "temporary" becomes eligible for GC
data = "new value"
```

---



### Mutable vs. Immutable
Mutable objects expose methods that modify their internal state after creation. Immutable objects cannot be modified; any operation returning a modified value creates an entirely new object in memory.

```
# Mutable (String)
str = "hello"
str.upcase! # Modifies existing object

# Immutable (Integer, Symbol, Frozen Strings)
num = 10
num += 5 # Creates a brand-new Integer object (15) and reassigns `num`
```

---


### Advantages of Mutable Objects
- Faster updates: In-place modifications avoid allocation overhead.
- Less memory churn: Fewer allocations reduce the frequency of Garbage Collection pauses.

---


### Advantages of Immutable Objects
- Predictable state: Eliminates unintended side effects across distant parts of your application.
- Easier debugging: State cannot change unexpectedly under the hood.
- Thread-safe & Functional: Safely shared across multiple threads without lock contention.

Ruby combines both approaches: most objects are mutable by default, but core primitives (like Integer, Float, Symbol, nil, true, false) are strictly immutable, and other objects can be frozen (.freeze).

---



### Demonstrating Mutability in Ruby
You can track whether an operation mutates an object or creates a new one by inspecting `object_id`.

```
# In-Place Mutation
msg = "Hello"
initial_id = msg.object_id

msg << " World"
puts msg.object_id == initial_id # => true (Same object mutated)

# Reassignment / Non-Mutating Operation
msg = msg + "!"
puts msg.object_id == initial_id # => false (New object allocated)
```

---


### Assignment vs. Mutation
It is critical to distinguish between reassigning a variable (pointing the label somewhere else) and mutating an object (changing the contents of the container).

```
x = [1, 2, 3]
y = x

# Reassignment: `x` now points to a new array; `y` still points to [1, 2, 3]
x = [4, 5, 6] 
puts y.inspect # => [1, 2, 3]

a = [1, 2, 3]
b = a

# Mutation: Mutates the array object both `a` and `b` reference
a << 4
puts b.inspect # => [1, 2, 3, 4]
```

### Real-World Production Bug Example
The Shared Default / Cached Configuration Bug
A common production issue occurs when returning a default shared object or caching class-level constants and accidentally mutating them during a request.

```
class UserReportService
  DEFAULT_OPTIONS = { format: :pdf, compress: true }.freeze # Frozen hash, but sub-values might not be!
  
  # Dangerous method
  def self.user_settings
    @user_settings ||= { permissions: ["read"] }
  end

  def grant_admin(user_hash)
    # BUG: Fetching shared array reference and mutating it directly!
    perms = self.class.user_settings[:permissions]
    perms << "admin" if user_hash[:is_admin]
  end
end

# Request 1 (Admin User)
service = UserReportService.new
service.grant_admin({ is_admin: true })

# Request 2 (Standard Non-Admin User)
puts UserReportService.user_settings[:permissions] 
# => ["read", "admin"]  <-- CRITICAL SECURITY BUG!
```

#### Why it happened:
`UserReportService.user_settings[:permissions]` returned a reference to the class-level array. Calling << "admin" mutated the shared array in heap memory instead of creating a user-specific copy. Consequently, every subsequent request—and every other user process sharing that Ruby memory space—was granted admin permissions.

#### The Fix:
Always dup/clone objects or map values when creating user-specific state from shared defaults:

```
# Fix: Create a fresh copy before mutating
perms = self.class.user_settings[:permissions].dup
```
