﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2CustomSchemeRegistration'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2CustomSchemeRegistration guid: (OS.COM.IID fromString: '{d60ac92c-37a6-4b26-a39e-95cfe59047bb}')!

WebView2.ICoreWebView2CustomSchemeRegistration isEgressOnly: true!

WebView2.ICoreWebView2CustomSchemeRegistration comment: '`ICoreWebView2CustomSchemeRegistration` is a wrapper class for the COM interface ''WebView2.ICoreWebView2CustomSchemeRegistration'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(d60ac92c-37a6-4b26-a39e-95cfe59047bb)
]
interface ICoreWebView2CustomSchemeRegistration : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall SchemeName(
		[out, retval]LPWSTR* SchemeName);
	[id(0x60010001), propget]
	HRESULT __stdcall TreatAsSecure(
		[out, retval]long* TreatAsSecure);
	[id(0x60010001), propput]
	HRESULT __stdcall TreatAsSecure(
		[in]long TreatAsSecure);
	[id(0x60010003)]
	HRESULT __stdcall GetAllowedOrigins(
		[out]unsigned int* allowedOriginsCount,
		[out]LPWSTR** allowedOrigins);
	[id(0x60010004)]
	HRESULT __stdcall SetAllowedOrigins(
		[in]unsigned int allowedOriginsCount,
		[in]LPWSTR* allowedOrigins);
	[id(0x60010005), propget]
	HRESULT __stdcall HasAuthorityComponent(
		[out, retval]long* HasAuthorityComponent);
	[id(0x60010005), propput]
	HRESULT __stdcall HasAuthorityComponent(
		[in]long HasAuthorityComponent);
};
```
'!

!WebView2.ICoreWebView2CustomSchemeRegistration categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2CustomSchemeRegistration methodsFor!

allowedOrigins
	"GetAllowedOrigins would be easier to use and implement if it employed ICoreWebView2StringCollection. Unfortunately the designer of this API somehow failed to notice the way collections are generally managed in WebView2, and chose to return a sequence of strings through a dynamically allocated array of dynamically allocated strings and the length of the array through out parameters. This is ugly and requires some complex/error-prone memory management. As ownership of the memory is assumed by the caller (i.e. us). We must be careful to free each of the individual strings and the array that we are given to avoid leaking memory."

	| allowedOrigins taskAllocator pStrings count |
	count := UInt32Bytes new.
	pStrings := External.Address new.
	self GetAllowedOrigins: count allowedOrigins: pStrings.
	count := count value.
	allowedOrigins := Array new: count.
	taskAllocator := TaskMemory allocator.
	1 to: count
		do: 
			[:i |
			| pwsz |
			pwsz := pStrings uintPtrAtOffset: (i - 1) * Kernel.VMConstants.IntPtrSize.
			allowedOrigins at: i put: (Utf16String fromAddress: pwsz).
			self assert: [(taskAllocator DidAlloc: pwsz) ~~ 0].
			taskAllocator Free: pwsz].
	self assert: [(taskAllocator DidAlloc: pStrings) ~~ 0].
	^allowedOrigins!

allowedOrigins: aCollection
	| strings allowedOrigins |
	strings := aCollection collect: [:each | each asUtf16String].
	allowedOrigins := PointerArray withAll: strings elementClass: Utf16String.
	self SetAllowedOrigins: strings size allowedOrigins: allowedOrigins!

get_HasAuthorityComponent: hasAuthorityComponent
	"Private - Get the value of the 'HasAuthorityComponent' property of the receiver.

		HRESULT __stdcall HasAuthorityComponent(
			[out, retval]long* HasAuthorityComponent);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall: _failureCode!

get_SchemeName: schemeName
	"Private - Get the value of the 'SchemeName' property of the receiver.

		HRESULT __stdcall SchemeName(
			[out, retval]LPWSTR* SchemeName);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_TreatAsSecure: treatAsSecure
	"Private - Get the value of the 'TreatAsSecure' property of the receiver.

		HRESULT __stdcall TreatAsSecure(
			[out, retval]long* TreatAsSecure);"

	<virtual stdcall: hresult 5 sdword*>
	^self invalidCall: _failureCode!

GetAllowedOrigins: allowedOriginsCount allowedOrigins: allowedOrigins
	"Private - Invoke the GetAllowedOrigins() method of the COM object.

		HRESULT __stdcall GetAllowedOrigins(
			[out]unsigned int* allowedOriginsCount,
			[out]LPWSTR** allowedOrigins);"

	<virtual stdcall: hresult 7 dword* lpwstr*>
	^self invalidCall: _failureCode!

hasAuthorityComponent
	"Answer the <boolean> value of the 'HasAuthorityComponent' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_HasAuthorityComponent: buf.
	^buf asBoolean!

hasAuthorityComponent: hasAuthorityComponent
	"Set the 'HasAuthorityComponent' property of the receiver to the <boolean> value of the argument."

	self put_HasAuthorityComponent: hasAuthorityComponent asParameter!

printableProperties
	^#(#schemeName #treatAsSecure #hasAuthorityComponent #allowedOrigins)!

put_HasAuthorityComponent: hasAuthorityComponent
	"Private - Set the value of the 'HasAuthorityComponent' property of the object wrapped by the 
	 receiver to the <sdword> argument, hasAuthorityComponent.

		HRESULT __stdcall HasAuthorityComponent(
			[in]long HasAuthorityComponent);"

	<virtual stdcall: hresult 10 sdword>
	^self invalidCall: _failureCode!

put_TreatAsSecure: treatAsSecure
	"Private - Set the value of the 'TreatAsSecure' property of the object wrapped by the 
	 receiver to the <sdword> argument, treatAsSecure.

		HRESULT __stdcall TreatAsSecure(
			[in]long TreatAsSecure);"

	<virtual stdcall: hresult 6 sdword>
	^self invalidCall: _failureCode!

schemeName
	"Answer the <Utf16String> value of the 'SchemeName' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_SchemeName: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

SetAllowedOrigins: allowedOriginsCount allowedOrigins: allowedOrigins
	"Private - Invoke the SetAllowedOrigins() method of the COM object.

		HRESULT __stdcall SetAllowedOrigins(
			[in]unsigned int allowedOriginsCount,
			[in]LPWSTR* allowedOrigins);"

	<virtual stdcall: hresult 8 dword lpwstr*>
	^self invalidCall: _failureCode!

treatAsSecure
	"Answer the <Boolean> value of the 'TreatAsSecure' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_TreatAsSecure: buf.
	^buf asBoolean!

treatAsSecure: treatAsSecure
	"Set the 'TreatAsSecure' property of the receiver to the <boolean> value of the argument."

	self put_TreatAsSecure: treatAsSecure asParameter! !

!WebView2.ICoreWebView2CustomSchemeRegistration categoriesForMethods!
allowedOrigins!properties!public! !
allowedOrigins:!properties!public! !
get_HasAuthorityComponent:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
get_SchemeName:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
get_TreatAsSecure:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
GetAllowedOrigins:allowedOrigins:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
hasAuthorityComponent!properties!public! !
hasAuthorityComponent:!properties!public! !
printableProperties!constants!private! !
put_HasAuthorityComponent:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
put_TreatAsSecure:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
schemeName!properties!public! !
SetAllowedOrigins:allowedOrigins:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
treatAsSecure!properties!public! !
treatAsSecure:!properties!public! !
!

WebView2.ICoreWebView2CustomSchemeRegistration methodProtocol: #ICoreWebView2CustomSchemeRegistration attributes: #(#readOnly) selectors: #(#get_HasAuthorityComponent: #get_SchemeName: #get_TreatAsSecure: #GetAllowedOrigins:allowedOrigins: #put_HasAuthorityComponent: #put_TreatAsSecure: #SetAllowedOrigins:allowedOrigins:)!

!WebView2.ICoreWebView2CustomSchemeRegistration class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2CustomSchemeRegistration'
		ICoreWebView2CustomSchemeRegistration defineTemplate"

	self
		defineFunction: #get_SchemeName:
			argumentTypes: 'lpwstr*';
		defineFunction: #get_TreatAsSecure:
			argumentTypes: 'sdword*';
		defineFunction: #put_TreatAsSecure:
			argumentTypes: 'sdword';
		defineFunction: #GetAllowedOrigins:allowedOrigins:
			argumentTypes: 'dword* lpwstr**';
		defineFunction: #SetAllowedOrigins:allowedOrigins:
			argumentTypes: 'dword lpwstr*';
		defineFunction: #get_HasAuthorityComponent:
			argumentTypes: 'sdword*';
		defineFunction: #put_HasAuthorityComponent:
			argumentTypes: 'sdword'
! !

!WebView2.ICoreWebView2CustomSchemeRegistration class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

