"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_21
	subclass: #'WebView2.ICoreWebView2_22'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_22 guid: (OS.COM.IID fromString: '{db75dfc7-a857-4632-a398-6969dde26c0a}')!

WebView2.ICoreWebView2_22 comment: '`ICoreWebView2_22` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_22'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(db75dfc7-a857-4632-a398-6969dde26c0a)
]
interface ICoreWebView2_22 : ICoreWebView2_21
 {
	[id(0x60160000)]
	HRESULT __stdcall AddWebResourceRequestedFilterWithRequestSourceKinds(
		[in]LPWSTR uri,
		[in]COREWEBVIEW2_WEB_RESOURCE_CONTEXT ResourceContext,
		[in]COREWEBVIEW2_WEB_RESOURCE_REQUEST_SOURCE_KINDS requestSourceKinds);
	[id(0x60160001)]
	HRESULT __stdcall RemoveWebResourceRequestedFilterWithRequestSourceKinds(
		[in]LPWSTR uri,
		[in]COREWEBVIEW2_WEB_RESOURCE_CONTEXT ResourceContext,
		[in]COREWEBVIEW2_WEB_RESOURCE_REQUEST_SOURCE_KINDS requestSourceKinds);
};
```
'!

!WebView2.ICoreWebView2_22 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_22 methodsFor!

AddWebResourceRequestedFilterWithRequestSourceKinds: uri resourceContext: resourceContext requestSourceKinds: requestSourceKinds
	"Private - Invoke the AddWebResourceRequestedFilterWithRequestSourceKinds() method of the COM object.

		HRESULT __stdcall AddWebResourceRequestedFilterWithRequestSourceKinds(
			[in]LPWSTR uri,
			[in]COREWEBVIEW2_WEB_RESOURCE_CONTEXT ResourceContext,
			[in]COREWEBVIEW2_WEB_RESOURCE_REQUEST_SOURCE_KINDS requestSourceKinds);"

	<virtual stdcall: hresult 124 lpwstr int32 int32>
	^self invalidCall: _failureCode!

RemoveWebResourceRequestedFilterWithRequestSourceKinds: uri resourceContext: resourceContext requestSourceKinds: requestSourceKinds
	"Private - Invoke the RemoveWebResourceRequestedFilterWithRequestSourceKinds() method of the COM object.

		HRESULT __stdcall RemoveWebResourceRequestedFilterWithRequestSourceKinds(
			[in]LPWSTR uri,
			[in]COREWEBVIEW2_WEB_RESOURCE_CONTEXT ResourceContext,
			[in]COREWEBVIEW2_WEB_RESOURCE_REQUEST_SOURCE_KINDS requestSourceKinds);"

	<virtual stdcall: hresult 125 lpwstr int32 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_22 categoriesForMethods!
AddWebResourceRequestedFilterWithRequestSourceKinds:resourceContext:requestSourceKinds:!**auto generated**!COM Interfaces-ICoreWebView2_22!private! !
RemoveWebResourceRequestedFilterWithRequestSourceKinds:resourceContext:requestSourceKinds:!**auto generated**!COM Interfaces-ICoreWebView2_22!private! !
!

!WebView2.ICoreWebView2_22 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_22'
		ICoreWebView2_22 defineTemplate"

	self
		defineFunction: #AddWebResourceRequestedFilterWithRequestSourceKinds:resourceContext:requestSourceKinds:
			argumentTypes: 'lpwstr int32 int32';
		defineFunction: #RemoveWebResourceRequestedFilterWithRequestSourceKinds:resourceContext:requestSourceKinds:
			argumentTypes: 'lpwstr int32 int32'
! !

!WebView2.ICoreWebView2_22 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

