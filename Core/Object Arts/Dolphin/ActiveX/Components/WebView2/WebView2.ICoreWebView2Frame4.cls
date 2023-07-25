"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Frame3
	subclass: #'WebView2.ICoreWebView2Frame4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Frame4 guid: (OS.COM.IID fromString: '{188782dc-92aa-4732-ab3c-fcc59f6f68b9}')!
WebView2.ICoreWebView2Frame4 comment: '`ICoreWebView2Frame4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Frame4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(188782dc-92aa-4732-ab3c-fcc59f6f68b9)
]
interface ICoreWebView2Frame4 : ICoreWebView2Frame3
 {
	[id(0x60040000)]
	HRESULT __stdcall PostSharedBufferToScript(
		[in]ICoreWebView2SharedBuffer* sharedBuffer,
		[in]COREWEBVIEW2_SHARED_BUFFER_ACCESS access,
		[in]LPWSTR additionalDataAsJson);
};
```
'!
!WebView2.ICoreWebView2Frame4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Frame4 methodsFor!

PostSharedBufferToScript: sharedBuffer access: access additionalDataAsJson: additionalDataAsJson
	"Invoke the PostSharedBufferToScript() method of the COM object.

		HRESULT __stdcall PostSharedBufferToScript(
			[in]ICoreWebView2SharedBuffer* sharedBuffer,
			[in]COREWEBVIEW2_SHARED_BUFFER_ACCESS access,
			[in]LPWSTR additionalDataAsJson);"

	<virtual stdcall: hresult 27 ICoreWebView2SharedBuffer* int32 lpwstr>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Frame4 categoriesForMethods!
PostSharedBufferToScript:access:additionalDataAsJson:!**auto generated**!COM Interfaces-ICoreWebView2Frame4!public! !
!

!WebView2.ICoreWebView2Frame4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Frame4'
		ICoreWebView2Frame4 defineTemplate"

	self
		defineFunction: #PostSharedBufferToScript:access:additionalDataAsJson:
			argumentTypes: 'ICoreWebView2SharedBuffer* int32 lpwstr'
! !
!WebView2.ICoreWebView2Frame4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

