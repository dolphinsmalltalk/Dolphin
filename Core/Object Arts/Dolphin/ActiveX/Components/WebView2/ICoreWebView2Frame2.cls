"Filed out from Dolphin Smalltalk"!

ICoreWebView2Frame subclass: #ICoreWebView2Frame2
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ICoreWebView2Frame2 guid: (IID fromString: '{7a6a5834-d185-4dbf-b63f-4a9bc43107d4}')!

ICoreWebView2Frame2 comment: '`ICoreWebView2Frame2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Frame2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(7a6a5834-d185-4dbf-b63f-4a9bc43107d4)
]
interface ICoreWebView2Frame2 : ICoreWebView2Frame
 {
	[id(0x60020000)]
	HRESULT __stdcall add_NavigationStarting(
		[in]ICoreWebView2FrameNavigationStartingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60020001)]
	HRESULT __stdcall remove_NavigationStarting(
		[in]EventRegistrationToken token);
	[id(0x60020002)]
	HRESULT __stdcall add_ContentLoading(
		[in]ICoreWebView2FrameContentLoadingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60020003)]
	HRESULT __stdcall remove_ContentLoading(
		[in]EventRegistrationToken token);
	[id(0x60020004)]
	HRESULT __stdcall add_NavigationCompleted(
		[in]ICoreWebView2FrameNavigationCompletedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60020005)]
	HRESULT __stdcall remove_NavigationCompleted(
		[in]EventRegistrationToken token);
	[id(0x60020006)]
	HRESULT __stdcall add_DOMContentLoaded(
		[in]ICoreWebView2FrameDOMContentLoadedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60020007)]
	HRESULT __stdcall remove_DOMContentLoaded(
		[in]EventRegistrationToken token);
	[id(0x60020008)]
	HRESULT __stdcall ExecuteScript(
		[in]LPWSTR javaScript,
		[in]ICoreWebView2ExecuteScriptCompletedHandler* handler);
	[id(0x60020009)]
	HRESULT __stdcall PostWebMessageAsJson(
		[in]LPWSTR webMessageAsJson);
	[id(0x6002000a)]
	HRESULT __stdcall PostWebMessageAsString(
		[in]LPWSTR webMessageAsString);
	[id(0x6002000b)]
	HRESULT __stdcall add_WebMessageReceived(
		[in]ICoreWebView2FrameWebMessageReceivedEventHandler* handler,
		[out]EventRegistrationToken* token);
	[id(0x6002000c)]
	HRESULT __stdcall remove_WebMessageReceived(
		[in]EventRegistrationToken token);
};
```
'!

!ICoreWebView2Frame2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !

!ICoreWebView2Frame2 methodsFor!

Add_ContentLoading: eventHandler token: token
	"Private - Invoke the add_ContentLoading() method of the COM object.

		HRESULT __stdcall add_ContentLoading(
			[in]ICoreWebView2FrameContentLoadingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 14 ICoreWebView2FrameContentLoadingEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_DOMContentLoaded: eventHandler token: token
	"Private - Invoke the add_DOMContentLoaded() method of the COM object.

		HRESULT __stdcall add_DOMContentLoaded(
			[in]ICoreWebView2FrameDOMContentLoadedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 18 ICoreWebView2FrameDOMContentLoadedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_NavigationCompleted: eventHandler token: token
	"Private - Invoke the add_NavigationCompleted() method of the COM object.

		HRESULT __stdcall add_NavigationCompleted(
			[in]ICoreWebView2FrameNavigationCompletedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 16 ICoreWebView2FrameNavigationCompletedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_NavigationStarting: eventHandler token: token
	"Private - Invoke the add_NavigationStarting() method of the COM object.

		HRESULT __stdcall add_NavigationStarting(
			[in]ICoreWebView2FrameNavigationStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 12 ICoreWebView2FrameNavigationStartingEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_WebMessageReceived: handler token: token
	"Private - Invoke the add_WebMessageReceived() method of the COM object.

		HRESULT __stdcall add_WebMessageReceived(
			[in]ICoreWebView2FrameWebMessageReceivedEventHandler* handler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 23 ICoreWebView2FrameWebMessageReceivedEventHandler* sqword*>
	^self invalidCall: _failureCode!

ExecuteScript: javaScript handler: handler
	"Private - Invoke the ExecuteScript() method of the COM object.

		HRESULT __stdcall ExecuteScript(
			[in]LPWSTR javaScript,
			[in]ICoreWebView2ExecuteScriptCompletedHandler* handler);"

	<virtual stdcall: hresult 20 lpwstr ICoreWebView2ExecuteScriptCompletedHandler*>
	^self invalidCall: _failureCode!

PostWebMessageAsJson: webMessageAsJson
	"Private - Invoke the PostWebMessageAsJson() method of the COM object.

		HRESULT __stdcall PostWebMessageAsJson(
			[in]LPWSTR webMessageAsJson);"

	<virtual stdcall: hresult 21 lpwstr>
	^self invalidCall: _failureCode!

PostWebMessageAsString: webMessageAsString
	"Private - Invoke the PostWebMessageAsString() method of the COM object.

		HRESULT __stdcall PostWebMessageAsString(
			[in]LPWSTR webMessageAsString);"

	<virtual stdcall: hresult 22 lpwstr>
	^self invalidCall: _failureCode!

Remove_ContentLoading: token
	"Private - Invoke the remove_ContentLoading() method of the COM object.

		HRESULT __stdcall remove_ContentLoading(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 15 sqword>
	^self invalidCall: _failureCode!

Remove_DOMContentLoaded: token
	"Private - Invoke the remove_DOMContentLoaded() method of the COM object.

		HRESULT __stdcall remove_DOMContentLoaded(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 19 sqword>
	^self invalidCall: _failureCode!

Remove_NavigationCompleted: token
	"Private - Invoke the remove_NavigationCompleted() method of the COM object.

		HRESULT __stdcall remove_NavigationCompleted(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 17 sqword>
	^self invalidCall: _failureCode!

Remove_NavigationStarting: token
	"Private - Invoke the remove_NavigationStarting() method of the COM object.

		HRESULT __stdcall remove_NavigationStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 13 sqword>
	^self invalidCall: _failureCode!

Remove_WebMessageReceived: token
	"Private - Invoke the remove_WebMessageReceived() method of the COM object.

		HRESULT __stdcall remove_WebMessageReceived(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 24 sqword>
	^self invalidCall: _failureCode! !

!ICoreWebView2Frame2 categoriesForMethods!
Add_ContentLoading:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
Add_DOMContentLoaded:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
Add_NavigationCompleted:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
Add_NavigationStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
Add_WebMessageReceived:token:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
ExecuteScript:handler:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!methods!private! !
PostWebMessageAsJson:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!methods!private! !
PostWebMessageAsString:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!methods!private! !
Remove_ContentLoading:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
Remove_DOMContentLoaded:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
Remove_NavigationCompleted:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
Remove_NavigationStarting:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
Remove_WebMessageReceived:!**auto generated**!COM Interfaces-ICoreWebView2Frame2!events!private! !
!

!ICoreWebView2Frame2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Frame2'
		ICoreWebView2Frame2 defineTemplate"

	self
		defineFunction: #Add_NavigationStarting:token:
			argumentTypes: 'ICoreWebView2FrameNavigationStartingEventHandler* sqword*';
		defineFunction: #Remove_NavigationStarting:
			argumentTypes: 'sqword';
		defineFunction: #Add_ContentLoading:token:
			argumentTypes: 'ICoreWebView2FrameContentLoadingEventHandler* sqword*';
		defineFunction: #Remove_ContentLoading:
			argumentTypes: 'sqword';
		defineFunction: #Add_NavigationCompleted:token:
			argumentTypes: 'ICoreWebView2FrameNavigationCompletedEventHandler* sqword*';
		defineFunction: #Remove_NavigationCompleted:
			argumentTypes: 'sqword';
		defineFunction: #Add_DOMContentLoaded:token:
			argumentTypes: 'ICoreWebView2FrameDOMContentLoadedEventHandler* sqword*';
		defineFunction: #Remove_DOMContentLoaded:
			argumentTypes: 'sqword';
		defineFunction: #ExecuteScript:handler:
			argumentTypes: 'lpwstr ICoreWebView2ExecuteScriptCompletedHandler*';
		defineFunction: #PostWebMessageAsJson:
			argumentTypes: 'lpwstr';
		defineFunction: #PostWebMessageAsString:
			argumentTypes: 'lpwstr';
		defineFunction: #Add_WebMessageReceived:token:
			argumentTypes: 'ICoreWebView2FrameWebMessageReceivedEventHandler* sqword*';
		defineFunction: #Remove_WebMessageReceived:
			argumentTypes: 'sqword'
! !

!ICoreWebView2Frame2 class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

