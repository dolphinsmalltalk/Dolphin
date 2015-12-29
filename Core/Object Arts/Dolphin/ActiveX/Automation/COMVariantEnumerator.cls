"Filed out from Dolphin Smalltalk X6"!

COMEnumerator subclass: #COMVariantEnumerator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMVariantEnumerator guid: (GUID fromString: '{537C1340-A1B1-11D3-B376-080046056106}')!
COMVariantEnumerator comment: 'COMInterfaceEnumerator is Dolphin''s implementation of <IEnumVARIANT>.'!
!COMVariantEnumerator categoriesForClass!COM-Implementations! !
!COMVariantEnumerator methodsFor!

nextElement
	"Private - Answer a copy of the next element of the receiver.
	Implementation Note: We must use VariantCopy() to ensure
	we get a true copy for an output argument."

	^contents next copy detach! !
!COMVariantEnumerator categoriesFor: #nextElement!COM Interfaces-IEnumXXXX!private! !

