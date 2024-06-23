"Filed out from Dolphin Smalltalk"!

STON.Tests.STONTestCase
	subclass: #'STON.Tests.STONTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

STON.Tests.STONTest guid: (Core.GUID fromString: '{b7f68843-9e21-424e-96cd-9c4a89a45e6c}')!

STON.Tests.STONTest comment: ''!

!STON.Tests.STONTest categoriesForClass!STON-Tests-Facade! !

!STON.Tests.STONTest methodsFor!

testAssociationClass
	self assert: (STON fromString: '#foo : 100') class equals: STON associationClass!

testClassNameKey
	self
		assert: ((STON reader
				acceptUnknownClasses: true;
				on: 'FooBarBaz { #foo : 100 }' readStream;
				next) at: STON classNameKey)
		equals: #FooBarBaz!

testFromString
	| object |
	object := STON listClass withAll: {1. 0. -1. true. false. nil}.
	self assert: (STON fromString: '[1,0,-1,true,false,nil]') equals: object!

testFromStringWithComments
	| object |
	object := STON listClass withAll: {1. 0. -1. true. false. nil}.
	self assert: (STON
				fromStringWithComments: '// comment\[1, /* comment */ 0, -1, true, false, nil] // comment' withCRs)
		equals: object!

testListClass
	self assert: (STON fromString: '[1 , 2 , 3]') class equals: STON listClass!

testMapClass
	self assert: (STON fromString: '{ #foo : 1 , #bar : 2 }') class equals: STON mapClass!

testPrettyPrinting
	| object |
	object := STONTestUser dummy.
	self assert: (STON fromString: (STON toStringPretty: object)) equals: object.
	object := TestDomainObject dummy.
	self assert: (STON fromString: (STON toStringPretty: object)) equals: object!

testRoomExitCycles
	| model room1 room2 exit1 exit2 ston object |
	(room1 := TestMap new) at: #name put: 'Room 1'.
	(room2 := TestMap new) at: #name put: 'Room 2'.
	(exit1 := TestMap new)
		at: #name put: 'Exit 1';
		at: #origin put: room1;
		at: #destination put: room2.
	(exit2 := TestMap new)
		at: #name put: 'Exit 2';
		at: #origin put: room2;
		at: #destination put: room1.
	room1 at: #exit put: exit1.
	room2 at: #exit put: exit2.
	model := Array with: room1 with: room2.
	ston := STON toString: model.
	object := STON fromString: ston.
	"We can't just compare because this is a recursive datastructure"
	self assert: (object first at: #name) equals: 'Room 1'.
	self assert: (object second at: #name) equals: 'Room 2'.
	self assert: ((object first at: #exit) at: #name) equals: 'Exit 1'.
	self assert: ((object second at: #exit) at: #name) equals: 'Exit 2'.
	self assert: ((object first at: #exit) at: #origin) identicalTo: object first.
	self assert: ((object first at: #exit) at: #destination) identicalTo: object second.
	self assert: ((object second at: #exit) at: #origin) identicalTo: object second.
	self assert: ((object second at: #exit) at: #destination) identicalTo: object first.
	"Try writing again the parse model"
	self assert: (STON toString: object) equals: ston!

testToString
	| object |
	object := STON listClass withAll: {1. 0. -1. true. false. nil}.
	self assert: (STON toString: object) equals: '[1,0,-1,true,false,nil]'! !

!STON.Tests.STONTest categoriesForMethods!
testAssociationClass!public!tests! !
testClassNameKey!public!tests! !
testFromString!public!tests! !
testFromStringWithComments!public!tests! !
testListClass!public!tests! !
testMapClass!public!tests! !
testPrettyPrinting!public!tests! !
testRoomExitCycles!public!tests! !
testToString!public!tests! !
!

