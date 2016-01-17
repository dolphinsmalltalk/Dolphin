"Load in the tests appropriate for DPRO and run them,"
Package manager install: 'Core\Object Arts\Dolphin\Base\Dolphin Base Tests.pax'.

[
Processor sleep: 5000.
SmalltalkSystem current runRegressionTests.
SessionManager current quit] postToInputQueue!