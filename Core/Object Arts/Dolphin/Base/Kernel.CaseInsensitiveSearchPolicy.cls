"Filed out from Dolphin Smalltalk"!

Kernel.SingletonSearchPolicy
	subclass: #'Kernel.CaseInsensitiveSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CaseInsensitiveSearchPolicy guid: (Core.GUID fromString: '{46f9c2fc-d025-11d3-93da-00a024ca708a}')!
Kernel.CaseInsensitiveSearchPolicy comment: 'CaseInsensitiveSearchPolicy is for configuring pluggable collections and models of strings to use case-insensitive equality based search and comparisons, i.e. using `String>>#<=>` and the hash of the case-folded string. Note that these comparisons are linguistic, which makes this policy unsuitable for use with OS file names/paths, and other named OS objects, but more suitable for cases where language rules mean that two strings should be considered equal but they are not under ordinal case-insensitive comparison rules. For example under this policy the German double-s (eszett) is considered equivalent to ''ss''.

```
	SearchPolicy caseInsensitive compare: ''ß'' with: ''ss''. "=> true"
	(SearchPolicy caseInsensitive hash: ''ß'') = (SearchPolicy caseInsensitive hash: ''SS'') "=> true"
```

N.B. Unlike most other SearchPolicy classes, instances of this class are only appropriate for comparing and searching collections of strings, or objects which can be represented as strings (i.e. implementors of #asString).


'!
!Kernel.CaseInsensitiveSearchPolicy categoriesForClass!Collections-Support! !
!Kernel.CaseInsensitiveSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument, operand2, by this search policy."

	^operand1 asString <=> operand2 asString == 0!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^operand asString caseFolded hash!

keyAtValue: value in: collection ifAbsent: operation
	"Answer the <Object> key of the <Object> argument, value in the keyed
	collection, collection, using the receiver's search policy. If there is no such 
	value, answer the result of evaluating the <niladicValuable>, operation.
	The reverse mapping identity search operation is used: The collection argument
	must respond to #keysAndValuesDo: (there is no keyedCollection protocol
	defined at present)."

	| comparand |
	comparand := value asString.
	collection keysAndValuesDo: [:k :v | (self compare: v asString with: comparand) ifTrue: [^k]].
	^operation value!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^'caseInsensitive'! !
!Kernel.CaseInsensitiveSearchPolicy categoriesForMethods!
compare:with:!comparing!public! !
hash:!comparing!public! !
keyAtValue:in:ifAbsent:!public!searching! !
name!accessing!public! !
!

