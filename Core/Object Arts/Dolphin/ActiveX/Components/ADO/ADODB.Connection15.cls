"Filed out from Dolphin Smalltalk 7"!

ADODB._ADO subclass: #'ADODB.Connection15'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{ADODB.ADODBConstants private})
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Connection15 guid: (OS.COM.IID fromString: '{00001515-0000-0010-8000-00aa006d2ea4}')!
ADODB.Connection15 comment: '`ADODBConnection15` is a wrapper class for the COM interface ''ADODB.Connection15'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001515-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c901), 
	hidden, 
	dual
]
interface Connection15 : _ADO
 {
	[id(0000000000), propget, helpcontext(0x0012c918)]
	HRESULT __stdcall ConnectionString(
		[out, retval]BSTR* pbstr);
	[id(0000000000), propput, helpcontext(0x0012c918)]
	HRESULT __stdcall ConnectionString(
		[in]BSTR pbstr);
	[id(0x00000002), propget, helpcontext(0x0012c914)]
	HRESULT __stdcall CommandTimeout(
		[out, retval]long* plTimeout);
	[id(0x00000002), propput, helpcontext(0x0012c914)]
	HRESULT __stdcall CommandTimeout(
		[in]long plTimeout);
	[id(0x00000003), propget, helpcontext(0x0012c919)]
	HRESULT __stdcall ConnectionTimeout(
		[out, retval]long* plTimeout);
	[id(0x00000003), propput, helpcontext(0x0012c919)]
	HRESULT __stdcall ConnectionTimeout(
		[in]long plTimeout);
	[id(0x00000004), propget, helpcontext(0x0012c94e)]
	HRESULT __stdcall Version(
		[out, retval]BSTR* pbstr);
	[id(0x00000005), helpcontext(0x0012c8bf)]
	HRESULT __stdcall Close();
	[id(0x00000006), helpcontext(0x0012c8cc)]
	HRESULT __stdcall Execute(
		[in]BSTR CommandText,
		[out, optional]VARIANT* RecordsAffected,
		[in, defaultvalue(-1)]long Options,
		[out, retval]_Recordset** ppiRset);
	[id(0x00000007), helpcontext(0x0012c8b7)]
	HRESULT __stdcall BeginTrans(
		[out, retval]long* TransactionLevel);
	[id(0x00000008), helpcontext(0x000f4248)]
	HRESULT __stdcall CommitTrans();
	[id(0x00000009), helpcontext(0x000f4249)]
	HRESULT __stdcall RollbackTrans();
	[id(0x0000000a), helpcontext(0x0012c8d6)]
	HRESULT __stdcall Open(
		[in, defaultvalue("")]BSTR ConnectionString,
		[in, defaultvalue("")]BSTR UserID,
		[in, defaultvalue("")]BSTR Password,
		[in, defaultvalue(-1)]long Options);
	[id(0x0000000b), propget, helpcontext(0x0012c8fd)]
	HRESULT __stdcall Errors(
		[out, retval]Errors** ppvObject);
	[id(0x0000000c), propget, helpcontext(0x0012c91d)]
	HRESULT __stdcall DefaultDatabase(
		[out, retval]BSTR* pbstr);
	[id(0x0000000c), propput, helpcontext(0x0012c91d)]
	HRESULT __stdcall DefaultDatabase(
		[in]BSTR pbstr);
	[id(0x0000000d), propget, helpcontext(0x0012c92a)]
	HRESULT __stdcall IsolationLevel(
		[out, retval]IsolationLevelEnum* Level);
	[id(0x0000000d), propput, helpcontext(0x0012c92a)]
	HRESULT __stdcall IsolationLevel(
		[in]IsolationLevelEnum Level);
	[id(0x0000000e), propget, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[out, retval]long* plAttr);
	[id(0x0000000e), propput, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[in]long plAttr);
	[id(0x0000000f), propget, helpcontext(0x0012c91b)]
	HRESULT __stdcall CursorLocation(
		[out, retval]CursorLocationEnum* plCursorLoc);
	[id(0x0000000f), propput, helpcontext(0x0012c91b)]
	HRESULT __stdcall CursorLocation(
		[in]CursorLocationEnum plCursorLoc);
	[id(0x00000010), propget, helpcontext(0x0012c92e)]
	HRESULT __stdcall Mode(
		[out, retval]ConnectModeEnum* plMode);
	[id(0x00000010), propput, helpcontext(0x0012c92e)]
	HRESULT __stdcall Mode(
		[in]ConnectModeEnum plMode);
	[id(0x00000011), propget, helpcontext(0x0012c93a)]
	HRESULT __stdcall Provider(
		[out, retval]BSTR* pbstr);
	[id(0x00000011), propput, helpcontext(0x0012c93a)]
	HRESULT __stdcall Provider(
		[in]BSTR pbstr);
	[id(0x00000012), propget, helpcontext(0x0012c948)]
	HRESULT __stdcall State(
		[out, retval]long* plObjState);
	[id(0x00000013), helpcontext(0x0012c8d8)]
	HRESULT __stdcall OpenSchema(
		[in]SchemaEnum Schema,
		[in, optional]VARIANT Restrictions,
		[in, optional]VARIANT SchemaID,
		[out, retval]_Recordset** pprset);
};
```
'!
!ADODB.Connection15 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Connection15 methodsFor!

attributes
	"Answer the <sdword> value of the 'Attributes' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Attributes: answer.
	^answer asObject!

attributes: plAttr
	"Set the 'Attributes' property of the receiver to the <sdword> value of the argument."

	self put_Attributes: plAttr!

beginTrans
	"Answer the <SDWORD> result of invoking the BeginTrans() method of the COM object."

	| answer |
	answer := SDWORD new.
	self BeginTrans: answer.
	^answer asObject!

BeginTrans: transactionLevel
	"Private - Invoke the BeginTrans() method of the COM object.

		HRESULT __stdcall BeginTrans(
			[out, retval]long* TransactionLevel);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall: _failureCode!

Close
	"Invoke the Close() method of the COM object.

		HRESULT __stdcall Close();"

	<virtual stdcall: hresult 16>
	^self invalidCall: _failureCode!

commandTimeout
	"Answer the <sdword> value of the 'CommandTimeout' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CommandTimeout: answer.
	^answer asObject!

commandTimeout: plTimeout
	"Set the 'CommandTimeout' property of the receiver to the <sdword> value of the argument."

	self put_CommandTimeout: plTimeout!

CommitTrans
	"Invoke the CommitTrans() method of the COM object.

		HRESULT __stdcall CommitTrans();"

	<virtual stdcall: hresult 19>
	^self invalidCall: _failureCode!

connectionString
	"Answer the <bstr> value of the 'ConnectionString' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_ConnectionString: answer.
	^answer asObject!

connectionString: pbstr
	"Set the 'ConnectionString' property of the receiver to the <bstr> value of the argument."

	self put_ConnectionString: pbstr!

connectionTimeout
	"Answer the <sdword> value of the 'ConnectionTimeout' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ConnectionTimeout: answer.
	^answer asObject!

connectionTimeout: plTimeout
	"Set the 'ConnectionTimeout' property of the receiver to the <sdword> value of the argument."

	self put_ConnectionTimeout: plTimeout!

cursorLocation
	"Answer the <sdword> value of the 'CursorLocation' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CursorLocation: answer.
	^answer asObject!

cursorLocation: plCursorLoc
	"Set the 'CursorLocation' property of the receiver to the <sdword> value of the argument."

	self put_CursorLocation: plCursorLoc!

defaultDatabase
	"Answer the <bstr> value of the 'DefaultDatabase' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_DefaultDatabase: answer.
	^answer asObject!

defaultDatabase: pbstr
	"Set the 'DefaultDatabase' property of the receiver to the <bstr> value of the argument."

	self put_DefaultDatabase: pbstr!

errors
	"Answer the <Errors> value of the 'Errors' property of the receiver."

	| answer |
	answer := Errors newPointer.
	self get_Errors: answer.
	^answer asObject!

execute: commandText
	"Invoke the Execute() method of the COM object.
	Default values are passed for all optional parameters."

	^self execute: commandText options: -1!

execute: commandText options: options
	"Invoke the Execute() method of the COM object."

	| outputs |
	outputs := {VARIANT new. _Recordset newPointer}.
	self
		Execute: commandText
		RecordsAffected: (outputs basicAt: 1)
		Options: options
		ppiRset: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

Execute: commandText RecordsAffected: recordsAffected Options: options ppiRset: ppiRset
	"Private - Invoke the Execute() method of the COM object.

		HRESULT __stdcall Execute(
			[in]BSTR CommandText,
			[out, optional]VARIANT* RecordsAffected,
			[in, defaultvalue(-1)]long Options,
			[out, retval]_Recordset** ppiRset);"

	<virtual stdcall: hresult 17 bstr variant* sdword _Recordset**>
	^self invalidCall: _failureCode!

get_Attributes: plAttr
	"Private - Get the value of the 'Attributes' property of the receiver.

		HRESULT __stdcall Attributes(
			[out, retval]long* plAttr);"

	<virtual stdcall: hresult 27 sdword*>
	^self invalidCall: _failureCode!

get_CommandTimeout: plTimeout
	"Private - Get the value of the 'CommandTimeout' property of the receiver.

		HRESULT __stdcall CommandTimeout(
			[out, retval]long* plTimeout);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_ConnectionString: pbstr
	"Private - Get the value of the 'ConnectionString' property of the receiver.

		HRESULT __stdcall ConnectionString(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

get_ConnectionTimeout: plTimeout
	"Private - Get the value of the 'ConnectionTimeout' property of the receiver.

		HRESULT __stdcall ConnectionTimeout(
			[out, retval]long* plTimeout);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall: _failureCode!

get_CursorLocation: plCursorLoc
	"Private - Get the value of the 'CursorLocation' property of the receiver.

		HRESULT __stdcall CursorLocation(
			[out, retval]CursorLocationEnum* plCursorLoc);"

	<virtual stdcall: hresult 29 sdword*>
	^self invalidCall: _failureCode!

get_DefaultDatabase: pbstr
	"Private - Get the value of the 'DefaultDatabase' property of the receiver.

		HRESULT __stdcall DefaultDatabase(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 23 bstr*>
	^self invalidCall: _failureCode!

get_Errors: ppvObject
	"Private - Get the value of the 'Errors' property of the receiver.

		HRESULT __stdcall Errors(
			[out, retval]Errors** ppvObject);"

	<virtual stdcall: hresult 22 Errors**>
	^self invalidCall: _failureCode!

get_IsolationLevel: level
	"Private - Get the value of the 'IsolationLevel' property of the receiver.

		HRESULT __stdcall IsolationLevel(
			[out, retval]IsolationLevelEnum* Level);"

	<virtual stdcall: hresult 25 sdword*>
	^self invalidCall: _failureCode!

get_Mode: plMode
	"Private - Get the value of the 'Mode' property of the receiver.

		HRESULT __stdcall Mode(
			[out, retval]ConnectModeEnum* plMode);"

	<virtual stdcall: hresult 31 sdword*>
	^self invalidCall: _failureCode!

get_Provider: pbstr
	"Private - Get the value of the 'Provider' property of the receiver.

		HRESULT __stdcall Provider(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 33 bstr*>
	^self invalidCall: _failureCode!

get_State: plObjState
	"Private - Get the value of the 'State' property of the receiver.

		HRESULT __stdcall State(
			[out, retval]long* plObjState);"

	<virtual stdcall: hresult 35 sdword*>
	^self invalidCall: _failureCode!

get_Version: pbstr
	"Private - Get the value of the 'Version' property of the receiver.

		HRESULT __stdcall Version(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 15 bstr*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^true!

isolationLevel
	"Answer the <sdword> value of the 'IsolationLevel' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsolationLevel: answer.
	^answer asObject!

isolationLevel: level
	"Set the 'IsolationLevel' property of the receiver to the <sdword> value of the argument."

	self put_IsolationLevel: level!

isVBCollection
	"Answer whether the receiver is a VB style collection.
	The receiver is dynamically extensible, so we cannot determine this from the type library,
       and must perform a run-time check for the _NewEnum property."

	^self has_NewEnum!

mode
	"Answer the <sdword> value of the 'Mode' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Mode: answer.
	^answer asObject!

mode: plMode
	"Set the 'Mode' property of the receiver to the <sdword> value of the argument."

	self put_Mode: plMode!

open
	"Invoke the Open() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		Open: ''
		UserID: ''
		Password: ''
		Options: -1!

open: aString 
	"Open the database using the specified connection string."

	^self 
		Open: aString
		UserID: ''
		Password: ''
		Options: -1!

Open: connectionString UserID: userID Password: password Options: options
	"Invoke the Open() method of the COM object.

		HRESULT __stdcall Open(
			[in, defaultvalue('')]BSTR ConnectionString,
			[in, defaultvalue('')]BSTR UserID,
			[in, defaultvalue('')]BSTR Password,
			[in, defaultvalue(-1)]long Options);"

	<virtual stdcall: hresult 21 bstr bstr bstr sdword>
	^self invalidCall: _failureCode!

openSchema: schema
	"Answer the <_Recordset> result of invoking the OpenSchema() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		openSchema: schema
		restrictions: VARIANT unspecified
		schemaID: VARIANT unspecified!

openSchema: schema restrictions: restrictions schemaID: schemaID
	"Answer the <_Recordset> result of invoking the OpenSchema() method of the COM object."

	| answer |
	answer := _Recordset newPointer.
	self
		OpenSchema: schema
		Restrictions: restrictions asVariant
		SchemaID: schemaID asVariant
		pprset: answer.
	^answer asObject!

OpenSchema: schema Restrictions: restrictions SchemaID: schemaID pprset: pprset
	"Private - Invoke the OpenSchema() method of the COM object.

		HRESULT __stdcall OpenSchema(
			[in]SchemaEnum Schema,
			[in, optional]VARIANT Restrictions,
			[in, optional]VARIANT SchemaID,
			[out, retval]_Recordset** pprset);"

	<virtual stdcall: hresult 36 sdword variant variant _Recordset**>
	^self invalidCall: _failureCode!

provider
	"Answer the <bstr> value of the 'Provider' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Provider: answer.
	^answer asObject!

provider: pbstr
	"Set the 'Provider' property of the receiver to the <bstr> value of the argument."

	self put_Provider: pbstr!

put_Attributes: plAttr
	"Private - Set the value of the 'Attributes' property of the object wrapped by the 
	 receiver to the <sdword> argument, plAttr.

		HRESULT __stdcall Attributes(
			[in]long plAttr);"

	<virtual stdcall: hresult 28 sdword>
	^self invalidCall: _failureCode!

put_CommandTimeout: plTimeout
	"Private - Set the value of the 'CommandTimeout' property of the object wrapped by the 
	 receiver to the <sdword> argument, plTimeout.

		HRESULT __stdcall CommandTimeout(
			[in]long plTimeout);"

	<virtual stdcall: hresult 12 sdword>
	^self invalidCall: _failureCode!

put_ConnectionString: pbstr
	"Private - Set the value of the 'ConnectionString' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.

		HRESULT __stdcall ConnectionString(
			[in]BSTR pbstr);"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall: _failureCode!

put_ConnectionTimeout: plTimeout
	"Private - Set the value of the 'ConnectionTimeout' property of the object wrapped by the 
	 receiver to the <sdword> argument, plTimeout.

		HRESULT __stdcall ConnectionTimeout(
			[in]long plTimeout);"

	<virtual stdcall: hresult 14 sdword>
	^self invalidCall: _failureCode!

put_CursorLocation: plCursorLoc
	"Private - Set the value of the 'CursorLocation' property of the object wrapped by the 
	 receiver to the <sdword> argument, plCursorLoc.

		HRESULT __stdcall CursorLocation(
			[in]CursorLocationEnum plCursorLoc);"

	<virtual stdcall: hresult 30 sdword>
	^self invalidCall: _failureCode!

put_DefaultDatabase: pbstr
	"Private - Set the value of the 'DefaultDatabase' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.

		HRESULT __stdcall DefaultDatabase(
			[in]BSTR pbstr);"

	<virtual stdcall: hresult 24 bstr>
	^self invalidCall: _failureCode!

put_IsolationLevel: level
	"Private - Set the value of the 'IsolationLevel' property of the object wrapped by the 
	 receiver to the <sdword> argument, level.

		HRESULT __stdcall IsolationLevel(
			[in]IsolationLevelEnum Level);"

	<virtual stdcall: hresult 26 sdword>
	^self invalidCall: _failureCode!

put_Mode: plMode
	"Private - Set the value of the 'Mode' property of the object wrapped by the 
	 receiver to the <sdword> argument, plMode.

		HRESULT __stdcall Mode(
			[in]ConnectModeEnum plMode);"

	<virtual stdcall: hresult 32 sdword>
	^self invalidCall: _failureCode!

put_Provider: pbstr
	"Private - Set the value of the 'Provider' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.

		HRESULT __stdcall Provider(
			[in]BSTR pbstr);"

	<virtual stdcall: hresult 34 bstr>
	^self invalidCall: _failureCode!

query: aString 
	"Execute the SQL in aString.
	Answer an <_Recordset> representing the resultant result set."

	^(self execute: aString options: adCmdText) second!

RollbackTrans
	"Invoke the RollbackTrans() method of the COM object.

		HRESULT __stdcall RollbackTrans();"

	<virtual stdcall: hresult 20>
	^self invalidCall: _failureCode!

state
	"Answer the <sdword> value of the 'State' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_State: answer.
	^answer asObject!

value
	"Answer the <bstr> value of the 'ConnectionString' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self connectionString!

value: pbstr
	"Set the 'ConnectionString' property of the receiver to the <bstr> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self connectionString: pbstr!

version
	"Answer the <bstr> value of the 'Version' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Version: answer.
	^answer asObject! !
!ADODB.Connection15 categoriesFor: #attributes!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #attributes:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #beginTrans!**auto generated**!methods!public! !
!ADODB.Connection15 categoriesFor: #BeginTrans:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #Close!**auto generated**!COM Interfaces-Connection15!public! !
!ADODB.Connection15 categoriesFor: #commandTimeout!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #commandTimeout:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #CommitTrans!**auto generated**!COM Interfaces-Connection15!public! !
!ADODB.Connection15 categoriesFor: #connectionString!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #connectionString:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #connectionTimeout!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #connectionTimeout:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #cursorLocation!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #cursorLocation:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #defaultDatabase!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #defaultDatabase:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #errors!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #execute:!**auto generated**!methods!public! !
!ADODB.Connection15 categoriesFor: #execute:options:!**auto generated**!methods!public! !
!ADODB.Connection15 categoriesFor: #Execute:RecordsAffected:Options:ppiRset:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_Attributes:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_CommandTimeout:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_ConnectionString:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_ConnectionTimeout:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_CursorLocation:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_DefaultDatabase:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_Errors:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_IsolationLevel:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_Mode:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_Provider:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_State:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #get_Version:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODB.Connection15 categoriesFor: #isolationLevel!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #isolationLevel:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODB.Connection15 categoriesFor: #mode!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #mode:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #open!**auto generated**!methods!public! !
!ADODB.Connection15 categoriesFor: #open:!operations!public! !
!ADODB.Connection15 categoriesFor: #Open:UserID:Password:Options:!**auto generated**!COM Interfaces-Connection15!public! !
!ADODB.Connection15 categoriesFor: #openSchema:!**auto generated**!methods!public! !
!ADODB.Connection15 categoriesFor: #openSchema:restrictions:schemaID:!**auto generated**!methods!public! !
!ADODB.Connection15 categoriesFor: #OpenSchema:Restrictions:SchemaID:pprset:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #provider!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #provider:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #put_Attributes:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #put_CommandTimeout:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #put_ConnectionString:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #put_ConnectionTimeout:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #put_CursorLocation:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #put_DefaultDatabase:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #put_IsolationLevel:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #put_Mode:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #put_Provider:!**auto generated**!COM Interfaces-Connection15!private! !
!ADODB.Connection15 categoriesFor: #query:!executing!public! !
!ADODB.Connection15 categoriesFor: #RollbackTrans!**auto generated**!COM Interfaces-Connection15!public! !
!ADODB.Connection15 categoriesFor: #state!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #value!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #value:!**auto generated**!properties!public! !
!ADODB.Connection15 categoriesFor: #version!**auto generated**!properties!public! !

!ADODB.Connection15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Connection15'
		Connection15 defineTemplate"

	self
		defineFunction: #get_ConnectionString:
			argumentTypes: 'bstr*';
		defineFunction: #put_ConnectionString:
			argumentTypes: 'bstr';
		defineFunction: #get_CommandTimeout:
			argumentTypes: 'sdword*';
		defineFunction: #put_CommandTimeout:
			argumentTypes: 'sdword';
		defineFunction: #get_ConnectionTimeout:
			argumentTypes: 'sdword*';
		defineFunction: #put_ConnectionTimeout:
			argumentTypes: 'sdword';
		defineFunction: #get_Version:
			argumentTypes: 'bstr*';
		defineFunction: #Close;
		defineFunction: #Execute:RecordsAffected:Options:ppiRset:
			argumentTypes: 'bstr variant* sdword _Recordset**';
		defineFunction: #BeginTrans:
			argumentTypes: 'sdword*';
		defineFunction: #CommitTrans;
		defineFunction: #RollbackTrans;
		defineFunction: #Open:UserID:Password:Options:
			argumentTypes: 'bstr bstr bstr sdword';
		defineFunction: #get_Errors:
			argumentTypes: 'Errors**';
		defineFunction: #get_DefaultDatabase:
			argumentTypes: 'bstr*';
		defineFunction: #put_DefaultDatabase:
			argumentTypes: 'bstr';
		defineFunction: #get_IsolationLevel:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsolationLevel:
			argumentTypes: 'sdword';
		defineFunction: #get_Attributes:
			argumentTypes: 'sdword*';
		defineFunction: #put_Attributes:
			argumentTypes: 'sdword';
		defineFunction: #get_CursorLocation:
			argumentTypes: 'sdword*';
		defineFunction: #put_CursorLocation:
			argumentTypes: 'sdword';
		defineFunction: #get_Mode:
			argumentTypes: 'sdword*';
		defineFunction: #put_Mode:
			argumentTypes: 'sdword';
		defineFunction: #get_Provider:
			argumentTypes: 'bstr*';
		defineFunction: #put_Provider:
			argumentTypes: 'bstr';
		defineFunction: #get_State:
			argumentTypes: 'sdword*';
		defineFunction: #OpenSchema:Restrictions:SchemaID:pprset:
			argumentTypes: 'sdword variant variant _Recordset**'
! !
!ADODB.Connection15 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

