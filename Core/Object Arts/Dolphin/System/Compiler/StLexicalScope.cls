"Filed out from Dolphin Smalltalk 7"!

StSemanticScope subclass: #StLexicalScope
	instanceVariableNames: 'locals node'
	classVariableNames: 'NeedsSelfMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLexicalScope guid: (GUID fromString: '{cf1f5402-a16a-4f0c-8c08-630e2b5fbf47}')!
StLexicalScope comment: ''!
!StLexicalScope categoriesForClass!Kernel-Objects! !
!StLexicalScope methodsFor!

argumentCount
	^node argumentCount!

declareArgument: aString
	self declareLocalVariable: (StArgumentVariable node: aString)!

declareLocalVariable: anStLocalVariable
	locals at: anStLocalVariable name
		put: (anStLocalVariable
				scope: self;
				yourself)!

declareTemp: aString
	self declareLocalVariable: (StTempVariable node: aString)!

includesArg: aString
	| local |
	^(local := locals at: aString ifAbsent: []) notNil and: [local isArgument]!

includesLocal: aString
	^locals includesKey: aString!

includesTemp: aString
	| local |
	^(local := locals at: aString ifAbsent: []) notNil and: [local isTempVariable]!

initialize
	super initialize.
	locals := LookupTable new!

isInlined
	^node isInlined!

localCount
	^locals size!

lookupVariable: aString
	^locals at: aString ifAbsent: [outer ifNotNil: [outer lookupVariable: aString]]!

needsSelf
	^flags anyMask: NeedsSelfMask!

needsSelf: aBoolean
	flags := flags mask: NeedsSelfMask set: aBoolean!

node
	^node!

printOn: aPuttableStream
	self basicPrintOn: aPuttableStream.
	aPuttableStream
		nextPut: $(;
		print: node;
		nextPut: $)!

setNode: aBlockOrMethodNode outer: anStLexicalScope
	node := aBlockOrMethodNode.
	outer := anStLexicalScope.
	self initialize!

temporaries
	^locals select: [:each | each isTempVariable]!

unreferencedArguments
	^(node isMethod and: [node isPrimitive])
		ifTrue: 
			["All arguments to primitive methods are implicitly referenced"
			#()]
		ifFalse: [locals select: [:each | each isArgument and: [each isRead not]]]! !
!StLexicalScope categoriesFor: #argumentCount!accessing!public! !
!StLexicalScope categoriesFor: #declareArgument:!helpers!private! !
!StLexicalScope categoriesFor: #declareLocalVariable:!helpers!private! !
!StLexicalScope categoriesFor: #declareTemp:!helpers!private! !
!StLexicalScope categoriesFor: #includesArg:!enquiries!public! !
!StLexicalScope categoriesFor: #includesLocal:!enquiries!public! !
!StLexicalScope categoriesFor: #includesTemp:!enquiries!public! !
!StLexicalScope categoriesFor: #initialize!initializing!private! !
!StLexicalScope categoriesFor: #isInlined!accessing!public! !
!StLexicalScope categoriesFor: #localCount!accessing!public! !
!StLexicalScope categoriesFor: #lookupVariable:!operations!public! !
!StLexicalScope categoriesFor: #needsSelf!accessing!public! !
!StLexicalScope categoriesFor: #needsSelf:!accessing!public! !
!StLexicalScope categoriesFor: #node!accessing!public! !
!StLexicalScope categoriesFor: #printOn:!printing!public! !
!StLexicalScope categoriesFor: #setNode:outer:!initializing!private! !
!StLexicalScope categoriesFor: #temporaries!accessing!private! !
!StLexicalScope categoriesFor: #unreferencedArguments!accessing!public! !

!StLexicalScope class methodsFor!

forScopeNode: aBlockOrMethodNode outer: anStLexicalScope
	^(self new)
		setNode: aBlockOrMethodNode outer: anStLexicalScope;
		yourself!

initialize
	self addClassConstant: 'NeedsSelfMask' value: 16r1! !
!StLexicalScope class categoriesFor: #forScopeNode:outer:!instance creation!public! !
!StLexicalScope class categoriesFor: #initialize!class initialization!public! !

