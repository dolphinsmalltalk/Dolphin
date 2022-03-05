"Filed out from Dolphin Smalltalk"!

StValueNode subclass: #StAbstractVariableNode
	instanceVariableNames: 'start variable'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StAbstractVariableNode guid: (GUID fromString: '{38ecca66-7d53-4b09-90f6-5c6f0e76ba79}')!
StAbstractVariableNode isAbstract: true!
StAbstractVariableNode comment: 'StAbstrctVariableNode is an abstract parse tree node with subclasses to represent variable references and definitions.

Instance Variables:
	start		<Integer> start position of the variable in the source
	variable	A subtype of <StVariable> describing the type of variable that this node is referencing or defining. Only set if semantic analysis has been run.

'!
!StAbstractVariableNode categoriesForClass!System-Compiler! !
!StAbstractVariableNode methodsFor!

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
!StAbstractVariableNode categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isConstantNode!public!testing! !
isImmediateNode!public!testing! !
isVariable!public!testing! !
name!constants!public! !
needsParenthesis!public!testing! !
precedence!accessing!public! !
setStart:!initializing!private! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
variable!accessing!public! !
variable:!accessing!public! !
!

!StAbstractVariableNode class methodsFor!

identifierToken: anIdentifierToken
	^self named: anIdentifierToken value start: anIdentifierToken start!

named: aString
	^self named: aString start: 0!

named: aString start: anInteger
	aString = 'self' ifTrue: [^StSelfVariableNode start: anInteger].
	aString = 'super' ifTrue: [^StSuperVariableNode start: anInteger].
	aString = 'thisContext' ifTrue: [^StThisContextVariableNode start: anInteger].
	^(self new)
		setName: aString start: anInteger;
		yourself! !
!StAbstractVariableNode class categoriesForMethods!
identifierToken:!instance creation!public! !
named:!instance creation!public! !
named:start:!instance creation!public! !
!

