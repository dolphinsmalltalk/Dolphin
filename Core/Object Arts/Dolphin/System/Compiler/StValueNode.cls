"Filed out from Dolphin Smalltalk 7"!

StProgramNode subclass: #StValueNode
	instanceVariableNames: 'parentheses'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StValueNode guid: (GUID fromString: '{644cb929-df4a-4cb9-bd37-42ab7b46490f}')!
StValueNode isAbstract: true!
StValueNode comment: 'StValueNode is an abstract class to represent parse tree nodes that return some value.

Instance Variables:
	parentheses	<SequenceableCollection> of <Inteval>	the positions of the parethesis around this node. We need a collection of intervals for stupid code such as "((3 + 4))" that has multiple parethesis around the same expression.

'!
!StValueNode categoriesForClass!System-Compiler! !
!StValueNode methodsFor!

addParenthesis: anInterval 
	parentheses isNil ifTrue: [parentheses := OrderedCollection new: 1].
	parentheses add: anInterval!

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
!StValueNode categoriesFor: #addParenthesis:!accessing!public! !
!StValueNode categoriesFor: #containedBy:!public!testing! !
!StValueNode categoriesFor: #hasParentheses!public!testing! !
!StValueNode categoriesFor: #isValue!public!testing! !
!StValueNode categoriesFor: #needsParenthesis!public!testing! !
!StValueNode categoriesFor: #parentheses!accessing!public! !
!StValueNode categoriesFor: #start!accessing!public! !
!StValueNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StValueNode categoriesFor: #stop!accessing!public! !
!StValueNode categoriesFor: #stopWithoutParentheses!accessing!public! !

