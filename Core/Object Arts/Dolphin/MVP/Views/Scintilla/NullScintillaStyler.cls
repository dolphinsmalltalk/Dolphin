"Filed out from Dolphin Smalltalk 7"!

ScintillaStyler subclass: #NullScintillaStyler
	instanceVariableNames: 'normalStyleName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NullScintillaStyler guid: (GUID fromString: '{930680AF-646B-4660-A349-1F5E5A8E0FEC}')!
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

	aScintillaView applyStyle: self normalStyleName toNext: stopInteger - startInteger + 1!

storeOn: aStream

	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' new'.
	normalStyleName == #'normal' ifFalse: [
		aStream nextPutAll: ' normalStyleName: '.
		normalStyleName storeOn: aStream.
		aStream nextPutAll: '; yourself'.
	].
	aStream nextPut: $)! !
!NullScintillaStyler categoriesFor: #initialize!initializing!public! !
!NullScintillaStyler categoriesFor: #normalStyleName!accessing!public! !
!NullScintillaStyler categoriesFor: #normalStyleName:!accessing!public! !
!NullScintillaStyler categoriesFor: #onStyleNeeded:from:to:!event handling!public! !
!NullScintillaStyler categoriesFor: #storeOn:!printing!public! !

!NullScintillaStyler class methodsFor!

stbConvertFrom: anSTBVersion 
	^[:instVars | self new]!

stbVersion
	^1! !
!NullScintillaStyler class categoriesFor: #stbConvertFrom:!binary filing!public! !
!NullScintillaStyler class categoriesFor: #stbVersion!binary filing!public! !

