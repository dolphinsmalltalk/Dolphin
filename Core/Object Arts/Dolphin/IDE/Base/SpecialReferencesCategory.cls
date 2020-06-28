"Filed out from Dolphin Smalltalk 7"!

ReferencesCategory subclass: #SpecialReferencesCategory
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!SpecialReferencesCategory categoriesFor: #includesMethod:!public!testing! !
!SpecialReferencesCategory categoriesFor: #index:!accessing!private! !

