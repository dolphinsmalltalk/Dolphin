"Filed out from Dolphin Smalltalk 7"!

COMEnumerator subclass: #COMVariantEnumerator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
COMVariantEnumerator guid: (GUID fromString: '{537c1340-a1b1-11d3-b376-080046056106}')!
COMVariantEnumerator comment: 'COMInterfaceEnumerator is Dolphin''s implementation of <IEnumVARIANT>.'!
!COMVariantEnumerator categoriesForClass!COM-Implementations! !
!COMVariantEnumerator methodsFor!

nextElement
	"Private - Answer a copy of the next element of the receiver.
	Implementation Note: We must use VariantCopy() to ensure
	we get a true copy for an output argument."

	^contents next copy detach! !
!COMVariantEnumerator categoriesFor: #nextElement!COM Interfaces-IEnumXXXX!private! !

