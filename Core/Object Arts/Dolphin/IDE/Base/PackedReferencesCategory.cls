"Filed out from Dolphin Smalltalk X6"!

ReferencesCategory subclass: #PackedReferencesCategory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackedReferencesCategory guid: (GUID fromString: '{A8CDF33B-5F72-4DF4-9EE0-91E91D37BC3C}')!
PackedReferencesCategory comment: 'PackedReferencesCategory is the class of virtual method categories dynamically determines their membership to include only those methods which have packed byte codes and reference a particular object from their literal frame. In practice this will include only those methods that consist of a send to self of a zero argument selector.

PackedReferencesCategory has no instances by default, but you can create your own packed reference categories by following the examples in the class #initialize method.'!
!PackedReferencesCategory categoriesForClass!Development! !
!PackedReferencesCategory methodsFor!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	A method is considered to be in a PackedReferencesCategory if it references
	the object which that category is interested in, and is a packed method."

	^(super includesMethod: aCompiledMethod) and: [aCompiledMethod isPacked]! !
!PackedReferencesCategory categoriesFor: #includesMethod:!public!testing! !

