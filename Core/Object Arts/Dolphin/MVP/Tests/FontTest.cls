"Filed out from Dolphin Smalltalk"!

AbstractFontTest subclass: #FontTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FontTest guid: (GUID fromString: '{dbb29546-1641-4b40-a6ec-ddb1540e927a}')!

FontTest comment: ''!

!FontTest categoriesForClass!Unclassified! !

!FontTest methodsFor!

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
	subject := self canonicalSubject.
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

testFromHandle
	| desktopFont systemFont |
	desktopFont := Canvas forDesktop font.
	systemFont := Font system.
	self assert: desktopFont logFont equals: systemFont logFont.
	systemFont free.
	self deny: desktopFont ownsHandle!

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
	self assert: font equals: ((Font name: 'Arial' pointSize: 11) isBold: true).
	self assert: font dpi equals: Win32Constants.USER_DEFAULT_SCREEN_DPI! !

!FontTest categoriesForMethods!
canonicalSubject!helpers!private! !
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testFromHandle!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
testStlConvertFrom0!public!unit tests! !
!

