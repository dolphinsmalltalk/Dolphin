"Filed out from Dolphin Smalltalk"!

GdiplusFontFamilyInitializer subclass: #GdiplusFontFamilyGenericSansSerifInitializer
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusFontFamilyGenericSansSerifInitializer guid: (GUID fromString: '{f784e19e-0b3b-498c-a5c4-456c191906c7}')!

GdiplusFontFamilyGenericSansSerifInitializer comment: ''!

!GdiplusFontFamilyGenericSansSerifInitializer categoriesForClass!Unclassified! !

!GdiplusFontFamilyGenericSansSerifInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := ExternalHandle new.
	self library gdipGetGenericFontFamilySansSerif: gpHandle.
	^gpHandle! !

!GdiplusFontFamilyGenericSansSerifInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
!

!GdiplusFontFamilyGenericSansSerifInitializer class methodsFor!

uninitialize
	GenericSansSerif := nil! !

!GdiplusFontFamilyGenericSansSerifInitializer class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

