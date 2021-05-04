"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #AbstractSocketTest
	instanceVariableNames: 'sockets'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractSocketTest guid: (Core.GUID fromString: '{4b35f00d-f9e0-442d-84fd-4721213f82fd}')!
AbstractSocketTest isNonInstantiable: true!
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

