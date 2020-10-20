"Filed out from Dolphin Smalltalk 7"!

ADODB._ADO subclass: #'ADODB.Field15'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Field15 guid: (OS.COM.IID fromString: '{00001505-0000-0010-8000-00aa006d2ea4}')!
ADODB.Field15 comment: '<ADODBField15> is a wrapper class for the COM interface ''ADODB.Field15'' generated from type information in the ''Microsoft ActiveX Data Objects 2.5 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(00000505-0000-0010-8000-00AA006D2EA4), 
	helpcontext(0x0012c908), 
	hidden, 
	dual, 
	nonextensible
]
interface Field15 : _ADO {
	[id(0x00000455), propget, helpcontext(0x0012c90c)]
	HRESULT __stdcall ActualSize(
		[out, retval] long* pl);
	[id(0x0000045a), propget, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[out, retval] long* pl);
	[id(0x0000044f), propget, helpcontext(0x0012c91e)]
	HRESULT __stdcall DefinedSize(
		[out, retval] long* pl);
	[id(0x0000044c), propget, helpcontext(0x0012c92f)]
	HRESULT __stdcall Name(
		[out, retval] BSTR* pbstr);
	[id(0x0000044e), propget, helpcontext(0x0012c94a)]
	HRESULT __stdcall Type(
		[out, retval] DataTypeEnum* pDataType);
	[id(0000000000), propget, helpcontext(0x0012c94d)]
	HRESULT __stdcall Value(
		[out, retval] VARIANT* pvar);
	[id(0000000000), propput, helpcontext(0x0012c94d)]
	HRESULT __stdcall Value(
		[in] VARIANT pvar);
	[id(0x00000458), propget, helpcontext(0x0012c938)]
	HRESULT __stdcall Precision(
		[out, retval] BYTE* pbPrecision);
	[id(0x00000459), propget, helpcontext(0x0012c932)]
	HRESULT __stdcall NumericScale(
		[out, retval] BYTE* pbNumericScale);
	[id(0x00000453), helpcontext(0x0012c8b6)]
	HRESULT __stdcall AppendChunk(
		[in] VARIANT Data);
	[id(0x00000454), helpcontext(0x0012c8ce)]
	HRESULT __stdcall GetChunk(
		[in] long Length,
		[out, retval] VARIANT* pvar);
	[id(0x00000450), propget, helpcontext(0x0012c934)]
	HRESULT __stdcall OriginalValue(
		[out, retval] VARIANT* pvar);
	[id(0x00000451), propget, helpcontext(0x0012c94b)]
	HRESULT __stdcall UnderlyingValue(
		[out, retval] VARIANT* pvar);
};
'!
!ADODB.Field15 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Field15 methodsFor!

actualSize
	"Answer the <sdword> value of the 'ActualSize' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ActualSize: answer.
	^answer asObject!

appendChunk: data
	"Invoke the AppendChunk() method of the COM object."

	^self AppendChunk: data asVariant!

AppendChunk: data
	"Private - Invoke the AppendChunk() method of the COM object.

		HRESULT __stdcall AppendChunk(
			[in]VARIANT Data);"

	<virtual stdcall: hresult 18 variant>
	^self invalidCall: _failureCode!

attributes
	"Answer the <sdword> value of the 'Attributes' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Attributes: answer.
	^answer asObject!

definedSize
	"Answer the <sdword> value of the 'DefinedSize' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_DefinedSize: answer.
	^answer asObject!

get_ActualSize: pl
	"Private - Get the value of the 'ActualSize' property of the receiver.

		HRESULT __stdcall ActualSize(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

get_Attributes: pl
	"Private - Get the value of the 'Attributes' property of the receiver.

		HRESULT __stdcall Attributes(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_DefinedSize: pl
	"Private - Get the value of the 'DefinedSize' property of the receiver.

		HRESULT __stdcall DefinedSize(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_Name: pbstr
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall: _failureCode!

get_NumericScale: pbNumericScale
	"Private - Get the value of the 'NumericScale' property of the receiver.

		HRESULT __stdcall NumericScale(
			[out, retval]BYTE* pbNumericScale);"

	<virtual stdcall: hresult 17 byte*>
	^self invalidCall: _failureCode!

get_OriginalValue: pvar
	"Private - Get the value of the 'OriginalValue' property of the receiver.

		HRESULT __stdcall OriginalValue(
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 20 variant*>
	^self invalidCall: _failureCode!

get_Precision: pbPrecision
	"Private - Get the value of the 'Precision' property of the receiver.

		HRESULT __stdcall Precision(
			[out, retval]BYTE* pbPrecision);"

	<virtual stdcall: hresult 16 byte*>
	^self invalidCall: _failureCode!

get_Type: pDataType
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval]DataTypeEnum* pDataType);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall: _failureCode!

get_UnderlyingValue: pvar
	"Private - Get the value of the 'UnderlyingValue' property of the receiver.

		HRESULT __stdcall UnderlyingValue(
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 21 variant*>
	^self invalidCall: _failureCode!

get_Value: pvar
	"Private - Get the value of the 'Value' property of the receiver.

		HRESULT __stdcall Value(
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 14 variant*>
	^self invalidCall: _failureCode!

getChunk: length
	"Answer the <variant> result of invoking the GetChunk() method of the COM object."

	| answer |
	answer := VARIANT new.
	self GetChunk: length pvar: answer.
	^answer asObject!

GetChunk: length pvar: pvar
	"Private - Invoke the GetChunk() method of the COM object.

		HRESULT __stdcall GetChunk(
			[in]long Length,
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 19 sdword variant*>
	^self invalidCall: _failureCode!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject!

numericScale
	"Answer the <byte> value of the 'NumericScale' property of the receiver."

	| answer |
	answer := BYTE new.
	self get_NumericScale: answer.
	^answer asObject!

originalValue
	"Answer the <variant> value of the 'OriginalValue' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_OriginalValue: answer.
	^answer asObject!

precision
	"Answer the <byte> value of the 'Precision' property of the receiver."

	| answer |
	answer := BYTE new.
	self get_Precision: answer.
	^answer asObject!

put_Value: pvar
	"Private - Set the value of the 'Value' property of the object wrapped by the 
	 receiver to the <variant> argument, pvar.

		HRESULT __stdcall Value(
			[in]VARIANT pvar);"

	<virtual stdcall: hresult 15 variant>
	^self invalidCall: _failureCode!

type
	"Answer the <sdword> value of the 'Type' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Type: answer.
	^answer asObject!

underlyingValue
	"Answer the <variant> value of the 'UnderlyingValue' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_UnderlyingValue: answer.
	^answer asObject!

value
	"Answer the <variant> value of the 'Value' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Value: answer.
	^answer asObject!

value: pvar
	"Set the 'Value' property of the receiver to the <variant> value of the argument."

	self put_Value: pvar asVariant! !
!ADODB.Field15 categoriesFor: #actualSize!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #appendChunk:!**auto generated**!methods!public! !
!ADODB.Field15 categoriesFor: #AppendChunk:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #attributes!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #definedSize!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #get_ActualSize:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_Attributes:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_DefinedSize:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_Name:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_NumericScale:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_OriginalValue:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_Precision:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_Type:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_UnderlyingValue:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #get_Value:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #getChunk:!**auto generated**!methods!public! !
!ADODB.Field15 categoriesFor: #GetChunk:pvar:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #name!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #numericScale!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #originalValue!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #precision!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #put_Value:!**auto generated**!COM Interfaces-Field15!private! !
!ADODB.Field15 categoriesFor: #type!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #underlyingValue!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #value!**auto generated**!properties!public! !
!ADODB.Field15 categoriesFor: #value:!**auto generated**!properties!public! !

!ADODB.Field15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Field15'
		Field15 defineTemplate"

	self
		defineFunction: #get_ActualSize:
			argumentTypes: 'sdword*';
		defineFunction: #get_Attributes:
			argumentTypes: 'sdword*';
		defineFunction: #get_DefinedSize:
			argumentTypes: 'sdword*';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #get_Value:
			argumentTypes: 'variant*';
		defineFunction: #put_Value:
			argumentTypes: 'variant';
		defineFunction: #get_Precision:
			argumentTypes: 'byte*';
		defineFunction: #get_NumericScale:
			argumentTypes: 'byte*';
		defineFunction: #AppendChunk:
			argumentTypes: 'variant';
		defineFunction: #GetChunk:pvar:
			argumentTypes: 'sdword variant*';
		defineFunction: #get_OriginalValue:
			argumentTypes: 'variant*';
		defineFunction: #get_UnderlyingValue:
			argumentTypes: 'variant*'
! !
!ADODB.Field15 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

