"Filed out from Dolphin Smalltalk 7"!

ScintillaPropertyDescriptor subclass: #ScintillaColorPropertyDescriptor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScintillaColorPropertyDescriptor guid: (GUID fromString: '{9bc3c105-f33d-4670-ac98-9126601fbbd9}')!
ScintillaColorPropertyDescriptor comment: '`ScintillaColorPropertyDescriptor`s are `ScintillaPropertyDescriptor`s for color properties of a `ScintillaView`. 

Scintilla always uses the RGB format for colors, and does not expect to receive any of the special forms of colour id (indexed colours, system colours). Although these will sometimes work, because Scintilla treats them as opaque values that it just passed through to GDI, they won''t work when a drawing technology other than GDI is used, e.g. DirectWrite.'!
!ScintillaColorPropertyDescriptor categoriesForClass!Kernel-Objects! !
!ScintillaColorPropertyDescriptor methodsFor!

lParamFromAttributeValue: aColor
	^aColor rgbCode!

valueFromLResult: anInteger
	^Color fromRgbCode: anInteger! !
!ScintillaColorPropertyDescriptor categoriesFor: #lParamFromAttributeValue:!helpers!private! !
!ScintillaColorPropertyDescriptor categoriesFor: #valueFromLResult:!helpers!private! !

