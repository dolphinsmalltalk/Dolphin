"Filed out from Dolphin Smalltalk 7"!

OS.COM.Enumerator subclass: #'OS.COM.VariantEnumerator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.VariantEnumerator guid: (Core.GUID fromString: '{537c1340-a1b1-11d3-b376-080046056106}')!
OS.COM.VariantEnumerator comment: 'COMInterfaceEnumerator is Dolphin''s implementation of <IEnumVARIANT>.'!
!OS.COM.VariantEnumerator categoriesForClass!COM-Implementations! !
!OS.COM.VariantEnumerator methodsFor!

nextElement
	"Private - Answer a copy of the next element of the receiver.
	Implementation Note: We must use VariantCopy() to ensure
	we get a true copy for an output argument."

	^contents next copy detach! !
!OS.COM.VariantEnumerator categoriesFor: #nextElement!COM Interfaces-IEnumXXXX!private! !

