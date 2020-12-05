"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'CDO.INNTPFinalScriptConnector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
CDO.INNTPFinalScriptConnector guid: (OS.COM.IID fromString: '{cd000032-8b95-11d1-82db-00c04fb1625d}')!
CDO.INNTPFinalScriptConnector comment: '<CDO.INNTPFinalScriptConnector> is a wrapper class for the COM interface ''CDO.INNTPFinalScriptConnector'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"INNTPFinalScriptConnector interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDO.INNTPFinalScriptConnector categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDO.INNTPFinalScriptConnector methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!CDO.INNTPFinalScriptConnector categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDO.INNTPFinalScriptConnector categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!CDO.INNTPFinalScriptConnector class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (NNTPFinalConnector) for which the receiver is the default interface.
	"

	^CLSID fromString: '{CD000010-8B95-11D1-82DB-00C04FB1625D}'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDO.INNTPFinalScriptConnector initializeTypeLib
	"

	typeLib := CDOLib! !
!CDO.INNTPFinalScriptConnector class categoriesFor: #clsid!**auto generated**!constants!private! !
!CDO.INNTPFinalScriptConnector class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

