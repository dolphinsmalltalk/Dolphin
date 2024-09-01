"Filed out from Dolphin Smalltalk"!

Graphics.Tests.AbstractFontTest
	subclass: #'Graphics.Tests.FontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.FontTest guid: (Core.GUID fromString: '{c9a96f0e-b8d4-491e-8f83-6916ec5fef04}')!

Graphics.Tests.FontTest comment: ''!

!Graphics.Tests.FontTest methodsFor!

canonicalSubject
	^Font name: 'Arial' pointSize: 12!

testAtDpi
	| subject double |
	subject := self canonicalSubject.
	self assert: subject dpi equals: 96.
	self assert: (subject atDpi: 96) identicalTo: subject.
	double := subject atDpi: 96 * 2.
	self assert: double dpi equals: 96 * 2.
	self assert: (double atDpi: 96) identicalTo: subject!

testComparing
	| subject comperand |
	subject := Font name: 'Arial' pointSize: 12.
	self assert: subject dpi equals: 96.
	comperand := subject atDpi: 96 * 2.
	self assert: subject equals: comperand.
	self assert: comperand equals: subject.
	self assert: subject hash equals: comperand hash.
	comperand := self canonicalSubject atDpi: 96 * 2.
	self deny: subject series equals: comperand series.
	self assert: subject equals: comperand.
	self assert: comperand equals: subject.
	self assert: subject hash equals: comperand hash.
	comperand := self canonicalSubject beBold.
	self deny: subject equals: comperand.
	self deny: comperand equals: subject!

testStbConvertFrom0
	| version0Bytes font |
	version0Bytes := #[33 83 84 66 32 49 32 6 4 4 0 70 111 110 116 0 0 0 0 0 0 0 0 16 0 0 0 6 1 7 0 76 79 71 70 79 78 84 0 0 0 0 114 0 0 0 60 0 0 0 240 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 0 0 0 0 83 101 103 111 101 32 85 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 2 5 0 80 111 105 110 116 0 0 0 0 193 0 0 0 193 0 0 0].
	font := Object fromBinaryStoreBytes: version0Bytes.
	self assert: font class identicalTo: Font.
	self assert: font dpi equals: 96.
	self assert: font handle notNil.
	self assert: font equals: ((Font name: 'Segoe UI' pointSize: 12) atDpi: 96)! !

!Graphics.Tests.FontTest categoriesForMethods!
canonicalSubject!helpers!private! !
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
!

