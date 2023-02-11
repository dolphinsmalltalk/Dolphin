"Filed out from Dolphin Smalltalk"!

Graphics.Tests.ImageTest subclass: #'Graphics.Tests.CursorTest'
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

testStbConvertFromVersion3_file
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

testStbConvertFromVersion3_resource
	| rehydrated comparand |
	rehydrated := Object
				fromLiteralStoreArray: #(#'!!STL' 4 394566 3 ##(Smalltalk.Cursor) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'HSPLIT' 591366 ##(Smalltalk.VMLibrary)).
	self assert: rehydrated isPersistent.
	self assert: rehydrated printString equals: 'Cursor fromId: ''HSPLIT'' in: VM'.
	self assert: rehydrated initializer isLoadShared.
	comparand := Cursor splitHorizontal.
	self assert: rehydrated equals: comparand!

testStbConvertFromVersion3_system
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
testStbConvertFromVersion3_file!public! !
testStbConvertFromVersion3_resource!public! !
testStbConvertFromVersion3_system!public! !
!

