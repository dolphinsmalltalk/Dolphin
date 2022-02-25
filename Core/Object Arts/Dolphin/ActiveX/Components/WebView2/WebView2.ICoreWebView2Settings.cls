"Filed out from Dolphin Smalltalk"!

ICoreWebView2Interface subclass: #ICoreWebView2Settings
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2Settings guid: (OS.COM.IID fromString: '{e562e4f0-d7fa-43ac-8d71-c05150499f00}')!
ICoreWebView2Settings comment: '`ICoreWebView2Settings` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

At the time of writing there are five later versions of this interface. In order to reduce the burden of degrading gracefully to older versions, default implementations of the additional methods and properties are added.

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

areBrowserAcceleratorKeysEnabled
	"Answer the <Boolean> value of the 'AreBrowserAcceleratorKeysEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_AreBrowserAcceleratorKeysEnabled: answer.
	^answer asObject!

areBrowserAcceleratorKeysEnabled: areBrowserAcceleratorKeysEnabled
	"Set the 'AreBrowserAcceleratorKeysEnabled' property of the receiver to the <sdword> value of the argument."

	self put_AreBrowserAcceleratorKeysEnabled: areBrowserAcceleratorKeysEnabled asParameter!

areDefaultContextMenusEnabled
	"Answer the <sdword> value of the 'AreDefaultContextMenusEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_AreDefaultContextMenusEnabled: answer.
	^answer asObject!

areDefaultContextMenusEnabled: enabled
	"Set the 'AreDefaultContextMenusEnabled' property of the receiver to the <sdword> value of the argument."

	self put_AreDefaultContextMenusEnabled: enabled asParameter!

areDefaultScriptDialogsEnabled
	"Answer the <Boolean> value of the 'AreDefaultScriptDialogsEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_AreDefaultScriptDialogsEnabled: answer.
	^answer asObject!

areDefaultScriptDialogsEnabled: areDefaultScriptDialogsEnabled
	"Set the 'AreDefaultScriptDialogsEnabled' property of the receiver to the <sdword> value of the argument."

	self put_AreDefaultScriptDialogsEnabled: areDefaultScriptDialogsEnabled asParameter!

areDevToolsEnabled
	"Answer the <Boolean> value of the 'AreDevToolsEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_AreDevToolsEnabled: answer.
	^answer asObject!

areDevToolsEnabled: areDevToolsEnabled
	"Set the 'AreDevToolsEnabled' property of the receiver to the <sdword> value of the argument."

	self put_AreDevToolsEnabled: areDevToolsEnabled asParameter!

areHostObjectsAllowed
	"Answer the <Boolean> value of the 'AreHostObjectsAllowed' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_AreHostObjectsAllowed: answer.
	^answer asObject!

areHostObjectsAllowed: allowed
	"Set the 'AreHostObjectsAllowed' property of the receiver to the <sdword> value of the argument."

	self put_AreHostObjectsAllowed: allowed asParameter!

get_AreBrowserAcceleratorKeysEnabled: areBrowserAcceleratorKeysEnabled
	"Private - Get the value of the 'AreBrowserAcceleratorKeysEnabled' property of the receiver.

		HRESULT __stdcall AreBrowserAcceleratorKeysEnabled(
			[out, retval]long* AreBrowserAcceleratorKeysEnabled);"

	areBrowserAcceleratorKeysEnabled value: 1.
	^S_OK!

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

get_IsGeneralAutofillEnabled: value
	"Private - Get the value of the 'IsGeneralAutofillEnabled' property of the receiver.

		HRESULT __stdcall IsGeneralAutofillEnabled(
			[out, retval]long* value);"

	value value: 1.
	^S_OK!

get_IsPasswordAutosaveEnabled: value
	"Private - Get the value of the 'IsPasswordAutosaveEnabled' property of the receiver.

		HRESULT __stdcall IsPasswordAutosaveEnabled(
			[out, retval]long* value);"

	value value: 1.
	^S_OK!

get_IsPinchZoomEnabled: enabled
	"Private - Get the value of the 'IsPinchZoomEnabled' property of the receiver.

		HRESULT __stdcall IsPinchZoomEnabled(
			[out, retval]long* enabled);"

	enabled value: 0.
	^S_OK!

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

get_IsSwipeNavigationEnabled: enabled
	"Private - Get the value of the 'IsSwipeNavigationEnabled' property of the receiver.

		HRESULT __stdcall IsSwipeNavigationEnabled(
			[out, retval]long* enabled);"

	enabled value: 0.
	^S_OK!

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

get_UserAgent: userAgent
	"Private - Get the value of the 'UserAgent' property of the receiver.

		HRESULT __stdcall UserAgent(
			[out, retval]LPWSTR* UserAgent);"

	| taskMem |
	taskMem := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36 Edg/90.0.818.46'
				asUtf16String copyToCOMTaskMemory.
	userAgent value: taskMem.
	taskMem beUnfinalizable.
	^S_OK!

isBuiltInErrorPageEnabled
	"Answer the <Boolean> value of the 'IsBuiltInErrorPageEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsBuiltInErrorPageEnabled: answer.
	^answer asObject!

isBuiltInErrorPageEnabled: enabled
	"Set the 'IsBuiltInErrorPageEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsBuiltInErrorPageEnabled: enabled asParameter!

isGeneralAutofillEnabled
	"Answer the <Boolean> value of the 'IsGeneralAutofillEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsGeneralAutofillEnabled: answer.
	^answer asObject!

isGeneralAutofillEnabled: value
	"Set the 'IsGeneralAutofillEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsGeneralAutofillEnabled: value asParameter!

isPasswordAutosaveEnabled
	"Answer the <Boolean> value of the 'IsPasswordAutosaveEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsPasswordAutosaveEnabled: answer.
	^answer asObject!

isPasswordAutosaveEnabled: value
	"Set the 'IsPasswordAutosaveEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsPasswordAutosaveEnabled: value asParameter!

isPinchZoomEnabled
	"Answer the <Boolean> value of the 'IsPinchZoomEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsPinchZoomEnabled: answer.
	^answer asObject!

isPinchZoomEnabled: enabled
	"Set the 'IsPinchZoomEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsPinchZoomEnabled: enabled asParameter!

isScriptEnabled
	"Answer the <Boolean> value of the 'IsScriptEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsScriptEnabled: answer.
	^answer asObject!

isScriptEnabled: isScriptEnabled
	"Set the 'IsScriptEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsScriptEnabled: isScriptEnabled asParameter!

isStatusBarEnabled
	"Answer the <Boolean> value of the 'IsStatusBarEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsStatusBarEnabled: answer.
	^answer asObject!

isStatusBarEnabled: isStatusBarEnabled
	"Set the 'IsStatusBarEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsStatusBarEnabled: isStatusBarEnabled asParameter!

isSwipeNavigationEnabled
	"Answer the <sdword> value of the 'IsSwipeNavigationEnabled' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_IsSwipeNavigationEnabled: answer.
	^answer asObject!

isSwipeNavigationEnabled: enabled
	"Set the 'IsSwipeNavigationEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsSwipeNavigationEnabled: enabled!

isWebMessageEnabled
	"Answer the <Boolean> value of the 'IsWebMessageEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsWebMessageEnabled: answer.
	^answer asObject!

isWebMessageEnabled: isWebMessageEnabled
	"Set the 'IsWebMessageEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsWebMessageEnabled: isWebMessageEnabled asParameter!

isZoomControlEnabled
	"Answer the <Boolean> value of the 'IsZoomControlEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsZoomControlEnabled: answer.
	^answer asObject!

isZoomControlEnabled: enabled
	"Set the 'IsZoomControlEnabled' property of the receiver to the <sdword> value of the argument."

	self put_IsZoomControlEnabled: enabled asParameter!

printableProperties
	^#(#areDefaultContextMenusEnabled #areDefaultScriptDialogsEnabled #areDevToolsEnabled #areHostObjectsAllowed #isBuiltInErrorPageEnabled #isScriptEnabled #isStatusBarEnabled #isWebMessageEnabled #isZoomControlEnabled #areBrowserAcceleratorKeysEnabled #isGeneralAutofillEnabled #isPasswordAutosaveEnabled #isPinchZoomEnabled)!

put_AreBrowserAcceleratorKeysEnabled: areBrowserAcceleratorKeysEnabled
	"Private - Set the value of the 'AreBrowserAcceleratorKeysEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, areBrowserAcceleratorKeysEnabled.

		HRESULT __stdcall AreBrowserAcceleratorKeysEnabled(
			[in]long AreBrowserAcceleratorKeysEnabled);"

	^E_NOTIMPL!

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

put_IsGeneralAutofillEnabled: value
	"Private - Set the value of the 'IsGeneralAutofillEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsGeneralAutofillEnabled(
			[in]long value);"

	^E_NOTIMPL!

put_IsPasswordAutosaveEnabled: value
	"Private - Set the value of the 'IsPasswordAutosaveEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsPasswordAutosaveEnabled(
			[in]long value);"

	^E_NOTIMPL!

put_IsPinchZoomEnabled: enabled
	"Private - Set the value of the 'IsPinchZoomEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, enabled.

		HRESULT __stdcall IsPinchZoomEnabled(
			[in]long enabled);"

	^E_NOTIMPL!

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

put_IsSwipeNavigationEnabled: enabled
	"Private - Set the value of the 'IsSwipeNavigationEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, enabled.

		HRESULT __stdcall IsSwipeNavigationEnabled(
			[in]long enabled);"

	^E_NOTIMPL!

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
	^self invalidCall: _failureCode!

put_UserAgent: userAgent
	"Private - Set the value of the 'UserAgent' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, userAgent.

		HRESULT __stdcall UserAgent(
			[in]LPWSTR UserAgent);"

	^E_NOTIMPL!

userAgent
	"Answer the <lpwstr> value of the 'UserAgent' property of the receiver."

	| ptr answer |
	ptr := COMTaskMemory new.
	self get_UserAgent: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

userAgent: userAgent
	"Set the 'UserAgent' property of the receiver to the <lpwstr> value of the argument."

	self put_UserAgent: userAgent asUtf16String! !
!ICoreWebView2Settings categoriesForMethods!
areBrowserAcceleratorKeysEnabled!properties!public! !
areBrowserAcceleratorKeysEnabled:!properties!public! !
areDefaultContextMenusEnabled!properties!public! !
areDefaultContextMenusEnabled:!properties!public! !
areDefaultScriptDialogsEnabled!properties!public! !
areDefaultScriptDialogsEnabled:!properties!public! !
areDevToolsEnabled!properties!public! !
areDevToolsEnabled:!properties!public! !
areHostObjectsAllowed!properties!public! !
areHostObjectsAllowed:!properties!public! !
get_AreBrowserAcceleratorKeysEnabled:!COM Interfaces-ICoreWebView2Settings3!private! !
get_AreDefaultContextMenusEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_AreDefaultScriptDialogsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_AreDevToolsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_AreHostObjectsAllowed:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsBuiltInErrorPageEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsGeneralAutofillEnabled:!COM Interfaces-ICoreWebView2Settings4!private! !
get_IsPasswordAutosaveEnabled:!COM Interfaces-ICoreWebView2Settings4!private! !
get_IsPinchZoomEnabled:!COM Interfaces-ICoreWebView2Settings5!private! !
get_IsScriptEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsStatusBarEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsSwipeNavigationEnabled:!COM Interfaces-ICoreWebView2Settings6!private! !
get_IsWebMessageEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_IsZoomControlEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
get_UserAgent:!COM Interfaces-ICoreWebView2Settings2!private! !
isBuiltInErrorPageEnabled!properties!public! !
isBuiltInErrorPageEnabled:!properties!public! !
isGeneralAutofillEnabled!properties!public! !
isGeneralAutofillEnabled:!properties!public! !
isPasswordAutosaveEnabled!properties!public! !
isPasswordAutosaveEnabled:!properties!public! !
isPinchZoomEnabled!properties!public! !
isPinchZoomEnabled:!properties!public! !
isScriptEnabled!properties!public! !
isScriptEnabled:!properties!public! !
isStatusBarEnabled!properties!public! !
isStatusBarEnabled:!properties!public! !
isSwipeNavigationEnabled!properties!public! !
isSwipeNavigationEnabled:!properties!public! !
isWebMessageEnabled!properties!public! !
isWebMessageEnabled:!properties!public! !
isZoomControlEnabled!properties!public! !
isZoomControlEnabled:!properties!public! !
printableProperties!development!printing!private! !
put_AreBrowserAcceleratorKeysEnabled:!COM Interfaces-ICoreWebView2Settings3!private! !
put_AreDefaultContextMenusEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_AreDefaultScriptDialogsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_AreDevToolsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_AreHostObjectsAllowed:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsBuiltInErrorPageEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsGeneralAutofillEnabled:!COM Interfaces-ICoreWebView2Settings4!private! !
put_IsPasswordAutosaveEnabled:!COM Interfaces-ICoreWebView2Settings4!private! !
put_IsPinchZoomEnabled:!COM Interfaces-ICoreWebView2Settings5!private! !
put_IsScriptEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsStatusBarEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsSwipeNavigationEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings6!private! !
put_IsWebMessageEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_IsZoomControlEnabled:!**auto generated**!COM Interfaces-ICoreWebView2Settings!private! !
put_UserAgent:!COM Interfaces-ICoreWebView2Settings2!private! !
userAgent!**auto generated**!properties!public! !
userAgent:!**auto generated**!properties!public! !
!

ICoreWebView2Settings methodProtocol: #ICoreWebView2Settings attributes: #(#readOnly) selectors: #(#get_AreDefaultContextMenusEnabled: #get_AreDefaultScriptDialogsEnabled: #get_AreDevToolsEnabled: #get_AreHostObjectsAllowed: #get_IsBuiltInErrorPageEnabled: #get_IsScriptEnabled: #get_IsStatusBarEnabled: #get_IsWebMessageEnabled: #get_IsZoomControlEnabled: #put_AreDefaultContextMenusEnabled: #put_AreDefaultScriptDialogsEnabled: #put_AreDevToolsEnabled: #put_AreHostObjectsAllowed: #put_IsBuiltInErrorPageEnabled: #put_IsScriptEnabled: #put_IsStatusBarEnabled: #put_IsWebMessageEnabled: #put_IsZoomControlEnabled:)!
ICoreWebView2Settings methodProtocol: #ICoreWebView2Settings2 attributes: #(#readOnly) selectors: #(#get_AreDefaultContextMenusEnabled: #get_AreDefaultScriptDialogsEnabled: #get_AreDevToolsEnabled: #get_AreHostObjectsAllowed: #get_IsBuiltInErrorPageEnabled: #get_IsScriptEnabled: #get_IsStatusBarEnabled: #get_IsWebMessageEnabled: #get_IsZoomControlEnabled: #get_UserAgent: #put_AreDefaultContextMenusEnabled: #put_AreDefaultScriptDialogsEnabled: #put_AreDevToolsEnabled: #put_AreHostObjectsAllowed: #put_IsBuiltInErrorPageEnabled: #put_IsScriptEnabled: #put_IsStatusBarEnabled: #put_IsWebMessageEnabled: #put_IsZoomControlEnabled: #put_UserAgent:)!
ICoreWebView2Settings methodProtocol: #ICoreWebView2Settings3 attributes: #(#readOnly) selectors: #(#get_AreBrowserAcceleratorKeysEnabled: #get_AreDefaultContextMenusEnabled: #get_AreDefaultScriptDialogsEnabled: #get_AreDevToolsEnabled: #get_AreHostObjectsAllowed: #get_IsBuiltInErrorPageEnabled: #get_IsScriptEnabled: #get_IsStatusBarEnabled: #get_IsWebMessageEnabled: #get_IsZoomControlEnabled: #get_UserAgent: #put_AreBrowserAcceleratorKeysEnabled: #put_AreDefaultContextMenusEnabled: #put_AreDefaultScriptDialogsEnabled: #put_AreDevToolsEnabled: #put_AreHostObjectsAllowed: #put_IsBuiltInErrorPageEnabled: #put_IsScriptEnabled: #put_IsStatusBarEnabled: #put_IsWebMessageEnabled: #put_IsZoomControlEnabled: #put_UserAgent:)!
ICoreWebView2Settings methodProtocol: #ICoreWebView2Settings4 attributes: #(#readOnly) selectors: #(#get_AreBrowserAcceleratorKeysEnabled: #get_AreDefaultContextMenusEnabled: #get_AreDefaultScriptDialogsEnabled: #get_AreDevToolsEnabled: #get_AreHostObjectsAllowed: #get_IsBuiltInErrorPageEnabled: #get_IsGeneralAutofillEnabled: #get_IsPasswordAutosaveEnabled: #get_IsScriptEnabled: #get_IsStatusBarEnabled: #get_IsWebMessageEnabled: #get_IsZoomControlEnabled: #get_UserAgent: #put_AreBrowserAcceleratorKeysEnabled: #put_AreDefaultContextMenusEnabled: #put_AreDefaultScriptDialogsEnabled: #put_AreDevToolsEnabled: #put_AreHostObjectsAllowed: #put_IsBuiltInErrorPageEnabled: #put_IsGeneralAutofillEnabled: #put_IsPasswordAutosaveEnabled: #put_IsScriptEnabled: #put_IsStatusBarEnabled: #put_IsWebMessageEnabled: #put_IsZoomControlEnabled: #put_UserAgent:)!
ICoreWebView2Settings methodProtocol: #ICoreWebView2Settings5 attributes: #(#readOnly) selectors: #(#get_AreBrowserAcceleratorKeysEnabled: #get_AreDefaultContextMenusEnabled: #get_AreDefaultScriptDialogsEnabled: #get_AreDevToolsEnabled: #get_AreHostObjectsAllowed: #get_IsBuiltInErrorPageEnabled: #get_IsGeneralAutofillEnabled: #get_IsPasswordAutosaveEnabled: #get_IsPinchZoomEnabled: #get_IsScriptEnabled: #get_IsStatusBarEnabled: #get_IsWebMessageEnabled: #get_IsZoomControlEnabled: #get_UserAgent: #put_AreBrowserAcceleratorKeysEnabled: #put_AreDefaultContextMenusEnabled: #put_AreDefaultScriptDialogsEnabled: #put_AreDevToolsEnabled: #put_AreHostObjectsAllowed: #put_IsBuiltInErrorPageEnabled: #put_IsGeneralAutofillEnabled: #put_IsPasswordAutosaveEnabled: #put_IsPinchZoomEnabled: #put_IsScriptEnabled: #put_IsStatusBarEnabled: #put_IsWebMessageEnabled: #put_IsZoomControlEnabled: #put_UserAgent:)!
ICoreWebView2Settings methodProtocol: #ICoreWebView2Settings6 attributes: #(#readOnly) selectors: #(#get_AreBrowserAcceleratorKeysEnabled: #get_AreDefaultContextMenusEnabled: #get_AreDefaultScriptDialogsEnabled: #get_AreDevToolsEnabled: #get_AreHostObjectsAllowed: #get_IsBuiltInErrorPageEnabled: #get_IsGeneralAutofillEnabled: #get_IsPasswordAutosaveEnabled: #get_IsPinchZoomEnabled: #get_IsScriptEnabled: #get_IsStatusBarEnabled: #get_IsSwipeNavigationEnabled: #get_IsWebMessageEnabled: #get_IsZoomControlEnabled: #get_UserAgent: #put_AreBrowserAcceleratorKeysEnabled: #put_AreDefaultContextMenusEnabled: #put_AreDefaultScriptDialogsEnabled: #put_AreDevToolsEnabled: #put_AreHostObjectsAllowed: #put_IsBuiltInErrorPageEnabled: #put_IsGeneralAutofillEnabled: #put_IsPasswordAutosaveEnabled: #put_IsPinchZoomEnabled: #put_IsScriptEnabled: #put_IsStatusBarEnabled: #put_IsSwipeNavigationEnabled: #put_IsWebMessageEnabled: #put_IsZoomControlEnabled: #put_UserAgent:)!

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

