"Filed out from Dolphin Smalltalk"!

UI.Scintilla.PropertyDescriptor
	subclass: #'UI.Scintilla.ColourAlphaPropertyDescriptor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.ColourAlphaPropertyDescriptor guid: (Core.GUID fromString: '{010719d4-b076-4654-8c87-15f795b7649f}')!
UI.Scintilla.ColourAlphaPropertyDescriptor comment: '`ColourAlphaPropertyDescriptor`s are `PropertyDescriptor`s for `ScintillaView` properties defined as being of `colouralpha` type in the scintilla.iface definition file.
'!
!UI.Scintilla.ColourAlphaPropertyDescriptor categoriesForClass!Kernel-Objects! !
!UI.Scintilla.ColourAlphaPropertyDescriptor methodsFor!

defaultFlags
	^NullableMask!

lParamFromAttributeValue: aColor
	^aColor rgbaCode!

valueFromLResult: anInteger
	^Color fromRgbaCode: anInteger! !
!UI.Scintilla.ColourAlphaPropertyDescriptor categoriesForMethods!
defaultFlags!constants!private! !
lParamFromAttributeValue:!helpers!private! !
valueFromLResult:!helpers!private! !
!

