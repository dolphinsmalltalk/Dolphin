"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOISMTPScriptConnector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOISMTPScriptConnector guid: (IID fromString: '{cd000030-8b95-11d1-82db-00c04fb1625d}')!
CDOISMTPScriptConnector comment: '<CDOISMTPScriptConnector> is a wrapper class for the COM interface ''CDO.ISMTPScriptConnector'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISMTPScriptConnector interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOISMTPScriptConnector categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOISMTPScriptConnector methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!CDOISMTPScriptConnector categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOISMTPScriptConnector categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!CDOISMTPScriptConnector class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (SMTPConnector) for which the receiver is the default interface.
	"

	^CLSID fromString: '{CD000008-8B95-11D1-82DB-00C04FB1625D}'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOISMTPScriptConnector initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOISMTPScriptConnector class categoriesFor: #clsid!**auto generated**!constants!private! !
!CDOISMTPScriptConnector class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

