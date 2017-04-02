"Filed out from Dolphin Smalltalk 7"!

StSpecialVariableNode subclass: #StSelfVariableNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSelfVariableNode guid: (GUID fromString: '{29220d9b-e07e-475a-95e2-b31f4bf41079}')!
StSelfVariableNode comment: 'StSelfVariableNode is an parse tree node that represents the special variable ''self''.
'!
!StSelfVariableNode categoriesForClass!System-Compiler! !
!StSelfVariableNode methodsFor!

name
	^'self'!

specialVariableInScope: anStSemanticScope
	^anStSemanticScope selfVariable! !
!StSelfVariableNode categoriesFor: #name!constants!public! !
!StSelfVariableNode categoriesFor: #specialVariableInScope:!double dispatch!public! !

