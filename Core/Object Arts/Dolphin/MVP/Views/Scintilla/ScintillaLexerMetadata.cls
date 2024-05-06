"Filed out from Dolphin Smalltalk"!

Object subclass: #ScintillaLexerMetadata
	instanceVariableNames: 'view id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaLexerMetadata guid: (GUID fromString: '{46328983-b7d1-40ad-a5aa-68899e36af2e}')!

ScintillaLexerMetadata isAbstract: true!

ScintillaLexerMetadata comment: ''!

!ScintillaLexerMetadata categoriesForClass!Kernel-Objects! !

!ScintillaLexerMetadata methodsFor!

description
	^self getDescription!

displayOn: target
	target display: self name!

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

!ScintillaLexerMetadata categoriesForMethods!
description!accessing!public! !
displayOn:!printing!public! !
getDescription!accessing!private! !
id!accessing!private! !
name!accessing!public! !
printOn:!printing!public! !
view!accessing!private! !
view:id:!public! !
!

!ScintillaLexerMetadata class methodsFor!

icon
	^ScintillaView icon!

view: aScintillaView id: anObject
	<primitive: 157>
	^self new view: aScintillaView id: anObject! !

!ScintillaLexerMetadata class categoriesForMethods!
icon!constants!development!public! !
view:id:!instance creation!public! !
!

