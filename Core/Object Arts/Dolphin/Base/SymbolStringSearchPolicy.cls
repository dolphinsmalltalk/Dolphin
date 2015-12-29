"Filed out from Dolphin Smalltalk X6"!

SingletonSearchPolicy subclass: #SymbolStringSearchPolicy
	instanceVariableNames: ''
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SymbolStringSearchPolicy guid: (GUID fromString: '{EA77CBF2-0CBB-4FBE-AC7B-A9AC258F1D4A}')!
SymbolStringSearchPolicy comment: 'SymbolStringSearchPolicy is for configuring pluggable collections and models of <String>s or <Symbol>s such that the same sequence of characters compare as equal, regardless of whether the sequence is stored in a Symbol or a String. Normally Symbols are not considered equal to Strings even when they contain the same characters.

N.B. Unlike most other SearchPolicy classes, instances of this class are only appropriate for comparing and searching collections of Symbols and Strings (the objects to be compared must implement #hashCharacters and #trueCompare:).'!
!SymbolStringSearchPolicy categoriesForClass!Collections-Support! !
!SymbolStringSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^(operand1 trueCompare: operand2) == 0
!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^operand hashCharacters! !
!SymbolStringSearchPolicy categoriesFor: #compare:with:!comparing!public! !
!SymbolStringSearchPolicy categoriesFor: #hash:!comparing!public! !

!SymbolStringSearchPolicy class methodsFor!

current
	"Answer the singleton instance of the receiver."

	Current isNil ifTrue: [Current := self new].
	^Current!

onPreStripImage
	"Private - Tidy up the receiver's lazily initialized class vars in preparation for image stripping."

	self uninitialize!

uninitialize
	"Private - Tidy up the receiver in preparation for removal from the system."

	Current := nil! !
!SymbolStringSearchPolicy class categoriesFor: #current!instance creation!public! !
!SymbolStringSearchPolicy class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!SymbolStringSearchPolicy class categoriesFor: #uninitialize!class hierarchy-removing!private! !

