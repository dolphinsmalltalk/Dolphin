"Filed out from Dolphin Smalltalk 7"!

UI.Scintilla.LexerMetadata subclass: #'UI.Scintilla.LexerProperty'
	instanceVariableNames: 'type'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.LexerProperty guid: (Core.GUID fromString: '{edef3c1e-b9c0-4eed-8b80-7ecdaeef15d7}')!
UI.Scintilla.LexerProperty comment: ''!
!UI.Scintilla.LexerProperty categoriesForClass!Kernel-Objects! !
!UI.Scintilla.LexerProperty methodsFor!

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
!UI.Scintilla.LexerProperty categoriesFor: #getDescription!accessing!private! !
!UI.Scintilla.LexerProperty categoriesFor: #name!accessing!public! !
!UI.Scintilla.LexerProperty categoriesFor: #type!accessing!public! !
!UI.Scintilla.LexerProperty categoriesFor: #value!accessing!public! !
!UI.Scintilla.LexerProperty categoriesFor: #value:!accessing!public! !

