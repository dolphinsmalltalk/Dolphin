"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Profile3
	subclass: #'WebView2.ICoreWebView2Profile4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Profile4 guid: (OS.COM.IID fromString: '{8f4ae680-192e-4ec8-833a-21cfadaef628}')!
WebView2.ICoreWebView2Profile4 comment: '`ICoreWebView2Profile4` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Profile4'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(8f4ae680-192e-4ec8-833a-21cfadaef628)
]
interface ICoreWebView2Profile4 : ICoreWebView2Profile3
 {
	[id(0x60040000)]
	HRESULT __stdcall SetPermissionState(
		[in]COREWEBVIEW2_PERMISSION_KIND PermissionKind,
		[in]LPWSTR origin,
		[in]COREWEBVIEW2_PERMISSION_STATE State,
		[in]ICoreWebView2SetPermissionStateCompletedHandler* completedHandler);
	[id(0x60040001)]
	HRESULT __stdcall GetNonDefaultPermissionSettings(
		[in]ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler* completedHandler);
};
```
'!
!WebView2.ICoreWebView2Profile4 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Profile4 methodsFor!

GetNonDefaultPermissionSettings: completedHandler
	"Invoke the GetNonDefaultPermissionSettings() method of the COM object.

		HRESULT __stdcall GetNonDefaultPermissionSettings(
			[in]ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler* completedHandler);"

	<virtual stdcall: hresult 17 ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler*>
	^self invalidCall: _failureCode!

SetPermissionState: permissionKind origin: origin state: state completedHandler: completedHandler
	"Invoke the SetPermissionState() method of the COM object.

		HRESULT __stdcall SetPermissionState(
			[in]COREWEBVIEW2_PERMISSION_KIND PermissionKind,
			[in]LPWSTR origin,
			[in]COREWEBVIEW2_PERMISSION_STATE State,
			[in]ICoreWebView2SetPermissionStateCompletedHandler* completedHandler);"

	<virtual stdcall: hresult 16 int32 lpwstr int32 ICoreWebView2SetPermissionStateCompletedHandler*>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Profile4 categoriesForMethods!
GetNonDefaultPermissionSettings:!**auto generated**!COM Interfaces-ICoreWebView2Profile4!public! !
SetPermissionState:origin:state:completedHandler:!**auto generated**!COM Interfaces-ICoreWebView2Profile4!public! !
!

!WebView2.ICoreWebView2Profile4 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Profile4'
		ICoreWebView2Profile4 defineTemplate"

	self
		defineFunction: #SetPermissionState:origin:state:completedHandler:
			argumentTypes: 'int32 lpwstr int32 ICoreWebView2SetPermissionStateCompletedHandler*';
		defineFunction: #GetNonDefaultPermissionSettings:
			argumentTypes: 'ICoreWebView2GetNonDefaultPermissionSettingsCompletedHandler*'
! !
!WebView2.ICoreWebView2Profile4 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

