"Filed out from Dolphin Smalltalk X6"!

ReferencesCategory subclass: #SpecialReferencesCategory
	instanceVariableNames: 'index'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SpecialReferencesCategory guid: (GUID fromString: '{E9A4ED98-09ED-452E-9FE6-E59AE77DCFDE}')!
SpecialReferencesCategory comment: ''!
!SpecialReferencesCategory categoriesForClass!Development! !
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

