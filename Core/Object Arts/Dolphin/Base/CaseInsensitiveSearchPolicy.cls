"Filed out from Dolphin Smalltalk X6"!

SingletonSearchPolicy subclass: #CaseInsensitiveSearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CaseInsensitiveSearchPolicy guid: (GUID fromString: '{46F9C2FC-D025-11D3-93DA-00A024CA708A}')!
CaseInsensitiveSearchPolicy comment: 'CaseInsensitiveSearchPolicy is for configuring pluggable collections and models of strings to use case-insensitive equality based search and comparisons, i.e. using #sameAs: and the #hash of the lowercased equivalent of the string.

N.B. Unlike other SearchPolicy classes, instances of this class are only appropriate for comparing and searching collections of strings, or objects which can be represented as strings (i.e. implementors of #asString).
'!
!CaseInsensitiveSearchPolicy categoriesForClass!Collections-Support! !
!CaseInsensitiveSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^operand1 asString sameAs: operand2 asString!

hash: operand
	"Answer a suitable hash value for the <Object>, operand, under this search policy."

	^operand asString asLowercase hash!

keyAtValue: value in: collection ifAbsent: operation
	"Answer the <Object> key of the <Object> argument, value in the keyed
	collection, collection, using the receiver's search policy. If there is no such 
	value, answer the result of evaluating the <niladicValuable>, operation.
	The reverse mapping identity search operation is used: The collection argument
	must respond to #keysAndValuesDo: (there is no keyedCollection protocol
	defined at present)."

	| comperand |
	comperand := value asString.
	collection keysAndValuesDo: [:k :v | (self compare: v asString with: comperand) ifTrue: [^k]].
	^operation value
! !
!CaseInsensitiveSearchPolicy categoriesFor: #compare:with:!comparing!public! !
!CaseInsensitiveSearchPolicy categoriesFor: #hash:!comparing!public! !
!CaseInsensitiveSearchPolicy categoriesFor: #keyAtValue:in:ifAbsent:!public!searching! !

!CaseInsensitiveSearchPolicy class methodsFor!

current
	"Answer the singleton instance of the receiver."

	^self caseInsensitive! !
!CaseInsensitiveSearchPolicy class categoriesFor: #current!instance creation!public! !

