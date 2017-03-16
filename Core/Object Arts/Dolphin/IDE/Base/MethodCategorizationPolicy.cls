"Filed out from Dolphin Smalltalk 7"!

Object subclass: #MethodCategorizationPolicy
	instanceVariableNames: ''
	classVariableNames: 'Default'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodCategorizationPolicy guid: (GUID fromString: '{87b4c4a1-026e-11d3-9fd7-00a0cc3e4a32}')!
MethodCategorizationPolicy comment: ''!
!MethodCategorizationPolicy categoriesForClass!Development! !
!MethodCategorizationPolicy methodsFor!

allCategoriesOfSelector: selector
	"Private - Answer a <Collection> of all the <methodCategory>s in which
	the selector <Symbol>, selector, currently appears."

	| answer |
	answer := IdentitySet new.
	self class environment allBehaviorsDo: [:c | | method |
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

	| catClass methodClass answer |
	methodClass := method methodClass.
	catClass := methodClass methodCategoryClass.
	answer := OrderedCollection new: 3.
	answer
		add: (catClass name: 'accessing');
		add: (catClass name: 'helpers').
	methodClass isMeta 
		ifTrue: [answer add: (catClass name: 'instance creation')]
		ifFalse: [answer add: (catClass name: 'operations')].
	^answer!

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

	| source catClass |
	source := method getSource.
	catClass := method methodClass methodCategoryClass.
	^(source findString: '"Private -') == 0 ifTrue: [catClass public] ifFalse: [catClass private]!

suggestionsFor: method 
	"Answer a <sequencedReadableCollection> of suggested method categories for 
	the <CompiledMethod>, method. Entries towards the start of the list are considered 
	to be better suggestions"

	| suggestions selector categoryManager |
	categoryManager := method methodClass methodCategoryClass.
	suggestions := self superCategoriesOf: method.
	selector := method selector.
	(self isReturnConstant: method) 
		ifTrue: [suggestions add: (categoryManager name: 'constants')].
	(self couldBeAccessor: method) 
		ifTrue: [suggestions add: (categoryManager name: 'accessing')].
	(self couldBeInitializer: method) 
		ifTrue: [suggestions add: (categoryManager name: 'initializing')].
	suggestions addAll: (self allCategoriesOfSelector: selector).
	self prefixCategories do: 
			[:each | 
			(selector beginsWith: each first) 
				ifTrue: [suggestions add: (categoryManager name: each last)]].
	self suffixCategories do: 
			[:each | 
			(selector endsWith: each first) 
				ifTrue: [suggestions add: (categoryManager name: each last)]].

	"If there are no better suggestions then use 'accessing' or 'operations', etc"
	suggestions addAll: (self defaultCategories: method).

	"Remove any dumb suggestions"
	suggestions := suggestions select: [:s | s isVirtual not and: [s acceptsAdditions]].

	"And finally remove any existing categories."
	suggestions := suggestions copyWithoutAll: method categories.
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
!MethodCategorizationPolicy categoriesFor: #allCategoriesOfSelector:!enquiries!private! !
!MethodCategorizationPolicy categoriesFor: #bestSuggestionFor:!enquiries!public! !
!MethodCategorizationPolicy categoriesFor: #couldBeAccessor:!helpers!private! !
!MethodCategorizationPolicy categoriesFor: #couldBeInitializer:!helpers!private! !
!MethodCategorizationPolicy categoriesFor: #defaultCategories:!helpers!private! !
!MethodCategorizationPolicy categoriesFor: #isReturnConstant:!helpers!private! !
!MethodCategorizationPolicy categoriesFor: #prefixCategories!constants!private! !
!MethodCategorizationPolicy categoriesFor: #suffixCategories!constants!private! !
!MethodCategorizationPolicy categoriesFor: #suggestedPrivacyFor:!enquiries!private! !
!MethodCategorizationPolicy categoriesFor: #suggestionsFor:!enquiries!public! !
!MethodCategorizationPolicy categoriesFor: #superCategoriesOf:!helpers!private! !

!MethodCategorizationPolicy class methodsFor!

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
!MethodCategorizationPolicy class categoriesFor: #default!instance creation!public! !
!MethodCategorizationPolicy class categoriesFor: #initialize!initializing!private! !
!MethodCategorizationPolicy class categoriesFor: #uninitialize!class hierarchy-removing!private! !

