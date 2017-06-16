"Load in the tests appropriate for DPRO and run them,"
(Package manager includesPackageNamed: 'Dolphin Base Tests') ifFalse: [
	SourceManager default fileIn: 'RegressionTestsLoad.st']!

[| results |
results := SmalltalkSystem current runRegressionTests.
SessionManager current quit: results failureCount+results errorCount] postToInputQueue !
