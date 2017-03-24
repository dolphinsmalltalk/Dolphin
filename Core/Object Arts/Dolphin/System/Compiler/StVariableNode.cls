"Filed out from Dolphin Smalltalk 7"!

StValueNode subclass: #StVariableNode
	instanceVariableNames: 'name start'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StVariableNode guid: (GUID fromString: '{b60d460e-99a6-4378-8b43-67b3bcb4cd16}')!
StVariableNode comment: 'StVariableNode is an parse tree node that represent a variable (global, inst var, temp, etc.).

Instance Variables:
	token	<StValueToken>	the token that contains our name and position

'!
!StVariableNode categoriesForClass!System-Compiler! !
!StVariableNode methodsFor!

= anObject
	self == anObject ifTrue: [^true].
	(anObject isKindOf: StVariableNode) ifFalse: [^false].
	^self name = anObject name!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitVariableNode: self!

equalTo: anObject withMapping: aDictionary 
	^self class = anObject class and: 
			[(aDictionary at: self name ifAbsentPut: [anObject name]) = anObject name]!

hash
	^self name hash!

identifierToken: anIdentifierToken
	name := anIdentifierToken value.
	start := anIdentifierToken start!

isConstantNode
	"Answer whether the receiver describes a variable that cannot be assigned to (i.e. a constant)."

	^false!

isImmediateNode
	^true!

isPseudoVariableNode
	"Answer whether the receiver describes a pseudo-variable such as 'self' or 'super'."

	^false!

isVariable
	^true!

name
	^name!

name: aString start: anInteger
	name := aString.
	start := anInteger!

needsParenthesis
	^false!

precedence
	^0!

startWithoutParentheses
	^start!

stopWithoutParentheses
	^start + name size - 1! !
!StVariableNode categoriesFor: #=!comparing!public! !
!StVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!StVariableNode categoriesFor: #equalTo:withMapping:!comparing!public! !
!StVariableNode categoriesFor: #hash!comparing!public! !
!StVariableNode categoriesFor: #identifierToken:!initializing!private! !
!StVariableNode categoriesFor: #isConstantNode!public!testing! !
!StVariableNode categoriesFor: #isImmediateNode!public!testing! !
!StVariableNode categoriesFor: #isPseudoVariableNode!public!testing! !
!StVariableNode categoriesFor: #isVariable!public!testing! !
!StVariableNode categoriesFor: #name!accessing!public! !
!StVariableNode categoriesFor: #name:start:!initializing!private! !
!StVariableNode categoriesFor: #needsParenthesis!public!testing! !
!StVariableNode categoriesFor: #precedence!accessing!public! !
!StVariableNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StVariableNode categoriesFor: #stopWithoutParentheses!accessing!public! !

!StVariableNode class methodsFor!

identifierToken: anIdentifierToken
	^self named: anIdentifierToken value start: anIdentifierToken start!

named: aString
	^self named: aString start: 0!

named: aString start: anInteger
	^(((aString = 'self' or: [aString = 'super' or: [aString = 'thisContext']])
		ifTrue: [StPseudoVariableNode]
		ifFalse: [self]) new)
		name: aString start: anInteger;
		yourself! !
!StVariableNode class categoriesFor: #identifierToken:!instance creation!public! !
!StVariableNode class categoriesFor: #named:!instance creation!public! !
!StVariableNode class categoriesFor: #named:start:!instance creation!public! !

