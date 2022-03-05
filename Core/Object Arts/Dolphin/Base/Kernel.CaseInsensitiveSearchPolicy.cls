"Filed out from Dolphin Smalltalk"!

Kernel.SingletonSearchPolicy subclass: #'Kernel.CaseInsensitiveSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.CaseInsensitiveSearchPolicy guid: (Core.GUID fromString: '{46f9c2fc-d025-11d3-93da-00a024ca708a}')!
Kernel.CaseInsensitiveSearchPolicy comment: 'CaseInsensitiveSearchPolicy is for configuring pluggable collections and models of strings to use case-insensitive equality based search and comparisons, i.e. using #equalsIgnoreCase: and the #hashIgnoreCase: of the string. Note that these comparisons are not linguistic (i.e. it is ordinal case-insensitive), which makes this policy suitable for use with OS file names/paths, and other named OS objects, but it may not be suitable for cases where language rules mean that two strings should be considered equal but they are not under ordinal case-insensitive comparison rules. For example if the user''s default locale is ''tr-Tr'', then ''i'' is not equivalent to ''I'' ignoring case following linguistic rules, but would always be considered so by this search policy.

```
	SearchPolicy caseInsensitive compare: ''i'' with: ''I''.	"=> true"
	SearchPolicy caseInsensitive compare: ((Locale named: ''tr-Tr'')  uppercaseString: ''i'') with: ''I''.	"=> false"
```

N.B. Unlike other SearchPolicy classes, instances of this class are only appropriate for comparing and searching collections of strings, or objects which can be represented as strings (i.e. implementors of #asString).


'!
!Kernel.CaseInsensitiveSearchPolicy categoriesForClass!Collections-Support! !
!Kernel.CaseInsensitiveSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument, operand2, by this search policy."

	"Note that this is an ordinal case-insensitive comparison, not a linguistic one, and hence uses String>>#equalsIgnoreCase:, rather than the spaceship operator, String>>#<=>."

	^operand1 asString equalsIgnoreCase: operand2 asString!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^operand asString hashIgnoreCase!

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

