"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.FramingConstraintsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.FramingConstraintsTest guid: (Core.GUID fromString: '{d3e4e78b-d2c4-48f8-9806-8ea0e96dfd32}')!

UI.Tests.FramingConstraintsTest comment: ''!

!UI.Tests.FramingConstraintsTest methodsFor!

testStbConversionFromVersion0
	"Version 0 binary serialization from Dolphin 2.0"

	| bytes constraint |
	bytes := #[33 83 84 66 32 48 32 6 8 18 0 70 114 97 109 105 110 103 67 111 110 115 116 114 97 105 110 116 115 0 0 0 0 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 15 0 0 0 102 105 120 101 100 80 97 114 101 110 116 76 101 102 116 21 0 0 0 122 0 0 0 0 0 0 0 146 0 0 0 18 0 0 0 114 101 108 97 116 105 118 101 80 97 114 101 110 116 76 101 102 116 6 2 8 0 70 114 97 99 116 105 111 110 0 0 0 0 27 0 0 0 61 0 0 0 122 0 0 0 0 0 0 0 146 0 0 0 14 0 0 0 102 105 120 101 100 80 97 114 101 110 116 84 111 112 81 0 0 0 122 0 0 0 0 0 0 0 146 0 0 0 17 0 0 0 102 105 120 101 100 80 97 114 101 110 116 66 111 116 116 111 109 237 255 255 255].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	constraint := Object fromBinaryStoreBytes: bytes.
	self assert: constraint leftFraming equals: #fixedParentLeft.
	self assert: constraint leftOffset equals: 10.
	self assert: constraint rightFraming equals: #relativeParentWidth.
	self assert: constraint rightOffset equals: 13 / 30.
	self assert: constraint topFraming equals: #fixedParentTop.
	self assert: constraint topOffset equals: 40.
	self assert: constraint bottomFraming equals: #fixedParentBottom.
	self assert: constraint bottomOffset equals: -10!

testStbConversionFromVersion1
	"Version 1 binary serialization from Dolphin 5.0.1"

	| bytes constraint |
	bytes := #[33 83 84 66 32 49 32 70 8 18 0 1 0 0 0 70 114 97 109 105 110 103 67 111 110 115 116 114 97 105 110 116 115 0 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 19 0 0 0 114 101 108 97 116 105 118 101 80 97 114 101 110 116 87 105 100 116 104 6 2 8 0 70 114 97 99 116 105 111 110 0 0 0 0 71 0 0 0 143 0 0 0 186 0 0 0 0 0 0 0 82 0 0 0 13 0 0 0 102 105 120 101 100 86 105 101 119 76 101 102 116 45 1 0 0 186 0 0 0 0 0 0 0 82 0 0 0 20 0 0 0 114 101 108 97 116 105 118 101 80 97 114 101 110 116 72 101 105 103 104 116 210 1 0 0 0 0 0 0 81 0 0 0 67 1 0 0 186 0 0 0 0 0 0 0 82 0 0 0 12 0 0 0 102 105 120 101 100 86 105 101 119 84 111 112 81 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	constraint := Object fromBinaryStoreBytes: bytes.
	self assert: constraint leftFraming equals: #relativeParentWidth.
	self assert: constraint leftOffset equals: 35/71.
	self assert: constraint rightFraming equals: #fixedViewLeft.
	self assert: constraint rightOffset equals: 150.
	self assert: constraint topFraming equals: #relativeParentHeight.
	self assert: constraint topOffset equals: 40/161.
	self assert: constraint bottomFraming equals: #fixedViewTop.
	self assert: constraint bottomOffset equals: 40! !

!UI.Tests.FramingConstraintsTest categoriesForMethods!
testStbConversionFromVersion0!public! !
testStbConversionFromVersion1!public! !
!

