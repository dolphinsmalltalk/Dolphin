"Filed out from Dolphin Smalltalk"!

IDispatch subclass: #IScriptModule
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSScriptControlConstants'
	classInstanceVariableNames: ''!

IScriptModule guid: (IID fromString: '{70841c70-067d-11d0-95d8-00a02463ab28}')!

IScriptModule comment: '<IScriptModule> is a wrapper class for the COM interface ''MSScriptControl.IScriptModule'' generated from type information in the ''Microsoft Script Control 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Context in which functions can be defined and expressions can be evaluated"
'!

!IScriptModule categoriesForClass!COM-Interfaces!MSScriptControl-Interfaces! !

!IScriptModule methodsFor!

addCode: code
	"Invoke the AddCode() method of the COM object.
	Helpstring: Add code to the module"

	^self AddCode: code
!

AddCode: code
	"Private - Invoke the AddCode() method of the COM object.
	Helpstring: Add code to the module

		HRESULT __stdcall AddCode(
			[in]BSTR Code);"

	<virtual stdcall: hresult 11 bstr>
	^self invalidCall: _failureCode!

codeObject
	"Answer the <IDispatch> value of the 'CodeObject' property of the receiver.
	Helpstring: Object exposed by the scripting engine that contains methods and properties defined in the code added to the module"

	| answer |
	answer := IDispatch newPointer.
	self get_CodeObject: answer.
	^answer asObject
!

eval: expression
	"Answer the <VARIANT> result of invoking the Eval() method of the COM object.
	Helpstring: Evaluate an expression within the context of the module"

	| answer |
	answer := VARIANT new.
	self
		Eval: expression
		pvarResult: answer.
	^answer asObject
!

Eval: expression pvarResult: pvarResult
	"Private - Invoke the Eval() method of the COM object.
	Helpstring: Evaluate an expression within the context of the module

		HRESULT __stdcall Eval(
			[in]BSTR Expression,
			[out, retval]VARIANT* pvarResult);"

	<virtual stdcall: hresult 12 bstr variant*>
	^self invalidCall: _failureCode!

executeStatement: statement
	"Invoke the ExecuteStatement() method of the COM object.
	Helpstring: Execute a statement within the context of the module"

	^self ExecuteStatement: statement
!

ExecuteStatement: statement
	"Private - Invoke the ExecuteStatement() method of the COM object.
	Helpstring: Execute a statement within the context of the module

		HRESULT __stdcall ExecuteStatement(
			[in]BSTR Statement);"

	<virtual stdcall: hresult 13 bstr>
	^self invalidCall: _failureCode!

get_CodeObject: ppdispObject
	"Private - Get the value of the 'CodeObject' property of the receiver.

		HRESULT __stdcall CodeObject(
			[out, retval]IDispatch** ppdispObject);"

	<virtual stdcall: hresult 9 IDispatch**>
	^self invalidCall: _failureCode!

get_Name: pbstrName
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval]BSTR* pbstrName);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

get_Procedures: ppdispProcedures
	"Private - Get the value of the 'Procedures' property of the receiver.

		HRESULT __stdcall Procedures(
			[out, retval]IScriptProcedureCollection** ppdispProcedures);"

	<virtual stdcall: hresult 10 IScriptProcedureCollection**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

name
	"Answer the <bstr> value of the 'Name' property of the receiver.
	Helpstring: Name of the module"

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject
!

procedures
	"Answer the <IScriptProcedureCollection> value of the 'Procedures' property of the receiver.
	Helpstring: Collection of procedures that are defined in the module"

	| answer |
	answer := IScriptProcedureCollection newPointer.
	self get_Procedures: answer.
	^answer asObject
!

run: procedureName parameters: parameters
	"Answer the <VARIANT> result of invoking the Run() method of the COM object.
	Helpstring: Call a procedure defined in the module"

	| answer |
	answer := VARIANT new.
	self
		Run: procedureName
		Parameters: parameters asSAFEARRAY
		pvarResult: answer.
	^answer asObject
!

Run: procedureName Parameters: parameters pvarResult: pvarResult
	"Private - Invoke the Run() method of the COM object.
	Helpstring: Call a procedure defined in the module

		HRESULT __stdcall Run(
			[in]BSTR ProcedureName,
			[in]SAFEARRAY(VARIANT)* Parameters,
			[out, retval]VARIANT* pvarResult);"

	<virtual stdcall: hresult 14 bstr SAFEARRAY** variant*>
	^self invalidCall: _failureCode!

value
	"Answer the <bstr> value of the 'Name' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self name
! !

!IScriptModule categoriesForMethods!
addCode:!**auto generated**!methods!public! !
AddCode:!**auto generated**!COM Interfaces-IScriptModule!private! !
codeObject!**auto generated**!properties!public! !
eval:!**auto generated**!methods!public! !
Eval:pvarResult:!**auto generated**!COM Interfaces-IScriptModule!private! !
executeStatement:!**auto generated**!methods!public! !
ExecuteStatement:!**auto generated**!COM Interfaces-IScriptModule!private! !
get_CodeObject:!**auto generated**!COM Interfaces-IScriptModule!private! !
get_Name:!**auto generated**!COM Interfaces-IScriptModule!private! !
get_Procedures:!**auto generated**!COM Interfaces-IScriptModule!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
name!**auto generated**!properties!public! !
procedures!**auto generated**!properties!public! !
run:parameters:!**auto generated**!methods!public! !
Run:Parameters:pvarResult:!**auto generated**!COM Interfaces-IScriptModule!private! !
value!**auto generated**!properties!public! !
!

!IScriptModule class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Module) for which the receiver is the default interface."

	^CLSID fromString: '{0E59F1DC-1FBE-11D0-8FF2-00A0D10038BC}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSScriptControl.IScriptModule'
		IScriptModule defineTemplate"

	self
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_CodeObject:
			argumentTypes: 'IDispatch**';
		defineFunction: #get_Procedures:
			argumentTypes: 'IScriptProcedureCollection**';
		defineFunction: #AddCode:
			argumentTypes: 'bstr';
		defineFunction: #Eval:pvarResult:
			argumentTypes: 'bstr variant*';
		defineFunction: #ExecuteStatement:
			argumentTypes: 'bstr';
		defineFunction: #Run:Parameters:pvarResult:
			argumentTypes: 'bstr SAFEARRAY** variant*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IScriptModule initializeTypeLib"

	typeLib := MSScriptControlLib! !

!IScriptModule class categoriesForMethods!
clsid!**auto generated**!constants!private! !
defineFunctions!**auto generated**!initializing!public! !
initializeTypeLib!**auto generated**!initializing!private! !
!

