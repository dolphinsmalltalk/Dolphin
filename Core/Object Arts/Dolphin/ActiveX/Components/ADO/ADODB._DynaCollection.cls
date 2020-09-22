"Filed out from Dolphin Smalltalk 7"!

ADODB_Collection subclass: #ADODB_DynaCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ADODBConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB_DynaCollection guid: (IID fromString: '{00000513-0000-0010-8000-00aa006d2ea4}')!
ADODB_DynaCollection comment: '`ADODB_DynaCollection` is a wrapper class for the COM interface ''ADODB._DynaCollection'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000513-0000-0010-8000-00aa006d2ea4), 
	nonextensible, 
	dual
]
interface _DynaCollection : _Collection
 {
	[id(0x60030000), helpcontext(0x0012c8b5)]
	HRESULT __stdcall Append(
		[in]IDispatch* Object);
	[id(0x60030001), helpcontext(0x0012c8c4)]
	HRESULT __stdcall Delete(
		[in]VARIANT Index);
};
```
'!
!ADODB_DynaCollection categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB_DynaCollection methodsFor!

Append: object
	"Invoke the Append() method of the COM object.

		HRESULT __stdcall Append(
			[in]IDispatch* Object);"

	<virtual stdcall: hresult 11 IDispatch*>
	^self invalidCall: _failureCode!

delete: index
	"Invoke the Delete() method of the COM object."

	^self Delete: index asVariant!

Delete: index
	"Private - Invoke the Delete() method of the COM object.

		HRESULT __stdcall Delete(
			[in]VARIANT Index);"

	<virtual stdcall: hresult 12 variant>
	^self invalidCall: _failureCode! !
!ADODB_DynaCollection categoriesFor: #Append:!**auto generated**!COM Interfaces-_DynaCollection!public! !
!ADODB_DynaCollection categoriesFor: #delete:!**auto generated**!methods!public! !
!ADODB_DynaCollection categoriesFor: #Delete:!**auto generated**!COM Interfaces-_DynaCollection!private! !

!ADODB_DynaCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._DynaCollection'
		ADODB_DynaCollection defineTemplate"

	self
		defineFunction: #Append:
			argumentTypes: 'IDispatch*';
		defineFunction: #Delete:
			argumentTypes: 'variant'
! !
!ADODB_DynaCollection class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

