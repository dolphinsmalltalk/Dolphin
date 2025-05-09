﻿"Filed out from Dolphin Smalltalk"!

UI.IAxWinAmbientDispatch
	subclass: #'UI.IAxWinAmbientDispatchEx'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.IAxWinAmbientDispatchEx guid: (OS.COM.IID fromString: '{b2d0778b-ac99-4c58-a5c8-e7724e5316b5}')!

UI.IAxWinAmbientDispatchEx comment: '<IAxWinAmbientDispatchEx> is a wrapper class for the COM interface ''ActiveXHost.IAxWinAmbientDispatchEx'' generated from type information in the ''Dolphin Smalltalk Active-X Host Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IAxWinAmbientDispatch Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(B2D0778B-AC99-4C58-A5C8-E7724E5316B5), 
	helpstring("IAxWinAmbientDispatch Interface"), 
	dual
]
interface IAxWinAmbientDispatchEx : IAxWinAmbientDispatch {
	[id(0x00000064)] 
	HRESULT __stdcall SetAmbientDispatch(
		[in] IDispatch* pDispatch);
};
'!

!UI.IAxWinAmbientDispatchEx categoriesForClass!ActiveXHost-Interfaces!COM-Interfaces! !

!UI.IAxWinAmbientDispatchEx methodsFor!

setAmbientDispatch: pDispatch
	"Invoke the SetAmbientDispatch() method of the COM object."

	^self SetAmbientDispatch: pDispatch
!

SetAmbientDispatch: pDispatch
	"Private - Invoke the SetAmbientDispatch() method of the COM object.

		HRESULT __stdcall SetAmbientDispatch(
			[in] IDispatch* pDispatch);"

	<virtual stdcall: hresult 36 IDispatch*>
	^self invalidCall: _failureCode! !

!UI.IAxWinAmbientDispatchEx categoriesForMethods!
setAmbientDispatch:!**auto generated**!methods!public! !
SetAmbientDispatch:!**auto generated**!COM Interfaces-IAxWinAmbientDispatchEx!private! !
!

!UI.IAxWinAmbientDispatchEx class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ActiveXHost.IAxWinAmbientDispatchEx'
		IAxWinAmbientDispatchEx defineTemplate"

	self
		defineFunction: #SetAmbientDispatch:
			argumentTypes: 'IDispatch*'
! !

!UI.IAxWinAmbientDispatchEx class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

