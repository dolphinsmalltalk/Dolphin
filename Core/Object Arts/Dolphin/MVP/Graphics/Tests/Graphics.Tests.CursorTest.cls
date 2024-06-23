"Filed out from Dolphin Smalltalk"!

Graphics.Tests.ImageTest
	subclass: #'Graphics.Tests.CursorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.CursorTest guid: (Core.GUID fromString: '{84acad1d-2783-48fc-a42a-94c73d6885ac}')!

Graphics.Tests.CursorTest comment: ''!

!Graphics.Tests.CursorTest methodsFor!

expectedImageExtent
	^Cursor defaultExtent!

imageFile
	^'Core\DolphinVM\res\hsplit.cur'!

subjectClass
	^Cursor!

testFromHandle
	| subject |
	subject := Cursor fromHandle: Cursor cross handle.
	self assert: subject handle equals: Cursor cross handle.
	self deny: subject ownsHandle!

testFromOwnedHandle
	| subject |
	subject := Cursor fromOwnedHandle: Cursor cross copyHandle.
	self deny: subject handle equals: Cursor cross handle.
	self assert: subject ownsHandle.
	self assert: subject isFinalizable.
	subject free!

testFromResource
	| cursor1 cursor2 |
	cursor1 := Cursor fromId: 'hsplit' in: VM.
	self assert: cursor1 initializer isLoadShared.
	cursor2 := Cursor splitHorizontal.
	self assert: cursor1 equals: cursor2.
	self assert: cursor2 equals: cursor1.
	self assert: cursor1 hash equals: cursor2 hash.
	self assert: cursor1 handle equals: cursor2 handle.
	self assert: cursor1 imageIndex equals: cursor2 imageIndex.
	self assert: cursor1 extent equals: Cursor largeExtent!

testFromSystemId
	| cursor1 cursor2 |
	cursor1 := Cursor fromSystemId: OS.Win32Constants.IDC_SIZEALL.
	self assert: cursor1 initializer isLoadShared.
	cursor2 := Cursor sizeAll.
	self assert: cursor1 equals: cursor2.
	self assert: cursor2 equals: cursor1.
	self assert: cursor1 hash equals: cursor2 hash.
	self assert: cursor1 imageIndex equals: cursor2 imageIndex.
	self assert: cursor1 extent equals: Cursor defaultExtent.
	self deny: cursor1 equals: Cursor hand.
	self deny: cursor1 handle equals: Cursor defaultHandle.
	self assert: cursor1 handle equals: cursor2 handle!

testStbConvertFromVersion1_resource
	| bytes cursor |
	bytes := #[33 83 84 66 32 48 32 6 4 6 0 67 117 114 115 111 114 0 0 0 0 0 0 0 0 16 0 0 0 54 0 6 0 83 116 114 105 110 103 6 0 0 0 86 83 80 76 73 84 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 14 1 13 0 83 84 66 67 108 97 115 115 80 114 111 120 121 0 0 0 0 114 0 0 0 9 0 0 0 86 77 76 105 98 114 97 114 121 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 114 0 0 0 7 0 0 0 100 101 102 97 117 108 116].
	cursor := Object fromBinaryStoreBytes: bytes.
	self assert: cursor isKindOf: Cursor.
	self assert: cursor ownsHandle.
	self assert: cursor initializer isKindOf: ImageFromStringResourceInitializer.
	self assert: cursor initializer identifier equals: 'VSPLIT'.
	self assert: cursor initializer module equals: VM.
	self assert: cursor equals: Cursor splitVertical.
	self assert: cursor extent equals: Icon largeExtent.
	cursor free!

testStbConvertFromVersion1_system
	| bytes cursor |
	bytes := #[33 83 84 66 32 48 32 6 4 6 0 67 117 114 115 111 114 0 0 0 0 0 0 0 0 16 0 0 0 21 255 0 0 1 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	cursor := Object fromBinaryStoreBytes: bytes.
	self assert: cursor isKindOf: Cursor.
	self assert: cursor ownsHandle.
	self assert: cursor initializer isKindOf: IconFromSystemInitializer.
	self assert: cursor initializer identifier equals: Win32Constants.IDC_APPSTARTING.
	self assert: cursor initializer isLoadShared.
	self assert: cursor equals: Cursor appStarting.
	self assert: cursor handle equals: Cursor appStarting handle!

testStbConvertFromVersion3_resource
	| bytes cursor |
	bytes := #[33 83 84 66 32 49 32 70 5 6 0 3 0 0 0 67 117 114 115 111 114 0 0 0 0 0 0 0 0 16 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 154 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 24 0 0 0 73 109 97 103 101 82 101 108 97 116 105 118 101 70 105 108 101 76 111 99 97 116 111 114 186 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 99 117 114 114 101 110 116 82 0 0 0 6 0 0 0 86 83 80 76 73 84 186 1 0 0 0 0 0 0 154 0 0 0 0 0 0 0 224 1 0 0 82 0 0 0 9 0 0 0 86 77 76 105 98 114 97 114 121 186 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 100 101 102 97 117 108 116].
	cursor := Object fromBinaryStoreBytes: bytes.
	self assert: cursor isKindOf: Cursor.
	self assert: cursor ownsHandle.
	self assert: cursor initializer isKindOf: ImageFromStringResourceInitializer.
	self assert: cursor initializer identifier equals: 'VSPLIT'.
	self assert: cursor initializer module equals: VM.
	self assert: cursor equals: Cursor splitVertical.
	self assert: cursor extent equals: Icon largeExtent.
	cursor free!

testStbConvertFromVersion3_system
	| bytes cursor |
	bytes := #[33 83 84 66 32 49 32 70 5 6 0 3 0 0 0 67 117 114 115 111 114 0 0 0 0 0 0 0 0 16 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 154 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 24 0 0 0 73 109 97 103 101 82 101 108 97 116 105 118 101 70 105 108 101 76 111 99 97 116 111 114 186 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 99 117 114 114 101 110 116 21 255 0 0 1 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	cursor := Object fromBinaryStoreBytes: bytes.
	self assert: cursor isKindOf: Cursor.
	self assert: cursor ownsHandle.
	self assert: cursor initializer isKindOf: IconFromSystemInitializer.
	self assert: cursor initializer identifier equals: Win32Constants.IDC_APPSTARTING.
	self assert: cursor initializer isLoadShared.
	self assert: cursor equals: Cursor appStarting.
	self assert: cursor handle equals: Cursor appStarting handle!

testStlConvertFromVersion3_file
	| rehydrated comparand |
	rehydrated := Object
				fromLiteralStoreArray: #(#'!!STL' 4 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Core\DolphinVM\res\collection.ico' nil).
	self assert: rehydrated isPersistent.
	self assert: rehydrated printString equals: 'Icon fromFile: ''Core\DolphinVM\res\collection.ico'''.
	comparand := Icon fromFile: 'Core\DolphinVM\res\Collection.ico'.
	self assert: rehydrated equals: comparand.
	"Icon's loaded from files are not shared, so the handles will be different"
	self deny: rehydrated initializer isLoadShared.
	self deny: rehydrated handle equals: comparand handle.
	self assert: rehydrated extent equals: Icon largeExtent!

testStlConvertFromVersion3_resource
	| rehydrated comparand |
	rehydrated := Object
				fromLiteralStoreArray: #(#'!!STL' 4 394566 3 ##(Smalltalk.Cursor) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'HSPLIT' 591366 ##(Smalltalk.VMLibrary)).
	self assert: rehydrated isPersistent.
	self assert: rehydrated printString equals: 'Cursor fromId: ''HSPLIT'' in: VM'.
	self assert: rehydrated initializer isLoadShared.
	comparand := Cursor splitHorizontal.
	self assert: rehydrated equals: comparand!

testStlConvertFromVersion3_system
	| rehydrated comparand |
	comparand := Cursor no.
	rehydrated := Object
				fromLiteralStoreArray: #(#'!!STL' 4 394566 3 ##(Smalltalk.Cursor) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 65297 1).
	self deny: rehydrated identicalTo: comparand.
	self assert: rehydrated equals: comparand.
	self assert: rehydrated initializer isLoadShared.
	self assert: rehydrated handle equals: comparand handle.
	self assert: rehydrated extent equals: Cursor defaultExtent! !

!Graphics.Tests.CursorTest categoriesForMethods!
expectedImageExtent!constants!private! !
imageFile!constants!private! !
subjectClass!constants!private! !
testFromHandle!public! !
testFromOwnedHandle!public! !
testFromResource!public! !
testFromSystemId!public! !
testStbConvertFromVersion1_resource!public!unit tests! !
testStbConvertFromVersion1_system!public!unit tests! !
testStbConvertFromVersion3_resource!public!unit tests! !
testStbConvertFromVersion3_system!public!unit tests! !
testStlConvertFromVersion3_file!public! !
testStlConvertFromVersion3_resource!public! !
testStlConvertFromVersion3_system!public! !
!

