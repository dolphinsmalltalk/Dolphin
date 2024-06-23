"Filed out from Dolphin Smalltalk"!

UI.Tests.TypeConverterTest
	subclass: #'UI.Tests.BooleanToTextTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.BooleanToTextTest guid: (Core.GUID fromString: '{ebc0e5f2-04f1-4c58-b28b-96ed8da630ce}')!

UI.Tests.BooleanToTextTest comment: ''!

!UI.Tests.BooleanToTextTest methodsFor!

testInvalidFormat
	edit typeconverter: BooleanToText new.
	edit value: false.
	self assert: edit model value not.
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.
	self assertIsNil: edit model value!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 51 32 6 3 13 0 66 111 111 108 101 97 110 84 111 84 101 120 116 0 0 0 0 82 0 0 0 0 0 0 0 98 0 0 0 2 0 0 0 82 0 0 0 2 0 0 0 78 111 82 0 0 0 3 0 0 0 89 101 115].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: BooleanToText.
	self assertIsNil: subject leftNullValue.
	self assert: subject rightNullValue equals: ''.
	self assert: subject locale identicalTo: Locale default.
	self assert: subject format equals: #('No' 'Yes')! !

!UI.Tests.BooleanToTextTest categoriesForMethods!
testInvalidFormat!public!unit tests! !
testStbConvertFromVersion0!public! !
!

