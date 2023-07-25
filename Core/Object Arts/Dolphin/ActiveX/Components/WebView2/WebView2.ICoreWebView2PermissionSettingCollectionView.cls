"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Sequence
	subclass: #'WebView2.ICoreWebView2PermissionSettingCollectionView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2PermissionSettingCollectionView guid: (OS.COM.IID fromString: '{f5596f62-3de5-47b1-91e8-a4104b596b96}')!
WebView2.ICoreWebView2PermissionSettingCollectionView comment: '`ICoreWebView2PermissionSettingCollectionView` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PermissionSettingCollectionView'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(f5596f62-3de5-47b1-91e8-a4104b596b96)
]
interface ICoreWebView2PermissionSettingCollectionView : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetValueAtIndex(
		[in]unsigned int index,
		[out, retval]ICoreWebView2PermissionSetting** permissionSetting);
	[id(0x60010001), propget]
	HRESULT __stdcall Count(
		[out, retval]unsigned int* value);
};
```
'!
!WebView2.ICoreWebView2PermissionSettingCollectionView categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2PermissionSettingCollectionView methodsFor!

elementClass
	^ICoreWebView2PermissionSetting!

get_Count: value
	"Private - Get the value of the 'Count' property of the receiver.

		HRESULT __stdcall Count(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 5 uint32*>
	^self invalidCall: _failureCode!

GetValueAtIndex: index value: permissionSetting
	"Private - Invoke the GetValueAtIndex() method of the COM object.

		HRESULT __stdcall GetValueAtIndex(
			[in]unsigned int index,
			[out, retval]ICoreWebView2PermissionSetting** permissionSetting);"

	<virtual stdcall: hresult 4 uint32 ICoreWebView2PermissionSetting**>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2PermissionSettingCollectionView categoriesForMethods!
elementClass!constants!private! !
get_Count:!**auto generated**!COM Interfaces-ICoreWebView2PermissionSettingCollectionView!private! !
GetValueAtIndex:value:!**auto generated**!COM Interfaces-ICoreWebView2PermissionSettingCollectionView!private! !
!

!WebView2.ICoreWebView2PermissionSettingCollectionView class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PermissionSettingCollectionView'
		ICoreWebView2PermissionSettingCollectionView defineTemplate"

	self
		defineFunction: #GetValueAtIndex:value:
			argumentTypes: 'uint32 ICoreWebView2PermissionSetting**';
		defineFunction: #get_Count:
			argumentTypes: 'uint32*'
! !
!WebView2.ICoreWebView2PermissionSettingCollectionView class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

