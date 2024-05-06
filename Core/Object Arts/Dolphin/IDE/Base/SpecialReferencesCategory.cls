"Filed out from Dolphin Smalltalk"!

ReferencesCategory subclass: #SpecialReferencesCategory
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SpecialReferencesCategory guid: (GUID fromString: '{e9a4ed98-09ed-452e-9fe6-e59ae77dcfde}')!

SpecialReferencesCategory comment: ''!

!SpecialReferencesCategory categoriesForClass!System-Support! !

!SpecialReferencesCategory methodsFor!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	A method is considered to be in a ReferencesCategory if it references
	the object which that category is interested in."

	^(super includesMethod: aCompiledMethod) or: [aCompiledMethod sendsSpecialSelector: index]!

index: anInteger
	"Private - Set the special selector index."

	index := anInteger! !

!SpecialReferencesCategory categoriesForMethods!
includesMethod:!public!testing! !
index:!accessing!private! !
!

