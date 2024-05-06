"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #TypeConverterTest
	instanceVariableNames: 'edit savedLocale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TypeConverterTest guid: (GUID fromString: '{a68a6616-456e-4a7f-85e0-50d168d1a828}')!

TypeConverterTest comment: ''!

!TypeConverterTest categoriesForClass!Unclassified! !

!TypeConverterTest methodsFor!

setUp
	savedLocale := Locale userDefault.
	"Many formatting tests are Locale sensitive, so use a known Locale"
	Locale userDefault: (Locale lcid: 1033).
	edit := TextEdit show.
!

tearDown
	savedLocale ifNotNil: [Locale userDefault: savedLocale. savedLocale := nil].
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

	#(1033 2057) do: 
			[:lcid |
			Locale userDefault: (Locale lcid: lcid).
			#('99' 'abcd') do: 
					[:each |
					edit typeconverter: DateToText new.
					edit value: (Date fromString: '1/1/03').
					self shouldnt: 
							[edit
								text: each;
								isTextModified: true;
								updateModel]
						raise: InvalidFormat.
					self assertIsNil: edit model value]]!

testInvalidDurationFormat
	edit typeconverter: DurationToText new.
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

!TypeConverterTest categoriesForMethods!
setUp!public!unit tests! !
tearDown!public!unit tests! !
testInvalidBooleanFormat!public!unit tests! !
testInvalidDateFormat!public!unit tests! !
testInvalidDurationFormat!public!unit tests! !
testInvalidNumberFormat!public!unit tests! !
testInvalidTimeFormat!public!unit tests! !
testLeftNullValue!public!unit tests! !
!

