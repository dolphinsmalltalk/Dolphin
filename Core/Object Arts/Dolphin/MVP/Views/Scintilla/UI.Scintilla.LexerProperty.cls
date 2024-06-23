"Filed out from Dolphin Smalltalk"!

UI.Scintilla.LexerMetadata
	subclass: #'UI.Scintilla.LexerProperty'
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
	^self type < SC_TYPE_STRING
		ifTrue: 
			[| intVal |
			intVal := view sciGetPropertyInt: id defaultValue: 0.
			type == SC_TYPE_BOOLEAN ifTrue: [intVal asBoolean] ifFalse: [intVal]]
		ifFalse: [view sciGetProperty: id]!

value: anObject
	view sciSetProperty: id
		value: (self type < SC_TYPE_STRING
				ifTrue: [anObject asParameter printString]
				ifFalse: [anObject])! !

!UI.Scintilla.LexerProperty categoriesForMethods!
getDescription!accessing!private! !
name!accessing!public! !
type!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
!

