"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.FontFamilyInitializer subclass: #'Graphics.Gdiplus.FontFamilyFromNameInitializer'
	instanceVariableNames: 'name fontCollection'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamilyFromNameInitializer guid: (Core.GUID fromString: '{2688e140-b9b7-4e51-9b2d-f8bba5c90e2b}')!
Graphics.Gdiplus.FontFamilyFromNameInitializer comment: ''!
!Graphics.Gdiplus.FontFamilyFromNameInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject
		or: [super = anObject and: [name = anObject name and: [fontCollection = anObject fontCollection]]]!

basicCreateHandle
	| gpHandle status |
	gpHandle := Handle new.
	status := Gdip
				gdipCreateFontFamilyFromName: name
				fontCollection: fontCollection asParameter
				fontFamily: gpHandle.
	"For consistency of behaviour with GDI fonts in Dolphin, don't fail if the FontFamily doesn't exist on the machine, but rather return a generic font family. This is fairly likely anyway, and it is not particuarly useful to fail when the machine does not have the requested font installed."
	^status == Ok ifTrue: [gpHandle] ifFalse: [self class genericSansSerif createHandle]!

fontCollection
	^fontCollection!

getName: aHandle
	| buf |
	buf := Utf16String newFixed: Win32Constants.LF_FACESIZE.
	Gdip
		gdipGetFamilyName: aHandle
		name: buf
		language: NlsConstants.LANG_NEUTRAL.
	^buf trimNulls!

hash
	"Answer the <integer> hash value for the receiver."

	^((super hash + name hash) hashMultiply + fontCollection hash) hashMultiply!

initializeFromHandle: aGpFontFamilyHandle
	"Private - Cache all the attributes of the native Gdiplus FontFamily identified by the specified <External.Handle> into the receiver."

	name := self getName: aGpFontFamilyHandle
	"There is no API provided to retrieve the font collection from a family handle."!

name
	^name!

name: aString fontCollection: aFontCollection
	name := aString.
	fontCollection := aFontCollection.
	^self!

printAttributesOn: aStream
	aStream
		nextPutAll: #name:;
		space;
		print: name.
	fontCollection
		ifNotNil: 
			[aStream
				nextPutAll: ' fontCollection: ';
				print: fontCollection]! !
!Graphics.Gdiplus.FontFamilyFromNameInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
fontCollection!accessing!private! !
getName:!helpers!private! !
hash!comparing!public! !
initializeFromHandle:!initializing!private! !
name!accessing!private! !
name:fontCollection:!initializing!private! !
printAttributesOn:!printing!private! !
!

