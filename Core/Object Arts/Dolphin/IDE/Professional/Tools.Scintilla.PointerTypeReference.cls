"Filed out from Dolphin Smalltalk"!

Tools.Scintilla.TypeReference
	subclass: #'Tools.Scintilla.PointerTypeReference'
	instanceVariableNames: 'name objectClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Scintilla.PointerTypeReference guid: (Core.GUID fromString: '{e266c63f-6fe4-4cc8-a4ff-18d6f3c3fafe}')!

Tools.Scintilla.PointerTypeReference comment: ''!

!Tools.Scintilla.PointerTypeReference categoriesForClass!Development! !

!Tools.Scintilla.PointerTypeReference methodsFor!

byRef
	^true!

defaultValue
	^0!

emitReturnConversionAround: aBlockClosure on: aPuttableStream
	aPuttableStream
		print: self objectClass;
		space;
		nextPutAll: self fromMessage;
		nextPutAll: ' ('.
	aBlockClosure value.
	aPuttableStream nextPut: $)!

fromMessage
	^#fromAddress:!

name
	^name!

name: aString objectClass: aClass
	name := aString.
	objectClass := aClass!

objectClass
	^objectClass! !

!Tools.Scintilla.PointerTypeReference categoriesForMethods!
byRef!accessing!public! !
defaultValue!constants!public! !
emitReturnConversionAround:on:!generating!private! !
fromMessage!accessing!public! !
name!accessing!public! !
name:objectClass:!instance creation!private! !
objectClass!accessing!public! !
!

!Tools.Scintilla.PointerTypeReference class methodsFor!

name: aString objectClass: aClass
	^self new name: aString objectClass: aClass! !

!Tools.Scintilla.PointerTypeReference class categoriesForMethods!
name:objectClass:!instance creation!private! !
!

