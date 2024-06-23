"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'CDO.INNTPOnPostEarly'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

CDO.INNTPOnPostEarly guid: (OS.COM.IID fromString: '{cd000033-8b95-11d1-82db-00c04fb1625d}')!

CDO.INNTPOnPostEarly comment: '<CDO.INNTPOnPostEarly> is a wrapper class for the COM interface ''CDO.INNTPOnPostEarly'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"The interface to implement when creating NNTP OnPostEarly event sinks"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!

!CDO.INNTPOnPostEarly categoriesForClass!CDO-Interfaces!COM-Interfaces! !

!CDO.INNTPOnPostEarly methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

OnPostEarly: msg EventStatus: eventStatus
	"Invoke the OnPostEarly() method of the COM object.
	Helpstring: Called by the NNTP event dispatcher when message headers arrive.

		HRESULT __stdcall OnPostEarly(
			[in]IMessage* Msg,
			[in, out]CdoEventStatus* EventStatus);"

	<virtual stdcall: hresult 8 IMessage* int32*>
	^self invalidCall: _failureCode! !

!CDO.INNTPOnPostEarly categoriesForMethods!
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
OnPostEarly:EventStatus:!**auto generated**!COM Interfaces-INNTPOnPostEarly!public! !
!

!CDO.INNTPOnPostEarly class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.INNTPOnPostEarly'
		INNTPOnPostEarly defineTemplate"

	self
		defineFunction: #OnPostEarly:EventStatus:
			argumentTypes: 'IMessage* sdword*'
! !

!CDO.INNTPOnPostEarly class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

