"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ADODBADORecordConstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODBADORecordConstruction guid: (IID fromString: '{00000567-0000-0010-8000-00aa006d2ea4}')!
ADODBADORecordConstruction comment: '`ADODBADORecordConstruction` is a wrapper class for the COM interface ''ADODB.ADORecordConstruction'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000567-0000-0010-8000-00aa006d2ea4), 
	restricted
]
interface ADORecordConstruction : IDispatch
 {
	[id(0x60020000), propget]
	HRESULT __stdcall Row(
		[out, retval]IUnknown** ppRow);
	[id(0x60020000), propput]
	HRESULT __stdcall Row(
		[in]IUnknown* ppRow);
	[id(0x60020002), propput]
	HRESULT __stdcall ParentRow(
		[in]IUnknown* arg1);
};
```
'!
!ADODBADORecordConstruction categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBADORecordConstruction methodsFor!

get_Row: ppRow
	"Private - Get the value of the 'Row' property of the receiver.

		HRESULT __stdcall Row(
			[out, retval]IUnknown** ppRow);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall: _failureCode!

parentRow: arg1
	"Set the 'ParentRow' property of the receiver to the <IUnknown*> value of the argument."

	self put_ParentRow: arg1!

put_ParentRow: arg1
	"Private - Set the value of the 'ParentRow' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, arg1.

		HRESULT __stdcall ParentRow(
			[in]IUnknown* arg1);"

	<virtual stdcall: hresult 10 IUnknown*>
	^self invalidCall: _failureCode!

put_Row: ppRow
	"Private - Set the value of the 'Row' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppRow.

		HRESULT __stdcall Row(
			[in]IUnknown* ppRow);"

	<virtual stdcall: hresult 9 IUnknown*>
	^self invalidCall: _failureCode!

row
	"Answer the <IUnknown> value of the 'Row' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_Row: answer.
	^answer asObject!

row: ppRow
	"Set the 'Row' property of the receiver to the <IUnknown*> value of the argument."

	self put_Row: ppRow! !
!ADODBADORecordConstruction categoriesFor: #get_Row:!**auto generated**!COM Interfaces-ADORecordConstruction!private! !
!ADODBADORecordConstruction categoriesFor: #parentRow:!**auto generated**!properties!public! !
!ADODBADORecordConstruction categoriesFor: #put_ParentRow:!**auto generated**!COM Interfaces-ADORecordConstruction!private! !
!ADODBADORecordConstruction categoriesFor: #put_Row:!**auto generated**!COM Interfaces-ADORecordConstruction!private! !
!ADODBADORecordConstruction categoriesFor: #row!**auto generated**!properties!public! !
!ADODBADORecordConstruction categoriesFor: #row:!**auto generated**!properties!public! !

!ADODBADORecordConstruction class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.ADORecordConstruction'
		ADODBADORecordConstruction defineTemplate"

	self
		defineFunction: #get_Row:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_Row:
			argumentTypes: 'IUnknown*';
		defineFunction: #put_ParentRow:
			argumentTypes: 'IUnknown*'
! !
!ADODBADORecordConstruction class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

