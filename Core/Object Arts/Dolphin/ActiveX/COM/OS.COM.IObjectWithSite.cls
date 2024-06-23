"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IObjectWithSite'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IObjectWithSite guid: (OS.COM.IID fromString: '{fc4801a3-2ba9-11cf-a229-00aa003d7352}')!

OS.COM.IObjectWithSite comment: '`IObjectWithSite` is a wrapper class for the COM interface ''Win32.IObjectWithSite'' generated from type information in the ''Win32 API'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Enables a container to pass an object a pointer to the interface for its site."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(fc4801a3-2ba9-11cf-a229-00aa003d7352)
]
interface IObjectWithSite : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall SetSite(
		[in]IUnknown* pUnkSite);
	[id(0x60010001)]
	HRESULT __stdcall GetSite(
		[in]GUID* riid,
		[out]void** ppvSite);
};
```
'!

!OS.COM.IObjectWithSite categoriesForClass!COM-Interfaces!Win32-Interfaces! !

!OS.COM.IObjectWithSite methodsFor!

GetSite: riid ppvSite: ppvSite
	"Invoke the GetSite() method of the COM object.

		HRESULT __stdcall GetSite(
			[in]GUID* riid,
			[out]void** ppvSite);"

	<virtual stdcall: hresult 5 guid* IUnknown**>
	^self invalidCall: _failureCode!

SetSite: pUnkSite
	"Invoke the SetSite() method of the COM object.

		HRESULT __stdcall SetSite(
			[in]IUnknown* pUnkSite);"

	<virtual stdcall: hresult 4 IUnknown*>
	^self invalidCall: _failureCode! !

!OS.COM.IObjectWithSite categoriesForMethods!
GetSite:ppvSite:!**auto generated**!COM Interfaces-IObjectWithSite!public! !
SetSite:!**auto generated**!COM Interfaces-IObjectWithSite!public! !
!

OS.COM.IObjectWithSite methodProtocol: #IObjectWithSite attributes: #(#readOnly) selectors: #(#GetSite:ppvSite: #SetSite:)!

!OS.COM.IObjectWithSite class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IObjectWithSite'
		IObjectWithSite defineTemplate"

	self
		defineFunction: #SetSite:
			argumentTypes: 'IUnknown*';
		defineFunction: #GetSite:ppvSite:
			argumentTypes: 'IID* IUnknown**'
! !

!OS.COM.IObjectWithSite class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

