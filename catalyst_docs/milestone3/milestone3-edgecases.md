# OpShin Edge Case Identification Report

**Project**: OpShin Audit  
**Milestone Title** : Milestone3 - Edge Case Identification  
**Submission Date** : 02-June-2025  
**Audit Team** : Anastasia Labs  
**Repository** : [Opshin Repository](https://github.com/OpShin/opshin)

## Executive Summary

This report documents 9 edge cases across the OpShin compiler codebase and test suite, identified through manual code review.
Each case highlights a gap in either functionality coverage or robustness in the current implementation of the language.

For each edge case, we have provided actionable strategies, such as expanding test coverage, improving type-checking logic, and refining error handling.
Implementing these changes will enhance OpShin’s reliability, improve the developer experience and strengthen its overall readiness for production-level smart contract development.

## Scope

We took the following approach to list the edge cases:

- Cross-referencing unit test files under `opshin/tests` against language specifications to uncover untested functionality.

- Incorporating documented edge cases from Milestone 2 to highlight high-risk scenarios lacking test coverage.

## Edge cases

### 1. Untested builtin `len()`for some types of `List[Anything]`

- File Reference: `opshin/tests/test_builtins.py`

- Edge case:

```python
len(x: Union[bytes, List[Anything]]) -> int
```

#### Description:

The `test_builtins.py` file includes unit tests for len(x) with bytes, tuples, dicts, and List[int]. However, it appears that tests for `List[Anything]` with other valid types (e.g., List[bytes], List[bool], etc.) are missing.

#### Recommendation:

We recommend to add additional test cases for the `len` built-in function to cover more variations of
`List[Anything]`, other than `List[int]`. Also include edge cases like empty bytes and empty lists.

### 2. Missing test cases for Dunder Methods

- File Reference: `opshin/tests/test_classmethods.py`

- Edge case(s): `__invert__, __and__, __or__`

#### Description:

While most of the dunder methods used and mentioned in type inference are tested in
`test_classmethods.py`, the following three methods are missing relevant test cases.

- "**invert**",
- "**and**",
- "**or**",

#### Recommendation:

Add test cases to verify the behavior of the **invert**,**and**, **or** dunder methods
in the PlutusData class.

### 3. Class Methods with No Return Type

- File Reference: `opshin/tests/test_classmethods.py`

- Edge case:

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

#### Description:

The above code fails to compile with the error `AssertionError: Invalid Python, class name is undefined at this stage`.
The method `my_method` defined inside the class `MyClass` is missing return type but the error message doesn't help the user understand what is wrong with the code.

#### Recommendation:

Detect class methods missing return types and throw an explicit error and add a failing test case for this scenario.

### 4. Missing Test Cases for Tuple Assignments

- Edge case:

```python
def validator(a: int) -> int:
   t1 = (a, a, a)
   t2 = (a, a)

   t3 = t1 if False else t2

   return t3[2]
```

#### Description:

Though tuples don’t yet have a type declaration syntax (and therefore user-defined functions can’t be created to take tuple arguments), tuples can still be used in other ways that may lead to successful compilation but result in runtime failures, as shown in the example above.

#### Recommendation:

We recommend adding test cases to cover various tuple-related scenarios for example:

- Assigning a tuple of one length to a variable expected to have a different length.
- Unpacking a tuple into variables where the number of variables doesn't match the tuple length.
- Comparing tuples of different lengths.
- Accessing indices or slices that are out of bounds for a tuple.

### 5. Test cases for different scenarios of Subtypes in Record

- File Reference: `opshin/tests/test_types.py`
- Edge Case:

1. Empty records are not included in the test cases, which can lead to unexpected/unspecified behavior.

2. There are no test cases for records with fields in a different order.

3. There are no test cases for records that have the same fields but different constructor IDs.

#### Recommendation:

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

### 6. Uncovered Scenarios in `Union` Type Behavior

- File Reference: `opshin/tests/test_Unions.py`
- Edge Cases:
  The following edge cases were not included in the test suite.

  1.Duplicate entries in `Union`s give compiler errors, but duplicate entries in nested `Union`s don't.

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

3. `Dict` with `Union` type key, can't be accessed with a `Union` type which has the same entries but in a different order.

```python
from opshin.prelude import *

def validator(d: Dict[Union[int, bytes], int]) -> int:
    key: Union[bytes, int] = 0
    return d[key]
```

#### Recommendation:

1. It is recommended to detect duplicate `CONSTR_ID`s after flattening the `Union` in `union_types()` within `type_inference.py`.
   Duplicates should be identified based on `CONSTR_ID`, regardless of data field equivalence.

2. The compiler should detect `Union`s containing only a single entry, and throw an explicit error.

3. We recommend to sort the `Union` entries in an unambiguous manner within the `union_types()` function in `type_inference.py`.

Corresponding test cases should be added to cover each of the scenarios described above.

### 7. Explicit testing for edge cases in bitmap and fractions

- File Reference: `opshin/tests/test_bitmap.py`,`opshin/tests/test_fractions.py`
- Edge Case:

`test_fractions.py`: The existing sample cases does not include scenarios where the denominator is zero.

`test_bitmap.py`: Similarly there are no test cases covering empty bytestring inputs and negative input values (e.g. creating a bitmap with a negative length).

#### Recommendation:

Add explicit test cases for

- Denominator = 0 in fractions (to check handling of division by zero).
- Empty bytestrings and negative index/length values in bitmap operations.

### 8. Index type not tested for different types

- File Reference: `opshin/tests/test_stdlib.py`

- Edge Case:

Attribute of listtype "index" is only tested for integers, missing other types, for example:

```python
from opshin.prelude import *

def validator(a: Anything, b: Anything) -> int:
   l: List[Anything] = [a, b]

   return l.index(b)
```

#### Recommendation:

In the `index` method defined in `ListType.attribute()` in `type_impls.py`, update the check to accommodate other primitive types, and add corresponding test cases to ensure coverage.

### 9. No test cases for `CONSTR_ID` attribute.

- Edge Case:

No test cases for validating the computation of `CONSTR_ID` attributes.
The following edge cases are valid in OpShin, but isn't consistent with how attributes are used in other types (e.g. `Union`s).

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

#### Recommendation:

1. Remove the `CONSTR_ID` attribute for `Anything`.
2. Do not expose the `CONSTR_ID` attribute of `Union`s which contain some non-`ConstrData` types.
