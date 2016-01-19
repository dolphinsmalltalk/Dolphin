"Load in the tests appropriate for DPRO and run them,"
SourceManager default fileIn: 'RegressionTestsLoad.st'!

[| results |
results := SmalltalkSystem current runRegressionTests.
SessionManager current quit: results failureCount+results errorCount] postToInputQueue !