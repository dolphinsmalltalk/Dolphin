"Filed out from Dolphin Smalltalk"!

ScintillaStyler subclass: #NullScintillaStyler
	instanceVariableNames: 'normalStyleName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NullScintillaStyler guid: (GUID fromString: '{930680af-646b-4660-a349-1f5e5a8e0fec}')!

NullScintillaStyler comment: 'NullScintillaStyler is a <ScintillaStyler> that leaves text in plain unformatted form, i.e. all text assumes the configured ''normal'' style, which is normally the style named #normal.

This styler is useful either when one wants to use Scintilla, but with plain text, or to temporarily disable styling.

Instance Variables:
	normalStyleName		<Symbol>'!

!NullScintillaStyler categoriesForClass!Kernel-Objects! !

!NullScintillaStyler methodsFor!

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

!NullScintillaStyler categoriesForMethods!
initialize!initializing!public! !
normalStyleName!accessing!public! !
normalStyleName:!accessing!public! !
onStyleNeeded:from:to:!event handling!public! !
!

!NullScintillaStyler class methodsFor!

stbConvertFrom: anSTBVersion 
	^[:instVars | self new]!

stbVersion
	^1! !

!NullScintillaStyler class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

