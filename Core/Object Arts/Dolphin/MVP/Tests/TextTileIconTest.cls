"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #TextTileIconTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TextTileIconTest guid: (GUID fromString: '{1a492d33-ea67-4b59-8d41-8aa37e1d2878}')!

TextTileIconTest comment: ''!

!TextTileIconTest categoriesForClass!Unclassified! !

!TextTileIconTest methodsFor!

testStbConvertFromVersion1
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 70 9 12 0 1 0 0 0 84 101 120 116 84 105 108 101 73 99 111 110 52 57 31 0 82 0 0 0 7 0 0 0 71 101 111 114 103 105 97 6 0 5 0 67 111 108 111 114 178 0 0 0 6 0 0 0 111 114 99 104 105 100 194 1 0 0 178 0 0 0 5 0 0 0 119 104 105 116 101 0 0 0 0 3 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0].
	"STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: TextTileIcon.
	TextTileIcon allInstVarNames
		keysAndValuesDo: [:i :each | each first == $_ ifTrue: [self assertIsNil: (subject instVarAt: i)]].
	self assert: subject tilecolor equals: Color orchid.
	self assert: subject textcolor equals: Color white.
	self assert: subject rotation equals: 90.
	self assert: subject fontName equals: 'Georgia'.
	self assert: subject fontStyle equals: #bold.
	self assert: subject text equals: $🎓! !

!TextTileIconTest categoriesForMethods!
testStbConvertFromVersion1!public!unit tests! !
!

