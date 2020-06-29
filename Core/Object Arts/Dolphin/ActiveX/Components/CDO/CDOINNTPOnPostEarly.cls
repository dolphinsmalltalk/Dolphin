"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOINNTPOnPostEarly
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOINNTPOnPostEarly guid: (IID fromString: '{cd000033-8b95-11d1-82db-00c04fb1625d}')!
CDOINNTPOnPostEarly comment: '<CDOINNTPOnPostEarly> is a wrapper class for the COM interface ''CDO.INNTPOnPostEarly'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"The interface to implement when creating NNTP OnPostEarly event sinks"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOINNTPOnPostEarly categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOINNTPOnPostEarly methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

OnPostEarly: msg EventStatus: eventStatus
	"Invoke the OnPostEarly() method of the COM object wrapped by the receiver.
	Helpstring: 'Called by the NNTP event dispatcher when message headers arrive.'

		HRESULT __stdcall OnPostEarly(
			[in] IMessage* Msg,
			[in, out] CdoEventStatus* EventStatus);
	"

	<virtual stdcall: hresult 8 CDOIMessage* sdword*>
	^self invalidCall: _failureCode! !
!CDOINNTPOnPostEarly categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOINNTPOnPostEarly categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOINNTPOnPostEarly categoriesFor: #OnPostEarly:EventStatus:!**auto generated**!COM Interfaces-INNTPOnPostEarly!public! !

!CDOINNTPOnPostEarly class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.INNTPOnPostEarly'
		CDOINNTPOnPostEarly defineTemplate
	"

	self
		defineFunction: #OnPostEarly:EventStatus:
			argumentTypes: 'CDOIMessage* sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOINNTPOnPostEarly initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOINNTPOnPostEarly class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOINNTPOnPostEarly class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

