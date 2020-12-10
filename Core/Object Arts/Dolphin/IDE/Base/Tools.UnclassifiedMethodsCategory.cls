"Filed out from Dolphin Smalltalk 7"!

Tools.VirtualMethodCategory subclass: #'Tools.UnclassifiedMethodsCategory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.UnclassifiedMethodsCategory guid: (Core.GUID fromString: '{87b4c508-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.UnclassifiedMethodsCategory comment: 'ReferencesCategory is a virtual method categories class which dynamically determines its membership to be those methods which are categorized only in other virtual categories, i.e. those methods which have not been specifically allocated a category.

Instance Variables:
	None

Class Variables:
	None'!
!Tools.UnclassifiedMethodsCategory categoriesForClass!System-Support! !
!Tools.UnclassifiedMethodsCategory methodsFor!

acceptsAdditions
	"Answer whether methods can be added to the receiver.
	Although this is a pseudo category, it can accept additions."

	^true!

addMethodSilently: aCompiledMethod 
	"Private - Add the <CompiledMethod> argument to the set of methods that are members
	of the receiver. As this is the unclassified category we must remove the method from any 
	of its current, non-pseudo, categories."

	aCompiledMethod categories 
		do: [:each | each isPseud ifFalse: [each removeMethodSilently: aCompiledMethod]]!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument."

	"Implementation Note: Unfortunately we must use private knowledge of the implementation
	of the methods catalogue/protocols to avoid creating an infinite loop here (if we asked the method
	for its categories then such a loop would result)."

	| selector |
	selector := aCompiledMethod selector.
	^aCompiledMethod methodClass methodsCatalogue 
		allSatisfy: [:each | (each includes: selector) not]!

methodsInBehavior: aBehavior do: aMonadicValuable 
	"Implementation Note: The simple implementation using #includesMethod: is too slow since it
	involves repeatedly searching the same collections. It is several times faster (depending on
	the class) to build a set of the classified selectors and compare that against the set of
	all selectors."

	| classified dict |
	classified := IdentitySet new.
	aBehavior methodsCatalogue do: [:each | classified addAll: each].
	dict := aBehavior methodDictionary.
	"We know that the classified methods must be a subset of the class' methods"
	dict size = classified size 
		ifFalse: 
			[(dict keys difference: classified) 
				do: [:each | aMonadicValuable value: (aBehavior compiledMethodAt: each)]]! !
!Tools.UnclassifiedMethodsCategory categoriesFor: #acceptsAdditions!public!testing! !
!Tools.UnclassifiedMethodsCategory categoriesFor: #addMethodSilently:!adding!private! !
!Tools.UnclassifiedMethodsCategory categoriesFor: #includesMethod:!public!testing! !
!Tools.UnclassifiedMethodsCategory categoriesFor: #methodsInBehavior:do:!enumerating!public! !

!Tools.UnclassifiedMethodsCategory class methodsFor!

initialize
	"Private - Initialize the receiver.
		UnclassifiedMethodsCategory initialize.
	"

	| unclassified names |
	names := #('unclassified' 'no category' 'as yet unclassified').
	names do: [:each | self removeCategory: each].
	self addPseud: (self newNamed: self unclassifiedName).
	unclassified := self unclassified.
	names do: [:each | Table at: each put: unclassified]!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self removePseud: self unclassifiedName! !
!Tools.UnclassifiedMethodsCategory class categoriesFor: #initialize!initializing!private! !
!Tools.UnclassifiedMethodsCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

