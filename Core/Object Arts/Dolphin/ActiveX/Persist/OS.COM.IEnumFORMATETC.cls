"Filed out from Dolphin Smalltalk"!

OS.COM.IEnumXXXX
	subclass: #'OS.COM.IEnumFORMATETC'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IEnumFORMATETC guid: (OS.COM.IID fromString: '{00000103-0000-0000-c000-000000000046}')!

OS.COM.IEnumFORMATETC comment: '`IEnumFORMATETC` is a wrapper class for the COM interface ''WebView2.IEnumFORMATETC'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(00000103-0000-0000-c000-000000000046)
]
interface IEnumFORMATETC : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall RemoteNext(
		[in]unsigned long celt,
		[out]FORMATETC* rgelt,
		[out]unsigned long* pceltFetched);
	[id(0x60010001)]
	HRESULT __stdcall Skip(
		[in]unsigned long celt);
	[id(0x60010002)]
	HRESULT __stdcall Reset();
	[id(0x60010003)]
	HRESULT __stdcall Clone(
		[out]IEnumFORMATETC** ppenum);
};
```
'!

!OS.COM.IEnumFORMATETC categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!OS.COM.IEnumFORMATETC class methodsFor!

elementClass
	"Private - Answer the class of element enumerated by the receiver."

	^FORMATETC
! !

!OS.COM.IEnumFORMATETC class categoriesForMethods!
elementClass!constants!private! !
!

