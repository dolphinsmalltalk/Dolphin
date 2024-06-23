"Filed out from Dolphin Smalltalk"!

VBScript.IMatchCollection
	subclass: #'VBScript.IMatchCollection2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

VBScript.IMatchCollection2 guid: (OS.COM.IID fromString: '{3f4dacb2-160d-11d2-a8e9-00104b365c9f}')!

VBScript.IMatchCollection2 isEgressOnly: true!

VBScript.IMatchCollection2 comment: '`IMatchCollection2` is a wrapper class for the COM interface ''VBScript_RegExp_55.IMatchCollection2'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(3f4dacb2-160d-11d2-a8e9-00104b365c9f), 
	hidden, 
	nonextensible, 
	dual
]
interface IMatchCollection2 : IDispatch
 {
	[id(0000000000), propget]
	HRESULT __stdcall Item(
		[in]long index,
		[out, retval]IDispatch** ppMatch);
	[id(0x00000001), propget]
	HRESULT __stdcall Count(
		[out, retval]long* pCount);
	[id(0xfffffffc), propget]
	HRESULT __stdcall _NewEnum(
		[out, retval]IUnknown** ppEnum);
};
```
'!

!VBScript.IMatchCollection2 categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !

!VBScript.IMatchCollection2 methodsFor!

matchClass
	^IMatch2! !

!VBScript.IMatchCollection2 categoriesForMethods!
matchClass!constants!private! !
!

!VBScript.IMatchCollection2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'VBScript_RegExp_55.IMatchCollection'
		IMatchCollection2 defineTemplate"
! !

!VBScript.IMatchCollection2 class categoriesForMethods!
defineFunctions!initializing!public! !
!

