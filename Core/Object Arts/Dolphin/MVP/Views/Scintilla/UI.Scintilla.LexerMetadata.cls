"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.LexerMetadata'
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

!UI.Scintilla.LexerMetadata categoriesForMethods!
description!accessing!public! !
displayOn:!printing!public! !
getDescription!accessing!private! !
id!accessing!private! !
name!accessing!public! !
printOn:!printing!public! !
view!accessing!private! !
view:id:!initializing!private! !
!

!UI.Scintilla.LexerMetadata class methodsFor!

icon
	^ScintillaView icon!

view: aScintillaView id: anObject
	<primitive: 157>
	^self new view: aScintillaView id: anObject! !

!UI.Scintilla.LexerMetadata class categoriesForMethods!
icon!constants!development!public! !
view:id:!instance creation!public! !
!

