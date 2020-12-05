"Filed out from Dolphin Smalltalk 7"!

UI.Scintilla.Styler subclass: #'UI.Scintilla.NullStyler'
	instanceVariableNames: 'normalStyleName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.NullStyler guid: (Core.GUID fromString: '{930680af-646b-4660-a349-1f5e5a8e0fec}')!
UI.Scintilla.NullStyler comment: 'NullScintillaStyler is a <ScintillaStyler> that leaves text in plain unformatted form, i.e. all text assumes the configured ''normal'' style, which is normally the style named #normal.

This styler is useful either when one wants to use Scintilla, but with plain text, or to temporarily disable styling.

Instance Variables:
	normalStyleName		<Symbol>'!
!UI.Scintilla.NullStyler categoriesForClass!Kernel-Objects! !
!UI.Scintilla.NullStyler methodsFor!

initialize
	normalStyleName := #normal!

normalStyleName
	^normalStyleName!

normalStyleName: anObject
	normalStyleName := anObject ifNotNil: [anObject asSymbol]!

onStyleNeeded: aScintillaView from: startInteger to: stopInteger 
	"Callback from Scintilla requesting that the specified range of text be coloured.
	In this case we just set to the default style, regardless."

	aScintillaView applyStyle: self normalStyleName toNext: stopInteger - startInteger + 1! !
!UI.Scintilla.NullStyler categoriesFor: #initialize!initializing!public! !
!UI.Scintilla.NullStyler categoriesFor: #normalStyleName!accessing!public! !
!UI.Scintilla.NullStyler categoriesFor: #normalStyleName:!accessing!public! !
!UI.Scintilla.NullStyler categoriesFor: #onStyleNeeded:from:to:!event handling!public! !

!UI.Scintilla.NullStyler class methodsFor!

stbConvertFrom: anSTBVersion 
	^[:instVars | self new]!

stbVersion
	^1! !
!UI.Scintilla.NullStyler class categoriesFor: #stbConvertFrom:!binary filing!public! !
!UI.Scintilla.NullStyler class categoriesFor: #stbVersion!binary filing!public! !

