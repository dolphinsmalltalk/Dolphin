"Filed out from Dolphin Smalltalk 7"!

ADODB._Collection subclass: #'ADODB.Properties'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Properties guid: (OS.COM.IID fromString: '{00000504-0000-0010-8000-00aa006d2ea4}')!
ADODB.Properties comment: '`ADODBProperties` is a wrapper class for the COM interface ''ADODB.Properties'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000504-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c900), 
	nonextensible, 
	dual
]
interface Properties : _Collection
 {
	[id(0000000000), propget, helpcontext(0x0012c8d1)]
	HRESULT __stdcall Item(
		[in]VARIANT Index,
		[out, retval]Property** ppvObject);
};
```
'!
!ADODB.Properties categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Properties methodsFor!

get_Item: index ppvObject: ppvObject
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]VARIANT Index,
			[out, retval]Property** ppvObject);"

	<virtual stdcall: hresult 11 variant Property**>
	^self invalidCall: _failureCode!

item: index
	"Answer the <Property> value of the 'Item' property of the receiver."

	| answer |
	answer := Property newPointer.
	self get_Item: index asVariant ppvObject: answer.
	^answer asObject! !
!ADODB.Properties categoriesFor: #get_Item:ppvObject:!**auto generated**!COM Interfaces-Properties!private! !
!ADODB.Properties categoriesFor: #item:!**auto generated**!properties!public! !

!ADODB.Properties class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Properties'
		Properties defineTemplate"

	self
		defineFunction: #get_Item:ppvObject:
			argumentTypes: 'variant Property**'
! !
!ADODB.Properties class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

