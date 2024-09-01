"Filed out from Dolphin Smalltalk"!

Graphics.Tests.AbstractFontTest
	subclass: #'Graphics.Tests.StockFontTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.StockFontTest guid: (Core.GUID fromString: '{8ade05f3-900f-4abf-8af5-897d4843196b}')!

Graphics.Tests.StockFontTest comment: ''!

!Graphics.Tests.StockFontTest methodsFor!

canonicalSubject
	^Font system!

testAtDpi
	| subject subject2 |
	subject := self canonicalSubject.
	self assert: (subject atDpi: subject dpi * 2) identicalTo: subject.
	subject := Font fromId: 12.
	self assert: subject pointSize equals: 8.
	self assert: subject pixelSize equals: (8 * 96 / 72) rounded.
	subject2 := subject atDpi: subject dpi * 2.
	self assert: subject2 equals: subject.
	self assert: subject2 pointSize equals: 8.
	self assert: subject2 pixelSize equals: (16 * 96 / 72) rounded!

testComparing
	| subject comperand |
	subject := self canonicalSubject.
	comperand := subject copy.
	self assert: comperand class identicalTo: Font.
	self assert: comperand equals: subject.
	self assert: subject equals: comperand.
	self assert: subject hash equals: comperand hash.
	comperand := (Font name: 'Arial' pointSize: 12) beBold.
	self deny: subject equals: comperand.
	self deny: comperand equals: subject!

testCopy
	| subject copy |
	subject := self canonicalSubject.
	copy := subject copy.
	self assert: (copy logFont equalExcludingSize: subject logFont).
	self deny: copy logFont identicalTo: subject logFont.
	self assert: copy class identicalTo: Font.
	self deny: copy handle equals: subject handle.
	subject free.
	self assert: copy isRealized.
	copy free!

testDcDefaultFont
	| dcDefaultFont dc |
	dc := Canvas forDesktop.
	dcDefaultFont := dc font.
	dc free.
	self assert: dcDefaultFont identicalTo: Font system!

testDefault
	| subject subject150 pointSize |
	subject := Font default.
	self assert: subject isKindOf: StockFont.
	self assert: subject name equals: 'MS Shell Dlg'.
	self deny: subject logFont isRasterFont.
	self deny: subject isItalic.
	self deny: subject isUnderlined.
	pointSize := subject pointSize.
	self assert: subject pixelSize equals: (pointSize * 96 / 72) rounded.
	self assert: subject dpi equals: Win32Constants.USER_DEFAULT_SCREEN_DPI.
	self assert: (subject atDpi: Win32Constants.USER_DEFAULT_SCREEN_DPI) identicalTo: subject.
	subject150 := subject atDpi: 144.
	self assert: subject150 pointSize equals: pointSize.
	self deny: subject150 identicalTo: subject.
	self assert: subject150 equals: subject.
	self assert: subject150 pixelSize equals: (pointSize * 144 / 72) rounded!

testFixedSystem
	| subject pointSize system150 |
	subject := Font fixedSystem.
	self assert: subject isKindOf: StockFont.
	self assert: subject name equals: 'Fixedsys'.
	self assert: subject logFont isRasterFont.
	self deny: subject isItalic.
	self deny: subject isUnderlined.
	pointSize := subject pointSize.
	self assert: subject dpi equals: Win32Constants.USER_DEFAULT_SCREEN_DPI.
	self assert: (subject atDpi: Win32Constants.USER_DEFAULT_SCREEN_DPI) identicalTo: subject.
	system150 := subject atDpi: 144.
	self assert: system150 pointSize equals: pointSize.
	self assert: system150 identicalTo: subject.
	self assert: subject printString equals: 'Graphics.Font fixedSystem'!

testPrintString
	self assert: Font default printString equals: 'Graphics.Font default'.
	self assert: Font system printString equals: 'Graphics.Font system'.
	self assert: Font fixedSystem printString equals: 'Graphics.Font fixedSystem'!

testStbConvertFrom0
	| version0Bytes font |
	version0Bytes := #[33 83 84 66 32 49 32 6 5 9 0 83 116 111 99 107 70 111 110 116 0 0 0 0 0 0 0 0 32 0 0 0 6 1 7 0 76 79 71 70 79 78 84 0 0 0 0 114 0 0 0 60 0 0 0 16 0 0 0 7 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 2 34 83 121 115 116 101 109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 2 5 0 80 111 105 110 116 0 0 0 0 193 0 0 0 193 0 0 0 27 0 0 0].
	font := Object fromBinaryStoreBytes: version0Bytes.
	self assert: font class identicalTo: StockFont.
	self assert: font dpi equals: 96.
	self assert: font handle notNil.
	font getLogFont.
	self assert: font equals: Font system!

testSystem
	| subject system150 pointSize |
	subject := self canonicalSubject.
	self assert: subject isKindOf: StockFont.
	self assert: subject name equals: 'System'.
	self assert: subject logFont isRasterFont.
	self deny: subject isItalic.
	self deny: subject isUnderlined.
	pointSize := subject pointSize.
	self assert: subject dpi equals: Win32Constants.USER_DEFAULT_SCREEN_DPI.
	self assert: (subject atDpi: Win32Constants.USER_DEFAULT_SCREEN_DPI) identicalTo: subject.
	system150 := subject atDpi: 144.
	self assert: system150 pointSize equals: pointSize.
	self assert: system150 identicalTo: subject! !

!Graphics.Tests.StockFontTest categoriesForMethods!
canonicalSubject!helpers!private! !
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testCopy!public!unit tests! !
testDcDefaultFont!public!unit tests! !
testDefault!public!unit tests! !
testFixedSystem!public!unit tests! !
testPrintString!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
testSystem!public!unit tests! !
!

