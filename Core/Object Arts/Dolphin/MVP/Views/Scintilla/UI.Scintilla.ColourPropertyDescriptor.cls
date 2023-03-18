"Filed out from Dolphin Smalltalk"!

UI.Scintilla.PropertyDescriptor
	subclass: #'UI.Scintilla.ColourPropertyDescriptor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.ColourPropertyDescriptor guid: (Core.GUID fromString: '{9bc3c105-f33d-4670-ac98-9126601fbbd9}')!
UI.Scintilla.ColourPropertyDescriptor comment: '`ColourPropertyDescriptor`s are `PropertyDescriptor`s for `ScintillaView` properties defined as being of `colour` type in the scintilla.iface definition file.

Scintilla always uses the RGB format for colors, and does not expect to receive any of the special forms of colour id (indexed colours, system colours). Although these will sometimes work, because Scintilla treats them as opaque values that it just passed through to GDI, they won''t work when a drawing technology other than GDI is used, e.g. DirectWrite.'!
!UI.Scintilla.ColourPropertyDescriptor categoriesForClass!Kernel-Objects! !
!UI.Scintilla.ColourPropertyDescriptor methodsFor!

defaultFlags
	^NullableMask!

lParamFromAttributeValue: aColor
	^aColor rgbCode!

valueFromLResult: anInteger
	^Color fromRgbCode: anInteger! !
!UI.Scintilla.ColourPropertyDescriptor categoriesForMethods!
defaultFlags!constants!private! !
lParamFromAttributeValue:!helpers!private! !
valueFromLResult:!helpers!private! !
!

