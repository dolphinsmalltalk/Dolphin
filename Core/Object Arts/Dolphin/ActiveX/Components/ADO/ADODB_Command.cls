"Filed out from Dolphin Smalltalk 7"!

ADODBCommand25 subclass: #ADODB_Command
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB_Command guid: (IID fromString: '{986761e8-7269-4890-aa65-ad7c03697a6d}')!
ADODB_Command comment: '`ADODB_Command` is a wrapper class for the COM interface ''ADODB._Command'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(986761e8-7269-4890-aa65-ad7c03697a6d), 
	helpcontext(0x0012c902), 
	nonextensible, 
	dual
]
interface _Command : Command25
 {
	[id(0x0000000b), propputref, helpcontext(0x0012c956)]
	HRESULT __stdcall CommandStream(
		[in]IUnknown* pvStream);
	[id(0x0000000b), propget, helpcontext(0x0012c956)]
	HRESULT __stdcall CommandStream(
		[out, retval]VARIANT* pvStream);
	[id(0x0000000c), propput, helpcontext(0x0012c957)]
	HRESULT __stdcall Dialect(
		[in]BSTR pbstrDialect);
	[id(0x0000000c), propget, helpcontext(0x0012c957)]
	HRESULT __stdcall Dialect(
		[out, retval]BSTR* pbstrDialect);
	[id(0x0000000d), propput, helpcontext(0x0012c958)]
	HRESULT __stdcall NamedParameters(
		[in]VARIANT_BOOL pfNamedParameters);
	[id(0x0000000d), propget, helpcontext(0x0012c958)]
	HRESULT __stdcall NamedParameters(
		[out, retval]VARIANT_BOOL* pfNamedParameters);
};
```
'!
!ADODB_Command categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB_Command methodsFor!

commandStream
	"Answer the <variant> value of the 'CommandStream' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_CommandStream: answer.
	^answer asObject!

dialect
	"Answer the <bstr> value of the 'Dialect' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Dialect: answer.
	^answer asObject!

dialect: pbstrDialect
	"Set the 'Dialect' property of the receiver to the <bstr> value of the argument."

	self put_Dialect: pbstrDialect!

get_CommandStream: pvStream
	"Private - Get the value of the 'CommandStream' property of the receiver.

		HRESULT __stdcall CommandStream(
			[out, retval]VARIANT* pvStream);"

	<virtual stdcall: hresult 28 variant*>
	^self invalidCall: _failureCode!

get_Dialect: pbstrDialect
	"Private - Get the value of the 'Dialect' property of the receiver.

		HRESULT __stdcall Dialect(
			[out, retval]BSTR* pbstrDialect);"

	<virtual stdcall: hresult 30 bstr*>
	^self invalidCall: _failureCode!

get_NamedParameters: pfNamedParameters
	"Private - Get the value of the 'NamedParameters' property of the receiver.

		HRESULT __stdcall NamedParameters(
			[out, retval]VARIANT_BOOL* pfNamedParameters);"

	<virtual stdcall: hresult 32 varbool*>
	^self invalidCall: _failureCode!

namedParameters
	"Answer the <varbool> value of the 'NamedParameters' property of the receiver."

	| answer |
	answer := VARIANT_BOOL new.
	self get_NamedParameters: answer.
	^answer asObject!

namedParameters: pfNamedParameters
	"Set the 'NamedParameters' property of the receiver to the <varbool> value of the argument."

	self put_NamedParameters: pfNamedParameters!

put_Dialect: pbstrDialect
	"Private - Set the value of the 'Dialect' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrDialect.

		HRESULT __stdcall Dialect(
			[in]BSTR pbstrDialect);"

	<virtual stdcall: hresult 29 bstr>
	^self invalidCall: _failureCode!

put_NamedParameters: pfNamedParameters
	"Private - Set the value of the 'NamedParameters' property of the object wrapped by the 
	 receiver to the <varbool> argument, pfNamedParameters.

		HRESULT __stdcall NamedParameters(
			[in]VARIANT_BOOL pfNamedParameters);"

	<virtual stdcall: hresult 31 varbool>
	^self invalidCall: _failureCode!

putref_CommandStream: pvStream
	"Private - Set the value of the 'CommandStream' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, pvStream.

		HRESULT __stdcall CommandStream(
			[in]IUnknown* pvStream);"

	<virtual stdcall: hresult 27 IUnknown*>
	^self invalidCall: _failureCode!

setCommandStream: pvStream
	"Set the 'CommandStream' property of the receiver to the <IUnknown*> value of the argument."

	self putref_CommandStream: pvStream! !
!ADODB_Command categoriesFor: #commandStream!**auto generated**!properties!public! !
!ADODB_Command categoriesFor: #dialect!**auto generated**!properties!public! !
!ADODB_Command categoriesFor: #dialect:!**auto generated**!properties!public! !
!ADODB_Command categoriesFor: #get_CommandStream:!**auto generated**!COM Interfaces-_Command!private! !
!ADODB_Command categoriesFor: #get_Dialect:!**auto generated**!COM Interfaces-_Command!private! !
!ADODB_Command categoriesFor: #get_NamedParameters:!**auto generated**!COM Interfaces-_Command!private! !
!ADODB_Command categoriesFor: #namedParameters!**auto generated**!properties!public! !
!ADODB_Command categoriesFor: #namedParameters:!**auto generated**!properties!public! !
!ADODB_Command categoriesFor: #put_Dialect:!**auto generated**!COM Interfaces-_Command!private! !
!ADODB_Command categoriesFor: #put_NamedParameters:!**auto generated**!COM Interfaces-_Command!private! !
!ADODB_Command categoriesFor: #putref_CommandStream:!**auto generated**!COM Interfaces-_Command!private! !
!ADODB_Command categoriesFor: #setCommandStream:!**auto generated**!properties!public! !

!ADODB_Command class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Command) for which the receiver is the default interface."

	^CLSID fromString: '{00000507-0000-0010-8000-00aa006d2ea4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Command'
		ADODB_Command defineTemplate"

	self
		defineFunction: #putref_CommandStream:
			argumentTypes: 'IUnknown*';
		defineFunction: #get_CommandStream:
			argumentTypes: 'variant*';
		defineFunction: #put_Dialect:
			argumentTypes: 'bstr';
		defineFunction: #get_Dialect:
			argumentTypes: 'bstr*';
		defineFunction: #put_NamedParameters:
			argumentTypes: 'varbool';
		defineFunction: #get_NamedParameters:
			argumentTypes: 'varbool*'
! !
!ADODB_Command class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB_Command class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

