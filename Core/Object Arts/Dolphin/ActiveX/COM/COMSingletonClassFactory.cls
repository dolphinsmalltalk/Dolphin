"Filed out from Dolphin Smalltalk X6"!

COMClassFactory subclass: #COMSingletonClassFactory
	instanceVariableNames: 'current'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
COMSingletonClassFactory guid: (GUID fromString: '{87B4C542-026E-11D3-9FD7-00A0CC3E4A32}')!
COMSingletonClassFactory comment: 'COMSingletonClassFactory is simple specialization of COMClassFactory which always serves up the same instance of its registered coclass.

Note that although this is a useful concept (it is supported by the ATL for example), it is not strictly supported by COM which expects every call to CoCreateInstance() to answer a brand new instance of the coclass. This can break the apartment threading model when sharing an object since COM assumes that the object is created in the apartment of the caller, and where multiple apartments exist this can result in one apartment erroneously holding an unmarshalled interface pointer to an object in another apartment.

Dolphin''s standard implementation of IClassFactory. It can serve up instances of a particular coclass (possibly also a subclass of COMInterfaceImp), and having been registered once for any paricular coclass it will re-register the availability of that coclass with COM each time that Dolphin is started.

Instance Variables:
	current		- the lazily instantiated singleton instance of the receiver''s coclass.

Class Variables:
	None
'!
!COMSingletonClassFactory categoriesForClass!COM-Implementations! !
!COMSingletonClassFactory methodsFor!

createInstance: pUnkOuter
	"Private - Answer the singleton instance of the receiver's server class."

	current isNil ifTrue: [
		current := super createInstance: pUnkOuter].
	^current! !
!COMSingletonClassFactory categoriesFor: #createInstance:!instance creation!private! !

