"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOINNTPEarlyScriptConnector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOINNTPEarlyScriptConnector guid: (IID fromString: '{cd000034-8b95-11d1-82db-00c04fb1625d}')!
CDOINNTPEarlyScriptConnector comment: '<CDOINNTPEarlyScriptConnector> is a wrapper class for the COM interface ''CDO.INNTPEarlyScriptConnector'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"INNTPFinalScriptConnector interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOINNTPEarlyScriptConnector categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOINNTPEarlyScriptConnector methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!CDOINNTPEarlyScriptConnector categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOINNTPEarlyScriptConnector categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!CDOINNTPEarlyScriptConnector class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (NNTPEarlyConnector) for which the receiver is the default interface.
	"

	^CLSID fromString: '{CD000011-8B95-11D1-82DB-00C04FB1625D}'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOINNTPEarlyScriptConnector initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOINNTPEarlyScriptConnector class categoriesFor: #clsid!**auto generated**!constants!private! !
!CDOINNTPEarlyScriptConnector class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

