"Filed out from Dolphin Smalltalk 7"!

Kernel.STBProxy subclass: #'Kernel.STBExternalResourceLibraryProxy'
	instanceVariableNames: 'fileName _reserved1'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBExternalResourceLibraryProxy guid: (Core.GUID fromString: '{87b4c6ec-026e-11d3-9fd7-00a0cc3e4a32}')!
Kernel.STBExternalResourceLibraryProxy comment: 'STBExternalResourceLibraryProxy is the class of <STBProxy>s used to save the state necessary to re-open an <ExternalResourceLibrary> from an STB stream. We use a special proxy in order to share a common instance so that each resource library need only be opened once.'!
!Kernel.STBExternalResourceLibraryProxy categoriesForClass!System-Binary storage! !
!Kernel.STBExternalResourceLibraryProxy methodsFor!

fileName: path
	"Private - Set the file name of the library represented by the receiver
	to the <readableString>, path."

	fileName := path!

stbFixup: inFiler at: id
	"Answer the object that this one represents.
	Implementation Note: The library that we represent may already be open 
	and cached in the table of open resource libraries, so we must not use become: 
	to swap the receiver with it. Instead we need to tell inFiler to replace 
	its (only) readMap entry for the receiver with the object it represents."

	| anObject |
	anObject := self value.
	inFiler fixup: id to: anObject.
	^anObject!

value
	"Answer an <External.ResourceLibrary> opened on the receiver's
	file path name."

	^External.ResourceLibrary open: fileName! !
!Kernel.STBExternalResourceLibraryProxy categoriesFor: #fileName:!accessing!private! !
!Kernel.STBExternalResourceLibraryProxy categoriesFor: #stbFixup:at:!converting!public! !
!Kernel.STBExternalResourceLibraryProxy categoriesFor: #value!converting!public! !

!Kernel.STBExternalResourceLibraryProxy class methodsFor!

forLibrary: lib
	"Answer a new instance representing the <ExternalResourceLibrary>, lib."

	^self basicNew
		fileName: lib fileName;
		yourself! !
!Kernel.STBExternalResourceLibraryProxy class categoriesFor: #forLibrary:!instance creation!public! !

