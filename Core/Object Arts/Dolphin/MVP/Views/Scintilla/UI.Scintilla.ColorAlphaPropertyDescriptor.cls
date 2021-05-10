"Filed out from Dolphin Smalltalk 7"!

UI.Scintilla.PropertyDescriptor subclass: #'UI.Scintilla.ColorAlphaPropertyDescriptor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.ColorAlphaPropertyDescriptor guid: (Core.GUID fromString: '{010719d4-b076-4654-8c87-15f795b7649f}')!
UI.Scintilla.ColorAlphaPropertyDescriptor comment: ''!
!UI.Scintilla.ColorAlphaPropertyDescriptor categoriesForClass!Kernel-Objects! !
!UI.Scintilla.ColorAlphaPropertyDescriptor methodsFor!

lParamFromAttributeValue: aColor
	^aColor rgbaCode!

valueFromLResult: anInteger
	^Color fromRgbaCode: anInteger! !
!UI.Scintilla.ColorAlphaPropertyDescriptor categoriesFor: #lParamFromAttributeValue:!helpers!private! !
!UI.Scintilla.ColorAlphaPropertyDescriptor categoriesFor: #valueFromLResult:!helpers!private! !

