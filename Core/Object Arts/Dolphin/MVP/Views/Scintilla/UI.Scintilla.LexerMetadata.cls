"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.Scintilla.LexerMetadata'
	instanceVariableNames: 'view id'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.LexerMetadata guid: (Core.GUID fromString: '{46328983-b7d1-40ad-a5aa-68899e36af2e}')!
UI.Scintilla.LexerMetadata isNonInstantiable: true!
UI.Scintilla.LexerMetadata comment: ''!
!UI.Scintilla.LexerMetadata categoriesForClass!Kernel-Objects! !
!UI.Scintilla.LexerMetadata methodsFor!

description
	^self getDescription!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self name!

getDescription
	^self subclassResponsibility!

id
	^id!

name
	^self subclassResponsibility!

printOn: target
	super printOn: target.
	target
		nextPut: $(;
		display: self;
		space;
		print: self description;
		nextPut: $)!

view
	^view!

view: aScintillaView id: anObject
	view := aScintillaView.
	id := anObject! !
!UI.Scintilla.LexerMetadata categoriesFor: #description!accessing!public! !
!UI.Scintilla.LexerMetadata categoriesFor: #displayOn:!printing!public! !
!UI.Scintilla.LexerMetadata categoriesFor: #getDescription!accessing!private! !
!UI.Scintilla.LexerMetadata categoriesFor: #id!accessing!private! !
!UI.Scintilla.LexerMetadata categoriesFor: #name!accessing!public! !
!UI.Scintilla.LexerMetadata categoriesFor: #printOn:!printing!public! !
!UI.Scintilla.LexerMetadata categoriesFor: #view!accessing!private! !
!UI.Scintilla.LexerMetadata categoriesFor: #view:id:!initializing!private! !

!UI.Scintilla.LexerMetadata class methodsFor!

icon
	^ScintillaView icon!

view: aScintillaView id: anObject
	<primitive: 157>
	^self new view: aScintillaView id: anObject! !
!UI.Scintilla.LexerMetadata class categoriesFor: #icon!constants!development!public! !
!UI.Scintilla.LexerMetadata class categoriesFor: #view:id:!instance creation!public! !

