"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueNode subclass: #'Kernel.StAbstractVariableNode'
	instanceVariableNames: 'start variable'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StAbstractVariableNode guid: (Core.GUID fromString: '{38ecca66-7d53-4b09-90f6-5c6f0e76ba79}')!
Kernel.StAbstractVariableNode isNonInstantiable: true!
Kernel.StAbstractVariableNode comment: 'StAbstrctVariableNode is an abstract parse tree node with subclasses to represent variable references and definitions.

Instance Variables:
	start		<Integer> start position of the variable in the source
	variable	A subtype of <StVariable> describing the type of variable that this node is referencing or defining. Only set if semantic analysis has been run.

'!
!Kernel.StAbstractVariableNode categoriesForClass!System-Compiler! !
!Kernel.StAbstractVariableNode methodsFor!

= anObject
	self == anObject ifTrue: [^true].
	(anObject isKindOf: StAbstractVariableNode) ifFalse: [^false].
	^self name = anObject name!

hash
	^self name hash!

isConstantNode
	"Answer whether the receiver describes a variable that cannot be assigned to (i.e. a constant)."

	^false!

isImmediateNode
	^true!

isVariable
	^true!

name
	^self subclassResponsibility!

needsParenthesis
	^false!

precedence
	^0!

setStart: anInteger
	start := anInteger!

startWithoutParentheses
	^start!

stopWithoutParentheses
	^start + self name size - 1!

variable
	^variable!

variable: anStVariable
	variable := anStVariable! !
!Kernel.StAbstractVariableNode categoriesFor: #=!comparing!public! !
!Kernel.StAbstractVariableNode categoriesFor: #hash!comparing!public! !
!Kernel.StAbstractVariableNode categoriesFor: #isConstantNode!public!testing! !
!Kernel.StAbstractVariableNode categoriesFor: #isImmediateNode!public!testing! !
!Kernel.StAbstractVariableNode categoriesFor: #isVariable!public!testing! !
!Kernel.StAbstractVariableNode categoriesFor: #name!constants!public! !
!Kernel.StAbstractVariableNode categoriesFor: #needsParenthesis!public!testing! !
!Kernel.StAbstractVariableNode categoriesFor: #precedence!accessing!public! !
!Kernel.StAbstractVariableNode categoriesFor: #setStart:!initializing!private! !
!Kernel.StAbstractVariableNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StAbstractVariableNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!Kernel.StAbstractVariableNode categoriesFor: #variable!accessing!public! !
!Kernel.StAbstractVariableNode categoriesFor: #variable:!accessing!public! !

!Kernel.StAbstractVariableNode class methodsFor!

identifierToken: anIdentifierToken
	^self named: anIdentifierToken value start: anIdentifierToken start!

named: aString
	^self named: aString start: 0!

named: aString start: anInteger
	aString = 'self' ifTrue: [^StSelfVariableNode start: anInteger].
	aString = 'super' ifTrue: [^StSuperVariableNode start: anInteger].
	aString = 'thisContext' ifTrue: [^StThisContextVariableNode start: anInteger].
	^self new
		setName: aString start: anInteger;
		yourself! !
!Kernel.StAbstractVariableNode class categoriesFor: #identifierToken:!instance creation!public! !
!Kernel.StAbstractVariableNode class categoriesFor: #named:!instance creation!public! !
!Kernel.StAbstractVariableNode class categoriesFor: #named:start:!instance creation!public! !

