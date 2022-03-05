"Filed out from Dolphin Smalltalk"!

StLexicalScope subclass: #StBlockScope
	instanceVariableNames: ''
	classVariableNames: 'EmptyBlockMask NeedsOuterMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StBlockScope guid: (GUID fromString: '{ee914772-f4ae-4569-87aa-95cdd445d7ef}')!
StBlockScope addClassConstant: 'EmptyBlockMask' value: 16r200!
StBlockScope addClassConstant: 'NeedsOuterMask' value: 16r100!
StBlockScope comment: ''!
!StBlockScope categoriesForClass!Kernel-Objects! !
!StBlockScope methodsFor!

isEmptyBlock
	^flags allMask: EmptyBlockMask!

markEmpty
	flags := flags maskSet: EmptyBlockMask!

needsOuter
	"Answer whether this scope accesses its enclosing lexical scope, either to write to
	temporary variables declared in enclosing scopes, or to read from temporary variables that
	are updated after a block (which is the physical manifestation of the scope) may have been
	captured. Note that accessing self or argument from outer scopes, or reading variables from
	outer scopes that are not later updated, does not imply a need for a reference to the
	enclosing scope as the values of these variables can be copied at the time the scope is
	reified into a block, i.e. a copying block. Some block scopes, generally those that are
	arguments to control messages (for conditionals or loops) are inlined into their enclosing
	scope, and so have no physical manifestation as an actual block. A ^-return (aka far return)
	from a block that is not inlined will always require a reference to the outer scope in order
	to escape from the method context active when the block was created."

	^flags anyMask: NeedsOuterMask! !
!StBlockScope categoriesForMethods!
isEmptyBlock!public! !
markEmpty!public! !
needsOuter!accessing!public! !
!

!StBlockScope class methodsFor!

forScopeNode: anStBlockNode outer: anStLexicalScope
	^((anStBlockNode isInlined ifTrue: [StOptimizedBlockScope] ifFalse: [self]) new)
		setNode: anStBlockNode outer: anStLexicalScope;
		yourself!

initialize
	self addClassConstant: 'NeedsOuterMask' value: 16r100.
	self addClassConstant: 'EmptyBlockMask' value: 16r200! !
!StBlockScope class categoriesForMethods!
forScopeNode:outer:!instance creation!public! !
initialize!class initialization!development!public! !
!

