"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'CDO.INNTPOnPostFinal'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

CDO.INNTPOnPostFinal guid: (OS.COM.IID fromString: '{cd000028-8b95-11d1-82db-00c04fb1625d}')!

CDO.INNTPOnPostFinal comment: '<CDO.INNTPOnPostFinal> is a wrapper class for the COM interface ''CDO.INNTPOnPostFinal'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"The interface to implement when creating NNTP OnPostFinal event sinks"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!

!CDO.INNTPOnPostFinal categoriesForClass!CDO-Interfaces!COM-Interfaces! !

!CDO.INNTPOnPostFinal methodsFor!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

OnPostFinal: msg EventStatus: eventStatus
	"Invoke the OnPostFinal() method of the COM object.
	Helpstring: Called by the NNTP event dispatcher after a posted message has been saved to its final location.

		HRESULT __stdcall OnPostFinal(
			[in]IMessage* Msg,
			[in, out]CdoEventStatus* EventStatus);"

	<virtual stdcall: hresult 8 IMessage* int32*>
	^self invalidCall: _failureCode! !

!CDO.INNTPOnPostFinal categoriesForMethods!
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
OnPostFinal:EventStatus:!**auto generated**!COM Interfaces-INNTPOnPostFinal!public! !
!

!CDO.INNTPOnPostFinal class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.INNTPOnPostFinal'
		INNTPOnPostFinal defineTemplate"

	self
		defineFunction: #OnPostFinal:EventStatus:
			argumentTypes: 'IMessage* sdword*'
! !

!CDO.INNTPOnPostFinal class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

