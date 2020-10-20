"Filed out from Dolphin Smalltalk 7"!

ADODB.Fields15 subclass: #'ADODB.Fields20'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Fields20 guid: (OS.COM.IID fromString: '{0000154d-0000-0010-8000-00aa006d2ea4}')!
ADODB.Fields20 comment: '`Fields20` is a wrapper class for the COM interface ''ADODB.Fields20'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0000154d-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c8fe), 
	hidden, 
	nonextensible, 
	dual
]
interface Fields20 : Fields15
 {
	[id(0x60040000), hidden]
	HRESULT __stdcall _Append(
		[in]BSTR Name,
		[in]DataTypeEnum Type,
		[in, defaultvalue(0)]long DefinedSize,
		[in, defaultvalue(-1)]FieldAttributeEnum Attrib);
	[id(0x00000004), helpcontext(0x0012f05c)]
	HRESULT __stdcall Delete(
		[in]VARIANT Index);
};
```
'!
!ADODB.Fields20 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Fields20 methodsFor!

_append: name type: type
	"Invoke the _Append() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		_Append: name
		Type: type
		DefinedSize: 0
		Attrib: -1!

_Append: name Type: type DefinedSize: definedSize Attrib: attrib
	"Invoke the _Append() method of the COM object.

		HRESULT __stdcall _Append(
			[in]BSTR Name,
			[in]DataTypeEnum Type,
			[in, defaultvalue(0)]long DefinedSize,
			[in, defaultvalue(-1)]FieldAttributeEnum Attrib);"

	<virtual stdcall: hresult 12 bstr sdword sdword sdword>
	^self invalidCall: _failureCode!

delete: index
	"Invoke the Delete() method of the COM object."

	^self Delete: index asVariant!

Delete: index
	"Private - Invoke the Delete() method of the COM object.

		HRESULT __stdcall Delete(
			[in]VARIANT Index);"

	<virtual stdcall: hresult 13 variant>
	^self invalidCall: _failureCode! !
!ADODB.Fields20 categoriesFor: #_append:type:!**auto generated**!methods!public! !
!ADODB.Fields20 categoriesFor: #_Append:Type:DefinedSize:Attrib:!**auto generated**!COM Interfaces-Fields20!public! !
!ADODB.Fields20 categoriesFor: #delete:!**auto generated**!methods!public! !
!ADODB.Fields20 categoriesFor: #Delete:!**auto generated**!COM Interfaces-Fields20!private! !

!ADODB.Fields20 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Fields20'
		Fields20 defineTemplate"

	self
		defineFunction: #_Append:Type:DefinedSize:Attrib:
			argumentTypes: 'bstr sdword sdword sdword';
		defineFunction: #Delete:
			argumentTypes: 'variant'
! !
!ADODB.Fields20 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

