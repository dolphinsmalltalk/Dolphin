"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #AbstractFontTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractFontTest guid: (GUID fromString: '{52dfbdb3-a15d-476a-83d0-c8fb03685b56}')!

AbstractFontTest isAbstract: true!

AbstractFontTest comment: ''!

!AbstractFontTest categoriesForClass!Unclassified! !

!AbstractFontTest methodsFor!

canonicalSubject
	self subclassResponsibility!

testAtDpi
	self subclassResponsibility!

testComparing
	self subclassResponsibility!

testStbConvertFrom0
	self subclassResponsibility!

testStbRoundTrip
	| subject subject2 bytes array deserialized |
	subject := self canonicalSubject.
	self assert: subject dpi equals: 96.
	subject2 := subject atDpi: subject dpi * 2.
	self assert: subject2 series identicalTo: subject series.
	bytes := { subject2. subject. subject. subject2 } binaryStoreBytes.
	array := Object fromBinaryStoreBytes: bytes.
	1 to: 3 do: [:i | self assert: (array at: i) identicalTo: (array at: i + 1)].
	deserialized := array first.
	self deny: deserialized identicalTo: subject.
	self assert: array first equals: subject.
	self deny: array first series identicalTo: subject series.
	self assert: deserialized dpi equals: 96! !

!AbstractFontTest categoriesForMethods!
canonicalSubject!helpers!private! !
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
testStbRoundTrip!public!unit tests! !
!

