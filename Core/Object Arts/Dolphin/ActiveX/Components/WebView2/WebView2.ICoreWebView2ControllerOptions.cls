﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2ControllerOptions'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ControllerOptions guid: (OS.COM.IID fromString: '{12aae616-8ccb-44ec-bcb3-eb1831881635}')!

WebView2.ICoreWebView2ControllerOptions isEgressOnly: true!

WebView2.ICoreWebView2ControllerOptions comment: '`ICoreWebView2ControllerOptions` is a wrapper class for the COM interface ''WebView2.ICoreWebView2ControllerOptions'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(12aae616-8ccb-44ec-bcb3-eb1831881635)
]
interface ICoreWebView2ControllerOptions : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall ProfileName(
		[out, retval]LPWSTR* value);
	[id(0x60010000), propput]
	HRESULT __stdcall ProfileName(
		[in]LPWSTR value);
	[id(0x60010002), propget]
	HRESULT __stdcall IsInPrivateModeEnabled(
		[out, retval]long* value);
	[id(0x60010002), propput]
	HRESULT __stdcall IsInPrivateModeEnabled(
		[in]long value);
};
```
'!

!WebView2.ICoreWebView2ControllerOptions categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!WebView2.ICoreWebView2ControllerOptions methodsFor!

get_IsInPrivateModeEnabled: value
	"Private - Get the value of the 'IsInPrivateModeEnabled' property of the receiver.

		HRESULT __stdcall IsInPrivateModeEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 6 int32*>
	^self invalidCall: _failureCode!

get_ProfileName: value
	"Private - Get the value of the 'ProfileName' property of the receiver.

		HRESULT __stdcall ProfileName(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_ScriptLocale: locale
	"Private - Get the value of the 'ScriptLocale' property of the receiver.

		HRESULT __stdcall ScriptLocale(
			[out, retval]LPWSTR* locale);"

	locale value: (Locale userDefault tag asUtf16String copyToCOMTaskMemory detach).
	^S_OK!

isInPrivateModeEnabled
	"Answer the <boolean> value of the 'IsInPrivateModeEnabled' property of the receiver."

	| buf |
	buf := UInt32Bytes new.
	self get_IsInPrivateModeEnabled: buf.
	^buf asBoolean!

isInPrivateModeEnabled: value
	"Set the 'IsInPrivateModeEnabled' property of the receiver to the <boolean> value of the argument."

	self put_IsInPrivateModeEnabled: value asParameter!

printableProperties
	^#(#profileName #isInPrivateModeEnabled #scriptLocale)!

profileName
	"Answer the <lpwstr> value of the 'ProfileName' property of the receiver."

	"The auto-generated code is functionally correct, but this code is slightly more efficient; in particular it avoids generating finalizable garbage."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ProfileName: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

profileName: value
	"Set the 'ProfileName' property of the receiver to the <lpwstr> value of the argument."

	self put_ProfileName: value asUtf16String!

put_IsInPrivateModeEnabled: value
	"Private - Set the value of the 'IsInPrivateModeEnabled' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall IsInPrivateModeEnabled(
			[in]long value);"

	<virtual stdcall: hresult 7 bool>
	^self invalidCall: _failureCode!

put_ProfileName: value
	"Private - Set the value of the 'ProfileName' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall ProfileName(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 5 lpwstr>
	^self invalidCall: _failureCode!

put_ScriptLocale: locale
	"Private - Set the value of the 'ScriptLocale' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, locale.

		HRESULT __stdcall ScriptLocale(
			[in]LPWSTR locale);"

	"Not implemented at this level - request to set the script locale is ignored"
	^E_NOTIMPL!

scriptLocale
	"Answer the <lpwstr> value of the 'ScriptLocale' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_ScriptLocale: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

scriptLocale: locale
	"Set the 'ScriptLocale' property of the receiver to the <lpwstr> value of the argument."

	self put_ScriptLocale: locale asUtf16String! !

!WebView2.ICoreWebView2ControllerOptions categoriesForMethods!
get_IsInPrivateModeEnabled:!**auto generated**!COM Interfaces-ICoreWebView2ControllerOptions!private! !
get_ProfileName:!**auto generated**!COM Interfaces-ICoreWebView2ControllerOptions!private! !
get_ScriptLocale:!COM Interfaces-ICoreWebView2ControllerOptions2!private! !
isInPrivateModeEnabled!properties!public! !
isInPrivateModeEnabled:!properties!public! !
printableProperties!printing!private! !
profileName!properties!public! !
profileName:!**auto generated**!properties!public! !
put_IsInPrivateModeEnabled:!**auto generated**!COM Interfaces-ICoreWebView2ControllerOptions!private! !
put_ProfileName:!**auto generated**!COM Interfaces-ICoreWebView2ControllerOptions!private! !
put_ScriptLocale:!COM Interfaces-ICoreWebView2ControllerOptions2!private! !
scriptLocale!properties!public! !
scriptLocale:!properties!public! !
!

!WebView2.ICoreWebView2ControllerOptions class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2ControllerOptions'
		ICoreWebView2ControllerOptions defineTemplate"

	self
		defineFunction: #get_ProfileName:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_ProfileName:
			argumentTypes: 'lpwstr';
		defineFunction: #get_IsInPrivateModeEnabled:
			argumentTypes: 'bool*';
		defineFunction: #put_IsInPrivateModeEnabled:
			argumentTypes: 'bool'
!

latestDerivation
	^##(super latestDerivation)! !

!WebView2.ICoreWebView2ControllerOptions class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
latestDerivation!enquiries!public! !
!

