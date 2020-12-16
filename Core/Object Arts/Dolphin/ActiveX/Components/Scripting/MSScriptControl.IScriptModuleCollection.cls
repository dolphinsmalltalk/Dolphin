"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSScriptControl.IScriptModuleCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSScriptControl.IScriptModuleCollection guid: (OS.COM.IID fromString: '{70841c6f-067d-11d0-95d8-00a02463ab28}')!
MSScriptControl.IScriptModuleCollection comment: '<IScriptModuleCollection> is a wrapper class for the COM interface ''MSScriptControl.IScriptModuleCollection'' generated from type information in the ''Microsoft Script Control 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Collection of modules"
'!
!MSScriptControl.IScriptModuleCollection categoriesForClass!COM-Interfaces!MSScriptControl-Interfaces! !
!MSScriptControl.IScriptModuleCollection methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject!

add: name
	"Answer the <IScriptModule> result of invoking the Add() method of the COM object.
	Default values are passed for all optional parameters."

	^self add: name object: VARIANT unspecified!

add: name object: object
	"Answer the <IScriptModule> result of invoking the Add() method of the COM object.
	Helpstring: Add a new module"

	| answer |
	answer := IScriptModule newPointer.
	self
		Add: name
		Object: object asVariant
		ppmod: answer.
	^answer asObject!

Add: name Object: object ppmod: ppmod
	"Private - Invoke the Add() method of the COM object.
	Helpstring: Add a new module

		HRESULT __stdcall Add(
			[in]BSTR Name,
			[in, optional]VARIANT* Object,
			[out, retval]IScriptModule** ppmod);"

	<virtual stdcall: hresult 11 bstr variant* IScriptModule**>
	^self invalidCall: _failureCode!

count
	"Answer the <sdword> value of the 'Count' property of the receiver.
	Helpstring: Number of modules"

	| answer |
	answer := SDWORD new.
	self get_Count: answer.
	^answer asObject!

get__NewEnum: ppenumContexts
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval]IUnknown** ppenumContexts);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall: _failureCode!

get_Count: plCount
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]long* plCount);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_Item: index ppmod: ppmod
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]VARIANT Index,
			[out, retval]IScriptModule** ppmod);"

	<virtual stdcall: hresult 9 variant IScriptModule**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <IScriptModule> value of the 'Item' property of the receiver.
	Helpstring: Get a module indexed by position or module name"

	| answer |
	answer := IScriptModule newPointer.
	self get_Item: index asVariant ppmod: answer.
	^answer asObject! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #_newEnum!**auto generated**!properties!public! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #add:!**auto generated**!methods!public! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #add:object:!**auto generated**!methods!public! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #Add:Object:ppmod:!**auto generated**!COM Interfaces-IScriptModuleCollection!private! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #count!**auto generated**!properties!public! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-IScriptModuleCollection!private! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #get_Count:!**auto generated**!COM Interfaces-IScriptModuleCollection!private! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #get_Item:ppmod:!**auto generated**!COM Interfaces-IScriptModuleCollection!private! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSScriptControl.IScriptModuleCollection categoriesFor: #item:!**auto generated**!properties!public! !

!MSScriptControl.IScriptModuleCollection class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Modules) for which the receiver is the default interface."

	^CLSID fromString: '{0e59f1dd-1fbe-11d0-8ff2-00a0d10038bc}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSScriptControl.IScriptModuleCollection'
		IScriptModuleCollection defineTemplate"

	self
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #get_Item:ppmod:
			argumentTypes: 'variant IScriptModule**';
		defineFunction: #get_Count:
			argumentTypes: 'sdword*';
		defineFunction: #Add:Object:ppmod:
			argumentTypes: 'bstr variant* IScriptModule**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IScriptModuleCollection initializeTypeLib"

	typeLib := MSScriptControlLib! !
!MSScriptControl.IScriptModuleCollection class categoriesFor: #clsid!**auto generated**!constants!private! !
!MSScriptControl.IScriptModuleCollection class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !
!MSScriptControl.IScriptModuleCollection class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

