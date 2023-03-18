"Filed out from Dolphin Smalltalk"!

UI.Scintilla.ThreeStateBooleanPropertyDescriptor
	subclass: #'UI.Scintilla.InvertedThreeStateBooleanPropertyDescriptor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.InvertedThreeStateBooleanPropertyDescriptor guid: (Core.GUID fromString: '{3902e233-24d2-494e-8b30-c615355d3c31}')!
UI.Scintilla.InvertedThreeStateBooleanPropertyDescriptor comment: ''!
!UI.Scintilla.InvertedThreeStateBooleanPropertyDescriptor methodsFor!

lParamFromAttributeValue: anObject
	^anObject not asUIntPtr!

valueFromLResult: anObject 
	^anObject == 0! !
!UI.Scintilla.InvertedThreeStateBooleanPropertyDescriptor categoriesForMethods!
lParamFromAttributeValue:!helpers!private! !
valueFromLResult:!helpers!private! !
!

