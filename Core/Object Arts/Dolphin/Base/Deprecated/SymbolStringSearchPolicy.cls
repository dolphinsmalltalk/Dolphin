"Filed out from Dolphin Smalltalk 7"!

SingletonSearchPolicy subclass: #SymbolStringSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SymbolStringSearchPolicy guid: (GUID fromString: '{ea77cbf2-0cbb-4fbe-ac7b-a9ac258f1d4a}')!
SymbolStringSearchPolicy comment: 'SymbolStringSearchPolicy is for configuring pluggable collections and models of <String>s or <Symbol>s such that the same sequence of characters compare as equal, regardless of whether the sequence is stored in a Symbol or a String. Normally Symbols are not considered equal to Strings even when they contain the same characters.

N.B. Unlike most other SearchPolicy classes, instances of this class are only appropriate for comparing and searching collections of Symbols and Strings (the objects to be compared must implement #hashCharacters and #trueCompare:).'!
!SymbolStringSearchPolicy categoriesForClass!Deprecated! !
!SymbolStringSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^(operand1 <==> operand2) == 0
!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^operand hash! !
!SymbolStringSearchPolicy categoriesFor: #compare:with:!comparing!public! !
!SymbolStringSearchPolicy categoriesFor: #hash:!comparing!public! !

