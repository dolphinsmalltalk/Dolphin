"Filed out from Dolphin Smalltalk 7"!

ScintillaLexerMetadata subclass: #ScintillaLexerProperty
	instanceVariableNames: 'type'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ScintillaLexerProperty guid: (Core.GUID fromString: '{edef3c1e-b9c0-4eed-8b80-7ecdaeef15d7}')!
ScintillaLexerProperty comment: ''!
!ScintillaLexerProperty categoriesForClass!Kernel-Objects! !
!ScintillaLexerProperty methodsFor!

getDescription
	^view sciDescribeProperty: id!

name
	^id!

type
	^type ifNil: [type := view sciPropertyType: id]!

value
	^self type < ScintillaConstants.SC_TYPE_STRING
		ifTrue: 
			[| intVal |
			intVal := view sciGetPropertyInt: id defaultValue: 0.
			type == ScintillaConstants.SC_TYPE_BOOLEAN ifTrue: [intVal asBoolean] ifFalse: [intVal]]
		ifFalse: [view sciGetProperty: id]!

value: anObject
	view sciSetProperty: id
		value: (self type < ScintillaConstants.SC_TYPE_STRING
				ifTrue: [anObject asParameter printString]
				ifFalse: [anObject])! !
!ScintillaLexerProperty categoriesFor: #getDescription!accessing!private! !
!ScintillaLexerProperty categoriesFor: #name!accessing!public! !
!ScintillaLexerProperty categoriesFor: #type!accessing!public! !
!ScintillaLexerProperty categoriesFor: #value!accessing!public! !
!ScintillaLexerProperty categoriesFor: #value:!accessing!public! !

