# OpShin Edge Case Audit Report

**Milestone Title** : Milestone3 - Edge Case Identification  
**Submission Date** :
**Audit Team** : Anastasia Labs  
**Repository** : [Opshin Repository](https://github.com/OpShin/opshin)

## Executive Summary

This report documents edge cases in OpShin smart contract development identified through manual code review. It provides actionable strategies to resolve these issues that can be applied to future iterations of the language.

### Scope

We took the following approach to list the edge cases:

- Cross-referencing unit test files under `opshin/tests` against language specifications to uncover untested functionality.

- Incorporating documented edge cases from Milestone 2 to highlight high-risk scenarios lacking test coverage.

## Edge cases

## 1. `len()` Builtin Untested Edge Cases

**Description:**  
The `len(x: Union[bytes, List[Anything]])` function lacks unit tests for:

- Empty inputs (`b""`, `[]`).
- `None` or invalid types (should raise compile-time/runtime errors).

**Recommendation:**

```python
# Add to test_builtins.py
def test_len_edge_cases():
    assert len(b"") == 0  # Empty bytes
    assert len([]) == 0   # Empty list
    with pytest.raises(Exception):
        len(None)         # Invalid input
```

2. Missing UPLC Dunder Methods
   Description:
   UPLC builtins for dunder methods (e.g., **invert**, **and**, **or**) are unimplemented.

Recommendation:

Add UPLC bindings for these methods in the compiler.

```python
class X:
    def __invert__(self): return self
assert (~X()) is not None

```

3. Class Methods with No Return Type
   Description:
   No test coverage for class methods lacking return annotations:

python
@dataclass  
class MyClass(PlutusData):  
 def my_method(self): # No -> None  
 pass  
Recommendation:

Add to test_class_methods.py:

python
def test_no_return_type_method():  
 c = MyClass()  
 assert c.my_method() is None # Implicit None return  
4. Short-Circuit Evaluation Missing
Description:
Operators and/or do not short-circuit (e.g., x and error() evaluates error() even if x is falsy).

Recommendation:

Enforce Python-like behavior in the compiler.

Test case:

python
def validator(x: bool) -> bool:  
 return x and error("Skip if x is False") # Must not evaluate RHS if x=False  
5. Type System Gaps
5.1 Union Types Untested
Description:
No tests for Union[A] or isinstance() with complex unions.

Recommendation:

python

# Add to test_types.py

def test_union_edge_cases():  
 assert isinstance(1, Union[int]) # Single-type union  
 assert not isinstance(1, Union[bytes])  
5.2 Record Field Order Sensitivity
Description:
RecordType subtyping ignores field order (e.g., A(foo, bar) vs A(bar, foo)).

Recommendation:

Clarify in docs whether order matters.

Add test:

python
A = RecordType([("foo", int), ("bar", bytes)])  
A_reversed = RecordType([("bar", bytes), ("foo", int)])  
assert A >= A_reversed # Should this be True?  
6. Control Flow: while False Undefined Behavior
Description:

python
def validator(\_: None) -> int:  
 while False:  
 a = 10  
 return a # Compiles but fails (undefined `a`)  
Recommendation:

Compiler should warn about unreachable code/undefined variables.

7. Tuple Index Out of Range
   Description:
   No tests for tuple index bounds checking (e.g., x: Tuple[int] = (1,); x[1]).

Recommendation:

Add runtime checks or compile-time errors.

Test case:

python
def validator() -> int:  
 x = (1,)  
 return x[1] # Should fail  
8. Boolean/Integer Comparison Quirk
Description:

python
def validator(x: bool, y: int) -> bool:  
 return x == y # Works for any `y` (e.g., `True == 1`)  
Recommendation:

Restrict comparisons to same types (or document this behavior).

Next Steps
Prioritize Critical Fixes:

Short-circuiting (EC-12), while False (EC-09).

Expand Test Suite:

Add all recommended test cases.

Document Behavior:

Clarify edge cases in OpShin docs (e.g., type comparisons).

Template Usage:

Add new findings as H2 headers (##).

Use code blocks for examples/recommendations.

Update Status inlined (e.g., **Status:** Fixed in v1.2).

This format is:

- **Actionable:** Clear recommendations for each issue.
- **Scalable:** Easy to add new findings as sections.
- **Markdown-Ready:** Directly usable in GitHub/GitLab.

Let me know if you'd like adjustments (e.g., severity labels, more code examples)!
