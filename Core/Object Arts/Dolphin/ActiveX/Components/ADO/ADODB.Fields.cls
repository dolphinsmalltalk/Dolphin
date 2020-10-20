"Filed out from Dolphin Smalltalk 7"!

ADODB.Fields20 subclass: #'ADODB.Fields'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Fields guid: (OS.COM.IID fromString: '{00001564-0000-0010-8000-00aa006d2ea4}')!
ADODB.Fields comment: '`Fields` is a wrapper class for the COM interface ''ADODB.Fields'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001564-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c8fe), 
	hidden, 
	nonextensible, 
	dual
]
interface Fields : Fields20
 {
	[id(0x00000003), helpcontext(0x0012f05d)]
	HRESULT __stdcall Append(
		[in]BSTR Name,
		[in]DataTypeEnum Type,
		[in, defaultvalue(0)]long DefinedSize,
		[in, defaultvalue(-1)]FieldAttributeEnum Attrib,
		[in, optional]VARIANT FieldValue);
	[id(0x00000005), helpcontext(0x0012f05e)]
	HRESULT __stdcall Update();
	[id(0x00000006), helpcontext(0x0012f05f)]
	HRESULT __stdcall Resync(
		[in, defaultvalue(2)]ResyncEnum ResyncValues);
	[id(0x00000007), helpcontext(0x0012f060)]
	HRESULT __stdcall CancelUpdate();
};
```
'!
!ADODB.Fields categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Fields methodsFor!

append: name type: type
	"Invoke the Append() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		append: name
		type: type
		definedSize: 0
		attrib: -1
		fieldValue: VARIANT unspecified!

append: name type: type definedSize: definedSize attrib: attrib fieldValue: fieldValue
	"Invoke the Append() method of the COM object."

	^self
		Append: name
		Type: type
		DefinedSize: definedSize
		Attrib: attrib
		FieldValue: fieldValue asVariant!

Append: name Type: type DefinedSize: definedSize Attrib: attrib FieldValue: fieldValue
	"Private - Invoke the Append() method of the COM object.

		HRESULT __stdcall Append(
			[in]BSTR Name,
			[in]DataTypeEnum Type,
			[in, defaultvalue(0)]long DefinedSize,
			[in, defaultvalue(-1)]FieldAttributeEnum Attrib,
			[in, optional]VARIANT FieldValue);"

	<virtual stdcall: hresult 14 bstr sdword sdword sdword variant>
	^self invalidCall: _failureCode!

CancelUpdate
	"Invoke the CancelUpdate() method of the COM object.

		HRESULT __stdcall CancelUpdate();"

	<virtual stdcall: hresult 17>
	^self invalidCall: _failureCode!

resync
	"Invoke the Resync() method of the COM object.
	Default values are passed for all optional parameters."

	^self Resync: 2!

Resync: resyncValues
	"Invoke the Resync() method of the COM object.

		HRESULT __stdcall Resync(
			[in, defaultvalue(2)]ResyncEnum ResyncValues);"

	<virtual stdcall: hresult 16 sdword>
	^self invalidCall: _failureCode!

Update
	"Invoke the Update() method of the COM object.

		HRESULT __stdcall Update();"

	<virtual stdcall: hresult 15>
	^self invalidCall: _failureCode! !
!ADODB.Fields categoriesFor: #append:type:!**auto generated**!methods!public! !
!ADODB.Fields categoriesFor: #append:type:definedSize:attrib:fieldValue:!**auto generated**!methods!public! !
!ADODB.Fields categoriesFor: #Append:Type:DefinedSize:Attrib:FieldValue:!**auto generated**!COM Interfaces-Fields!private! !
!ADODB.Fields categoriesFor: #CancelUpdate!**auto generated**!COM Interfaces-Fields!public! !
!ADODB.Fields categoriesFor: #resync!**auto generated**!methods!public! !
!ADODB.Fields categoriesFor: #Resync:!**auto generated**!COM Interfaces-Fields!public! !
!ADODB.Fields categoriesFor: #Update!**auto generated**!COM Interfaces-Fields!public! !

!ADODB.Fields class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Fields'
		Fields defineTemplate"

	self
		defineFunction: #Append:Type:DefinedSize:Attrib:FieldValue:
			argumentTypes: 'bstr sdword sdword sdword variant';
		defineFunction: #Update;
		defineFunction: #Resync:
			argumentTypes: 'sdword';
		defineFunction: #CancelUpdate
! !
!ADODB.Fields class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

