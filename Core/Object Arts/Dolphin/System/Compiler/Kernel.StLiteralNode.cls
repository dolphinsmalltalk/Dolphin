"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueNode subclass: #'Kernel.StLiteralNode'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralNode guid: (Core.GUID fromString: '{dad93c9c-b8b1-43b6-b9eb-dae76d502022}')!
Kernel.StLiteralNode isNonInstantiable: true!
Kernel.StLiteralNode comment: 'StLiteralNode is a parse tree node that represents literals (e.g., #foo, #(1 2 3), true, etc.).

Instance Variables:
	token	<StLiteralToken> the token that contains the literal value as well as its source positions

'!
!Kernel.StLiteralNode categoriesForClass!System-Compiler! !
!Kernel.StLiteralNode methodsFor!

= anObject 
	self == anObject ifTrue: [^true].
	^self class == anObject class!

hash
	^self value hash!

isImmediateNode
	^true!

isLiteralNode
	^true!

needsParenthesis
	^false!

precedence
	^0!

value
	^self subclassResponsibility!

valueClass
	^self subclassResponsibility! !
!Kernel.StLiteralNode categoriesFor: #=!comparing!public! !
!Kernel.StLiteralNode categoriesFor: #hash!comparing!public! !
!Kernel.StLiteralNode categoriesFor: #isImmediateNode!public!testing! !
!Kernel.StLiteralNode categoriesFor: #isLiteralNode!public!testing! !
!Kernel.StLiteralNode categoriesFor: #needsParenthesis!public!testing! !
!Kernel.StLiteralNode categoriesFor: #precedence!accessing!public! !
!Kernel.StLiteralNode categoriesFor: #value!accessing!public! !
!Kernel.StLiteralNode categoriesFor: #valueClass!accessing!public! !

!Kernel.StLiteralNode class methodsFor!

value: aValue
	^((aValue class == Array or: [aValue class == ByteArray])
		ifTrue: [StLiteralArrayNode]
		ifFalse: [StLiteralValueNode]) value: aValue! !
!Kernel.StLiteralNode class categoriesFor: #value:!instance creation!public! !

