"Filed out from Dolphin Smalltalk"!

ImageTest subclass: #CursorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CursorTest guid: (GUID fromString: '{6675665d-76c1-4c17-b23d-7d4c6ac959b9}')!

CursorTest comment: ''!

!CursorTest categoriesForClass!Unclassified! !

!CursorTest methodsFor!

canonicalInstance
	^self subjectClass arrow!

defaultHandle
	^Icon question handle!

expectedImageExtent
	^Cursor defaultExtent!

imageFile
	^'Core\DolphinVM\res\hsplit.cur'!

subjectClass
	^Cursor!

testExtent
	self deny: self canonicalInstance handle equals: Cursor question handle.
	self assert: self canonicalInstance extent equals: self expectedImageExtent!

testFromOwnedHandle
	| subject |
	subject := Cursor fromOwnedHandle: Cursor cross copyHandle.
	self deny: subject handle equals: Cursor cross handle.
	self assert: subject ownsHandle.
	self assert: subject isFinalizable.
	subject free!

testFromResource
	| cursor1 cursor2 |
	cursor1 := Cursor fromId: 3 in: (ExternalResourceLibrary open: 'ole32').
	cursor2 := Cursor ddCopy.
	self assert: cursor1 equals: cursor2.
	self assert: cursor2 equals: cursor1.
	self assert: cursor1 hash equals: cursor2 hash.
	self assert: cursor1 handle equals: cursor2 handle.
	self assert: cursor1 imageIndex equals: cursor2 imageIndex!

testFromSystemId
	| cursor1 cursor2 |
	cursor1 := Cursor fromSystemId: Win32Constants.IDC_SIZEALL.
	cursor2 := Cursor sizeAll.
	self assert: cursor1 equals: cursor2.
	self assert: cursor2 equals: cursor1.
	self assert: cursor1 hash equals: cursor2 hash.
	self assert: cursor1 imageIndex equals: cursor2 imageIndex.
	self assert: cursor1 extent equals: Cursor defaultExtent.
	self deny: cursor1 equals: Cursor hand.
	self deny: cursor1 handle equals: self defaultHandle.
	self assert: cursor1 handle equals: cursor2 handle!

testHotspot
	self assert: self canonicalInstance hotspot equals: 0 @ 0!

testStbConvertFromVersion1_resource
	| bytes cursor |
	bytes := #[33 83 84 66 32 48 32 6 4 6 0 67 117 114 115 111 114 0 0 0 0 0 0 0 0 16 0 0 0 54 0 6 0 83 116 114 105 110 103 6 0 0 0 86 83 80 76 73 84 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 114 0 0 0 9 0 0 0 86 77 76 105 98 114 97 114 121 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 114 0 0 0 7 0 0 0 100 101 102 97 117 108 116].
	cursor := Object fromBinaryStoreBytes: bytes.
	self assert: cursor isKindOf: Cursor.
	self assert: cursor ownsHandle.
	self assert: cursor identifier equals: 'vsplit'.
	self assert: cursor instanceHandle equals: VMLibrary default.
	self assert: cursor extent equals: Icon largeExtent.
	cursor free!

testStbConvertFromVersion1_system
	| bytes cursor |
	bytes := #[33 83 84 66 32 48 32 6 4 6 0 67 117 114 115 111 114 0 0 0 0 0 0 0 0 16 0 0 0 21 255 0 0 1 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	cursor := Object fromBinaryStoreBytes: bytes.
	self assert: cursor isKindOf: Cursor.
	self assert: cursor ownsHandle.
	self assert: cursor identifier equals: Win32Constants.IDC_APPSTARTING.
	self assert: cursor equals: Cursor appStarting.
	self assert: cursor handle equals: Cursor appStarting handle! !

!CursorTest categoriesForMethods!
canonicalInstance!helpers!private! !
defaultHandle!constants!private! !
expectedImageExtent!constants!private! !
imageFile!constants!private! !
subjectClass!constants!private! !
testExtent!public!unit tests! !
testFromOwnedHandle!public!unit tests! !
testFromResource!public!unit tests! !
testFromSystemId!public!unit tests! !
testHotspot!public!unit tests! !
testStbConvertFromVersion1_resource!public!unit tests! !
testStbConvertFromVersion1_system!public!unit tests! !
!

