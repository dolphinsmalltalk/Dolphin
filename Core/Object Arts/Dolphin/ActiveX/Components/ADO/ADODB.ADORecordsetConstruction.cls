"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'ADODB.ADORecordsetConstruction'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.ADORecordsetConstruction guid: (OS.COM.IID fromString: '{00000283-0000-0010-8000-00aa006d2ea4}')!
ADODB.ADORecordsetConstruction comment: '`ADODBADORecordsetConstruction` is a wrapper class for the COM interface ''ADODB.ADORecordsetConstruction'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000283-0000-0010-8000-00aa006d2ea4), 
	hidden, 
	restricted
]
interface ADORecordsetConstruction : IDispatch
 {
	[id(0x60020000), propget]
	HRESULT __stdcall Rowset(
		[out, retval]IUnknown** ppRowset);
	[id(0x60020000), propput]
	HRESULT __stdcall Rowset(
		[in]IUnknown* ppRowset);
	[id(0x60020002), propget]
	HRESULT __stdcall Chapter(
		[out, retval]ADO_LONGPTR* plChapter);
	[id(0x60020002), propput]
	HRESULT __stdcall Chapter(
		[in]ADO_LONGPTR plChapter);
	[id(0x60020004), propget]
	HRESULT __stdcall RowPosition(
		[out, retval]IUnknown** ppRowPos);
	[id(0x60020004), propput]
	HRESULT __stdcall RowPosition(
		[in]IUnknown* ppRowPos);
};
```
'!
!ADODB.ADORecordsetConstruction categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.ADORecordsetConstruction methodsFor!

chapter
	"Answer the <sdword> value of the 'Chapter' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Chapter: answer.
	^answer asObject!

chapter: plChapter
	"Set the 'Chapter' property of the receiver to the <sdword> value of the argument."

	self put_Chapter: plChapter!

get_Chapter: plChapter
	"Private - Get the value of the 'Chapter' property of the receiver.

		HRESULT __stdcall Chapter(
			[out, retval]ADO_LONGPTR* plChapter);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_RowPosition: ppRowPos
	"Private - Get the value of the 'RowPosition' property of the receiver.

		HRESULT __stdcall RowPosition(
			[out, retval]IUnknown** ppRowPos);"

	<virtual stdcall: hresult 12 IUnknown**>
	^self invalidCall: _failureCode!

get_Rowset: ppRowset
	"Private - Get the value of the 'Rowset' property of the receiver.

		HRESULT __stdcall Rowset(
			[out, retval]IUnknown** ppRowset);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall: _failureCode!

put_Chapter: plChapter
	"Private - Set the value of the 'Chapter' property of the object wrapped by the 
	 receiver to the <sdword> argument, plChapter.

		HRESULT __stdcall Chapter(
			[in]ADO_LONGPTR plChapter);"

	<virtual stdcall: hresult 11 sdword>
	^self invalidCall: _failureCode!

put_RowPosition: ppRowPos
	"Private - Set the value of the 'RowPosition' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppRowPos.

		HRESULT __stdcall RowPosition(
			[in]IUnknown* ppRowPos);"

	<virtual stdcall: hresult 13 IUnknown*>
	^self invalidCall: _failureCode!

put_Rowset: ppRowset
	"Private - Set the value of the 'Rowset' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppRowset.

		HRESULT __stdcall Rowset(
			[in]IUnknown* ppRowset);"

	<virtual stdcall: hresult 9 IUnknown*>
	^self invalidCall: _failureCode!

rowPosition
	"Answer the <IUnknown> value of the 'RowPosition' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_RowPosition: answer.
	^answer asObject!

rowPosition: ppRowPos
	"Set the 'RowPosition' property of the receiver to the <IUnknown*> value of the argument."

	self put_RowPosition: ppRowPos!

rowset
	"Answer the <IUnknown> value of the 'Rowset' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_Rowset: answer.
	^answer asObject!

rowset: ppRowset
	"Set the 'Rowset' property of the receiver to the <IUnknown*> value of the argument."

	self put_Rowset: ppRowset! !
!ADODB.ADORecordsetConstruction categoriesFor: #chapter!**auto generated**!properties!public! !
!ADODB.ADORecordsetConstruction categoriesFor: #chapter:!**auto generated**!properties!public! !
!ADODB.ADORecordsetConstruction categoriesFor: #get_Chapter:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODB.ADORecordsetConstruction categoriesFor: #get_RowPosition:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODB.ADORecordsetConstruction categoriesFor: #get_Rowset:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODB.ADORecordsetConstruction categoriesFor: #put_Chapter:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODB.ADORecordsetConstruction categoriesFor: #put_RowPosition:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODB.ADORecordsetConstruction categoriesFor: #put_Rowset:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODB.ADORecordsetConstruction categoriesFor: #rowPosition!**auto generated**!properties!public! !
!ADODB.ADORecordsetConstruction categoriesFor: #rowPosition:!**auto generated**!properties!public! !
!ADODB.ADORecordsetConstruction categoriesFor: #rowset!**auto generated**!properties!public! !
!ADODB.ADORecordsetConstruction categoriesFor: #rowset:!**auto generated**!properties!public! !

!ADODB.ADORecordsetConstruction class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.ADORecordsetConstruction'
		ADORecordsetConstruction defineTemplate"

	self
		defineFunction: #get_Rowset:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_Rowset:
			argumentTypes: 'IUnknown*';
		defineFunction: #get_Chapter:
			argumentTypes: 'sdword*';
		defineFunction: #put_Chapter:
			argumentTypes: 'sdword';
		defineFunction: #get_RowPosition:
			argumentTypes: 'IUnknown**';
		defineFunction: #put_RowPosition:
			argumentTypes: 'IUnknown*'
! !
!ADODB.ADORecordsetConstruction class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

