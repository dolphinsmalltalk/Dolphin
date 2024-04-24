"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #FontTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

FontTest guid: (GUID fromString: '{dbb29546-1641-4b40-a6ec-ddb1540e927a}')!

FontTest comment: ''!

!FontTest categoriesForClass!Unclassified! !

!FontTest methodsFor!

testAtDpi
	| subject double |
	subject := Font name: 'Arial' pointSize: 12.
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
	comperand := (Font name: 'Arial' pointSize: 12) atDpi: 96 * 2.
	self deny: subject series equals: comperand series.
	self assert: subject equals: comperand.
	self assert: comperand equals: subject.
	self assert: subject hash equals: comperand hash.
	comperand := (Font name: 'Arial' pointSize: 12) beBold.
	self deny: subject equals: comperand.
	self deny: comperand equals: subject.
	
!

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
	"We have to re-retrieve the LOGFONT so we have in LOGFONTW form for comparison"
	font getLogFont.
	self assert: font equals: ((Font name: 'Segoe UI' pointSize: 12) atDpi: 96).
	version0Bytes := #[33 83 84 66 32 49 32 6 5 9 0 83 116 111 99 107 70 111 110 116 0 0 0 0 0 0 0 0 32 0 0 0 6 1 7 0 76 79 71 70 79 78 84 0 0 0 0 114 0 0 0 60 0 0 0 16 0 0 0 7 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 2 34 83 121 115 116 101 109 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6 2 5 0 80 111 105 110 116 0 0 0 0 193 0 0 0 193 0 0 0 27 0 0 0].
	font := Object fromBinaryStoreBytes: version0Bytes.
	self assert: font class identicalTo: StockFont.
	self assert: font dpi equals: 96.
	self assert: font handle notNil.
	font getLogFont.
	self assert: font equals: Font system!

testStbRoundTrip
	| arial12at96 arial12at120 bytes array deserialized |
	arial12at96 := Font name: 'Arial' pointSize: 12.
	self assert: arial12at96 dpi equals: 96.
	arial12at120 := arial12at96 atDpi: arial12at96 dpi * 2.
	self assert: arial12at120 series identicalTo: arial12at96 series.
	bytes := {arial12at120. arial12at96.  arial12at96. arial12at120} binaryStoreBytes.
	array := Object fromBinaryStoreBytes: bytes.
	1 to: 3 do: [:i | self assert: (array at: i) identicalTo: (array at: i + 1)].
	deserialized := array first.
	self deny: deserialized identicalTo: arial12at96.
	self assert: array first equals: arial12at96.
	self deny: array first series identicalTo: arial12at96 series.
	self assert: deserialized dpi equals: 96!

testSystem
	| systemFont |
	systemFont := Font system.
	self assert: systemFont pointSize equals: 10.
	self assert: systemFont dpi equals: SystemMetrics current dpi.
	self assert: Font system identicalTo: systemFont.
	self assert: systemFont isKindOf: StockFont! !
!FontTest categoriesForMethods!
testAtDpi!public!unit tests! !
testComparing!public!unit tests! !
testFromHandle!public!unit tests! !
testStbConvertFrom0!public!unit tests! !
testStbRoundTrip!public!unit tests! !
testSystem!public!unit tests! !
!

