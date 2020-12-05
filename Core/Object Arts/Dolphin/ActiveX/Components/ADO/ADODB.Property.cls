"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'ADODB.Property'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Property guid: (OS.COM.IID fromString: '{00000503-0000-0010-8000-00aa006d2ea4}')!
ADODB.Property comment: '`ADODBProperty` is a wrapper class for the COM interface ''ADODB.Property'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000503-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c907), 
	nonextensible, 
	dual
]
interface Property : IDispatch
 {
	[id(0000000000), propget, helpcontext(0x0012c94d)]
	HRESULT __stdcall Value(
		[out, retval]VARIANT* pval);
	[id(0000000000), propput, helpcontext(0x0012c94d)]
	HRESULT __stdcall Value(
		[in]VARIANT pval);
	[id(0x60020002), propget, helpcontext(0x0012c92f)]
	HRESULT __stdcall Name(
		[out, retval]BSTR* pbstr);
	[id(0x60020003), propget, helpcontext(0x0012c94a)]
	HRESULT __stdcall Type(
		[out, retval]DataTypeEnum* ptype);
	[id(0x60020004), propget, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[out, retval]long* plAttributes);
	[id(0x60020004), propput, helpcontext(0x0012c90d)]
	HRESULT __stdcall Attributes(
		[in]long plAttributes);
};
```
'!
!ADODB.Property categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Property methodsFor!

attributes
	"Answer the <sdword> value of the 'Attributes' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Attributes: answer.
	^answer asObject!

attributes: plAttributes
	"Set the 'Attributes' property of the receiver to the <sdword> value of the argument."

	self put_Attributes: plAttributes!

get_Attributes: plAttributes
	"Private - Get the value of the 'Attributes' property of the receiver.

		HRESULT __stdcall Attributes(
			[out, retval]long* plAttributes);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

get_Name: pbstr
	"Private - Get the value of the 'Name' property of the receiver.

		HRESULT __stdcall Name(
			[out, retval]BSTR* pbstr);"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall: _failureCode!

get_Type: ptype
	"Private - Get the value of the 'Type' property of the receiver.

		HRESULT __stdcall Type(
			[out, retval]DataTypeEnum* ptype);"

	<virtual stdcall: hresult 11 sdword*>
	^self invalidCall: _failureCode!

get_Value: pval
	"Private - Get the value of the 'Value' property of the receiver.

		HRESULT __stdcall Value(
			[out, retval]VARIANT* pval);"

	<virtual stdcall: hresult 8 variant*>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

name
	"Answer the <bstr> value of the 'Name' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Name: answer.
	^answer asObject!

printValueOn: aStream
	aStream
		print: self name;
		nextPutAll: '=';
		print: self value!

put_Attributes: plAttributes
	"Private - Set the value of the 'Attributes' property of the object wrapped by the 
	 receiver to the <sdword> argument, plAttributes.

		HRESULT __stdcall Attributes(
			[in]long plAttributes);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall: _failureCode!

put_Value: pval
	"Private - Set the value of the 'Value' property of the object wrapped by the 
	 receiver to the <variant> argument, pval.

		HRESULT __stdcall Value(
			[in]VARIANT pval);"

	<virtual stdcall: hresult 9 variant>
	^self invalidCall: _failureCode!

type
	"Answer the <sdword> value of the 'Type' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_Type: answer.
	^answer asObject!

value
	"Answer the <variant> value of the 'Value' property of the receiver."

	| answer |
	answer := VARIANT new.
	self get_Value: answer.
	^answer asObject!

value: pval
	"Set the 'Value' property of the receiver to the <variant> value of the argument."

	self put_Value: pval asVariant! !
!ADODB.Property categoriesFor: #attributes!**auto generated**!properties!public! !
!ADODB.Property categoriesFor: #attributes:!**auto generated**!properties!public! !
!ADODB.Property categoriesFor: #get_Attributes:!**auto generated**!COM Interfaces-Property!private! !
!ADODB.Property categoriesFor: #get_Name:!**auto generated**!COM Interfaces-Property!private! !
!ADODB.Property categoriesFor: #get_Type:!**auto generated**!COM Interfaces-Property!private! !
!ADODB.Property categoriesFor: #get_Value:!**auto generated**!COM Interfaces-Property!private! !
!ADODB.Property categoriesFor: #isExtensible!**auto generated**!public!testing! !
!ADODB.Property categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!ADODB.Property categoriesFor: #name!**auto generated**!properties!public! !
!ADODB.Property categoriesFor: #printValueOn:!printing!private! !
!ADODB.Property categoriesFor: #put_Attributes:!**auto generated**!COM Interfaces-Property!private! !
!ADODB.Property categoriesFor: #put_Value:!**auto generated**!COM Interfaces-Property!private! !
!ADODB.Property categoriesFor: #type!**auto generated**!properties!public! !
!ADODB.Property categoriesFor: #value!**auto generated**!properties!public! !
!ADODB.Property categoriesFor: #value:!**auto generated**!properties!public! !

!ADODB.Property class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Property'
		Property defineTemplate"

	self
		defineFunction: #get_Value:
			argumentTypes: 'variant*';
		defineFunction: #put_Value:
			argumentTypes: 'variant';
		defineFunction: #get_Name:
			argumentTypes: 'bstr*';
		defineFunction: #get_Type:
			argumentTypes: 'sdword*';
		defineFunction: #get_Attributes:
			argumentTypes: 'sdword*';
		defineFunction: #put_Attributes:
			argumentTypes: 'sdword'
! !
!ADODB.Property class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

