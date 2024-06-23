"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2_16
	subclass: #'WebView2.ICoreWebView2_17'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2_17 guid: (OS.COM.IID fromString: '{702e75d4-fd44-434d-9d70-1a68a6b1192a}')!

WebView2.ICoreWebView2_17 isEgressOnly: true!

WebView2.ICoreWebView2_17 comment: '`ICoreWebView2_17` is a wrapper class for the COM interface ''WebView2.ICoreWebView2_17'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(702e75d4-fd44-434d-9d70-1a68a6b1192a)
]
interface ICoreWebView2_17 : ICoreWebView2_16
 {
	[id(0x60110000)]
	HRESULT __stdcall PostSharedBufferToScript(
		[in]ICoreWebView2SharedBuffer* sharedBuffer,
		[in]COREWEBVIEW2_SHARED_BUFFER_ACCESS access,
		[in]LPWSTR additionalDataAsJson);
};
```
'!

!WebView2.ICoreWebView2_17 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2_17 methodsFor!

PostSharedBufferToScript: sharedBuffer access: access additionalDataAsJson: additionalDataAsJson
	"Invoke the PostSharedBufferToScript() method of the COM object.

		HRESULT __stdcall PostSharedBufferToScript(
			[in]ICoreWebView2SharedBuffer* sharedBuffer,
			[in]COREWEBVIEW2_SHARED_BUFFER_ACCESS access,
			[in]LPWSTR additionalDataAsJson);"

	<virtual stdcall: hresult 117 ICoreWebView2SharedBuffer* int32 lpwstr>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2_17 categoriesForMethods!
PostSharedBufferToScript:access:additionalDataAsJson:!**auto generated**!COM Interfaces-ICoreWebView2_17!public! !
!

!WebView2.ICoreWebView2_17 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2_17'
		ICoreWebView2_17 defineTemplate"

	self
		defineFunction: #PostSharedBufferToScript:access:additionalDataAsJson:
			argumentTypes: 'ICoreWebView2SharedBuffer* int32 lpwstr'
! !

!WebView2.ICoreWebView2_17 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

