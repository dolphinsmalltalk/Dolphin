"Filed out from Dolphin Smalltalk"!

VirtualMethodCategory subclass: #ReferencesCategory
	instanceVariableNames: 'literal'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ReferencesCategory guid: (GUID fromString: '{87b4c507-026e-11d3-9fd7-00a0cc3e4a32}')!
ReferencesCategory comment: 'ReferencesCategory is the class of virtual method categories which dynamically determines their membership to include only those methods which reference a particular object from their literal frame.

ReferencesCategory has (sub)instances such as the ''*-subclass responsibility'' category, but you can create your own references categories by following the examples in the class #initialize method.

Instance Variables:
	object	<Object> to which a reference confers category membership.

Class Variables:
	None'!
!ReferencesCategory categoriesForClass!System-Support! !
!ReferencesCategory methodsFor!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	A method is considered to be in a ReferencesCategory if it references
	the object which that category is interested in."

	^aCompiledMethod refersToLiteral: literal!

literal: anObject
	"Set the literal, references to which define membership of this category."

	literal := anObject! !
!ReferencesCategory categoriesForMethods!
includesMethod:!public!testing! !
literal:!accessing!public! !
!

!ReferencesCategory class methodsFor!

createDefaultInstances
	self referenceSymbols do: 
			[:each |
			| cat suffix |
			suffix := each asPhrase asLowercase.
			cat := (self newNamed: self pseudPrefix , suffix)
						literal: each asSymbol;
						yourself.
			self
				removeCategory: suffix;
				addPseud: cat.
			Table at: suffix put: cat]!

initialize
	"Private - Initialize the receiver.
		ReferencesCategory initialize.
	You can add your own reference categories for the selectors you are interested in.
	Unless you want this method to appear in the category too, you should use #asSymbol to
	construct the referenced symbol dynamically.
	"

	self createDefaultInstances!

newNamed: aString literal: anObject 
	^((VMLibrary default indexOfSpecialSelector: anObject ifAbsent: []) 
		ifNil: [self newNamed: aString]
		ifNotNil: 
			[:index | 
			(SpecialReferencesCategory newNamed: aString)
				index: index;
				yourself])
		literal: anObject;
		yourself!

referenceSymbols
	^#('notYetImplemented' 'deprecated')!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self referenceSymbols do: [:each | self removePseud: self pseudPrefix , each asPhrase asLowercase]! !
!ReferencesCategory class categoriesForMethods!
createDefaultInstances!initializing!private! !
initialize!initializing!private! !
newNamed:literal:!public! !
referenceSymbols!constants!private! !
uninitialize!class hierarchy-removing!private! !
!

