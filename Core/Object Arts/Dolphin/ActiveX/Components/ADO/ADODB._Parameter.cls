"Filed out from Dolphin Smalltalk 7"!

ADODB._ADO subclass: #'ADODB._Parameter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB._Parameter guid: (OS.COM.IID fromString: '{0000150c-0000-0010-8000-00aa006d2ea4}')!
ADODB._Parameter comment: '`_Parameter` is a wrapper class for the COM interface ''ADODB._Parameter'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0000150c-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c909), 
	hidden, 
	nonextensible, 
	dual
]
interface _Parameter : _ADO
 {
	[id(0x00000001), propget, helpcontext(0x0012c92f)]
	HRESULT __stdcall Name(
		[out, retval]BSTR* pbstr);
	[id(0x00000001), propput, helpcontext(0x0012c92f)]
	HRESULT __stdcall Name(
		[in]BSTR pbstr);
	[id(0000000000), propget, helpcontext(0x0012c94d)]
	HRESULT __stdcall Value(
		[out, retval]VARIANT* pvar);
	[id(0000000000), propput, helpcontext(0x0012c94d)]
	HRESULT __stdcall Value(
		[in]VARIANT pvar);
	[id(0x00000002), propget, helpcontext(0x0012c94a)]
	HRESULT __stdcall Type(
		[out, retval]DataTypeEnum* psDataType);
	[id(0x00000002), propput, helpcontext(0x0012c94a)]
	HRESULT __stdcall Type(
		[in]DataTypeEnum psDataType);
	[id(0x00000003), propput, helpcontext(0x0012c920)]
	HRESULT __stdcall Direction(
		[in]ParameterDirectionEnum plParmDirection);
	[id(0x00000003), propget, helpcontext(0x0012c920)]
	HRESULT __stdcall Direction(
		[out, retval]ParameterDirectionEnum* plParmDirection);
	[id(0x00000004), propput, helpcontext(0x0012c938)]
	HRESULT __stdcall Precision(
		[in]BYTE pbPrecision);
	[id(0x00000004), propget, helpcontext(0x0012c938)]
	HRESULT __stdcall Precision(
		[out, retval]BYTE* pbPrecision);
	[id(0x00000005), propput, helpcontext(0x0012c932)]
	HRESULT __stdcall NumericScale(
		[in]BYTE pbScale);
	[id(0x00000005), propget, helpcontext(0x0012c932)]
	HRESULT __stdcall NumericScale(
		[out, retval]BYTE* pbScale);
	[id(0x00000006), propput, helpcontext(0x0012c940)]
	HRESULT __stdcall Size(
		[in]long pl);
	[id(0x00000006), propget, helpcontext(0x0012c940)]
	HRESULT __stdcall Size(
		[out, retval]long* pl);
	[id(0x00000007), helpcontext(0x0012c8b6)]
	HRESULT __stdcall AppendChunk(
		[in]VARIANT Val);
	[id(0x00000008), propget, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[out, retval]long* plParmAttribs);
	[id(0x00000008), propput, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[in]long plParmAttribs);
};
```
'!
!ADODB._Parameter categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB._Parameter methodsFor!

appendChunk: val
	"Invoke the AppendChunk() method of the COM object."

	^self AppendChunk: val asVariant!

AppendChunk: val
	"Private - Invoke the AppendChunk() method of the COM object.

		HRESULT __stdcall AppendChunk(
			[in]VARIANT Val);"

	<virtual stdcall: hresult 23 variant>
	^self invalidCall: _failureCode!

attributes
	"Answer the <sdword> value of the 'Attributes' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Attributes: answer.
	^answer asObject!

attributes: plParmAttribs
	"Set the 'Attributes' property of the receiver to the <sdword> value of the argument."

	self put_Attributes: plParmAttribs!

direction
	"Answer the <sdword> value of the 'Direction' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Direction: answer.
	^answer asObject!

direction: plParmDirection
	"Set the 'Direction' property of the receiver to the <sdword> value of the argument."

	self put_Direction: plParmDirection!

get_Attributes: plParmAttribs
	"Private - Get the value of the 'Attributes' property of the receiver.

		HRESULT __stdcall Attributes(
			[out, retval]long* plParmAttribs);"

	<virtual stdcall: hresult 24 sdword*>
	^self invalidCall: _failureCode!

get_Direction: plParmDirection
	"Private - Get the value of the 'Direction' property of the receiver.

		HRESULT __stdcall Direction(
			[out, retval]ParameterDirectionEnum* plParmDirection);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall: _failureCode!

get_Name: pbstr
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

get_NumericScale: pbScale
	"Private - Get the value of the 'NumericScale' property of the receiver.

		HRESULT __stdcall NumericScale(
			[out, retval]BYTE* pbScale);"

	<virtual stdcall: hresult 20 byte*>
	^self invalidCall: _failureCode!

get_Precision: pbPrecision
	"Private - Get the value of the 'Precision' property of the receiver.

		HRESULT __stdcall Precision(
			[out, retval]BYTE* pbPrecision);"

	<virtual stdcall: hresult 18 byte*>
	^self invalidCall: _failureCode!

get_Size: pl
	"Private - Get the value of the 'Size' property of the receiver.

		HRESULT __stdcall Size(
			[out, retval]long* pl);"

	<virtual stdcall: hresult 22 sdword*>
	^self invalidCall: _failureCode!

get_Type: psDataType
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval]DataTypeEnum* psDataType);"

	<virtual stdcall: hresult 13 sdword*>
	^self invalidCall: _failureCode!

get_Value: pvar
	"Private - Get the value of the 'Value' property of the receiver.

		HRESULT __stdcall Value(
			[out, retval]VARIANT* pvar);"

	<virtual stdcall: hresult 11 variant*>
	^self invalidCall: _failureCode!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject!

name: pbstr
	"Set the 'Name' property of the receiver to the <bstr> value of the argument."

	self put_Name: pbstr!

numericScale
	"Answer the <byte> value of the 'NumericScale' property of the receiver."

	| answer |
	answer := BYTE new.
	self get_NumericScale: answer.
	^answer asObject!

numericScale: pbScale
	"Set the 'NumericScale' property of the receiver to the <byte> value of the argument."

	self put_NumericScale: pbScale!

precision
	"Answer the <byte> value of the 'Precision' property of the receiver."

	| answer |
	answer := BYTE new.
	self get_Precision: answer.
	^answer asObject!

precision: pbPrecision
	"Set the 'Precision' property of the receiver to the <byte> value of the argument."

	self put_Precision: pbPrecision!

put_Attributes: plParmAttribs
	"Private - Set the value of the 'Attributes' property of the object wrapped by the 
	 receiver to the <sdword> argument, plParmAttribs.

		HRESULT __stdcall Attributes(
			[in]long plParmAttribs);"

	<virtual stdcall: hresult 25 sdword>
	^self invalidCall: _failureCode!

put_Direction: plParmDirection
	"Private - Set the value of the 'Direction' property of the object wrapped by the 
	 receiver to the <sdword> argument, plParmDirection.

		HRESULT __stdcall Direction(
			[in]ParameterDirectionEnum plParmDirection);"

	<virtual stdcall: hresult 15 sdword>
	^self invalidCall: _failureCode!

put_Name: pbstr
	"Private - Set the value of the 'Name' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstr.

		HRESULT __stdcall Name(
			[in]BSTR pbstr);"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall: _failureCode!

put_NumericScale: pbScale
	"Private - Set the value of the 'NumericScale' property of the object wrapped by the 
	 receiver to the <byte> argument, pbScale.

		HRESULT __stdcall NumericScale(
			[in]BYTE pbScale);"

	<virtual stdcall: hresult 19 byte>
	^self invalidCall: _failureCode!

put_Precision: pbPrecision
	"Private - Set the value of the 'Precision' property of the object wrapped by the 
	 receiver to the <byte> argument, pbPrecision.

		HRESULT __stdcall Precision(
			[in]BYTE pbPrecision);"

	<virtual stdcall: hresult 17 byte>
	^self invalidCall: _failureCode!

put_Size: pl
	"Private - Set the value of the 'Size' property of the object wrapped by the 
	 receiver to the <sdword> argument, pl.

		HRESULT __stdcall Size(
			[in]long pl);"

	<virtual stdcall: hresult 21 sdword>
	^self invalidCall: _failureCode!

put_Type: psDataType
	"Private - Set the value of the 'Type' property of the object wrapped by the 
	 receiver to the <sdword> argument, psDataType.

		HRESULT __stdcall Type(
			[in]DataTypeEnum psDataType);"

	<virtual stdcall: hresult 14 sdword>
	^self invalidCall: _failureCode!

put_Value: pvar
	"Private - Set the value of the 'Value' property of the object wrapped by the 
	 receiver to the <variant> argument, pvar.

		HRESULT __stdcall Value(
			[in]VARIANT pvar);"

	<virtual stdcall: hresult 12 variant>
	^self invalidCall: _failureCode!

size
	"Answer the <sdword> value of the 'Size' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Size: answer.
	^answer asObject!

size: pl
	"Set the 'Size' property of the receiver to the <sdword> value of the argument."

	self put_Size: pl!

type
	"Answer the <sdword> value of the 'Type' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Type: answer.
	^answer asObject!

type: psDataType
	"Set the 'Type' property of the receiver to the <sdword> value of the argument."

	self put_Type: psDataType!

value
	"Answer the <variant> value of the 'Value' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Value: answer.
	^answer asObject!

value: pvar
	"Set the 'Value' property of the receiver to the <variant> value of the argument."

	self put_Value: pvar asVariant! !
!ADODB._Parameter categoriesFor: #appendChunk:!**auto generated**!methods!public! !
!ADODB._Parameter categoriesFor: #AppendChunk:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #attributes!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #attributes:!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #direction!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #direction:!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #get_Attributes:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #get_Direction:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #get_Name:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #get_NumericScale:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #get_Precision:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #get_Size:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #get_Type:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #get_Value:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #name!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #name:!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #numericScale!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #numericScale:!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #precision!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #precision:!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #put_Attributes:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #put_Direction:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #put_Name:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #put_NumericScale:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #put_Precision:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #put_Size:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #put_Type:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #put_Value:!**auto generated**!COM Interfaces-_Parameter!private! !
!ADODB._Parameter categoriesFor: #size!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #size:!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #type!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #type:!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #value!**auto generated**!properties!public! !
!ADODB._Parameter categoriesFor: #value:!**auto generated**!properties!public! !

!ADODB._Parameter class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Parameter) for which the receiver is the default interface."

	^CLSID fromString: '{0000050b-0000-0010-8000-00aa006d2ea4}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._Parameter'
		_Parameter defineTemplate"

	self
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #put_Name:
			argumentTypes: 'bstr';
		defineFunction: #get_Value:
			argumentTypes: 'variant*';
		defineFunction: #put_Value:
			argumentTypes: 'variant';
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #put_Type:
			argumentTypes: 'sdword';
		defineFunction: #put_Direction:
			argumentTypes: 'sdword';
		defineFunction: #get_Direction:
			argumentTypes: 'sdword*';
		defineFunction: #put_Precision:
			argumentTypes: 'byte';
		defineFunction: #get_Precision:
			argumentTypes: 'byte*';
		defineFunction: #put_NumericScale:
			argumentTypes: 'byte';
		defineFunction: #get_NumericScale:
			argumentTypes: 'byte*';
		defineFunction: #put_Size:
			argumentTypes: 'sdword';
		defineFunction: #get_Size:
			argumentTypes: 'sdword*';
		defineFunction: #AppendChunk:
			argumentTypes: 'variant';
		defineFunction: #get_Attributes:
			argumentTypes: 'sdword*';
		defineFunction: #put_Attributes:
			argumentTypes: 'sdword'
! !
!ADODB._Parameter class categoriesFor: #clsid!**auto generated**!constants!private! !
!ADODB._Parameter class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

