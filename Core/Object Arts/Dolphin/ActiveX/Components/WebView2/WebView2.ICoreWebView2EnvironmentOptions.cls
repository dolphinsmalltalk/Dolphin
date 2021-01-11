"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2EnvironmentOptions'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2EnvironmentOptions guid: (OS.COM.IID fromString: '{2fde08a8-1e9a-4766-8c05-95a9ceb9d1c5}')!
WebView2.ICoreWebView2EnvironmentOptions comment: '`ICoreWebView2EnvironmentOptions` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(2fde08a8-1e9a-4766-8c05-95a9ceb9d1c5)
]
interface ICoreWebView2EnvironmentOptions : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall AdditionalBrowserArguments(
		[out, retval]LPWSTR* value);
	[id(0x60010000), propput]
	HRESULT __stdcall AdditionalBrowserArguments(
		[in]LPWSTR value);
	[id(0x60010002), propget]
	HRESULT __stdcall Language(
		[out, retval]LPWSTR* value);
	[id(0x60010002), propput]
	HRESULT __stdcall Language(
		[in]LPWSTR value);
	[id(0x60010004), propget]
	HRESULT __stdcall TargetCompatibleBrowserVersion(
		[out, retval]LPWSTR* value);
	[id(0x60010004), propput]
	HRESULT __stdcall TargetCompatibleBrowserVersion(
		[in]LPWSTR value);
	[id(0x60010006), propget]
	HRESULT __stdcall AllowSingleSignOnUsingOSPrimaryAccount(
		[out, retval]long* allow);
	[id(0x60010006), propput]
	HRESULT __stdcall AllowSingleSignOnUsingOSPrimaryAccount(
		[in]long allow);
};
```
'!
!WebView2.ICoreWebView2EnvironmentOptions categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2EnvironmentOptions methodsFor!

additionalBrowserArguments
	"Answer the <lpwstr> value of the 'AdditionalBrowserArguments' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_AdditionalBrowserArguments: answer.
	^answer asObject!

additionalBrowserArguments: value
	"Set the 'AdditionalBrowserArguments' property of the receiver to the <lpwstr> value of the argument."

	self put_AdditionalBrowserArguments: value asUtf16String!

allowSingleSignOnUsingOSPrimaryAccount
	"Answer the <sdword> value of the 'AllowSingleSignOnUsingOSPrimaryAccount' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_AllowSingleSignOnUsingOSPrimaryAccount: answer.
	^answer asObject!

allowSingleSignOnUsingOSPrimaryAccount: allow
	"Set the 'AllowSingleSignOnUsingOSPrimaryAccount' property of the receiver to the <sdword> value of the argument."

	self put_AllowSingleSignOnUsingOSPrimaryAccount: allow!

get_AdditionalBrowserArguments: value
	"Private - Get the value of the 'AdditionalBrowserArguments' property of the receiver.

		HRESULT __stdcall AdditionalBrowserArguments(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 4 lpwstr*>
	^self invalidCall: _failureCode!

get_AllowSingleSignOnUsingOSPrimaryAccount: allow
	"Private - Get the value of the 'AllowSingleSignOnUsingOSPrimaryAccount' property of the receiver.

		HRESULT __stdcall AllowSingleSignOnUsingOSPrimaryAccount(
			[out, retval]long* allow);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall: _failureCode!

get_Language: value
	"Private - Get the value of the 'Language' property of the receiver.

		HRESULT __stdcall Language(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_TargetCompatibleBrowserVersion: value
	"Private - Get the value of the 'TargetCompatibleBrowserVersion' property of the receiver.

		HRESULT __stdcall TargetCompatibleBrowserVersion(
			[out, retval]LPWSTR* value);"

	<virtual stdcall: hresult 8 lpwstr*>
	^self invalidCall: _failureCode!

language
	"Answer the <lpwstr> value of the 'Language' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_Language: answer.
	^answer asObject!

language: value
	"Set the 'Language' property of the receiver to the <lpwstr> value of the argument."

	self put_Language: value asUtf16String!

put_AdditionalBrowserArguments: value
	"Private - Set the value of the 'AdditionalBrowserArguments' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall AdditionalBrowserArguments(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 5 lpwstr>
	^self invalidCall: _failureCode!

put_AllowSingleSignOnUsingOSPrimaryAccount: allow
	"Private - Set the value of the 'AllowSingleSignOnUsingOSPrimaryAccount' property of the object wrapped by the 
	 receiver to the <sdword> argument, allow.

		HRESULT __stdcall AllowSingleSignOnUsingOSPrimaryAccount(
			[in]long allow);"

	<virtual stdcall: hresult 11 sdword>
	^self invalidCall: _failureCode!

put_Language: value
	"Private - Set the value of the 'Language' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall Language(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 7 lpwstr>
	^self invalidCall: _failureCode!

put_TargetCompatibleBrowserVersion: value
	"Private - Set the value of the 'TargetCompatibleBrowserVersion' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, value.

		HRESULT __stdcall TargetCompatibleBrowserVersion(
			[in]LPWSTR value);"

	<virtual stdcall: hresult 9 lpwstr>
	^self invalidCall: _failureCode!

targetCompatibleBrowserVersion
	"Answer the <lpwstr> value of the 'TargetCompatibleBrowserVersion' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_TargetCompatibleBrowserVersion: answer.
	^answer asObject!

targetCompatibleBrowserVersion: value
	"Set the 'TargetCompatibleBrowserVersion' property of the receiver to the <lpwstr> value of the argument."

	self put_TargetCompatibleBrowserVersion: value asUtf16String! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #additionalBrowserArguments!**auto generated**!properties!public! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #additionalBrowserArguments:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #allowSingleSignOnUsingOSPrimaryAccount!**auto generated**!properties!public! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #allowSingleSignOnUsingOSPrimaryAccount:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #get_AdditionalBrowserArguments:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #get_AllowSingleSignOnUsingOSPrimaryAccount:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #get_Language:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #get_TargetCompatibleBrowserVersion:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #language!**auto generated**!properties!public! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #language:!**auto generated**!properties!public! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #put_AdditionalBrowserArguments:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #put_AllowSingleSignOnUsingOSPrimaryAccount:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #put_Language:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #put_TargetCompatibleBrowserVersion:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions!private! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #targetCompatibleBrowserVersion!**auto generated**!properties!public! !
!WebView2.ICoreWebView2EnvironmentOptions categoriesFor: #targetCompatibleBrowserVersion:!**auto generated**!properties!public! !

!WebView2.ICoreWebView2EnvironmentOptions class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions'
		ICoreWebView2EnvironmentOptions defineTemplate"

	self
		defineFunction: #get_AdditionalBrowserArguments:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_AdditionalBrowserArguments:
			argumentTypes: 'lpwstr';
		defineFunction: #get_Language:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_Language:
			argumentTypes: 'lpwstr';
		defineFunction: #get_TargetCompatibleBrowserVersion:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_TargetCompatibleBrowserVersion:
			argumentTypes: 'lpwstr';
		defineFunction: #get_AllowSingleSignOnUsingOSPrimaryAccount:
			argumentTypes: 'sdword*';
		defineFunction: #put_AllowSingleSignOnUsingOSPrimaryAccount:
			argumentTypes: 'sdword'
! !
!WebView2.ICoreWebView2EnvironmentOptions class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

