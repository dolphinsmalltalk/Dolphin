"Filed out from Dolphin Smalltalk 7"!

ADODB.Recordset20 subclass: #'ADODB.Recordset21'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Recordset21 guid: (OS.COM.IID fromString: '{00001555-0000-0010-8000-00aa006d2ea4}')!
ADODB.Recordset21 comment: '`Recordset21` is a wrapper class for the COM interface ''ADODB.Recordset21'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001555-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c903), 
	hidden, 
	nonextensible, 
	dual
]
interface Recordset21 : Recordset20
 {
	[id(0x0000042a), helpcontext(0x001356db)]
	HRESULT __stdcall Seek(
		[in]VARIANT KeyValues,
		[in, defaultvalue(1)]SeekEnum SeekOption);
	[id(0x0000042b), propput, helpcontext(0x001356da)]
	HRESULT __stdcall Index(
		[in]BSTR pbstrIndex);
	[id(0x0000042b), propget, helpcontext(0x001356da)]
	HRESULT __stdcall Index(
		[out, retval]BSTR* pbstrIndex);
};
```
'!
!ADODB.Recordset21 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Recordset21 methodsFor!

get_Index: pbstrIndex
	"Private - Get the value of the 'Index' property of the receiver.

		HRESULT __stdcall Index(
			[out, retval]BSTR* pbstrIndex);"

	<virtual stdcall: hresult 84 bstr*>
	^self invalidCall: _failureCode!

index
	"Answer the <bstr> value of the 'Index' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_Index: answer.
	^answer asObject!

index: pbstrIndex
	"Set the 'Index' property of the receiver to the <bstr> value of the argument."

	self put_Index: pbstrIndex!

put_Index: pbstrIndex
	"Private - Set the value of the 'Index' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrIndex.

		HRESULT __stdcall Index(
			[in]BSTR pbstrIndex);"

	<virtual stdcall: hresult 83 bstr>
	^self invalidCall: _failureCode!

seek: keyValues
	"Invoke the Seek() method of the COM object.
	Default values are passed for all optional parameters."

	^self seek: keyValues seekOption: 1!

seek: keyValues seekOption: seekOption
	"Invoke the Seek() method of the COM object."

	^self Seek: keyValues asVariant SeekOption: seekOption!

Seek: keyValues SeekOption: seekOption
	"Private - Invoke the Seek() method of the COM object.

		HRESULT __stdcall Seek(
			[in]VARIANT KeyValues,
			[in, defaultvalue(1)]SeekEnum SeekOption);"

	<virtual stdcall: hresult 82 variant sdword>
	^self invalidCall: _failureCode! !
!ADODB.Recordset21 categoriesFor: #get_Index:!**auto generated**!COM Interfaces-Recordset21!private! !
!ADODB.Recordset21 categoriesFor: #index!**auto generated**!properties!public! !
!ADODB.Recordset21 categoriesFor: #index:!**auto generated**!properties!public! !
!ADODB.Recordset21 categoriesFor: #put_Index:!**auto generated**!COM Interfaces-Recordset21!private! !
!ADODB.Recordset21 categoriesFor: #seek:!**auto generated**!methods!public! !
!ADODB.Recordset21 categoriesFor: #seek:seekOption:!**auto generated**!methods!public! !
!ADODB.Recordset21 categoriesFor: #Seek:SeekOption:!**auto generated**!COM Interfaces-Recordset21!private! !

!ADODB.Recordset21 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Recordset21'
		Recordset21 defineTemplate"

	self
		defineFunction: #Seek:SeekOption:
			argumentTypes: 'variant sdword';
		defineFunction: #put_Index:
			argumentTypes: 'bstr';
		defineFunction: #get_Index:
			argumentTypes: 'bstr*'
! !
!ADODB.Recordset21 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

