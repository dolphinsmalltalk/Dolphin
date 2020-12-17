"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Net.Tests.AbstractSocketTest'
	instanceVariableNames: 'sockets'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.Tests.AbstractSocketTest guid: (Core.GUID fromString: '{4b35f00d-f9e0-442d-84fd-4721213f82fd}')!
Net.Tests.AbstractSocketTest isNonInstantiable: true!
Net.Tests.AbstractSocketTest comment: ''!
!Net.Tests.AbstractSocketTest categoriesForClass!Unclassified! !
!Net.Tests.AbstractSocketTest methodsFor!

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
!Net.Tests.AbstractSocketTest categoriesFor: #serverSocketClass!constants!private! !
!Net.Tests.AbstractSocketTest categoriesFor: #setUp!private!running! !
!Net.Tests.AbstractSocketTest categoriesFor: #tearDown!private!running! !
!Net.Tests.AbstractSocketTest categoriesFor: #testQueryPort!public!unit tests! !

!Net.Tests.AbstractSocketTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!Net.Tests.AbstractSocketTest class categoriesFor: #isAbstract!public!Testing! !

