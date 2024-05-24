"Filed out from Dolphin Smalltalk"!

GdiplusFontFamilyInitializer subclass: #GdiplusFontFamilyGenericSerifInitializer
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusFontFamilyGenericSerifInitializer guid: (GUID fromString: '{57c9fb99-3104-48e2-b5e7-d4f2041b5a3e}')!

GdiplusFontFamilyGenericSerifInitializer comment: ''!

!GdiplusFontFamilyGenericSerifInitializer categoriesForClass!Unclassified! !

!GdiplusFontFamilyGenericSerifInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := ExternalHandle new.
	self library gdipGetGenericFontFamilySerif: gpHandle.
	^gpHandle! !

!GdiplusFontFamilyGenericSerifInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
!

!GdiplusFontFamilyGenericSerifInitializer class methodsFor!

uninitialize
	GenericSerif := nil! !

!GdiplusFontFamilyGenericSerifInitializer class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

