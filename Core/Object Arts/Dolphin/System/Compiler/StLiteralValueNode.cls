"Filed out from Dolphin Smalltalk 7"!

StLiteralNode subclass: #StLiteralValueNode
	instanceVariableNames: 'token'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StLiteralValueNode guid: (GUID fromString: '{93764089-2da7-47ec-8bee-95e969f27b94}')!
StLiteralValueNode comment: ''!
!StLiteralValueNode categoriesForClass!Unclassified! !
!StLiteralValueNode methodsFor!

= anObject 
	^super = anObject and: 
			[self value = anObject value 
				and: [self value species == anObject value species]]!

acceptVisitor: aProgramNodeVisitor
	^aProgramNodeVisitor visitLiteralNode: self!

formattedCode
	^self token formattedFrom: self source!

literalToken: aLiteralToken 
	token := aLiteralToken!

startWithoutParentheses
	^token start!

stopWithoutParentheses
	^token stop!

token
	^token!

value
	^token realValue!

valueClass
	^token value class! !
!StLiteralValueNode categoriesFor: #=!comparing!public! !
!StLiteralValueNode categoriesFor: #acceptVisitor:!public!visitor! !
!StLiteralValueNode categoriesFor: #formattedCode!accessing!public! !
!StLiteralValueNode categoriesFor: #literalToken:!accessing!private! !
!StLiteralValueNode categoriesFor: #startWithoutParentheses!accessing!public! !
!StLiteralValueNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!StLiteralValueNode categoriesFor: #token!accessing!public! !
!StLiteralValueNode categoriesFor: #value!accessing!public! !
!StLiteralValueNode categoriesFor: #valueClass!accessing!public! !

!StLiteralValueNode class methodsFor!

literalToken: aLiteralToken 
	^(self new)
		literalToken: aLiteralToken;
		yourself!

value: aValue 
	^self literalToken: (StLiteralToken value: aValue)! !
!StLiteralValueNode class categoriesFor: #literalToken:!instance creation!public! !
!StLiteralValueNode class categoriesFor: #value:!instance creation!public! !

