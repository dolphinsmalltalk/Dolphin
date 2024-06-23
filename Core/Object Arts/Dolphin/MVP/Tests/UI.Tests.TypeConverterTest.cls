"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.TypeConverterTest'
	instanceVariableNames: 'edit'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.TypeConverterTest guid: (Core.GUID fromString: '{a68a6616-456e-4a7f-85e0-50d168d1a828}')!

UI.Tests.TypeConverterTest isNonInstantiable: true!

UI.Tests.TypeConverterTest comment: ''!

!UI.Tests.TypeConverterTest methodsFor!

setUp
	super setUp.
	edit := TextEdit show!

tearDown
	edit topShell destroy.
	edit := nil.
	super tearDown!

testInvalidFormat
	self subclassResponsibility!

testStbConvertFromVersion0
	self subclassResponsibility! !

!UI.Tests.TypeConverterTest categoriesForMethods!
setUp!public!unit tests! !
tearDown!public!unit tests! !
testInvalidFormat!public!unit tests! !
testStbConvertFromVersion0!public! !
!

