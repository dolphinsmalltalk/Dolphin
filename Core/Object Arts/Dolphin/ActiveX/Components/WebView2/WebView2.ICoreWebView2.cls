"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'WebView2.ICoreWebView2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2 guid: (OS.COM.IID fromString: '{76eceacb-0462-4d94-ac83-423a6793775e}')!
WebView2.ICoreWebView2 comment: '`ICoreWebView2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
[
	object, 
	uuid(76eceacb-0462-4d94-ac83-423a6793775e)
]
interface ICoreWebView2 : IUnknown
 {
	[id(0x60010000), propget]
	HRESULT __stdcall Settings(
		[out, retval]ICoreWebView2Settings** Settings);
	[id(0x60010001), propget]
	HRESULT __stdcall Source(
		[out, retval]LPWSTR* uri);
	[id(0x60010002)]
	HRESULT __stdcall Navigate(
		[in]LPWSTR uri);
	[id(0x60010003)]
	HRESULT __stdcall NavigateToString(
		[in]LPWSTR htmlContent);
	[id(0x60010004)]
	HRESULT __stdcall add_NavigationStarting(
		[in]ICoreWebView2NavigationStartingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010005)]
	HRESULT __stdcall remove_NavigationStarting(
		[in]EventRegistrationToken token);
	[id(0x60010006)]
	HRESULT __stdcall add_ContentLoading(
		[in]ICoreWebView2ContentLoadingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010007)]
	HRESULT __stdcall remove_ContentLoading(
		[in]EventRegistrationToken token);
	[id(0x60010008)]
	HRESULT __stdcall add_SourceChanged(
		[in]ICoreWebView2SourceChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010009)]
	HRESULT __stdcall remove_SourceChanged(
		[in]EventRegistrationToken token);
	[id(0x6001000a)]
	HRESULT __stdcall add_HistoryChanged(
		[in]ICoreWebView2HistoryChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001000b)]
	HRESULT __stdcall remove_HistoryChanged(
		[in]EventRegistrationToken token);
	[id(0x6001000c)]
	HRESULT __stdcall add_NavigationCompleted(
		[in]ICoreWebView2NavigationCompletedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001000d)]
	HRESULT __stdcall remove_NavigationCompleted(
		[in]EventRegistrationToken token);
	[id(0x6001000e)]
	HRESULT __stdcall add_FrameNavigationStarting(
		[in]ICoreWebView2NavigationStartingEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001000f)]
	HRESULT __stdcall remove_FrameNavigationStarting(
		[in]EventRegistrationToken token);
	[id(0x60010010)]
	HRESULT __stdcall add_FrameNavigationCompleted(
		[in]ICoreWebView2NavigationCompletedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010011)]
	HRESULT __stdcall remove_FrameNavigationCompleted(
		[in]EventRegistrationToken token);
	[id(0x60010012)]
	HRESULT __stdcall add_ScriptDialogOpening(
		[in]ICoreWebView2ScriptDialogOpeningEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010013)]
	HRESULT __stdcall remove_ScriptDialogOpening(
		[in]EventRegistrationToken token);
	[id(0x60010014)]
	HRESULT __stdcall add_PermissionRequested(
		[in]ICoreWebView2PermissionRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010015)]
	HRESULT __stdcall remove_PermissionRequested(
		[in]EventRegistrationToken token);
	[id(0x60010016)]
	HRESULT __stdcall add_ProcessFailed(
		[in]ICoreWebView2ProcessFailedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010017)]
	HRESULT __stdcall remove_ProcessFailed(
		[in]EventRegistrationToken token);
	[id(0x60010018)]
	HRESULT __stdcall AddScriptToExecuteOnDocumentCreated(
		[in]LPWSTR javaScript,
		[in]ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler* handler);
	[id(0x60010019)]
	HRESULT __stdcall RemoveScriptToExecuteOnDocumentCreated(
		[in]LPWSTR id);
	[id(0x6001001a)]
	HRESULT __stdcall ExecuteScript(
		[in]LPWSTR javaScript,
		[in]ICoreWebView2ExecuteScriptCompletedHandler* handler);
	[id(0x6001001b)]
	HRESULT __stdcall CapturePreview(
		[in]COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT imageFormat,
		[in]IStream* imageStream,
		[in]ICoreWebView2CapturePreviewCompletedHandler* handler);
	[id(0x6001001c)]
	HRESULT __stdcall Reload();
	[id(0x6001001d)]
	HRESULT __stdcall PostWebMessageAsJson(
		[in]LPWSTR webMessageAsJson);
	[id(0x6001001e)]
	HRESULT __stdcall PostWebMessageAsString(
		[in]LPWSTR webMessageAsString);
	[id(0x6001001f)]
	HRESULT __stdcall add_WebMessageReceived(
		[in]ICoreWebView2WebMessageReceivedEventHandler* handler,
		[out]EventRegistrationToken* token);
	[id(0x60010020)]
	HRESULT __stdcall remove_WebMessageReceived(
		[in]EventRegistrationToken token);
	[id(0x60010021)]
	HRESULT __stdcall CallDevToolsProtocolMethod(
		[in]LPWSTR methodName,
		[in]LPWSTR parametersAsJson,
		[in]ICoreWebView2CallDevToolsProtocolMethodCompletedHandler* handler);
	[id(0x60010022), propget]
	HRESULT __stdcall BrowserProcessId(
		[out, retval]unsigned int* value);
	[id(0x60010023), propget]
	HRESULT __stdcall CanGoBack(
		[out, retval]long* CanGoBack);
	[id(0x60010024), propget]
	HRESULT __stdcall CanGoForward(
		[out, retval]long* CanGoForward);
	[id(0x60010025)]
	HRESULT __stdcall GoBack();
	[id(0x60010026)]
	HRESULT __stdcall GoForward();
	[id(0x60010027)]
	HRESULT __stdcall GetDevToolsProtocolEventReceiver(
		[in]LPWSTR eventName,
		[out, retval]ICoreWebView2DevToolsProtocolEventReceiver** receiver);
	[id(0x60010028)]
	HRESULT __stdcall Stop();
	[id(0x60010029)]
	HRESULT __stdcall add_NewWindowRequested(
		[in]ICoreWebView2NewWindowRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001002a)]
	HRESULT __stdcall remove_NewWindowRequested(
		[in]EventRegistrationToken token);
	[id(0x6001002b)]
	HRESULT __stdcall add_DocumentTitleChanged(
		[in]ICoreWebView2DocumentTitleChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x6001002c)]
	HRESULT __stdcall remove_DocumentTitleChanged(
		[in]EventRegistrationToken token);
	[id(0x6001002d), propget]
	HRESULT __stdcall DocumentTitle(
		[out, retval]LPWSTR* title);
	[id(0x6001002e)]
	HRESULT __stdcall AddHostObjectToScript(
		[in]LPWSTR name,
		[in]VARIANT* object);
	[id(0x6001002f)]
	HRESULT __stdcall RemoveHostObjectFromScript(
		[in]LPWSTR name);
	[id(0x60010030)]
	HRESULT __stdcall OpenDevToolsWindow();
	[id(0x60010031)]
	HRESULT __stdcall add_ContainsFullScreenElementChanged(
		[in]ICoreWebView2ContainsFullScreenElementChangedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010032)]
	HRESULT __stdcall remove_ContainsFullScreenElementChanged(
		[in]EventRegistrationToken token);
	[id(0x60010033), propget]
	HRESULT __stdcall ContainsFullScreenElement(
		[out, retval]long* ContainsFullScreenElement);
	[id(0x60010034)]
	HRESULT __stdcall add_WebResourceRequested(
		[in]ICoreWebView2WebResourceRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010035)]
	HRESULT __stdcall remove_WebResourceRequested(
		[in]EventRegistrationToken token);
	[id(0x60010036)]
	HRESULT __stdcall AddWebResourceRequestedFilter(
		[in]LPWSTR uri,
		[in]COREWEBVIEW2_WEB_RESOURCE_CONTEXT ResourceContext);
	[id(0x60010037)]
	HRESULT __stdcall RemoveWebResourceRequestedFilter(
		[in]LPWSTR uri,
		[in]COREWEBVIEW2_WEB_RESOURCE_CONTEXT ResourceContext);
	[id(0x60010038)]
	HRESULT __stdcall add_WindowCloseRequested(
		[in]ICoreWebView2WindowCloseRequestedEventHandler* eventHandler,
		[out]EventRegistrationToken* token);
	[id(0x60010039)]
	HRESULT __stdcall remove_WindowCloseRequested(
		[in]EventRegistrationToken token);
};
```
'!
!WebView2.ICoreWebView2 categoriesForClass!COM-Interfaces!WebView2-Interfaces! !
!WebView2.ICoreWebView2 methodsFor!

add_ContainsFullScreenElementChanged: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_ContainsFullScreenElementChanged() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_ContainsFullScreenElementChanged: eventHandler token: answer.
	^answer asObject!

Add_ContainsFullScreenElementChanged: eventHandler token: token
	"Private - Invoke the add_ContainsFullScreenElementChanged() method of the COM object.

		HRESULT __stdcall add_ContainsFullScreenElementChanged(
			[in]ICoreWebView2ContainsFullScreenElementChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 53 ICoreWebView2ContainsFullScreenElementChangedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_ContentLoading: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_ContentLoading() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_ContentLoading: eventHandler token: answer.
	^answer asObject!

Add_ContentLoading: eventHandler token: token
	"Private - Invoke the add_ContentLoading() method of the COM object.

		HRESULT __stdcall add_ContentLoading(
			[in]ICoreWebView2ContentLoadingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 10 ICoreWebView2ContentLoadingEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_DocumentTitleChanged: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_DocumentTitleChanged() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_DocumentTitleChanged: eventHandler token: answer.
	^answer asObject!

Add_DocumentTitleChanged: eventHandler token: token
	"Private - Invoke the add_DocumentTitleChanged() method of the COM object.

		HRESULT __stdcall add_DocumentTitleChanged(
			[in]ICoreWebView2DocumentTitleChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 47 ICoreWebView2DocumentTitleChangedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_FrameNavigationCompleted: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_FrameNavigationCompleted() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_FrameNavigationCompleted: eventHandler token: answer.
	^answer asObject!

Add_FrameNavigationCompleted: eventHandler token: token
	"Private - Invoke the add_FrameNavigationCompleted() method of the COM object.

		HRESULT __stdcall add_FrameNavigationCompleted(
			[in]ICoreWebView2NavigationCompletedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 20 ICoreWebView2NavigationCompletedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_FrameNavigationStarting: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_FrameNavigationStarting() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_FrameNavigationStarting: eventHandler token: answer.
	^answer asObject!

Add_FrameNavigationStarting: eventHandler token: token
	"Private - Invoke the add_FrameNavigationStarting() method of the COM object.

		HRESULT __stdcall add_FrameNavigationStarting(
			[in]ICoreWebView2NavigationStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 18 ICoreWebView2NavigationStartingEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_HistoryChanged: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_HistoryChanged() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_HistoryChanged: eventHandler token: answer.
	^answer asObject!

Add_HistoryChanged: eventHandler token: token
	"Private - Invoke the add_HistoryChanged() method of the COM object.

		HRESULT __stdcall add_HistoryChanged(
			[in]ICoreWebView2HistoryChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 14 ICoreWebView2HistoryChangedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_NavigationCompleted: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_NavigationCompleted() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_NavigationCompleted: eventHandler token: answer.
	^answer asObject!

Add_NavigationCompleted: eventHandler token: token
	"Private - Invoke the add_NavigationCompleted() method of the COM object.

		HRESULT __stdcall add_NavigationCompleted(
			[in]ICoreWebView2NavigationCompletedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 16 ICoreWebView2NavigationCompletedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_NavigationStarting: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_NavigationStarting() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_NavigationStarting: eventHandler token: answer.
	^answer asObject!

Add_NavigationStarting: eventHandler token: token
	"Private - Invoke the add_NavigationStarting() method of the COM object.

		HRESULT __stdcall add_NavigationStarting(
			[in]ICoreWebView2NavigationStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 8 ICoreWebView2NavigationStartingEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_NewWindowRequested: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_NewWindowRequested() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_NewWindowRequested: eventHandler token: answer.
	^answer asObject!

Add_NewWindowRequested: eventHandler token: token
	"Private - Invoke the add_NewWindowRequested() method of the COM object.

		HRESULT __stdcall add_NewWindowRequested(
			[in]ICoreWebView2NewWindowRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 45 ICoreWebView2NewWindowRequestedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_PermissionRequested: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_PermissionRequested() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_PermissionRequested: eventHandler token: answer.
	^answer asObject!

Add_PermissionRequested: eventHandler token: token
	"Private - Invoke the add_PermissionRequested() method of the COM object.

		HRESULT __stdcall add_PermissionRequested(
			[in]ICoreWebView2PermissionRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 24 ICoreWebView2PermissionRequestedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_ProcessFailed: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_ProcessFailed() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_ProcessFailed: eventHandler token: answer.
	^answer asObject!

Add_ProcessFailed: eventHandler token: token
	"Private - Invoke the add_ProcessFailed() method of the COM object.

		HRESULT __stdcall add_ProcessFailed(
			[in]ICoreWebView2ProcessFailedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 26 ICoreWebView2ProcessFailedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_ScriptDialogOpening: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_ScriptDialogOpening() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_ScriptDialogOpening: eventHandler token: answer.
	^answer asObject!

Add_ScriptDialogOpening: eventHandler token: token
	"Private - Invoke the add_ScriptDialogOpening() method of the COM object.

		HRESULT __stdcall add_ScriptDialogOpening(
			[in]ICoreWebView2ScriptDialogOpeningEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 22 ICoreWebView2ScriptDialogOpeningEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_SourceChanged: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_SourceChanged() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_SourceChanged: eventHandler token: answer.
	^answer asObject!

Add_SourceChanged: eventHandler token: token
	"Private - Invoke the add_SourceChanged() method of the COM object.

		HRESULT __stdcall add_SourceChanged(
			[in]ICoreWebView2SourceChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 12 ICoreWebView2SourceChangedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_WebMessageReceived: handler
	"Answer the <EventRegistrationToken> result of invoking the add_WebMessageReceived() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_WebMessageReceived: handler token: answer.
	^answer asObject!

Add_WebMessageReceived: handler token: token
	"Private - Invoke the add_WebMessageReceived() method of the COM object.

		HRESULT __stdcall add_WebMessageReceived(
			[in]ICoreWebView2WebMessageReceivedEventHandler* handler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 35 ICoreWebView2WebMessageReceivedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_WebResourceRequested: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_WebResourceRequested() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_WebResourceRequested: eventHandler token: answer.
	^answer asObject!

Add_WebResourceRequested: eventHandler token: token
	"Private - Invoke the add_WebResourceRequested() method of the COM object.

		HRESULT __stdcall add_WebResourceRequested(
			[in]ICoreWebView2WebResourceRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 56 ICoreWebView2WebResourceRequestedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

add_WindowCloseRequested: eventHandler
	"Answer the <EventRegistrationToken> result of invoking the add_WindowCloseRequested() method of the COM object."

	| answer |
	answer := EventRegistrationToken new.
	self Add_WindowCloseRequested: eventHandler token: answer.
	^answer asObject!

Add_WindowCloseRequested: eventHandler token: token
	"Private - Invoke the add_WindowCloseRequested() method of the COM object.

		HRESULT __stdcall add_WindowCloseRequested(
			[in]ICoreWebView2WindowCloseRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 60 ICoreWebView2WindowCloseRequestedEventHandler* EventRegistrationToken*>
	^self invalidCall: _failureCode!

addHostObjectToScript: name object: object
	"Invoke the AddHostObjectToScript() method of the COM object."

	^self AddHostObjectToScript: name asUtf16String object: object asVariant!

AddHostObjectToScript: name object: object
	"Private - Invoke the AddHostObjectToScript() method of the COM object.

		HRESULT __stdcall AddHostObjectToScript(
			[in]LPWSTR name,
			[in]VARIANT* object);"

	<virtual stdcall: hresult 50 lpwstr variant*>
	^self invalidCall: _failureCode!

addScriptToExecuteOnDocumentCreated: javaScript handler: handler
	"Invoke the AddScriptToExecuteOnDocumentCreated() method of the COM object."

	^self AddScriptToExecuteOnDocumentCreated: javaScript asUtf16String handler: handler!

AddScriptToExecuteOnDocumentCreated: javaScript handler: handler
	"Private - Invoke the AddScriptToExecuteOnDocumentCreated() method of the COM object.

		HRESULT __stdcall AddScriptToExecuteOnDocumentCreated(
			[in]LPWSTR javaScript,
			[in]ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler* handler);"

	<virtual stdcall: hresult 28 lpwstr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler*>
	^self invalidCall: _failureCode!

addWebResourceRequestedFilter: uri resourceContext: resourceContext
	"Invoke the AddWebResourceRequestedFilter() method of the COM object."

	^self AddWebResourceRequestedFilter: uri asUtf16String resourceContext: resourceContext!

AddWebResourceRequestedFilter: uri resourceContext: resourceContext
	"Private - Invoke the AddWebResourceRequestedFilter() method of the COM object.

		HRESULT __stdcall AddWebResourceRequestedFilter(
			[in]LPWSTR uri,
			[in]COREWEBVIEW2_WEB_RESOURCE_CONTEXT ResourceContext);"

	<virtual stdcall: hresult 58 lpwstr sdword>
	^self invalidCall: _failureCode!

browserProcessId
	"Answer the <dword> value of the 'BrowserProcessId' property of the receiver."

	| answer |
	answer := DWORD new.
	self get_BrowserProcessId: answer.
	^answer asObject!

callDevToolsProtocolMethod: methodName parametersAsJson: parametersAsJson handler: handler
	"Invoke the CallDevToolsProtocolMethod() method of the COM object."

	^self
		CallDevToolsProtocolMethod: methodName asUtf16String
		parametersAsJson: parametersAsJson asUtf16String
		handler: handler!

CallDevToolsProtocolMethod: methodName parametersAsJson: parametersAsJson handler: handler
	"Private - Invoke the CallDevToolsProtocolMethod() method of the COM object.

		HRESULT __stdcall CallDevToolsProtocolMethod(
			[in]LPWSTR methodName,
			[in]LPWSTR parametersAsJson,
			[in]ICoreWebView2CallDevToolsProtocolMethodCompletedHandler* handler);"

	<virtual stdcall: hresult 37 lpwstr lpwstr ICoreWebView2CallDevToolsProtocolMethodCompletedHandler*>
	^self invalidCall: _failureCode!

canGoBack
	"Answer the <sdword> value of the 'CanGoBack' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CanGoBack: answer.
	^answer asObject!

canGoForward
	"Answer the <sdword> value of the 'CanGoForward' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_CanGoForward: answer.
	^answer asObject!

capturePreview: imageFormat imageStream: imageStream handler: handler
	"Invoke the CapturePreview() method of the COM object."

	^self
		CapturePreview: imageFormat
		imageStream: imageStream
		handler: handler!

CapturePreview: imageFormat imageStream: imageStream handler: handler
	"Private - Invoke the CapturePreview() method of the COM object.

		HRESULT __stdcall CapturePreview(
			[in]COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT imageFormat,
			[in]IStream* imageStream,
			[in]ICoreWebView2CapturePreviewCompletedHandler* handler);"

	<virtual stdcall: hresult 31 sdword IStream* ICoreWebView2CapturePreviewCompletedHandler*>
	^self invalidCall: _failureCode!

containsFullScreenElement
	"Answer the <sdword> value of the 'ContainsFullScreenElement' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_ContainsFullScreenElement: answer.
	^answer asObject!

documentTitle
	"Answer the <lpwstr> value of the 'DocumentTitle' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_DocumentTitle: answer.
	^answer asObject!

executeScript: javaScript handler: handler
	"Invoke the ExecuteScript() method of the COM object."

	^self ExecuteScript: javaScript asUtf16String handler: handler!

ExecuteScript: javaScript handler: handler
	"Private - Invoke the ExecuteScript() method of the COM object.

		HRESULT __stdcall ExecuteScript(
			[in]LPWSTR javaScript,
			[in]ICoreWebView2ExecuteScriptCompletedHandler* handler);"

	<virtual stdcall: hresult 30 lpwstr ICoreWebView2ExecuteScriptCompletedHandler*>
	^self invalidCall: _failureCode!

get_BrowserProcessId: value
	"Private - Get the value of the 'BrowserProcessId' property of the receiver.

		HRESULT __stdcall BrowserProcessId(
			[out, retval]unsigned int* value);"

	<virtual stdcall: hresult 38 dword*>
	^self invalidCall: _failureCode!

get_CanGoBack: canGoBack
	"Private - Get the value of the 'CanGoBack' property of the receiver.

		HRESULT __stdcall CanGoBack(
			[out, retval]long* CanGoBack);"

	<virtual stdcall: hresult 39 sdword*>
	^self invalidCall: _failureCode!

get_CanGoForward: canGoForward
	"Private - Get the value of the 'CanGoForward' property of the receiver.

		HRESULT __stdcall CanGoForward(
			[out, retval]long* CanGoForward);"

	<virtual stdcall: hresult 40 sdword*>
	^self invalidCall: _failureCode!

get_ContainsFullScreenElement: containsFullScreenElement
	"Private - Get the value of the 'ContainsFullScreenElement' property of the receiver.

		HRESULT __stdcall ContainsFullScreenElement(
			[out, retval]long* ContainsFullScreenElement);"

	<virtual stdcall: hresult 55 sdword*>
	^self invalidCall: _failureCode!

get_DocumentTitle: title
	"Private - Get the value of the 'DocumentTitle' property of the receiver.

		HRESULT __stdcall DocumentTitle(
			[out, retval]LPWSTR* title);"

	<virtual stdcall: hresult 49 lpwstr*>
	^self invalidCall: _failureCode!

get_Settings: settings
	"Private - Get the value of the 'Settings' property of the receiver.

		HRESULT __stdcall Settings(
			[out, retval]ICoreWebView2Settings** Settings);"

	<virtual stdcall: hresult 4 ICoreWebView2Settings**>
	^self invalidCall: _failureCode!

get_Source: uri
	"Private - Get the value of the 'Source' property of the receiver.

		HRESULT __stdcall Source(
			[out, retval]LPWSTR* uri);"

	<virtual stdcall: hresult 5 lpwstr*>
	^self invalidCall: _failureCode!

getDevToolsProtocolEventReceiver: eventName
	"Answer the <ICoreWebView2DevToolsProtocolEventReceiver> result of invoking the GetDevToolsProtocolEventReceiver() method of the COM object."

	| answer |
	answer := ICoreWebView2DevToolsProtocolEventReceiver newPointer.
	self GetDevToolsProtocolEventReceiver: eventName asUtf16String receiver: answer.
	^answer asObject!

GetDevToolsProtocolEventReceiver: eventName receiver: receiver
	"Private - Invoke the GetDevToolsProtocolEventReceiver() method of the COM object.

		HRESULT __stdcall GetDevToolsProtocolEventReceiver(
			[in]LPWSTR eventName,
			[out, retval]ICoreWebView2DevToolsProtocolEventReceiver** receiver);"

	<virtual stdcall: hresult 43 lpwstr ICoreWebView2DevToolsProtocolEventReceiver**>
	^self invalidCall: _failureCode!

goBack
	"Invoke the GoBack() method of the COM object."

	^self GoBack!

GoBack
	"Private - Invoke the GoBack() method of the COM object.

		HRESULT __stdcall GoBack();"

	<virtual stdcall: hresult 41>
	^self invalidCall: _failureCode!

goForward
	"Invoke the GoForward() method of the COM object."

	^self GoForward!

GoForward
	"Private - Invoke the GoForward() method of the COM object.

		HRESULT __stdcall GoForward();"

	<virtual stdcall: hresult 42>
	^self invalidCall: _failureCode!

navigate: uri
	"Invoke the Navigate() method of the COM object."

	^self Navigate: uri asUtf16String!

Navigate: uri
	"Private - Invoke the Navigate() method of the COM object.

		HRESULT __stdcall Navigate(
			[in]LPWSTR uri);"

	<virtual stdcall: hresult 6 lpwstr>
	^self invalidCall: _failureCode!

navigateToString: htmlContent
	"Invoke the NavigateToString() method of the COM object."

	^self NavigateToString: htmlContent asUtf16String!

NavigateToString: htmlContent
	"Private - Invoke the NavigateToString() method of the COM object.

		HRESULT __stdcall NavigateToString(
			[in]LPWSTR htmlContent);"

	<virtual stdcall: hresult 7 lpwstr>
	^self invalidCall: _failureCode!

openDevToolsWindow
	"Invoke the OpenDevToolsWindow() method of the COM object."

	^self OpenDevToolsWindow!

OpenDevToolsWindow
	"Private - Invoke the OpenDevToolsWindow() method of the COM object.

		HRESULT __stdcall OpenDevToolsWindow();"

	<virtual stdcall: hresult 52>
	^self invalidCall: _failureCode!

postWebMessageAsJson: webMessageAsJson
	"Invoke the PostWebMessageAsJson() method of the COM object."

	^self PostWebMessageAsJson: webMessageAsJson asUtf16String!

PostWebMessageAsJson: webMessageAsJson
	"Private - Invoke the PostWebMessageAsJson() method of the COM object.

		HRESULT __stdcall PostWebMessageAsJson(
			[in]LPWSTR webMessageAsJson);"

	<virtual stdcall: hresult 33 lpwstr>
	^self invalidCall: _failureCode!

postWebMessageAsString: webMessageAsString
	"Invoke the PostWebMessageAsString() method of the COM object."

	^self PostWebMessageAsString: webMessageAsString asUtf16String!

PostWebMessageAsString: webMessageAsString
	"Private - Invoke the PostWebMessageAsString() method of the COM object.

		HRESULT __stdcall PostWebMessageAsString(
			[in]LPWSTR webMessageAsString);"

	<virtual stdcall: hresult 34 lpwstr>
	^self invalidCall: _failureCode!

reload
	"Invoke the Reload() method of the COM object."

	^self Reload!

Reload
	"Private - Invoke the Reload() method of the COM object.

		HRESULT __stdcall Reload();"

	<virtual stdcall: hresult 32>
	^self invalidCall: _failureCode!

remove_ContainsFullScreenElementChanged: token
	"Invoke the remove_ContainsFullScreenElementChanged() method of the COM object."

	^self Remove_ContainsFullScreenElementChanged: token!

Remove_ContainsFullScreenElementChanged: token
	"Private - Invoke the remove_ContainsFullScreenElementChanged() method of the COM object.

		HRESULT __stdcall remove_ContainsFullScreenElementChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 54 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_ContentLoading: token
	"Invoke the remove_ContentLoading() method of the COM object."

	^self Remove_ContentLoading: token!

Remove_ContentLoading: token
	"Private - Invoke the remove_ContentLoading() method of the COM object.

		HRESULT __stdcall remove_ContentLoading(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 11 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_DocumentTitleChanged: token
	"Invoke the remove_DocumentTitleChanged() method of the COM object."

	^self Remove_DocumentTitleChanged: token!

Remove_DocumentTitleChanged: token
	"Private - Invoke the remove_DocumentTitleChanged() method of the COM object.

		HRESULT __stdcall remove_DocumentTitleChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 48 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_FrameNavigationCompleted: token
	"Invoke the remove_FrameNavigationCompleted() method of the COM object."

	^self Remove_FrameNavigationCompleted: token!

Remove_FrameNavigationCompleted: token
	"Private - Invoke the remove_FrameNavigationCompleted() method of the COM object.

		HRESULT __stdcall remove_FrameNavigationCompleted(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 21 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_FrameNavigationStarting: token
	"Invoke the remove_FrameNavigationStarting() method of the COM object."

	^self Remove_FrameNavigationStarting: token!

Remove_FrameNavigationStarting: token
	"Private - Invoke the remove_FrameNavigationStarting() method of the COM object.

		HRESULT __stdcall remove_FrameNavigationStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 19 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_HistoryChanged: token
	"Invoke the remove_HistoryChanged() method of the COM object."

	^self Remove_HistoryChanged: token!

Remove_HistoryChanged: token
	"Private - Invoke the remove_HistoryChanged() method of the COM object.

		HRESULT __stdcall remove_HistoryChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 15 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_NavigationCompleted: token
	"Invoke the remove_NavigationCompleted() method of the COM object."

	^self Remove_NavigationCompleted: token!

Remove_NavigationCompleted: token
	"Private - Invoke the remove_NavigationCompleted() method of the COM object.

		HRESULT __stdcall remove_NavigationCompleted(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 17 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_NavigationStarting: token
	"Invoke the remove_NavigationStarting() method of the COM object."

	^self Remove_NavigationStarting: token!

Remove_NavigationStarting: token
	"Private - Invoke the remove_NavigationStarting() method of the COM object.

		HRESULT __stdcall remove_NavigationStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 9 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_NewWindowRequested: token
	"Invoke the remove_NewWindowRequested() method of the COM object."

	^self Remove_NewWindowRequested: token!

Remove_NewWindowRequested: token
	"Private - Invoke the remove_NewWindowRequested() method of the COM object.

		HRESULT __stdcall remove_NewWindowRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 46 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_PermissionRequested: token
	"Invoke the remove_PermissionRequested() method of the COM object."

	^self Remove_PermissionRequested: token!

Remove_PermissionRequested: token
	"Private - Invoke the remove_PermissionRequested() method of the COM object.

		HRESULT __stdcall remove_PermissionRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 25 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_ProcessFailed: token
	"Invoke the remove_ProcessFailed() method of the COM object."

	^self Remove_ProcessFailed: token!

Remove_ProcessFailed: token
	"Private - Invoke the remove_ProcessFailed() method of the COM object.

		HRESULT __stdcall remove_ProcessFailed(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 27 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_ScriptDialogOpening: token
	"Invoke the remove_ScriptDialogOpening() method of the COM object."

	^self Remove_ScriptDialogOpening: token!

Remove_ScriptDialogOpening: token
	"Private - Invoke the remove_ScriptDialogOpening() method of the COM object.

		HRESULT __stdcall remove_ScriptDialogOpening(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 23 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_SourceChanged: token
	"Invoke the remove_SourceChanged() method of the COM object."

	^self Remove_SourceChanged: token!

Remove_SourceChanged: token
	"Private - Invoke the remove_SourceChanged() method of the COM object.

		HRESULT __stdcall remove_SourceChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 13 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_WebMessageReceived: token
	"Invoke the remove_WebMessageReceived() method of the COM object."

	^self Remove_WebMessageReceived: token!

Remove_WebMessageReceived: token
	"Private - Invoke the remove_WebMessageReceived() method of the COM object.

		HRESULT __stdcall remove_WebMessageReceived(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 36 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_WebResourceRequested: token
	"Invoke the remove_WebResourceRequested() method of the COM object."

	^self Remove_WebResourceRequested: token!

Remove_WebResourceRequested: token
	"Private - Invoke the remove_WebResourceRequested() method of the COM object.

		HRESULT __stdcall remove_WebResourceRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 57 EventRegistrationToken>
	^self invalidCall: _failureCode!

remove_WindowCloseRequested: token
	"Invoke the remove_WindowCloseRequested() method of the COM object."

	^self Remove_WindowCloseRequested: token!

Remove_WindowCloseRequested: token
	"Private - Invoke the remove_WindowCloseRequested() method of the COM object.

		HRESULT __stdcall remove_WindowCloseRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 61 EventRegistrationToken>
	^self invalidCall: _failureCode!

removeHostObjectFromScript: name
	"Invoke the RemoveHostObjectFromScript() method of the COM object."

	^self RemoveHostObjectFromScript: name asUtf16String!

RemoveHostObjectFromScript: name
	"Private - Invoke the RemoveHostObjectFromScript() method of the COM object.

		HRESULT __stdcall RemoveHostObjectFromScript(
			[in]LPWSTR name);"

	<virtual stdcall: hresult 51 lpwstr>
	^self invalidCall: _failureCode!

removeScriptToExecuteOnDocumentCreated: id
	"Invoke the RemoveScriptToExecuteOnDocumentCreated() method of the COM object."

	^self RemoveScriptToExecuteOnDocumentCreated: id asUtf16String!

RemoveScriptToExecuteOnDocumentCreated: id
	"Private - Invoke the RemoveScriptToExecuteOnDocumentCreated() method of the COM object.

		HRESULT __stdcall RemoveScriptToExecuteOnDocumentCreated(
			[in]LPWSTR id);"

	<virtual stdcall: hresult 29 lpwstr>
	^self invalidCall: _failureCode!

removeWebResourceRequestedFilter: uri resourceContext: resourceContext
	"Invoke the RemoveWebResourceRequestedFilter() method of the COM object."

	^self RemoveWebResourceRequestedFilter: uri asUtf16String resourceContext: resourceContext!

RemoveWebResourceRequestedFilter: uri resourceContext: resourceContext
	"Private - Invoke the RemoveWebResourceRequestedFilter() method of the COM object.

		HRESULT __stdcall RemoveWebResourceRequestedFilter(
			[in]LPWSTR uri,
			[in]COREWEBVIEW2_WEB_RESOURCE_CONTEXT ResourceContext);"

	<virtual stdcall: hresult 59 lpwstr sdword>
	^self invalidCall: _failureCode!

settings
	"Answer the <ICoreWebView2Settings> value of the 'Settings' property of the receiver."

	| answer |
	answer := ICoreWebView2Settings newPointer.
	self get_Settings: answer.
	^answer asObject!

source
	"Answer the <lpwstr> value of the 'Source' property of the receiver."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self get_Source: answer.
	^answer asObject!

stop
	"Invoke the Stop() method of the COM object."

	^self Stop!

Stop
	"Private - Invoke the Stop() method of the COM object.

		HRESULT __stdcall Stop();"

	<virtual stdcall: hresult 44>
	^self invalidCall: _failureCode! !
!WebView2.ICoreWebView2 categoriesFor: #add_ContainsFullScreenElementChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_ContainsFullScreenElementChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_ContentLoading:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_ContentLoading:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_DocumentTitleChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_DocumentTitleChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_FrameNavigationCompleted:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_FrameNavigationCompleted:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_FrameNavigationStarting:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_FrameNavigationStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_HistoryChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_HistoryChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_NavigationCompleted:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_NavigationCompleted:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_NavigationStarting:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_NavigationStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_NewWindowRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_NewWindowRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_PermissionRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_PermissionRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_ProcessFailed:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_ProcessFailed:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_ScriptDialogOpening:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_ScriptDialogOpening:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_SourceChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_SourceChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_WebMessageReceived:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_WebMessageReceived:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_WebResourceRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_WebResourceRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #add_WindowCloseRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Add_WindowCloseRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #addHostObjectToScript:object:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #AddHostObjectToScript:object:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #addScriptToExecuteOnDocumentCreated:handler:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #AddScriptToExecuteOnDocumentCreated:handler:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #addWebResourceRequestedFilter:resourceContext:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #AddWebResourceRequestedFilter:resourceContext:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #browserProcessId!**auto generated**!properties!public! !
!WebView2.ICoreWebView2 categoriesFor: #callDevToolsProtocolMethod:parametersAsJson:handler:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #CallDevToolsProtocolMethod:parametersAsJson:handler:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #canGoBack!**auto generated**!properties!public! !
!WebView2.ICoreWebView2 categoriesFor: #canGoForward!**auto generated**!properties!public! !
!WebView2.ICoreWebView2 categoriesFor: #capturePreview:imageStream:handler:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #CapturePreview:imageStream:handler:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #containsFullScreenElement!**auto generated**!properties!public! !
!WebView2.ICoreWebView2 categoriesFor: #documentTitle!**auto generated**!properties!public! !
!WebView2.ICoreWebView2 categoriesFor: #executeScript:handler:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #ExecuteScript:handler:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #get_BrowserProcessId:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #get_CanGoBack:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #get_CanGoForward:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #get_ContainsFullScreenElement:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #get_DocumentTitle:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #get_Settings:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #get_Source:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #getDevToolsProtocolEventReceiver:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #GetDevToolsProtocolEventReceiver:receiver:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #goBack!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #GoBack!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #goForward!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #GoForward!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #navigate:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Navigate:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #navigateToString:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #NavigateToString:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #openDevToolsWindow!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #OpenDevToolsWindow!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #postWebMessageAsJson:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #PostWebMessageAsJson:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #postWebMessageAsString:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #PostWebMessageAsString:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #reload!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Reload!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_ContainsFullScreenElementChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_ContainsFullScreenElementChanged:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_ContentLoading:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_ContentLoading:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_DocumentTitleChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_DocumentTitleChanged:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_FrameNavigationCompleted:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_FrameNavigationCompleted:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_FrameNavigationStarting:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_FrameNavigationStarting:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_HistoryChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_HistoryChanged:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_NavigationCompleted:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_NavigationCompleted:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_NavigationStarting:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_NavigationStarting:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_NewWindowRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_NewWindowRequested:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_PermissionRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_PermissionRequested:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_ProcessFailed:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_ProcessFailed:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_ScriptDialogOpening:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_ScriptDialogOpening:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_SourceChanged:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_SourceChanged:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_WebMessageReceived:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_WebMessageReceived:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_WebResourceRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_WebResourceRequested:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #remove_WindowCloseRequested:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Remove_WindowCloseRequested:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #removeHostObjectFromScript:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #RemoveHostObjectFromScript:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #removeScriptToExecuteOnDocumentCreated:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #RemoveScriptToExecuteOnDocumentCreated:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #removeWebResourceRequestedFilter:resourceContext:!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #RemoveWebResourceRequestedFilter:resourceContext:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
!WebView2.ICoreWebView2 categoriesFor: #settings!**auto generated**!properties!public! !
!WebView2.ICoreWebView2 categoriesFor: #source!**auto generated**!properties!public! !
!WebView2.ICoreWebView2 categoriesFor: #stop!**auto generated**!methods!public! !
!WebView2.ICoreWebView2 categoriesFor: #Stop!**auto generated**!COM Interfaces-ICoreWebView2!private! !

!WebView2.ICoreWebView2 class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.ICoreWebView2'
		ICoreWebView2 defineTemplate"

	self
		defineFunction: #get_Settings:
			argumentTypes: 'ICoreWebView2Settings**';
		defineFunction: #get_Source:
			argumentTypes: 'lpwstr*';
		defineFunction: #Navigate:
			argumentTypes: 'lpwstr';
		defineFunction: #NavigateToString:
			argumentTypes: 'lpwstr';
		defineFunction: #Add_NavigationStarting:token:
			argumentTypes: 'ICoreWebView2NavigationStartingEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_NavigationStarting:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_ContentLoading:token:
			argumentTypes: 'ICoreWebView2ContentLoadingEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_ContentLoading:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_SourceChanged:token:
			argumentTypes: 'ICoreWebView2SourceChangedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_SourceChanged:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_HistoryChanged:token:
			argumentTypes: 'ICoreWebView2HistoryChangedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_HistoryChanged:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_NavigationCompleted:token:
			argumentTypes: 'ICoreWebView2NavigationCompletedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_NavigationCompleted:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_FrameNavigationStarting:token:
			argumentTypes: 'ICoreWebView2NavigationStartingEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_FrameNavigationStarting:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_FrameNavigationCompleted:token:
			argumentTypes: 'ICoreWebView2NavigationCompletedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_FrameNavigationCompleted:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_ScriptDialogOpening:token:
			argumentTypes: 'ICoreWebView2ScriptDialogOpeningEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_ScriptDialogOpening:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_PermissionRequested:token:
			argumentTypes: 'ICoreWebView2PermissionRequestedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_PermissionRequested:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_ProcessFailed:token:
			argumentTypes: 'ICoreWebView2ProcessFailedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_ProcessFailed:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #AddScriptToExecuteOnDocumentCreated:handler:
			argumentTypes: 'lpwstr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler*';
		defineFunction: #RemoveScriptToExecuteOnDocumentCreated:
			argumentTypes: 'lpwstr';
		defineFunction: #ExecuteScript:handler:
			argumentTypes: 'lpwstr ICoreWebView2ExecuteScriptCompletedHandler*';
		defineFunction: #CapturePreview:imageStream:handler:
			argumentTypes: 'sdword IStream* ICoreWebView2CapturePreviewCompletedHandler*';
		defineFunction: #Reload;
		defineFunction: #PostWebMessageAsJson:
			argumentTypes: 'lpwstr';
		defineFunction: #PostWebMessageAsString:
			argumentTypes: 'lpwstr';
		defineFunction: #Add_WebMessageReceived:token:
			argumentTypes: 'ICoreWebView2WebMessageReceivedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_WebMessageReceived:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #CallDevToolsProtocolMethod:parametersAsJson:handler:
			argumentTypes: 'lpwstr lpwstr ICoreWebView2CallDevToolsProtocolMethodCompletedHandler*';
		defineFunction: #get_BrowserProcessId:
			argumentTypes: 'dword*';
		defineFunction: #get_CanGoBack:
			argumentTypes: 'sdword*';
		defineFunction: #get_CanGoForward:
			argumentTypes: 'sdword*';
		defineFunction: #GoBack;
		defineFunction: #GoForward;
		defineFunction: #GetDevToolsProtocolEventReceiver:receiver:
			argumentTypes: 'lpwstr ICoreWebView2DevToolsProtocolEventReceiver**';
		defineFunction: #Stop;
		defineFunction: #Add_NewWindowRequested:token:
			argumentTypes: 'ICoreWebView2NewWindowRequestedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_NewWindowRequested:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #Add_DocumentTitleChanged:token:
			argumentTypes: 'ICoreWebView2DocumentTitleChangedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_DocumentTitleChanged:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #get_DocumentTitle:
			argumentTypes: 'lpwstr*';
		defineFunction: #AddHostObjectToScript:object:
			argumentTypes: 'lpwstr variant*';
		defineFunction: #RemoveHostObjectFromScript:
			argumentTypes: 'lpwstr';
		defineFunction: #OpenDevToolsWindow;
		defineFunction: #Add_ContainsFullScreenElementChanged:token:
			argumentTypes: 'ICoreWebView2ContainsFullScreenElementChangedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_ContainsFullScreenElementChanged:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #get_ContainsFullScreenElement:
			argumentTypes: 'sdword*';
		defineFunction: #Add_WebResourceRequested:token:
			argumentTypes: 'ICoreWebView2WebResourceRequestedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_WebResourceRequested:
			argumentTypes: 'EventRegistrationToken';
		defineFunction: #AddWebResourceRequestedFilter:resourceContext:
			argumentTypes: 'lpwstr sdword';
		defineFunction: #RemoveWebResourceRequestedFilter:resourceContext:
			argumentTypes: 'lpwstr sdword';
		defineFunction: #Add_WindowCloseRequested:token:
			argumentTypes: 'ICoreWebView2WindowCloseRequestedEventHandler* EventRegistrationToken*';
		defineFunction: #Remove_WindowCloseRequested:
			argumentTypes: 'EventRegistrationToken'
! !
!WebView2.ICoreWebView2 class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

