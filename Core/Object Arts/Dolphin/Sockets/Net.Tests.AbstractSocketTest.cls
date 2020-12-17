"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AbstractSocketTest
	instanceVariableNames: 'sockets'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractSocketTest guid: (GUID fromString: '{4b35f00d-f9e0-442d-84fd-4721213f82fd}')!
AbstractSocketTest isAbstract: true!
AbstractSocketTest comment: ''!
!AbstractSocketTest categoriesForClass!Unclassified! !
!AbstractSocketTest methodsFor!

serverSocketClass
	^self subclassResponsibility!

setUp
	super setUp.
	sockets := OrderedCollection new!

tearDown
	sockets do: [:each | [each close] on: Error do: [:ex | ]].
	sockets := nil.
	super tearDown!

testQueryPort
	"See #1317"

	| s |
	s := self serverSocketClass port: 1000.
	[self assert: s queryPort = 1000] ensure: [s close]! !
!AbstractSocketTest categoriesFor: #serverSocketClass!constants!private! !
!AbstractSocketTest categoriesFor: #setUp!private!running! !
!AbstractSocketTest categoriesFor: #tearDown!private!running! !
!AbstractSocketTest categoriesFor: #testQueryPort!public!unit tests! !

!AbstractSocketTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!AbstractSocketTest class categoriesFor: #isAbstract!public!Testing! !

