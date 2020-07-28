"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ScintillaLexerMetadata
	instanceVariableNames: 'view id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScintillaLexerMetadata guid: (GUID fromString: '{46328983-b7d1-40ad-a5aa-68899e36af2e}')!
ScintillaLexerMetadata isAbstract: true!
ScintillaLexerMetadata comment: ''!
!ScintillaLexerMetadata categoriesForClass!Kernel-Objects! !
!ScintillaLexerMetadata methodsFor!

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
!ScintillaLexerMetadata categoriesFor: #description!accessing!public! !
!ScintillaLexerMetadata categoriesFor: #displayOn:!printing!public! !
!ScintillaLexerMetadata categoriesFor: #getDescription!accessing!private! !
!ScintillaLexerMetadata categoriesFor: #id!accessing!private! !
!ScintillaLexerMetadata categoriesFor: #name!accessing!public! !
!ScintillaLexerMetadata categoriesFor: #printOn:!printing!public! !
!ScintillaLexerMetadata categoriesFor: #view!accessing!private! !
!ScintillaLexerMetadata categoriesFor: #view:id:!public! !

!ScintillaLexerMetadata class methodsFor!

icon
	^ScintillaView icon!

view: aScintillaView id: anObject
	<primitive: 157>
	^self new view: aScintillaView id: anObject! !
!ScintillaLexerMetadata class categoriesFor: #icon!constants!development!public! !
!ScintillaLexerMetadata class categoriesFor: #view:id:!instance creation!public! !

