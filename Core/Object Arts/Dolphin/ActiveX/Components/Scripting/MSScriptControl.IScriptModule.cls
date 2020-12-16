"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSScriptControl.IScriptModule'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSScriptControl.IScriptModule guid: (OS.COM.IID fromString: '{70841c70-067d-11d0-95d8-00a02463ab28}')!
MSScriptControl.IScriptModule comment: '<IScriptModule> is a wrapper class for the COM interface ''MSScriptControl.IScriptModule'' generated from type information in the ''Microsoft Script Control 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Context in which functions can be defined and expressions can be evaluated"
'!
!MSScriptControl.IScriptModule categoriesForClass!COM-Interfaces!MSScriptControl-Interfaces! !
!MSScriptControl.IScriptModule methodsFor!

addCode: code
	"Invoke the AddCode() method of the COM object.
	Helpstring: Add code to the module"

	^self AddCode: code!

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
	^answer asObject!

eval: expression
	"Answer the <variant> result of invoking the Eval() method of the COM object.
	Helpstring: Evaluate an expression within the context of the module"

	| answer |
	answer := VARIANT new.
	self Eval: expression pvarResult: answer.
	^answer asObject!

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

	^self ExecuteStatement: statement!

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
	^answer asObject!

procedures
	"Answer the <IScriptProcedureCollection> value of the 'Procedures' property of the receiver.
	Helpstring: Collection of procedures that are defined in the module"

	| answer |
	answer := IScriptProcedureCollection newPointer.
	self get_Procedures: answer.
	^answer asObject!

run: procedureName parameters: parameters
	"Answer the <variant> result of invoking the Run() method of the COM object.
	Helpstring: Call a procedure defined in the module"

	| answer |
	answer := VARIANT new.
	self
		Run: procedureName
		Parameters: parameters asSAFEARRAY
		pvarResult: answer.
	^answer asObject!

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

	^self name! !
!MSScriptControl.IScriptModule categoriesFor: #addCode:!**auto generated**!methods!public! !
!MSScriptControl.IScriptModule categoriesFor: #AddCode:!**auto generated**!COM Interfaces-IScriptModule!private! !
!MSScriptControl.IScriptModule categoriesFor: #codeObject!**auto generated**!properties!public! !
!MSScriptControl.IScriptModule categoriesFor: #eval:!**auto generated**!methods!public! !
!MSScriptControl.IScriptModule categoriesFor: #Eval:pvarResult:!**auto generated**!COM Interfaces-IScriptModule!private! !
!MSScriptControl.IScriptModule categoriesFor: #executeStatement:!**auto generated**!methods!public! !
!MSScriptControl.IScriptModule categoriesFor: #ExecuteStatement:!**auto generated**!COM Interfaces-IScriptModule!private! !
!MSScriptControl.IScriptModule categoriesFor: #get_CodeObject:!**auto generated**!COM Interfaces-IScriptModule!private! !
!MSScriptControl.IScriptModule categoriesFor: #get_Name:!**auto generated**!COM Interfaces-IScriptModule!private! !
!MSScriptControl.IScriptModule categoriesFor: #get_Procedures:!**auto generated**!COM Interfaces-IScriptModule!private! !
!MSScriptControl.IScriptModule categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSScriptControl.IScriptModule categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSScriptControl.IScriptModule categoriesFor: #name!**auto generated**!properties!public! !
!MSScriptControl.IScriptModule categoriesFor: #procedures!**auto generated**!properties!public! !
!MSScriptControl.IScriptModule categoriesFor: #run:parameters:!**auto generated**!methods!public! !
!MSScriptControl.IScriptModule categoriesFor: #Run:Parameters:pvarResult:!**auto generated**!COM Interfaces-IScriptModule!private! !
!MSScriptControl.IScriptModule categoriesFor: #value!**auto generated**!properties!public! !

!MSScriptControl.IScriptModule class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Module) for which the receiver is the default interface."

	^CLSID fromString: '{0e59f1dc-1fbe-11d0-8ff2-00a0d10038bc}'
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
!MSScriptControl.IScriptModule class categoriesFor: #clsid!**auto generated**!constants!private! !
!MSScriptControl.IScriptModule class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !
!MSScriptControl.IScriptModule class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

