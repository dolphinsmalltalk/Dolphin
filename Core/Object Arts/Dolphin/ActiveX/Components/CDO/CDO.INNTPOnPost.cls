"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOINNTPOnPost
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOINNTPOnPost guid: (IID fromString: '{cd000027-8b95-11d1-82db-00c04fb1625d}')!
CDOINNTPOnPost comment: '<CDOINNTPOnPost> is a wrapper class for the COM interface ''CDO.INNTPOnPost'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"The interface to implement when creating NNTP OnPost event sinks"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOINNTPOnPost categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOINNTPOnPost methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

OnPost: msg EventStatus: eventStatus
	"Invoke the OnPost() method of the COM object wrapped by the receiver.
	Helpstring: 'Called by the NNTP event dispatcher when a message is posted.'

		HRESULT __stdcall OnPost(
			[in] IMessage* Msg,
			[in, out] CdoEventStatus* EventStatus);
	"

	<virtual stdcall: hresult 8 CDOIMessage* sdword*>
	^self invalidCall: _failureCode! !
!CDOINNTPOnPost categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOINNTPOnPost categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOINNTPOnPost categoriesFor: #OnPost:EventStatus:!**auto generated**!COM Interfaces-INNTPOnPost!public! !

!CDOINNTPOnPost class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.INNTPOnPost'
		CDOINNTPOnPost defineTemplate
	"

	self
		defineFunction: #OnPost:EventStatus:
			argumentTypes: 'CDOIMessage* sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOINNTPOnPost initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOINNTPOnPost class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOINNTPOnPost class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

