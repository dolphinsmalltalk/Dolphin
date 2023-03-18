"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'CDO.ISMTPOnArrival'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
CDO.ISMTPOnArrival guid: (OS.COM.IID fromString: '{cd000026-8b95-11d1-82db-00c04fb1625d}')!
CDO.ISMTPOnArrival comment: '<CDO.ISMTPOnArrival> is a wrapper class for the COM interface ''CDO.ISMTPOnArrival'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"The interface to implement when creating SMTP OnArrival event sinks"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDO.ISMTPOnArrival categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDO.ISMTPOnArrival methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

OnArrival: msg EventStatus: eventStatus
	"Invoke the OnArrival() method of the COM object.
	Helpstring: Called by the SMTP event dispatcher when a message arrives.

		HRESULT __stdcall OnArrival(
			[in]IMessage* Msg,
			[in, out]CdoEventStatus* EventStatus);"

	<virtual stdcall: hresult 8 IMessage* int32*>
	^self invalidCall: _failureCode! !
!CDO.ISMTPOnArrival categoriesForMethods!
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
OnArrival:EventStatus:!**auto generated**!COM Interfaces-ISMTPOnArrival!public! !
!

!CDO.ISMTPOnArrival class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.ISMTPOnArrival'
		ISMTPOnArrival defineTemplate"

	self
		defineFunction: #OnArrival:EventStatus:
			argumentTypes: 'IMessage* sdword*'
! !
!CDO.ISMTPOnArrival class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

