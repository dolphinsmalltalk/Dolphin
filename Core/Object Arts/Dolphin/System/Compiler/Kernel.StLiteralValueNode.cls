"Filed out from Dolphin Smalltalk"!

Kernel.StLiteralNode
	subclass: #'Kernel.StLiteralValueNode'
	instanceVariableNames: 'token'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralValueNode guid: (Core.GUID fromString: '{93764089-2da7-47ec-8bee-95e969f27b94}')!
Kernel.StLiteralValueNode comment: ''!
!Kernel.StLiteralValueNode methodsFor!

= anObject
	^self == anObject or: 
			[self class == anObject class
				and: [self value = anObject value and: [self value species == anObject value species]]]!

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
!Kernel.StLiteralValueNode categoriesForMethods!
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

!Kernel.StLiteralValueNode class methodsFor!

literalToken: aLiteralToken 
	^(self new)
		literalToken: aLiteralToken;
		yourself!

value: aValue
	^self literalToken: (StLiteralToken value: aValue)! !
!Kernel.StLiteralValueNode class categoriesForMethods!
literalToken:!instance creation!public! !
value:!instance creation!public! !
!

