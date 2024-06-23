"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'CDO.INNTPEarlyScriptConnector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

CDO.INNTPEarlyScriptConnector guid: (OS.COM.IID fromString: '{cd000034-8b95-11d1-82db-00c04fb1625d}')!

CDO.INNTPEarlyScriptConnector comment: '<CDO.INNTPEarlyScriptConnector> is a wrapper class for the COM interface ''CDO.INNTPEarlyScriptConnector'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"INNTPFinalScriptConnector interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!

!CDO.INNTPEarlyScriptConnector categoriesForClass!CDO-Interfaces!COM-Interfaces! !

!CDO.INNTPEarlyScriptConnector methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !

!CDO.INNTPEarlyScriptConnector categoriesForMethods!
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
!

!CDO.INNTPEarlyScriptConnector class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (NNTPEarlyConnector) for which the receiver is the default interface."

	^CLSID fromString: '{cd000011-8b95-11d1-82db-00c04fb1625d}'
! !

!CDO.INNTPEarlyScriptConnector class categoriesForMethods!
clsid!**auto generated**!constants!private! !
!

