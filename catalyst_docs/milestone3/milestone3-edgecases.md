# OpShin Edge Case Audit Report

**Milestone Title** : Milestone3 - Edge Case Identification  
**Submission Date** :
**Audit Team** : Anastasia Labs  
**Repository** : [Opshin Repository](https://github.com/OpShin/opshin)

## Executive Summary

We audited Opshin codebased and have compiled a documented list of edge cases relevant to smart contract development. We have also proposed strategies for resolving identified cases that can be applied to future iterations of the language. The work was conducted manually.

## Edge cases

## 1. Lack of namespaced imports

### **Description**

User defined symbols can only be imported using `from <pkg> import *`, and every time such a statement is encountered the complete list of imported module statements is inlined. This can lead to a lot of duplicate statements, and quickly pollutes the global namespace with every symbol defined in every (imported) package.

The following scenarios explain why this is a critical problem.

#### **Scenario 1**

Imagine both a singular name (eg. `asset`) and a plural name (eg. `assets`) are defined somewhere in the OpShin smart contract codebase or external libraries. The programmer makes a typo and unknowingly uses the wrong variable (e.g. `asset` instead of `assets`). Due to type inference the value of the wrongly used variable might actually have a type that passes the type check (eg. both `asset` and `assets` allow calling `len()`). The program compiles and seems to work even though it doesn’t match the programmer's intent.

#### **Scenario 2**

The codebase defines a variable with the same name and type multiple times, but each time another value is assigned. For the programmer it is ambiguous which value will actually be used when referencing the variable. The programmer doesn’t know enough about the library code being imported to intuitively figure out which variable shadows all the others.

#### **Scenario 3**

```python
@dataclass()
class Address(PlutusData):
    street: bytes
    city: bytes
    zip_code: int

@dataclass()
class Employee(PlutusData):
    name: bytes
    age: int
    address: Address
```

This code defines a custom class named `Address`, which shadows the built-in Address type from the Cardano ecosystem.
It throws a type inference error. However, it should show a warning indicating that the name is shadowed.

#### **Scenario 4**

The code checks for the length of imports, empty asnames, and \* as a name (lines 76–84), but it does not check for duplicate imports. This allows the same module to be imported multiple times without warnings or errors.

```python
from typing import Dict, List, Union
from typing import Dict, List, Union
from typing import Dict, List, Union
```

These imports can be given any number of times, leading to redundant code.

### **Recommendation**

The current OpShin import mechanism is generally poorly implemented, also for builtins:

- The `hashlib` functions are handled differently from `opshin.std`, yet there is no obvious reason why they should be treated differently
- The `check_integrity` macro is added to the global scope with its alias name, meaning it suddenly pollutes the namespace of upstream packages.
- Some of the builtin imports suffer from the same issue as imports of user defined symbols: duplication.
- `Dict, List, Union` must be imported in that order from `typing`
- The `Datum as Anything` import from `pycardano` seems to only exist to help define `Anything` for eg. IDEs, but `Anything` is actually defined elsewhere.

Though the import of builtins will be hidden behind `opshin.prelude` for most users, it is still not implemented in a maintainable way.

A complete overhaul of the import mechanism is recommended, including the implementation of the `import <pkg>` syntax. The OpShin AST should be able to have multiple Module nodes, each with their own scope.

Nice to have:

- Use `.pyi` files for builtin packages, and define the actual builtin package implementation in code in importable scopes
- OpShin specific builtins should be importable in any pythonic way, even with aliases. Name resolution should be able to figure out the original builtin symbol id/name.
- Detect which python builtins and OpShin builtins are being used, and only inject those.
- Don't expose `@wraps_builtin` decorator
- Builtin scope entries can be given a "forbid override" flag, instead of having to maintain a list of forbidden overrides in `rewrite/rewrite_forbidden_overwrites.py`
- Implement a warning for shadowing (instead of e.g. the type inference error thrown in scenario 3). This would help developers catch potential issues early without halting compilation.

## 2. No Copies of Middle Expression

### **Description**

When rewriting chained comparisons to individual comparisons combined with `and` for e.g.
`<expr-a> < <expr-b> < <expr-c> to (<expr-a> < <expr-b>) and (<expr-b> < <expr-c>)`
in `rewrite/rewrite_comparison_chaining.py`, no copies of `<expr-b>` seem to be created, leading to the same AST node instance appearing twice in the AST.

The compiler steps frequently mutate the AST nodes instead of creating copies, which can lead to difficult to debug issues in this case.

### **Recommendation**

Similar to `rewrite/rewrite_tuple_assign.py`, create temporary variables for each of the middle expressions in the chain. Then refer to those temporary variables in the resulting BinOp expressions.

This approach avoids the issue described and also avoids the recalculation of the same expression (potentially expensive).

## 3. Type safe tuple unpacking

### **Description**

Tuple unpacking (step 7) is currently being rewritten before the ATI (aggressive type inference) step. This allows writing unpacking assignments with a mismatched number of tuple entries.

If there there are more names on the left side this throws a non-user friendly FreeVariableError. If there are less the rewritten code is valid, even though in python it wouldn't be valid, thus violating the expected "strict subset of python" behavior.

There might be other ways this can be abused to get inconsistent behavior.

### **Recommendation**

Perform this step after type inference. Check tuple types during type inference.

## 4. Non-friendly Error Messages

### **Description**

Using `import <pkg>` or `import <pkg> as <aname>` isn’t supported and throws a non-user friendly error: "free variable '\<pkg-root\>' referenced before assignment in enclosing scope".

### **Recommendation**

Perform this step after type inference. Check tuple types during type inference.
