"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #TypeConverterTest
	instanceVariableNames: 'edit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TypeConverterTest guid: (GUID fromString: '{a68a6616-456e-4a7f-85e0-50d168d1a828}')!
TypeConverterTest comment: ''!
!TypeConverterTest categoriesForClass!Unclassified! !
!TypeConverterTest methodsFor!

setUp
	edit := TextEdit show.
!

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
	self assert: edit model value isNil.
!

testInvalidDateFormat
	edit typeconverter: DateToText new.
	edit value: (Date fromString: '1/1/03').
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.
	self assert: edit model value isNil!

testInvalidNumberFormat
	edit typeconverter: NumberToText new.
	edit value: 100.
	self assert: edit model value =100.
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat. "#1362"
	self assert: edit model value isNil!

testInvalidTimeFormat
	edit typeconverter: TimeToText new.
	edit value: (Time fromString: '11:59').
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.
	self assert: edit model value isNil!

testLeftNullValue
	edit typeconverter: NumberToText new.
	edit value: 500.
	self shouldnt: 
			[edit
				text: 'abcd';
				isTextModified: true;
				updateModel]
		raise: InvalidFormat.
	self assert: edit model value isNil.
	self assert: edit text isEmpty.
	edit
		text: 'xyz';
		isTextModified: true;
		updateModel.
	self assert: edit model value isNil.
	self assert: edit text isEmpty	"#1257"! !
!TypeConverterTest categoriesFor: #setUp!public!unit tests! !
!TypeConverterTest categoriesFor: #tearDown!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidBooleanFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidDateFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidNumberFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testInvalidTimeFormat!public!unit tests! !
!TypeConverterTest categoriesFor: #testLeftNullValue!public!unit tests! !

