"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2PermissionRequestedEventArgs2
	subclass: #'WebView2.ICoreWebView2PermissionRequestedEventArgs3'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2PermissionRequestedEventArgs3 guid: (OS.COM.IID fromString: '{e61670bc-3dce-4177-86d2-c629ae3cb6ac}')!
WebView2.ICoreWebView2PermissionRequestedEventArgs3 comment: '`ICoreWebView2PermissionRequestedEventArgs3` is a wrapper class for the COM interface ''WebView2.ICoreWebView2PermissionRequestedEventArgs3'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e61670bc-3dce-4177-86d2-c629ae3cb6ac)
]
interface ICoreWebView2PermissionRequestedEventArgs3 : ICoreWebView2PermissionRequestedEventArgs2
 {
	[id(0x60030000), propget]
	HRESULT __stdcall SavesInProfile(
		[out, retval]long* value);
	[id(0x60030000), propput]
	HRESULT __stdcall SavesInProfile(
		[in]long value);
};
```
'!
!WebView2.ICoreWebView2PermissionRequestedEventArgs3 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs3 methodsFor!

get_SavesInProfile: value
	"Private - Get the value of the 'SavesInProfile' property of the receiver.

		HRESULT __stdcall SavesInProfile(
			[out, retval]long* value);"

	<virtual stdcall: hresult 12 int32*>
	^self invalidCall: _failureCode!

put_SavesInProfile: value
	"Private - Set the value of the 'SavesInProfile' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall SavesInProfile(
			[in]long value);"

	<virtual stdcall: hresult 13 int32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs3 categoriesForMethods!
get_SavesInProfile:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs3!private! !
put_SavesInProfile:!**auto generated**!COM Interfaces-ICoreWebView2PermissionRequestedEventArgs3!private! !
!

!WebView2.ICoreWebView2PermissionRequestedEventArgs3 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2PermissionRequestedEventArgs3'
		ICoreWebView2PermissionRequestedEventArgs3 defineTemplate"

	self
		defineFunction: #get_SavesInProfile:
			argumentTypes: 'int32*';
		defineFunction: #put_SavesInProfile:
			argumentTypes: 'int32'
! !
!WebView2.ICoreWebView2PermissionRequestedEventArgs3 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

