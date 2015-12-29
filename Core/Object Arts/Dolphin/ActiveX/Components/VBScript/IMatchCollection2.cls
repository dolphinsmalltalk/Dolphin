"Filed out from Dolphin Smalltalk X6"!

IMatchCollection subclass: #IMatchCollection2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IMatchCollection2 guid: (IID fromString: '{3F4DACB2-160D-11D2-A8E9-00104B365C9F}')!
IMatchCollection2 comment: '<IMatchCollection2> is a wrapper class for the COM interface ''VBScript_RegExp_55.IMatchCollection2'' generated from type information in the ''Microsoft VBScript Regular Expressions 5.5'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(3F4DACB2-160D-11D2-A8E9-00104B365C9F), 
	hidden, 
	dual, 
	nonextensible
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
'!
!IMatchCollection2 categoriesForClass!COM-Interfaces!VBScript_RegExp_55-Interfaces! !
!IMatchCollection2 methodsFor!

matchClass
	^IMatch2! !
!IMatchCollection2 categoriesFor: #matchClass!constants!private! !

!IMatchCollection2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'VBScript_RegExp_55.IMatchCollection'
		IMatchCollection2 defineTemplate"
! !
!IMatchCollection2 class categoriesFor: #defineFunctions!initializing!public! !

