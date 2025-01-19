"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EnvironmentOptions4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2EnvironmentOptions4 guid: (OS.COM.IID fromString: '{ac52d13f-0d38-475a-9dca-876580d6793e}')!

WebView2.ICoreWebView2EnvironmentOptions4 comment: '`ICoreWebView2EnvironmentOptions4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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

!WebView2.ICoreWebView2EnvironmentOptions4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2EnvironmentOptions4 methodsFor!

customSchemeRegistrations
	"Answer an <Array> of <ICoreWebView2CustomSchemeRegistration>s describing the receiver's custom URI schemes."

	"This API is not as well designed as most of the other APIs in WebView2 that represent sequences as there is no collection object defined. Rather a contiguous array has to be allocated from the task allocator, populated with addref'd interface pointers, and then owership (i.e. responsibility to free) that array is passed out to the caller."

	| registrations pArray count |
	count := UInt32Bytes new.
	pArray := TaskMemory new.
	self GetCustomSchemeRegistrations: count schemeRegistrations: pArray.
	self assert: [(TaskMemory DidAlloc: pArray) ~~ 0].
	count := count value.
	registrations := Array new: count.
	1 to: count
		do: 
			[:i |
			"By attaching the interface pointers in the array, we are assuming the ref count added by the implementor of GetCustomSchemeRegistrations"
			registrations at: i
				put: (ICoreWebView2CustomSchemeRegistration
						attach: (pArray uintPtrAtOffset: (i - 1) * Kernel.VMConstants.IntPtrSize))].
	pArray free.
	^registrations!

customSchemeRegistrations: aCollection
	"Set the collection of <ICoreWebView2CustomSchemeRegistration>s describing the receiver's custom URI schemes."

	| interfaces pointers |
	interfaces := aCollection
				collect: [:each | each queryInterface: ICoreWebView2CustomSchemeRegistration].
	pointers := PointerArray withAll: interfaces elementClass: ICoreWebView2CustomSchemeRegistration.
	self SetCustomSchemeRegistrations: pointers size schemeRegistrations: pointers.
	interfaces do: [:each | each free]!

GetCustomSchemeRegistrations: count schemeRegistrations: schemeRegistrations
	"Private - Invoke the GetCustomSchemeRegistrations() method of the COM object.

		HRESULT __stdcall GetCustomSchemeRegistrations(
			[out]unsigned int* Count,
			[out]ICoreWebView2CustomSchemeRegistration*** schemeRegistrations);"

	<virtual stdcall: hresult 4 dword* ICoreWebView2CustomSchemeRegistration**>
	^self invalidCall: _failureCode!

SetCustomSchemeRegistrations: count schemeRegistrations: schemeRegistrations
	"Private - Invoke the SetCustomSchemeRegistrations() method of the COM object.

		HRESULT __stdcall SetCustomSchemeRegistrations(
			[in]unsigned int Count,
			[in]ICoreWebView2CustomSchemeRegistration** schemeRegistrations);"

	<virtual stdcall: hresult 5 dword ICoreWebView2CustomSchemeRegistration**>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2EnvironmentOptions4 categoriesForMethods!
customSchemeRegistrations!accessing!public! !
customSchemeRegistrations:!accessing!public! !
GetCustomSchemeRegistrations:schemeRegistrations:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions4!private! !
SetCustomSchemeRegistrations:schemeRegistrations:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions4!private! !
!

WebView2.ICoreWebView2EnvironmentOptions4 methodProtocol: #ICoreWebView2EnvironmentOptions4 attributes: #(#readOnly) selectors: #(#GetCustomSchemeRegistrations:schemeRegistrations: #SetCustomSchemeRegistrations:schemeRegistrations:)!

!WebView2.ICoreWebView2EnvironmentOptions4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions4'
		ICoreWebView2EnvironmentOptions4 defineTemplate"

	self
		defineFunction: #GetCustomSchemeRegistrations:schemeRegistrations:
			argumentTypes: 'dword* ICoreWebView2CustomSchemeRegistration**';
		defineFunction: #SetCustomSchemeRegistrations:schemeRegistrations:
			argumentTypes: 'dword ICoreWebView2CustomSchemeRegistration**'
! !

!WebView2.ICoreWebView2EnvironmentOptions4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

