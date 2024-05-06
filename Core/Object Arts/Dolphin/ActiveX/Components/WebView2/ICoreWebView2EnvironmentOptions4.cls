"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2EnvironmentOptions4
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2EnvironmentOptions4 guid: (IID fromString: '{ac52d13f-0d38-475a-9dca-876580d6793e}')!

ICoreWebView2EnvironmentOptions4 comment: '`ICoreWebView2EnvironmentOptions4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ac52d13f-0d38-475a-9dca-876580d6793e)
]
interface ICoreWebView2EnvironmentOptions4 : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetCustomSchemeRegistrations(
		[out]unsigned int* Count,
		[out]ICoreWebView2CustomSchemeRegistration*** schemeRegistrations);
	[id(0x60010001)]
	HRESULT __stdcall SetCustomSchemeRegistrations(
		[in]unsigned int Count,
		[in]ICoreWebView2CustomSchemeRegistration** schemeRegistrations);
};
```
'!

!ICoreWebView2EnvironmentOptions4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2EnvironmentOptions4 methodsFor!

getCustomSchemeRegistrations
	| registrations pArray count |
	count := DWORDBytes new.
	pArray := ExternalAddress new.
	self GetCustomSchemeRegistrations: count schemeRegistrations: pArray.
	count := count value.
	registrations := Array new: count.
	1 to: count
		do: 
			[:i |
			registrations at: i
				put: (ICoreWebView2CustomSchemeRegistration
						attach: (pArray uintPtrAtOffset: (i - 1) * VMConstants.IntPtrSize))].
	COMTaskMemory free: pArray.
	^registrations!

GetCustomSchemeRegistrations: count schemeRegistrations: schemeRegistrations
	"Private - Invoke the GetCustomSchemeRegistrations() method of the COM object.

		HRESULT __stdcall GetCustomSchemeRegistrations(
			[out]unsigned int* Count,
			[out]ICoreWebView2CustomSchemeRegistration*** schemeRegistrations);"

	<virtual stdcall: hresult 4 dword* ICoreWebView2CustomSchemeRegistration**>
	^self invalidCall: _failureCode!

setCustomSchemeRegistrations: aCollection
	| interfaces pointers |
	interfaces := aCollection
				collect: [:each | each queryInterface: ICoreWebView2CustomSchemeRegistration].
	pointers := PointerArray withAll: interfaces.
	self SetCustomSchemeRegistrations: pointers size schemeRegistrations: pointers.
	interfaces do: [:each | each free]!

SetCustomSchemeRegistrations: count schemeRegistrations: schemeRegistrations
	"Private - Invoke the SetCustomSchemeRegistrations() method of the COM object.

		HRESULT __stdcall SetCustomSchemeRegistrations(
			[in]unsigned int Count,
			[in]ICoreWebView2CustomSchemeRegistration** schemeRegistrations);"

	<virtual stdcall: hresult 5 dword ICoreWebView2CustomSchemeRegistration**>
	^self invalidCall: _failureCode! !

!ICoreWebView2EnvironmentOptions4 categoriesForMethods!
getCustomSchemeRegistrations!COM Interfaces-ICoreWebView2EnvironmentOptions4!public! !
GetCustomSchemeRegistrations:schemeRegistrations:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions4!private! !
setCustomSchemeRegistrations:!COM Interfaces-ICoreWebView2EnvironmentOptions4!public! !
SetCustomSchemeRegistrations:schemeRegistrations:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions4!private! !
!

!ICoreWebView2EnvironmentOptions4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions4'
		ICoreWebView2EnvironmentOptions4 defineTemplate"

	self
		defineFunction: #GetCustomSchemeRegistrations:schemeRegistrations:
			argumentTypes: 'dword* ICoreWebView2CustomSchemeRegistration**';
		defineFunction: #SetCustomSchemeRegistrations:schemeRegistrations:
			argumentTypes: 'dword ICoreWebView2CustomSchemeRegistration**'
! !

!ICoreWebView2EnvironmentOptions4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

