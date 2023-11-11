"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2CompletedHandler
	subclass: #'WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler guid: (OS.COM.IID fromString: '{38274481-a15c-4563-94cf-990edc9aeb95}')!
WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler comment: '`ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler` is a wrapper class for the COM interface ''WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(38274481-a15c-4563-94cf-990edc9aeb95)
]
interface ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Invoke(
		[in]HRESULT errorCode,
		[in]ICoreWebView2PermissionSettingCollectionView* collectionView);
};
```
'!
!WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler methodsFor!

Invoke: invoke arg: arg
	"Callout for the ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler::Invoke() interface function.
	N.B. This method has been automatically generated from 
	the vtable defined in ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler>>defineFunctions. DO NOT MODIFY!!"

	<virtual stdcall: hresult 4 hresult WebView2.ICoreWebView2PermissionSettingCollectionView*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler categoriesForMethods!
Invoke:arg:!COM Interfaces-ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler!public! !
!

!WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler'
		ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler compileFunctions
	"

	self
		defineFunction: #Invoke:arg:
			argumentTypes: 'hresult ICoreWebView2PermissionSettingCollectionView*'
! !
!WebView2.ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

