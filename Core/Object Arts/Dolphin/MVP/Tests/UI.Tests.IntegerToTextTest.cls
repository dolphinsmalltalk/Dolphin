"Filed out from Dolphin Smalltalk"!

UI.Tests.TypeConverterTest
	subclass: #'UI.Tests.IntegerToTextTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.IntegerToTextTest guid: (Core.GUID fromString: '{f5820844-5d0a-4a2b-a43e-0a1c41fba952}')!

UI.Tests.IntegerToTextTest comment: ''!

!UI.Tests.IntegerToTextTest methodsFor!

testInvalidFormat
	edit typeconverter: IntegerToText new.
	edit value: 100.
	self assert: edit model value equals: 100.
	self shouldnt: 
			[edit
				text: '1.2';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.	"#1362"
	self assertIsNil: edit model value!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 6 3 12 0 78 117 109 98 101 114 84 111 84 101 120 116 0 0 0 0 54 0 5 0 70 108 111 97 116 8 0 0 0 0 0 0 0 0 0 0 0 54 0 6 0 83 116 114 105 110 103 4 0 0 0 90 101 114 111 0 0 0 0].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: NumberToText.
	self assert: subject leftNullValue equals: 0.0.
	self assert: subject rightNullValue equals: 'Zero'.
	self assert: subject locale identicalTo: Locale default! !

!UI.Tests.IntegerToTextTest categoriesForMethods!
testInvalidFormat!public!unit tests! !
testStbConvertFromVersion0!public! !
!

