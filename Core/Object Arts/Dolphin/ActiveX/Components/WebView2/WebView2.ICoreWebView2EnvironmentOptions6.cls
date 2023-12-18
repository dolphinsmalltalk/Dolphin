"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2EnvironmentOptions6'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2EnvironmentOptions6 guid: (OS.COM.IID fromString: '{57d29cc3-c84f-42a0-b0e2-effbd5e179de}')!
WebView2.ICoreWebView2EnvironmentOptions6 comment: '`ICoreWebView2EnvironmentOptions6` is a wrapper class for the COM interface ''WebView2.ICoreWebView2EnvironmentOptions6'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(57d29cc3-c84f-42a0-b0e2-effbd5e179de)
]
interface ICoreWebView2EnvironmentOptions6 : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall AreBrowserExtensionsEnabled(
		[out, retval]long* value);
	[id(0x60010000), propput]
	HRESULT __stdcall AreBrowserExtensionsEnabled(
		[in]long value);
};
```
'!
!WebView2.ICoreWebView2EnvironmentOptions6 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2EnvironmentOptions6 methodsFor!

areBrowserExtensionsEnabled
	"Answer the <boolean> value of the 'AreBrowserExtensionsEnabled' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_AreBrowserExtensionsEnabled: answer.
	^answer asObject!

areBrowserExtensionsEnabled: value
	"Set the 'AreBrowserExtensionsEnabled' property of the receiver to the <int32> value of the argument."

	self put_AreBrowserExtensionsEnabled: value asParameter!

get_AreBrowserExtensionsEnabled: value
	"Private - Get the value of the 'AreBrowserExtensionsEnabled' property of the receiver.

		HRESULT __stdcall AreBrowserExtensionsEnabled(
			[out, retval]long* value);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

put_AreBrowserExtensionsEnabled: value
	"Private - Set the value of the 'AreBrowserExtensionsEnabled' property of the object wrapped by the 
	 receiver to the <int32> argument, value.

		HRESULT __stdcall AreBrowserExtensionsEnabled(
			[in]long value);"

	<virtual stdcall: hresult 5 int32>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2EnvironmentOptions6 categoriesForMethods!
areBrowserExtensionsEnabled!properties!public! !
areBrowserExtensionsEnabled:!properties!public! !
get_AreBrowserExtensionsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions6!private! !
put_AreBrowserExtensionsEnabled:!**auto generated**!COM Interfaces-ICoreWebView2EnvironmentOptions6!private! !
!

WebView2.ICoreWebView2EnvironmentOptions6 methodProtocol: #ICoreWebView2EnvironmentOptions6 attributes: #(#readOnly) selectors: #(#get_AreBrowserExtensionsEnabled: #put_AreBrowserExtensionsEnabled:)!

!WebView2.ICoreWebView2EnvironmentOptions6 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2EnvironmentOptions6'
		ICoreWebView2EnvironmentOptions6 defineTemplate"

	self
		defineFunction: #get_AreBrowserExtensionsEnabled:
			argumentTypes: 'int32*';
		defineFunction: #put_AreBrowserExtensionsEnabled:
			argumentTypes: 'int32'
! !
!WebView2.ICoreWebView2EnvironmentOptions6 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
!

