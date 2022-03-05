"Filed out from Dolphin Smalltalk"!

ADODB_Collection subclass: #ADODBProperties
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''!
ADODBProperties guid: (IID fromString: '{00000504-0000-0010-8000-00aa006d2ea4}')!
ADODBProperties comment: '`ADODBProperties` is a wrapper class for the COM interface ''ADODB.Properties'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

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
!ADODBProperties categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBProperties methodsFor!

get_Item: index ppvObject: ppvObject
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]VARIANT Index,
			[out, retval]Property** ppvObject);"

	<virtual stdcall: hresult 11 variant ADODBProperty**>
	^self invalidCall: _failureCode!

item: index
	"Answer the <ADODBProperty> value of the 'Item' property of the receiver."

	| answer |
	answer := ADODBProperty newPointer.
	self get_Item: index asVariant ppvObject: answer.
	^answer asObject! !
!ADODBProperties categoriesForMethods!
get_Item:ppvObject:!**auto generated**!COM Interfaces-Properties!private! !
item:!**auto generated**!properties!public! !
!

!ADODBProperties class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Properties'
		ADODBProperties defineTemplate"

	self
		defineFunction: #get_Item:ppvObject:
			argumentTypes: 'variant ADODBProperty**'
! !
!ADODBProperties class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

