"Filed out from Dolphin Smalltalk 7"!

Tools.ReferencesCategory subclass: #'Tools.SpecialReferencesCategory'
	instanceVariableNames: 'index'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.SpecialReferencesCategory guid: (Core.GUID fromString: '{e9a4ed98-09ed-452e-9fe6-e59ae77dcfde}')!
Tools.SpecialReferencesCategory comment: ''!
!Tools.SpecialReferencesCategory categoriesForClass!System-Support! !
!Tools.SpecialReferencesCategory methodsFor!

includesMethod: aCompiledMethod 
	"Answer whether the receiver includes the <CompiledMethod> argument.
	A method is considered to be in a ReferencesCategory if it references
	the object which that category is interested in."

	^(super includesMethod: aCompiledMethod) or: [aCompiledMethod sendsSpecialSelector: index]!

index: anInteger
	"Private - Set the special selector index."

	index := anInteger! !
!Tools.SpecialReferencesCategory categoriesFor: #includesMethod:!public!testing! !
!Tools.SpecialReferencesCategory categoriesFor: #index:!accessing!private! !

