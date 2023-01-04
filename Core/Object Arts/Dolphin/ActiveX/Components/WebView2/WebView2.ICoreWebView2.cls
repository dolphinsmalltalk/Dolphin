"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface subclass: #'WebView2.ICoreWebView2'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
WebView2.ICoreWebView2 guid: (OS.COM.IID fromString: '{76eceacb-0462-4d94-ac83-423a6793775e}')!
WebView2.ICoreWebView2 comment: '`ICoreWebView2` is a wrapper class for the COM interface ''WebView2.ICoreWebView2'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

At the time of writing there are eight (!!) later versions of this interface. In order to reduce the burden of degrading gracefully to older versions, default implementations of the additional methods and properties are added.

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

Add_BasicAuthenticationRequested: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_ClientCertificateRequested: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_ContainsFullScreenElementChanged: eventHandler token: token
	"Private - Invoke the add_ContainsFullScreenElementChanged() method of the COM object.

		HRESULT __stdcall add_ContainsFullScreenElementChanged(
			[in]ICoreWebView2ContainsFullScreenElementChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 53 ICoreWebView2ContainsFullScreenElementChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_ContentLoading: eventHandler token: token
	"Private - Invoke the add_ContentLoading() method of the COM object.

		HRESULT __stdcall add_ContentLoading(
			[in]ICoreWebView2ContentLoadingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 10 ICoreWebView2ContentLoadingEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_ContextMenuRequested: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_DocumentTitleChanged: eventHandler token: token
	"Private - Invoke the add_DocumentTitleChanged() method of the COM object.

		HRESULT __stdcall add_DocumentTitleChanged(
			[in]ICoreWebView2DocumentTitleChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 47 ICoreWebView2DocumentTitleChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_DOMContentLoaded: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_DownloadStarting: eventHandler token: token
	"Not supported by this version"

	^E_NOTIMPL!

Add_FaviconChanged: eventHandler token: token
	"Not supported by this version"

	^E_NOTIMPL!

Add_FrameCreated: eventHandler token: token
	"Not supported by this version"

	^E_NOTIMPL!

Add_FrameNavigationCompleted: eventHandler token: token
	"Private - Invoke the add_FrameNavigationCompleted() method of the COM object.

		HRESULT __stdcall add_FrameNavigationCompleted(
			[in]ICoreWebView2NavigationCompletedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 20 ICoreWebView2NavigationCompletedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_FrameNavigationStarting: eventHandler token: token
	"Private - Invoke the add_FrameNavigationStarting() method of the COM object.

		HRESULT __stdcall add_FrameNavigationStarting(
			[in]ICoreWebView2NavigationStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 18 ICoreWebView2NavigationStartingEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_HistoryChanged: eventHandler token: token
	"Private - Invoke the add_HistoryChanged() method of the COM object.

		HRESULT __stdcall add_HistoryChanged(
			[in]ICoreWebView2HistoryChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 14 ICoreWebView2HistoryChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_IsDefaultDownloadDialogOpenChanged: handler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_IsDocumentPlayingAudioChanged: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_IsMutedChanged: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_NavigationCompleted: eventHandler token: token
	"Private - Invoke the add_NavigationCompleted() method of the COM object.

		HRESULT __stdcall add_NavigationCompleted(
			[in]ICoreWebView2NavigationCompletedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 16 ICoreWebView2NavigationCompletedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_NavigationStarting: eventHandler token: token
	"Private - Invoke the add_NavigationStarting() method of the COM object.

		HRESULT __stdcall add_NavigationStarting(
			[in]ICoreWebView2NavigationStartingEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 8 ICoreWebView2NavigationStartingEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_NewWindowRequested: eventHandler token: token
	"Private - Invoke the add_NewWindowRequested() method of the COM object.

		HRESULT __stdcall add_NewWindowRequested(
			[in]ICoreWebView2NewWindowRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 45 ICoreWebView2NewWindowRequestedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_PermissionRequested: eventHandler token: token
	"Private - Invoke the add_PermissionRequested() method of the COM object.

		HRESULT __stdcall add_PermissionRequested(
			[in]ICoreWebView2PermissionRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 24 ICoreWebView2PermissionRequestedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_ProcessFailed: eventHandler token: token
	"Private - Invoke the add_ProcessFailed() method of the COM object.

		HRESULT __stdcall add_ProcessFailed(
			[in]ICoreWebView2ProcessFailedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 26 ICoreWebView2ProcessFailedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_ScriptDialogOpening: eventHandler token: token
	"Private - Invoke the add_ScriptDialogOpening() method of the COM object.

		HRESULT __stdcall add_ScriptDialogOpening(
			[in]ICoreWebView2ScriptDialogOpeningEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 22 ICoreWebView2ScriptDialogOpeningEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_ServerCertificateErrorDetected: eventHandler token: token
	"Private - Invoke the add_ServerCertificateErrorDetected() method of the COM object.

		HRESULT __stdcall add_ServerCertificateErrorDetected(
			[in]ICoreWebView2ServerCertificateErrorDetectedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	^E_NOTIMPL!

Add_SourceChanged: eventHandler token: token
	"Private - Invoke the add_SourceChanged() method of the COM object.

		HRESULT __stdcall add_SourceChanged(
			[in]ICoreWebView2SourceChangedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 12 ICoreWebView2SourceChangedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_StatusBarTextChanged: eventHandler token: token
	"Not supported at this level"

	^E_NOTIMPL!

Add_WebMessageReceived: handler token: token
	"Private - Invoke the add_WebMessageReceived() method of the COM object.

		HRESULT __stdcall add_WebMessageReceived(
			[in]ICoreWebView2WebMessageReceivedEventHandler* handler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 35 ICoreWebView2WebMessageReceivedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_WebResourceRequested: eventHandler token: token
	"Private - Invoke the add_WebResourceRequested() method of the COM object.

		HRESULT __stdcall add_WebResourceRequested(
			[in]ICoreWebView2WebResourceRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 56 ICoreWebView2WebResourceRequestedEventHandler* sqword*>
	^self invalidCall: _failureCode!

Add_WebResourceResponseReceived: eventHandler token: token
	"Not supported by this version"

	^E_NOTIMPL!

Add_WindowCloseRequested: eventHandler token: token
	"Private - Invoke the add_WindowCloseRequested() method of the COM object.

		HRESULT __stdcall add_WindowCloseRequested(
			[in]ICoreWebView2WindowCloseRequestedEventHandler* eventHandler,
			[out]EventRegistrationToken* token);"

	<virtual stdcall: hresult 60 ICoreWebView2WindowCloseRequestedEventHandler* sqword*>
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

AddScriptToExecuteOnDocumentCreated: javaScript handler: handler
	"Private - Invoke the AddScriptToExecuteOnDocumentCreated() method of the COM object.

		HRESULT __stdcall AddScriptToExecuteOnDocumentCreated(
			[in]LPWSTR javaScript,
			[in]ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler* handler);"

	<virtual stdcall: hresult 28 lpwstr ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler*>
	^self invalidCall: _failureCode!

addScriptToExecuteOnDocumentCreated: javaScript thenDo: aDyadicValuable
	"Invoke the AddScriptToExecuteOnDocumentCreated() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2AddScriptToExecuteOnDocumentCreatedCompletedHandler.
	self AddScriptToExecuteOnDocumentCreated: javaScript asUtf16String handler: handler.
	handler free!

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

CallDevToolsProtocolMethod: methodName parametersAsJson: parametersAsJson handler: handler
	"Private - Invoke the CallDevToolsProtocolMethod() method of the COM object.

		HRESULT __stdcall CallDevToolsProtocolMethod(
			[in]LPWSTR methodName,
			[in]LPWSTR parametersAsJson,
			[in]ICoreWebView2CallDevToolsProtocolMethodCompletedHandler* handler);"

	<virtual stdcall: hresult 37 lpwstr lpwstr ICoreWebView2CallDevToolsProtocolMethodCompletedHandler*>
	^self invalidCall: _failureCode!

callDevToolsProtocolMethod: nameString parametersAsJson: jsonString thenDo: aDyadicValuable
	"Invoke the CallDevToolsProtocolMethod() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2CallDevToolsProtocolMethodCompletedHandler.
	self
		CallDevToolsProtocolMethod: nameString asUtf16String
		parametersAsJson: jsonString asUtf16String
		handler: handler.
	handler free!

CallDevToolsProtocolMethodForSession: sessionId methodName: methodName parametersAsJson: parametersAsJson handler: handler
	"Not supported at this level"

	^E_NOTIMPL!

callDevToolsProtocolMethodForSession: sessionId methodName: methodName parametersAsJson: parametersAsJson thenDo: aDyadicValuable
	"Invoke the CallDevToolsProtocolMethodForSession() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2CallDevToolsProtocolMethodCompletedHandler.
	self
		CallDevToolsProtocolMethodForSession: sessionId
		methodName: methodName
		parametersAsJson: parametersAsJson
		handler: handler.
	handler free!

canGoBack
	"Answer the <Boolean> value of the 'CanGoBack' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_CanGoBack: answer.
	^answer asObject!

canGoForward
	"Answer the <Boolean> value of the 'CanGoForward' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_CanGoForward: answer.
	^answer asObject!

canPrintToPdf
	^false!

CapturePreview: imageFormat imageStream: imageStream handler: handler
	"Private - Invoke the CapturePreview() method of the COM object.

		HRESULT __stdcall CapturePreview(
			[in]COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT imageFormat,
			[in]IStream* imageStream,
			[in]ICoreWebView2CapturePreviewCompletedHandler* handler);"

	<virtual stdcall: hresult 31 sdword IStream* ICoreWebView2CapturePreviewCompletedHandler*>
	^self invalidCall: _failureCode!

capturePreview: anInteger imageStream: anIStream thenDo: aMonadicValuable
	"Request a screenshot of the webview content captured into a byte stream. The operation is asynchronous, and the results an HRESULT code indicating completion status is passed to the <monadicValuable> final argument when complete. Assuming success, the image can then be retrieved from the byte stream passed as the 2nd argument."

	"For example, given an ICoreWebView2 variable, `webview`:

		stream := ByteArray writeStream.
		webview capturePreview: WebView2Constants.COREWEBVIEW2_CAPTURE_PREVIEW_IMAGE_FORMAT_PNG
			imageStream: (stream queryInterface: IStream)
			thenDo: [:hr | 
				| pngBytes |
				pngBytes := stream contents.
				(GdiplusBitmap fromByteArray: pngBytes) inspect]
	"

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aMonadicValuable)
				queryInterface: ICoreWebView2CapturePreviewCompletedHandler.
	self
		CapturePreview: anInteger
		imageStream: anIStream
		handler: handler.
	handler free!

ClearServerCertificateErrorActions: handler
	"Private - Invoke the ClearServerCertificateErrorActions() method of the COM object.

		HRESULT __stdcall ClearServerCertificateErrorActions(
			[in]ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler* handler);"

	^E_NOTIMPL!

clearServerCertificateErrorActionsThenDo: aMonadicValuable
	"Invoke the ClearServerCertificateErrorActions() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aMonadicValuable)
				queryInterface: ICoreWebView2ClearServerCertificateErrorActionsCompletedHandler.
	self ClearServerCertificateErrorActions: handler.
	handler free!

clearVirtualHostNameToFolderMapping: hostName
	"Invoke the ClearVirtualHostNameToFolderMapping() method of the COM object."

	^self ClearVirtualHostNameToFolderMapping: hostName asUtf16String!

ClearVirtualHostNameToFolderMapping: hostName
	"Private - Invoke the ClearVirtualHostNameToFolderMapping() method of the COM object.

		HRESULT __stdcall ClearVirtualHostNameToFolderMapping(
			[in]LPWSTR hostName);"

	"Not implemented by this version of WebView2"
	^E_NOTIMPL!

closeDefaultDownloadDialog
	"Invoke the CloseDefaultDownloadDialog() method of the COM object."

	^self CloseDefaultDownloadDialog!

CloseDefaultDownloadDialog
	"Private - Invoke the CloseDefaultDownloadDialog() method of the COM object.

		HRESULT __stdcall CloseDefaultDownloadDialog();"

	"Not supported at this level"

	^E_NOTIMPL!

containsFullScreenElement
	"Answer the <Boolean> value of the 'ContainsFullScreenElement' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_ContainsFullScreenElement: answer.
	^answer asObject!

cookieManager
	"Answer the <ICoreWebView2CookieManager> value of the 'CookieManager' property of the receiver."

	| answer |
	answer := ICoreWebView2CookieManager newPointer.
	self get_CookieManager: answer.
	^answer asObject!

defaultDownloadDialogCornerAlignment
	"Answer the <sdword> value of the 'DefaultDownloadDialogCornerAlignment' property of the receiver."

	| answer |
	answer := SDWORD new.
	self get_DefaultDownloadDialogCornerAlignment: answer.
	^answer asObject!

defaultDownloadDialogCornerAlignment: value
	"Set the 'DefaultDownloadDialogCornerAlignment' property of the receiver to the <sdword> value of the argument."

	self put_DefaultDownloadDialogCornerAlignment: value!

defaultDownloadDialogMargin
	"Answer the <POINTL> value of the 'DefaultDownloadDialogMargin' property of the receiver."

	| answer |
	answer := POINTL new.
	self get_DefaultDownloadDialogMargin: answer.
	^answer asObject!

defaultDownloadDialogMargin: value
	"Set the 'DefaultDownloadDialogMargin' property of the receiver to the <POINTL> value of the argument."

	self put_DefaultDownloadDialogMargin: value asParameter!

displayOn: aWriteStream
	aWriteStream nextPutAll: self documentTitle!

documentTitle
	"Answer the <readableString> title of the current document."

	"The auto-generated code is functionally correct, but this property may be accessed a lot and this code is slightly more efficient; in particular it avoids generating finalizable garbage."

	| ptr answer |
	ptr := TaskMemory new.
	self get_DocumentTitle: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

environment
	"Answer the <ICoreWebView2Environment> value of the 'Environment' property of the receiver."

	| answer |
	answer := ICoreWebView2Environment newPointer.
	self get_Environment: answer.
	^answer asObject!

ExecuteScript: javaScript handler: handler
	"Private - Invoke the ExecuteScript() method of the COM object.

		HRESULT __stdcall ExecuteScript(
			[in]LPWSTR javaScript,
			[in]ICoreWebView2ExecuteScriptCompletedHandler* handler);"

	<virtual stdcall: hresult 30 lpwstr ICoreWebView2ExecuteScriptCompletedHandler*>
	^self invalidCall: _failureCode!

executeScript: javaScript thenDo: aDyadicValuable
	"Request the execution of some javascript in the browser, evaluating the <dyadicValuable> second argument when the script has finished running, passing it an HRESULT status code and the the JSON result string."

	"For example:

		webview executeScript: 'window.document.URL;'
			thenDo: [:hr :json | MessageBox notify: 'Document url is: ', json].
	"

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2ExecuteScriptCompletedHandler.
	self ExecuteScript: javaScript asUtf16String handler: handler.
	handler free!

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

	<virtual stdcall: hresult 39 bool*>
	^self invalidCall: _failureCode!

get_CanGoForward: canGoForward
	"Private - Get the value of the 'CanGoForward' property of the receiver.

		HRESULT __stdcall CanGoForward(
			[out, retval]long* CanGoForward);"

	<virtual stdcall: hresult 40 bool*>
	^self invalidCall: _failureCode!

get_ContainsFullScreenElement: containsFullScreenElement
	"Private - Get the value of the 'ContainsFullScreenElement' property of the receiver.

		HRESULT __stdcall ContainsFullScreenElement(
			[out, retval]long* ContainsFullScreenElement);"

	<virtual stdcall: hresult 55 sdword*>
	^self invalidCall: _failureCode!

get_CookieManager: cookieManager
	"Private - Get the value of the 'CookieManager' property of the receiver.

		HRESULT __stdcall CookieManager(
			[out, retval]ICoreWebView2CookieManager** CookieManager);"

	"Not implemented in this version of WebView2"
	^E_NOTIMPL!

get_DefaultDownloadDialogCornerAlignment: value
	"Private - Get the value of the 'DefaultDownloadDialogCornerAlignment' property of the receiver.

		HRESULT __stdcall DefaultDownloadDialogCornerAlignment(
			[out, retval]COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT* value);"

	"Not supported at this level"

	^E_NOTIMPL!

get_DefaultDownloadDialogMargin: value
	"Private - Get the value of the 'DefaultDownloadDialogMargin' property of the receiver.

		HRESULT __stdcall DefaultDownloadDialogMargin(
			[out, retval]POINT* value);"

	"Not supported at this level"

	^E_NOTIMPL!

get_DocumentTitle: title
	"Private - Get the value of the 'DocumentTitle' property of the receiver.

		HRESULT __stdcall DocumentTitle(
			[out, retval]LPWSTR* title);"

	<virtual stdcall: hresult 49 lpwstr*>
	^self invalidCall: _failureCode!

get_Environment: environment
	"Private - Get the value of the 'Environment' property of the receiver.

		HRESULT __stdcall Environment(
			[out, retval]ICoreWebView2Environment** Environment);"

	"Not implemented in this version of WebView2"
	^E_NOTIMPL

!

get_IsDefaultDownloadDialogOpen: value
	"Private - Get the value of the 'IsDefaultDownloadDialogOpen' property of the receiver.

		HRESULT __stdcall IsDefaultDownloadDialogOpen(
			[out, retval]long* value);"

	"Not supported at this level"

	^E_NOTIMPL!

get_IsDocumentPlayingAudio: value
	"Private - Get the value of the 'IsDocumentPlayingAudio' property of the receiver.

		HRESULT __stdcall IsDocumentPlayingAudio(
			[out, retval]long* value);"

	^E_NOTIMPL!

get_IsMuted: value
	"Private - Get the value of the 'IsMuted' property of the receiver.

		HRESULT __stdcall IsMuted(
			[out, retval]long* value);"

	value value: 0.
	^S_OK!

get_IsSuspended: isSuspended
	"Private - Get the value of the 'IsSuspended' property of the receiver.

		HRESULT __stdcall IsSuspended(
			[out, retval]long* IsSuspended);"

	isSuspended value: 0.
	^S_OK!

get_Profile: value
	"Private - Get the value of the 'Profile' property of the receiver.

		HRESULT __stdcall Profile(
			[out, retval]ICoreWebView2Profile** value);"

	^E_NOTIMPL!

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

get_StatusBarText: value
	"Not supported at this level"

	^E_NOTIMPL!

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

GetFavicon: format completedHandler: completedHandler
	"Not supported by this version"

	^E_NOTIMPL!

getFavIcon: formatInteger thenDo: aDyadicValuable
	"Invoke the CallDevToolsProtocolMethod() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: Smalltalk.ICoreWebView2GetFaviconCompletedHandler.
	self GetFavicon: formatInteger completedHandler: handler.
	handler free!

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

isDefaultDownloadDialogOpen
	"Answer the <Boolean> value of the 'IsDefaultDownloadDialogOpen' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsDefaultDownloadDialogOpen: answer.
	^answer asObject!

isDocumentPlayingAudio
	"Answer the <Boolean> value of the 'IsDocumentPlayingAudio' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsDocumentPlayingAudio: answer.
	^answer asObject!

isMuted
	"Answer the <Boolean> value of the 'IsMuted' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsMuted: answer.
	^answer asObject!

isSuspended
	"Answer the <Boolean> value of the 'IsSuspended' property of the receiver."

	| answer |
	answer := BOOL newBuffer.
	self get_IsSuspended: answer.
	^answer asObject!

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

NavigateWithWebResourceRequest: request
	"Private - Invoke the NavigateWithWebResourceRequest() method of the COM object.

		HRESULT __stdcall NavigateWithWebResourceRequest(
			[in]ICoreWebView2WebResourceRequest* Request);"

	"Not implemented in this version of WebView2"

	^E_NOTIMPL!

openDefaultDownloadDialog
	"Invoke the OpenDefaultDownloadDialog() method of the COM object."

	^self OpenDefaultDownloadDialog!

OpenDefaultDownloadDialog
	"Private - Invoke the OpenDefaultDownloadDialog() method of the COM object.

		HRESULT __stdcall OpenDefaultDownloadDialog();"

	"Not supported at this level"

	^E_NOTIMPL!

openDevToolsWindow
	"Invoke the OpenDevToolsWindow() method of the COM object."

	^self OpenDevToolsWindow!

OpenDevToolsWindow
	"Private - Invoke the OpenDevToolsWindow() method of the COM object.

		HRESULT __stdcall OpenDevToolsWindow();"

	<virtual stdcall: hresult 52>
	^self invalidCall: _failureCode!

openTaskManagerWindow
	"Invoke the OpenTaskManagerWindow() method of the COM object."

	^self OpenTaskManagerWindow!

OpenTaskManagerWindow
	"Private - Invoke the OpenTaskManagerWindow() method of the COM object.

		HRESULT __stdcall OpenTaskManagerWindow();"

	"Not implemented by this version of WebView2"
	^E_NOTIMPL!

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

printableProperties
	^#(#source)!

PrintToPdf: resultFilePath printSettings: printSettings handler: anICoreWebView2PrintToPdfCompletedHandler
	"Private - Invoke the PrintToPdf() method of the COM object.

		HRESULT __stdcall PrintToPdf(
			[in]LPWSTR ResultFilePath,
			[in]ICoreWebView2PrintSettings* printSettings,
			[in]ICoreWebView2PrintToPdfCompletedHandler* handler);"

	anICoreWebView2PrintToPdfCompletedHandler Invoke: E_NOTIMPL arg: 0.
	^E_NOTIMPL!

printToPdf: resultFilePath settings: printSettings thenDo: aDyadicValuable
	"Request asynchronous print to PDF. On completion invoke the <dyadicValuable> argument passing an HRESULT code and boolean success flag."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2PrintToPdfCompletedHandler.
	self
		PrintToPdf: resultFilePath asUtf16String
		printSettings: printSettings
		handler: handler.
	handler free!

profile
	"Answer the <ICoreWebView2Profile> value of the 'Profile' property of the receiver."

	| answer |
	answer := ICoreWebView2Profile newPointer.
	self get_Profile: answer.
	^answer notNull ifTrue: [answer queryInterface: ICoreWebView2Profile2 ifNone: [answer]]!

put_DefaultDownloadDialogCornerAlignment: value
	"Private - Set the value of the 'DefaultDownloadDialogCornerAlignment' property of the object wrapped by the 
	 receiver to the <sdword> argument, value.

		HRESULT __stdcall DefaultDownloadDialogCornerAlignment(
			[in]COREWEBVIEW2_DEFAULT_DOWNLOAD_DIALOG_CORNER_ALIGNMENT value);"

	"Not supported at this level"

	^E_NOTIMPL!

put_DefaultDownloadDialogMargin: value
	"Private - Set the value of the 'DefaultDownloadDialogMargin' property of the object wrapped by the 
	 receiver to the <POINTL> argument, value.

		HRESULT __stdcall DefaultDownloadDialogMargin(
			[in]POINT value);"

	"Not supported at this level"

	^E_NOTIMPL!

put_IsMuted: value
	"Not implemented in this version of WebView2"

	^E_NOTIMPL!

reload
	"Invoke the Reload() method of the COM object."

	^self Reload!

Reload
	"Private - Invoke the Reload() method of the COM object.

		HRESULT __stdcall Reload();"

	<virtual stdcall: hresult 32>
	^self invalidCall: _failureCode!

Remove_BasicAuthenticationRequested: token
	"Not supported at this level"

	^E_NOTIMPL!

Remove_ClientCertificateRequested: token
	"Not supported at this level"

	^E_NOTIMPL!

Remove_ContainsFullScreenElementChanged: token
	"Private - Invoke the remove_ContainsFullScreenElementChanged() method of the COM object.

		HRESULT __stdcall remove_ContainsFullScreenElementChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 54 sqword>
	^self invalidCall: _failureCode!

Remove_ContentLoading: token
	"Private - Invoke the remove_ContentLoading() method of the COM object.

		HRESULT __stdcall remove_ContentLoading(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 11 sqword>
	^self invalidCall: _failureCode!

Remove_ContextMenuRequested: token
	"Not supported at this level"

	^E_NOTIMPL!

Remove_DocumentTitleChanged: token
	"Private - Invoke the remove_DocumentTitleChanged() method of the COM object.

		HRESULT __stdcall remove_DocumentTitleChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 48 sqword>
	^self invalidCall: _failureCode!

Remove_DOMContentLoaded: token
	"Not supported by this version"

	^E_NOTIMPL!

Remove_DownloadStarting: token
	"Not supported by this version"

	^E_NOTIMPL!

Remove_FaviconChanged: token
	"Not supported by this version"

	^E_NOTIMPL!

Remove_FrameCreated: token
	"Not supported by this version"

	^E_NOTIMPL!

Remove_FrameNavigationCompleted: token
	"Private - Invoke the remove_FrameNavigationCompleted() method of the COM object.

		HRESULT __stdcall remove_FrameNavigationCompleted(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 21 sqword>
	^self invalidCall: _failureCode!

Remove_FrameNavigationStarting: token
	"Private - Invoke the remove_FrameNavigationStarting() method of the COM object.

		HRESULT __stdcall remove_FrameNavigationStarting(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 19 sqword>
	^self invalidCall: _failureCode!

Remove_HistoryChanged: token
	"Private - Invoke the remove_HistoryChanged() method of the COM object.

		HRESULT __stdcall remove_HistoryChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 15 sqword>
	^self invalidCall: _failureCode!

Remove_IsDefaultDownloadDialogOpenChanged: token
	"Not supported at this level"

	^E_NOTIMPL!

Remove_IsDocumentPlayingAudioChanged: token
	"Not supported at this level"

	^E_NOTIMPL!

Remove_IsMutedChanged: token
	"Not supported at this level"

	^E_NOTIMPL!

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

	<virtual stdcall: hresult 9 sqword>
	^self invalidCall: _failureCode!

Remove_NewWindowRequested: token
	"Private - Invoke the remove_NewWindowRequested() method of the COM object.

		HRESULT __stdcall remove_NewWindowRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 46 sqword>
	^self invalidCall: _failureCode!

Remove_PermissionRequested: token
	"Private - Invoke the remove_PermissionRequested() method of the COM object.

		HRESULT __stdcall remove_PermissionRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 25 sqword>
	^self invalidCall: _failureCode!

Remove_ProcessFailed: token
	"Private - Invoke the remove_ProcessFailed() method of the COM object.

		HRESULT __stdcall remove_ProcessFailed(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 27 sqword>
	^self invalidCall: _failureCode!

Remove_ScriptDialogOpening: token
	"Private - Invoke the remove_ScriptDialogOpening() method of the COM object.

		HRESULT __stdcall remove_ScriptDialogOpening(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 23 sqword>
	^self invalidCall: _failureCode!

Remove_ServerCertificateErrorDetected: token
	"Private - Invoke the remove_ServerCertificateErrorDetected() method of the COM object.

		HRESULT __stdcall remove_ServerCertificateErrorDetected(
			[in]EventRegistrationToken token);"

	^E_NOTIMPL!

Remove_SourceChanged: token
	"Private - Invoke the remove_SourceChanged() method of the COM object.

		HRESULT __stdcall remove_SourceChanged(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 13 sqword>
	^self invalidCall: _failureCode!

Remove_StatusBarTextChanged: token
	"Not supported at this level"

	^E_NOTIMPL!

Remove_WebMessageReceived: token
	"Private - Invoke the remove_WebMessageReceived() method of the COM object.

		HRESULT __stdcall remove_WebMessageReceived(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 36 sqword>
	^self invalidCall: _failureCode!

Remove_WebResourceRequested: token
	"Private - Invoke the remove_WebResourceRequested() method of the COM object.

		HRESULT __stdcall remove_WebResourceRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 57 sqword>
	^self invalidCall: _failureCode!

Remove_WebResourceResponseReceived: token
	"Not supported by this version"

	^E_NOTIMPL!

Remove_WindowCloseRequested: token
	"Private - Invoke the remove_WindowCloseRequested() method of the COM object.

		HRESULT __stdcall remove_WindowCloseRequested(
			[in]EventRegistrationToken token);"

	<virtual stdcall: hresult 61 sqword>
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

resume
	"Invoke the Resume() method of the COM object."

	^self Resume!

Resume
	"Private - Invoke the Resume() method of the COM object.

		HRESULT __stdcall Resume();"

	<virtual stdcall: hresult 70>
	^self invalidCall: _failureCode!

settings
	"Answer the <ICoreWebView2Settings> value of the 'Settings' property of the receiver."

	| answer |
	answer := ICoreWebView2Settings newPointer.
	self get_Settings: answer.
	^answer asObject!

setVirtualHostNameToFolderMapping: hostName folderPath: folderPath accessKind: accessKind
	"Invoke the SetVirtualHostNameToFolderMapping() method of the COM object."

	^self
		SetVirtualHostNameToFolderMapping: hostName asUtf16String
		folderPath: folderPath asUtf16String
		accessKind: accessKind!

SetVirtualHostNameToFolderMapping: hostName folderPath: folderPath accessKind: accessKind
	"Private - Invoke the SetVirtualHostNameToFolderMapping() method of the COM object.

		HRESULT __stdcall SetVirtualHostNameToFolderMapping(
			[in]LPWSTR hostName,
			[in]LPWSTR folderPath,
			[in]COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND accessKind);"

	"Not implemented by this version of WebView2"
	^E_NOTIMPL!

source
	"Answer the <readableString> 'Source' uri."

	"The auto-generated code is functionally correct, but this property may be accessed a lot and this code is slightly more efficient; in particular it avoids generating finalizable garbage."

	| ptr answer |
	ptr := TaskMemory new.
	self get_Source: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

statusBarText
	"Answer the <readableString> 'status bar' text."

	| ptr answer |
	ptr := TaskMemory new.
	self get_StatusBarText: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

stop
	"Invoke the Stop() method of the COM object."

	^self Stop!

Stop
	"Private - Invoke the Stop() method of the COM object.

		HRESULT __stdcall Stop();"

	<virtual stdcall: hresult 44>
	^self invalidCall: _failureCode!

trySuspend: aDyadicValuable
	"Request asynchronous suspend. On completion invoke the <dyadicValuable> argument passing an HRESULT code and boolean success flag."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2TrySuspendCompletedHandler.
	self TrySuspend: handler.
	handler free!

TrySuspend: handler
	"Private - Invoke the TrySuspend() method of the COM object.

		HRESULT __stdcall TrySuspend(
			[in]ICoreWebView2TrySuspendCompletedHandler* handler);"

	handler Invoke: E_NOTIMPL arg: 0! !
!WebView2.ICoreWebView2 categoriesForMethods!
Add_BasicAuthenticationRequested:token:!COM Interfaces-ICoreWebView2_10!private! !
Add_ClientCertificateRequested:token:!COM Interfaces-ICoreWebView2_5!private! !
Add_ContainsFullScreenElementChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_ContentLoading:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_ContextMenuRequested:token:!COM Interfaces-ICoreWebView2_11!private! !
Add_DocumentTitleChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_DOMContentLoaded:token:!COM Interfaces-ICoreWebView2_2!events!private! !
Add_DownloadStarting:token:!COM Interfaces-ICoreWebView2_4!private! !
Add_FaviconChanged:token:!COM Interfaces-ICoreWebView2_15!private! !
Add_FrameCreated:token:!COM Interfaces-ICoreWebView2_4!private! !
Add_FrameNavigationCompleted:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_FrameNavigationStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_HistoryChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_IsDefaultDownloadDialogOpenChanged:token:!COM Interfaces-ICoreWebView2_9!private! !
Add_IsDocumentPlayingAudioChanged:token:!COM Interfaces-ICoreWebView2_8!private! !
Add_IsMutedChanged:token:!COM Interfaces-ICoreWebView2_8!private! !
Add_NavigationCompleted:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_NavigationStarting:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_NewWindowRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_PermissionRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_ProcessFailed:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_ScriptDialogOpening:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_ServerCertificateErrorDetected:token:!COM Interfaces-ICoreWebView2_14!private! !
Add_SourceChanged:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_StatusBarTextChanged:token:!COM Interfaces-ICoreWebView2_12!private! !
Add_WebMessageReceived:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_WebResourceRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
Add_WebResourceResponseReceived:token:!COM Interfaces-ICoreWebView2_2!events!private! !
Add_WindowCloseRequested:token:!**auto generated**!COM Interfaces-ICoreWebView2!events!private! !
addHostObjectToScript:object:!**auto generated**!methods!public! !
AddHostObjectToScript:object:!**auto generated**!COM Interfaces-ICoreWebView2!methods!private! !
AddScriptToExecuteOnDocumentCreated:handler:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
addScriptToExecuteOnDocumentCreated:thenDo:!async requests!public! !
addWebResourceRequestedFilter:resourceContext:!**auto generated**!methods!public! !
AddWebResourceRequestedFilter:resourceContext:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
browserProcessId!**auto generated**!properties!public! !
CallDevToolsProtocolMethod:parametersAsJson:handler:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
callDevToolsProtocolMethod:parametersAsJson:thenDo:!async requests!public! !
CallDevToolsProtocolMethodForSession:methodName:parametersAsJson:handler:!COM Interfaces-ICoreWebView2_11!private! !
callDevToolsProtocolMethodForSession:methodName:parametersAsJson:thenDo:!async requests!public! !
canGoBack!properties!public! !
canGoForward!properties!public! !
canPrintToPdf!public!testing! !
CapturePreview:imageStream:handler:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
capturePreview:imageStream:thenDo:!async requests!public! !
ClearServerCertificateErrorActions:!COM Interfaces-ICoreWebView2_14!private! !
clearServerCertificateErrorActionsThenDo:!async requests!public! !
clearVirtualHostNameToFolderMapping:!methods!public! !
ClearVirtualHostNameToFolderMapping:!COM Interfaces-ICoreWebView2_3!private! !
closeDefaultDownloadDialog!methods!public! !
CloseDefaultDownloadDialog!COM Interfaces-ICoreWebView2_9!private! !
containsFullScreenElement!properties!public! !
cookieManager!properties!public! !
defaultDownloadDialogCornerAlignment!properties!public! !
defaultDownloadDialogCornerAlignment:!properties!public! !
defaultDownloadDialogMargin!properties!public! !
defaultDownloadDialogMargin:!properties!public! !
displayOn:!displaying!public! !
documentTitle!properties!public! !
environment!properties!public! !
ExecuteScript:handler:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
executeScript:thenDo:!async requests!public! !
get_BrowserProcessId:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
get_CanGoBack:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
get_CanGoForward:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
get_ContainsFullScreenElement:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
get_CookieManager:!COM Interfaces-ICoreWebView2_2!private!properties! !
get_DefaultDownloadDialogCornerAlignment:!COM Interfaces-ICoreWebView2_9!private! !
get_DefaultDownloadDialogMargin:!COM Interfaces-ICoreWebView2_9!private! !
get_DocumentTitle:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
get_Environment:!COM Interfaces-ICoreWebView2_2!private!properties! !
get_IsDefaultDownloadDialogOpen:!COM Interfaces-ICoreWebView2_9!private! !
get_IsDocumentPlayingAudio:!COM Interfaces-ICoreWebView2_8!private! !
get_IsMuted:!COM Interfaces-ICoreWebView2_8!private! !
get_IsSuspended:!COM Interfaces-ICoreWebView2_3!private! !
get_Profile:!COM Interfaces-ICoreWebView2_13!private! !
get_Settings:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
get_Source:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
get_StatusBarText:!COM Interfaces-ICoreWebView2_12!private! !
getDevToolsProtocolEventReceiver:!**auto generated**!methods!public! !
GetDevToolsProtocolEventReceiver:receiver:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
GetFavicon:completedHandler:!COM Interfaces-ICoreWebView2_15!private! !
getFavIcon:thenDo:!async requests!public! !
goBack!**auto generated**!methods!public! !
GoBack!**auto generated**!COM Interfaces-ICoreWebView2!private! !
goForward!**auto generated**!methods!public! !
GoForward!**auto generated**!COM Interfaces-ICoreWebView2!private! !
isDefaultDownloadDialogOpen!properties!public! !
isDocumentPlayingAudio!properties!public! !
isMuted!properties!public! !
isSuspended!properties!public! !
navigate:!**auto generated**!methods!public! !
Navigate:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
navigateToString:!**auto generated**!methods!public! !
NavigateToString:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
NavigateWithWebResourceRequest:!COM Interfaces-ICoreWebView2_2!methods!private! !
openDefaultDownloadDialog!methods!public! !
OpenDefaultDownloadDialog!COM Interfaces-ICoreWebView2_9!private! !
openDevToolsWindow!**auto generated**!methods!public! !
OpenDevToolsWindow!**auto generated**!COM Interfaces-ICoreWebView2!private! !
openTaskManagerWindow!methods!public! !
OpenTaskManagerWindow!COM Interfaces-ICoreWebView2_6!private! !
postWebMessageAsJson:!**auto generated**!methods!public! !
PostWebMessageAsJson:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
postWebMessageAsString:!**auto generated**!methods!public! !
PostWebMessageAsString:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
printableProperties!printing!private! !
PrintToPdf:printSettings:handler:!COM Interfaces-ICoreWebView2_7!private! !
printToPdf:settings:thenDo:!methods!public! !
profile!properties!public! !
put_DefaultDownloadDialogCornerAlignment:!COM Interfaces-ICoreWebView2_9!private! !
put_DefaultDownloadDialogMargin:!COM Interfaces-ICoreWebView2_9!private! !
put_IsMuted:!COM Interfaces-ICoreWebView2_8!private! !
reload!**auto generated**!methods!public! !
Reload!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_BasicAuthenticationRequested:!COM Interfaces-ICoreWebView2_10!private! !
Remove_ClientCertificateRequested:!COM Interfaces-ICoreWebView2_5!private! !
Remove_ContainsFullScreenElementChanged:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_ContentLoading:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_ContextMenuRequested:!COM Interfaces-ICoreWebView2_11!private! !
Remove_DocumentTitleChanged:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_DOMContentLoaded:!COM Interfaces-ICoreWebView2_2!events!private! !
Remove_DownloadStarting:!COM Interfaces-ICoreWebView2_4!private! !
Remove_FaviconChanged:!**auto generated**!COM Interfaces-ICoreWebView2_15!private! !
Remove_FrameCreated:!COM Interfaces-ICoreWebView2_4!private! !
Remove_FrameNavigationCompleted:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_FrameNavigationStarting:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_HistoryChanged:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_IsDefaultDownloadDialogOpenChanged:!COM Interfaces-ICoreWebView2_9!private! !
Remove_IsDocumentPlayingAudioChanged:!COM Interfaces-ICoreWebView2_8!private! !
Remove_IsMutedChanged:!COM Interfaces-ICoreWebView2_8!private! !
Remove_NavigationCompleted:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_NavigationStarting:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_NewWindowRequested:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_PermissionRequested:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_ProcessFailed:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_ScriptDialogOpening:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_ServerCertificateErrorDetected:!COM Interfaces-ICoreWebView2_14!private! !
Remove_SourceChanged:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_StatusBarTextChanged:!COM Interfaces-ICoreWebView2_12!private! !
Remove_WebMessageReceived:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_WebResourceRequested:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
Remove_WebResourceResponseReceived:!COM Interfaces-ICoreWebView2_2!events!private! !
Remove_WindowCloseRequested:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
removeHostObjectFromScript:!**auto generated**!methods!public! !
RemoveHostObjectFromScript:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
removeScriptToExecuteOnDocumentCreated:!**auto generated**!methods!public! !
RemoveScriptToExecuteOnDocumentCreated:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
removeWebResourceRequestedFilter:resourceContext:!**auto generated**!methods!public! !
RemoveWebResourceRequestedFilter:resourceContext:!**auto generated**!COM Interfaces-ICoreWebView2!private! !
resume!methods!public! !
Resume!COM Interfaces-ICoreWebView2_3!private! !
settings!**auto generated**!properties!public! !
setVirtualHostNameToFolderMapping:folderPath:accessKind:!methods!public! !
SetVirtualHostNameToFolderMapping:folderPath:accessKind:!COM Interfaces-ICoreWebView2_3!private! !
source!properties!public! !
statusBarText!properties!public! !
stop!**auto generated**!methods!public! !
Stop!**auto generated**!COM Interfaces-ICoreWebView2!private! !
trySuspend:!methods!public! !
TrySuspend:!COM Interfaces-ICoreWebView2_3!private! !
!

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
			argumentTypes: 'ICoreWebView2NavigationStartingEventHandler* sqword*';
		defineFunction: #Remove_NavigationStarting:
			argumentTypes: 'sqword';
		defineFunction: #Add_ContentLoading:token:
			argumentTypes: 'ICoreWebView2ContentLoadingEventHandler* sqword*';
		defineFunction: #Remove_ContentLoading:
			argumentTypes: 'sqword';
		defineFunction: #Add_SourceChanged:token:
			argumentTypes: 'ICoreWebView2SourceChangedEventHandler* sqword*';
		defineFunction: #Remove_SourceChanged:
			argumentTypes: 'sqword';
		defineFunction: #Add_HistoryChanged:token:
			argumentTypes: 'ICoreWebView2HistoryChangedEventHandler* sqword*';
		defineFunction: #Remove_HistoryChanged:
			argumentTypes: 'sqword';
		defineFunction: #Add_NavigationCompleted:token:
			argumentTypes: 'ICoreWebView2NavigationCompletedEventHandler* sqword*';
		defineFunction: #Remove_NavigationCompleted:
			argumentTypes: 'sqword';
		defineFunction: #Add_FrameNavigationStarting:token:
			argumentTypes: 'ICoreWebView2NavigationStartingEventHandler* sqword*';
		defineFunction: #Remove_FrameNavigationStarting:
			argumentTypes: 'sqword';
		defineFunction: #Add_FrameNavigationCompleted:token:
			argumentTypes: 'ICoreWebView2NavigationCompletedEventHandler* sqword*';
		defineFunction: #Remove_FrameNavigationCompleted:
			argumentTypes: 'sqword';
		defineFunction: #Add_ScriptDialogOpening:token:
			argumentTypes: 'ICoreWebView2ScriptDialogOpeningEventHandler* sqword*';
		defineFunction: #Remove_ScriptDialogOpening:
			argumentTypes: 'sqword';
		defineFunction: #Add_PermissionRequested:token:
			argumentTypes: 'ICoreWebView2PermissionRequestedEventHandler* sqword*';
		defineFunction: #Remove_PermissionRequested:
			argumentTypes: 'sqword';
		defineFunction: #Add_ProcessFailed:token:
			argumentTypes: 'ICoreWebView2ProcessFailedEventHandler* sqword*';
		defineFunction: #Remove_ProcessFailed:
			argumentTypes: 'sqword';
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
			argumentTypes: 'ICoreWebView2WebMessageReceivedEventHandler* sqword*';
		defineFunction: #Remove_WebMessageReceived:
			argumentTypes: 'sqword';
		defineFunction: #CallDevToolsProtocolMethod:parametersAsJson:handler:
			argumentTypes: 'lpwstr lpwstr ICoreWebView2CallDevToolsProtocolMethodCompletedHandler*';
		defineFunction: #get_BrowserProcessId:
			argumentTypes: 'dword*';
		defineFunction: #get_CanGoBack:
			argumentTypes: 'bool*';
		defineFunction: #get_CanGoForward:
			argumentTypes: 'bool*';
		defineFunction: #GoBack;
		defineFunction: #GoForward;
		defineFunction: #GetDevToolsProtocolEventReceiver:receiver:
			argumentTypes: 'lpwstr ICoreWebView2DevToolsProtocolEventReceiver**';
		defineFunction: #Stop;
		defineFunction: #Add_NewWindowRequested:token:
			argumentTypes: 'ICoreWebView2NewWindowRequestedEventHandler* sqword*';
		defineFunction: #Remove_NewWindowRequested:
			argumentTypes: 'sqword';
		defineFunction: #Add_DocumentTitleChanged:token:
			argumentTypes: 'ICoreWebView2DocumentTitleChangedEventHandler* sqword*';
		defineFunction: #Remove_DocumentTitleChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_DocumentTitle:
			argumentTypes: 'lpwstr*';
		defineFunction: #AddHostObjectToScript:object:
			argumentTypes: 'lpwstr variant*';
		defineFunction: #RemoveHostObjectFromScript:
			argumentTypes: 'lpwstr';
		defineFunction: #OpenDevToolsWindow;
		defineFunction: #Add_ContainsFullScreenElementChanged:token:
			argumentTypes: 'ICoreWebView2ContainsFullScreenElementChangedEventHandler* sqword*';
		defineFunction: #Remove_ContainsFullScreenElementChanged:
			argumentTypes: 'sqword';
		defineFunction: #get_ContainsFullScreenElement:
			argumentTypes: 'sdword*';
		defineFunction: #Add_WebResourceRequested:token:
			argumentTypes: 'ICoreWebView2WebResourceRequestedEventHandler* sqword*';
		defineFunction: #Remove_WebResourceRequested:
			argumentTypes: 'sqword';
		defineFunction: #AddWebResourceRequestedFilter:resourceContext:
			argumentTypes: 'lpwstr sdword';
		defineFunction: #RemoveWebResourceRequestedFilter:resourceContext:
			argumentTypes: 'lpwstr sdword';
		defineFunction: #Add_WindowCloseRequested:token:
			argumentTypes: 'ICoreWebView2WindowCloseRequestedEventHandler* sqword*';
		defineFunction: #Remove_WindowCloseRequested:
			argumentTypes: 'sqword'
! !
!WebView2.ICoreWebView2 class categoriesForMethods!
defineFunctions!initializing!public! !
!

