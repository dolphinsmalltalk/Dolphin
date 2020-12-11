"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'UI.Tests.ColorDialogTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ColorDialogTest guid: (Core.GUID fromString: '{9f86c1ad-cb21-4061-be85-0cd9561cda37}')!
UI.Tests.ColorDialogTest comment: ''!
!UI.Tests.ColorDialogTest categoriesForClass!Unclassified! !
!UI.Tests.ColorDialogTest methodsFor!

testColorDefault
	"We don't need to test the actual ColorDialog (which is modal), just that the default colour roundtrips."

	| subject model struct |
	model := Color default asValue.
	subject := UI.ColorDialog on: model.
	subject prepareStruct.
	struct := subject winStruct.
	self assert: struct color equals: ColorRef defaultColorRepresentation.
	model value: Color black.
	subject extractResult: true.
	self assert: model value equals: Color default! !
!UI.Tests.ColorDialogTest categoriesFor: #testColorDefault!public! !

