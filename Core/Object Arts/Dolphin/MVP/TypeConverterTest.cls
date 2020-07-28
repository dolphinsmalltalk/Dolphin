"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #TypeConverterTest
	instanceVariableNames: 'edit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TypeConverterTest guid: (GUID fromString: '{a68a6616-456e-4a7f-85e0-50d168d1a828}')!
TypeConverterTest comment: ''!
!TypeConverterTest categoriesForClass!Unclassified! !
!TypeConverterTest methodsFor!

setUp
	edit := TextEdit show!

tearDown
	edit topShell destroy!

testInvalidBooleanFormat
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

testInvalidDateFormat
	"Test for a couple of locales with different default date orders"

	{Locale named: 'en-US'. Locale named: 'en-GB'} do: 
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

testInvalidDurationFormat
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

testInvalidNumberFormat
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

testInvalidTimeFormat
	edit typeconverter: TimeToText new.
	edit value: (Time fromString: '11:59').
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.
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
	self assert: edit text isEmpty	"#1257"! !
!TypeConverterTest categoriesFor: #setUp!public!unit tests! !
!TypeConverterTest categoriesFor: #tearDown!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidBooleanFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidDateFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidDurationFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidNumberFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidTimeFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testLeftNullValue!public!unit tests! !

