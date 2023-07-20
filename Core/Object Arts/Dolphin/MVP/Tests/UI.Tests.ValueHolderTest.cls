"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.ValueHolderTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ValueHolderTest guid: (Core.GUID fromString: '{599f6879-a7ea-4110-bc74-2bae85fbf825}')!
UI.Tests.ValueHolderTest comment: ''!
!UI.Tests.ValueHolderTest methodsFor!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 6 2 11 0 86 97 108 117 101 72 111 108 100 101 114 0 0 0 0 6 1 16 0 67 111 109 112 97 114 105 115 111 110 80 111 108 105 99 121 0 0 0 0 6 4 12 0 66 108 111 99 107 67 108 111 115 117 114 101 0 0 0 0 38 3 13 0 77 101 116 104 111 100 67 111 110 116 101 120 116 2 0 0 0 1 0 0 0 38 5 14 0 67 111 109 112 105 108 101 100 77 101 116 104 111 100 3 0 0 0 143 2 0 0 14 1 17 0 83 84 66 77 101 116 97 99 108 97 115 115 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 16 0 0 0 67 111 109 112 97 114 105 115 111 110 80 111 108 105 99 121 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 18 1 0 0 6 0 0 0 97 108 119 97 121 115 3 232 65 22 54 0 9 0 66 121 116 101 65 114 114 97 121 22 0 0 0 45 223 17 57 217 1 100 251 2 4 0 90 89 58 106 176 97 152 213 0 45 105 6 2 11 0 65 115 115 111 99 105 97 116 105 111 110 0 0 0 0 18 1 0 0 6 0 0 0 65 108 119 97 121 115 128 0 0 0 58 1 0 0 0 0 0 0 18 1 0 0 3 0 0 0 110 101 119 58 1 0 0 0 0 0 0 18 1 0 0 13 0 0 0 99 111 109 112 97 114 101 66 108 111 99 107 58 112 0 0 0 0 0 0 0 0 0 0 0 5 0 0 0 25 0 0 0 224 0 0 0 18 1 0 0 3 0 0 0 97 98 99].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ValueModel.
	self assertIsNil: subject getEvents.
	self assert: subject value equals: 'abc'.
	self assert: (subject instVarNamed: 'settingValue') equals: false.
	self assert: subject comparisonPolicy printString equals: 'SearchPolicy always'!

testStbConvertFromVersion1
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 70 3 11 0 1 0 0 0 86 97 108 117 101 72 111 108 100 101 114 0 0 0 0 0 0 0 0 6 1 16 0 67 111 109 112 97 114 105 115 111 110 80 111 108 105 99 121 0 0 0 0 6 2 7 0 77 101 115 115 97 103 101 0 0 0 0 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 1 0 0 0 61 38 0 5 0 65 114 114 97 121 0 0 0 0 210 0 0 0 3 0 0 0 97 98 99].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ValueModel.
	self assertIsNil: subject getEvents.
	self assert: subject value equals: 'abc'.
	self assert: (subject instVarNamed: 'settingValue') equals: false.
	self assert: subject comparisonPolicy printString equals: 'SearchPolicy equality'! !
!UI.Tests.ValueHolderTest categoriesForMethods!
testStbConvertFromVersion0!public! !
testStbConvertFromVersion1!public! !
!

