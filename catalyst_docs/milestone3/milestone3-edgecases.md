# OpShin Edge Case Identification Report

**Project**: OpShin Audit  
**Milestone Title** : Milestone3 - Edge Case Identification  
**Submission Date** : 23-May-2025  
**Audit Team** : Anastasia Labs  
**Repository** : [Opshin Repository](https://github.com/OpShin/opshin)

## Executive Summary

This report documents untested edge cases in the OpShin compiler code base identified through manual code review.
We also aim to provide actionable strategies to resolve these issues that can be applied to future iterations of the language.

### Scope

We took the following approach to list the edge cases:

- Cross-referencing unit test files under `opshin/tests` against language specifications to uncover untested functionality.

- Incorporating documented edge cases from Milestone 2 to highlight high-risk scenarios lacking test coverage.

# Edge cases

## 1. Untested builtin `len()`

- **File Reference**: `opshin/tests/test_builtins.py`

- **Edge case**:

```python
len(x: Union[bytes, List[Anything]]) -> int
```

### **Description:**

The `test_builtins.py` file currently lacks unit tests for the `len(x: Union[bytes, List[Any]])` function, which is documented
in the OpShin book as part of the supported Python built-in functions being implemented in OpShin.

### **Recommendation:**

Add test cases for the builtin function for differest test inputs including empty bytes and lists.

## 2. Missing test cases for Dunder Methods

- **File Reference**: `opshin/tests/test_classmethods.py`

- **Edge case(s)**: `__invert__, __and__, __or__`

### Description:

While most of the dunder methods used and mentioned in type inference are tested in
`test_classmethods.py`, the following three methods are missing relevant test cases.

- "**invert**",
- "**and**",
- "**or**",

### Recommendation:

Add test cases to verify the behavior of the **invert**,**and**, **or** dunder methods
in the PlutusData class.

## 3. Class Methods with No Return Type

- **File Reference**: `opshin/tests/test_classmethods.py`

- **Edge case**:

```python
from opshin.prelude import *

@dataclass()
class MyClass(PlutusData):
    def my_method(self):
        pass

def validator(_: None) -> None:
    c = MyClass()
    c.my_method()
```

### Description:

The above code fails to compile with the error `AssertionError: Invalid Python, class name is undefined at this stage`.
The method `my_method` defined inside the class `MyClass` is missing return type but the error message doesn't help the user understand what is wrong with the code.

### Recommendation:

Detect class methods missing return types and throw an explicit error and add a failing test case for this scenario.

## 4. Missing Test Cases for Tuple Assignments

- **Edge case**:

```python
def validator(a: int) -> int:
   t1 = (a, a, a)
   t2 = (a, a)

   t3 = t1 if False else t2

   return t3[2]
```

### Description:

Though tuples don’t yet have a type declaration syntax (and therefore user-defined functions can’t be created to take tuple arguments), tuples can still be used in other ways that may lead to successful compilation but result in runtime failures, as shown in the example above.

### Recommendation:

In `TupleType.__ge__` in `type_impls.py`, the Python builtin `zip` function is used without checking that the lengths of its arguments are the same. This means a shorter length tuple can potentially be passed into a function whose argument expects a longer length tuple.So ensure the lengths of the TupleTypes are the same when comparing them in `TupleType.__ge__`.

Add test cases for different scenarios related to tuple assignments.

## 5. Test cases for different scenarios of Subtypes in Record

- **File Reference**: `opshin/tests/test_types.py`
- **Edge Case**:

1. Empty records are not included in the test cases, which leads to a lack of validation for subtyping behavior with empty records.

2. There are no test cases for records with fields in a different order.

3. There are no test cases for records that have the same fields but different constructor IDs.

### Recommendation:

We recommend to add similar tests for the above mentioned edge cases

1. Empty Records:

```
Empty = RecordType(Record("Empty", "Empty", 0, []))
```

2. Reversed field order:

```
A = RecordType(Record("A", "A", 0, [("foo", IntegerInstanceType), ("bar", ByteStringInstanceType)]))

A_reversed = RecordType(Record("A", "A", 0, [("bar", ByteStringInstanceType), ("foo", IntegerInstanceType)]))
```

3. `Records` having same fields but different constructor ids.

```
A = RecordType(Record("A", "A", 0, [("foo", IntegerInstanceType), ("bar", ByteStringInstanceType)]))

A_diff_constr = RecordType(Record("A", "A", 1, [("foo", IntegerInstanceType),("bar", ByteStringInstanceType)]))

```

## 6. Uncovered Scenarios in `Union` Type Behavior

- **File Reference**: `opshin/tests/test_Unions.py`
- **Edge Cases**:
  The following edge cases were not included in the test suite.

  1.Duplicate entries in `Unions` give compiler errors, but duplicate entries in nested `Unions` don't.

```python
from opshin.prelude import *

@dataclass()
class A(PlutusData):
    CONSTR_ID = 1
    a: bytes

@dataclass()
class B(PlutusData):
    CONSTR_ID = 2
    a: int
    b: int

@dataclass()
class C(PlutusData):
    CONSTR_ID = 2
    a: int
    b: int

def validator(_: Union[Union[A, B], C]) -> None:
    pass
```

### Recommendation :

It is recommended to detect duplicate `CONSTR_ID`s after flattening the `Union` in `union_types()` within `type_inference.py`.
Duplicates should be identified based on `CONSTR_ID`, regardless of data field equivalence.

2. `Union`s with no entries or only one entry are not tested.
   Compiling the following code throws an unrelated error message: `'Name' object has no attribute 'elts'`.

```python
from opshin.prelude import *

@dataclass()
class A(PlutusData):
    x: int

def validator(a: Union[A]) -> None:
    assert isinstance(a, A)
```

### Recommendation:

The compiler should detect `Union`s containing only a single entry, and throw an explicit error.

3. `Dict` with `Union` type key, can't be accessed with a `Union` type which has the same entries but in a different order.

```python
from opshin.prelude import *

def validator(d: Dict[Union[int, bytes], int]) -> int:
    key: Union[bytes, int] = 0
    return d[key]
```

### Recommendation:

We recommend to sort the `Union` entries in an unambiguous manner within the `union_types()` function in `type_inference.py`.

## 7. Explicit testing for edge cases in bitmap and fractions

- **File Reference**: `opshin/tests/test_bitmap.py`,`opshin/tests/test_fractions.py`
- **Edge Case**:

`test_fractions.py`: The existing sample cases exclude scenarios where the denominator is zero.

`test_bitmap.py`: Similar oversight with excluding empty bytestrings and negative values,these should also be tested to ensure robustness.

### Recommendation:

Add explicit test cases for

- Denominator = 0 in fractions (to check handling of division by zero).
- Empty bytestrings and negative index values in bitmap operations.

## 8. Index type not tested for different types

- **File Reference**: `opshin/tests/test_stdlib.py`

- **Edge Case**:

Attribute of listtype "index" is only tested for integers, missing other types which leads to the following edge case that wasn't tested.

```python
from opshin.prelude import *

def validator(a: Anything, b: Anything) -> int:
   l: List[Anything] = [a, b]

   return l.index(b)
```

### Recommendation:

In the `index` method, defined in `ListType.attribute()` in `type_impls.py`, change the check to `EqualsData(transform_output_map(itemType)(x), transform_output_map(itemType)(HeadList(xs)))`.

## 9. No test cases for `CONSTR_ID` attribute.

- **Edge Case**:

No test cases for analysing the behaviour of `CONSTR_ID` attribute.
The following edge cases are valid OpShin, but isn't consistent with how attributes are exposed of regular `Union`s (they must exist on each subtype), and can lead to unexpected runtime errors.

```python
from opshin.prelude import *

def validator(l: List[Anything]) -> int:
    return l[0].CONSTR_ID
```

```python
from opshin.prelude import

def validator(u: Union[int, bytes]) -> int:
return u.CONSTR_ID
```

### Recommendation:

1. Remove the `CONSTR_ID` attribute for `Anything`.
2. Don't expose the `CONSTR_ID` attribute of `Union`s which contain some non-`ConstrData` types.

# Summary

This report identifies and analyzes 9 edge cases across the OpShin codebase and test suite.
Each case highlights a gap in either functionality coverage or robustness in the current implementation of the language.

For each edge case, we have proposed actionable recommendations, such as test coverage expansion,and improvements to type checking logic.
Implementing these changes will improve OpShin’s reliability, developer experience, and readiness for production smart contract development.

# Validation by OpShin Team

**Reviewers**:[]  
**Date Reviewed**: []  
**Feedback Summary**:[]
