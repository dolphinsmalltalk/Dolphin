"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2EnvironmentOptions2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2EnvironmentOptions2 guid: (IID fromString: '{ff85c98a-1ba7-4a6b-90c8-2b752c89e9e2}')!
ICoreWebView2EnvironmentOptions2 comment: '`ICoreWebView2EnvironmentOptions2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

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
!ICoreWebView2EnvironmentOptions2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2EnvironmentOptions2 methodsFor!

exclusiveUserDataFolderAccess
	"Answer the <Boolean> value of the 'ExclusiveUserDataFolderAccess' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_ExclusiveUserDataFolderAccess: answer.
	^answer value!

exclusiveUserDataFolderAccess: value
	"Set the 'ExclusiveUserDataFolderAccess' property of the receiver to the <sdword> value of the argument."

	self put_ExclusiveUserDataFolderAccess: value!

get_ExclusiveUserDataFolderAccess: value
	"Private - Get the value of the 'ExclusiveUserDataFolderAccess' property of the receiver.

		HRESULT __stdcall ExclusiveUserDataFolderAccess(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

put_ExclusiveUserDataFolderAccess: value
	"Private - Set the value of the 'ExclusiveUserDataFolderAccess' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall ExclusiveUserDataFolderAccess(
			[in]long value);"

	<virtual stdcall: hresult 5 sdword>
	^self invalidCall: _failureCode! !
!ICoreWebView2EnvironmentOptions2 categoriesForMethods!
exclusiveUserDataFolderAccess!properties!public! !
exclusiveUserDataFolderAccess:!**auto generated**!properties!public! !
get_ExclusiveUserDataFolderAccess:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions2!private! !
put_ExclusiveUserDataFolderAccess:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions2!private! !
!

ICoreWebView2EnvironmentOptions2 methodProtocol: #ICoreWebView2EnvironmentOptions2 attributes: #(#readOnly) selectors: #(#get_ExclusiveUserDataFolderAccess: #put_ExclusiveUserDataFolderAccess:)!

!ICoreWebView2EnvironmentOptions2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions2'
		ICoreWebView2EnvironmentOptions2 defineTemplate"

	self
		defineFunction: #get_ExclusiveUserDataFolderAccess:
			argumentTypes: 'sdword*';
		defineFunction: #put_ExclusiveUserDataFolderAccess:
			argumentTypes: 'sdword'
! !
!ICoreWebView2EnvironmentOptions2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

