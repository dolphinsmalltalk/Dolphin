"Filed out from Dolphin Smalltalk 7"!

StValueNode subclass: #StLiteralNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLiteralNode guid: (GUID fromString: '{dad93c9c-b8b1-43b6-b9eb-dae76d502022}')!
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
	^self subclassResponsibility! !
!StLiteralNode categoriesFor: #=!comparing!public! !
!StLiteralNode categoriesFor: #hash!comparing!public! !
!StLiteralNode categoriesFor: #isImmediateNode!public!testing! !
!StLiteralNode categoriesFor: #isLiteralNode!public!testing! !
!StLiteralNode categoriesFor: #needsParenthesis!public!testing! !
!StLiteralNode categoriesFor: #precedence!accessing!public! !
!StLiteralNode categoriesFor: #value!accessing!public! !

!StLiteralNode class methodsFor!

literalToken: aLiteralToken 
	^(aLiteralToken realValue class == Array or: [aLiteralToken realValue class == ByteArray]) 
		ifTrue: 
			[StLiteralArrayNode 
				startPosition: aLiteralToken start
				contents: (aLiteralToken value asArray collect: [:each | StLiteralNode literalToken: each])
				stopPosition: aLiteralToken stop
				isByteArray: aLiteralToken value class ~~ Array]
		ifFalse: [StLiteralValueNode literalToken: aLiteralToken]!

value: aValue 
	^((aValue class == Array or: [aValue class == ByteArray]) 
		ifTrue: [StLiteralArrayNode]
		ifFalse: [StLiteralValueNode]) value: aValue! !
!StLiteralNode class categoriesFor: #literalToken:!instance creation!public! !
!StLiteralNode class categoriesFor: #value:!instance creation!public! !

