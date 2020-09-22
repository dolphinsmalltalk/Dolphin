"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ADODBADOStreamConstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODBADOStreamConstruction guid: (IID fromString: '{00000568-0000-0010-8000-00aa006d2ea4}')!
ADODBADOStreamConstruction comment: '`ADODBADOStreamConstruction` is a wrapper class for the COM interface ''ADODB.ADOStreamConstruction'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000568-0000-0010-8000-00aa006d2ea4), 
	restricted
]
interface ADOStreamConstruction : IDispatch
 {
	[id(0x60020000), propget]
	HRESULT __stdcall Stream(
		[out, retval]IUnknown** ppStm);
	[id(0x60020000), propput]
	HRESULT __stdcall Stream(
		[in]IUnknown* ppStm);
};
```
'!
!ADODBADOStreamConstruction categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBADOStreamConstruction methodsFor!

get_Stream: ppStm
	"Private - Get the value of the 'Stream' property of the receiver.

		HRESULT __stdcall Stream(
			[out, retval]IUnknown** ppStm);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall: _failureCode!

put_Stream: ppStm
	"Private - Set the value of the 'Stream' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppStm.

		HRESULT __stdcall Stream(
			[in]IUnknown* ppStm);"

	<virtual stdcall: hresult 9 IUnknown*>
	^self invalidCall: _failureCode!

stream
	"Answer the <IUnknown> value of the 'Stream' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_Stream: answer.
	^answer asObject!

stream: ppStm
	"Set the 'Stream' property of the receiver to the <IUnknown*> value of the argument."

	self put_Stream: ppStm! !
!ADODBADOStreamConstruction categoriesFor: #get_Stream:!**auto generated**!COM Interfaces-ADOStreamConstruction!private! !
!ADODBADOStreamConstruction categoriesFor: #put_Stream:!**auto generated**!COM Interfaces-ADOStreamConstruction!private! !
!ADODBADOStreamConstruction categoriesFor: #stream!**auto generated**!properties!public! !
!ADODBADOStreamConstruction categoriesFor: #stream:!**auto generated**!properties!public! !

!ADODBADOStreamConstruction class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.ADOStreamConstruction'
		ADODBADOStreamConstruction defineTemplate"

	self
		defineFunction: #get_Stream:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_Stream:
			argumentTypes: 'IUnknown*'
! !
!ADODBADOStreamConstruction class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

