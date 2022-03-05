"Filed out from Dolphin Smalltalk"!

IDispatch subclass: #IScriptProcedure
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSScriptControlConstants'
	classInstanceVariableNames: ''!
IScriptProcedure guid: (IID fromString: '{70841c73-067d-11d0-95d8-00a02463ab28}')!
IScriptProcedure comment: '<IScriptProcedure> is a wrapper class for the COM interface ''MSScriptControl.IScriptProcedure'' generated from type information in the ''Microsoft Script Control 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Describes a procedure"
'!
!IScriptProcedure categoriesForClass!COM-Interfaces!MSScriptControl-Interfaces! !
!IScriptProcedure methodsFor!

get_HasReturnValue: pfHasReturnValue
	"Private - Get the value of the 'HasReturnValue' property of the receiver.

		HRESULT __stdcall HasReturnValue(
			[out, retval]VARIANT_BOOL* pfHasReturnValue);"

	<virtual stdcall: hresult 10 varbool*>
	^self invalidCall: _failureCode!

get_Name: pbstrName
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval]BSTR* pbstrName);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

get_NumArgs: pcArgs
	"Private - Get the value of the 'NumArgs' property of the receiver.

		HRESULT __stdcall NumArgs(
			[out, retval]long* pcArgs);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

hasReturnValue
	"Answer the <varbool> value of the 'HasReturnValue' property of the receiver.
	Helpstring: True if procedure returns a value"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_HasReturnValue: answer.
	^answer asObject
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

name
	"Answer the <bstr> value of the 'Name' property of the receiver.
	Helpstring: Name of the procedure"

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject
!

numArgs
	"Answer the <sdword> value of the 'NumArgs' property of the receiver.
	Helpstring: Number of arguments that are expected"

	| answer |
	answer := (SDWORD new).
	self get_NumArgs: answer.
	^answer asObject
!

value
	"Answer the <bstr> value of the 'Name' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self name
! !
!IScriptProcedure categoriesForMethods!
get_HasReturnValue:!**auto generated**!COM Interfaces-IScriptProcedure!private! !
get_Name:!**auto generated**!COM Interfaces-IScriptProcedure!private! !
get_NumArgs:!**auto generated**!COM Interfaces-IScriptProcedure!private! !
hasReturnValue!**auto generated**!properties!public! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
name!**auto generated**!properties!public! !
numArgs!**auto generated**!properties!public! !
value!**auto generated**!properties!public! !
!

!IScriptProcedure class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Procedure) for which the receiver is the default interface."

	^CLSID fromString: '{0E59F1DA-1FBE-11D0-8FF2-00A0D10038BC}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSScriptControl.IScriptProcedure'
		IScriptProcedure defineTemplate"

	self
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_NumArgs:
			argumentTypes: 'sdword*';
		defineFunction: #get_HasReturnValue:
			argumentTypes: 'varbool*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IScriptProcedure initializeTypeLib"

	typeLib := MSScriptControlLib! !
!IScriptProcedure class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!public! !
initializeTypeLib!**auto generated**!initializing!private! !
!

