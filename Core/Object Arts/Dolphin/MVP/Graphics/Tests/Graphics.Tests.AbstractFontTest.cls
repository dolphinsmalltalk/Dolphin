"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Graphics.Tests.AbstractFontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.AbstractFontTest guid: (Core.GUID fromString: '{8a4906fc-95c2-4d0c-af13-60c309d9ada0}')!

Graphics.Tests.AbstractFontTest isNonInstantiable: true!

Graphics.Tests.AbstractFontTest comment: ''!

!Graphics.Tests.AbstractFontTest methodsFor!

canonicalSubject
	^self subclassResponsibility!

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

!Graphics.Tests.AbstractFontTest categoriesForMethods!
canonicalSubject!helpers!private! !
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
testStbRoundTrip!public!unit tests! !
!

