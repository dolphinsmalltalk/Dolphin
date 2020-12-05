"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'ADODB.Error'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Error guid: (OS.COM.IID fromString: '{00000500-0000-0010-8000-00aa006d2ea4}')!
ADODB.Error comment: '`ADODBError` is a wrapper class for the COM interface ''ADODB.Error'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000500-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c906), 
	nonextensible, 
	dual
]
interface Error : IDispatch
 {
	[id(0x00000001), propget, helpcontext(0x0012c931)]
	HRESULT __stdcall Number(
		[out, retval]long* pl);
	[id(0x00000002), propget, helpcontext(0x0012c944)]
	HRESULT __stdcall Source(
		[out, retval]BSTR* pbstr);
	[id(0000000000), propget, helpcontext(0x0012c91f)]
	HRESULT __stdcall Description(
		[out, retval]BSTR* pbstr);
	[id(0x00000003), propget, helpcontext(0x000f4251)]
	HRESULT __stdcall HelpFile(
		[out, retval]BSTR* pbstr);
	[id(0x00000004), propget, helpcontext(0x0012c929)]
	HRESULT __stdcall HelpContext(
		[out, retval]long* pl);
	[id(0x00000005), propget, helpcontext(0x0012c947)]
	HRESULT __stdcall SQLState(
		[out, retval]BSTR* pbstr);
	[id(0x00000006), propget, helpcontext(0x0012c930)]
	HRESULT __stdcall NativeError(
		[out, retval]long* pl);
};
```
'!
!ADODB.Error categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Error methodsFor!

description
	"Answer the <bstr> value of the 'Description' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Description: answer.
	^answer asObject!

get_Description: pbstr
	"Private - Get the value of the 'Description' property of the receiver.

		HRESULT __stdcall Description(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall: _failureCode!

get_HelpContext: pl
	"Private - Get the value of the 'HelpContext' property of the receiver.

		HRESULT __stdcall HelpContext(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

get_HelpFile: pbstr
	"Private - Get the value of the 'HelpFile' property of the receiver.

		HRESULT __stdcall HelpFile(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

get_NativeError: pl
	"Private - Get the value of the 'NativeError' property of the receiver.

		HRESULT __stdcall NativeError(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall: _failureCode!

get_Number: pl
	"Private - Get the value of the 'Number' property of the receiver.

		HRESULT __stdcall Number(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_Source: pbstr
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

get_SQLState: pbstr
	"Private - Get the value of the 'SQLState' property of the receiver.

		HRESULT __stdcall SQLState(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall: _failureCode!

helpContext
	"Answer the <sdword> value of the 'HelpContext' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_HelpContext: answer.
	^answer asObject!

helpFile
	"Answer the <bstr> value of the 'HelpFile' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_HelpFile: answer.
	^answer asObject!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

nativeError
	"Answer the <sdword> value of the 'NativeError' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_NativeError: answer.
	^answer asObject!

number
	"Answer the <sdword> value of the 'Number' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Number: answer.
	^answer asObject!

printValueOn: aStream
	aStream print: self description!

source
	"Answer the <bstr> value of the 'Source' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Source: answer.
	^answer asObject!

sqlState
	"Answer the <bstr> value of the 'SQLState' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_SQLState: answer.
	^answer asObject!

value
	"Answer the <bstr> value of the 'Description' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self description! !
!ADODB.Error categoriesFor: #description!**auto generated**!properties!public! !
!ADODB.Error categoriesFor: #get_Description:!**auto generated**!COM Interfaces-Error!private! !
!ADODB.Error categoriesFor: #get_HelpContext:!**auto generated**!COM Interfaces-Error!private! !
!ADODB.Error categoriesFor: #get_HelpFile:!**auto generated**!COM Interfaces-Error!private! !
!ADODB.Error categoriesFor: #get_NativeError:!**auto generated**!COM Interfaces-Error!private! !
!ADODB.Error categoriesFor: #get_Number:!**auto generated**!COM Interfaces-Error!private! !
!ADODB.Error categoriesFor: #get_Source:!**auto generated**!COM Interfaces-Error!private! !
!ADODB.Error categoriesFor: #get_SQLState:!**auto generated**!COM Interfaces-Error!private! !
!ADODB.Error categoriesFor: #helpContext!**auto generated**!properties!public! !
!ADODB.Error categoriesFor: #helpFile!**auto generated**!properties!public! !
!ADODB.Error categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODB.Error categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODB.Error categoriesFor: #nativeError!**auto generated**!properties!public! !
!ADODB.Error categoriesFor: #number!**auto generated**!properties!public! !
!ADODB.Error categoriesFor: #printValueOn:!printing!private! !
!ADODB.Error categoriesFor: #source!**auto generated**!properties!public! !
!ADODB.Error categoriesFor: #sqlState!**auto generated**!properties!public! !
!ADODB.Error categoriesFor: #value!**auto generated**!properties!public! !

!ADODB.Error class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Error'
		Error defineTemplate"

	self
		defineFunction: #get_Number:
			argumentTypes: 'sdword*';
		defineFunction: #get_Source:
			argumentTypes: 'bstr*';
		defineFunction: #get_Description:
			argumentTypes: 'bstr*';
		defineFunction: #get_HelpFile:
			argumentTypes: 'bstr*';
		defineFunction: #get_HelpContext:
			argumentTypes: 'sdword*';
		defineFunction: #get_SQLState:
			argumentTypes: 'bstr*';
		defineFunction: #get_NativeError:
			argumentTypes: 'sdword*'
! !
!ADODB.Error class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

