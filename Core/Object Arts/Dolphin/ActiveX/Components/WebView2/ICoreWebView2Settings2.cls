"Filed out from Dolphin Smalltalk"!

ICoreWebView2Settings subclass: #ICoreWebView2Settings2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2Settings2 guid: (IID fromString: '{ee9a0f68-f46c-4e32-ac23-ef8cac224d2a}')!
ICoreWebView2Settings2 comment: '`ICoreWebView2Settings2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Settings2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(ee9a0f68-f46c-4e32-ac23-ef8cac224d2a)
]
interface ICoreWebView2Settings2 : ICoreWebView2Settings
 {
	[id(0x60020000), propget]
	HRESULT __stdcall UserAgent(
		[out, retval]LPWSTR* UserAgent);
	[id(0x60020000), propput]
	HRESULT __stdcall UserAgent(
		[in]LPWSTR UserAgent);
};
```
'!
!ICoreWebView2Settings2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!ICoreWebView2Settings2 methodsFor!

get_UserAgent: userAgent
	"Private - Get the value of the 'UserAgent' property of the receiver.

		HRESULT __stdcall UserAgent(
			[out, retval]LPWSTR* UserAgent);"

	<virtual stdcall: hresult 22 lpwstr*>
	^self invalidCall: _failureCode!

put_UserAgent: userAgent
	"Private - Set the value of the 'UserAgent' property of the object wrapped by the 
	 receiver to the <lpwstr> argument, userAgent.

		HRESULT __stdcall UserAgent(
			[in]LPWSTR UserAgent);"

	<virtual stdcall: hresult 23 lpwstr>
	^self invalidCall: _failureCode! !
!ICoreWebView2Settings2 categoriesForMethods!
get_UserAgent:!**auto generated**!COM Interfaces-ICoreWebView2Settings2!private! !
put_UserAgent:!**auto generated**!COM Interfaces-ICoreWebView2Settings2!private! !
!

!ICoreWebView2Settings2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Settings2'
		ICoreWebView2Settings2 defineTemplate"

	self
		defineFunction: #get_UserAgent:
			argumentTypes: 'lpwstr*';
		defineFunction: #put_UserAgent:
			argumentTypes: 'lpwstr'
! !
!ICoreWebView2Settings2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

