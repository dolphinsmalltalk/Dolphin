﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'ADODB.RecordsetEventsVt'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

ADODB.RecordsetEventsVt guid: (OS.COM.IID fromString: '{00001403-0000-0010-8000-00aa006d2ea4}')!

ADODB.RecordsetEventsVt comment: '`RecordsetEventsVt` is a wrapper class for the COM interface ''ADODB.RecordsetEventsVt'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001403-0000-0010-8000-00aa006d2ea4), 
	hidden
]
interface RecordsetEventsVt : IUnknown
 {
	[id(0x00000009), helpcontext(0x0012d377)]
	HRESULT __stdcall WillChangeField(
		[in]long cFields,
		[in]VARIANT Fields,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x0000000a), helpcontext(0x000f4244)]
	HRESULT __stdcall FieldChangeComplete(
		[in]long cFields,
		[in]VARIANT Fields,
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x0000000b), helpcontext(0x0012d378)]
	HRESULT __stdcall WillChangeRecord(
		[in]EventReasonEnum adReason,
		[in]long cRecords,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x0000000c), helpcontext(0x000f4245)]
	HRESULT __stdcall RecordChangeComplete(
		[in]EventReasonEnum adReason,
		[in]long cRecords,
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x0000000d), helpcontext(0x0012d379)]
	HRESULT __stdcall WillChangeRecordset(
		[in]EventReasonEnum adReason,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x0000000e), helpcontext(0x000f4246)]
	HRESULT __stdcall RecordsetChangeComplete(
		[in]EventReasonEnum adReason,
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x0000000f), helpcontext(0x0012d376)]
	HRESULT __stdcall WillMove(
		[in]EventReasonEnum adReason,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x00000010), helpcontext(0x000f4247)]
	HRESULT __stdcall MoveComplete(
		[in]EventReasonEnum adReason,
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x00000011), helpcontext(0x0012d37a)]
	HRESULT __stdcall EndOfRecordset(
		[in, out]VARIANT_BOOL* fMoreData,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x00000012), helpcontext(0x0012d47d)]
	HRESULT __stdcall FetchProgress(
		[in]long Progress,
		[in]long MaxProgress,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
	[id(0x00000013), helpcontext(0x0012d47e)]
	HRESULT __stdcall FetchComplete(
		[in]Error* pError,
		[in, out]EventStatusEnum* adStatus,
		[in]_Recordset* pRecordset);
};
```
'!

!ADODB.RecordsetEventsVt categoriesForClass!ADODB-Interfaces!COM-Interfaces! !

!ADODB.RecordsetEventsVt methodsFor!

endOfRecordset: fMoreData adStatus: adStatus pRecordset: pRecordset
	"Invoke the EndOfRecordset() method of the COM object."

	| outputs |
	outputs := {VARIANT_BOOL new
					value: fMoreData;
					yourself.
				Int32 new
					value: adStatus;
					yourself}.
	self
		EndOfRecordset: (outputs basicAt: 1)
		adStatus: (outputs basicAt: 2)
		pRecordset: pRecordset.
	^outputs collect: [:each | each asObject]!

EndOfRecordset: fMoreData adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the EndOfRecordset() method of the COM object.

		HRESULT __stdcall EndOfRecordset(
			[in, out]VARIANT_BOOL* fMoreData,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 12 varbool* int32* _Recordset*>
	^self invalidCall: _failureCode!

fetchComplete: pError adStatus: adStatus pRecordset: pRecordset
	"Invoke the FetchComplete() method of the COM object."

	^self
		FetchComplete: pError
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

FetchComplete: pError adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the FetchComplete() method of the COM object.

		HRESULT __stdcall FetchComplete(
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 14 Error* int32* _Recordset*>
	^self invalidCall: _failureCode!

fetchProgress: progress maxProgress: maxProgress adStatus: adStatus pRecordset: pRecordset
	"Invoke the FetchProgress() method of the COM object."

	^self
		FetchProgress: progress
		MaxProgress: maxProgress
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

FetchProgress: progress MaxProgress: maxProgress adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the FetchProgress() method of the COM object.

		HRESULT __stdcall FetchProgress(
			[in]long Progress,
			[in]long MaxProgress,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 13 int32 int32 int32* _Recordset*>
	^self invalidCall: _failureCode!

fieldChangeComplete: cFields fields: fields pError: pError adStatus: adStatus pRecordset: pRecordset
	"Invoke the FieldChangeComplete() method of the COM object."

	^self
		FieldChangeComplete: cFields
		Fields: fields asVariant
		pError: pError
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

FieldChangeComplete: cFields Fields: fields pError: pError adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the FieldChangeComplete() method of the COM object.

		HRESULT __stdcall FieldChangeComplete(
			[in]long cFields,
			[in]VARIANT Fields,
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 5 int32 variant Error* int32* _Recordset*>
	^self invalidCall: _failureCode!

moveComplete: adReason pError: pError adStatus: adStatus pRecordset: pRecordset
	"Invoke the MoveComplete() method of the COM object."

	^self
		MoveComplete: adReason
		pError: pError
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

MoveComplete: adReason pError: pError adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the MoveComplete() method of the COM object.

		HRESULT __stdcall MoveComplete(
			[in]EventReasonEnum adReason,
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 11 int32 Error* int32* _Recordset*>
	^self invalidCall: _failureCode!

recordChangeComplete: adReason cRecords: cRecords pError: pError adStatus: adStatus pRecordset: pRecordset
	"Invoke the RecordChangeComplete() method of the COM object."

	^self
		RecordChangeComplete: adReason
		cRecords: cRecords
		pError: pError
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

RecordChangeComplete: adReason cRecords: cRecords pError: pError adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the RecordChangeComplete() method of the COM object.

		HRESULT __stdcall RecordChangeComplete(
			[in]EventReasonEnum adReason,
			[in]long cRecords,
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 7 int32 int32 Error* int32* _Recordset*>
	^self invalidCall: _failureCode!

recordsetChangeComplete: adReason pError: pError adStatus: adStatus pRecordset: pRecordset
	"Invoke the RecordsetChangeComplete() method of the COM object."

	^self
		RecordsetChangeComplete: adReason
		pError: pError
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

RecordsetChangeComplete: adReason pError: pError adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the RecordsetChangeComplete() method of the COM object.

		HRESULT __stdcall RecordsetChangeComplete(
			[in]EventReasonEnum adReason,
			[in]Error* pError,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 9 int32 Error* int32* _Recordset*>
	^self invalidCall: _failureCode!

willChangeField: cFields fields: fields adStatus: adStatus pRecordset: pRecordset
	"Invoke the WillChangeField() method of the COM object."

	^self
		WillChangeField: cFields
		Fields: fields asVariant
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

WillChangeField: cFields Fields: fields adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the WillChangeField() method of the COM object.

		HRESULT __stdcall WillChangeField(
			[in]long cFields,
			[in]VARIANT Fields,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 4 int32 variant int32* _Recordset*>
	^self invalidCall: _failureCode!

willChangeRecord: adReason cRecords: cRecords adStatus: adStatus pRecordset: pRecordset
	"Invoke the WillChangeRecord() method of the COM object."

	^self
		WillChangeRecord: adReason
		cRecords: cRecords
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

WillChangeRecord: adReason cRecords: cRecords adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the WillChangeRecord() method of the COM object.

		HRESULT __stdcall WillChangeRecord(
			[in]EventReasonEnum adReason,
			[in]long cRecords,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 6 int32 int32 int32* _Recordset*>
	^self invalidCall: _failureCode!

willChangeRecordset: adReason adStatus: adStatus pRecordset: pRecordset
	"Invoke the WillChangeRecordset() method of the COM object."

	^self
		WillChangeRecordset: adReason
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

WillChangeRecordset: adReason adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the WillChangeRecordset() method of the COM object.

		HRESULT __stdcall WillChangeRecordset(
			[in]EventReasonEnum adReason,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 8 int32 int32* _Recordset*>
	^self invalidCall: _failureCode!

willMove: adReason adStatus: adStatus pRecordset: pRecordset
	"Invoke the WillMove() method of the COM object."

	^self
		WillMove: adReason
		adStatus: (Int32 new
				value: adStatus;
				yourself)
		pRecordset: pRecordset!

WillMove: adReason adStatus: adStatus pRecordset: pRecordset
	"Private - Invoke the WillMove() method of the COM object.

		HRESULT __stdcall WillMove(
			[in]EventReasonEnum adReason,
			[in, out]EventStatusEnum* adStatus,
			[in]_Recordset* pRecordset);"

	<virtual stdcall: hresult 10 int32 int32* _Recordset*>
	^self invalidCall: _failureCode! !

!ADODB.RecordsetEventsVt categoriesForMethods!
endOfRecordset:adStatus:pRecordset:!**auto generated**!methods!public! !
EndOfRecordset:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
fetchComplete:adStatus:pRecordset:!**auto generated**!methods!public! !
FetchComplete:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
fetchProgress:maxProgress:adStatus:pRecordset:!**auto generated**!methods!public! !
FetchProgress:MaxProgress:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
fieldChangeComplete:fields:pError:adStatus:pRecordset:!**auto generated**!methods!public! !
FieldChangeComplete:Fields:pError:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
moveComplete:pError:adStatus:pRecordset:!**auto generated**!methods!public! !
MoveComplete:pError:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
recordChangeComplete:cRecords:pError:adStatus:pRecordset:!**auto generated**!methods!public! !
RecordChangeComplete:cRecords:pError:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
recordsetChangeComplete:pError:adStatus:pRecordset:!**auto generated**!methods!public! !
RecordsetChangeComplete:pError:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
willChangeField:fields:adStatus:pRecordset:!**auto generated**!methods!public! !
WillChangeField:Fields:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
willChangeRecord:cRecords:adStatus:pRecordset:!**auto generated**!methods!public! !
WillChangeRecord:cRecords:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
willChangeRecordset:adStatus:pRecordset:!**auto generated**!methods!public! !
WillChangeRecordset:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
willMove:adStatus:pRecordset:!**auto generated**!methods!public! !
WillMove:adStatus:pRecordset:!**auto generated**!COM Interfaces-RecordsetEventsVt!private! !
!

!ADODB.RecordsetEventsVt class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.RecordsetEventsVt'
		RecordsetEventsVt defineTemplate"

	self
		defineFunction: #WillChangeField:Fields:adStatus:pRecordset:
			argumentTypes: 'sdword variant sdword* _Recordset*';
		defineFunction: #FieldChangeComplete:Fields:pError:adStatus:pRecordset:
			argumentTypes: 'sdword variant Error* sdword* _Recordset*';
		defineFunction: #WillChangeRecord:cRecords:adStatus:pRecordset:
			argumentTypes: 'sdword sdword sdword* _Recordset*';
		defineFunction: #RecordChangeComplete:cRecords:pError:adStatus:pRecordset:
			argumentTypes: 'sdword sdword Error* sdword* _Recordset*';
		defineFunction: #WillChangeRecordset:adStatus:pRecordset:
			argumentTypes: 'sdword sdword* _Recordset*';
		defineFunction: #RecordsetChangeComplete:pError:adStatus:pRecordset:
			argumentTypes: 'sdword Error* sdword* _Recordset*';
		defineFunction: #WillMove:adStatus:pRecordset:
			argumentTypes: 'sdword sdword* _Recordset*';
		defineFunction: #MoveComplete:pError:adStatus:pRecordset:
			argumentTypes: 'sdword Error* sdword* _Recordset*';
		defineFunction: #EndOfRecordset:adStatus:pRecordset:
			argumentTypes: 'varbool* sdword* _Recordset*';
		defineFunction: #FetchProgress:MaxProgress:adStatus:pRecordset:
			argumentTypes: 'sdword sdword sdword* _Recordset*';
		defineFunction: #FetchComplete:adStatus:pRecordset:
			argumentTypes: 'Error* sdword* _Recordset*'
! !

!ADODB.RecordsetEventsVt class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

