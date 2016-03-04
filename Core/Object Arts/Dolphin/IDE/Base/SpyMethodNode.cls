"Filed out from Dolphin Smalltalk 7"!

StMethodNode subclass: #SpyMethodNode
	instanceVariableNames: 'methodSpies'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SpyMethodNode guid: (GUID fromString: '{90039801-3670-11D6-87E5-0010A70883E2}')!
SpyMethodNode comment: ''!
!SpyMethodNode categoriesForClass!Unclassified! !
!SpyMethodNode methodsFor!

formattedCode

	"Do not use formattedSource for a SpyMethod"

	^self source

!

formattedParseTree

	"Do not use formattedSource for a SpyMethod"

	^self

!

methodSpies

	"© 2002 Solutions Software"

	^methodSpies!

methodSpies: aCollection

	"© 2002 Solutions Software"

	methodSpies := aCollection! !
!SpyMethodNode categoriesFor: #formattedCode!accessing!public! !
!SpyMethodNode categoriesFor: #formattedParseTree!accessing!public! !
!SpyMethodNode categoriesFor: #methodSpies!accessing!public! !
!SpyMethodNode categoriesFor: #methodSpies:!accessing!public! !

!SpyMethodNode class methodsFor!

selectorParts: tokenCollection arguments: variableNodes 

	"Overriden to use the receiver class rather than hard-coded StMethodNode"

	^((tokenCollection detect: [:each | each isPatternVariable] ifNone: [nil]) 
		notNil ifTrue: [RBPatternMethodNode] ifFalse: [self]) 
		new selectorParts: tokenCollection arguments: variableNodes! !
!SpyMethodNode class categoriesFor: #selectorParts:arguments:!public! !

