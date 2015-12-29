"Filed out from Dolphin Smalltalk X6"!

Category subclass: #MethodCategory
	instanceVariableNames: ''
	classVariableNames: 'Private Pseuds Public Table'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodCategory guid: (GUID fromString: '{87B4C502-026E-11D3-9FD7-00A0CC3E4A32}')!
MethodCategory comment: 'MethodCategory is the class of objects used to classify the methods of classes in taxonomies that are generally unrelated to the class hierarchy.

Instance Variables: (None)

Class Variables:
	Pseuds		<Set> of <VirtualMethodCategory>s. The pseudo-categories.
	Table		<WeakLookupTable> mapping <String> names to <MethodCategory> instances.'!
!MethodCategory categoriesForClass!Development! !
!MethodCategory methodsFor!

addClass: class
	"Add the <Class>, class, to the collection of classes associated with the receiver.
	There is nothing we can do for method categories as we don't have the notion of
	a set of selectors which constitutes the category, and therefore we can't update
	the class in any useful manner (however see MethodProtocol)."!

addMethod: method
	"Add the <CompiledMethod>, method, to the collection of methods within the receiver."

	(self includesMethod: method) ifFalse: [
		self addMethodSilently: method.
		method methodClass environment trigger: #methodCategorized: with: method]
!

addMethods: aCollection 
	aCollection do: [:each | self addMethod: each]!

addMethodSilently: method
	"Private -  Add the <CompiledMethod>, method, to the collection of methods 
	classified under receiver, without triggering a recategorization event."

	method methodClass includeSelector: method selector inCategory: self!

behaviors
	"Answer a <sequencedReadableCollection> of all the <ClassDescription> objects which have
	methods in this category in class hierarchy order (i.e. superclasses first)."

	| answer |
	answer := OrderedCollection new: 32.
	self behaviorsDo: [:each | answer addLast: each].
	^answer!

behaviorsDo: aMonadicValuable 
	self class environment 
		allBehaviorsDo: [:each | (each includesCategory: self) ifTrue: [aMonadicValuable value: each]]!

contents
	"Answer a <collection> of all methods classified under the receiver."

	| foundMethods |
	foundMethods := IdentitySet new.
	self behaviorsDo: [:aBehavior | foundMethods addAll: (self methodsInBehavior: aBehavior)].
	^foundMethods!

includesMethod: method
	"Answer whether the receiver includes the <CompiledMethod>, method."

	^(method methodClass selectorsInCategory: self) identityIncludes: method selector!

isPrivacy
	"Private - Answer whether the receiver is a method privacy category."

	^false!

methodsInBehavior: aBehavior 
	"Answer a <sequencedReadableCollection> of <CompiledMethods>s being all the methods in the <Behavior>
	argument which are members of the receiver."

	| answer |
	answer := OrderedCollection new: 32.
	self methodsInBehavior: aBehavior do: [:each | answer addLast: each].
	^answer!

methodsInBehavior: aBehavior do: aMonadicValuable 
	(aBehavior selectorsInCategory: self) do: 
			[:eachSelector | 
			(aBehavior compiledMethodAt: eachSelector ifAbsent: []) 
				ifNotNil: [:eachMethod | aMonadicValuable value: eachMethod]]!

removeClass: aClassDescription 
	"Remove the <ClassDescription> argument from the classes 'held' by the receiver.
	In this case we just remove all references to this category from the class."

	| methods |
	methods := self methodsInBehavior: aClassDescription.
	methods isEmpty ifTrue: [^self].
	methods do: [:each | self removeMethodSilently: each].
	aClassDescription isChanged: true!

removeMethod: method
	"Remove the <CompiledMethod>, method, from the methods held 
	by the receiver, triggering a method categorization event to inform
	observers."

	self removeMethodSilently: method.
	method methodClass environment trigger: #methodCategorized: with: method!

removeMethods: aCollection 
	aCollection do: [:each | self removeMethod: each]!

removeMethodSilently: method
	"Private - Remove the <CompiledMethod>, method, from the set of 
	methods that are members of the receiver, and make no fuss about it." 

	method methodClass removeSelector: method selector fromCategory: self! !
!MethodCategory categoriesFor: #addClass:!adding!public! !
!MethodCategory categoriesFor: #addMethod:!adding!public! !
!MethodCategory categoriesFor: #addMethods:!adding!public! !
!MethodCategory categoriesFor: #addMethodSilently:!adding!private! !
!MethodCategory categoriesFor: #behaviors!enumerating!private! !
!MethodCategory categoriesFor: #behaviorsDo:!enumerating!public! !
!MethodCategory categoriesFor: #contents!enumerating!public! !
!MethodCategory categoriesFor: #includesMethod:!public!testing! !
!MethodCategory categoriesFor: #isPrivacy!private!testing! !
!MethodCategory categoriesFor: #methodsInBehavior:!enumerating!public! !
!MethodCategory categoriesFor: #methodsInBehavior:do:!enumerating!public! !
!MethodCategory categoriesFor: #removeClass:!public!removing! !
!MethodCategory categoriesFor: #removeMethod:!public!removing! !
!MethodCategory categoriesFor: #removeMethods:!public!removing! !
!MethodCategory categoriesFor: #removeMethodSilently:!private!removing! !

!MethodCategory class methodsFor!

addPseud: category
	"Add the virtual method category, category, to the global list of virtual categories
	which may be associated with any class. Any samed name standard category
	is removed from the system."

	self removeCategory: category.
	Pseuds add: category.
	^Table at: category name put: category.!

allMethodCategories
	"Answer the set of all <methodCategory>s current registered in the system."

	^Table values!

deprecatedMethods
	"Answer the category for deprecated methods. Note we choose not to use #deprecated as the selector
	for this method, as otherwise it too would appear in the deprecated category."

	^self name: '*-deprecated'!

initialize
	"Private - Initialize the receiver's class variables.
		MethodCategory initialize
	"

	self initializeTable!

initializeTable
	"Private - Initialize the receiver's dictionary of instances.

	This is a No-Op because we have to create the table
	during the booting process of Dolphin so all the methods
	categories can be set as they are loaded. Support for the booting
	of the system is unnecessary in the release version of Dolphin but
	it resolves the conundrom of creating the Smalltalk system, which
	relies on itself to work, from nothing using smalltalk. 

	It is unwise to clear down this table, as the development system
	expects methods and classes to be correctly categorized."
"	| newTable |

	newTable := WeakLookupTable new.
	newTable addAll: Table associations.
	Table := newTable"

	"Repair table as weakness not operative during boot process"
	Table removeAllKeys: (Table keys select: [:k | k isKindOf: DeadObject])!

name: categoryName
	"Answer the subinstance of the receiver with the <readableString> name, categoryName."

	| nameString |
	nameString := categoryName asString.
	^Table at: nameString ifAbsentPut: [self newNamed: nameString]!

primitives
	"Answer the category for primitive methods."

	^self name: '*-primitives'!

private
	"Answer the category for private methods."

	Private isNil ifTrue: [Private := self name: 'private'].
	^Private!

pseudoCategories
	"Answer the <collection> of standard pseudo categories, the contents of which 
	are calculated, and which might therefore be associated with any class in the system."

	^Pseuds!

pseudPrefix
	"Private - Answer the <readableString> prefix to be prepended to the names of the
	standard pseudo categories. N.B. The prefix should be short."

	^'*-'!

public
	"Answer the category for public methods."

	Public isNil ifTrue: [Public := self name: 'public'].
	^Public!

removeCategory: category
	"Remove the specified category from all classes with which it is associated,
	and also from the table of categories."

	| catName |
	catName := category asString.
	"Make absolutely sure any standard category of the same name has been removed"
	self environment allBehaviorsDo: [:c | | catalogue |
		catalogue := c methodsCatalogue.
		(catalogue keys select: [:e | e name = catName]) 
			do: [:k | catalogue removeKey: k]].
	Pseuds remove: (Table removeKey: catName ifAbsent: []) ifAbsent: []!

removePseud: pseud
	"Remove the virtual method category, pseud, from the global list of virtual 
	categories which may be associated with any class."

	^Pseuds notNil ifTrue: [Pseuds remove: (Table removeKey: pseud asString ifAbsent: []) ifAbsent: []]!

setMethod: method categories: categories 
	"Private - Set the categories of the <CompiledMethod>, method, to be the <Collection> of
	<methodCategory>s, categories, only (i.e. any existing non-pseudo classifications
	not in 'categories' are removed)."

	| newCategories original unwanted |
	original := method realCategories.
	newCategories := categories reject: [:each | each isPseud].
	unwanted := original difference: newCategories.
	newCategories := newCategories difference: original.
	unwanted do: [:c | c removeMethodSilently: method].
	newCategories do: [:each | each addMethodSilently: method].
	^unwanted notEmpty or: [newCategories notEmpty]!

unclassifiedName
	"Private - Answer the <readableString> name for the unclassified category."

	^ '*-unclassified'!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Pseuds := Table := nil! !
!MethodCategory class categoriesFor: #addPseud:!adding!public! !
!MethodCategory class categoriesFor: #allMethodCategories!accessing!public! !
!MethodCategory class categoriesFor: #deprecatedMethods!instance creation!public! !
!MethodCategory class categoriesFor: #initialize!initializing!private! !
!MethodCategory class categoriesFor: #initializeTable!initializing!private! !
!MethodCategory class categoriesFor: #name:!instance creation!public! !
!MethodCategory class categoriesFor: #primitives!instance creation!public! !
!MethodCategory class categoriesFor: #private!instance creation!public! !
!MethodCategory class categoriesFor: #pseudoCategories!constants!public! !
!MethodCategory class categoriesFor: #pseudPrefix!constants!private! !
!MethodCategory class categoriesFor: #public!instance creation!public! !
!MethodCategory class categoriesFor: #removeCategory:!public!removing! !
!MethodCategory class categoriesFor: #removePseud:!public!removing! !
!MethodCategory class categoriesFor: #setMethod:categories:!helpers!private! !
!MethodCategory class categoriesFor: #unclassifiedName!constants!private! !
!MethodCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

