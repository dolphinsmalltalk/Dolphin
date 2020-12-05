"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'CDO.INNTPPostScriptConnector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
CDO.INNTPPostScriptConnector guid: (OS.COM.IID fromString: '{cd000031-8b95-11d1-82db-00c04fb1625d}')!
CDO.INNTPPostScriptConnector comment: '<CDO.INNTPPostScriptConnector> is a wrapper class for the COM interface ''CDO.INNTPPostScriptConnector'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"INNTPPostScriptConnector interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDO.INNTPPostScriptConnector categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDO.INNTPPostScriptConnector methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false! !
!CDO.INNTPPostScriptConnector categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDO.INNTPPostScriptConnector categoriesFor: #isVBCollection!**auto generated**!public!testing! !

!CDO.INNTPPostScriptConnector class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (NNTPPostConnector) for which the receiver is the default interface.
	"

	^CLSID fromString: '{CD000009-8B95-11D1-82DB-00C04FB1625D}'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDO.INNTPPostScriptConnector initializeTypeLib
	"

	typeLib := CDOLib! !
!CDO.INNTPPostScriptConnector class categoriesFor: #clsid!**auto generated**!constants!private! !
!CDO.INNTPPostScriptConnector class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

