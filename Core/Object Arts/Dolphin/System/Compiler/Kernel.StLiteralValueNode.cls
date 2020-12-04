"Filed out from Dolphin Smalltalk 7"!

Kernel.StLiteralNode subclass: #'Kernel.StLiteralValueNode'
	instanceVariableNames: 'token'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralValueNode guid: (Core.GUID fromString: '{93764089-2da7-47ec-8bee-95e969f27b94}')!
Kernel.StLiteralValueNode comment: ''!
!Kernel.StLiteralValueNode categoriesForClass!Unclassified! !
!Kernel.StLiteralValueNode methodsFor!

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
!Kernel.StLiteralValueNode categoriesFor: #=!comparing!public! !
!Kernel.StLiteralValueNode categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StLiteralValueNode categoriesFor: #formattedCode!accessing!public! !
!Kernel.StLiteralValueNode categoriesFor: #literalToken:!accessing!private! !
!Kernel.StLiteralValueNode categoriesFor: #startWithoutParentheses!accessing!public! !
!Kernel.StLiteralValueNode categoriesFor: #stopWithoutParentheses!accessing!public! !
!Kernel.StLiteralValueNode categoriesFor: #token!accessing!public! !
!Kernel.StLiteralValueNode categoriesFor: #value!accessing!public! !
!Kernel.StLiteralValueNode categoriesFor: #valueClass!accessing!public! !

!Kernel.StLiteralValueNode class methodsFor!

literalToken: aLiteralToken 
	^(self new)
		literalToken: aLiteralToken;
		yourself!

value: aValue
	^self literalToken: (StLiteralToken value: aValue)! !
!Kernel.StLiteralValueNode class categoriesFor: #literalToken:!instance creation!public! !
!Kernel.StLiteralValueNode class categoriesFor: #value:!instance creation!public! !

