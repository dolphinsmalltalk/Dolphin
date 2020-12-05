"Filed out from Dolphin Smalltalk 7"!

ADODB.Recordset15 subclass: #'ADODB.Recordset20'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Recordset20 guid: (OS.COM.IID fromString: '{0000154f-0000-0010-8000-00aa006d2ea4}')!
ADODB.Recordset20 comment: '`ADODBRecordset20` is a wrapper class for the COM interface ''ADODB.Recordset20'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0000154f-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c903), 
	hidden, 
	nonextensible, 
	dual
]
interface Recordset20 : Recordset15
 {
	[id(0x0000041f), helpcontext(0x0012c8b8)]
	HRESULT __stdcall Cancel();
	[id(0x00000420), propget, helpcontext(0x0012dbbe)]
	HRESULT __stdcall DataSource(
		[out, retval]IUnknown** ppunkDataSource);
	[id(0x00000420), propputref, helpcontext(0x0012dbbe)]
	HRESULT __stdcall DataSource(
		[in]IUnknown* ppunkDataSource);
	[id(0x60040003), hidden]
	HRESULT __stdcall _xSave(
		[in, defaultvalue("")]BSTR FileName,
		[in, defaultvalue(0)]PersistFormatEnum PersistFormat);
	[id(0x00000425), propget, helpcontext(0x0012dbbc)]
	HRESULT __stdcall ActiveCommand(
		[out, retval]IDispatch** ppCmd);
	[id(0x00000427), propput, helpcontext(0x0012dbd0)]
	HRESULT __stdcall StayInSync(
		[in]VARIANT_BOOL pbStayInSync);
	[id(0x00000427), propget, helpcontext(0x0012dbd0)]
	HRESULT __stdcall StayInSync(
		[out, retval]VARIANT_BOOL* pbStayInSync);
	[id(0x00000426), helpcontext(0x0012c8d0)]
	HRESULT __stdcall GetString(
		[in, defaultvalue(2)]StringFormatEnum StringFormat,
		[in, defaultvalue(-1)]long NumRows,
		[in, defaultvalue("")]BSTR ColumnDelimeter,
		[in, defaultvalue("")]BSTR RowDelimeter,
		[in, defaultvalue("")]BSTR NullExpr,
		[out, retval]BSTR* pRetString);
	[id(0x00000428), propget, helpcontext(0x0012dbbd)]
	HRESULT __stdcall DataMember(
		[out, retval]BSTR* pbstrDataMember);
	[id(0x00000428), propput, helpcontext(0x0012dbbd)]
	HRESULT __stdcall DataMember(
		[in]BSTR pbstrDataMember);
	[id(0x00000429), helpcontext(0x0012dba4)]
	HRESULT __stdcall CompareBookmarks(
		[in]VARIANT Bookmark1,
		[in]VARIANT Bookmark2,
		[out, retval]CompareEnum* pCompare);
	[id(0x0000040a), helpcontext(0x0012c8be)]
	HRESULT __stdcall Clone(
		[in, defaultvalue(-1)]LockTypeEnum LockType,
		[out, retval]_Recordset** ppvObject);
	[id(0x00000400), helpcontext(0x0012c8de)]
	HRESULT __stdcall Resync(
		[in, defaultvalue(3)]AffectEnum AffectRecords,
		[in, defaultvalue(2)]ResyncEnum ResyncValues);
};
```
'!
!ADODB.Recordset20 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Recordset20 methodsFor!

_xSave
	"Invoke the _xSave() method of the COM object.
	Default values are passed for all optional parameters."

	^self _xSave: '' PersistFormat: 0!

_xSave: fileName PersistFormat: persistFormat
	"Invoke the _xSave() method of the COM object.

		HRESULT __stdcall _xSave(
			[in, defaultvalue('')]BSTR FileName,
			[in, defaultvalue(0)]PersistFormatEnum PersistFormat);"

	<virtual stdcall: hresult 72 bstr sdword>
	^self invalidCall: _failureCode!

activeCommand
	"Answer the <IDispatch> value of the 'ActiveCommand' property of the receiver."

	| answer |
	answer := IDispatch newPointer.
	self get_ActiveCommand: answer.
	^answer asObject!

Cancel
	"Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 69>
	^self invalidCall: _failureCode!

clone
	"Answer the <_Recordset> result of invoking the Clone() method of the COM object.
	Default values are passed for all optional parameters."

	^self clone: -1!

clone: lockType
	"Answer the <_Recordset> result of invoking the Clone() method of the COM object."

	| answer |
	answer := _Recordset newPointer.
	self Clone: lockType ppvObject: answer.
	^answer asObject!

Clone: lockType ppvObject: ppvObject
	"Private - Invoke the Clone() method of the COM object.

		HRESULT __stdcall Clone(
			[in, defaultvalue(-1)]LockTypeEnum LockType,
			[out, retval]_Recordset** ppvObject);"

	<virtual stdcall: hresult 80 sdword _Recordset**>
	^self invalidCall: _failureCode!

compareBookmarks: bookmark1 bookmark2: bookmark2
	"Answer the <SDWORD> result of invoking the CompareBookmarks() method of the COM object."

	| answer |
	answer := SDWORD new.
	self
		CompareBookmarks: bookmark1 asVariant
		Bookmark2: bookmark2 asVariant
		pCompare: answer.
	^answer asObject!

CompareBookmarks: bookmark1 Bookmark2: bookmark2 pCompare: pCompare
	"Private - Invoke the CompareBookmarks() method of the COM object.

		HRESULT __stdcall CompareBookmarks(
			[in]VARIANT Bookmark1,
			[in]VARIANT Bookmark2,
			[out, retval]CompareEnum* pCompare);"

	<virtual stdcall: hresult 79 variant variant sdword*>
	^self invalidCall: _failureCode!

dataMember
	"Answer the <bstr> value of the 'DataMember' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_DataMember: answer.
	^answer asObject!

dataMember: pbstrDataMember
	"Set the 'DataMember' property of the receiver to the <bstr> value of the argument."

	self put_DataMember: pbstrDataMember!

dataSource
	"Answer the <IUnknown> value of the 'DataSource' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_DataSource: answer.
	^answer asObject!

get_ActiveCommand: ppCmd
	"Private - Get the value of the 'ActiveCommand' property of the receiver.

		HRESULT __stdcall ActiveCommand(
			[out, retval]IDispatch** ppCmd);"

	<virtual stdcall: hresult 73 IDispatch**>
	^self invalidCall: _failureCode!

get_DataMember: pbstrDataMember
	"Private - Get the value of the 'DataMember' property of the receiver.

		HRESULT __stdcall DataMember(
			[out, retval]BSTR* pbstrDataMember);"

	<virtual stdcall: hresult 77 bstr*>
	^self invalidCall: _failureCode!

get_DataSource: ppunkDataSource
	"Private - Get the value of the 'DataSource' property of the receiver.

		HRESULT __stdcall DataSource(
			[out, retval]IUnknown** ppunkDataSource);"

	<virtual stdcall: hresult 70 IUnknown**>
	^self invalidCall: _failureCode!

get_StayInSync: pbStayInSync
	"Private - Get the value of the 'StayInSync' property of the receiver.

		HRESULT __stdcall StayInSync(
			[out, retval]VARIANT_BOOL* pbStayInSync);"

	<virtual stdcall: hresult 75 varbool*>
	^self invalidCall: _failureCode!

getString
	"Answer the <BSTR> result of invoking the GetString() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		getString: 2
		numRows: -1
		columnDelimeter: ''
		rowDelimeter: ''
		nullExpr: ''!

getString: stringFormat numRows: numRows columnDelimeter: columnDelimeter rowDelimeter: rowDelimeter nullExpr: nullExpr
	"Answer the <BSTR> result of invoking the GetString() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		GetString: stringFormat
		NumRows: numRows
		ColumnDelimeter: columnDelimeter
		RowDelimeter: rowDelimeter
		NullExpr: nullExpr
		pRetString: answer.
	^answer asObject!

GetString: stringFormat NumRows: numRows ColumnDelimeter: columnDelimeter RowDelimeter: rowDelimeter NullExpr: nullExpr pRetString: pRetString
	"Private - Invoke the GetString() method of the COM object.

		HRESULT __stdcall GetString(
			[in, defaultvalue(2)]StringFormatEnum StringFormat,
			[in, defaultvalue(-1)]long NumRows,
			[in, defaultvalue('')]BSTR ColumnDelimeter,
			[in, defaultvalue('')]BSTR RowDelimeter,
			[in, defaultvalue('')]BSTR NullExpr,
			[out, retval]BSTR* pRetString);"

	<virtual stdcall: hresult 76 sdword sdword bstr bstr bstr bstr*>
	^self invalidCall: _failureCode!

put_DataMember: pbstrDataMember
	"Private - Set the value of the 'DataMember' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrDataMember.

		HRESULT __stdcall DataMember(
			[in]BSTR pbstrDataMember);"

	<virtual stdcall: hresult 78 bstr>
	^self invalidCall: _failureCode!

put_StayInSync: pbStayInSync
	"Private - Set the value of the 'StayInSync' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbStayInSync.

		HRESULT __stdcall StayInSync(
			[in]VARIANT_BOOL pbStayInSync);"

	<virtual stdcall: hresult 74 varbool>
	^self invalidCall: _failureCode!

putref_DataSource: ppunkDataSource
	"Private - Set the value of the 'DataSource' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppunkDataSource.

		HRESULT __stdcall DataSource(
			[in]IUnknown* ppunkDataSource);"

	<virtual stdcall: hresult 71 IUnknown*>
	^self invalidCall: _failureCode!

resync
	"Invoke the Resync() method of the COM object.
	Default values are passed for all optional parameters."

	^self Resync: 3 ResyncValues: 2!

Resync: affectRecords ResyncValues: resyncValues
	"Invoke the Resync() method of the COM object.

		HRESULT __stdcall Resync(
			[in, defaultvalue(3)]AffectEnum AffectRecords,
			[in, defaultvalue(2)]ResyncEnum ResyncValues);"

	<virtual stdcall: hresult 81 sdword sdword>
	^self invalidCall: _failureCode!

setDataSource: ppunkDataSource
	"Set the 'DataSource' property of the receiver to the <IUnknown*> value of the argument."

	self putref_DataSource: ppunkDataSource!

stayInSync
	"Answer the <varbool> value of the 'StayInSync' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_StayInSync: answer.
	^answer asObject!

stayInSync: pbStayInSync
	"Set the 'StayInSync' property of the receiver to the <varbool> value of the argument."

	self put_StayInSync: pbStayInSync! !
!ADODB.Recordset20 categoriesFor: #_xSave!**auto generated**!methods!public! !
!ADODB.Recordset20 categoriesFor: #_xSave:PersistFormat:!**auto generated**!COM Interfaces-Recordset20!public! !
!ADODB.Recordset20 categoriesFor: #activeCommand!**auto generated**!properties!public! !
!ADODB.Recordset20 categoriesFor: #Cancel!**auto generated**!COM Interfaces-Recordset20!public! !
!ADODB.Recordset20 categoriesFor: #clone!**auto generated**!methods!public! !
!ADODB.Recordset20 categoriesFor: #clone:!**auto generated**!methods!public! !
!ADODB.Recordset20 categoriesFor: #Clone:ppvObject:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #compareBookmarks:bookmark2:!**auto generated**!methods!public! !
!ADODB.Recordset20 categoriesFor: #CompareBookmarks:Bookmark2:pCompare:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #dataMember!**auto generated**!properties!public! !
!ADODB.Recordset20 categoriesFor: #dataMember:!**auto generated**!properties!public! !
!ADODB.Recordset20 categoriesFor: #dataSource!**auto generated**!properties!public! !
!ADODB.Recordset20 categoriesFor: #get_ActiveCommand:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #get_DataMember:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #get_DataSource:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #get_StayInSync:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #getString!**auto generated**!methods!public! !
!ADODB.Recordset20 categoriesFor: #getString:numRows:columnDelimeter:rowDelimeter:nullExpr:!**auto generated**!methods!public! !
!ADODB.Recordset20 categoriesFor: #GetString:NumRows:ColumnDelimeter:RowDelimeter:NullExpr:pRetString:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #put_DataMember:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #put_StayInSync:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #putref_DataSource:!**auto generated**!COM Interfaces-Recordset20!private! !
!ADODB.Recordset20 categoriesFor: #resync!**auto generated**!methods!public! !
!ADODB.Recordset20 categoriesFor: #Resync:ResyncValues:!**auto generated**!COM Interfaces-Recordset20!public! !
!ADODB.Recordset20 categoriesFor: #setDataSource:!**auto generated**!properties!public! !
!ADODB.Recordset20 categoriesFor: #stayInSync!**auto generated**!properties!public! !
!ADODB.Recordset20 categoriesFor: #stayInSync:!**auto generated**!properties!public! !

!ADODB.Recordset20 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Recordset20'
		Recordset20 defineTemplate"

	self
		defineFunction: #Cancel;
		defineFunction: #get_DataSource:
			argumentTypes: 'IUnknown**';
		defineFunction: #putref_DataSource:
			argumentTypes: 'IUnknown*';
		defineFunction: #_xSave:PersistFormat:
			argumentTypes: 'bstr sdword';
		defineFunction: #get_ActiveCommand:
			argumentTypes: 'IDispatch**';
		defineFunction: #put_StayInSync:
			argumentTypes: 'varbool';
		defineFunction: #get_StayInSync:
			argumentTypes: 'varbool*';
		defineFunction: #GetString:NumRows:ColumnDelimeter:RowDelimeter:NullExpr:pRetString:
			argumentTypes: 'sdword sdword bstr bstr bstr bstr*';
		defineFunction: #get_DataMember:
			argumentTypes: 'bstr*';
		defineFunction: #put_DataMember:
			argumentTypes: 'bstr';
		defineFunction: #CompareBookmarks:Bookmark2:pCompare:
			argumentTypes: 'variant variant sdword*';
		defineFunction: #Clone:ppvObject:
			argumentTypes: 'sdword _Recordset**';
		defineFunction: #Resync:ResyncValues:
			argumentTypes: 'sdword sdword'
! !
!ADODB.Recordset20 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

