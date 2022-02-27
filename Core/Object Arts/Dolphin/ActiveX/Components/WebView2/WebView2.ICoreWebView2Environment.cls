"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface subclass: #'WebView2.ICoreWebView2Environment'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2Environment guid: (OS.COM.IID fromString: '{b96d755e-0319-4e92-a296-23436f46a1fc}')!
WebView2.ICoreWebView2Environment comment: '`ICoreWebView2Environment` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

At the time of writing there are seven (!!) later versions of this interface. In order to reduce the burden of degrading gracefully to older versions, default implementations of the additional methods and properties are added.

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

Add_BrowserProcessExited: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_NewBrowserVersionAvailable: eventHandler token: token
	"Private - Invoke the add_NewBrowserVersionAvailable() method of the COM object.

		HRESULT __stdcall add_NewBrowserVersionAvailable(
			[in]ICoreWebView2NewBrowserVersionAvailableEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 7 ICoreWebView2NewBrowserVersionAvailableEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_ProcessInfosChanged: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

browserVersionString
	"Answer the <lpwstr> value of the 'BrowserVersionString' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_BrowserVersionString: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

CreateCoreWebView2CompositionController: parentWindow handler: handler
	"Private - Invoke the CreateCoreWebView2CompositionController() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2CompositionController(
			wireHWND ParentWindow,
			ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler* handler);"

	"Not implemented in this version"

	^E_NOTIMPL!

createCoreWebView2CompositionController: parentWindow thenDo: aDyadicValuable
	"Invoke the CreateCoreWebView2CompositionController() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler.
	self CreateCoreWebView2CompositionController: parentWindow handler: handler.
	handler free!

CreateCoreWebView2Controller: parentWindow handler: handler
	"Private - Invoke the CreateCoreWebView2Controller() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2Controller(
			wireHWND ParentWindow,
			ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* handler);"

	<virtual stdcall: hresult 4 handle ICoreWebView2CreateCoreWebView2ControllerCompletedHandler*>
	^self invalidCall: _failureCode!

createCoreWebView2Controller: parentWindow thenDo: aDyadicValuable
	"Invoke the CreateCoreWebView2Controller() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler.
	self CreateCoreWebView2Controller: parentWindow handler: handler.
	handler free!

CreateCoreWebView2PointerInfo: pointerInfo
	"Private - Invoke the CreateCoreWebView2PointerInfo() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2PointerInfo(
			[out, retval]ICoreWebView2PointerInfo** pointerInfo);"

	"Not implemented in this version"

	^E_NOTIMPL!

createPointerInfo
	"Answer a new <ICoreWebView2PointerInfo> to be populated with settings to pass to a composition controller via SendPointerInput."

	| answer |
	answer := ICoreWebView2PointerInfo newPointer.
	self CreateCoreWebView2PointerInfo: answer.
	^answer asObject!

CreatePrintSettings: printSettings
	"Private - Invoke the CreatePrintSettings() method of the COM object.

		HRESULT __stdcall CreatePrintSettings(
			[out, retval]ICoreWebView2PrintSettings** printSettings);"

	^E_NOTIMPL
!

createWebResourceRequest: uri method: method postData: postData headers: headers
	"Answer the <ICoreWebView2WebResourceRequest> result of invoking the CreateWebResourceRequest() method of the COM object, or nil if not implemented by this version."

	| answer |
	answer := ICoreWebView2WebResourceRequest newPointer.
	self
		CreateWebResourceRequest: uri asUtf16String
		method: method asUtf16String
		postData: postData
		headers: headers asUtf16String
		request: answer.
	^answer asObject!

CreateWebResourceRequest: uri method: method postData: postData headers: headers request: request
	"Private - Invoke the CreateWebResourceRequest() method of the COM object.

		HRESULT __stdcall CreateWebResourceRequest(
			[in]LPWSTR uri,
			[in]LPWSTR Method,
			[in]IStream* postData,
			[in]LPWSTR Headers,
			[out, retval]ICoreWebView2WebResourceRequest** Request);"

	"Not implemented in this version"

	^E_NOTIMPL!

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

displayOn: aWriteStream
	self isNull
		ifTrue: [super displayOn: aWriteStream]
		ifFalse: [aWriteStream nextPutAll: self browserVersionString]!

get_BrowserVersionString: versionInfo
	"Private - Get the value of the 'BrowserVersionString' property of the receiver.

		HRESULT __stdcall BrowserVersionString(
			[out, retval]LPWSTR* versionInfo);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_UserDataFolder: value
	"Private - Get the value of the 'UserDataFolder' property of the receiver.

		HRESULT __stdcall UserDataFolder(
			[out, retval]LPWSTR* value);"

	"Not implemented in this version"

	^E_NOTIMPL!

GetProcessInfos: value
	"Private - Invoke the GetProcessInfos() method of the COM object.

		HRESULT __stdcall GetProcessInfos(
			[out, retval]ICoreWebView2ProcessInfoCollection** value);"

	^E_NOTIMPL!

getProviderForHwnd: hwnd
	"Answer the <IUnknown> result of invoking the GetProviderForHwnd() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self GetProviderForHwnd: hwnd provider: answer.
	^answer asObject!

GetProviderForHwnd: hwnd provider: provider
	"Private - Invoke the GetProviderForHwnd() method of the COM object.

		HRESULT __stdcall GetProviderForHwnd(
			[in]wireHWND hwnd,
			[out, retval]IUnknown** provider);"

	^E_NOTIMPL
!

printSettings
	"Answer the <ICoreWebView2PrintSettings> result of invoking the CreatePrintSettings() method of the COM object."

	| answer |
	answer := ICoreWebView2PrintSettings newPointer.
	self CreatePrintSettings: answer.
	^answer asObject!

processInfos
	"Answer the <ICoreWebView2ProcessInfoCollection> result of invoking the GetProcessInfos() method of the COM object."

	| answer |
	answer := ICoreWebView2ProcessInfoCollection newPointer.
	self GetProcessInfos: answer.
	^answer asObject!

Remove_BrowserProcessExited: token
	"Not supported at this level"

	^E_NOTIMPL!

Remove_NewBrowserVersionAvailable: token
	"Private - Invoke the remove_NewBrowserVersionAvailable() method of the COM object.

		HRESULT __stdcall remove_NewBrowserVersionAvailable(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 8 sqword>
	^self invalidCall: _failureCode!

Remove_ProcessInfosChanged: token
	"Not supported at this level"

	^E_NOTIMPL!

userDataFolder
	"Answer the <lpwstr> value of the 'UserDataFolder' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_UserDataFolder: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer! !
!WebView2.ICoreWebView2Environment categoriesForMethods!
Add_BrowserProcessExited:token:!COM Interfaces-ICoreWebView2Environment5!events!private! !
Add_NewBrowserVersionAvailable:token:!**auto generated**!COM Interfaces-ICoreWebView2Environment!events!private! !
Add_ProcessInfosChanged:token:!COM Interfaces-ICoreWebView2Environment8!events!private! !
browserVersionString!properties!public! !
CreateCoreWebView2CompositionController:handler:!COM Interfaces-ICoreWebView2Environment3!methods!private! !
createCoreWebView2CompositionController:thenDo:!methods!public! !
CreateCoreWebView2Controller:handler:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
createCoreWebView2Controller:thenDo:!methods!public! !
CreateCoreWebView2PointerInfo:!COM Interfaces-ICoreWebView2Environment3!methods!private! !
createPointerInfo!methods!public! !
CreatePrintSettings:!COM Interfaces-ICoreWebView2Environment6!methods!private! !
createWebResourceRequest:method:postData:headers:!methods!public! !
CreateWebResourceRequest:method:postData:headers:request:!COM Interfaces-ICoreWebView2Environment2!displaying!private! !
createWebResourceResponse:statusCode:reasonPhrase:headers:!**auto generated**!methods!public! !
CreateWebResourceResponse:statusCode:reasonPhrase:headers:response:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
displayOn:!displaying!public! !
get_BrowserVersionString:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
get_UserDataFolder:!COM Interfaces-ICoreWebView2Environment7!private!properties! !
GetProcessInfos:!COM Interfaces-ICoreWebView2Environment8!methods!private! !
getProviderForHwnd:!methods!public! !
GetProviderForHwnd:provider:!COM Interfaces-ICoreWebView2Environment4!methods!private! !
printSettings!methods!public! !
processInfos!methods!public! !
Remove_BrowserProcessExited:!COM Interfaces-ICoreWebView2Environment5!events!private! !
Remove_NewBrowserVersionAvailable:!**auto generated**!COM Interfaces-ICoreWebView2Environment!events!private! !
Remove_ProcessInfosChanged:!COM Interfaces-ICoreWebView2Environment8!events!private! !
userDataFolder!properties!public! !
!

WebView2.ICoreWebView2Environment methodProtocol: #ICoreWebView2Environment attributes: #(#readOnly) selectors: #(#Add_NewBrowserVersionAvailable:token: #CreateCoreWebView2Controller:handler: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response: #get_BrowserVersionString: #Remove_NewBrowserVersionAvailable:)!
WebView2.ICoreWebView2Environment methodProtocol: #ICoreWebView2Environment2 attributes: #(#readOnly) selectors: #(#Add_NewBrowserVersionAvailable:token: #CreateCoreWebView2Controller:handler: #CreateWebResourceRequest:method:postData:headers:request: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response: #get_BrowserVersionString: #Remove_NewBrowserVersionAvailable:)!
WebView2.ICoreWebView2Environment methodProtocol: #ICoreWebView2Environment3 attributes: #(#readOnly) selectors: #(#Add_NewBrowserVersionAvailable:token: #CreateCoreWebView2CompositionController:handler: #CreateCoreWebView2Controller:handler: #CreateCoreWebView2PointerInfo: #CreateWebResourceRequest:method:postData:headers:request: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response: #get_BrowserVersionString: #Remove_NewBrowserVersionAvailable:)!
WebView2.ICoreWebView2Environment methodProtocol: #ICoreWebView2Environment4 attributes: #(#readOnly) selectors: #(#Add_NewBrowserVersionAvailable:token: #CreateCoreWebView2CompositionController:handler: #CreateCoreWebView2Controller:handler: #CreateCoreWebView2PointerInfo: #CreateWebResourceRequest:method:postData:headers:request: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response: #get_BrowserVersionString: #GetProviderForHwnd:provider: #Remove_NewBrowserVersionAvailable:)!
WebView2.ICoreWebView2Environment methodProtocol: #ICoreWebView2Environment5 attributes: #(#readOnly) selectors: #(#Add_BrowserProcessExited:token: #Add_NewBrowserVersionAvailable:token: #CreateCoreWebView2CompositionController:handler: #CreateCoreWebView2Controller:handler: #CreateCoreWebView2PointerInfo: #CreateWebResourceRequest:method:postData:headers:request: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response: #get_BrowserVersionString: #GetProviderForHwnd:provider: #Remove_BrowserProcessExited: #Remove_NewBrowserVersionAvailable:)!
WebView2.ICoreWebView2Environment methodProtocol: #ICoreWebView2Environment6 attributes: #(#readOnly) selectors: #(#Add_BrowserProcessExited:token: #Add_NewBrowserVersionAvailable:token: #CreateCoreWebView2CompositionController:handler: #CreateCoreWebView2Controller:handler: #CreateCoreWebView2PointerInfo: #CreatePrintSettings: #CreateWebResourceRequest:method:postData:headers:request: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response: #get_BrowserVersionString: #GetProviderForHwnd:provider: #Remove_BrowserProcessExited: #Remove_NewBrowserVersionAvailable:)!
WebView2.ICoreWebView2Environment methodProtocol: #ICoreWebView2Environment7 attributes: #(#readOnly) selectors: #(#Add_BrowserProcessExited:token: #Add_NewBrowserVersionAvailable:token: #CreateCoreWebView2CompositionController:handler: #CreateCoreWebView2Controller:handler: #CreateCoreWebView2PointerInfo: #CreatePrintSettings: #CreateWebResourceRequest:method:postData:headers:request: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response: #get_BrowserVersionString: #get_UserDataFolder: #GetProviderForHwnd:provider: #Remove_BrowserProcessExited: #Remove_NewBrowserVersionAvailable:)!
WebView2.ICoreWebView2Environment methodProtocol: #ICoreWebView2Environment8 attributes: #(#readOnly) selectors: #(#Add_BrowserProcessExited:token: #Add_NewBrowserVersionAvailable:token: #Add_ProcessInfosChanged:token: #CreateCoreWebView2CompositionController:handler: #CreateCoreWebView2Controller:handler: #CreateCoreWebView2PointerInfo: #CreatePrintSettings: #CreateWebResourceRequest:method:postData:headers:request: #CreateWebResourceResponse:statusCode:reasonPhrase:headers:response: #get_BrowserVersionString: #get_UserDataFolder: #GetProcessInfos: #GetProviderForHwnd:provider: #Remove_BrowserProcessExited: #Remove_NewBrowserVersionAvailable: #Remove_ProcessInfosChanged:)!

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
			argumentTypes: 'ICoreWebView2NewBrowserVersionAvailableEventHandler* sqword*';
		defineFunction: #Remove_NewBrowserVersionAvailable:
			argumentTypes: 'sqword'
! !
!WebView2.ICoreWebView2Environment class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public! !
!

