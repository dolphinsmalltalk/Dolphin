"Filed out from Dolphin Smalltalk"!

UI.Tests.TypeConverterTest
	subclass: #'UI.Tests.TimeToTextTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.TimeToTextTest guid: (Core.GUID fromString: '{2abbcfbe-0c0d-4deb-bf0b-61d631c5f387}')!

UI.Tests.TimeToTextTest comment: ''!

!UI.Tests.TimeToTextTest methodsFor!

testInvalidFormat
	edit typeconverter: TimeToText new.
	edit value: (Time fromString: '11:59').
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.
	self assertIsNil: edit model value!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 6 3 10 0 84 105 109 101 84 111 84 101 120 116 0 0 0 0 0 0 0 0 0 0 0 0 54 0 6 0 83 116 114 105 110 103 8 0 0 0 72 72 58 109 109 46 115 115].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: TimeToText.
	self assert: subject leftNullValue equals: nil.
	self assert: subject rightNullValue equals: nil.
	self assert: subject locale identicalTo: Locale default.
	self assert: subject format equals: 'HH:mm.ss'.
	self assert: (subject convertFromLeftToRight: (Time fromSeconds: 5555)) equals: '01:32.35'! !

!UI.Tests.TimeToTextTest categoriesForMethods!
testInvalidFormat!public!unit tests! !
testStbConvertFromVersion0!public! !
!

