"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOINNTPFinalScriptConnector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOINNTPFinalScriptConnector guid: (IID fromString: '{cd000032-8b95-11d1-82db-00c04fb1625d}')!
CDOINNTPFinalScriptConnector comment: '<CDOINNTPFinalScriptConnector> is a wrapper class for the COM interface ''CDO.INNTPFinalScriptConnector'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"INNTPFinalScriptConnector interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOINNTPFinalScriptConnector categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOINNTPFinalScriptConnector methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!CDOINNTPFinalScriptConnector categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOINNTPFinalScriptConnector categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!CDOINNTPFinalScriptConnector class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (NNTPFinalConnector) for which the receiver is the default interface.
	"

	^CLSID fromString: '{CD000010-8B95-11D1-82DB-00C04FB1625D}'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOINNTPFinalScriptConnector initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOINNTPFinalScriptConnector class categoriesFor: #clsid!**auto generated**!constants!private! !
!CDOINNTPFinalScriptConnector class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

