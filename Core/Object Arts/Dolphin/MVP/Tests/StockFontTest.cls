"Filed out from Dolphin Smalltalk"!

AbstractFontTest subclass: #StockFontTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StockFontTest guid: (GUID fromString: '{8ade05f3-900f-4abf-8af5-897d4843196b}')!

StockFontTest comment: ''!

!StockFontTest categoriesForClass!Unclassified! !

!StockFontTest methodsFor!

canonicalSubject
	^Font system!

testAtDpi
	| ansiVar ansiVar150 systemDpi |
	ansiVar := Font fromId: StockFont.ANSI_VAR_FONT.
	"Non-raster, scalable, stock font"
	self deny: ansiVar logFont isRasterFont.
	self assert: ansiVar logFont lfHeight equals: 12.
	systemDpi := SystemMetrics current dpi.
	ansiVar150 := ansiVar atDpi: systemDpi * 1.5.
	self assert: ansiVar150 equals: ansiVar.
	self assert: ansiVar150 series identicalTo: ansiVar series.
	self assert: ansiVar150 pointSize equals: ansiVar pointSize.
	self
		assert: ansiVar150 pixelSize
		closeTo: (ansiVar pointSize * 1.5 * systemDpi / 72) rounded
		precision: 1.
	self assert: ansiVar150 printString equals: ansiVar printString.
	self assert: ansiVar150 displayString equals: ansiVar displayString.!

testAtDpiRaster
	| system |
	system := self canonicalSubject.
	"System font is not scalable"
	self assert: system logFont isRasterFont.
	"Since not scalable, same instance used at any dpi"
	self assert: (system atDpi: system dpi * 2) identicalTo: system!

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
	self deny: comperand equals: subject.
	subject := Font default.
	comperand := subject atDpi: subject dpi * 1.5.
	self assert: subject equals: comperand.
	self assert: comperand equals: subject.
	self assert: subject hash equals: comperand hash.
	comperand := comperand copy.
	self assert: subject equals: comperand.
	self assert: comperand equals: subject.
	self assert: subject hash equals: comperand hash!

testCopy
	| subject copy |
	subject := self canonicalSubject.
	copy := subject copy.
	self assert: (copy logFont equalExcludingSize: subject logFont).
	self deny: copy logFont identicalTo: subject logFont.
	self assert: copy class identicalTo: Font.
	self deny: copy handle equals: subject handle.
	self assert: copy isRealized.
	copy free!

testDcDefaultFont
	| dcDefaultFont dc |
	dc := Canvas forDesktop.
	dcDefaultFont := dc font.
	dc free.
	self assert: dcDefaultFont identicalTo: Font system!

testDefault
	| subject subject150 pointSize systemDpi otherDpi |
	subject := Font default.
	self assert: subject isKindOf: StockFont.
	self assert: subject name equals: 'MS Shell Dlg'.
	self deny: subject logFont isRasterFont.
	self deny: subject isItalic.
	self deny: subject isUnderlined.
	systemDpi := SystemMetrics current dpi.
	self assert: subject dpi equals: systemDpi.
	pointSize := subject pointSize.
	self
		assert: subject pixelSize
		closeTo: (pointSize * systemDpi / 72) rounded
		precision: 1.
	self assert: subject dpi equals: systemDpi.
	otherDpi := systemDpi + 48.
	subject150 := subject atDpi: otherDpi.
	self assert: subject150 pointSize equals: pointSize.
	self deny: subject150 identicalTo: subject.
	self assert: subject150 equals: subject.
	self
		assert: subject150 pixelSize
		closeTo: (pointSize * otherDpi / 72) rounded
		precision: 1!

testFixedSystem
	| subject pointSize system150 systemDpi |
	subject := Font systemFixed.
	self assert: subject isKindOf: StockFont.
	self assert: subject name equals: 'Fixedsys'.
	self assert: subject logFont isRasterFont.
	self deny: subject isItalic.
	self deny: subject isUnderlined.
	pointSize := subject pointSize.
	systemDpi := SystemMetrics current dpi.
	self assert: subject dpi equals: systemDpi.
	self assert: (subject atDpi: systemDpi) identicalTo: subject.
	system150 := subject atDpi: systemDpi + 48.
	self assert: system150 pointSize equals: pointSize.
	self assert: system150 identicalTo: subject!

testPrintString
	self assert: Font system printString equals: 'Font system'.
	#('ANSI_FIXED_FONT' 'ANSI_VAR_FONT' 'DEFAULT_GUI_FONT' 'DEVICE_DEFAULT_FONT' 'OEM_FIXED_FONT' 'SYSTEM_FIXED_FONT')
		do: 
			[:each |
			| expected id subject |
			expected := '(Font fromId: StockFont.<1s>)' << each.
			id := (StockFont bindingFor: each) value.
			subject := Font fromId: id.
			self assert: subject printString equals: expected.
			self assert: (subject atDpi: subject dpi * 1.5) printString equals: expected]!

testStbConvertFrom0
	| version0Bytes font |
	self assertNotNil: (Font system instVarAt: LogFontIndex).
	version0Bytes := #[33 83 84 66 32 49 32 6 5 9 0 83 116 111 99 107 70 111 110 116 0 0 0 0 0 0 0 0 32 0 0 0 6 1 7 0 76 79 71 70 79 78 84 0 0 0 0 114 0 0 0 60 0 0 0 16 0 0 0 7 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 2 34 83 121 115 116 101 109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 2 5 0 80 111 105 110 116 0 0 0 0 193 0 0 0 193 0 0 0 27 0 0 0].
	font := Object fromBinaryStoreBytes: version0Bytes.
	self assert: font identicalTo: Font system.
	self assertNotNil: (font instVarAt: LogFontIndex).
	self assertNotNil: font basicHandle!

testStlConvertFrom0
	| font |
	font := Object
				fromLiteralStoreArray: #(#'!!STL' 3 591110 ##(StockFont) 0 32 459014 ##(Smalltalk.LOGFONT) 8 #[16 0 0 0 7 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 2 34 83 121 115 116 101 109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Point) 193 193 27).
	self assert: font identicalTo: Font system.
	"We don't want the shared instance to be affected."
	self assertNotNil: (font instVarAt: LogFontIndex).
	self assertNotNil: font basicHandle!

testSystem
	| subject system150 pointSize |
	subject := self canonicalSubject.
	self assert: subject isKindOf: StockFont.
	self assert: subject name equals: 'System'.
	self assert: subject logFont isRasterFont.
	self deny: subject isItalic.
	self deny: subject isUnderlined.
	pointSize := subject pointSize.
	self assert: subject dpi equals: SystemMetrics current dpi.
	self assert: (subject atDpi: Win32Constants.USER_DEFAULT_SCREEN_DPI) identicalTo: subject.
	system150 := subject atDpi: 144.
	self assert: system150 pointSize equals: pointSize.
	self assert: system150 identicalTo: subject!

verifyStxRoundTrip: aMonadicValuable
	| systemDpi array system default150 default default96 |
	system := self canonicalSubject.
	default := Font default.
	systemDpi := SystemMetrics current dpi.
	self assert: default dpi equals: systemDpi.
	default150 := default atDpi: default dpi * 1.5.
	"Once scaled won't be a StockFont anymore, it will be a normal Font instance with the same logfont attributes except lfHeight."
	self assert: default150 isKindOf: Font.
	self deny: default150 identicalTo: default.
	self assert: default150 series identicalTo: default series.
	self assert: default150 dpi equals: systemDpi * 1.5.
	self assert: default150 equals: default.
	default96 := default atDpi: 96.
	self assert: default96 series identicalTo: default series.
	self assert: default96 dpi equals: 96.
	self assert: default96 equals: default.
	array := aMonadicValuable
				value: { system. default. default150. default96. system. default. default150. default96 }.
	self assert: array asIdentitySet equals: { system. default } asIdentitySet.
	self assert: array first identicalTo: system.
	self assert: array second identicalTo: default.
	"The StockFont instances are shared. We don't want the STB loading process to clear the cached handle and logfont."
	self assertNotNil: (system instVarAt: LogFontIndex).
	self assertNotNil: system basicHandle.
	self assertNotNil: (default instVarAt: LogFontIndex).
	self assertNotNil: default basicHandle! !

!StockFontTest categoriesForMethods!
canonicalSubject!helpers!private! !
testAtDpi!public!unit tests! !
testAtDpiRaster!public!unit tests! !
testComparing!public!unit tests! !
testCopy!public!unit tests! !
testDcDefaultFont!public!unit tests! !
testDefault!public!unit tests! !
testFixedSystem!public!unit tests! !
testPrintString!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
testStlConvertFrom0!public!unit tests! !
testSystem!public!unit tests! !
verifyStxRoundTrip:!helpers!private! !
!

