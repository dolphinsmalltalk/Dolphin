"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ColorDialogTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ColorDialogTest guid: (GUID fromString: '{9f86c1ad-cb21-4061-be85-0cd9561cda37}')!

ColorDialogTest comment: ''!

!ColorDialogTest categoriesForClass!Unclassified! !

!ColorDialogTest methodsFor!

testColorDefault
	"We don't need to test the actual ColorDialog (which is modal), just that the default colour roundtrips."

	| subject model struct |
	model := Color default asValue.
	subject := ColorDialog on: model.
	subject prepareStruct.
	struct := subject winStruct.
	self assert: struct color equals: ColorRef defaultColorRepresentation.
	model value: Color black.
	subject extractResult: true.
	self assert: model value equals: Color default! !

!ColorDialogTest categoriesForMethods!
testColorDefault!public!unit tests! !
!

