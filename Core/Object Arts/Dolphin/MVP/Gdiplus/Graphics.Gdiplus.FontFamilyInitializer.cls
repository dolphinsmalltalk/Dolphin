"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer
	subclass: #'Graphics.Gdiplus.FontFamilyInitializer'
	instanceVariableNames: ''
	classVariableNames: 'GenericMonospace GenericSansSerif GenericSerif'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamilyInitializer guid: (Core.GUID fromString: '{c09d8c09-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.FontFamilyInitializer isNonInstantiable: true!
Graphics.Gdiplus.FontFamilyInitializer comment: ''!
!Graphics.Gdiplus.FontFamilyInitializer methodsFor!

= anObject
	^self species == anObject species!

hash
	^self species hash!

isSelfEvaluating
	^true! !
!Graphics.Gdiplus.FontFamilyInitializer categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isSelfEvaluating!public!testing! !
!

!Graphics.Gdiplus.FontFamilyInitializer class methodsFor!

cloneHandle: aHandle
	| clone |
	clone := Handle new.
	Gdip gdipCloneFontFamily: aHandle clonedFontFamily: clone.
	^clone!

freeHandle: aHandle
	Gdip gdipDeleteFontFamily: aHandle!

genericMonospace
	^GenericMonospace ifNil: [GenericMonospace := FontFamilyGenericMonospaceInitializer basicNew]!

genericSansSerif
	^GenericSansSerif ifNil: [GenericSansSerif := FontFamilyGenericSansSerifInitializer basicNew]!

genericSerif
	^GenericSerif ifNil: [GenericSerif := FontFamilyGenericSerifInitializer basicNew]!

name: aString
	^self name: aString fontCollection: nil!

name: aString fontCollection: aFontCollection
	^FontFamilyFromNameInitializer basicNew name: aString fontCollection: aFontCollection!

onPreStripImage
	"Private -  Allow the receiver and subclasses to be stripped by clearing lazy initialized class variables
	which hold sub-instance of the receiver."

	GenericSansSerif := GenericSerif := nil! !
!Graphics.Gdiplus.FontFamilyInitializer class categoriesForMethods!
cloneHandle:!private!realizing/unrealizing! !
freeHandle:!private!realizing/unrealizing! !
genericMonospace!instance creation!public! !
genericSansSerif!instance creation!public! !
genericSerif!instance creation!public! !
name:!instance creation!public! !
name:fontCollection:!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
!

