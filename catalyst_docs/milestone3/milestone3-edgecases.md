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

- **File Reference**: `opshin/tests/test_builtins.py`

- **Edge case**: `len(x: Union[bytes, List[Anything]]) -> int`

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

- **Edge case**: `__invert__, __and__, __or__`

### Description:

While most of the dunder methods used and mentioned in type inference are tested in
`test_classmethods.py`, the following three methods are not tested.

- "**invert**",
- "**and**",
- "**or**",

### Recommendation:

Add test cases to verify the behavior of the **invert**,**and**, **or** dunder methods
in a PlutusData class.

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

The above code fails to compile with the error `AssertionError: Invalid Python, class name is undefined at this stage`. The method `my_method` defined inside the class `MyClass` is missing return type but the error message doesn't help the user understand what is wrong with the code.

### Recommendation:

Detect class methods missing return types and throw an explicit error and add a failing test case for this scenario.

## 4. Tuple ...

Though tuples don’t yet have a type syntax, user-defined functions can’t be created that take tuple arguments and tuples can still be used in other ways that lead to compilation succeeding but runtime failures, for example:

```python
def validator(a: int) -> int:
   t1 = (a, a, a)
   t2 = (a, a)

   t3 = t1 if False else t2

   return t3[2]
```

Recommendation:

In `TupleType.__ge__` in type_impls.py, the Python builtin zip function is used without checking that the lengths of its arguments are the same. This means a shorter length tuple can potentially be passed into a function whose argument expects a longer length tuple.So ensure the lengths of the TupleTypes are the same when comparing them in `TupleType.__ge__`.

Add test cases for different scenarios related to tuple assignments.

## 5. Subtypes Record and Union

- **File Reference**: `opshin/tests/test_types.py`
  Test cases missing

1. Empty = `RecordType(Record("Empty", "Empty", 0, []))`
2. Reversed field order : `A = RecordType(Record("A", "A", 0, [("foo", IntegerInstanceType), ("bar", ByteStringInstanceType)]))
A_reversed = RecordType(Record("A", "A", 0, [("bar", ByteStringInstanceType), ("foo", IntegerInstanceType)]))`
3. same fields and different constructor id

## 6. test_Unions.py

The following edge cases was identified
Duplicate entries in Unions give compiler errors, but duplicate entries in nested Unions don't.

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

```python
from opshin.prelude import *

@dataclass()
class A(PlutusData):
    x: int

def validator(a: Union[A]) -> None:
    assert isinstance(a, A)
```

```python
from opshin.prelude import *

def validator(d: Dict[Union[int, bytes], int]) -> int:
    key: Union[bytes, int] = 0
    return d[key]
```

## 7. test bitmap - to be checked

Empty bitmap (b"") not included while creating a sample

## 8. test_Stdlib.py

Attribute of listtype "index" is only tested for integers, missing other types which leads to an edge case

```python
from opshin.prelude import *

def validator(a: Anything, b: Anything) -> int:
   l: List[Anything] = [a, b]

   return l.index(b)
```

## 9. CONSTR_ID attribute for

No test cases for analysing the behaviour of CONSTR_ID attribute

```python
from opshin.prelude import

def validator(u: Union[int, bytes]) -> int:
return u.CONSTR_ID
```

## 10. Type inference of list and dicts to be tested

The type inferred for lists and dicts should be tested. The following is a edge case which lead to the fact that the type
of lists and dicts are inferred by the first entry

```python
a: Union[int, bytes] = 10
l = [a, 10, b'abcd']

a: Union[int, bytes] = 10
l = [10, a, b'abcd']
```

## 11 . Function `to_cbor_hex` not tested

```python
@dataclass()
class Employee(PlutusData):
    name: bytes
    age: int

employee = Employee(b"Alice", 30)

def validator():
    print(employee.to_cbor_hex())
```
