"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IScriptProcedureCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSScriptControlConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
IScriptProcedureCollection guid: (IID fromString: '{70841c71-067d-11d0-95d8-00a02463ab28}')!
IScriptProcedureCollection comment: '<IScriptProcedureCollection> is a wrapper class for the COM interface ''MSScriptControl.IScriptProcedureCollection'' generated from type information in the ''Microsoft Script Control 1.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"Collection of procedures"
'!
!IScriptProcedureCollection categoriesForClass!COM-Interfaces!MSScriptControl-Interfaces! !
!IScriptProcedureCollection methodsFor!

_newEnum
	"Answer the <IUnknown> value of the '_NewEnum' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get__NewEnum: answer.
	^answer asObject
!

count
	"Answer the <sdword> value of the 'Count' property of the receiver.
	Helpstring: Number of procedures"

	| answer |
	answer := (SDWORD new).
	self get_Count: answer.
	^answer asObject
!

get__NewEnum: ppenumProcedures
	"Private - Get the value of the '_NewEnum' property of the receiver.

		HRESULT __stdcall _NewEnum(
			[out, retval]IUnknown** ppenumProcedures);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall: _failureCode!

get_Count: plCount
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]long* plCount);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_Item: index ppdispProcedure: ppdispProcedure
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]VARIANT Index,
			[out, retval]IScriptProcedure** ppdispProcedure);"

	<virtual stdcall: hresult 9 variant IScriptProcedure**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^true!

item: index
	"Answer the <IScriptProcedure> value of the 'Item' property of the receiver.
	Helpstring: Get a procedure indexed by position or procedure name"

	| answer |
	answer := IScriptProcedure newPointer.
	self
		get_Item: index asVariant
		ppdispProcedure: answer.
	^answer asObject
! !
!IScriptProcedureCollection categoriesFor: #_newEnum!**auto generated**!properties!public! !
!IScriptProcedureCollection categoriesFor: #count!**auto generated**!properties!public! !
!IScriptProcedureCollection categoriesFor: #get__NewEnum:!**auto generated**!COM Interfaces-IScriptProcedureCollection!private! !
!IScriptProcedureCollection categoriesFor: #get_Count:!**auto generated**!COM Interfaces-IScriptProcedureCollection!private! !
!IScriptProcedureCollection categoriesFor: #get_Item:ppdispProcedure:!**auto generated**!COM Interfaces-IScriptProcedureCollection!private! !
!IScriptProcedureCollection categoriesFor: #isExtensible!**auto generated**!public!testing! !
!IScriptProcedureCollection categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!IScriptProcedureCollection categoriesFor: #item:!**auto generated**!properties!public! !

!IScriptProcedureCollection class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Procedures) for which the receiver is the default interface."

	^CLSID fromString: '{0E59F1DB-1FBE-11D0-8FF2-00A0D10038BC}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSScriptControl.IScriptProcedureCollection'
		IScriptProcedureCollection defineTemplate"

	self
		defineFunction: #get__NewEnum:
			argumentTypes: 'IUnknown**';
		defineFunction: #get_Item:ppdispProcedure:
			argumentTypes: 'variant IScriptProcedure**';
		defineFunction: #get_Count:
			argumentTypes: 'sdword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IScriptProcedureCollection initializeTypeLib"

	typeLib := MSScriptControlLib! !
!IScriptProcedureCollection class categoriesFor: #clsid!**auto generated**!constants!private! !
!IScriptProcedureCollection class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IScriptProcedureCollection class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

