"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StLexicalScope
	instanceVariableNames: 'node outer temps argNames flags'
	classVariableNames: 'EmptyBlockMask FarReturnMask NeedsOuter NeedsSelfMask OptimizedBlockMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLexicalScope guid: (GUID fromString: '{cf1f5402-a16a-4f0c-8c08-630e2b5fbf47}')!
StLexicalScope addClassConstant: 'EmptyBlockMask' value: 2!
StLexicalScope addClassConstant: 'FarReturnMask' value: 8!
StLexicalScope addClassConstant: 'NeedsOuter' value: 16!
StLexicalScope addClassConstant: 'NeedsSelfMask' value: 1!
StLexicalScope addClassConstant: 'OptimizedBlockMask' value: 4!
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

needsSelf
	^flags anyMask: NeedsSelfMask!

needsSelf: aBoolean
	flags := flags mask: NeedsSelfMask set: aBoolean!

outer
	^outer!

referenceArg: aString 
	^(argNames includesKey: aString) and: [argNames at: aString put: true]!

refsToTemp: aString 
	^temps at: aString ifAbsent: []!

setNode: aBlockOrMethodNode outer: anStLexicalScope
	| argNodes referenced |
	node := aBlockOrMethodNode.
	outer := anStLexicalScope.
	temps := LookupTable new.
	argNodes := node arguments.
	argNames := LookupTable new: argNodes size.
	referenced := node isMethod and: [node isPrimitive].
	argNodes do: [:each | argNames at: each name put: referenced].
	flags := 0!

tempCount
	^temps size!

unreferencedArguments
	^node arguments reject: [:each | argNames at: each name]! !
!StLexicalScope categoriesFor: #addTemp:!public! !
!StLexicalScope categoriesFor: #argumentCount!accessing!public! !
!StLexicalScope categoriesFor: #includesArg:!public! !
!StLexicalScope categoriesFor: #includesTemp:!public! !
!StLexicalScope categoriesFor: #isInlined!accessing!public! !
!StLexicalScope categoriesFor: #needsSelf!accessing!public! !
!StLexicalScope categoriesFor: #needsSelf:!accessing!public! !
!StLexicalScope categoriesFor: #outer!accessing!public! !
!StLexicalScope categoriesFor: #referenceArg:!public! !
!StLexicalScope categoriesFor: #refsToTemp:!public! !
!StLexicalScope categoriesFor: #setNode:outer:!initializing!private! !
!StLexicalScope categoriesFor: #tempCount!public! !
!StLexicalScope categoriesFor: #unreferencedArguments!accessing!public! !

!StLexicalScope class methodsFor!

forScopeNode: aBlockOrMethodNode outer: anStLexicalScope
	^(self new)
		setNode: aBlockOrMethodNode outer: anStLexicalScope;
		yourself!

initialize
	self addClassConstant: 'NeedsSelfMask' value: 16r1.
	self addClassConstant: 'EmptyBlockMask' value: 16r2.
	self addClassConstant: 'OptimizedBlockMask' value: 16r4.
	self addClassConstant: 'FarReturnMask' value: 16r8.
	self addClassConstant: 'NeedsOuter' value: 16r10! !
!StLexicalScope class categoriesFor: #forScopeNode:outer:!public! !
!StLexicalScope class categoriesFor: #initialize!public! !

