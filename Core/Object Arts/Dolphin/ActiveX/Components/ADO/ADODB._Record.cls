"Filed out from Dolphin Smalltalk 7"!

ADODB._ADO subclass: #'ADODB._Record'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB._Record guid: (OS.COM.IID fromString: '{00001562-0000-0010-8000-00aa006d2ea4}')!
ADODB._Record comment: '`_Record` is a wrapper class for the COM interface ''ADODB._Record'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001562-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012cc8e), 
	hidden, 
	dual
]
interface _Record : _ADO
 {
	[id(0x00000001), propget, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[out, retval]VARIANT* pvar);
	[id(0x00000001), propput, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[in]BSTR pvar);
	[id(0x00000001), propputref, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[in]_Connection* pvar);
	[id(0x00000002), propget, helpcontext(0x0012cc80)]
	HRESULT __stdcall State(
		[out, retval]ObjectStateEnum* pState);
	[id(0x00000003), propget, helpcontext(0x0012cc81)]
	HRESULT __stdcall Source(
		[out, retval]VARIANT* pvar);
	[id(0x00000003), propput, helpcontext(0x0012cc81)]
	HRESULT __stdcall Source(
		[in]BSTR pvar);
	[id(0x00000003), propputref, helpcontext(0x0012cc81)]
	HRESULT __stdcall Source(
		[in]IDispatch* pvar);
	[id(0x00000004), propget, helpcontext(0x0012cc82)]
	HRESULT __stdcall Mode(
		[out, retval]ConnectModeEnum* pMode);
	[id(0x00000004), propput, helpcontext(0x0012cc82)]
	HRESULT __stdcall Mode(
		[in]ConnectModeEnum pMode);
	[id(0x00000005), propget, helpcontext(0x0012cc83)]
	HRESULT __stdcall ParentURL(
		[out, retval]BSTR* pbstrParentURL);
	[id(0x00000006), helpcontext(0x0012cc84)]
	HRESULT __stdcall MoveRecord(
		[in, defaultvalue("")]BSTR Source,
		[in, defaultvalue("")]BSTR Destination,
		[in, defaultvalue("")]BSTR UserName,
		[in, defaultvalue("")]BSTR Password,
		[in, defaultvalue(-1)]MoveRecordOptionsEnum Options,
		[in, defaultvalue(false)]VARIANT_BOOL Async,
		[out, retval]BSTR* pbstrNewURL);
	[id(0x00000007), helpcontext(0x0012cc85)]
	HRESULT __stdcall CopyRecord(
		[in, defaultvalue("")]BSTR Source,
		[in, defaultvalue("")]BSTR Destination,
		[in, defaultvalue("")]BSTR UserName,
		[in, defaultvalue("")]BSTR Password,
		[in, defaultvalue(-1)]CopyRecordOptionsEnum Options,
		[in, defaultvalue(false)]VARIANT_BOOL Async,
		[out, retval]BSTR* pbstrNewURL);
	[id(0x00000008), helpcontext(0x0012cc86)]
	HRESULT __stdcall DeleteRecord(
		[in, defaultvalue("")]BSTR Source,
		[in, defaultvalue(false)]VARIANT_BOOL Async);
	[id(0x00000009), helpcontext(0x0012cc87)]
	HRESULT __stdcall Open(
		[in, optional]VARIANT Source,
		[in, optional]VARIANT ActiveConnection,
		[in, defaultvalue(0)]ConnectModeEnum Mode,
		[in, defaultvalue(-1)]RecordCreateOptionsEnum CreateOptions,
		[in, defaultvalue(-1)]RecordOpenOptionsEnum Options,
		[in, defaultvalue("")]BSTR UserName,
		[in, defaultvalue("")]BSTR Password);
	[id(0x0000000a), helpcontext(0x0012cc88)]
	HRESULT __stdcall Close();
	[id(0000000000), propget, helpcontext(0x0012cc89)]
	HRESULT __stdcall Fields(
		[out, retval]Fields** ppFlds);
	[id(0x0000000b), propget, helpcontext(0x0012cc8a)]
	HRESULT __stdcall RecordType(
		[out, retval]RecordTypeEnum* ptype);
	[id(0x0000000c), helpcontext(0x0012cc8d)]
	HRESULT __stdcall GetChildren(
		[out, retval]_Recordset** pprset);
	[id(0x0000000d), helpcontext(0x0012cc8c)]
	HRESULT __stdcall Cancel();
};
```
'!
!ADODB._Record categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB._Record methodsFor!

activeConnection
	"Answer the <variant> value of the 'ActiveConnection' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_ActiveConnection: answer.
	^answer asObject!

activeConnection: pvar
	"Set the 'ActiveConnection' property of the receiver to the <bstr> value of the argument."

	self put_ActiveConnection: pvar!

Cancel
	"Invoke the Cancel() method of the COM object.

		HRESULT __stdcall Cancel();"

	<virtual stdcall: hresult 27>
	^self invalidCall: _failureCode!

Close
	"Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 23>
	^self invalidCall: _failureCode!

copyRecord
	"Answer the <bstr> result of invoking the CopyRecord() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		copyRecord: ''
		destination: ''
		userName: ''
		password: ''
		options: -1
		async: false!

copyRecord: source destination: destination userName: userName password: password options: options async: async
	"Answer the <bstr> result of invoking the CopyRecord() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		CopyRecord: source
		Destination: destination
		UserName: userName
		Password: password
		Options: options
		Async: async
		pbstrNewURL: answer.
	^answer asObject!

CopyRecord: source Destination: destination UserName: userName Password: password Options: options Async: async pbstrNewURL: pbstrNewURL
	"Private - Invoke the CopyRecord() method of the COM object.

		HRESULT __stdcall CopyRecord(
			[in, defaultvalue('')]BSTR Source,
			[in, defaultvalue('')]BSTR Destination,
			[in, defaultvalue('')]BSTR UserName,
			[in, defaultvalue('')]BSTR Password,
			[in, defaultvalue(-1)]CopyRecordOptionsEnum Options,
			[in, defaultvalue(false)]VARIANT_BOOL Async,
			[out, retval]BSTR* pbstrNewURL);"

	<virtual stdcall: hresult 20 bstr bstr bstr bstr sdword varbool bstr*>
	^self invalidCall: _failureCode!

deleteRecord
	"Invoke the DeleteRecord() method of the COM object.
	Default values are passed for all optional parameters."

	^self DeleteRecord: '' Async: false!

DeleteRecord: source Async: async
	"Invoke the DeleteRecord() method of the COM object.

		HRESULT __stdcall DeleteRecord(
			[in, defaultvalue('')]BSTR Source,
			[in, defaultvalue(false)]VARIANT_BOOL Async);"

	<virtual stdcall: hresult 21 bstr varbool>
	^self invalidCall: _failureCode!

fields
	"Answer the <ADODB.Fields> value of the 'Fields' property of the receiver.
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk <sequencedReadableCollection>."

	| answer |
	answer := Fields newPointer.
	self get_Fields: answer.
	^ADOCollection on: answer!

get_ActiveConnection: pvar
	"Private - Get the value of the 'ActiveConnection' property of the receiver.

		HRESULT __stdcall ActiveConnection(
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 9 variant*>
	^self invalidCall: _failureCode!

get_Fields: ppFlds
	"Private - Get the value of the 'Fields' property of the receiver.

		HRESULT __stdcall Fields(
			[out, retval]Fields** ppFlds);"

	<virtual stdcall: hresult 24 Fields**>
	^self invalidCall: _failureCode!

get_Mode: pMode
	"Private - Get the value of the 'Mode' property of the receiver.

		HRESULT __stdcall Mode(
			[out, retval]ConnectModeEnum* pMode);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall: _failureCode!

get_ParentURL: pbstrParentURL
	"Private - Get the value of the 'ParentURL' property of the receiver.

		HRESULT __stdcall ParentURL(
			[out, retval]BSTR* pbstrParentURL);"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall: _failureCode!

get_RecordType: ptype
	"Private - Get the value of the 'RecordType' property of the receiver.

		HRESULT __stdcall RecordType(
			[out, retval]RecordTypeEnum* ptype);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall: _failureCode!

get_Source: pvar
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 13 variant*>
	^self invalidCall: _failureCode!

get_State: pState
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]ObjectStateEnum* pState);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

getChildren
	"Answer the <_Recordset> result of invoking the GetChildren() method of the COM object."

	| answer |
	answer := _Recordset newPointer.
	self GetChildren: answer.
	^answer asObject!

GetChildren: pprset
	"Private - Invoke the GetChildren() method of the COM object.

		HRESULT __stdcall GetChildren(
			[out, retval]_Recordset** pprset);"

	<virtual stdcall: hresult 26 _Recordset**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^true!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the type library, and must perform a run-time check for the _NewEnum property."

	^self has_NewEnum!

mode
	"Answer the <sdword> value of the 'Mode' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Mode: answer.
	^answer asObject!

mode: pMode
	"Set the 'Mode' property of the receiver to the <sdword> value of the argument."

	self put_Mode: pMode!

moveRecord
	"Answer the <bstr> result of invoking the MoveRecord() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		moveRecord: ''
		destination: ''
		userName: ''
		password: ''
		options: -1
		async: false!

moveRecord: source destination: destination userName: userName password: password options: options async: async
	"Answer the <bstr> result of invoking the MoveRecord() method of the COM object."

	| answer |
	answer := BSTR new.
	self
		MoveRecord: source
		Destination: destination
		UserName: userName
		Password: password
		Options: options
		Async: async
		pbstrNewURL: answer.
	^answer asObject!

MoveRecord: source Destination: destination UserName: userName Password: password Options: options Async: async pbstrNewURL: pbstrNewURL
	"Private - Invoke the MoveRecord() method of the COM object.

		HRESULT __stdcall MoveRecord(
			[in, defaultvalue('')]BSTR Source,
			[in, defaultvalue('')]BSTR Destination,
			[in, defaultvalue('')]BSTR UserName,
			[in, defaultvalue('')]BSTR Password,
			[in, defaultvalue(-1)]MoveRecordOptionsEnum Options,
			[in, defaultvalue(false)]VARIANT_BOOL Async,
			[out, retval]BSTR* pbstrNewURL);"

	<virtual stdcall: hresult 19 bstr bstr bstr bstr sdword varbool bstr*>
	^self invalidCall: _failureCode!

open
	"Invoke the Open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		open: VARIANT unspecified
		activeConnection: VARIANT unspecified
		mode: 0
		createOptions: -1
		options: -1
		userName: ''
		password: ''!

open: source activeConnection: activeConnection mode: mode createOptions: createOptions options: options userName: userName password: password
	"Invoke the Open() method of the COM object."

	^self
		Open: source asVariant
		ActiveConnection: activeConnection asVariant
		Mode: mode
		CreateOptions: createOptions
		Options: options
		UserName: userName
		Password: password!

Open: source ActiveConnection: activeConnection Mode: mode CreateOptions: createOptions Options: options UserName: userName Password: password
	"Private - Invoke the Open() method of the COM object.

		HRESULT __stdcall Open(
			[in, optional]VARIANT Source,
			[in, optional]VARIANT ActiveConnection,
			[in, defaultvalue(0)]ConnectModeEnum Mode,
			[in, defaultvalue(-1)]RecordCreateOptionsEnum CreateOptions,
			[in, defaultvalue(-1)]RecordOpenOptionsEnum Options,
			[in, defaultvalue('')]BSTR UserName,
			[in, defaultvalue('')]BSTR Password);"

	<virtual stdcall: hresult 22 variant variant sdword sdword sdword bstr bstr>
	^self invalidCall: _failureCode!

parentURL
	"Answer the <bstr> value of the 'ParentURL' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_ParentURL: answer.
	^answer asObject!

put_ActiveConnection: pvar
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <bstr> argument, pvar.

		HRESULT __stdcall ActiveConnection(
			[in]BSTR pvar);"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall: _failureCode!

put_Mode: pMode
	"Private - Set the value of the 'Mode' property of the object wrapped by the 
	 receiver to the <sdword> argument, pMode.

		HRESULT __stdcall Mode(
			[in]ConnectModeEnum pMode);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall: _failureCode!

put_Source: pvar
	"Private - Set the value of the 'Source' property of the object wrapped by the 
	 receiver to the <bstr> argument, pvar.

		HRESULT __stdcall Source(
			[in]BSTR pvar);"

	<virtual stdcall: hresult 14 bstr>
	^self invalidCall: _failureCode!

putref_ActiveConnection: pvar
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <_Connection*> argument, pvar.

		HRESULT __stdcall ActiveConnection(
			[in]_Connection* pvar);"

	<virtual stdcall: hresult 11 _Connection*>
	^self invalidCall: _failureCode!

putref_Source: pvar
	"Private - Set the value of the 'Source' property of the object wrapped by the 
	 receiver to the <IDispatch*> argument, pvar.

		HRESULT __stdcall Source(
			[in]IDispatch* pvar);"

	<virtual stdcall: hresult 15 IDispatch*>
	^self invalidCall: _failureCode!

recordType
	"Answer the <sdword> value of the 'RecordType' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_RecordType: answer.
	^answer asObject!

setActiveConnection: pvar
	"Set the 'ActiveConnection' property of the receiver to the <_Connection*> value of the argument."

	self putref_ActiveConnection: pvar!

setSource: pvar
	"Set the 'Source' property of the receiver to the <IDispatch*> value of the argument."

	self putref_Source: pvar!

source
	"Answer the <variant> value of the 'Source' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Source: answer.
	^answer asObject!

source: pvar
	"Set the 'Source' property of the receiver to the <bstr> value of the argument."

	self put_Source: pvar!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_State: answer.
	^answer asObject!

value
	"Answer the <Fields> value of the 'Fields' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self fields! !
!ADODB._Record categoriesFor: #activeConnection!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #activeConnection:!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #Cancel!**auto generated**!COM Interfaces-_Record!public! !
!ADODB._Record categoriesFor: #Close!**auto generated**!COM Interfaces-_Record!public! !
!ADODB._Record categoriesFor: #copyRecord!**auto generated**!methods!public! !
!ADODB._Record categoriesFor: #copyRecord:destination:userName:password:options:async:!**auto generated**!methods!public! !
!ADODB._Record categoriesFor: #CopyRecord:Destination:UserName:Password:Options:Async:pbstrNewURL:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #deleteRecord!**auto generated**!methods!public! !
!ADODB._Record categoriesFor: #DeleteRecord:Async:!**auto generated**!COM Interfaces-_Record!public! !
!ADODB._Record categoriesFor: #fields!properties!public! !
!ADODB._Record categoriesFor: #get_ActiveConnection:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #get_Fields:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #get_Mode:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #get_ParentURL:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #get_RecordType:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #get_Source:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #get_State:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #getChildren!**auto generated**!methods!public! !
!ADODB._Record categoriesFor: #GetChildren:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODB._Record categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODB._Record categoriesFor: #mode!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #mode:!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #moveRecord!**auto generated**!methods!public! !
!ADODB._Record categoriesFor: #moveRecord:destination:userName:password:options:async:!**auto generated**!methods!public! !
!ADODB._Record categoriesFor: #MoveRecord:Destination:UserName:Password:Options:Async:pbstrNewURL:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #open!**auto generated**!methods!public! !
!ADODB._Record categoriesFor: #open:activeConnection:mode:createOptions:options:userName:password:!**auto generated**!methods!public! !
!ADODB._Record categoriesFor: #Open:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #parentURL!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #put_ActiveConnection:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #put_Mode:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #put_Source:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #putref_ActiveConnection:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #putref_Source:!**auto generated**!COM Interfaces-_Record!private! !
!ADODB._Record categoriesFor: #recordType!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #setActiveConnection:!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #setSource:!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #source!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #source:!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #state!**auto generated**!properties!public! !
!ADODB._Record categoriesFor: #value!**auto generated**!properties!public! !

!ADODB._Record class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Record) for which the receiver is the default interface."

	^CLSID fromString: '{00000560-0000-0010-8000-00aa006d2ea4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Record'
		_Record defineTemplate"

	self
		defineFunction: #get_ActiveConnection:
			argumentTypes: 'variant*';
		defineFunction: #put_ActiveConnection:
			argumentTypes: 'bstr';
		defineFunction: #putref_ActiveConnection:
			argumentTypes: '_Connection*';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #get_Source:
			argumentTypes: 'variant*';
		defineFunction: #put_Source:
			argumentTypes: 'bstr';
		defineFunction: #putref_Source:
			argumentTypes: 'IDispatch*';
		defineFunction: #get_Mode:
			argumentTypes: 'sdword*';
		defineFunction: #put_Mode:
			argumentTypes: 'sdword';
		defineFunction: #get_ParentURL:
			argumentTypes: 'bstr*';
		defineFunction: #MoveRecord:Destination:UserName:Password:Options:Async:pbstrNewURL:
			argumentTypes: 'bstr bstr bstr bstr sdword varbool bstr*';
		defineFunction: #CopyRecord:Destination:UserName:Password:Options:Async:pbstrNewURL:
			argumentTypes: 'bstr bstr bstr bstr sdword varbool bstr*';
		defineFunction: #DeleteRecord:Async:
			argumentTypes: 'bstr varbool';
		defineFunction: #Open:ActiveConnection:Mode:CreateOptions:Options:UserName:Password:
			argumentTypes: 'variant variant sdword sdword sdword bstr bstr';
		defineFunction: #Close;
		defineFunction: #get_Fields:
			argumentTypes: 'Fields**';
		defineFunction: #get_RecordType:
			argumentTypes: 'sdword*';
		defineFunction: #GetChildren:
			argumentTypes: '_Recordset**';
		defineFunction: #Cancel
! !
!ADODB._Record class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB._Record class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

