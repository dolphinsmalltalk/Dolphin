"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSScriptControl.IScriptControl'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSScriptControl.IScriptControl guid: (OS.COM.IID fromString: '{0e59f1d3-1fbe-11d0-8ff2-00a0d10038bc}')!
MSScriptControl.IScriptControl comment: '<IScriptControl> is a wrapper class for the COM interface ''MSScriptControl.IScriptControl'' generated from type information in the ''Microsoft Script Control 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Control to host scripting engines that understand the ActiveX Scripting interface"'!
!MSScriptControl.IScriptControl categoriesForClass!COM-Interfaces!MSScriptControl-Interfaces! !
!MSScriptControl.IScriptControl methodsFor!

_aboutBox
	"Invoke the _AboutBox() method of the COM object."

	^self _AboutBox!

_AboutBox
	"Private - Invoke the _AboutBox() method of the COM object.

		HRESULT __stdcall _AboutBox();"

	<virtual stdcall: hresult 24>
	^self invalidCall: _failureCode!

addCode: code
	"Invoke the AddCode() method of the COM object.
	Helpstring: Add code to the global module"

	^self AddCode: code!

AddCode: code
	"Private - Invoke the AddCode() method of the COM object.
	Helpstring: Add code to the global module

		HRESULT __stdcall AddCode(
			[in]BSTR Code);"

	<virtual stdcall: hresult 27 bstr>
	^self invalidCall: _failureCode!

addObject: name object: object
	"Invoke the AddObject() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		addObject: name
		object: object
		addMembers: false!

addObject: name object: object addMembers: addMembers
	"Invoke the AddObject() method of the COM object.
	Helpstring: Add an object to the global namespace of the scripting engine"

	^self
		AddObject: name
		Object: object
		AddMembers: addMembers!

AddObject: name Object: object AddMembers: addMembers
	"Private - Invoke the AddObject() method of the COM object.
	Helpstring: Add an object to the global namespace of the scripting engine

		HRESULT __stdcall AddObject(
			[in]BSTR Name,
			[in]IDispatch* Object,
			[in, defaultvalue(false)]VARIANT_BOOL AddMembers);"

	<virtual stdcall: hresult 25 bstr IDispatch* varbool>
	^self invalidCall: _failureCode!

allowUI
	"Answer the <varbool> value of the 'AllowUI' property of the receiver.
	Helpstring: Enable or disable display of the UI"

	| answer |
	answer := VARIANT_BOOL new.
	self get_AllowUI: answer.
	^answer asObject!

allowUI: pfAllowUI
	"Set the 'AllowUI' property of the receiver to the <varbool> value of the argument.
	Helpstring: Enable or disable display of the UI"

	self put_AllowUI: pfAllowUI!

codeObject
	"Answer the <IDispatch> value of the 'CodeObject' property of the receiver.
	Helpstring: Object exposed by the scripting engine that contains methods and properties defined in the code added to the global module"

	| answer |
	answer := IDispatch newPointer.
	self get_CodeObject: answer.
	^answer asObject!

error
	"Answer the <IScriptError> value of the 'Error' property of the receiver.
	Helpstring: The last error reported by the scripting engine"

	| answer |
	answer := IScriptError newPointer.
	self get_Error: answer.
	^answer asObject!

eval: expression
	"Answer the <variant> result of invoking the Eval() method of the COM object.
	Helpstring: Evaluate an expression within the context of the global module"

	| answer |
	answer := VARIANT new.
	self Eval: expression pvarResult: answer.
	^answer asObject!

Eval: expression pvarResult: pvarResult
	"Private - Invoke the Eval() method of the COM object.
	Helpstring: Evaluate an expression within the context of the global module

		HRESULT __stdcall Eval(
			[in]BSTR Expression,
			[out, retval]VARIANT* pvarResult);"

	<virtual stdcall: hresult 28 bstr variant*>
	^self invalidCall: _failureCode!

executeStatement: statement
	"Invoke the ExecuteStatement() method of the COM object.
	Helpstring: Execute a statement within the context of the global module"

	^self ExecuteStatement: statement!

ExecuteStatement: statement
	"Private - Invoke the ExecuteStatement() method of the COM object.
	Helpstring: Execute a statement within the context of the global module

		HRESULT __stdcall ExecuteStatement(
			[in]BSTR Statement);"

	<virtual stdcall: hresult 29 bstr>
	^self invalidCall: _failureCode!

get_AllowUI: pfAllowUI
	"Private - Get the value of the 'AllowUI' property of the receiver.

		HRESULT __stdcall AllowUI(
			[out, retval]VARIANT_BOOL* pfAllowUI);"

	<virtual stdcall: hresult 16 varbool*>
	^self invalidCall: _failureCode!

get_CodeObject: ppdispObject
	"Private - Get the value of the 'CodeObject' property of the receiver.

		HRESULT __stdcall CodeObject(
			[out, retval]IDispatch** ppdispObject);"

	<virtual stdcall: hresult 22 IDispatch**>
	^self invalidCall: _failureCode!

get_Error: ppse
	"Private - Get the value of the 'Error' property of the receiver.

		HRESULT __stdcall Error(
			[out, retval]IScriptError** ppse);"

	<virtual stdcall: hresult 21 IScriptError**>
	^self invalidCall: _failureCode!

get_Language: pbstrLanguage
	"Private - Get the value of the 'Language' property of the receiver.

		HRESULT __stdcall Language(
			[out, retval]BSTR* pbstrLanguage);"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

get_Modules: ppmods
	"Private - Get the value of the 'Modules' property of the receiver.

		HRESULT __stdcall Modules(
			[out, retval]IScriptModuleCollection** ppmods);"

	<virtual stdcall: hresult 20 IScriptModuleCollection**>
	^self invalidCall: _failureCode!

get_Procedures: ppdispProcedures
	"Private - Get the value of the 'Procedures' property of the receiver.

		HRESULT __stdcall Procedures(
			[out, retval]IScriptProcedureCollection** ppdispProcedures);"

	<virtual stdcall: hresult 23 IScriptProcedureCollection**>
	^self invalidCall: _failureCode!

get_SitehWnd: phwnd
	"Private - Get the value of the 'SitehWnd' property of the receiver.

		HRESULT __stdcall SitehWnd(
			[out, retval]long* phwnd);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall: _failureCode!

get_State: pssState
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]ScriptControlStates* pssState);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_Timeout: plMilleseconds
	"Private - Get the value of the 'Timeout' property of the receiver.

		HRESULT __stdcall Timeout(
			[out, retval]long* plMilleseconds);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall: _failureCode!

get_UseSafeSubset: pfUseSafeSubset
	"Private - Get the value of the 'UseSafeSubset' property of the receiver.

		HRESULT __stdcall UseSafeSubset(
			[out, retval]VARIANT_BOOL* pfUseSafeSubset);"

	<virtual stdcall: hresult 18 varbool*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

language
	"Answer the <bstr> value of the 'Language' property of the receiver.
	Helpstring: Language engine to use"

	| answer |
	answer := BSTR new.
	self get_Language: answer.
	^answer asObject!

language: pbstrLanguage
	"Set the 'Language' property of the receiver to the <bstr> value of the argument.
	Helpstring: Language engine to use"

	self put_Language: pbstrLanguage!

modules
	"Answer the <IScriptModuleCollection> value of the 'Modules' property of the receiver.
	Helpstring: Collection of modules for the ScriptControl"

	| answer |
	answer := IScriptModuleCollection newPointer.
	self get_Modules: answer.
	^answer asObject!

procedures
	"Answer the <IScriptProcedureCollection> value of the 'Procedures' property of the receiver.
	Helpstring: Collection of procedures that are defined in the global module"

	| answer |
	answer := IScriptProcedureCollection newPointer.
	self get_Procedures: answer.
	^answer asObject!

put_AllowUI: pfAllowUI
	"Private - Set the value of the 'AllowUI' property of the object wrapped by the 
	 receiver to the <varbool> argument, pfAllowUI.

		HRESULT __stdcall AllowUI(
			[in]VARIANT_BOOL pfAllowUI);"

	<virtual stdcall: hresult 17 varbool>
	^self invalidCall: _failureCode!

put_Language: pbstrLanguage
	"Private - Set the value of the 'Language' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrLanguage.

		HRESULT __stdcall Language(
			[in]BSTR pbstrLanguage);"

	<virtual stdcall: hresult 9 bstr>
	^self invalidCall: _failureCode!

put_SitehWnd: phwnd
	"Private - Set the value of the 'SitehWnd' property of the object wrapped by the 
	 receiver to the <sdword> argument, phwnd.

		HRESULT __stdcall SitehWnd(
			[in]long phwnd);"

	<virtual stdcall: hresult 12 sdword>
	^self invalidCall: _failureCode!

put_State: pssState
	"Private - Set the value of the 'State' property of the object wrapped by the 
	 receiver to the <sdword> argument, pssState.

		HRESULT __stdcall State(
			[in]ScriptControlStates pssState);"

	<virtual stdcall: hresult 11 sdword>
	^self invalidCall: _failureCode!

put_Timeout: plMilleseconds
	"Private - Set the value of the 'Timeout' property of the object wrapped by the 
	 receiver to the <sdword> argument, plMilleseconds.

		HRESULT __stdcall Timeout(
			[in]long plMilleseconds);"

	<virtual stdcall: hresult 15 sdword>
	^self invalidCall: _failureCode!

put_UseSafeSubset: pfUseSafeSubset
	"Private - Set the value of the 'UseSafeSubset' property of the object wrapped by the 
	 receiver to the <varbool> argument, pfUseSafeSubset.

		HRESULT __stdcall UseSafeSubset(
			[in]VARIANT_BOOL pfUseSafeSubset);"

	<virtual stdcall: hresult 19 varbool>
	^self invalidCall: _failureCode!

reset
	"Invoke the Reset() method of the COM object.
	Helpstring: Reset the scripting engine to a newly created state"

	^self Reset!

Reset
	"Private - Invoke the Reset() method of the COM object.
	Helpstring: Reset the scripting engine to a newly created state

		HRESULT __stdcall Reset();"

	<virtual stdcall: hresult 26>
	^self invalidCall: _failureCode!

run: procedureName parameters: parameters
	"Answer the <variant> result of invoking the Run() method of the COM object.
	Helpstring: Call a procedure defined in the global module"

	| answer |
	answer := VARIANT new.
	self
		Run: procedureName
		Parameters: parameters asSAFEARRAY
		pvarResult: answer.
	^answer asObject!

Run: procedureName Parameters: parameters pvarResult: pvarResult
	"Private - Invoke the Run() method of the COM object.
	Helpstring: Call a procedure defined in the global module

		HRESULT __stdcall Run(
			[in]BSTR ProcedureName,
			[in]SAFEARRAY(VARIANT)* Parameters,
			[out, retval]VARIANT* pvarResult);"

	<virtual stdcall: hresult 30 bstr SAFEARRAY** variant*>
	^self invalidCall: _failureCode!

sitehWnd
	"Answer the <sdword> value of the 'SitehWnd' property of the receiver.
	Helpstring: hWnd used as a parent for displaying UI"

	| answer |
	answer := SDWORD new.
	self get_SitehWnd: answer.
	^answer asObject!

sitehWnd: phwnd
	"Set the 'SitehWnd' property of the receiver to the <sdword> value of the argument.
	Helpstring: hWnd used as a parent for displaying UI"

	self put_SitehWnd: phwnd!

state
	"Answer the <sdword> value of the 'State' property of the receiver.
	Helpstring: State of the control"

	| answer |
	answer := SDWORD new.
	self get_State: answer.
	^answer asObject!

state: pssState
	"Set the 'State' property of the receiver to the <sdword> value of the argument.
	Helpstring: State of the control"

	self put_State: pssState!

timeout
	"Answer the <sdword> value of the 'Timeout' property of the receiver.
	Helpstring: Length of time in milliseconds that a script can execute before being considered hung"

	| answer |
	answer := SDWORD new.
	self get_Timeout: answer.
	^answer asObject!

timeout: plMilleseconds
	"Set the 'Timeout' property of the receiver to the <sdword> value of the argument.
	Helpstring: Length of time in milliseconds that a script can execute before being considered hung"

	self put_Timeout: plMilleseconds!

useSafeSubset
	"Answer the <varbool> value of the 'UseSafeSubset' property of the receiver.
	Helpstring: Force script to execute in safe mode and disallow potentially harmful actions"

	| answer |
	answer := VARIANT_BOOL new.
	self get_UseSafeSubset: answer.
	^answer asObject!

useSafeSubset: pfUseSafeSubset
	"Set the 'UseSafeSubset' property of the receiver to the <varbool> value of the argument.
	Helpstring: Force script to execute in safe mode and disallow potentially harmful actions"

	self put_UseSafeSubset: pfUseSafeSubset! !
!MSScriptControl.IScriptControl categoriesFor: #_aboutBox!**auto generated**!methods!public! !
!MSScriptControl.IScriptControl categoriesFor: #_AboutBox!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #addCode:!**auto generated**!methods!public! !
!MSScriptControl.IScriptControl categoriesFor: #AddCode:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #addObject:object:!**auto generated**!methods!public! !
!MSScriptControl.IScriptControl categoriesFor: #addObject:object:addMembers:!**auto generated**!methods!public! !
!MSScriptControl.IScriptControl categoriesFor: #AddObject:Object:AddMembers:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #allowUI!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #allowUI:!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #codeObject!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #error!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #eval:!**auto generated**!methods!public! !
!MSScriptControl.IScriptControl categoriesFor: #Eval:pvarResult:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #executeStatement:!**auto generated**!methods!public! !
!MSScriptControl.IScriptControl categoriesFor: #ExecuteStatement:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_AllowUI:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_CodeObject:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_Error:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_Language:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_Modules:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_Procedures:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_SitehWnd:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_State:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_Timeout:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #get_UseSafeSubset:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSScriptControl.IScriptControl categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSScriptControl.IScriptControl categoriesFor: #language!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #language:!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #modules!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #procedures!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #put_AllowUI:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #put_Language:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #put_SitehWnd:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #put_State:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #put_Timeout:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #put_UseSafeSubset:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #reset!**auto generated**!methods!public! !
!MSScriptControl.IScriptControl categoriesFor: #Reset!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #run:parameters:!**auto generated**!methods!public! !
!MSScriptControl.IScriptControl categoriesFor: #Run:Parameters:pvarResult:!**auto generated**!COM Interfaces-IScriptControl!private! !
!MSScriptControl.IScriptControl categoriesFor: #sitehWnd!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #sitehWnd:!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #state!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #state:!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #timeout!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #timeout:!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #useSafeSubset!**auto generated**!properties!public! !
!MSScriptControl.IScriptControl categoriesFor: #useSafeSubset:!**auto generated**!properties!public! !

!MSScriptControl.IScriptControl class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (ScriptControl) for which the receiver is the default interface."

	^CLSID fromString: '{0e59f1d5-1fbe-11d0-8ff2-00a0d10038bc}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSScriptControl.IScriptControl'
		IScriptControl defineTemplate"

	self
		defineFunction: #get_Language:
			argumentTypes: 'bstr*';
		defineFunction: #put_Language:
			argumentTypes: 'bstr';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #put_State:
			argumentTypes: 'sdword';
		defineFunction: #put_SitehWnd:
			argumentTypes: 'sdword';
		defineFunction: #get_SitehWnd:
			argumentTypes: 'sdword*';
		defineFunction: #get_Timeout:
			argumentTypes: 'sdword*';
		defineFunction: #put_Timeout:
			argumentTypes: 'sdword';
		defineFunction: #get_AllowUI:
			argumentTypes: 'varbool*';
		defineFunction: #put_AllowUI:
			argumentTypes: 'varbool';
		defineFunction: #get_UseSafeSubset:
			argumentTypes: 'varbool*';
		defineFunction: #put_UseSafeSubset:
			argumentTypes: 'varbool';
		defineFunction: #get_Modules:
			argumentTypes: 'IScriptModuleCollection**';
		defineFunction: #get_Error:
			argumentTypes: 'IScriptError**';
		defineFunction: #get_CodeObject:
			argumentTypes: 'IDispatch**';
		defineFunction: #get_Procedures:
			argumentTypes: 'IScriptProcedureCollection**';
		defineFunction: #_AboutBox;
		defineFunction: #AddObject:Object:AddMembers:
			argumentTypes: 'bstr IDispatch* varbool';
		defineFunction: #Reset;
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
		IScriptControl initializeTypeLib"

	typeLib := MSScriptControlLib! !
!MSScriptControl.IScriptControl class categoriesFor: #clsid!**auto generated**!constants!private! !
!MSScriptControl.IScriptControl class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !
!MSScriptControl.IScriptControl class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

