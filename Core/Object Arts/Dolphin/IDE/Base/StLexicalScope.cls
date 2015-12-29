"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #StLexicalScope
	instanceVariableNames: 'node temps argNames'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLexicalScope guid: (GUID fromString: '{CF1F5402-A16A-4F0C-8C08-630E2B5FBF47}')!
StLexicalScope comment: ''!
!StLexicalScope categoriesForClass!Kernel-Objects! !
!StLexicalScope methodsFor!

addTemp: aString
	temps at: aString put: (Array with: nil with: nil)!

argumentCount
	^node argumentCount!

includesArg: aString 
	^argNames includesKey: aString!

includesTemp: aString 
	^temps includesKey: aString!

isInlined
	^node isInlined!

referenceArg: aString 
	^(argNames includesKey: aString) and: [argNames at: aString put: true]!

refsToTemp: aString 
	^temps at: aString ifAbsent: []!

setNode: aBlockOrMethodNode 
	| argNodes referenced |
	node := aBlockOrMethodNode.
	temps := LookupTable new.
	argNodes := node arguments.
	argNames := LookupTable new: argNodes size.
	referenced := node isMethod and: [node isPrimitive].
	argNodes do: [:each | argNames at: each name put: referenced]!

tempCount
	^temps size!

unreferencedArguments
	^node arguments reject: [:each | argNames at: each name]! !
!StLexicalScope categoriesFor: #addTemp:!public! !
!StLexicalScope categoriesFor: #argumentCount!accessing!public! !
!StLexicalScope categoriesFor: #includesArg:!public! !
!StLexicalScope categoriesFor: #includesTemp:!public! !
!StLexicalScope categoriesFor: #isInlined!accessing!public! !
!StLexicalScope categoriesFor: #referenceArg:!public! !
!StLexicalScope categoriesFor: #refsToTemp:!public! !
!StLexicalScope categoriesFor: #setNode:!initializing!private! !
!StLexicalScope categoriesFor: #tempCount!public! !
!StLexicalScope categoriesFor: #unreferencedArguments!accessing!public! !

!StLexicalScope class methodsFor!

forScopeNode: aBlockOrMethodNode 
	^(self new)
		setNode: aBlockOrMethodNode;
		yourself! !
!StLexicalScope class categoriesFor: #forScopeNode:!public! !

