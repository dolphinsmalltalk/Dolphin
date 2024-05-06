"Filed out from Dolphin Smalltalk"!

ScintillaLexerMetadata subclass: #ScintillaLexerNamedStyle
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaLexerNamedStyle guid: (GUID fromString: '{75e1ab33-a3b6-477a-9d03-35dd22b204a3}')!

ScintillaLexerNamedStyle comment: 'Metadata about the pre-defined styles supported by a particular lexer.

Not currently integrated in any useful way with the Scintilla style support in Dolphin''s Scintilla View wrapper. For example ScintillaView class>>xmlTextStyles answers a pre-configured set of styles definitions for each of the named styles of the XML lexer. The association is made through the style id, however.'!

!ScintillaLexerNamedStyle categoriesForClass!Kernel-Objects! !

!ScintillaLexerNamedStyle methodsFor!

getDescription
	^view sciDescriptionOfStyle: id!

getName
	^view sciNameOfStyle: id!

getTags
	^(view sciTagsOfStyle: id) subStrings!

name
	^name ifNil: [name := self getName]!

tags
	^self getTags!

view: aScintillaView id: anInteger
	view := aScintillaView.
	id := anInteger! !

!ScintillaLexerNamedStyle categoriesForMethods!
getDescription!accessing!private! !
getName!accessing!private! !
getTags!accessing!private! !
name!accessing!public! !
tags!accessing!public! !
view:id:!initializing!private! !
!

