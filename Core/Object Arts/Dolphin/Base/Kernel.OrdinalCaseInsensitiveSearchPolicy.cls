"Filed out from Dolphin Smalltalk"!

Kernel.SingletonSearchPolicy
	subclass: #'Kernel.OrdinalCaseInsensitiveSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.OrdinalCaseInsensitiveSearchPolicy guid: (Core.GUID fromString: '{9a377dae-be71-4f53-a2c3-98513799332c}')!
Kernel.OrdinalCaseInsensitiveSearchPolicy comment: '`OrdinalCaseInsensitiveSearchPolicy` is for configuring pluggable collections and models of strings to use ordinal case-insensitive equality based search and comparisons, i.e. using `String>>#compareOrdinals:ignoringCase:` and `String>>#hashOrdinalsIgnoringCase`. Note that these comparisons are not linguistic (but see also `CaseInsensitiveSearchPolicy`), which makes this policy suitable for use with OS file names/paths, and other named OS objects, but it may not be suitable for cases where language rules mean that two strings should be considered equal but they are not under ordinal case-insensitive comparison rules. For example under this policy the German double-s (eszett) is never considered equivalent to ''ss''.

```
	SearchPolicy ordinalCaseInsensitive compare: ''ß'' with: ''ss''. "=> false"
	(SearchPolicy ordinalCaseInsensitive hash: ''ß'') = (SearchPolicy ordinalCaseInsensitive hash: ''SS'') "=> false"
```

N.B. Unlike most other SearchPolicy classes, instances of this class are only appropriate for comparing and searching collections of strings, or objects which can be represented as strings (i.e. implementors of `#asString`).

'!
!Kernel.OrdinalCaseInsensitiveSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument, operand2, by this search policy."

	"Note that this is an ordinal case-insensitive comparison, not a linguistic one, and hence uses String>>#compareOrdinals:ignoringCase:, rather than the spaceship operator, String>>#<=>."

	^(operand1 asString compareOrdinals: operand2 asString ignoringCase: true) == 0!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^operand asString hashOrdinalsIgnoringCase!

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

	^'ordinalCaseInsensitive'! !
!Kernel.OrdinalCaseInsensitiveSearchPolicy categoriesForMethods!
compare:with:!comparing!public! !
hash:!comparing!public! !
keyAtValue:in:ifAbsent:!public!searching! !
name!accessing!public! !
!

