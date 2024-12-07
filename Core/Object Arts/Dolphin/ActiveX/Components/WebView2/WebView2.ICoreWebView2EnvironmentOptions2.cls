"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EnvironmentOptions2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2EnvironmentOptions2 guid: (OS.COM.IID fromString: '{ff85c98a-1ba7-4a6b-90c8-2b752c89e9e2}')!

WebView2.ICoreWebView2EnvironmentOptions2 comment: '`ICoreWebView2EnvironmentOptions2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The IDL contains this comment, which includes an explanation of why ICoreWebView2EnviromentOptions2 is not a sub-interface of ICoreWebView2EnvironmentOptions:

/// Additional options used to create WebView2 Environment.  A default implementation is
/// provided in `WebView2EnvironmentOptions.h`.
///
/// \snippet AppWindow.cpp CreateCoreWebView2EnvironmentWithOptions

// Note: ICoreWebView2EnvironmentOptions* interfaces derive from IUnknown to make moving
// the API from experimental to public smoothier. These interfaces are mostly internal to
// WebView''s own code. Normal apps just use the objects we provided and never interact
// with the interfaces. Advanced apps might implement their own options object. In that
// case, it is also easier for them to implement the interface if it is derived from IUnknown.

IDL definition follows:
```
[
	object, 
	uuid(ff85c98a-1ba7-4a6b-90c8-2b752c89e9e2)
]
interface ICoreWebView2EnvironmentOptions2 : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ExclusiveUserDataFolderAccess(
		[out, retval]long* value);
	[id(0x60010000), propput]
	HRESULT __stdcall ExclusiveUserDataFolderAccess(
		[in]long value);
};
```
'!

!WebView2.ICoreWebView2EnvironmentOptions2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2EnvironmentOptions2 methodsFor!

exclusiveUserDataFolderAccess
	"Answer the <Boolean> value of the 'ExclusiveUserDataFolderAccess' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_ExclusiveUserDataFolderAccess: buf.
	^buf asBoolean!

exclusiveUserDataFolderAccess: value
	"Set the 'ExclusiveUserDataFolderAccess' property of the receiver to the <boolean> value of the argument."

	self put_ExclusiveUserDataFolderAccess: value asParameter!

get_ExclusiveUserDataFolderAccess: value
	"Private - Get the value of the 'ExclusiveUserDataFolderAccess' property of the receiver.

		HRESULT __stdcall ExclusiveUserDataFolderAccess(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

put_ExclusiveUserDataFolderAccess: value
	"Private - Set the value of the 'ExclusiveUserDataFolderAccess' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall ExclusiveUserDataFolderAccess(
			[in]long value);"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2EnvironmentOptions2 categoriesForMethods!
exclusiveUserDataFolderAccess!properties!public! !
exclusiveUserDataFolderAccess:!properties!public! !
get_ExclusiveUserDataFolderAccess:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions2!private! !
put_ExclusiveUserDataFolderAccess:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions2!private! !
!

WebView2.ICoreWebView2EnvironmentOptions2 methodProtocol: #ICoreWebView2EnvironmentOptions2 attributes: #(#readOnly) selectors: #(#get_ExclusiveUserDataFolderAccess: #put_ExclusiveUserDataFolderAccess:)!

!WebView2.ICoreWebView2EnvironmentOptions2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions2'
		ICoreWebView2EnvironmentOptions2 defineTemplate"

	self
		defineFunction: #get_ExclusiveUserDataFolderAccess:
			argumentTypes: 'sdword*';
		defineFunction: #put_ExclusiveUserDataFolderAccess:
			argumentTypes: 'sdword'
! !

!WebView2.ICoreWebView2EnvironmentOptions2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

