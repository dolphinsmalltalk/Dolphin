"Filed out from Dolphin Smalltalk"!

StValueNode subclass: #StLiteralNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StLiteralNode guid: (GUID fromString: '{dad93c9c-b8b1-43b6-b9eb-dae76d502022}')!

StLiteralNode isAbstract: true!

StLiteralNode comment: 'StLiteralNode is a parse tree node that represents literals (e.g., #foo, #(1 2 3), true, etc.).

Instance Variables:
	token	<StLiteralToken> the token that contains the literal value as well as its source positions

'!

!StLiteralNode categoriesForClass!System-Compiler! !

!StLiteralNode methodsFor!

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

!StLiteralNode categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isImmediateNode!public!testing! !
isLiteralNode!public!testing! !
needsParenthesis!public!testing! !
precedence!accessing!public! !
value!accessing!public! !
valueClass!accessing!public! !
!

!StLiteralNode class methodsFor!

value: aValue
	^((aValue class == Array or: [aValue class == ByteArray])
		ifTrue: [StLiteralArrayNode]
		ifFalse: [StLiteralValueNode]) value: aValue! !

!StLiteralNode class categoriesForMethods!
value:!instance creation!public! !
!

