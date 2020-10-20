"Filed out from Dolphin Smalltalk 7"!

ADODB._ADO subclass: #'ADODB.Field20'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Field20 guid: (OS.COM.IID fromString: '{0000154c-0000-0010-8000-00aa006d2ea4}')!
ADODB.Field20 comment: '`Field20` is a wrapper class for the COM interface ''ADODB.Field20'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0000154c-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c908), 
	hidden, 
	nonextensible, 
	dual
]
interface Field20 : _ADO
 {
	[id(0x00000455), propget, helpcontext(0x0012c90c)]
	HRESULT __stdcall ActualSize(
		[out, retval]long* pl);
	[id(0x0000045a), propget, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[out, retval]long* pl);
	[id(0x0000044f), propget, helpcontext(0x0012c91e)]
	HRESULT __stdcall DefinedSize(
		[out, retval]long* pl);
	[id(0x0000044c), propget, helpcontext(0x0012c92f)]
	HRESULT __stdcall Name(
		[out, retval]BSTR* pbstr);
	[id(0x0000044e), propget, helpcontext(0x0012c94a)]
	HRESULT __stdcall Type(
		[out, retval]DataTypeEnum* pDataType);
	[id(0000000000), propget, helpcontext(0x0012c94d)]
	HRESULT __stdcall Value(
		[out, retval]VARIANT* pvar);
	[id(0000000000), propput, helpcontext(0x0012c94d)]
	HRESULT __stdcall Value(
		[in]VARIANT pvar);
	[id(0x00000458), propget, helpcontext(0x0012c938)]
	HRESULT __stdcall Precision(
		[out, retval]BYTE* pbPrecision);
	[id(0x00000459), propget, helpcontext(0x0012c932)]
	HRESULT __stdcall NumericScale(
		[out, retval]BYTE* pbNumericScale);
	[id(0x00000453), helpcontext(0x0012c8b6)]
	HRESULT __stdcall AppendChunk(
		[in]VARIANT Data);
	[id(0x00000454), helpcontext(0x0012c8ce)]
	HRESULT __stdcall GetChunk(
		[in]long Length,
		[out, retval]VARIANT* pvar);
	[id(0x00000450), propget, helpcontext(0x0012c934)]
	HRESULT __stdcall OriginalValue(
		[out, retval]VARIANT* pvar);
	[id(0x00000451), propget, helpcontext(0x0012c94b)]
	HRESULT __stdcall UnderlyingValue(
		[out, retval]VARIANT* pvar);
	[id(0x0000045b), propget]
	HRESULT __stdcall DataFormat(
		[out, retval]IUnknown** ppiDF);
	[id(0x0000045b), propputref]
	HRESULT __stdcall DataFormat(
		[in]IUnknown* ppiDF);
	[id(0x00000458), propput, helpcontext(0x0012c938)]
	HRESULT __stdcall Precision(
		[in]BYTE pbPrecision);
	[id(0x00000459), propput, helpcontext(0x0012c932)]
	HRESULT __stdcall NumericScale(
		[in]BYTE pbNumericScale);
	[id(0x0000044e), propput, helpcontext(0x0012c94a)]
	HRESULT __stdcall Type(
		[in]DataTypeEnum pDataType);
	[id(0x0000044f), propput, helpcontext(0x0012c91e)]
	HRESULT __stdcall DefinedSize(
		[in]long pl);
	[id(0x0000045a), propput, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[in]long pl);
};
```
'!
!ADODB.Field20 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Field20 methodsFor!

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

attributes: pl
	"Set the 'Attributes' property of the receiver to the <sdword> value of the argument."

	self put_Attributes: pl!

dataFormat
	"Answer the <IUnknown> value of the 'DataFormat' property of the receiver."

	| answer |
	answer := IUnknown newPointer.
	self get_DataFormat: answer.
	^answer asObject!

definedSize
	"Answer the <sdword> value of the 'DefinedSize' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_DefinedSize: answer.
	^answer asObject!

definedSize: pl
	"Set the 'DefinedSize' property of the receiver to the <sdword> value of the argument."

	self put_DefinedSize: pl!

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

get_DataFormat: ppiDF
	"Private - Get the value of the 'DataFormat' property of the receiver.

		HRESULT __stdcall DataFormat(
			[out, retval]IUnknown** ppiDF);"

	<virtual stdcall: hresult 22 IUnknown**>
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

numericScale: pbNumericScale
	"Set the 'NumericScale' property of the receiver to the <byte> value of the argument."

	self put_NumericScale: pbNumericScale!

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

precision: pbPrecision
	"Set the 'Precision' property of the receiver to the <byte> value of the argument."

	self put_Precision: pbPrecision!

printValueOn: aStream
	aStream print: self name.
	
	["The field may not have a value if the source recordset is empty, or the record has been deleted"

	| value |
	value := self value.
	aStream
		nextPutAll: '=';
		print: value] 
			on: OS.HRESULTError
			do: [:ex | ]!

put_Attributes: pl
	"Private - Set the value of the 'Attributes' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall Attributes(
			[in]long pl);"

	<virtual stdcall: hresult 28 sdword>
	^self invalidCall: _failureCode!

put_DefinedSize: pl
	"Private - Set the value of the 'DefinedSize' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall DefinedSize(
			[in]long pl);"

	<virtual stdcall: hresult 27 sdword>
	^self invalidCall: _failureCode!

put_NumericScale: pbNumericScale
	"Private - Set the value of the 'NumericScale' property of the object wrapped by the 
	 receiver to the <byte> argument, pbNumericScale.

		HRESULT __stdcall NumericScale(
			[in]BYTE pbNumericScale);"

	<virtual stdcall: hresult 25 byte>
	^self invalidCall: _failureCode!

put_Precision: pbPrecision
	"Private - Set the value of the 'Precision' property of the object wrapped by the 
	 receiver to the <byte> argument, pbPrecision.

		HRESULT __stdcall Precision(
			[in]BYTE pbPrecision);"

	<virtual stdcall: hresult 24 byte>
	^self invalidCall: _failureCode!

put_Type: pDataType
	"Private - Set the value of the 'Type' property of the object wrapped by the 
	 receiver to the <sdword> argument, pDataType.

		HRESULT __stdcall Type(
			[in]DataTypeEnum pDataType);"

	<virtual stdcall: hresult 26 sdword>
	^self invalidCall: _failureCode!

put_Value: pvar
	"Private - Set the value of the 'Value' property of the object wrapped by the 
	 receiver to the <variant> argument, pvar.

		HRESULT __stdcall Value(
			[in]VARIANT pvar);"

	<virtual stdcall: hresult 15 variant>
	^self invalidCall: _failureCode!

putref_DataFormat: ppiDF
	"Private - Set the value of the 'DataFormat' property of the object wrapped by the 
	 receiver to the <IUnknown*> argument, ppiDF.

		HRESULT __stdcall DataFormat(
			[in]IUnknown* ppiDF);"

	<virtual stdcall: hresult 23 IUnknown*>
	^self invalidCall: _failureCode!

setDataFormat: ppiDF
	"Set the 'DataFormat' property of the receiver to the <IUnknown*> value of the argument."

	self putref_DataFormat: ppiDF!

type
	"Answer the <sdword> value of the 'Type' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Type: answer.
	^answer asObject!

type: pDataType
	"Set the 'Type' property of the receiver to the <sdword> value of the argument."

	self put_Type: pDataType!

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
!ADODB.Field20 categoriesFor: #actualSize!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #appendChunk:!**auto generated**!methods!public! !
!ADODB.Field20 categoriesFor: #AppendChunk:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #attributes!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #attributes:!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #dataFormat!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #definedSize!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #definedSize:!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #get_ActualSize:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_Attributes:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_DataFormat:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_DefinedSize:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_Name:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_NumericScale:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_OriginalValue:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_Precision:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_Type:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_UnderlyingValue:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #get_Value:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #getChunk:!**auto generated**!methods!public! !
!ADODB.Field20 categoriesFor: #GetChunk:pvar:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #name!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #numericScale!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #numericScale:!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #originalValue!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #precision!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #precision:!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #printValueOn:!printing!private! !
!ADODB.Field20 categoriesFor: #put_Attributes:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #put_DefinedSize:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #put_NumericScale:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #put_Precision:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #put_Type:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #put_Value:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #putref_DataFormat:!**auto generated**!COM Interfaces-Field20!private! !
!ADODB.Field20 categoriesFor: #setDataFormat:!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #type!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #type:!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #underlyingValue!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #value!**auto generated**!properties!public! !
!ADODB.Field20 categoriesFor: #value:!**auto generated**!properties!public! !

!ADODB.Field20 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Field20'
		Field20 defineTemplate"

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
			argumentTypes: 'variant*';
		defineFunction: #get_DataFormat:
			argumentTypes: 'IUnknown**';
		defineFunction: #putref_DataFormat:
			argumentTypes: 'IUnknown*';
		defineFunction: #put_Precision:
			argumentTypes: 'byte';
		defineFunction: #put_NumericScale:
			argumentTypes: 'byte';
		defineFunction: #put_Type:
			argumentTypes: 'sdword';
		defineFunction: #put_DefinedSize:
			argumentTypes: 'sdword';
		defineFunction: #put_Attributes:
			argumentTypes: 'sdword'
! !
!ADODB.Field20 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

