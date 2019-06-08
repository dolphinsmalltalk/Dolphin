"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ADODBADORecordsetConstruction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBADORecordsetConstruction guid: (IID fromString: '{00000283-0000-0010-8000-00AA006D2EA4}')!
ADODBADORecordsetConstruction comment: '<ADODBADORecordsetConstruction> is a wrapper class for the COM interface ''ADODB.ADORecordsetConstruction'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBADORecordsetConstruction categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBADORecordsetConstruction methodsFor!

chapter
	"Answer the <sdword> value of the 'Chapter' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_Chapter: answer.
	^answer asObject
!

chapter: plChapter
	"Set the 'Chapter' property of the receiver to the <sdword> value of the argument."

	self put_Chapter: plChapter
!

get_Chapter: plChapter
	"Private - Get the value of the 'Chapter' property of the receiver.
				HRESULT __stdcall Chapter(
			[out, retval] long* plChapter);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_RowPosition: ppRowPos
	"Private - Get the value of the 'RowPosition' property of the receiver.
				HRESULT __stdcall RowPosition(
			[out, retval] IUnknown** ppRowPos);"

	<virtual stdcall: hresult 12 IUnknown**>
	^self invalidCall: _failureCode!

get_Rowset: ppRowset
	"Private - Get the value of the 'Rowset' property of the receiver.
				HRESULT __stdcall Rowset(
			[out, retval] IUnknown** ppRowset);"

	<virtual stdcall: hresult 8 IUnknown**>
	^self invalidCall: _failureCode!

put_Chapter: plChapter
	"Private - Set the value of the 'Chapter' property of the object wrapped by the 
	 receiver to the <sdword> argument, plChapter.
				HRESULT __stdcall Chapter(
			[in] long plChapter);"

	<virtual stdcall: hresult 11 sdword>
	^self invalidCall: _failureCode!

put_RowPosition: ppRowPos
	"Private - Set the value of the 'RowPosition' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppRowPos.
				HRESULT __stdcall RowPosition(
			[in] IUnknown* ppRowPos);"

	<virtual stdcall: hresult 13 IUnknown*>
	^self invalidCall: _failureCode!

put_Rowset: ppRowset
	"Private - Set the value of the 'Rowset' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppRowset.
				HRESULT __stdcall Rowset(
			[in] IUnknown* ppRowset);"

	<virtual stdcall: hresult 9 IUnknown*>
	^self invalidCall: _failureCode!

rowPosition
	"Answer the <IUnknown> value of the 'RowPosition' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_RowPosition: answer.
	^answer asObject
!

rowPosition: ppRowPos
	"Set the 'RowPosition' property of the receiver to the <IUnknown*> value of the argument."

	self put_RowPosition: ppRowPos
!

rowset
	"Answer the <IUnknown> value of the 'Rowset' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_Rowset: answer.
	^answer asObject
!

rowset: ppRowset
	"Set the 'Rowset' property of the receiver to the <IUnknown*> value of the argument."

	self put_Rowset: ppRowset
! !
!ADODBADORecordsetConstruction categoriesFor: #chapter!**auto generated**!properties!public! !
!ADODBADORecordsetConstruction categoriesFor: #chapter:!**auto generated**!properties!public! !
!ADODBADORecordsetConstruction categoriesFor: #get_Chapter:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODBADORecordsetConstruction categoriesFor: #get_RowPosition:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODBADORecordsetConstruction categoriesFor: #get_Rowset:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODBADORecordsetConstruction categoriesFor: #put_Chapter:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODBADORecordsetConstruction categoriesFor: #put_RowPosition:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODBADORecordsetConstruction categoriesFor: #put_Rowset:!**auto generated**!COM Interfaces-ADORecordsetConstruction!private! !
!ADODBADORecordsetConstruction categoriesFor: #rowPosition!**auto generated**!properties!public! !
!ADODBADORecordsetConstruction categoriesFor: #rowPosition:!**auto generated**!properties!public! !
!ADODBADORecordsetConstruction categoriesFor: #rowset!**auto generated**!properties!public! !
!ADODBADORecordsetConstruction categoriesFor: #rowset:!**auto generated**!properties!public! !

!ADODBADORecordsetConstruction class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.ADORecordsetConstruction'
		ADODBADORecordsetConstruction defineTemplate"

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
!ADODBADORecordsetConstruction class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

