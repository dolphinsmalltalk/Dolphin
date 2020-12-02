"Filed out from Dolphin Smalltalk 7"!

StSemanticScope subclass: #StLexicalScope
	instanceVariableNames: 'locals node thisContextVariable flags'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'FarReturnMask' -> 16r2.
		'NeedsSelfMask' -> 16r1
	}!
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

envTempCount
	"Answer the number of environment temporaries that will be required for this scope."

	^self locals count: [:var | var storage == #shared]!

hasFarReturn
	"Answer whether this scope contains a ^-return."

	^flags anyMask: FarReturnMask!

includesArg: aString
	| local |
	^(local := locals lookup: aString) notNil and: [local isArgument]!

includesLocal: aString
	^locals includesKey: aString!

includesTemp: aString
	| local |
	^(local := locals lookup: aString) notNil and: [local isTempVariable]!

initialize
	super initialize.
	locals := LookupTable new.
	flags := 0!

isInlined
	^node isInlined!

localCount
	^locals size!

locals
	^locals!

lookupVariable: anStVariableNode
	"Lookup and return an <StVariable> describing the variable definition in this scope matching
	the variable reference specified by the <StVariableNode> argument."

	anStVariableNode isSpecialVariable ifTrue: [^anStVariableNode specialVariableInScope: self].
	^(locals lookup: anStVariableNode name)
		ifNil: [outer ifNotNil: [outer lookupVariable: anStVariableNode]]!

markFarReturn
	"Mark this scope as containing a ^-return."

	flags := flags maskSet: FarReturnMask!

markNeedsSelf
	"Mark this scope as accessing self (or super)."

	flags := flags maskSet: NeedsSelfMask!

needsContext
	"Answer whether this scope requires a reified <Context> when physically activated. The
	context is needed to hold shared, closed-over, temporary variables defined in this scope,
	and/or to support ^-returns from blocks."

	^self hasFarReturn or: [self envTempCount > 0]!

needsSelf
	"Answer whether this scope access self (or super)."

	^flags anyMask: NeedsSelfMask!

node
	^node!

printOn: aPuttableStream
	self basicPrintOn: aPuttableStream.
	aPuttableStream
		nextPut: $(;
		print: node;
		nextPut: $)!

realScope
	"Answer the nearest real (non-optimized) scope. If the scope is itself unoptimized, then
	this will be the receiver. The actual scope is the scope in which any variables declared in
	the receiver will actually be allocated."

	^self!

setNode: aBlockOrMethodNode outer: anStLexicalScope
	node := aBlockOrMethodNode.
	outer := anStLexicalScope.
	self initialize!

temporaries
	^locals select: [:each | each isTempVariable]!

thisContextVariable
	^thisContextVariable
		ifNil: 
			[thisContextVariable := (StThisContextVariable new)
						scope: self;
						yourself]!

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
!StLexicalScope categoriesFor: #envTempCount!accessing!development!public! !
!StLexicalScope categoriesFor: #hasFarReturn!accessing!public! !
!StLexicalScope categoriesFor: #includesArg:!enquiries!public! !
!StLexicalScope categoriesFor: #includesLocal:!enquiries!public! !
!StLexicalScope categoriesFor: #includesTemp:!enquiries!public! !
!StLexicalScope categoriesFor: #initialize!initializing!private! !
!StLexicalScope categoriesFor: #isInlined!accessing!public! !
!StLexicalScope categoriesFor: #localCount!accessing!public! !
!StLexicalScope categoriesFor: #locals!accessing!public! !
!StLexicalScope categoriesFor: #lookupVariable:!operations!public! !
!StLexicalScope categoriesFor: #markFarReturn!public!visiting! !
!StLexicalScope categoriesFor: #markNeedsSelf!public!visiting! !
!StLexicalScope categoriesFor: #needsContext!accessing!public! !
!StLexicalScope categoriesFor: #needsSelf!accessing!public! !
!StLexicalScope categoriesFor: #node!accessing!public! !
!StLexicalScope categoriesFor: #printOn:!printing!public! !
!StLexicalScope categoriesFor: #realScope!public! !
!StLexicalScope categoriesFor: #setNode:outer:!initializing!private! !
!StLexicalScope categoriesFor: #temporaries!accessing!private! !
!StLexicalScope categoriesFor: #thisContextVariable!public! !
!StLexicalScope categoriesFor: #unreferencedArguments!accessing!public! !

