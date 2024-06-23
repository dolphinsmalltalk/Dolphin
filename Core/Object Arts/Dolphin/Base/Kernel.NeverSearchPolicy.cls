"Filed out from Dolphin Smalltalk"!

Kernel.SingletonSearchPolicy
	subclass: #'Kernel.NeverSearchPolicy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.NeverSearchPolicy guid: (Core.GUID fromString: '{f9b07491-78b3-4ef8-a7af-af9c2a556b1a}')!

Kernel.NeverSearchPolicy comment: ''!

!Kernel.NeverSearchPolicy categoriesForClass!Collections-Support! !

!Kernel.NeverSearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^false!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^'never'! !

!Kernel.NeverSearchPolicy categoriesForMethods!
compare:with:!comparing!public! !
name!accessing!public! !
!

