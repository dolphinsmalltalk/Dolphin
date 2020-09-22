"Filed out from Dolphin Smalltalk 7"!

ADODB_Collection subclass: #ADODBFields15
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODBFields15 guid: (IID fromString: '{00001506-0000-0010-8000-00aa006d2ea4}')!
ADODBFields15 comment: '`ADODBFields15` is a wrapper class for the COM interface ''ADODB.Fields15'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00001506-0000-0010-8000-00aa006d2ea4), 
	helpcontext(0x0012c8fe), 
	hidden, 
	nonextensible, 
	dual
]
interface Fields15 : _Collection
 {
	[id(0000000000), propget, helpcontext(0x0012c8d1)]
	HRESULT __stdcall Item(
		[in]VARIANT Index,
		[out, retval]Field** ppvObject);
};
```
'!
!ADODBFields15 categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODBFields15 methodsFor!

get_Item: index ppvObject: ppvObject
	"Private - Get the value of the 'Item' property of the receiver.

		HRESULT __stdcall Item(
			[in]VARIANT Index,
			[out, retval]Field** ppvObject);"

	<virtual stdcall: hresult 11 variant ADODBField**>
	^self invalidCall: _failureCode!

item: index
	"Answer the <ADODBField> value of the 'Item' property of the receiver."

	| answer |
	answer := ADODBField newPointer.
	self get_Item: index asVariant ppvObject: answer.
	^answer asObject! !
!ADODBFields15 categoriesFor: #get_Item:ppvObject:!**auto generated**!COM Interfaces-Fields15!private! !
!ADODBFields15 categoriesFor: #item:!**auto generated**!properties!public! !

!ADODBFields15 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB.Fields15'
		ADODBFields15 defineTemplate"

	self
		defineFunction: #get_Item:ppvObject:
			argumentTypes: 'variant ADODBField**'
! !
!ADODBFields15 class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

