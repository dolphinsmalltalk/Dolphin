"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ExternalStructureTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalStructureTest guid: (GUID fromString: '{a9244232-e68c-4a65-bbf2-c8392aee459b}')!
ExternalStructureTest comment: 'SUnitBrowser openOnTestCase: self'!
!ExternalStructureTest categoriesForClass!Unclassified! !
!ExternalStructureTest methodsFor!

testEquals
	| s1 s2 s3 s4 |
	s1 := POINTL newPointer.
	s2 := POINTL newPointer.
	self assert: s1 equals: s1.
	self assert: s1 equals: s2.
	s1 := (1 @ 2) asParameter.
	self deny: s1 equals: s2.
	self assert: s1 equals: s1.
	s3 := POINTL fromAddress: s1 yourAddress.
	self assert: s3 equals: s3.
	self assert: s1 equals: s3.
	self deny: s2 equals: s3.
	self deny: s3 equals: s2.
	s2 := (1 @ 2) asParameter.
	self assert: s1 equals: s2.
	self assert: s2 equals: s1.
	self assert: s1 equals: s3.
	self assert: s3 equals: s1.
	self assert: s3 equals: s2.
	self assert: s2 equals: s3.
	s4 := POINTL fromAddress: s2 yourAddress.
	self assert: s1 equals: s4.
	self assert: s4 equals: s1!

testIsNull
	| struct |
	self assert: POINTL newPointer isNull.

	struct := POINTL new.
	self assert: struct isNull not.

	struct bytes: 0.
	self assert: struct isNull.
	
	struct bytes: nil.
	self assert: struct isNull.

	struct bytes: Object new.
	self should: [struct isNull] raise: MessageNotUnderstood.
	
	struct bytes: ByteArray new.
	self assert: struct isNull not.

	struct bytes: ExternalAddress new.
	self assert: struct isNull.! !
!ExternalStructureTest categoriesFor: #testEquals!public!unit tests! !
!ExternalStructureTest categoriesFor: #testIsNull!public!unit tests! !

