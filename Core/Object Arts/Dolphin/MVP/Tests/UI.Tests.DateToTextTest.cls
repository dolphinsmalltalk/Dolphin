﻿"Filed out from Dolphin Smalltalk"!

UI.Tests.TypeConverterTest
	subclass: #'UI.Tests.DateToTextTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.DateToTextTest guid: (Core.GUID fromString: '{074b66b7-70b4-4f0c-af2d-3e2400170b3d}')!

UI.Tests.DateToTextTest comment: ''!

!UI.Tests.DateToTextTest methodsFor!

testInvalidFormat
	"Test for a couple of locales with different default date orders"

	{ Locale named: 'en-US'. Locale named: 'en-GB' } do: 
			[:locale |
			#('99' 'abcd') do: 
					[:each |
					edit typeconverter: (DateToText new
								locale: locale;
								yourself).
					edit value: (Date fromString: '1/1/03').
					self shouldnt: 
							[edit
								text: each;
								isTextModified: true;
								updateModel]
						raise: InvalidFormat.
					self assertIsNil: edit model value]]!

testStbConvertFromVersion0
	| bytes subject |
	bytes := #[33 83 84 66 32 48 32 6 3 10 0 68 97 116 101 84 111 84 101 120 116 0 0 0 0 6 1 4 0 68 97 116 101 0 0 0 0 1 0 0 0 54 0 6 0 83 116 114 105 110 103 0 0 0 0 146 0 0 0 8 0 0 0 100 100 32 77 77 32 89 89].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: DateToText.
	self assert: subject leftNullValue equals: (Date fromDays: 0).
	self assert: subject rightNullValue equals: ''.
	self assert: subject locale identicalTo: Locale default.
	self assert: subject format equals: 'dd MM YY'! !

!UI.Tests.DateToTextTest categoriesForMethods!
testInvalidFormat!public!unit tests! !
testStbConvertFromVersion0!public! !
!

