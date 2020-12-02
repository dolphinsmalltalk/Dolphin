"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #STONTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STONTest guid: (GUID fromString: '{b7f68843-9e21-424e-96cd-9c4a89a45e6c}')!
STONTest comment: ''!
!STONTest categoriesForClass!STON-Tests-Facade! !
!STONTest methodsFor!

testFromString
	| object |
	object := STON listClass withAll: {1 . 0 . -1 . true . false . nil}.
	self assert: (STON fromString: '[1,0,-1,true,false,nil]') equals: object!

testFromStringWithComments
	| object |
	object := STON listClass withAll: { 1. 0. -1. true. false. nil }.
	self 
		assert: (STON fromStringWithComments: '// comment\[1, /* comment */ 0, -1, true, false, nil] // comment' withCRs)
		equals: object!

testPrettyPrinting
	| object |
	object := STONTestUser dummy.
	self assert: (STON fromString: (STON toStringPretty: object)) equals: object.
	object := STONTestDomainObject dummy.
	self assert: (STON fromString: (STON toStringPretty: object)) equals: object!

testRoomExitCycles
	| model room1 room2 exit1 exit2 ston object |
	(room1 := STONTestMap new) at: #name put: 'Room 1'.
	(room2 := STONTestMap new) at: #name put: 'Room 2'.
	(exit1 := STONTestMap new)
		at: #name put: 'Exit 1';
		at: #origin put: room1;
		at: #destination put: room2.
	(exit2 := STONTestMap new)
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
	object := STON listClass withAll: {1 . 0 . -1 . true . false . nil}.
	self assert: (STON toString: object) equals: '[1,0,-1,true,false,nil]'! !
!STONTest categoriesFor: #testFromString!public! !
!STONTest categoriesFor: #testFromStringWithComments!public! !
!STONTest categoriesFor: #testPrettyPrinting!public! !
!STONTest categoriesFor: #testRoomExitCycles!public! !
!STONTest categoriesFor: #testToString!public! !

