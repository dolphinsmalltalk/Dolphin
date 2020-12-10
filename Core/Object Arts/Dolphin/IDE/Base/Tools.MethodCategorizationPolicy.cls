"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.MethodCategorizationPolicy'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MethodCategorizationPolicy guid: (Core.GUID fromString: '{87b4c4a1-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.MethodCategorizationPolicy comment: ''!
!Tools.MethodCategorizationPolicy categoriesForClass!System-Support! !
!Tools.MethodCategorizationPolicy methodsFor!

allCategoriesOfSelector: selector
	"Private - Answer a <Collection> of all the <methodCategory>s in which
	the selector <Symbol>, selector, currently appears."

	| answer |
	answer := IdentitySet new.
	Smalltalk allBehaviorsDo: 
			[:c |
			| method |
			method := c compiledMethodAt: selector ifAbsent: [].
			method notNil ifTrue: [answer addAll: (c categoriesOfMethod: method)]].
	^answer!

bestSuggestionFor: aCompiledMethod
	"Answer the best suggestion for a category into which aCompiledMethod should be placed"

	^(self suggestionsFor: aCompiledMethod) first!

couldBeAccessor: aCompiledMethod 
	"Private - Answer whether the argument might possibly be an accessor method 
	for its method class."

	| selector |
	selector := aCompiledMethod selector.
	^selector argumentCount <= 1 and: 
			[| name |
			name := selector last = $: ifTrue: [selector allButLast] ifFalse: [selector asString].
			(aCompiledMethod methodClass instVarNames detect: [:each | each = name] ifNone: []) 
				notNil]!

couldBeInitializer: aCompiledMethod 
	"Private - Answer whether the argument might possibly be an initialization method."

	| selector |
	selector := aCompiledMethod selector.
	^selector beginsWith: 'initialize'!

defaultCategories: method
	"Private - Answer a <sequencedReadableCollection> of default categories to be presented
	for the <CompiledMethod>, method."

	| methodClass answer |
	methodClass := method methodClass.
	answer := OrderedCollection new: 3.
	answer
		add: 'accessing';
		add: 'helpers'.
	methodClass isMeta ifTrue: [answer add: 'instance creation'] ifFalse: [answer add: 'operations'].
	^answer collect: [:each | each asMethodCategory]!

isReturnConstant: aCompiledMethod 
	"Private - Answer whether the <CompiledMethod> argument returns a constant value."

	^aCompiledMethod extraIndex between: 2 and: 5!

prefixCategories
	^#(
	#('is' 'testing')
	#('can' 'testing')
	#('as' 'converting')
	#('be' 'modes') 
	#('error' 'exceptions') 
	#('on' 'event handling') 
	#('add' 'adding') 
	#('remove' 'removing') 
	#('compare' 'comparing') 
	#('refresh' 'updating') 
	#('test' 'unit tests')
	)!

suffixCategories
	^#(
	#('Changed' 'updating')
	#('Menu' 'menus')
	#('Model' 'models')
	#('View' 'views')
	#('Shell' 'views')
	#('Dialog' 'views')
	)
!

suggestedPrivacyFor: method
	"Answer the suggested <MethodPrivacyCategory> for the <CompiledMethod>, method."

	| source |
	source := method getSource.
	^((source contains: '"Private -') ifTrue: ['private'] ifFalse: ['public']) asMethodCategory!

suggestionsFor: method
	"Answer a <sequencedReadableCollection> of suggested method categories for 
	the <CompiledMethod>, method. Entries towards the start of the list are considered 
	to be better suggestions"

	| suggestions selector |
	suggestions := self superCategoriesOf: method.
	selector := method selector.
	(self isReturnConstant: method) ifTrue: [suggestions add: 'constants' asMethodCategory].
	(self couldBeAccessor: method) ifTrue: [suggestions add: 'accessing' asMethodCategory].
	(self couldBeInitializer: method) ifTrue: [suggestions add: 'initializing' asMethodCategory].
	suggestions addAll: (self allCategoriesOfSelector: selector).
	self prefixCategories
		do: [:each | (selector beginsWith: each first) ifTrue: [suggestions add: each last asMethodCategory]].
	self suffixCategories
		do: [:each | (selector endsWith: each first) ifTrue: [suggestions add: each last asMethodCategory]].

	"If there are no better suggestions then use 'accessing' or 'operations', etc"
	suggestions addAll: (self defaultCategories: method).

	"Remove any dumb suggestions"
	suggestions := suggestions select: [:s | s isVirtual not and: [s acceptsAdditions]].

	"And finally remove any existing categories."
	suggestions := suggestions difference: method categories.
	^suggestions!

superCategoriesOf: method 
	"Private - Answer a <sequencedReadableCollection> of the categories of superclass implementations
	of the <CompiledMethod>, method. Categories may appear more than once in the collection."

	| selector suggestions |
	selector := method selector.
	suggestions := OrderedCollection new.
	method methodClass allSuperclasses do: 
			[:each | 
			(each includesSelector: selector) 
				ifTrue: 
					[| m |
					m := each compiledMethodAt: selector.
					suggestions addAll: m categories]].
	^suggestions! !
!Tools.MethodCategorizationPolicy categoriesFor: #allCategoriesOfSelector:!enquiries!private! !
!Tools.MethodCategorizationPolicy categoriesFor: #bestSuggestionFor:!enquiries!public! !
!Tools.MethodCategorizationPolicy categoriesFor: #couldBeAccessor:!helpers!private! !
!Tools.MethodCategorizationPolicy categoriesFor: #couldBeInitializer:!helpers!private! !
!Tools.MethodCategorizationPolicy categoriesFor: #defaultCategories:!helpers!private! !
!Tools.MethodCategorizationPolicy categoriesFor: #isReturnConstant:!helpers!private! !
!Tools.MethodCategorizationPolicy categoriesFor: #prefixCategories!constants!private! !
!Tools.MethodCategorizationPolicy categoriesFor: #suffixCategories!constants!private! !
!Tools.MethodCategorizationPolicy categoriesFor: #suggestedPrivacyFor:!enquiries!private! !
!Tools.MethodCategorizationPolicy categoriesFor: #suggestionsFor:!enquiries!public! !
!Tools.MethodCategorizationPolicy categoriesFor: #superCategoriesOf:!helpers!private! !

!Tools.MethodCategorizationPolicy class methodsFor!

default
	"Answer the default instance of the receiver."

	^Default!

initialize	
	"Private - Initialize the receiver's class variables.
		MethodCategorizationPolicy initialize
	"

	Default := self new!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Default := nil.! !
!Tools.MethodCategorizationPolicy class categoriesFor: #default!instance creation!public! !
!Tools.MethodCategorizationPolicy class categoriesFor: #initialize!initializing!private! !
!Tools.MethodCategorizationPolicy class categoriesFor: #uninitialize!class hierarchy-removing!private! !

