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
	| subject subject200 |
	subject := self canonicalSubject.
	self assert: subject dpi equals: 96.
	self assert: (subject atDpi: 96) identicalTo: subject.
	subject200 := subject atDpi: 96 * 2.
	self deny: subject200 identicalTo: subject.
	self assert: subject200 equals: subject.
	self assert: subject200 dpi equals: 96 * 2.
	self assert: (subject200 atDpi: 96) identicalTo: subject!

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
	self assert: font equals: (Font name: 'Segoe UI' pointSize: 12)!

testStlConvertFrom0
	| font |
	font := Object
				fromLiteralStoreArray: #(#'!!STL' 3 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[241 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 0 0 0 0 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193).
	self assert: font equals: ((Graphics.Font name: 'Arial' pointSize: 11) isBold: true).
	self assert: font dpi equals: Win32Constants.USER_DEFAULT_SCREEN_DPI! !

!Graphics.Tests.FontTest categoriesForMethods!
canonicalSubject!helpers!private! !
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
testStlConvertFrom0!public!unit tests! !
!

