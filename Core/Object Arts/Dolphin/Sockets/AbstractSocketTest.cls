"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AbstractSocketTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractSocketTest guid: (GUID fromString: '{4b35f00d-f9e0-442d-84fd-4721213f82fd}')!
AbstractSocketTest comment: ''!
!AbstractSocketTest categoriesForClass!Unclassified! !
!AbstractSocketTest methodsFor!

serverSocketClass
	^self subclassResponsibility!

testQueryPort
	"See #1317"

	| s |
	s := self serverSocketClass port: 1000.
	[self assert: s queryPort = 1000] ensure: [s close]! !
!AbstractSocketTest categoriesFor: #serverSocketClass!private!unit tests! !
!AbstractSocketTest categoriesFor: #testQueryPort!public!unit tests! !

!AbstractSocketTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!AbstractSocketTest class categoriesFor: #isAbstract!public!Testing! !

