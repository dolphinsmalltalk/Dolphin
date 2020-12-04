"Filed out from Dolphin Smalltalk 7"!

Kernel.StProgramNode subclass: #'Kernel.StValueNode'
	instanceVariableNames: 'parentheses'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StValueNode guid: (Core.GUID fromString: '{644cb929-df4a-4cb9-bd37-42ab7b46490f}')!
Kernel.StValueNode isNonInstantiable: true!
Kernel.StValueNode comment: 'StValueNode is an abstract class to represent parse tree nodes that return some value.

Instance Variables:
	parentheses	<SequenceableCollection> of <Inteval>	the positions of the parethesis around this node. We need a collection of intervals for stupid code such as "((3 + 4))" that has multiple parethesis around the same expression.

'!
!Kernel.StValueNode categoriesForClass!System-Compiler! !
!Kernel.StValueNode methodsFor!

addParenthesis: anInterval
	(parentheses ifNil: [parentheses := OrderedCollection new: 1]) addLast: anInterval!

containedBy: anInterval 
	^anInterval first <= self startWithoutParentheses 
		and: [anInterval last >= self stopWithoutParentheses]!

hasParentheses
	^self parentheses notEmpty!

isValue
	^true!

needsParenthesis
	^self subclassResponsibility!

parentheses
	^parentheses ?? #()!

start
	^parentheses isNil 
		ifTrue: [self startWithoutParentheses]
		ifFalse: [parentheses last first]!

startWithoutParentheses
	^self subclassResponsibility!

stop
	^parentheses isNil
		ifTrue: [self stopWithoutParentheses]
		ifFalse: [parentheses last last]!

stopWithoutParentheses
	^self subclassResponsibility! !
!Kernel.StValueNode categoriesFor: #addParenthesis:!accessing!public! !
!Kernel.StValueNode categoriesFor: #containedBy:!public!testing! !
!Kernel.StValueNode categoriesFor: #hasParentheses!public!testing! !
!Kernel.StValueNode categoriesFor: #isValue!public!testing! !
!Kernel.StValueNode categoriesFor: #needsParenthesis!public!testing! !
!Kernel.StValueNode categoriesFor: #parentheses!accessing!public! !
!Kernel.StValueNode categoriesFor: #start!accessing!public! !
!Kernel.StValueNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StValueNode categoriesFor: #stop!accessing!public! !
!Kernel.StValueNode categoriesFor: #stopWithoutParentheses!accessing!public! !

