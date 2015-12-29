"Filed out from Dolphin Smalltalk X6"!

StValueNode subclass: #StVariableNode
	instanceVariableNames: 'token'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StVariableNode guid: (GUID fromString: '{B60D460E-99A6-4378-8B43-67B3BCB4CD16}')!
StVariableNode comment: 'StVariableNode is an parse tree node that represent a variable (global, inst var, temp, etc.).

Instance Variables:
	token	<StValueToken>	the token that contains our name and position

'!
!StVariableNode categoriesForClass!System-Compiler! !
!StVariableNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	self class = anObject class ifFalse: [^false].
	^self name = anObject name!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptVariableNode: self!

equalTo: anObject withMapping: aDictionary 
	^self class = anObject class and: 
			[(aDictionary at: self name ifAbsentPut: [anObject name]) = anObject name]!

hash
	^self name hash!

identifierToken: anIdentifierToken 
	token := anIdentifierToken!

isImmediateNode
	^true!

isVariable
	^true!

name
	^token value!

needsParenthesis
	^false!

precedence
	^0!

startWithoutParentheses
	^token start!

stopWithoutParentheses
	^token stop! !
!StVariableNode categoriesFor: #=!comparing!public! !
!StVariableNode categoriesFor: #acceptVisitor:!public!visitor! !
!StVariableNode categoriesFor: #equalTo:withMapping:!comparing!public! !
!StVariableNode categoriesFor: #hash!comparing!public! !
!StVariableNode categoriesFor: #identifierToken:!initializing!private! !
!StVariableNode categoriesFor: #isImmediateNode!public!testing! !
!StVariableNode categoriesFor: #isVariable!public!testing! !
!StVariableNode categoriesFor: #name!accessing!public! !
!StVariableNode categoriesFor: #needsParenthesis!public!testing! !
!StVariableNode categoriesFor: #precedence!accessing!public! !
!StVariableNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StVariableNode categoriesFor: #stopWithoutParentheses!accessing!public! !

!StVariableNode class methodsFor!

identifierToken: anIdentifierToken 
	^(self new)
		identifierToken: anIdentifierToken;
		yourself!

named: aString 
	^self identifierToken: (StIdentifierToken value: aString start: 0)! !
!StVariableNode class categoriesFor: #identifierToken:!instance creation!public! !
!StVariableNode class categoriesFor: #named:!instance creation!public! !

