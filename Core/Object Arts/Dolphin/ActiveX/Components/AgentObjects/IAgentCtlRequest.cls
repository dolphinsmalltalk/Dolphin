"Filed out from Dolphin Smalltalk X6"!

IDispatch subclass: #IAgentCtlRequest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlRequest guid: (IID fromString: '{1DAB85C3-803A-11D0-AC63-00C04FD97575}')!
IAgentCtlRequest comment: '<IAgentCtlRequest> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlRequest'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlRequest Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlRequest categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlRequest methodsFor!

description
	"Answer the <bstr> value of the 'Description' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Description: answer.
	^answer asObject
!

get_Description: description
	"Private - Get the value of the 'Description' property of the receiver.
				HRESULT __stdcall Description(
			[out, retval] BSTR* Description);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall
!

get_ID: id
	"Private - Get the value of the 'ID' property of the receiver.
				HRESULT __stdcall ID(
			[out, retval] long* ID);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_Number: number
	"Private - Get the value of the 'Number' property of the receiver.
				HRESULT __stdcall Number(
			[out, retval] long* Number);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall
!

get_Status: status
	"Private - Get the value of the 'Status' property of the receiver.
				HRESULT __stdcall Status(
			[out, retval] long* Status);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

id
	"Answer the <sdword> value of the 'ID' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_ID: answer.
	^answer asObject
!

number
	"Answer the <sdword> value of the 'Number' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Number: answer.
	^answer asObject
!

status
	"Answer the <sdword> value of the 'Status' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Status: answer.
	^answer asObject
!

value
	"Answer the <sdword> value of the 'ID' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self id
! !
!IAgentCtlRequest categoriesFor: #description!**auto generated**!properties!public! !
!IAgentCtlRequest categoriesFor: #get_Description:!**auto generated**!COM Interfaces-IAgentCtlRequest!private! !
!IAgentCtlRequest categoriesFor: #get_ID:!**auto generated**!COM Interfaces-IAgentCtlRequest!private! !
!IAgentCtlRequest categoriesFor: #get_Number:!**auto generated**!COM Interfaces-IAgentCtlRequest!private! !
!IAgentCtlRequest categoriesFor: #get_Status:!**auto generated**!COM Interfaces-IAgentCtlRequest!private! !
!IAgentCtlRequest categoriesFor: #id!**auto generated**!properties!public! !
!IAgentCtlRequest categoriesFor: #number!**auto generated**!properties!public! !
!IAgentCtlRequest categoriesFor: #status!**auto generated**!properties!public! !
!IAgentCtlRequest categoriesFor: #value!**auto generated**!properties!public! !

!IAgentCtlRequest class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlRequest'
		IAgentCtlRequest defineTemplate"

	self
		defineFunction: #get_ID:
			argumentTypes: 'sdword*';
		defineFunction: #get_Status:
			argumentTypes: 'sdword*';
		defineFunction: #get_Description:
			argumentTypes: 'bstr*';
		defineFunction: #get_Number:
			argumentTypes: 'sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlRequest initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlRequest class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlRequest class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

