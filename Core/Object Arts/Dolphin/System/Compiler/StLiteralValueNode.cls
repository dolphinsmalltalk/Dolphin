"Filed out from Dolphin Smalltalk"!

StLiteralNode subclass: #StLiteralValueNode
	instanceVariableNames: 'token'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!StLiteralValueNode categoriesForMethods!
=!comparing!public! !
acceptVisitor:!public!visitor! !
formattedCode!accessing!public! !
literalToken:!accessing!private! !
startWithoutParentheses!accessing!public! !
stopWithoutParentheses!accessing!public! !
token!accessing!public! !
value!accessing!public! !
valueClass!accessing!public! !
!

!StLiteralValueNode class methodsFor!

literalToken: aLiteralToken 
	^(self new)
		literalToken: aLiteralToken;
		yourself!

value: aValue 
	^self literalToken: (StLiteralToken value: aValue)! !

!StLiteralValueNode class categoriesForMethods!
literalToken:!instance creation!public! !
value:!instance creation!public! !
!

