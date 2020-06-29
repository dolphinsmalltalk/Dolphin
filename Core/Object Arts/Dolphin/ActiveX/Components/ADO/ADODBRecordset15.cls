"Filed out from Dolphin Smalltalk 7"!

ADODB_ADO subclass: #ADODBRecordset15
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODBRecordset15 guid: (IID fromString: '{0000150e-0000-0010-8000-00aa006d2ea4}')!
ADODBRecordset15 comment: '`ADODBRecordset15` is a wrapper class for the COM interface ''ADODB.Recordset15'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0000150e-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c903), 
	hidden, 
	nonextensible, 
	dual
]
interface Recordset15 : _ADO
 {
	[id(0x000003e8), propget, helpcontext(0x0012c905)]
	HRESULT __stdcall AbsolutePosition(
		[out, retval]PositionEnum* pl);
	[id(0x000003e8), propput, helpcontext(0x0012c905)]
	HRESULT __stdcall AbsolutePosition(
		[in]PositionEnum pl);
	[id(0x000003e9), propputref, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[in]IDispatch* pvar);
	[id(0x000003e9), propput, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[in]VARIANT pvar);
	[id(0x000003e9), propget, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[out, retval]VARIANT* pvar);
	[id(0x000003ea), propget, helpcontext(0x0012c910)]
	HRESULT __stdcall BOF(
		[out, retval]VARIANT_BOOL* pb);
	[id(0x000003eb), propget, helpcontext(0x0012c911)]
	HRESULT __stdcall Bookmark(
		[out, retval]VARIANT* pvBookmark);
	[id(0x000003eb), propput, helpcontext(0x0012c911)]
	HRESULT __stdcall Bookmark(
		[in]VARIANT pvBookmark);
	[id(0x000003ec), propget, helpcontext(0x0012c912)]
	HRESULT __stdcall CacheSize(
		[out, retval]long* pl);
	[id(0x000003ec), propput, helpcontext(0x0012c912)]
	HRESULT __stdcall CacheSize(
		[in]long pl);
	[id(0x000003ed), propget, helpcontext(0x0012c91c)]
	HRESULT __stdcall CursorType(
		[out, retval]CursorTypeEnum* plCursorType);
	[id(0x000003ed), propput, helpcontext(0x0012c91c)]
	HRESULT __stdcall CursorType(
		[in]CursorTypeEnum plCursorType);
	[id(0x000003ee), propget, helpcontext(0x000f4250)]
	HRESULT __stdcall EOF(
		[out, retval]VARIANT_BOOL* pb);
	[id(0000000000), propget, helpcontext(0x0012c8fe)]
	HRESULT __stdcall Fields(
		[out, retval]Fields** ppvObject);
	[id(0x000003f0), propget, helpcontext(0x0012c92b)]
	HRESULT __stdcall LockType(
		[out, retval]LockTypeEnum* plLockType);
	[id(0x000003f0), propput, helpcontext(0x0012c92b)]
	HRESULT __stdcall LockType(
		[in]LockTypeEnum plLockType);
	[id(0x000003f1), propget, helpcontext(0x0012c92d)]
	HRESULT __stdcall MaxRecords(
		[out, retval]long* plMaxRecords);
	[id(0x000003f1), propput, helpcontext(0x0012c92d)]
	HRESULT __stdcall MaxRecords(
		[in]long plMaxRecords);
	[id(0x000003f2), propget, helpcontext(0x0012c93b)]
	HRESULT __stdcall RecordCount(
		[out, retval]long* pl);
	[id(0x000003f3), propputref, helpcontext(0x0012c945)]
	HRESULT __stdcall Source(
		[in]IDispatch* pvSource);
	[id(0x000003f3), propput, helpcontext(0x0012c945)]
	HRESULT __stdcall Source(
		[in]BSTR pvSource);
	[id(0x000003f3), propget, helpcontext(0x0012c945)]
	HRESULT __stdcall Source(
		[out, retval]VARIANT* pvSource);
	[id(0x000003f4), helpcontext(0x0012c8b4)]
	HRESULT __stdcall AddNew(
		[in, optional]VARIANT FieldList,
		[in, optional]VARIANT Values);
	[id(0x000003f5), helpcontext(0x0012c8bb)]
	HRESULT __stdcall CancelUpdate();
	[id(0x000003f6), helpcontext(0x0012c8bf)]
	HRESULT __stdcall Close();
	[id(0x000003f7), helpcontext(0x0012c8ca)]
	HRESULT __stdcall Delete(
		[in, defaultvalue(1)]AffectEnum AffectRecords);
	[id(0x000003f8), helpcontext(0x0012c8cf)]
	HRESULT __stdcall GetRows(
		[in, defaultvalue(-1)]long Rows,
		[in, optional]VARIANT Start,
		[in, optional]VARIANT Fields,
		[out, retval]VARIANT* pvar);
	[id(0x000003f9), helpcontext(0x0012c8d2)]
	HRESULT __stdcall Move(
		[in]long NumRecords,
		[in, optional]VARIANT Start);
	[id(0x000003fa), helpcontext(0x000f424b)]
	HRESULT __stdcall MoveNext();
	[id(0x000003fb), helpcontext(0x000f424c)]
	HRESULT __stdcall MovePrevious();
	[id(0x000003fc), helpcontext(0x0012c8d3)]
	HRESULT __stdcall MoveFirst();
	[id(0x000003fd), helpcontext(0x000f424a)]
	HRESULT __stdcall MoveLast();
	[id(0x000003fe), helpcontext(0x0012c8d7)]
	HRESULT __stdcall Open(
		[in, optional]VARIANT Source,
		[in, optional]VARIANT ActiveConnection,
		[in, defaultvalue(-1)]CursorTypeEnum CursorType,
		[in, defaultvalue(-1)]LockTypeEnum LockType,
		[in, defaultvalue(-1)]long Options);
	[id(0x000003ff), helpcontext(0x0012c8dc)]
	HRESULT __stdcall Requery(
		[in, defaultvalue(-1)]long Options);
	[id(0x60030022), hidden]
	HRESULT __stdcall _xResync(
		[in, defaultvalue(3)]AffectEnum AffectRecords);
	[id(0x00000401), helpcontext(0x0012c8e2)]
	HRESULT __stdcall Update(
		[in, optional]VARIANT Fields,
		[in, optional]VARIANT Values);
	[id(0x00000417), propget, helpcontext(0x0012c904)]
	HRESULT __stdcall AbsolutePage(
		[out, retval]PositionEnum* pl);
	[id(0x00000417), propput, helpcontext(0x0012c904)]
	HRESULT __stdcall AbsolutePage(
		[in]PositionEnum pl);
	[id(0x00000402), propget, helpcontext(0x0012c921)]
	HRESULT __stdcall EditMode(
		[out, retval]EditModeEnum* pl);
	[id(0x00000406), propget, helpcontext(0x0012c924)]
	HRESULT __stdcall Filter(
		[out, retval]VARIANT* Criteria);
	[id(0x00000406), propput, helpcontext(0x0012c924)]
	HRESULT __stdcall Filter(
		[in]VARIANT Criteria);
	[id(0x0000041a), propget, helpcontext(0x0012c935)]
	HRESULT __stdcall PageCount(
		[out, retval]long* pl);
	[id(0x00000418), propget, helpcontext(0x0012c936)]
	HRESULT __stdcall PageSize(
		[out, retval]long* pl);
	[id(0x00000418), propput, helpcontext(0x0012c936)]
	HRESULT __stdcall PageSize(
		[in]long pl);
	[id(0x00000407), propget, helpcontext(0x0012c941)]
	HRESULT __stdcall Sort(
		[out, retval]BSTR* Criteria);
	[id(0x00000407), propput, helpcontext(0x0012c941)]
	HRESULT __stdcall Sort(
		[in]BSTR Criteria);
	[id(0x00000405), propget, helpcontext(0x0012c949)]
	HRESULT __stdcall Status(
		[out, retval]long* pl);
	[id(0x0000041e), propget, helpcontext(0x0012c948)]
	HRESULT __stdcall State(
		[out, retval]long* plObjState);
	[id(0x60030030), hidden]
	HRESULT __stdcall _xClone(
		[out, retval]_Recordset** ppvObject);
	[id(0x0000040b), helpcontext(0x0012c8e3)]
	HRESULT __stdcall UpdateBatch(
		[in, defaultvalue(3)]AffectEnum AffectRecords);
	[id(0x00000419), helpcontext(0x0012c8ba)]
	HRESULT __stdcall CancelBatch(
		[in, defaultvalue(3)]AffectEnum AffectRecords);
	[id(0x0000041b), propget, helpcontext(0x0012c91b)]
	HRESULT __stdcall CursorLocation(
		[out, retval]CursorLocationEnum* plCursorLoc);
	[id(0x0000041b), propput, helpcontext(0x0012c91b)]
	HRESULT __stdcall CursorLocation(
		[in]CursorLocationEnum plCursorLoc);
	[id(0x0000041c), helpcontext(0x0012c8d5)]
	HRESULT __stdcall NextRecordset(
		[out, optional]VARIANT* RecordsAffected,
		[out, retval]_Recordset** ppiRs);
	[id(0x0000040c), helpcontext(0x0012c8e1)]
	HRESULT __stdcall Supports(
		[in]CursorOptionEnum CursorOptions,
		[out, retval]VARIANT_BOOL* pb);
	[id(0xfffffff8), hidden, propget]
	HRESULT __stdcall Collect(
		[in]VARIANT Index,
		[out, retval]VARIANT* pvar);
	[id(0xfffffff8), hidden, propput]
	HRESULT __stdcall Collect(
		[in]VARIANT Index,
		[in]VARIANT pvar);
	[id(0x0000041d), propget, helpcontext(0x0012c92c)]
	HRESULT __stdcall MarshalOptions(
		[out, retval]MarshalOptionsEnum* peMarshal);
	[id(0x0000041d), propput, helpcontext(0x0012c92c)]
	HRESULT __stdcall MarshalOptions(
		[in]MarshalOptionsEnum peMarshal);
	[id(0x00000422), helpcontext(0x0012c8cd)]
	HRESULT __stdcall Find(
		[in]BSTR Criteria,
		[in, defaultvalue(0)]long SkipRecords,
		[in, defaultvalue(1)]SearchDirectionEnum SearchDirection,
		[in, optional]VARIANT Start);
};
```
'!
!ADODBRecordset15 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBRecordset15 methodsFor!

_xClone
	"Answer the <ADODB_Recordset> result of invoking the _xClone() method of the COM object."

	| answer |
	answer := ADODB_Recordset newPointer.
	self _xClone: answer.
	^answer asObject!

_xClone: ppvObject
	"Private - Invoke the _xClone() method of the COM object.

		HRESULT __stdcall _xClone(
			[out, retval]_Recordset** ppvObject);"

	<virtual stdcall: hresult 57 ADODB_Recordset**>
	^self invalidCall: _failureCode!

_xResync
	"Invoke the _xResync() method of the COM object.
	Default values are passed for all optional parameters."

	^self _xResync: 3!

_xResync: affectRecords
	"Invoke the _xResync() method of the COM object.

		HRESULT __stdcall _xResync(
			[in, defaultvalue(3)]AffectEnum AffectRecords);"

	<virtual stdcall: hresult 43 sdword>
	^self invalidCall: _failureCode!

absolutePage
	"Answer the <sdword> value of the 'AbsolutePage' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_AbsolutePage: answer.
	^answer asObject!

absolutePage: pl
	"Set the 'AbsolutePage' property of the receiver to the <sdword> value of the argument."

	self put_AbsolutePage: pl!

absolutePosition
	"Answer the <sdword> value of the 'AbsolutePosition' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_AbsolutePosition: answer.
	^answer asObject!

absolutePosition: pl
	"Set the 'AbsolutePosition' property of the receiver to the <sdword> value of the argument."

	self put_AbsolutePosition: pl!

activeConnection
	"Answer the <variant> value of the 'ActiveConnection' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_ActiveConnection: answer.
	^answer asObject!

activeConnection: pvar
	"Set the 'ActiveConnection' property of the receiver to the <variant> value of the argument."

	self put_ActiveConnection: pvar asVariant!

addNew
	"Invoke the AddNew() method of the COM object.
	Default values are passed for all optional parameters."

	^self addNew: VARIANT unspecified values: VARIANT unspecified!

addNew: fieldList values: values
	"Invoke the AddNew() method of the COM object."

	^self AddNew: fieldList asVariant Values: values asVariant!

AddNew: fieldList Values: values
	"Private - Invoke the AddNew() method of the COM object.

		HRESULT __stdcall AddNew(
			[in, optional]VARIANT FieldList,
			[in, optional]VARIANT Values);"

	<virtual stdcall: hresult 31 variant variant>
	^self invalidCall: _failureCode!

bof
	"Answer the <varbool> value of the 'BOF' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_BOF: answer.
	^answer asObject!

bookmark
	"Answer the <variant> value of the 'Bookmark' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Bookmark: answer.
	^answer asObject!

bookmark: pvBookmark
	"Set the 'Bookmark' property of the receiver to the <variant> value of the argument."

	self put_Bookmark: pvBookmark asVariant!

cacheSize
	"Answer the <sdword> value of the 'CacheSize' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CacheSize: answer.
	^answer asObject!

cacheSize: pl
	"Set the 'CacheSize' property of the receiver to the <sdword> value of the argument."

	self put_CacheSize: pl!

cancelBatch
	"Invoke the CancelBatch() method of the COM object.
	Default values are passed for all optional parameters."

	^self CancelBatch: 3!

CancelBatch: affectRecords
	"Invoke the CancelBatch() method of the COM object.

		HRESULT __stdcall CancelBatch(
			[in, defaultvalue(3)]AffectEnum AffectRecords);"

	<virtual stdcall: hresult 59 sdword>
	^self invalidCall: _failureCode!

CancelUpdate
	"Invoke the CancelUpdate() method of the COM object.

		HRESULT __stdcall CancelUpdate();"

	<virtual stdcall: hresult 32>
	^self invalidCall: _failureCode!

close
	self Close!

Close
	"Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 33>
	^self invalidCall: _failureCode!

collect: transformer 
	"Evaluate the <monadicValuable> argument, transformer, for each of the 
	receiver's elements in the order defined by the receiver's implementation of #do:,
	collecting the results into an OrderedCollection which is answered."

	| answer |
	answer := OrderedCollection new.
	self do: [:each | answer add: (transformer value: each)].
	^answer!

collect: index pvar: pvar
	"Set the 'Collect' property of the receiver to the <variant> value of the argument."

	self put_Collect: index asVariant pvar: pvar asVariant!

cursorLocation
	"Answer the <sdword> value of the 'CursorLocation' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CursorLocation: answer.
	^answer asObject!

cursorLocation: plCursorLoc
	"Set the 'CursorLocation' property of the receiver to the <sdword> value of the argument."

	self put_CursorLocation: plCursorLoc!

cursorType
	"Answer the <sdword> value of the 'CursorType' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CursorType: answer.
	^answer asObject!

cursorType: plCursorType
	"Set the 'CursorType' property of the receiver to the <sdword> value of the argument."

	self put_CursorType: plCursorType!

delete
	"Invoke the Delete() method of the COM object.
	Default values are passed for all optional parameters."

	^self Delete: 1!

Delete: affectRecords
	"Invoke the Delete() method of the COM object.

		HRESULT __stdcall Delete(
			[in, defaultvalue(1)]AffectEnum AffectRecords);"

	<virtual stdcall: hresult 34 sdword>
	^self invalidCall: _failureCode!

do: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the 
	records in the receiver."

	| fields |
	self bof ifFalse: [self MoveFirst].
	fields := self fields.
	[self eof] whileFalse: [
		operation value: fields.
		self MoveNext]!

editMode
	"Answer the <sdword> value of the 'EditMode' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_EditMode: answer.
	^answer asObject!

eof
	"Answer the <varbool> value of the 'EOF' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_EOF: answer.
	^answer asObject!

fields
	"Answer the <ADODBFields> value of the 'Fields' property of the receiver.
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk sequenceable collection."

	| answer |
	answer := ADODBFields newPointer.
	self get_Fields: answer.
	^ADOCollection on: answer
!

filter
	"Answer the <variant> value of the 'Filter' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Filter: answer.
	^answer asObject!

filter: criteria
	"Set the 'Filter' property of the receiver to the <variant> value of the argument."

	self put_Filter: criteria asVariant!

find: criteria
	"Invoke the Find() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		find: criteria
		skipRecords: 0
		searchDirection: 1
		start: VARIANT unspecified!

find: criteria skipRecords: skipRecords searchDirection: searchDirection start: start
	"Invoke the Find() method of the COM object."

	^self
		Find: criteria
		SkipRecords: skipRecords
		SearchDirection: searchDirection
		Start: start asVariant!

Find: criteria SkipRecords: skipRecords SearchDirection: searchDirection Start: start
	"Private - Invoke the Find() method of the COM object.

		HRESULT __stdcall Find(
			[in]BSTR Criteria,
			[in, defaultvalue(0)]long SkipRecords,
			[in, defaultvalue(1)]SearchDirectionEnum SearchDirection,
			[in, optional]VARIANT Start);"

	<virtual stdcall: hresult 68 bstr sdword sdword variant>
	^self invalidCall: _failureCode!

get_AbsolutePage: pl
	"Private - Get the value of the 'AbsolutePage' property of the receiver.

		HRESULT __stdcall AbsolutePage(
			[out, retval]PositionEnum* pl);"

	<virtual stdcall: hresult 45 sdword*>
	^self invalidCall: _failureCode!

get_AbsolutePosition: pl
	"Private - Get the value of the 'AbsolutePosition' property of the receiver.

		HRESULT __stdcall AbsolutePosition(
			[out, retval]PositionEnum* pl);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

get_ActiveConnection: pvar
	"Private - Get the value of the 'ActiveConnection' property of the receiver.

		HRESULT __stdcall ActiveConnection(
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 13 variant*>
	^self invalidCall: _failureCode!

get_BOF: pb
	"Private - Get the value of the 'BOF' property of the receiver.

		HRESULT __stdcall BOF(
			[out, retval]VARIANT_BOOL* pb);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall: _failureCode!

get_Bookmark: pvBookmark
	"Private - Get the value of the 'Bookmark' property of the receiver.

		HRESULT __stdcall Bookmark(
			[out, retval]VARIANT* pvBookmark);"

	<virtual stdcall: hresult 15 variant*>
	^self invalidCall: _failureCode!

get_CacheSize: pl
	"Private - Get the value of the 'CacheSize' property of the receiver.

		HRESULT __stdcall CacheSize(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall: _failureCode!

get_Collect: index pvar: pvar
	"Private - Get the value of the 'Collect' property of the receiver.

		HRESULT __stdcall Collect(
			[in]VARIANT Index,
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 64 variant variant*>
	^self invalidCall: _failureCode!

get_CursorLocation: plCursorLoc
	"Private - Get the value of the 'CursorLocation' property of the receiver.

		HRESULT __stdcall CursorLocation(
			[out, retval]CursorLocationEnum* plCursorLoc);"

	<virtual stdcall: hresult 60 sdword*>
	^self invalidCall: _failureCode!

get_CursorType: plCursorType
	"Private - Get the value of the 'CursorType' property of the receiver.

		HRESULT __stdcall CursorType(
			[out, retval]CursorTypeEnum* plCursorType);"

	<virtual stdcall: hresult 19 sdword*>
	^self invalidCall: _failureCode!

get_EditMode: pl
	"Private - Get the value of the 'EditMode' property of the receiver.

		HRESULT __stdcall EditMode(
			[out, retval]EditModeEnum* pl);"

	<virtual stdcall: hresult 47 sdword*>
	^self invalidCall: _failureCode!

get_EOF: pb
	"Private - Get the value of the 'EOF' property of the receiver.

		HRESULT __stdcall EOF(
			[out, retval]VARIANT_BOOL* pb);"

	<virtual stdcall: hresult 21 varbool*>
	^self invalidCall: _failureCode!

get_Fields: ppvObject
	"Private - Get the value of the 'Fields' property of the receiver.

		HRESULT __stdcall Fields(
			[out, retval]Fields** ppvObject);"

	<virtual stdcall: hresult 22 ADODBFields**>
	^self invalidCall: _failureCode!

get_Filter: criteria
	"Private - Get the value of the 'Filter' property of the receiver.

		HRESULT __stdcall Filter(
			[out, retval]VARIANT* Criteria);"

	<virtual stdcall: hresult 48 variant*>
	^self invalidCall: _failureCode!

get_LockType: plLockType
	"Private - Get the value of the 'LockType' property of the receiver.

		HRESULT __stdcall LockType(
			[out, retval]LockTypeEnum* plLockType);"

	<virtual stdcall: hresult 23 sdword*>
	^self invalidCall: _failureCode!

get_MarshalOptions: peMarshal
	"Private - Get the value of the 'MarshalOptions' property of the receiver.

		HRESULT __stdcall MarshalOptions(
			[out, retval]MarshalOptionsEnum* peMarshal);"

	<virtual stdcall: hresult 66 sdword*>
	^self invalidCall: _failureCode!

get_MaxRecords: plMaxRecords
	"Private - Get the value of the 'MaxRecords' property of the receiver.

		HRESULT __stdcall MaxRecords(
			[out, retval]long* plMaxRecords);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall: _failureCode!

get_PageCount: pl
	"Private - Get the value of the 'PageCount' property of the receiver.

		HRESULT __stdcall PageCount(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 50 sdword*>
	^self invalidCall: _failureCode!

get_PageSize: pl
	"Private - Get the value of the 'PageSize' property of the receiver.

		HRESULT __stdcall PageSize(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 51 sdword*>
	^self invalidCall: _failureCode!

get_RecordCount: pl
	"Private - Get the value of the 'RecordCount' property of the receiver.

		HRESULT __stdcall RecordCount(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 27 sdword*>
	^self invalidCall: _failureCode!

get_Sort: criteria
	"Private - Get the value of the 'Sort' property of the receiver.

		HRESULT __stdcall Sort(
			[out, retval]BSTR* Criteria);"

	<virtual stdcall: hresult 53 bstr*>
	^self invalidCall: _failureCode!

get_Source: pvSource
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]VARIANT* pvSource);"

	<virtual stdcall: hresult 30 variant*>
	^self invalidCall: _failureCode!

get_State: plObjState
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]long* plObjState);"

	<virtual stdcall: hresult 56 sdword*>
	^self invalidCall: _failureCode!

get_Status: pl
	"Private - Get the value of the 'Status' property of the receiver.

		HRESULT __stdcall Status(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 55 sdword*>
	^self invalidCall: _failureCode!

getRows
	"Answer the <VARIANT> result of invoking the GetRows() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		getRows: -1
		start: VARIANT unspecified
		fields: VARIANT unspecified!

getRows: rows start: start fields: fields
	"Answer the <VARIANT> result of invoking the GetRows() method of the COM object."

	| answer |
	answer := VARIANT new.
	self
		GetRows: rows
		Start: start asVariant
		Fields: fields asVariant
		pvar: answer.
	^answer asObject!

GetRows: rows Start: start Fields: fields pvar: pvar
	"Private - Invoke the GetRows() method of the COM object.

		HRESULT __stdcall GetRows(
			[in, defaultvalue(-1)]long Rows,
			[in, optional]VARIANT Start,
			[in, optional]VARIANT Fields,
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 35 sdword variant variant variant*>
	^self invalidCall: _failureCode!

isEmpty
	"Answer whether the receiver is devoid of any rows."

	^self bof and: [self eof]!

lockType
	"Answer the <sdword> value of the 'LockType' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_LockType: answer.
	^answer asObject!

lockType: plLockType
	"Set the 'LockType' property of the receiver to the <sdword> value of the argument."

	self put_LockType: plLockType!

marshalOptions
	"Answer the <sdword> value of the 'MarshalOptions' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_MarshalOptions: answer.
	^answer asObject!

marshalOptions: peMarshal
	"Set the 'MarshalOptions' property of the receiver to the <sdword> value of the argument."

	self put_MarshalOptions: peMarshal!

maxRecords
	"Answer the <sdword> value of the 'MaxRecords' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_MaxRecords: answer.
	^answer asObject!

maxRecords: plMaxRecords
	"Set the 'MaxRecords' property of the receiver to the <sdword> value of the argument."

	self put_MaxRecords: plMaxRecords!

move: numRecords
	"Invoke the Move() method of the COM object.
	Default values are passed for all optional parameters."

	^self move: numRecords start: VARIANT unspecified!

move: numRecords start: start
	"Invoke the Move() method of the COM object."

	^self Move: numRecords Start: start asVariant!

Move: numRecords Start: start
	"Private - Invoke the Move() method of the COM object.

		HRESULT __stdcall Move(
			[in]long NumRecords,
			[in, optional]VARIANT Start);"

	<virtual stdcall: hresult 36 sdword variant>
	^self invalidCall: _failureCode!

MoveFirst
	"Invoke the MoveFirst() method of the COM object.

		HRESULT __stdcall MoveFirst();"

	<virtual stdcall: hresult 39>
	^self invalidCall: _failureCode!

MoveLast
	"Invoke the MoveLast() method of the COM object.

		HRESULT __stdcall MoveLast();"

	<virtual stdcall: hresult 40>
	^self invalidCall: _failureCode!

MoveNext
	"Invoke the MoveNext() method of the COM object.

		HRESULT __stdcall MoveNext();"

	<virtual stdcall: hresult 37>
	^self invalidCall: _failureCode!

MovePrevious
	"Invoke the MovePrevious() method of the COM object.

		HRESULT __stdcall MovePrevious();"

	<virtual stdcall: hresult 38>
	^self invalidCall: _failureCode!

nextRecordset
	"Invoke the NextRecordset() method of the COM object."

	| outputs |
	outputs := {VARIANT new. ADODB_Recordset newPointer}.
	self NextRecordset: (outputs basicAt: 1) ppiRs: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

NextRecordset: recordsAffected ppiRs: ppiRs
	"Private - Invoke the NextRecordset() method of the COM object.

		HRESULT __stdcall NextRecordset(
			[out, optional]VARIANT* RecordsAffected,
			[out, retval]_Recordset** ppiRs);"

	<virtual stdcall: hresult 62 variant* ADODB_Recordset**>
	^self invalidCall: _failureCode!

open
	"Open the recordset, using the current properties for the command,
	connection, etc."

	^self open: VARIANT unspecified!

open: source
	"Open the recordset, defaulting all parameters except the 'source'."

	^self open: source activeConnection: VARIANT unspecified!

open: source activeConnection: connectionOrString
	"Open the recordset, defaulting all parameters except the 'source' and 'active connection'."

	^self
		open: source asVariant
		activeConnection: connectionOrString asVariant
		cursorType: -1
		lockType: -1
		options: -1

!

open: source activeConnection: activeConnection cursorType: cursorType lockType: lockType options: options
	"Invoke the Open() method of the COM object."

	^self
		Open: source asVariant
		ActiveConnection: activeConnection asVariant
		CursorType: cursorType
		LockType: lockType
		Options: options!

Open: source ActiveConnection: activeConnection CursorType: cursorType LockType: lockType Options: options
	"Private - Invoke the Open() method of the COM object.

		HRESULT __stdcall Open(
			[in, optional]VARIANT Source,
			[in, optional]VARIANT ActiveConnection,
			[in, defaultvalue(-1)]CursorTypeEnum CursorType,
			[in, defaultvalue(-1)]LockTypeEnum LockType,
			[in, defaultvalue(-1)]long Options);"

	<virtual stdcall: hresult 41 variant variant sdword sdword sdword>
	^self invalidCall: _failureCode!

pageCount
	"Answer the <sdword> value of the 'PageCount' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_PageCount: answer.
	^answer asObject!

pageSize
	"Answer the <sdword> value of the 'PageSize' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_PageSize: answer.
	^answer asObject!

pageSize: pl
	"Set the 'PageSize' property of the receiver to the <sdword> value of the argument."

	self put_PageSize: pl!

put_AbsolutePage: pl
	"Private - Set the value of the 'AbsolutePage' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall AbsolutePage(
			[in]PositionEnum pl);"

	<virtual stdcall: hresult 46 sdword>
	^self invalidCall: _failureCode!

put_AbsolutePosition: pl
	"Private - Set the value of the 'AbsolutePosition' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall AbsolutePosition(
			[in]PositionEnum pl);"

	<virtual stdcall: hresult 10 sdword>
	^self invalidCall: _failureCode!

put_ActiveConnection: pvar
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <variant> argument, pvar.

		HRESULT __stdcall ActiveConnection(
			[in]VARIANT pvar);"

	<virtual stdcall: hresult 12 variant>
	^self invalidCall: _failureCode!

put_Bookmark: pvBookmark
	"Private - Set the value of the 'Bookmark' property of the object wrapped by the 
	 receiver to the <variant> argument, pvBookmark.

		HRESULT __stdcall Bookmark(
			[in]VARIANT pvBookmark);"

	<virtual stdcall: hresult 16 variant>
	^self invalidCall: _failureCode!

put_CacheSize: pl
	"Private - Set the value of the 'CacheSize' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall CacheSize(
			[in]long pl);"

	<virtual stdcall: hresult 18 sdword>
	^self invalidCall: _failureCode!

put_Collect: index pvar: pvar
	"Private - Set the value of the 'Collect' property of the object wrapped by the 
	 receiver to the <variant> argument, pvar.

		HRESULT __stdcall Collect(
			[in]VARIANT Index,
			[in]VARIANT pvar);"

	<virtual stdcall: hresult 65 variant variant>
	^self invalidCall: _failureCode!

put_CursorLocation: plCursorLoc
	"Private - Set the value of the 'CursorLocation' property of the object wrapped by the 
	 receiver to the <sdword> argument, plCursorLoc.

		HRESULT __stdcall CursorLocation(
			[in]CursorLocationEnum plCursorLoc);"

	<virtual stdcall: hresult 61 sdword>
	^self invalidCall: _failureCode!

put_CursorType: plCursorType
	"Private - Set the value of the 'CursorType' property of the object wrapped by the 
	 receiver to the <sdword> argument, plCursorType.

		HRESULT __stdcall CursorType(
			[in]CursorTypeEnum plCursorType);"

	<virtual stdcall: hresult 20 sdword>
	^self invalidCall: _failureCode!

put_Filter: criteria
	"Private - Set the value of the 'Filter' property of the object wrapped by the 
	 receiver to the <variant> argument, criteria.

		HRESULT __stdcall Filter(
			[in]VARIANT Criteria);"

	<virtual stdcall: hresult 49 variant>
	^self invalidCall: _failureCode!

put_LockType: plLockType
	"Private - Set the value of the 'LockType' property of the object wrapped by the 
	 receiver to the <sdword> argument, plLockType.

		HRESULT __stdcall LockType(
			[in]LockTypeEnum plLockType);"

	<virtual stdcall: hresult 24 sdword>
	^self invalidCall: _failureCode!

put_MarshalOptions: peMarshal
	"Private - Set the value of the 'MarshalOptions' property of the object wrapped by the 
	 receiver to the <sdword> argument, peMarshal.

		HRESULT __stdcall MarshalOptions(
			[in]MarshalOptionsEnum peMarshal);"

	<virtual stdcall: hresult 67 sdword>
	^self invalidCall: _failureCode!

put_MaxRecords: plMaxRecords
	"Private - Set the value of the 'MaxRecords' property of the object wrapped by the 
	 receiver to the <sdword> argument, plMaxRecords.

		HRESULT __stdcall MaxRecords(
			[in]long plMaxRecords);"

	<virtual stdcall: hresult 26 sdword>
	^self invalidCall: _failureCode!

put_PageSize: pl
	"Private - Set the value of the 'PageSize' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall PageSize(
			[in]long pl);"

	<virtual stdcall: hresult 52 sdword>
	^self invalidCall: _failureCode!

put_Sort: criteria
	"Private - Set the value of the 'Sort' property of the object wrapped by the 
	 receiver to the <bstr> argument, criteria.

		HRESULT __stdcall Sort(
			[in]BSTR Criteria);"

	<virtual stdcall: hresult 54 bstr>
	^self invalidCall: _failureCode!

put_Source: pvSource
	"Private - Set the value of the 'Source' property of the object wrapped by the 
	 receiver to the <bstr> argument, pvSource.

		HRESULT __stdcall Source(
			[in]BSTR pvSource);"

	<virtual stdcall: hresult 29 bstr>
	^self invalidCall: _failureCode!

putref_ActiveConnection: pvar
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <IDispatch*> argument, pvar.

		HRESULT __stdcall ActiveConnection(
			[in]IDispatch* pvar);"

	<virtual stdcall: hresult 11 IDispatch*>
	^self invalidCall: _failureCode!

putref_Source: pvSource
	"Private - Set the value of the 'Source' property of the object wrapped by the 
	 receiver to the <IDispatch*> argument, pvSource.

		HRESULT __stdcall Source(
			[in]IDispatch* pvSource);"

	<virtual stdcall: hresult 28 IDispatch*>
	^self invalidCall: _failureCode!

recordCount
	"Answer the <sdword> value of the 'RecordCount' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_RecordCount: answer.
	^answer asObject!

requery
	"Invoke the Requery() method of the COM object.
	Default values are passed for all optional parameters."

	^self Requery: -1!

Requery: options
	"Invoke the Requery() method of the COM object.

		HRESULT __stdcall Requery(
			[in, defaultvalue(-1)]long Options);"

	<virtual stdcall: hresult 42 sdword>
	^self invalidCall: _failureCode!

setActiveConnection: pvar
	"Set the 'ActiveConnection' property of the receiver to the <IDispatch*> value of the argument."

	self putref_ActiveConnection: pvar!

setSource: pvSource
	"Set the 'Source' property of the receiver to the <IDispatch*> value of the argument."

	self putref_Source: pvSource!

size
	"Answer the number of records in this recordset (or -1 if not known)."

	^self recordCount!

sort
	"Answer the <bstr> value of the 'Sort' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Sort: answer.
	^answer asObject!

sort: criteria
	"Set the 'Sort' property of the receiver to the <bstr> value of the argument."

	self put_Sort: criteria!

source
	"Answer the <variant> value of the 'Source' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Source: answer.
	^answer asObject!

source: pvSource
	"Set the 'Source' property of the receiver to the <bstr> value of the argument."

	self put_Source: pvSource!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_State: answer.
	^answer asObject!

status
	"Answer the <sdword> value of the 'Status' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Status: answer.
	^answer asObject!

supports: cursorOptions
	"Answer the <VARIANT_BOOL> result of invoking the Supports() method of the COM object."

	| answer |
	answer := VARIANT_BOOL new.
	self Supports: cursorOptions pb: answer.
	^answer asObject!

Supports: cursorOptions pb: pb
	"Private - Invoke the Supports() method of the COM object.

		HRESULT __stdcall Supports(
			[in]CursorOptionEnum CursorOptions,
			[out, retval]VARIANT_BOOL* pb);"

	<virtual stdcall: hresult 63 sdword varbool*>
	^self invalidCall: _failureCode!

update
	"Invoke the Update() method of the COM object.
	Default values are passed for all optional parameters."

	^self update: VARIANT unspecified values: VARIANT unspecified!

update: fields values: values
	"Invoke the Update() method of the COM object."

	^self Update: fields asVariant Values: values asVariant!

Update: fields Values: values
	"Private - Invoke the Update() method of the COM object.

		HRESULT __stdcall Update(
			[in, optional]VARIANT Fields,
			[in, optional]VARIANT Values);"

	<virtual stdcall: hresult 44 variant variant>
	^self invalidCall: _failureCode!

updateBatch
	"Invoke the UpdateBatch() method of the COM object.
	Default values are passed for all optional parameters."

	^self UpdateBatch: 3!

UpdateBatch: affectRecords
	"Invoke the UpdateBatch() method of the COM object.

		HRESULT __stdcall UpdateBatch(
			[in, defaultvalue(3)]AffectEnum AffectRecords);"

	<virtual stdcall: hresult 58 sdword>
	^self invalidCall: _failureCode!

value
	"Answer the <ADODBFields> value of the 'Fields' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self fields! !
!ADODBRecordset15 categoriesFor: #_xClone!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #_xClone:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #_xResync!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #_xResync:!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #absolutePage!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #absolutePage:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #absolutePosition!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #absolutePosition:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #activeConnection!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #activeConnection:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #addNew!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #addNew:values:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #AddNew:Values:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #bof!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #bookmark!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #bookmark:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #cacheSize!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #cacheSize:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #cancelBatch!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #CancelBatch:!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #CancelUpdate!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #close!operations!public! !
!ADODBRecordset15 categoriesFor: #Close!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #collect:!enumerating!public! !
!ADODBRecordset15 categoriesFor: #collect:pvar:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #cursorLocation!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #cursorLocation:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #cursorType!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #cursorType:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #delete!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #Delete:!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #do:!enumerating!public! !
!ADODBRecordset15 categoriesFor: #editMode!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #eof!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #fields!properties!public! !
!ADODBRecordset15 categoriesFor: #filter!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #filter:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #find:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #find:skipRecords:searchDirection:start:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #Find:SkipRecords:SearchDirection:Start:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_AbsolutePage:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_AbsolutePosition:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_ActiveConnection:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_BOF:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_Bookmark:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_CacheSize:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_Collect:pvar:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_CursorLocation:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_CursorType:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_EditMode:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_EOF:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_Fields:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_Filter:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_LockType:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_MarshalOptions:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_MaxRecords:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_PageCount:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_PageSize:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_RecordCount:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_Sort:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_Source:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_State:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #get_Status:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #getRows!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #getRows:start:fields:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #GetRows:Start:Fields:pvar:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #isEmpty!public!testing! !
!ADODBRecordset15 categoriesFor: #lockType!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #lockType:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #marshalOptions!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #marshalOptions:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #maxRecords!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #maxRecords:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #move:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #move:start:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #Move:Start:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #MoveFirst!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #MoveLast!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #MoveNext!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #MovePrevious!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #nextRecordset!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #NextRecordset:ppiRs:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #open!methods!public! !
!ADODBRecordset15 categoriesFor: #open:!methods!public! !
!ADODBRecordset15 categoriesFor: #open:activeConnection:!methods!public! !
!ADODBRecordset15 categoriesFor: #open:activeConnection:cursorType:lockType:options:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #Open:ActiveConnection:CursorType:LockType:Options:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #pageCount!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #pageSize!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #pageSize:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #put_AbsolutePage:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_AbsolutePosition:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_ActiveConnection:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_Bookmark:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_CacheSize:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_Collect:pvar:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_CursorLocation:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_CursorType:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_Filter:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_LockType:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_MarshalOptions:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_MaxRecords:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_PageSize:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_Sort:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #put_Source:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #putref_ActiveConnection:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #putref_Source:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #recordCount!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #requery!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #Requery:!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #setActiveConnection:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #setSource:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #size!properties!public! !
!ADODBRecordset15 categoriesFor: #sort!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #sort:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #source!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #source:!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #state!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #status!**auto generated**!properties!public! !
!ADODBRecordset15 categoriesFor: #supports:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #Supports:pb:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #update!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #update:values:!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #Update:Values:!**auto generated**!COM Interfaces-Recordset15!private! !
!ADODBRecordset15 categoriesFor: #updateBatch!**auto generated**!methods!public! !
!ADODBRecordset15 categoriesFor: #UpdateBatch:!**auto generated**!COM Interfaces-Recordset15!public! !
!ADODBRecordset15 categoriesFor: #value!**auto generated**!properties!public! !

!ADODBRecordset15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Recordset15'
		ADODBRecordset15 defineTemplate"

	self
		defineFunction: #get_AbsolutePosition:
			argumentTypes: 'sdword*';
		defineFunction: #put_AbsolutePosition:
			argumentTypes: 'sdword';
		defineFunction: #putref_ActiveConnection:
			argumentTypes: 'IDispatch*';
		defineFunction: #put_ActiveConnection:
			argumentTypes: 'variant';
		defineFunction: #get_ActiveConnection:
			argumentTypes: 'variant*';
		defineFunction: #get_BOF:
			argumentTypes: 'varbool*';
		defineFunction: #get_Bookmark:
			argumentTypes: 'variant*';
		defineFunction: #put_Bookmark:
			argumentTypes: 'variant';
		defineFunction: #get_CacheSize:
			argumentTypes: 'sdword*';
		defineFunction: #put_CacheSize:
			argumentTypes: 'sdword';
		defineFunction: #get_CursorType:
			argumentTypes: 'sdword*';
		defineFunction: #put_CursorType:
			argumentTypes: 'sdword';
		defineFunction: #get_EOF:
			argumentTypes: 'varbool*';
		defineFunction: #get_Fields:
			argumentTypes: 'ADODBFields**';
		defineFunction: #get_LockType:
			argumentTypes: 'sdword*';
		defineFunction: #put_LockType:
			argumentTypes: 'sdword';
		defineFunction: #get_MaxRecords:
			argumentTypes: 'sdword*';
		defineFunction: #put_MaxRecords:
			argumentTypes: 'sdword';
		defineFunction: #get_RecordCount:
			argumentTypes: 'sdword*';
		defineFunction: #putref_Source:
			argumentTypes: 'IDispatch*';
		defineFunction: #put_Source:
			argumentTypes: 'bstr';
		defineFunction: #get_Source:
			argumentTypes: 'variant*';
		defineFunction: #AddNew:Values:
			argumentTypes: 'variant variant';
		defineFunction: #CancelUpdate;
		defineFunction: #Close;
		defineFunction: #Delete:
			argumentTypes: 'sdword';
		defineFunction: #GetRows:Start:Fields:pvar:
			argumentTypes: 'sdword variant variant variant*';
		defineFunction: #Move:Start:
			argumentTypes: 'sdword variant';
		defineFunction: #MoveNext;
		defineFunction: #MovePrevious;
		defineFunction: #MoveFirst;
		defineFunction: #MoveLast;
		defineFunction: #Open:ActiveConnection:CursorType:LockType:Options:
			argumentTypes: 'variant variant sdword sdword sdword';
		defineFunction: #Requery:
			argumentTypes: 'sdword';
		defineFunction: #_xResync:
			argumentTypes: 'sdword';
		defineFunction: #Update:Values:
			argumentTypes: 'variant variant';
		defineFunction: #get_AbsolutePage:
			argumentTypes: 'sdword*';
		defineFunction: #put_AbsolutePage:
			argumentTypes: 'sdword';
		defineFunction: #get_EditMode:
			argumentTypes: 'sdword*';
		defineFunction: #get_Filter:
			argumentTypes: 'variant*';
		defineFunction: #put_Filter:
			argumentTypes: 'variant';
		defineFunction: #get_PageCount:
			argumentTypes: 'sdword*';
		defineFunction: #get_PageSize:
			argumentTypes: 'sdword*';
		defineFunction: #put_PageSize:
			argumentTypes: 'sdword';
		defineFunction: #get_Sort:
			argumentTypes: 'bstr*';
		defineFunction: #put_Sort:
			argumentTypes: 'bstr';
		defineFunction: #get_Status:
			argumentTypes: 'sdword*';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #_xClone:
			argumentTypes: 'ADODB_Recordset**';
		defineFunction: #UpdateBatch:
			argumentTypes: 'sdword';
		defineFunction: #CancelBatch:
			argumentTypes: 'sdword';
		defineFunction: #get_CursorLocation:
			argumentTypes: 'sdword*';
		defineFunction: #put_CursorLocation:
			argumentTypes: 'sdword';
		defineFunction: #NextRecordset:ppiRs:
			argumentTypes: 'variant* ADODB_Recordset**';
		defineFunction: #Supports:pb:
			argumentTypes: 'sdword varbool*';
		defineFunction: #get_Collect:pvar:
			argumentTypes: 'variant variant*';
		defineFunction: #put_Collect:pvar:
			argumentTypes: 'variant variant';
		defineFunction: #get_MarshalOptions:
			argumentTypes: 'sdword*';
		defineFunction: #put_MarshalOptions:
			argumentTypes: 'sdword';
		defineFunction: #Find:SkipRecords:SearchDirection:Start:
			argumentTypes: 'bstr sdword sdword variant'
! !
!ADODBRecordset15 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

