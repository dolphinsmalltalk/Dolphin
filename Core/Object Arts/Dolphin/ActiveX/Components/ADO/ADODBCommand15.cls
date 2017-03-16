"Filed out from Dolphin Smalltalk 7"!

ADODB_ADO subclass: #ADODBCommand15
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBCommand15 guid: (IID fromString: '{00000508-0000-0010-8000-00AA006D2EA4}')!
ADODBCommand15 comment: '<ADODBCommand15> is a wrapper class for the COM interface ''ADODB.Command15'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!ADODBCommand15 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBCommand15 methodsFor!

activeConnection
	"Answer the <ADODB_Connection> value of the 'ActiveConnection' property of the receiver."

	| answer |
	answer := ADODB_Connection newPointer.
	self get_ActiveConnection: answer.
	^answer asObject
!

activeConnection: ppvObject
	"Set the 'ActiveConnection' property of the receiver to the <variant> value of the argument."

	self put_ActiveConnection: ppvObject asVariant
!

commandText
	"Answer the <bstr> value of the 'CommandText' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_CommandText: answer.
	^answer asObject
!

commandText: pbstr
	"Set the 'CommandText' property of the receiver to the <bstr> value of the argument."

	self put_CommandText: pbstr
!

commandTimeout
	"Answer the <sdword> value of the 'CommandTimeout' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_CommandTimeout: answer.
	^answer asObject
!

commandTimeout: pl
	"Set the 'CommandTimeout' property of the receiver to the <sdword> value of the argument."

	self put_CommandTimeout: pl
!

commandType
	"Answer the <sdword> value of the 'CommandType' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_CommandType: answer.
	^answer asObject
!

commandType: plCmdType
	"Set the 'CommandType' property of the receiver to the <sdword> value of the argument."

	self put_CommandType: plCmdType
!

createParameter
	"Answer the <ADODB_Parameter> result of invoking the CreateParameter() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 createParameter: ''
		 type: 0
		 direction: 1
		 size: 0
		 value: VARIANT unspecified!

createParameter: name type: type direction: direction size: size value: value
	"Answer the <ADODB_Parameter> result of invoking the CreateParameter() method of the COM object."

	| answer |
	answer := ADODB_Parameter newPointer.
	self
		CreateParameter: name
		Type: type
		Direction: direction
		Size: size
		Value: value asVariant
		ppiprm: answer.
	^answer asObject
!

CreateParameter: name Type: type Direction: direction Size: size Value: value ppiprm: ppiprm
	"Private - Invoke the CreateParameter() method of the COM object.

		HRESULT __stdcall CreateParameter(
			[in, optional, defaultvalue("")] BSTR Name,
			[in, optional, defaultvalue(0)] DataTypeEnum Type,
			[in, optional, defaultvalue(1)] ParameterDirectionEnum Direction,
			[in, optional, defaultvalue(0)] long Size,
			[in, optional] VARIANT Value,
			[out, retval] _Parameter** ppiprm);"

	<virtual stdcall: hresult 19 bstr sdword sdword sdword variant ADODB_Parameter**>
	^self invalidCall
!

execute
	"Invoke the Execute() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		 execute: nil
		 options: -1!

execute: parameters options: options
	"Invoke the Execute() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: VARIANT new;
				basicAt: 2 put: ADODB_Recordset newPointer;
				yourself.
	self
		Execute: (answer basicAt: 1)
		Parameters: parameters asVariant
		Options: options
		ppiRs: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

Execute: recordsAffected Parameters: parameters Options: options ppiRs: ppiRs
	"Private - Invoke the Execute() method of the COM object.

		HRESULT __stdcall Execute(
			[out, optional] VARIANT* RecordsAffected,
			[in, optional] VARIANT* Parameters,
			[in, optional, defaultvalue(-1)] long Options,
			[out, retval] _Recordset** ppiRs);"

	<virtual stdcall: hresult 18 variant* variant* sdword ADODB_Recordset**>
	^self invalidCall
!

get_ActiveConnection: ppvObject
	"Private - Get the value of the 'ActiveConnection' property of the receiver.
				HRESULT __stdcall ActiveConnection(
			[out, retval] _Connection** ppvObject);"

	<virtual stdcall: hresult 9 ADODB_Connection**>
	^self invalidCall
!

get_CommandText: pbstr
	"Private - Get the value of the 'CommandText' property of the receiver.
				HRESULT __stdcall CommandText(
			[out, retval] BSTR* pbstr);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall
!

get_CommandTimeout: pl
	"Private - Get the value of the 'CommandTimeout' property of the receiver.
				HRESULT __stdcall CommandTimeout(
			[out, retval] long* pl);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall
!

get_CommandType: plCmdType
	"Private - Get the value of the 'CommandType' property of the receiver.
				HRESULT __stdcall CommandType(
			[out, retval] CommandTypeEnum* plCmdType);"

	<virtual stdcall: hresult 22 sdword*>
	^self invalidCall
!

get_Name: pbstrName
	"Private - Get the value of the 'Name' property of the receiver.
				HRESULT __stdcall Name(
			[out, retval] BSTR* pbstrName);"

	<virtual stdcall: hresult 23 bstr*>
	^self invalidCall
!

get_Parameters: ppvObject
	"Private - Get the value of the 'Parameters' property of the receiver.
				HRESULT __stdcall Parameters(
			[out, retval] Parameters** ppvObject);"

	<virtual stdcall: hresult 20 ADODBParameters**>
	^self invalidCall
!

get_Prepared: pfPrepared
	"Private - Get the value of the 'Prepared' property of the receiver.
				HRESULT __stdcall Prepared(
			[out, retval] VARIANT_BOOL* pfPrepared);"

	<virtual stdcall: hresult 16 varbool*>
	^self invalidCall
!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject
!

name: pbstrName
	"Set the 'Name' property of the receiver to the <bstr> value of the argument."

	self put_Name: pbstrName
!

parameters
	"Answer the <ADODBParameters> value of the 'Parameters' property of the receiver.
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk sequenceable collection."

	| answer |
	answer := ADODBParameters newPointer.
	self get_Parameters: answer.
	^ADODynaCollection on: answer!

prepared
	"Answer the <varbool> value of the 'Prepared' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Prepared: answer.
	^answer asObject
!

prepared: pfPrepared
	"Set the 'Prepared' property of the receiver to the <varbool> value of the argument."

	self put_Prepared: pfPrepared
!

put_ActiveConnection: ppvObject
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <variant> argument, ppvObject.
				HRESULT __stdcall ActiveConnection(
			[in] VARIANT ppvObject);"

	<virtual stdcall: hresult 11 variant>
	^self invalidCall
!

put_CommandText: pbstr
	"Private - Set the value of the 'CommandText' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.
				HRESULT __stdcall CommandText(
			[in] BSTR pbstr);"

	<virtual stdcall: hresult 13 bstr>
	^self invalidCall
!

put_CommandTimeout: pl
	"Private - Set the value of the 'CommandTimeout' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.
				HRESULT __stdcall CommandTimeout(
			[in] long pl);"

	<virtual stdcall: hresult 15 sdword>
	^self invalidCall
!

put_CommandType: plCmdType
	"Private - Set the value of the 'CommandType' property of the object wrapped by the 
	 receiver to the <sdword> argument, plCmdType.
				HRESULT __stdcall CommandType(
			[in] CommandTypeEnum plCmdType);"

	<virtual stdcall: hresult 21 sdword>
	^self invalidCall
!

put_Name: pbstrName
	"Private - Set the value of the 'Name' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrName.
				HRESULT __stdcall Name(
			[in] BSTR pbstrName);"

	<virtual stdcall: hresult 24 bstr>
	^self invalidCall
!

put_Prepared: pfPrepared
	"Private - Set the value of the 'Prepared' property of the object wrapped by the 
	 receiver to the <varbool> argument, pfPrepared.
				HRESULT __stdcall Prepared(
			[in] VARIANT_BOOL pfPrepared);"

	<virtual stdcall: hresult 17 varbool>
	^self invalidCall
!

putref_ActiveConnection: ppvObject
	"Private - Set the value of the 'ActiveConnection' property of the object wrapped by the 
	 receiver to the <ADODB_Connection*> argument, ppvObject.
				HRESULT __stdcall ActiveConnection(
			[in] _Connection* ppvObject);"

	<virtual stdcall: hresult 10 ADODB_Connection*>
	^self invalidCall
!

setActiveConnection: ppvObject
	"Set the 'ActiveConnection' property of the receiver to the <ADODB_Connection*> value of the argument."

	self putref_ActiveConnection: ppvObject
!

value
	"Answer the <ADODBParameters> value of the 'Parameters' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self parameters
! !
!ADODBCommand15 categoriesFor: #activeConnection!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #activeConnection:!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #commandText!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #commandText:!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #commandTimeout!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #commandTimeout:!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #commandType!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #commandType:!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #createParameter!**auto generated**!methods!public! !
!ADODBCommand15 categoriesFor: #createParameter:type:direction:size:value:!**auto generated**!methods!public! !
!ADODBCommand15 categoriesFor: #CreateParameter:Type:Direction:Size:Value:ppiprm:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #execute!**auto generated**!methods!public! !
!ADODBCommand15 categoriesFor: #execute:options:!**auto generated**!methods!public! !
!ADODBCommand15 categoriesFor: #Execute:Parameters:Options:ppiRs:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #get_ActiveConnection:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #get_CommandText:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #get_CommandTimeout:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #get_CommandType:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #get_Name:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #get_Parameters:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #get_Prepared:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #name!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #name:!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #parameters!properties!public! !
!ADODBCommand15 categoriesFor: #prepared!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #prepared:!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #put_ActiveConnection:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #put_CommandText:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #put_CommandTimeout:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #put_CommandType:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #put_Name:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #put_Prepared:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #putref_ActiveConnection:!**auto generated**!COM Interfaces-Command15!private! !
!ADODBCommand15 categoriesFor: #setActiveConnection:!**auto generated**!properties!public! !
!ADODBCommand15 categoriesFor: #value!**auto generated**!properties!public! !

!ADODBCommand15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Command15'
		ADODBCommand15 defineTemplate"

	self
		defineFunction: #get_ActiveConnection:
			argumentTypes: 'ADODB_Connection**';
		defineFunction: #putref_ActiveConnection:
			argumentTypes: 'ADODB_Connection*';
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
			argumentTypes: 'variant* variant* sdword ADODB_Recordset**';
		defineFunction: #CreateParameter:Type:Direction:Size:Value:ppiprm:
			argumentTypes: 'bstr sdword sdword sdword variant ADODB_Parameter**';
		defineFunction: #get_Parameters:
			argumentTypes: 'ADODBParameters**';
		defineFunction: #put_CommandType:
			argumentTypes: 'sdword';
		defineFunction: #get_CommandType:
			argumentTypes: 'sdword*';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #put_Name:
			argumentTypes: 'bstr'
! !
!ADODBCommand15 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

