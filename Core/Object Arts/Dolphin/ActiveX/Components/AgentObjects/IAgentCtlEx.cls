"Filed out from Dolphin Smalltalk X6"!

IAgentCtl subclass: #IAgentCtlEx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlEx guid: (IID fromString: '{8563FF20-8ECC-11D1-B9B4-00C04FD97575}')!
IAgentCtlEx comment: '<IAgentCtlEx> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlEx'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlEx Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlEx categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlEx methodsFor!

get_RaiseRequestErrors: raiseErrors
	"Private - Get the value of the 'RaiseRequestErrors' property of the receiver.
				HRESULT __stdcall RaiseRequestErrors(
			[out, retval] VARIANT_BOOL* RaiseErrors);"

	<virtual stdcall: hresult 17 varbool*>
	^self invalidCall
!

put_RaiseRequestErrors: raiseErrors
	"Private - Set the value of the 'RaiseRequestErrors' property of the object wrapped by the 
	 receiver to the <varbool> argument, raiseErrors.
				HRESULT __stdcall RaiseRequestErrors(
			[in] VARIANT_BOOL RaiseErrors);"

	<virtual stdcall: hresult 18 varbool>
	^self invalidCall
!

raiseRequestErrors
	"Answer the <varbool> value of the 'RaiseRequestErrors' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_RaiseRequestErrors: answer.
	^answer asObject
!

raiseRequestErrors: raiseErrors
	"Set the 'RaiseRequestErrors' property of the receiver to the <varbool> value of the argument."

	self put_RaiseRequestErrors: raiseErrors
!

showDefaultCharacterProperties
	"Invoke the ShowDefaultCharacterProperties() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 showDefaultCharacterProperties: VARIANT unspecified
		 y: VARIANT unspecified!

showDefaultCharacterProperties: x y: y
	"Invoke the ShowDefaultCharacterProperties() method of the COM object."

	^self
		ShowDefaultCharacterProperties: x asVariant
		y: y asVariant
!

ShowDefaultCharacterProperties: x y: y
	"Private - Invoke the ShowDefaultCharacterProperties() method of the COM object.

		HRESULT __stdcall ShowDefaultCharacterProperties(
			[in, optional] VARIANT x,
			[in, optional] VARIANT y);"

	<virtual stdcall: hresult 16 variant variant>
	^self invalidCall
! !
!IAgentCtlEx categoriesFor: #get_RaiseRequestErrors:!**auto generated**!COM Interfaces-IAgentCtlEx!private! !
!IAgentCtlEx categoriesFor: #put_RaiseRequestErrors:!**auto generated**!COM Interfaces-IAgentCtlEx!private! !
!IAgentCtlEx categoriesFor: #raiseRequestErrors!**auto generated**!properties!public! !
!IAgentCtlEx categoriesFor: #raiseRequestErrors:!**auto generated**!properties!public! !
!IAgentCtlEx categoriesFor: #showDefaultCharacterProperties!**auto generated**!methods!public! !
!IAgentCtlEx categoriesFor: #showDefaultCharacterProperties:y:!**auto generated**!methods!public! !
!IAgentCtlEx categoriesFor: #ShowDefaultCharacterProperties:y:!**auto generated**!COM Interfaces-IAgentCtlEx!private! !

!IAgentCtlEx class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Agent) for which the receiver is the default interface."

	^CLSID fromString: '{D45FD31B-5C6E-11D1-9EC1-00C04FD7081F}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlEx'
		IAgentCtlEx defineTemplate"

	self
		defineFunction: #ShowDefaultCharacterProperties:y:
			argumentTypes: 'variant variant';
		defineFunction: #get_RaiseRequestErrors:
			argumentTypes: 'varbool*';
		defineFunction: #put_RaiseRequestErrors:
			argumentTypes: 'varbool'
! !
!IAgentCtlEx class categoriesFor: #clsid!**auto generated**!constants!private! !
!IAgentCtlEx class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

