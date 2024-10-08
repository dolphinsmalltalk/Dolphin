﻿"Filed out from Dolphin Smalltalk"!

Core.Category
	subclass: #'Core.MethodCategory'
	instanceVariableNames: ''
	classVariableNames: 'Private Pseuds Public Table'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'UnclassifiedName' -> '*-unclassified' }!

Core.MethodCategory guid: (Core.GUID fromString: '{87b4c502-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.MethodCategory comment: 'MethodCategory is the class of objects used to classify the methods of classes in taxonomies that are generally unrelated to the class hierarchy.

Instance Variables: (None)

Class Variables:
	Pseuds		<Set> of <VirtualMethodCategory>s. The pseudo-categories.
	Table		<WeakLookupTable> mapping <String> names to <MethodCategory> instances.'!

!Core.MethodCategory categoriesForClass!System-Support! !

!Core.MethodCategory methodsFor!

addClass: class
	"Add the <Class>, class, to the collection of classes associated with the receiver.
	There is nothing we can do for method categories as we don't have the notion of
	a set of selectors which constitutes the category, and therefore we can't update
	the class in any useful manner (however see MethodProtocol)."!

addMethod: method
	"Add the <CompiledMethod>, method, to the collection of methods within the receiver."

	(self includesMethod: method)
		ifFalse: 
			[self addMethodSilently: method.
			Smalltalk trigger: #methodCategorized: with: method]!

addMethods: aCollection 
	aCollection do: [:each | self addMethod: each]!

addMethodSilently: method
	"Private -  Add the <CompiledMethod>, method, to the collection of methods 
	classified under receiver, without triggering a recategorization event."

	method methodClass includeSelector: method selector inCategory: self!

asMethodCategory
	^self!

behaviors
	"Answer a <sequencedReadableCollection> of all the <ClassDescription> objects which have
	methods in this category in class hierarchy order (i.e. superclasses first)."

	| answer |
	answer := OrderedCollection new: 32.
	self behaviorsDo: [:each | answer addLast: each].
	^answer!

behaviorsDo: aMonadicValuable
	Smalltalk
		allBehaviorsDo: [:each | (each includesCategory: self) ifTrue: [aMonadicValuable value: each]]!

contents
	Notification deprecated.
	^self methods!

includesBehavior: aBehavior
	"Answer whether the receiver categorizes any methods in the specified class."

	^aBehavior includesCategory: self!

includesMethod: aCompiledMethod
	"Answer whether the receiver includes the <CompiledMethod> argument."

	^(aCompiledMethod methodClass selectorsInCategory: self) identityIncludes: aCompiledMethod selector!

isEmpty
	"Answer whether the receiver is an empty category (with no members)"

	self class environment allBehaviorsDo: [:each | self methodsInBehavior: each do: [:method | ^false]].
	^true!

isPrivacy
	"Private - Answer whether the receiver is a method privacy category."

	^false!

methods
	"Answer a <collection> of all methods classified under the receiver."

	| foundMethods |
	foundMethods := IdentitySet new: 32.
	Smalltalk
		allBehaviorsDo: [:each | self methodsInBehavior: each do: [:method | foundMethods add: method]].
	^foundMethods!

methodsInBehavior: aBehavior
	"Answer a <sequencedReadableCollection> of <CompiledMethods>s being all the methods in the <Behavior> argument which are members of the receiver."

	| methods selectors count |
	selectors := aBehavior selectorsInCategory: self.
	"This needs to be robust to the method catalogue being out of date with respect to the actual method dictionary, which can happen if something has removed methods directly from the MethodDictionary such that no system update events were triggered."
	count := selectors size.
	methods := WriteStream on: (Array new: count).
	1 to: count
		do: 
			[:i |
			(aBehavior compiledMethodAt: (selectors at: i) ifAbsent: nil)
				ifNotNil: [:each | methods nextPut: each]].
	^methods grabContents!

methodsInBehavior: aBehavior do: aMonadicValuable
	(aBehavior selectorsInCategory: self) do: 
			[:eachSelector |
			(aBehavior compiledMethodAt: eachSelector ifAbsent: nil)
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
	Smalltalk trigger: #methodCategorized: with: method!

removeMethods: aCollection 
	aCollection do: [:each | self removeMethod: each]!

removeMethodSilently: method
	"Private - Remove the <CompiledMethod>, method, from the set of 
	methods that are members of the receiver, and make no fuss about it." 

	method methodClass removeSelector: method selector fromCategory: self!

selectorsInBehavior: aBehavior
	"Answer a <sequencedReadableCollection> of <Symbol>s being the selectors of methods in the <Behavior> argument which are members of the receiver."

	^aBehavior selectorsInCategory: self! !

!Core.MethodCategory categoriesForMethods!
addClass:!adding!public! !
addMethod:!adding!public! !
addMethods:!adding!public! !
addMethodSilently:!adding!private! !
asMethodCategory!converting!public! !
behaviors!enumerating!private! !
behaviorsDo:!enumerating!public! !
contents!enumerating!public! !
includesBehavior:!development!enumerating!public! !
includesMethod:!public!testing! !
isEmpty!public!testing! !
isPrivacy!private!testing! !
methods!enumerating!public! !
methodsInBehavior:!enumerating!public! !
methodsInBehavior:do:!enumerating!public! !
removeClass:!development!public!removing! !
removeMethod:!public!removing! !
removeMethods:!public!removing! !
removeMethodSilently:!private!removing! !
selectorsInBehavior:!enumerating!public! !
!

!Core.MethodCategory class methodsFor!

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

	"It is unwise to clear down the method category table, as the development system expects methods and classes
	to be correctly categorized. However during the booting of the system weakness is not operative so we must
	repair the table by cleaning out the dead wood."

	Table removeAllKeys: (Table keys select: [:k | k isKindOf: DeadObject])!

name: categoryName
	"Answer the subinstance of the receiver with the <readableString> name, categoryName."

	| nameString |
	nameString := categoryName asString.
	^Table at: nameString ifAbsentPutClean: [self newNamed: nameString]!

primitives
	"Answer the category for primitive methods."

	^self name: '*-primitives'!

private
	"Answer the category for private methods."

	^Private ifNil: [Private := self name: 'private']!

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

	^Public ifNil: [Public := self name: 'public']!

removeCategory: category
	"Remove the specified category from all classes with which it is associated,
	and also from the table of categories."

	| catName |
	catName := category asString.
	"Make absolutely sure any standard category of the same name has been removed"
	Smalltalk allBehaviorsDo: 
			[:c |
			| catalogue |
			catalogue := c methodsCatalogue.
			(catalogue keys select: [:e | e name = catName]) do: [:k | catalogue removeKey: k]].
	Pseuds remove: (Table removeKey: catName ifAbsent: nil) ifAbsent: nil!

removePseud: pseud
	"Remove the virtual method category, pseud, from the global list of virtual 
	categories which may be associated with any class."

	^Pseuds notNil
		ifTrue: [Pseuds remove: (Table removeKey: pseud asString ifAbsent: nil) ifAbsent: nil]!

setMethod: aCompiledMethod categories: aCollectionOfCategories
	"Private - Set the categories of the <CompiledMethod>, method, to be the <Collection> of
	<methodCategory>s, categories, only (i.e. any existing non-pseudo classifications
	not in 'categories' are removed)."

	| nonPseudo newCategories original unwanted |
	nonPseudo := IdentitySet new: aCollectionOfCategories size.
	aCollectionOfCategories do: 
			[:each |
			| category |
			category := each asMethodCategory.
			each isPseud ifFalse: [nonPseudo add: category]].
	original := aCompiledMethod realCategories.
	unwanted := original difference: nonPseudo.
	newCategories := nonPseudo difference: original.
	unwanted do: [:each | each removeMethodSilently: aCompiledMethod].
	newCategories do: [:each | each addMethodSilently: aCompiledMethod].
	^unwanted notEmpty or: [newCategories notEmpty]!

unclassified
	"Answer a Category used to mark an unclassified object."

	^self name: UnclassifiedName!

uninitialize
	"Private - Uninitialize the receiver as it may be about to be removed from the system."

	Pseuds := Set new.
	Table := WeakLookupTable new! !

!Core.MethodCategory class categoriesForMethods!
addPseud:!adding!public! !
allMethodCategories!accessing!public! !
deprecatedMethods!instance creation!public! !
initialize!initializing!private! !
name:!instance creation!public! !
primitives!instance creation!public! !
private!instance creation!public! !
pseudoCategories!constants!public! !
pseudPrefix!constants!private! !
public!instance creation!public! !
removeCategory:!public!removing! !
removePseud:!public!removing! !
setMethod:categories:!helpers!private! !
unclassified!instance creation!public! !
uninitialize!class hierarchy-removing!private! !
!

