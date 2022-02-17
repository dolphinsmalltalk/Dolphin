"Filed out from Dolphin Smallalk"!

IUnknown subclass: #ICoreWebView2Settings
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WebView2Constants'
	classInstanceVariableNames: ''!
ICoreWebView2Settings guid: (IID fromString: '{e562e4f0-d7fa-43ac-8d71-c05150499f00}')!
ICoreWebView2Settings comment: '`ICoreWebView2Settings` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(e562e4f0-d7fa-43ac-8d71-c05150499f00)
]
interface ICoreWebView2Settings : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall IsScriptEnabled(
		[out, retval]long* IsScriptEnabled);
	[id(0x60010000), propput]
	HRESULT __stdcall IsScriptEnabled(
		[in]long IsScriptEnabled);
	[id(0x60010002), propget]
	HRESULT __stdcall IsWebMessageEnabled(
		[out, retval]long* IsWebMessageEnabled);
	[id(0x60010002), propput]
	HRESULT __stdcall IsWebMessageEnabled(
		[in]long IsWebMessageEnabled);
	[id(0x60010004), propget]
	HRESULT __stdcall AreDefaultScriptDialogsEnabled(
		[out, retval]long* AreDefaultScriptDialogsEnabled);
	[id(0x60010004), propput]
	HRESULT __stdcall AreDefaultScriptDialogsEnabled(
		[in]long AreDefaultScriptDialogsEnabled);
	[id(0x60010006), propget]
	HRESULT __stdcall IsStatusBarEnabled(
		[out, retval]long* IsStatusBarEnabled);
	[id(0x60010006), propput]
	HRESULT __stdcall IsStatusBarEnabled(
		[in]long IsStatusBarEnabled);
	[id(0x60010008), propget]
	HRESULT __stdcall AreDevToolsEnabled(
		[out, retval]long* AreDevToolsEnabled);
	[id(0x60010008), propput]
	HRESULT __stdcall AreDevToolsEnabled(
		[in]long AreDevToolsEnabled);
	[id(0x6001000a), propget]
	HRESULT __stdcall AreDefaultContextMenusEnabled(
		[out, retval]long* enabled);
	[id(0x6001000a), propput]
	HRESULT __stdcall AreDefaultContextMenusEnabled(
		[in]long enabled);
	[id(0x6001000c), propget]
	HRESULT __stdcall AreHostObjectsAllowed(
		[out, retval]long* allowed);
	[id(0x6001000c), propput]
	HRESULT __stdcall AreHostObjectsAllowed(
		[in]long allowed);
	[id(0x6001000e), propget]
	HRESULT __stdcall IsZoomControlEnabled(
		[out, retval]long* enabled);
	[id(0x6001000e), propput]
	HRESULT __stdcall IsZoomControlEnabled(
		[in]long enabled);
	[id(0x60010010), propget]
	HRESULT __stdcall IsBuiltInErrorPageEnabled(
		[out, retval]long* enabled);
	[id(0x60010010), propput]
	HRESULT __stdcall IsBuiltInErrorPageEnabled(
		[in]long enabled);
};
```
'!
!ICoreWebView2Settings categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Settings methodsFor!

areDefaultContextMenusEnabled
	"Answer the <sdword> value of the 'AreDefaultContextMenusEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_AreDefaultContextMenusEnabled: answer.
	^answer asObject!

areDefaultContextMenusEnabled: enabled
	"Set the 'AreDefaultContextMenusEnabled' property of the receiver to the <sdword> value of the argument."

	self put_AreDefaultContextMenusEnabled: enabled!

areDefaultScriptDialogsEnabled
	"Answer the <sdword> value of the 'AreDefaultScriptDialogsEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_AreDefaultScriptDialogsEnabled: answer.
	^answer asObject!

areDefaultScriptDialogsEnabled: areDefaultScriptDialogsEnabled
	"Set the 'AreDefaultScriptDialogsEnabled' property of the receiver to the <sdword> value of the argument."

	self put_AreDefaultScriptDialogsEnabled: areDefaultScriptDialogsEnabled!

areDevToolsEnabled
	"Answer the <sdword> value of the 'AreDevToolsEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_AreDevToolsEnabled: answer.
	^answer asObject!

areDevToolsEnabled: areDevToolsEnabled
	"Set the 'AreDevToolsEnabled' property of the receiver to the <sdword> value of the argument."

	self put_AreDevToolsEnabled: areDevToolsEnabled!

areHostObjectsAllowed
	"Answer the <sdword> value of the 'AreHostObjectsAllowed' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_AreHostObjectsAllowed: answer.
	^answer asObject!

areHostObjectsAllowed: allowed
	"Set the 'AreHostObjectsAllowed' property of the receiver to the <sdword> value of the argument."

	self put_AreHostObjectsAllowed: allowed!

get_AreDefaultContextMenusEnabled: enabled
	"Private - Get the value of the 'AreDefaultContextMenusEnabled' property of the receiver.

		HRESULT __stdcall AreDefaultContextMenusEnabled(
			[out, retval]long* enabled);"

	<virtual stdcall: hresult 14 sdword*>
	^self invalidCall: _failureCode!

get_AreDefaultScriptDialogsEnabled: areDefaultScriptDialogsEnabled
	"Private - Get the value of the 'AreDefaultScriptDialogsEnabled' property of the receiver.

		HRESULT __stdcall AreDefaultScriptDialogsEnabled(
			[out, retval]long* AreDefaultScriptDialogsEnabled);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall: _failureCode!

get_AreDevToolsEnabled: areDevToolsEnabled
	"Private - Get the value of the 'AreDevToolsEnabled' property of the receiver.

		HRESULT __stdcall AreDevToolsEnabled(
			[out, retval]long* AreDevToolsEnabled);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall: _failureCode!

get_AreHostObjectsAllowed: allowed
	"Private - Get the value of the 'AreHostObjectsAllowed' property of the receiver.

		HRESULT __stdcall AreHostObjectsAllowed(
			[out, retval]long* allowed);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall: _failureCode!

get_IsBuiltInErrorPageEnabled: enabled
	"Private - Get the value of the 'IsBuiltInErrorPageEnabled' property of the receiver.

		HRESULT __stdcall IsBuiltInErrorPageEnabled(
			[out, retval]long* enabled);"

	<virtual stdcall: hresult 20 sdword*>
	^self invalidCall: _failureCode!

get_IsScriptEnabled: isScriptEnabled
	"Private - Get the value of the 'IsScriptEnabled' property of the receiver.

		HRESULT __stdcall IsScriptEnabled(
			[out, retval]long* IsScriptEnabled);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

get_IsStatusBarEnabled: isStatusBarEnabled
	"Private - Get the value of the 'IsStatusBarEnabled' property of the receiver.

		HRESULT __stdcall IsStatusBarEnabled(
			[out, retval]long* IsStatusBarEnabled);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_IsWebMessageEnabled: isWebMessageEnabled
	"Private - Get the value of the 'IsWebMessageEnabled' property of the receiver.

		HRESULT __stdcall IsWebMessageEnabled(
			[out, retval]long* IsWebMessageEnabled);"

	<virtual stdcall: hresult 6 sdword*>
	^self invalidCall: _failureCode!

get_IsZoomControlEnabled: enabled
	"Private - Get the value of the 'IsZoomControlEnabled' property of the receiver.

		HRESULT __stdcall IsZoomControlEnabled(
			[out, retval]long* enabled);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall: _failureCode!

isBuiltInErrorPageEnabled
	"Answer the <sdword> value of the 'IsBuiltInErrorPageEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsBuiltInErrorPageEnabled: answer.
	^answer asObject!

isBuiltInErrorPageEnabled: enabled
	"Set the 'IsBuiltInErrorPageEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsBuiltInErrorPageEnabled: enabled!

isScriptEnabled
	"Answer the <sdword> value of the 'IsScriptEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsScriptEnabled: answer.
	^answer asObject!

isScriptEnabled: isScriptEnabled
	"Set the 'IsScriptEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsScriptEnabled: isScriptEnabled!

isStatusBarEnabled
	"Answer the <sdword> value of the 'IsStatusBarEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsStatusBarEnabled: answer.
	^answer asObject!

isStatusBarEnabled: isStatusBarEnabled
	"Set the 'IsStatusBarEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsStatusBarEnabled: isStatusBarEnabled!

isWebMessageEnabled
	"Answer the <sdword> value of the 'IsWebMessageEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsWebMessageEnabled: answer.
	^answer asObject!

isWebMessageEnabled: isWebMessageEnabled
	"Set the 'IsWebMessageEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsWebMessageEnabled: isWebMessageEnabled!

isZoomControlEnabled
	"Answer the <sdword> value of the 'IsZoomControlEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsZoomControlEnabled: answer.
	^answer asObject!

isZoomControlEnabled: enabled
	"Set the 'IsZoomControlEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsZoomControlEnabled: enabled!

put_AreDefaultContextMenusEnabled: enabled
	"Private - Set the value of the 'AreDefaultContextMenusEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, enabled.

		HRESULT __stdcall AreDefaultContextMenusEnabled(
			[in]long enabled);"

	<virtual stdcall: hresult 15 sdword>
	^self invalidCall: _failureCode!

put_AreDefaultScriptDialogsEnabled: areDefaultScriptDialogsEnabled
	"Private - Set the value of the 'AreDefaultScriptDialogsEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, areDefaultScriptDialogsEnabled.

		HRESULT __stdcall AreDefaultScriptDialogsEnabled(
			[in]long AreDefaultScriptDialogsEnabled);"

	<virtual stdcall: hresult 9 sdword>
	^self invalidCall: _failureCode!

put_AreDevToolsEnabled: areDevToolsEnabled
	"Private - Set the value of the 'AreDevToolsEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, areDevToolsEnabled.

		HRESULT __stdcall AreDevToolsEnabled(
			[in]long AreDevToolsEnabled);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall: _failureCode!

put_AreHostObjectsAllowed: allowed
	"Private - Set the value of the 'AreHostObjectsAllowed' property of the object wrapped by the 
	 receiver to the <sdword> argument, allowed.

		HRESULT __stdcall AreHostObjectsAllowed(
			[in]long allowed);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall: _failureCode!

put_IsBuiltInErrorPageEnabled: enabled
	"Private - Set the value of the 'IsBuiltInErrorPageEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, enabled.

		HRESULT __stdcall IsBuiltInErrorPageEnabled(
			[in]long enabled);"

	<virtual stdcall: hresult 21 sdword>
	^self invalidCall: _failureCode!

put_IsScriptEnabled: isScriptEnabled
	"Private - Set the value of the 'IsScriptEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, isScriptEnabled.

		HRESULT __stdcall IsScriptEnabled(
			[in]long IsScriptEnabled);"

	<virtual stdcall: hresult 5 sdword>
	^self invalidCall: _failureCode!

put_IsStatusBarEnabled: isStatusBarEnabled
	"Private - Set the value of the 'IsStatusBarEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, isStatusBarEnabled.

		HRESULT __stdcall IsStatusBarEnabled(
			[in]long IsStatusBarEnabled);"

	<virtual stdcall: hresult 11 sdword>
	^self invalidCall: _failureCode!

put_IsWebMessageEnabled: isWebMessageEnabled
	"Private - Set the value of the 'IsWebMessageEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, isWebMessageEnabled.

		HRESULT __stdcall IsWebMessageEnabled(
			[in]long IsWebMessageEnabled);"

	<virtual stdcall: hresult 7 sdword>
	^self invalidCall: _failureCode!

put_IsZoomControlEnabled: enabled
	"Private - Set the value of the 'IsZoomControlEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, enabled.

		HRESULT __stdcall IsZoomControlEnabled(
			[in]long enabled);"

	<virtual stdcall: hresult 19 sdword>
	^self invalidCall: _failureCode! !
!ICoreWebView2Settings categoriesForMethods!
areDefaultContextMenusEnabled!**auto generated**!properties!public! !
areDefaultContextMenusEnabled:!**auto generated**!properties!public! !
areDefaultScriptDialogsEnabled!**auto generated**!properties!public! !
areDefaultScriptDialogsEnabled:!**auto generated**!properties!public! !
areDevToolsEnabled!**auto generated**!properties!public! !
areDevToolsEnabled:!**auto generated**!properties!public! !
areHostObjectsAllowed!**auto generated**!properties!public! !
areHostObjectsAllowed:!**auto generated**!properties!public! !
get_AreDefaultContextMenusEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_AreDefaultScriptDialogsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_AreDevToolsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_AreHostObjectsAllowed:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsBuiltInErrorPageEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsScriptEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsStatusBarEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsWebMessageEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsZoomControlEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
isBuiltInErrorPageEnabled!**auto generated**!properties!public! !
isBuiltInErrorPageEnabled:!**auto generated**!properties!public! !
isScriptEnabled!**auto generated**!properties!public! !
isScriptEnabled:!**auto generated**!properties!public! !
isStatusBarEnabled!**auto generated**!properties!public! !
isStatusBarEnabled:!**auto generated**!properties!public! !
isWebMessageEnabled!**auto generated**!properties!public! !
isWebMessageEnabled:!**auto generated**!properties!public! !
isZoomControlEnabled!**auto generated**!properties!public! !
isZoomControlEnabled:!**auto generated**!properties!public! !
put_AreDefaultContextMenusEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_AreDefaultScriptDialogsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_AreDevToolsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_AreHostObjectsAllowed:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsBuiltInErrorPageEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsScriptEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsStatusBarEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsWebMessageEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsZoomControlEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
!

!ICoreWebView2Settings class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings'
		ICoreWebView2Settings defineTemplate"

	self
		defineFunction: #get_IsScriptEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsScriptEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_IsWebMessageEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsWebMessageEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_AreDefaultScriptDialogsEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_AreDefaultScriptDialogsEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_IsStatusBarEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsStatusBarEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_AreDevToolsEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_AreDevToolsEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_AreDefaultContextMenusEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_AreDefaultContextMenusEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_AreHostObjectsAllowed:
			argumentTypes: 'sdword*';
		defineFunction: #put_AreHostObjectsAllowed:
			argumentTypes: 'sdword';
		defineFunction: #get_IsZoomControlEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsZoomControlEnabled:
			argumentTypes: 'sdword';
		defineFunction: #get_IsBuiltInErrorPageEnabled:
			argumentTypes: 'sdword*';
		defineFunction: #put_IsBuiltInErrorPageEnabled:
			argumentTypes: 'sdword'
! !
!ICoreWebView2Settings class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

