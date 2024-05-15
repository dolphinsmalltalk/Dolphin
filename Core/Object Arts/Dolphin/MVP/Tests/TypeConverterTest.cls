"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #TypeConverterTest
	instanceVariableNames: 'edit savedLocale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TypeConverterTest guid: (GUID fromString: '{a68a6616-456e-4a7f-85e0-50d168d1a828}')!

TypeConverterTest isAbstract: true!

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

testInvalidFormat
	self subclassResponsibility!

testStbConvertFromVersion0
	self subclassResponsibility! !

!TypeConverterTest categoriesForMethods!
setUp!public!unit tests! !
tearDown!public!unit tests! !
testInvalidFormat!public!unit tests! !
testStbConvertFromVersion0!public! !
!

