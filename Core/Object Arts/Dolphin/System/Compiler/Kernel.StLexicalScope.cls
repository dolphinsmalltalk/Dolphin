"Filed out from Dolphin Smalltalk 7"!

Kernel.StSemanticScope subclass: #'Kernel.StLexicalScope'
	instanceVariableNames: 'locals node thisContextVariable flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'FarReturnMask' -> 16r2.
		'NeedsSelfMask' -> 16r1
	}!
Kernel.StLexicalScope guid: (Core.GUID fromString: '{cf1f5402-a16a-4f0c-8c08-630e2b5fbf47}')!
Kernel.StLexicalScope comment: ''!
!Kernel.StLexicalScope categoriesForClass!Kernel-Objects! !
!Kernel.StLexicalScope methodsFor!

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
			[thisContextVariable := StThisContextVariable new
						scope: self;
						yourself]!

unreferencedArguments
	^(node isMethod and: [node isPrimitive])
		ifTrue: 
			["All arguments to primitive methods are implicitly referenced"
			#()]
		ifFalse: [locals select: [:each | each isArgument and: [each isRead not]]]! !
!Kernel.StLexicalScope categoriesFor: #argumentCount!accessing!public! !
!Kernel.StLexicalScope categoriesFor: #declareArgument:!helpers!private! !
!Kernel.StLexicalScope categoriesFor: #declareLocalVariable:!helpers!private! !
!Kernel.StLexicalScope categoriesFor: #declareTemp:!helpers!private! !
!Kernel.StLexicalScope categoriesFor: #envTempCount!accessing!development!public! !
!Kernel.StLexicalScope categoriesFor: #hasFarReturn!accessing!public! !
!Kernel.StLexicalScope categoriesFor: #includesArg:!enquiries!public! !
!Kernel.StLexicalScope categoriesFor: #includesLocal:!enquiries!public! !
!Kernel.StLexicalScope categoriesFor: #includesTemp:!enquiries!public! !
!Kernel.StLexicalScope categoriesFor: #initialize!initializing!private! !
!Kernel.StLexicalScope categoriesFor: #isInlined!accessing!public! !
!Kernel.StLexicalScope categoriesFor: #localCount!accessing!public! !
!Kernel.StLexicalScope categoriesFor: #locals!accessing!public! !
!Kernel.StLexicalScope categoriesFor: #lookupVariable:!operations!public! !
!Kernel.StLexicalScope categoriesFor: #markFarReturn!public!visiting! !
!Kernel.StLexicalScope categoriesFor: #markNeedsSelf!public!visiting! !
!Kernel.StLexicalScope categoriesFor: #needsContext!accessing!public! !
!Kernel.StLexicalScope categoriesFor: #needsSelf!accessing!public! !
!Kernel.StLexicalScope categoriesFor: #node!accessing!public! !
!Kernel.StLexicalScope categoriesFor: #printOn:!printing!public! !
!Kernel.StLexicalScope categoriesFor: #realScope!public! !
!Kernel.StLexicalScope categoriesFor: #setNode:outer:!initializing!private! !
!Kernel.StLexicalScope categoriesFor: #temporaries!accessing!private! !
!Kernel.StLexicalScope categoriesFor: #thisContextVariable!public! !
!Kernel.StLexicalScope categoriesFor: #unreferencedArguments!accessing!public! !

