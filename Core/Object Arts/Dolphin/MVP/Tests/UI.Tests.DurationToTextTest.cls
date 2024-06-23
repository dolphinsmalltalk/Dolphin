"Filed out from Dolphin Smalltalk"!

UI.Tests.TypeConverterTest
	subclass: #'UI.Tests.DurationToTextTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.DurationToTextTest guid: (Core.GUID fromString: '{d057c88c-cf5e-4ff1-b903-160f7135f777}')!

UI.Tests.DurationToTextTest comment: ''!

!UI.Tests.DurationToTextTest methodsFor!

testInvalidFormat
	edit typeconverter: (DurationToText new
				locale: Locale smalltalk;
				yourself).
	edit value: 42.123456789 days.
	self assert: edit text equals: '42:02:57:46.667'.
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.
	self assertIsNil: edit model value!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 6 3 14 0 68 117 114 97 116 105 111 110 84 111 84 101 120 116 0 0 0 0 82 0 0 0 0 0 0 0 82 0 0 0 12 0 0 0 45 100 58 104 104 58 109 109 58 115 102 102].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: DurationToText.
	self assertIsNil: subject leftNullValue.
	self assert: subject rightNullValue equals: ''.
	self assert: subject locale identicalTo: Locale default.
	self assert: subject format equals: '-d:hh:mm:sff'! !

!UI.Tests.DurationToTextTest categoriesForMethods!
testInvalidFormat!public!unit tests! !
testStbConvertFromVersion0!public! !
!

