"Filed out from Dolphin Smalltalk 7"!

Tools.ReferencesCategory subclass: #'Tools.PackedReferencesCategory'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackedReferencesCategory guid: (Core.GUID fromString: '{a8cdf33b-5f72-4df4-9ee0-91e91d37bc3c}')!
Tools.PackedReferencesCategory comment: 'PackedReferencesCategory is the class of virtual method categories dynamically determines their membership to include only those methods which have packed byte codes and reference a particular object from their literal frame. In practice this will include only those methods that consist of a send to self of a zero argument selector.

PackedReferencesCategory has no instances by default, but you can create your own packed reference categories by following the examples in the class #initialize method.'!
!Tools.PackedReferencesCategory categoriesForClass!System-Support! !
!Tools.PackedReferencesCategory methodsFor!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	A method is considered to be in a PackedReferencesCategory if it references
	the object which that category is interested in, and is a packed method."

	^(super includesMethod: aCompiledMethod) and: [aCompiledMethod isPacked]! !
!Tools.PackedReferencesCategory categoriesFor: #includesMethod:!public!testing! !

