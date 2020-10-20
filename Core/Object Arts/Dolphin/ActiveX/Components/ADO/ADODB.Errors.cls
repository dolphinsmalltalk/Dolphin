"Filed out from Dolphin Smalltalk 7"!

ADODB._Collection subclass: #'ADODB.Errors'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.Errors guid: (OS.COM.IID fromString: '{00000501-0000-0010-8000-00aa006d2ea4}')!
ADODB.Errors comment: '`Errors` is a wrapper class for the COM interface ''ADODB.Errors'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000501-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c8fd), 
	nonextensible, 
	dual
]
interface Errors : _Collection
 {
	[id(0000000000), propget, helpcontext(0x0012c8d1)]
	HRESULT __stdcall Item(
		[in]VARIANT Index,
		[out, retval]Error** ppvObject);
	[id(0x60030001), helpcontext(0x0012c8bd)]
	HRESULT __stdcall Clear();
};
```
'!
!ADODB.Errors categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB.Errors methodsFor!

Clear
	"Invoke the Clear() method of the COM object.

		HRESULT __stdcall Clear();"

	<virtual stdcall: hresult 12>
	^self invalidCall: _failureCode!

get_Item: index ppvObject: ppvObject
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]VARIANT Index,
			[out, retval]Error** ppvObject);"

	<virtual stdcall: hresult 11 variant Error**>
	^self invalidCall: _failureCode!

item: index
	"Answer the <Error> value of the 'Item' property of the receiver."

	| answer |
	answer := Error newPointer.
	self get_Item: index asVariant ppvObject: answer.
	^answer asObject! !
!ADODB.Errors categoriesFor: #Clear!**auto generated**!COM Interfaces-Errors!public! !
!ADODB.Errors categoriesFor: #get_Item:ppvObject:!**auto generated**!COM Interfaces-Errors!private! !
!ADODB.Errors categoriesFor: #item:!**auto generated**!properties!public! !

!ADODB.Errors class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Errors'
		Errors defineTemplate"

	self
		defineFunction: #get_Item:ppvObject:
			argumentTypes: 'variant Error**';
		defineFunction: #Clear
! !
!ADODB.Errors class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

