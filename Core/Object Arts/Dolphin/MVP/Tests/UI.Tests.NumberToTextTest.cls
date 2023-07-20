"Filed out from Dolphin Smalltalk"!

UI.Tests.TypeConverterTest
	subclass: #'UI.Tests.NumberToTextTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.NumberToTextTest guid: (Core.GUID fromString: '{cbd894b2-a2ef-4a75-9636-86d351c7aac3}')!
UI.Tests.NumberToTextTest comment: ''!
!UI.Tests.NumberToTextTest methodsFor!

testConversions
	| subject |
	subject := NumberToText new.
	self assert: (subject convertFromLeftToRight: nil) equals: ''.
	self assert: (subject convertFromRightToLeft: '') equals: nil.
	self assert: (subject convertFromLeftToRight: 0) equals: '0'.
	self assert: (subject convertFromLeftToRight: 0.0) equals: 0.0 displayString.
	self assert: (subject convertFromRightToLeft: '0') equals: 0.
	self assert: (subject convertFromRightToLeft: '0.0') equals: 0.0.
	self assert: (subject convertFromRightToLeft: 0.0 displayString) equals: 0.0.
	self assert: (subject convertFromLeftToRight: 123.456) equals: 123.456 displayString.
	self assert: (subject convertFromRightToLeft: '123.456') equals: 123.456.
!

testConvertNullValues
	| subject |
	subject := NumberToText new
				leftNullValue: Float infinity;
				rightExceptionalValue: '∞';
				yourself.
	self assert: (subject convertFromLeftToRight: Float infinity) equals: '∞'.
	self assert: (subject convertFromRightToLeft: '∞') equals: Float infinity!

testInvalidFormat
	edit typeconverter: NumberToText new.
	edit value: 100.
	self assert: edit model value equals: 100.
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.	"#1362"
	self assertIsNil: edit model value!

testLeftNullValue
	edit typeconverter: NumberToText new.
	edit value: 500.
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.
	self assertIsNil: edit model value.
	self assert: edit text isEmpty.
	edit
		text: 'xyz';
		isTextModified: true;
		updateModel.
	self assertIsNil: edit model value.
	self assert: edit text isEmpty	"#1257"!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 6 3 12 0 78 117 109 98 101 114 84 111 84 101 120 116 0 0 0 0 54 0 5 0 70 108 111 97 116 8 0 0 0 0 0 0 0 0 0 0 0 54 0 6 0 83 116 114 105 110 103 4 0 0 0 90 101 114 111 0 0 0 0].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: NumberToText.
	self assert: subject leftNullValue equals: 0.0.
	self assert: subject rightNullValue equals: 'Zero'.
	self assert: subject locale identicalTo: Locale default! !
!UI.Tests.NumberToTextTest categoriesForMethods!
testConversions!public! !
testConvertNullValues!public! !
testInvalidFormat!public!unit tests! !
testLeftNullValue!public!unit tests! !
testStbConvertFromVersion0!public! !
!

