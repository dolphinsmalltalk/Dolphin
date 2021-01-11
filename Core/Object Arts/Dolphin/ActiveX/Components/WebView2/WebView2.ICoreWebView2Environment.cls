"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2Environment'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Environment guid: (OS.COM.IID fromString: '{b96d755e-0319-4e92-a296-23436f46a1fc}')!
WebView2.ICoreWebView2Environment comment: '`ICoreWebView2Environment` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(b96d755e-0319-4e92-a296-23436f46a1fc)
]
interface ICoreWebView2Environment : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall CreateCoreWebView2Controller(
		wireHWND ParentWindow,
		ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* handler);
	[id(0x60010001)]
	HRESULT __stdcall CreateWebResourceResponse(
		[in]IStream* Content,
		[in]int StatusCode,
		[in]LPWSTR ReasonPhrase,
		[in]LPWSTR Headers,
		[out, retval]ICoreWebView2WebResourceResponse** Response);
	[id(0x60010002), propget]
	HRESULT __stdcall BrowserVersionString(
		[out, retval]LPWSTR* versionInfo);
	[id(0x60010003)]
	HRESULT __stdcall add_NewBrowserVersionAvailable(
		[in]ICoreWebView2NewBrowserVersionAvailableEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010004)]
	HRESULT __stdcall remove_NewBrowserVersionAvailable(
		[in]EventRegistrationToken token);
};
```
'!
!WebView2.ICoreWebView2Environment categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2Environment methodsFor!

add_NewBrowserVersionAvailable: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_NewBrowserVersionAvailable() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_NewBrowserVersionAvailable: eventHandler token: answer.
	^answer asObject!

Add_NewBrowserVersionAvailable: eventHandler token: token
	"Private - Invoke the add_NewBrowserVersionAvailable() method of the COM object.

		HRESULT __stdcall add_NewBrowserVersionAvailable(
			[in]ICoreWebView2NewBrowserVersionAvailableEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 7 ICoreWebView2NewBrowserVersionAvailableEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

browserVersionString
	"Answer the <lpwstr> value of the 'BrowserVersionString' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_BrowserVersionString: answer.
	^answer asObject!

createCoreWebView2Controller: parentWindow handler: handler
	"Invoke the CreateCoreWebView2Controller() method of the COM object."

	^self CreateCoreWebView2Controller: parentWindow handler: handler!

CreateCoreWebView2Controller: parentWindow handler: handler
	"Private - Invoke the CreateCoreWebView2Controller() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2Controller(
			wireHWND ParentWindow,
			ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* handler);"

	<virtual stdcall: hresult 4 handle ICoreWebView2CreateCoreWebView2ControllerCompletedHandler*>
	^self invalidCall: _failureCode!

createWebResourceResponse: content statusCode: statusCode reasonPhrase: reasonPhrase headers: headers
	"Answer the <ICoreWebView2WebResourceResponse> result of invoking the CreateWebResourceResponse() method of the COM object."

	| answer |
	answer := ICoreWebView2WebResourceResponse newPointer.
	self
		CreateWebResourceResponse: content
		statusCode: statusCode
		reasonPhrase: reasonPhrase asUtf16String
		headers: headers asUtf16String
		response: answer.
	^answer asObject!

CreateWebResourceResponse: content statusCode: statusCode reasonPhrase: reasonPhrase headers: headers response: response
	"Private - Invoke the CreateWebResourceResponse() method of the COM object.

		HRESULT __stdcall CreateWebResourceResponse(
			[in]IStream* Content,
			[in]int StatusCode,
			[in]LPWSTR ReasonPhrase,
			[in]LPWSTR Headers,
			[out, retval]ICoreWebView2WebResourceResponse** Response);"

	<virtual stdcall: hresult 5 IStream* sdword lpwstr lpwstr ICoreWebView2WebResourceResponse**>
	^self invalidCall: _failureCode!

get_BrowserVersionString: versionInfo
	"Private - Get the value of the 'BrowserVersionString' property of the receiver.

		HRESULT __stdcall BrowserVersionString(
			[out, retval]LPWSTR* versionInfo);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

remove_NewBrowserVersionAvailable: token
	"Invoke the remove_NewBrowserVersionAvailable() method of the COM object."

	^self Remove_NewBrowserVersionAvailable: token!

Remove_NewBrowserVersionAvailable: token
	"Private - Invoke the remove_NewBrowserVersionAvailable() method of the COM object.

		HRESULT __stdcall remove_NewBrowserVersionAvailable(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 8 EventRegistrationToken>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2Environment categoriesFor: #add_NewBrowserVersionAvailable:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Environment categoriesFor: #Add_NewBrowserVersionAvailable:token:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
!WebView2.ICoreWebView2Environment categoriesFor: #browserVersionString!**auto generated**!properties!public! !
!WebView2.ICoreWebView2Environment categoriesFor: #createCoreWebView2Controller:handler:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Environment categoriesFor: #CreateCoreWebView2Controller:handler:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
!WebView2.ICoreWebView2Environment categoriesFor: #createWebResourceResponse:statusCode:reasonPhrase:headers:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Environment categoriesFor: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
!WebView2.ICoreWebView2Environment categoriesFor: #get_BrowserVersionString:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
!WebView2.ICoreWebView2Environment categoriesFor: #remove_NewBrowserVersionAvailable:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2Environment categoriesFor: #Remove_NewBrowserVersionAvailable:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !

!WebView2.ICoreWebView2Environment class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2Environment'
		ICoreWebView2Environment defineTemplate"

	self
		defineFunction: #CreateCoreWebView2Controller:handler:
			argumentTypes: 'handle ICoreWebView2CreateCoreWebView2ControllerCompletedHandler*';
		defineFunction: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response:
			argumentTypes: 'IStream* sdword lpwstr lpwstr ICoreWebView2WebResourceResponse**';
		defineFunction: #get_BrowserVersionString:
			argumentTypes: 'lpwstr*';
		defineFunction: #Add_NewBrowserVersionAvailable:token:
			argumentTypes: 'ICoreWebView2NewBrowserVersionAvailableEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_NewBrowserVersionAvailable:
			argumentTypes: 'EventRegistrationToken'
! !
!WebView2.ICoreWebView2Environment class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

