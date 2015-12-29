"Filed out from Dolphin Smalltalk X6"!

StLiteralNode subclass: #StLiteralValueNode
	instanceVariableNames: 'token'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLiteralValueNode guid: (GUID fromString: '{93764089-2DA7-47EC-8BEE-95E969F27B94}')!
StLiteralValueNode comment: ''!
!StLiteralValueNode categoriesForClass!Unclassified! !
!StLiteralValueNode methodsFor!

= anObject 
	^super = anObject and: 
			[self value = anObject value 
				and: [self value species == anObject value species]]!

acceptVisitor: aProgramNodeVisitor 
	^aProgramNodeVisitor acceptLiteralNode: self!

literalToken: aLiteralToken 
	token := aLiteralToken!

startWithoutParentheses
	^token start!

stopWithoutParentheses
	^token stop!

token
	^token!

value
	^token realValue! !
!StLiteralValueNode categoriesFor: #=!comparing!public! !
!StLiteralValueNode categoriesFor: #acceptVisitor:!public!visitor! !
!StLiteralValueNode categoriesFor: #literalToken:!accessing!private! !
!StLiteralValueNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StLiteralValueNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StLiteralValueNode categoriesFor: #token!accessing!public! !
!StLiteralValueNode categoriesFor: #value!accessing!public! !

!StLiteralValueNode class methodsFor!

literalToken: aLiteralToken 
	^(self new)
		literalToken: aLiteralToken;
		yourself!

value: aValue 
	^self literalToken: (StLiteralToken value: aValue)! !
!StLiteralValueNode class categoriesFor: #literalToken:!instance creation!public! !
!StLiteralValueNode class categoriesFor: #value:!instance creation!public! !

