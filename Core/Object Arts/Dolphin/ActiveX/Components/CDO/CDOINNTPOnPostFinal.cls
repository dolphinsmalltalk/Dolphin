"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOINNTPOnPostFinal
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOINNTPOnPostFinal guid: (IID fromString: '{cd000028-8b95-11d1-82db-00c04fb1625d}')!
CDOINNTPOnPostFinal comment: '<CDOINNTPOnPostFinal> is a wrapper class for the COM interface ''CDO.INNTPOnPostFinal'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"The interface to implement when creating NNTP OnPostFinal event sinks"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOINNTPOnPostFinal categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOINNTPOnPostFinal methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

OnPostFinal: msg EventStatus: eventStatus
	"Invoke the OnPostFinal() method of the COM object wrapped by the receiver.
	Helpstring: 'Called by the NNTP event dispatcher after a posted message has been saved to its final location.'

		HRESULT __stdcall OnPostFinal(
			[in] IMessage* Msg,
			[in, out] CdoEventStatus* EventStatus);
	"

	<virtual stdcall: hresult 8 CDOIMessage* sdword*>
	^self invalidCall: _failureCode! !
!CDOINNTPOnPostFinal categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOINNTPOnPostFinal categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOINNTPOnPostFinal categoriesFor: #OnPostFinal:EventStatus:!**auto generated**!COM Interfaces-INNTPOnPostFinal!public! !

!CDOINNTPOnPostFinal class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.INNTPOnPostFinal'
		CDOINNTPOnPostFinal defineTemplate
	"

	self
		defineFunction: #OnPostFinal:EventStatus:
			argumentTypes: 'CDOIMessage* sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOINNTPOnPostFinal initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOINNTPOnPostFinal class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOINNTPOnPostFinal class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

