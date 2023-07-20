"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.ValueBufferTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ValueBufferTest guid: (Core.GUID fromString: '{599f6879-a7ea-4110-bc74-2bae85fbf825}')!
UI.Tests.ValueBufferTest comment: ''!
!UI.Tests.ValueBufferTest methodsFor!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 6 5 11 0 86 97 108 117 101 66 117 102 102 101 114 0 0 0 0 6 1 16 0 67 111 109 112 97 114 105 115 111 110 80 111 108 105 99 121 0 0 0 0 6 2 7 0 77 101 115 115 97 103 101 0 0 0 0 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 1 0 0 0 61 38 0 5 0 65 114 114 97 121 0 0 0 0 145 3 0 0 6 2 11 0 86 97 108 117 101 72 111 108 100 101 114 0 0 0 0 128 0 0 0 247 0 0 0 16 0 0 0 18 1 0 0 0 0 0 0 128 0 0 0 32 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ValueBuffer.
	self assertIsNil: subject getEvents.
	self assert: subject value equals: 456.
	self assert: (subject instVarNamed: 'settingValue') equals: false.
	self assert: subject comparisonPolicy printString equals: 'SearchPolicy equality'.
	self assert: subject isModified.
	self assert: subject subject value equals: 123.
	self deny: subject gate value.
	"Note that events are never saved/restored by STB, so we need to reset the gate model to rewire it"
	subject gate: subject gate.
	"Now if we set the gate the value should transfer back to the model, if everything is working"
	subject gate value: true.
	self assert: subject subject value equals: 456.
	self deny: subject isModified!

testStbConvertFromVersion1
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 70 6 11 0 1 0 0 0 86 97 108 117 101 66 117 102 102 101 114 0 0 0 0 0 0 0 0 6 1 16 0 67 111 109 112 97 114 105 115 111 110 80 111 108 105 99 121 0 0 0 0 6 2 7 0 77 101 115 115 97 103 101 0 0 0 0 14 1 14 0 83 84 66 83 121 109 98 111 108 80 114 111 120 121 0 0 0 0 54 0 6 0 83 116 114 105 110 103 1 0 0 0 61 38 0 5 0 65 114 114 97 121 0 0 0 0 145 3 0 0 70 3 11 0 1 0 0 0 86 97 108 117 101 72 111 108 100 101 114 0 0 0 0 0 0 0 0 128 0 0 0 247 0 0 0 16 0 0 0 18 1 0 0 0 0 0 0 0 0 0 0 128 0 0 0 32 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: ValueBuffer.
	self assertIsNil: subject getEvents.
	self assert: subject value equals: 456.
	self assert: (subject instVarNamed: 'settingValue') equals: false.
	self assert: subject comparisonPolicy printString equals: 'SearchPolicy equality'.
	self assert: subject isModified.
	self assert: subject subject value equals: 123.
	self deny: subject gate value.
	"Note that events are never saved/restored by STB, so we need to reset the gate model to rewire it"
	subject gate: subject gate.
	"Now if we set the gate the value should transfer back to the model, if everything is working"
	subject gate value: true.
	self assert: subject subject value equals: 456.
	self deny: subject isModified! !
!UI.Tests.ValueBufferTest categoriesForMethods!
testStbConvertFromVersion0!public! !
testStbConvertFromVersion1!public! !
!

