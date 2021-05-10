"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'UI.Scintilla.LexillaLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.LexillaLibrary guid: (Core.GUID fromString: '{a34fd000-7092-4296-a98e-01bfd5d23b65}')!
UI.Scintilla.LexillaLibrary comment: '
```
lexilla := LexillaLibrary default.
languages := lexilla getLexerNames.
ScintillaView lexerLanguages difference: languages.
languages difference: ScintillaView lexerLanguages.

```'!
!UI.Scintilla.LexillaLibrary categoriesForClass!External-Libraries! !
!UI.Scintilla.LexillaLibrary methodsFor!

createLexer: aString
	<stdcall: void* CreateLexer lpstr>
	^self invalidCall: _failureCode!

getLexerCount
	<stdcall: sdword GetLexerCount>
	^self invalidCall: _failureCode!

getLexerName: indexInteger name: aString buflength: lengthInteger
	<stdcall: sdword GetLexerName sdword lpstr sdword>
	^self invalidCall: _failureCode!

getLexerNames
	| count buf bufsize |
	count := self getLexerCount.
	buf := String newFixed: 128.
	bufsize := buf byteSize.
	^(0 to: count - 1) collect: 
			[:index |
			self
				getLexerName: index
				name: buf
				buflength: bufsize.
			buf trimNulls]! !
!UI.Scintilla.LexillaLibrary categoriesFor: #createLexer:!operations!public! !
!UI.Scintilla.LexillaLibrary categoriesFor: #getLexerCount!operations!public! !
!UI.Scintilla.LexillaLibrary categoriesFor: #getLexerName:name:buflength:!operations!public! !
!UI.Scintilla.LexillaLibrary categoriesFor: #getLexerNames!enquiries!public! !

!UI.Scintilla.LexillaLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the receiver represents"

	^'Lexilla'! !
!UI.Scintilla.LexillaLibrary class categoriesFor: #fileName!constants!public! !

