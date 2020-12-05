"Filed out from Dolphin Smalltalk 7"!

UI.Scintilla.LexerMetadata subclass: #'UI.Scintilla.LexerNamedStyle'
	instanceVariableNames: 'name'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.LexerNamedStyle guid: (Core.GUID fromString: '{75e1ab33-a3b6-477a-9d03-35dd22b204a3}')!
UI.Scintilla.LexerNamedStyle comment: 'Metadata about the pre-defined styles supported by a particular lexer.

Not currently integrated in any useful way with the Scintilla style support in Dolphin''s Scintilla View wrapper. For example ScintillaView class>>xmlTextStyles answers a pre-configured set of styles definitions for each of the named styles of the XML lexer. The association is made through the style id, however.'!
!UI.Scintilla.LexerNamedStyle categoriesForClass!Kernel-Objects! !
!UI.Scintilla.LexerNamedStyle methodsFor!

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
!UI.Scintilla.LexerNamedStyle categoriesFor: #getDescription!accessing!private! !
!UI.Scintilla.LexerNamedStyle categoriesFor: #getName!accessing!private! !
!UI.Scintilla.LexerNamedStyle categoriesFor: #getTags!accessing!private! !
!UI.Scintilla.LexerNamedStyle categoriesFor: #name!accessing!public! !
!UI.Scintilla.LexerNamedStyle categoriesFor: #tags!accessing!public! !
!UI.Scintilla.LexerNamedStyle categoriesFor: #view:id:!initializing!private! !

