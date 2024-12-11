# Opshin - Language analysis Report

## Table of Contents

1. [Quantitative Metrics](#quantitative-metrics)
2. [Syntax Analysis](#syntax-analysis)
3. [Type System](#type-system)
4. [Code Coverage Percentage](#code-coverage-percentage)
5. [Manual Review Findings](#manual-review-findings)

# Quantitative Metrics

## Introduction to OpShin

OpShin is a programming language for developing smart contracts on the Cardano blockchain.Its syntax is 100% valid Python code and it aims to lower the barrier to entry for Cardano smart contract development. This approach allows developers to write smart contracts using familiar Python constructs while still benefiting from Cardano's robust and secure execution environment.

OpShin ensures that contracts evaluate on-chain exactly as their Python counterpart. This allows unit tests and verification of the Python code using standard tooling available for Python development. The type system of opshin is much stricter than the type system of Python, so that many optimizations can be implemented and an elevated level of security is provided.

## Syntax Analysis

OpShin presents itself as a restricted version of Python, written specifically for smart contract development on the Cardano blockchain. While it encourages developers to write code as they would in standard Python programs, it's important to note that not all Python features are available in OpShin.

OpShin's approach ensures that if a program successfully compiles, it meets two crucial criteria. Firstly, the compiled code is guaranteed to be a valid Python program.Secondly, OpShin ensures that the output of running the compiled program with Python is identical to its execution on-chain.

## Type System

One of the limitations of using Python as-is for smart contract development is that it is dynamically typed. Opshin addresses this concern by introducing a strict type system on top of Python. What Opshin does is have an independent component called the 'aggressive static type inferencer', which can infer all types of the Python AST nodes for a well chosen subset of Python.So in simple terms every variable in OpShin has a type. There are no opaque type sin OpShin,everything can be deconstructed.

Currently, OpShin supports only Lists and Dicts. It does not support tuples and generic types, which we see as a limitation, as these can be really valuable when writing smart contracts. This might require workarounds to achieve the desired functionality.

## Compilation and Execution

OpShin provides a toolkit to evaluate the script in Python,compile the script to UPLC, and compiel the script to `pluto`, an intermediate language for debugging purposes.

It offers a straightforward API to compile, load, apply parameters and evaluate smart contracts locally. The build process creates all required files for integration with off-chain libraries like pycardano and LucidEvolution. Key features include the ability to build validators from Python files, apply parameters during or after compilation, store and load compilation artifacts, and access important contract information such as addresses and blueprints.

## Metrics using Gastronomy

create a sample example of adding 1 to an input and evaluate the uplc generated for aiken and opshin

# Code Coverage Percentage

Currently, the unit tests primarily focuses on the builtins,hash library, operations,keywords,ledger functionalities and standar library functions.
The Unit tests that is available covers 80% of the codebase.(Check if 80% of codebase can be used)

OpShin's codebase includes two additional modules, `opshin.rewrite` and `opshin.optimize`, which play crucial roles in enhancing the smart contract compiling process. The `opshin.rewrite` module performs various rewriting steps that remove complexity from Python source code. Meanwhile, the `opshin.optimize` module ensures better performance through targeted optimizations. Given the importance of these modules in the OpShin ecosystem, we strongly recommend expanding the unit test coverage to include them.

# Manual Review Findings

The document herein is provided as an interim update detailing the findings of our
ongoing audit process on the opshin repository. It is crucial to understand that this
document does not constitute the final audit report. The contents are meant to offer a
preliminary insight into our findings up to this point and are subject to change as our
audit progresses.

## Summary of Findings Across Categories

1. Security -
2. Performance -
3. Maintainability -
4. Others -

# Recommendations for Improvements

## Finding01 - Improving Error Clarity -- minor or information?

While the `opshin eval` command provides a valuable tool for evaluating scripts in Python, its error reporting can be enhanced to provide more user-friendly and informative feedback. Currently, when incorrect arguments or mismatched types are provided, the error messages may not clearly indicate the source or nature of the problem. We recommend implementing more specific error messages that pinpoint the problematic argument, indicate its position, and clearly state the expected type. Additionally, echoing the provided input, and suggesting corrections, for detailed debugging information could significantly improve the user experience and reduce troubleshooting time. These enhancements would make the tool more accessible, especially for developers new to OpShin or smart contract development on Cardano.

```py
def validator(datum: WithdrawDatum, redeemer: None, context: ScriptContext) -> None:
    sig_present = datum.pubkeyhash in context.tx_info.signatories
    assert (
        sig_present
    ), f"Required signature missing, expected {datum.pubkeyhash.hex()} but got {[s.hex() for s in context.tx_info.signatories]}"
```

When this command is executed in the CLI

        `opshin eval spending examples/smart_contracts/gift.py "{\"constructor\": 0,\"fields\":[
        {\"bytes\": \"1e51fcdc14be9a148bb0aaec9197eb47c83776fb\"}]}" None d8799fd8799f9fd8799fd8799fd8799f582055d353acacaab6460b37ed0f0e3a1a0aabf056df4a7fa1e265d21149ccacc527ff01ffd8799fd8799fd87a9f581cdbe769758f26efb21f008dc097bb194cffc622acc37fcefc5372eee3ffd87a80ffa140a1401a00989680d87a9f5820dfab81872ce2bbe6ee5af9bbfee4047f91c1f57db5e30da727d5fef1e7f02f4dffd87a80ffffff809fd8799fd8799fd8799f581cdc315c289fee4484eda07038393f21dc4e572aff292d7926018725c2ffd87a80ffa140a14000d87980d87a80ffffa140a14000a140a1400080a0d8799fd8799fd87980d87a80ffd8799fd87b80d87a80ffff80a1d87a9fd8799fd8799f582055d353acacaab6460b37ed0f0e3a1a0aabf056df4a7fa1e265d21149ccacc527ff01ffffd87980a15820dfab81872ce2bbe6ee5af9bbfee4047f91c1f57db5e30da727d5fef1e7f02f4dd8799f581cdc315c289fee4484eda07038393f21dc4e572aff292d7926018725c2ffd8799f5820746957f0eb57f2b11119684e611a98f373afea93473fefbb7632d579af2f6259ffffd87a9fd8799fd8799f582055d353acacaab6460b37ed0f0e3a1a0aabf056df4a7fa1e265d21149ccacc527ff01ffffff`

This error is encountered: `ValueError: non-hexadecimal number found in fromhex() arg at position 0`. The actual issue is caused at the second argument, where None has been passed instead of a Plutus data object for Nothing.

### Recommendation

## Finding02 - Lack of Tests for Static Type Inferencer Module

OpShin parses the Python code into an Abstract Syntax Tree (AST), which serves as the foundation for subsequent analysis. The compiler then performs static type inference on the AST nodes, inferring types for variables, functions, and expressions without requiring explicit type annotations. This step is crucial for ensuring type safety and catching potential errors early in the development process.

### Recommendation

Since the module `opshin.type_inference` plays a crucial role in transforming and assigning types to every variable, we strongly recommend implementing unit tests for the class `AggressiveTypeInferencer` under `opshin.type_inference` module to ensure its functionality and reliability.

## Finding03 - Missing name of the validator function

At present, the `opshin build` command compiles the validator and writes the artifacts to the build folder under the name of the validator. The `blueprint.json` file is created, containing the compiled code, datum, and redeemer details.The title of the validator is missing in the `blueprint.json` file.

### Recommendation

Although the file `blueprint.json` lies at the client-side, including the name of the validator as a `title` would be helpful for debugging and referencing during off-chain validation.
