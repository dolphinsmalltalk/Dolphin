"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOISMTPOnArrival
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOISMTPOnArrival guid: (IID fromString: '{cd000026-8b95-11d1-82db-00c04fb1625d}')!
CDOISMTPOnArrival comment: '<CDOISMTPOnArrival> is a wrapper class for the COM interface ''CDO.ISMTPOnArrival'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"The interface to implement when creating SMTP OnArrival event sinks"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOISMTPOnArrival categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOISMTPOnArrival methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

OnArrival: msg EventStatus: eventStatus
	"Invoke the OnArrival() method of the COM object wrapped by the receiver.
	Helpstring: 'Called by the SMTP event dispatcher when a message arrives.'

		HRESULT __stdcall OnArrival(
			[in] IMessage* Msg,
			[in, out] CdoEventStatus* EventStatus);
	"

	<virtual stdcall: hresult 8 CDOIMessage* sdword*>
	^self invalidCall: _failureCode! !
!CDOISMTPOnArrival categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOISMTPOnArrival categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOISMTPOnArrival categoriesFor: #OnArrival:EventStatus:!**auto generated**!COM Interfaces-ISMTPOnArrival!public! !

!CDOISMTPOnArrival class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.ISMTPOnArrival'
		CDOISMTPOnArrival defineTemplate
	"

	self
		defineFunction: #OnArrival:EventStatus:
			argumentTypes: 'CDOIMessage* sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOISMTPOnArrival initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOISMTPOnArrival class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOISMTPOnArrival class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

