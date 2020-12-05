"Filed out from Dolphin Smalltalk 7"!

ADODB._Collection subclass: #'ADODB._DynaCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB._DynaCollection guid: (OS.COM.IID fromString: '{00000513-0000-0010-8000-00aa006d2ea4}')!
ADODB._DynaCollection comment: '`ADODB_DynaCollection` is a wrapper class for the COM interface ''ADODB._DynaCollection'' generated from type information in the ''Microsoft ActiveX Data Objects 6.1 Library'' library. It contains methods to invoke the member functions exposed by that interface.

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
!ADODB._DynaCollection categoriesForClass!ADODB-Interfaces!COM-Interfaces! !
!ADODB._DynaCollection methodsFor!

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
!ADODB._DynaCollection categoriesFor: #Append:!**auto generated**!COM Interfaces-_DynaCollection!public! !
!ADODB._DynaCollection categoriesFor: #delete:!**auto generated**!methods!public! !
!ADODB._DynaCollection categoriesFor: #Delete:!**auto generated**!COM Interfaces-_DynaCollection!private! !

!ADODB._DynaCollection class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'ADODB._DynaCollection'
		_DynaCollection defineTemplate"

	self
		defineFunction: #Append:
			argumentTypes: 'IDispatch*';
		defineFunction: #Delete:
			argumentTypes: 'variant'
! !
!ADODB._DynaCollection class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

