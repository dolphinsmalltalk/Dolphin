"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSScriptControl.IScriptProcedure'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSScriptControl.IScriptProcedure guid: (OS.COM.IID fromString: '{70841c73-067d-11d0-95d8-00a02463ab28}')!
MSScriptControl.IScriptProcedure comment: '<IScriptProcedure> is a wrapper class for the COM interface ''MSScriptControl.IScriptProcedure'' generated from type information in the ''Microsoft Script Control 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Describes a procedure"
'!
!MSScriptControl.IScriptProcedure categoriesForClass!COM-Interfaces!MSScriptControl-Interfaces! !
!MSScriptControl.IScriptProcedure methodsFor!

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
	answer := VARIANT_BOOL new.
	self get_HasReturnValue: answer.
	^answer asObject!

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
	^answer asObject!

numArgs
	"Answer the <sdword> value of the 'NumArgs' property of the receiver.
	Helpstring: Number of arguments that are expected"

	| answer |
	answer := SDWORD new.
	self get_NumArgs: answer.
	^answer asObject!

value
	"Answer the <bstr> value of the 'Name' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self name! !
!MSScriptControl.IScriptProcedure categoriesFor: #get_HasReturnValue:!**auto generated**!COM Interfaces-IScriptProcedure!private! !
!MSScriptControl.IScriptProcedure categoriesFor: #get_Name:!**auto generated**!COM Interfaces-IScriptProcedure!private! !
!MSScriptControl.IScriptProcedure categoriesFor: #get_NumArgs:!**auto generated**!COM Interfaces-IScriptProcedure!private! !
!MSScriptControl.IScriptProcedure categoriesFor: #hasReturnValue!**auto generated**!properties!public! !
!MSScriptControl.IScriptProcedure categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSScriptControl.IScriptProcedure categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSScriptControl.IScriptProcedure categoriesFor: #name!**auto generated**!properties!public! !
!MSScriptControl.IScriptProcedure categoriesFor: #numArgs!**auto generated**!properties!public! !
!MSScriptControl.IScriptProcedure categoriesFor: #value!**auto generated**!properties!public! !

!MSScriptControl.IScriptProcedure class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Procedure) for which the receiver is the default interface."

	^CLSID fromString: '{0e59f1da-1fbe-11d0-8ff2-00a0d10038bc}'
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
!MSScriptControl.IScriptProcedure class categoriesFor: #clsid!**auto generated**!constants!private! !
!MSScriptControl.IScriptProcedure class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !
!MSScriptControl.IScriptProcedure class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

