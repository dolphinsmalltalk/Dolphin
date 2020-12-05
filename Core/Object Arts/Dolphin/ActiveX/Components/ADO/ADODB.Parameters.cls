"Filed out from Dolphin Smalltalk 7"!

ADODB._DynaCollection subclass: #'ADODB.Parameters'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Parameters guid: (OS.COM.IID fromString: '{0000150d-0000-0010-8000-00aa006d2ea4}')!
ADODB.Parameters comment: '`ADODBParameters` is a wrapper class for the COM interface ''ADODB.Parameters'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(0000150d-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c8ff), 
	nonextensible, 
	dual
]
interface Parameters : _DynaCollection
 {
	[id(0000000000), propget, helpcontext(0x0012c8d1)]
	HRESULT __stdcall Item(
		[in]VARIANT Index,
		[out, retval]_Parameter** ppvObject);
};
```
'!
!ADODB.Parameters categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Parameters methodsFor!

get_Item: index ppvObject: ppvObject
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]VARIANT Index,
			[out, retval]_Parameter** ppvObject);"

	<virtual stdcall: hresult 13 variant _Parameter**>
	^self invalidCall: _failureCode!

item: index
	"Answer the <_Parameter> value of the 'Item' property of the receiver."

	| answer |
	answer := _Parameter newPointer.
	self get_Item: index asVariant ppvObject: answer.
	^answer asObject! !
!ADODB.Parameters categoriesFor: #get_Item:ppvObject:!**auto generated**!COM Interfaces-Parameters!private! !
!ADODB.Parameters categoriesFor: #item:!**auto generated**!properties!public! !

!ADODB.Parameters class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Parameters'
		Parameters defineTemplate"

	self
		defineFunction: #get_Item:ppvObject:
			argumentTypes: 'variant _Parameter**'
! !
!ADODB.Parameters class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

