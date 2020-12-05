"Filed out from Dolphin Smalltalk 7"!

ADODB._ADO subclass: #'ADODB.Command15'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Command15 guid: (OS.COM.IID fromString: '{00001508-0000-0010-8000-00aa006d2ea4}')!
ADODB.Command15 comment: '`ADODBCommand15` is a wrapper class for the COM interface ''ADODB.Command15'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001508-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c902), 
	hidden, 
	nonextensible, 
	dual
]
interface Command15 : _ADO
 {
	[id(0x00000001), propget, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[out, retval]_Connection** ppvObject);
	[id(0x00000001), propputref, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[in]_Connection* ppvObject);
	[id(0x00000001), propput, helpcontext(0x0012c90b)]
	HRESULT __stdcall ActiveConnection(
		[in]VARIANT ppvObject);
	[id(0x00000002), propget, helpcontext(0x0012c913)]
	HRESULT __stdcall CommandText(
		[out, retval]BSTR* pbstr);
	[id(0x00000002), propput, helpcontext(0x0012c913)]
	HRESULT __stdcall CommandText(
		[in]BSTR pbstr);
	[id(0x00000003), propget, helpcontext(0x0012c914)]
	HRESULT __stdcall CommandTimeout(
		[out, retval]long* pl);
	[id(0x00000003), propput, helpcontext(0x0012c914)]
	HRESULT __stdcall CommandTimeout(
		[in]long pl);
	[id(0x00000004), propget, helpcontext(0x0012c939)]
	HRESULT __stdcall Prepared(
		[out, retval]VARIANT_BOOL* pfPrepared);
	[id(0x00000004), propput, helpcontext(0x0012c939)]
	HRESULT __stdcall Prepared(
		[in]VARIANT_BOOL pfPrepared);
	[id(0x00000005), helpcontext(0x0012c8cb)]
	HRESULT __stdcall Execute(
		[out, optional]VARIANT* RecordsAffected,
		[in, optional]VARIANT* Parameters,
		[in, defaultvalue(-1)]long Options,
		[out, retval]_Recordset** ppiRs);
	[id(0x00000006), helpcontext(0x0012c8c2)]
	HRESULT __stdcall CreateParameter(
		[in, defaultvalue("")]BSTR Name,
		[in, defaultvalue(0)]DataTypeEnum Type,
		[in, defaultvalue(1)]ParameterDirectionEnum Direction,
		[in, defaultvalue(0)]long Size,
		[in, optional]VARIANT Value,
		[out, retval]_Parameter** ppiprm);
	[id(0000000000), propget, helpcontext(0x0012c8ff)]
	HRESULT __stdcall Parameters(
		[out, retval]Parameters** ppvObject);
	[id(0x00000007), propput, helpcontext(0x0012c915)]
	HRESULT __stdcall CommandType(
		[in]CommandTypeEnum plCmdType);
	[id(0x00000007), propget, helpcontext(0x0012c915)]
	HRESULT __stdcall CommandType(
		[out, retval]CommandTypeEnum* plCmdType);
	[id(0x00000008), propget, helpcontext(0x0012c92f)]
	HRESULT __stdcall Name(
		[out, retval]BSTR* pbstrName);
	[id(0x00000008), propput, helpcontext(0x0012c92f)]
	HRESULT __stdcall Name(
		[in]BSTR pbstrName);
};
```
'!
!ADODB.Command15 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Command15 methodsFor!

activeConnection
	"Answer the <_Connection> value of the 'ActiveConnection' property of the receiver."

	| answer |
	answer := _Connection newPointer.
	self get_ActiveConnection: answer.
	^answer asObject!

activeConnection: ppvObject
	"Set the 'ActiveConnection' property of the receiver to the <variant> value of the argument."

	self put_ActiveConnection: ppvObject asVariant!

commandText
	"Answer the <bstr> value of the 'CommandText' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_CommandText: answer.
	^answer asObject!

commandText: pbstr
	"Set the 'CommandText' property of the receiver to the <bstr> value of the argument."

	self put_CommandText: pbstr!

commandTimeout
	"Answer the <sdword> value of the 'CommandTimeout' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CommandTimeout: answer.
	^answer asObject!

commandTimeout: pl
	"Set the 'CommandTimeout' property of the receiver to the <sdword> value of the argument."

	self put_CommandTimeout: pl!

commandType
	"Answer the <sdword> value of the 'CommandType' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CommandType: answer.
	^answer asObject!

commandType: plCmdType
	"Set the 'CommandType' property of the receiver to the <sdword> value of the argument."

	self put_CommandType: plCmdType!

createParameter
	"Answer the <_Parameter> result of invoking the CreateParameter() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		createParameter: ''
		type: 0
		direction: 1
		size: 0
		value: VARIANT unspecified!

createParameter: name type: type direction: direction size: size value: value
	"Answer the <_Parameter> result of invoking the CreateParameter() method of the COM object."

	| answer |
	answer := _Parameter newPointer.
	self
		CreateParameter: name
		Type: type
		Direction: direction
		Size: size
		Value: value asVariant
		ppiprm: answer.
	^answer asObject!

CreateParameter: name Type: type Direction: direction Size: size Value: value ppiprm: ppiprm
	"Private - Invoke the CreateParameter() method of the COM object.

		HRESULT __stdcall CreateParameter(
			[in, defaultvalue('')]BSTR Name,
			[in, defaultvalue(0)]DataTypeEnum Type,
			[in, defaultvalue(1)]ParameterDirectionEnum Direction,
			[in, defaultvalue(0)]long Size,
			[in, optional]VARIANT Value,
			[out, retval]_Parameter** ppiprm);"

	<virtual stdcall: hresult 19 bstr sdword sdword sdword variant _Parameter**>
	^self invalidCall: _failureCode!

execute
	"Invoke the Execute() method of the COM object.
	Default values are passed for all optional parameters."

	^self execute: VARIANT unspecified options: -1!

execute: parameters options: options
	"Invoke the Execute() method of the COM object."

	| outputs |
	outputs := {VARIANT new. _Recordset newPointer}.
	self
		Execute: (outputs basicAt: 1)
		Parameters: parameters asVariant
		Options: options
		ppiRs: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

Execute: recordsAffected Parameters: parameters Options: options ppiRs: ppiRs
	"Private - Invoke the Execute() method of the COM object.

		HRESULT __stdcall Execute(
			[out, optional]VARIANT* RecordsAffected,
			[in, optional]VARIANT* Parameters,
			[in, defaultvalue(-1)]long Options,
			[out, retval]_Recordset** ppiRs);"

	<virtual stdcall: hresult 18 variant* variant* sdword _Recordset**>
	^self invalidCall: _failureCode!

get_ActiveConnection: ppvObject
	"Private - Get the value of the 'ActiveConnection' property of the receiver.

		HRESULT __stdcall ActiveConnection(
			[out, retval]_Connection** ppvObject);"

	<virtual stdcall: hresult 9 _Connection**>
	^self invalidCall: _failureCode!

get_CommandText: pbstr
	"Private - Get the value of the 'CommandText' property of the receiver.

		HRESULT __stdcall CommandText(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall: _failureCode!

get_CommandTimeout: pl
	"Private - Get the value of the 'CommandTimeout' property of the receiver.

		HRESULT __stdcall CommandTimeout(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall: _failureCode!

get_CommandType: plCmdType
	"Private - Get the value of the 'CommandType' property of the receiver.

		HRESULT __stdcall CommandType(
			[out, retval]CommandTypeEnum* plCmdType);"

	<virtual stdcall: hresult 22 sdword*>
	^self invalidCall: _failureCode!

get_Name: pbstrName
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval]BSTR* pbstrName);"

	<virtual stdcall: hresult 23 bstr*>
	^self invalidCall: _failureCode!

get_Parameters: ppvObject
	"Private - Get the value of the 'Parameters' property of the receiver.

		HRESULT __stdcall Parameters(
			[out, retval]Parameters** ppvObject);"

	<virtual stdcall: hresult 20 Parameters**>
	^self invalidCall: _failureCode!

get_Prepared: pfPrepared
	"Private - Get the value of the 'Prepared' property of the receiver.

		HRESULT __stdcall Prepared(
			[out, retval]VARIANT_BOOL* pfPrepared);"

	<virtual stdcall: hresult 16 varbool*>
	^self invalidCall: _failureCode!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject!

name: pbstrName
	"Set the 'Name' property of the receiver to the <bstr> value of the argument."

	self put_Name: pbstrName!

parameters
	"Answer the <Parameters> value of the 'Parameters' property of the receiver.
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk sequenceable collection."

	| answer |
	answer := Parameters newPointer.
	self get_Parameters: answer.
	^ADODynaCollection on: answer!

prepared
	"Answer the <varbool> value of the 'Prepared' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_Prepared: answer.
	^answer asObject!

prepared: pfPrepared
	"Set the 'Prepared' property of the receiver to the <varbool> value of the argument."

	self put_Prepared: pfPrepared!

put_ActiveConnection: ppvObject
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <variant> argument, ppvObject.

		HRESULT __stdcall ActiveConnection(
			[in]VARIANT ppvObject);"

	<virtual stdcall: hresult 11 variant>
	^self invalidCall: _failureCode!

put_CommandText: pbstr
	"Private - Set the value of the 'CommandText' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.

		HRESULT __stdcall CommandText(
			[in]BSTR pbstr);"

	<virtual stdcall: hresult 13 bstr>
	^self invalidCall: _failureCode!

put_CommandTimeout: pl
	"Private - Set the value of the 'CommandTimeout' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall CommandTimeout(
			[in]long pl);"

	<virtual stdcall: hresult 15 sdword>
	^self invalidCall: _failureCode!

put_CommandType: plCmdType
	"Private - Set the value of the 'CommandType' property of the object wrapped by the 
	 receiver to the <sdword> argument, plCmdType.

		HRESULT __stdcall CommandType(
			[in]CommandTypeEnum plCmdType);"

	<virtual stdcall: hresult 21 sdword>
	^self invalidCall: _failureCode!

put_Name: pbstrName
	"Private - Set the value of the 'Name' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrName.

		HRESULT __stdcall Name(
			[in]BSTR pbstrName);"

	<virtual stdcall: hresult 24 bstr>
	^self invalidCall: _failureCode!

put_Prepared: pfPrepared
	"Private - Set the value of the 'Prepared' property of the object wrapped by the 
	 receiver to the <varbool> argument, pfPrepared.

		HRESULT __stdcall Prepared(
			[in]VARIANT_BOOL pfPrepared);"

	<virtual stdcall: hresult 17 varbool>
	^self invalidCall: _failureCode!

putref_ActiveConnection: ppvObject
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <_Connection*> argument, ppvObject.

		HRESULT __stdcall ActiveConnection(
			[in]_Connection* ppvObject);"

	<virtual stdcall: hresult 10 _Connection*>
	^self invalidCall: _failureCode!

setActiveConnection: ppvObject
	"Set the 'ActiveConnection' property of the receiver to the <_Connection*> value of the argument."

	self putref_ActiveConnection: ppvObject!

value
	"Answer the <Parameters> value of the 'Parameters' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self parameters! !
!ADODB.Command15 categoriesFor: #activeConnection!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #activeConnection:!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #commandText!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #commandText:!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #commandTimeout!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #commandTimeout:!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #commandType!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #commandType:!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #createParameter!**auto generated**!methods!public! !
!ADODB.Command15 categoriesFor: #createParameter:type:direction:size:value:!**auto generated**!methods!public! !
!ADODB.Command15 categoriesFor: #CreateParameter:Type:Direction:Size:Value:ppiprm:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #execute!**auto generated**!methods!public! !
!ADODB.Command15 categoriesFor: #execute:options:!**auto generated**!methods!public! !
!ADODB.Command15 categoriesFor: #Execute:Parameters:Options:ppiRs:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #get_ActiveConnection:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #get_CommandText:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #get_CommandTimeout:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #get_CommandType:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #get_Name:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #get_Parameters:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #get_Prepared:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #name!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #name:!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #parameters!properties!public! !
!ADODB.Command15 categoriesFor: #prepared!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #prepared:!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #put_ActiveConnection:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #put_CommandText:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #put_CommandTimeout:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #put_CommandType:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #put_Name:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #put_Prepared:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #putref_ActiveConnection:!**auto generated**!COM Interfaces-Command15!private! !
!ADODB.Command15 categoriesFor: #setActiveConnection:!**auto generated**!properties!public! !
!ADODB.Command15 categoriesFor: #value!**auto generated**!properties!public! !

!ADODB.Command15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Command15'
		Command15 defineTemplate"

	self
		defineFunction: #get_ActiveConnection:
			argumentTypes: '_Connection**';
		defineFunction: #putref_ActiveConnection:
			argumentTypes: '_Connection*';
		defineFunction: #put_ActiveConnection:
			argumentTypes: 'variant';
		defineFunction: #get_CommandText:
			argumentTypes: 'bstr*';
		defineFunction: #put_CommandText:
			argumentTypes: 'bstr';
		defineFunction: #get_CommandTimeout:
			argumentTypes: 'sdword*';
		defineFunction: #put_CommandTimeout:
			argumentTypes: 'sdword';
		defineFunction: #get_Prepared:
			argumentTypes: 'varbool*';
		defineFunction: #put_Prepared:
			argumentTypes: 'varbool';
		defineFunction: #Execute:Parameters:Options:ppiRs:
			argumentTypes: 'variant* variant* sdword _Recordset**';
		defineFunction: #CreateParameter:Type:Direction:Size:Value:ppiprm:
			argumentTypes: 'bstr sdword sdword sdword variant _Parameter**';
		defineFunction: #get_Parameters:
			argumentTypes: 'Parameters**';
		defineFunction: #put_CommandType:
			argumentTypes: 'sdword';
		defineFunction: #get_CommandType:
			argumentTypes: 'sdword*';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #put_Name:
			argumentTypes: 'bstr'
! !
!ADODB.Command15 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

