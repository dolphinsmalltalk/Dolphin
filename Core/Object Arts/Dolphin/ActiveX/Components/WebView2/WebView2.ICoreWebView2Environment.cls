"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2Interface
	subclass: #'WebView2.ICoreWebView2Environment'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2Environment guid: (OS.COM.IID fromString: '{b96d755e-0319-4e92-a296-23436f46a1fc}')!

WebView2.ICoreWebView2Environment isEgressOnly: true!

WebView2.ICoreWebView2Environment comment: '`ICoreWebView2Environment` is a wrapper class for the COM interface ''WebView2.ICoreWebView2Environment'' generated from type information in the '''' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

At the time of writing there are eleven (!!) later versions of this interface. In order to reduce the burden of degrading gracefully to older versions, default implementations of the additional methods and properties are added.

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

	<virtual stdcall: hresult 7 ICoreWebView2NewBrowserVersionAvailableEventHandler* int64*>
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

createContextMenuItem: label iconStream: iconStream kind: kind
	"Answer the <ICoreWebView2ContextMenuItem> result of invoking the CreateContextMenuItem() method of the COM object."

	| answer |
	answer := ICoreWebView2ContextMenuItem newPointer.
	self
		CreateContextMenuItem: label asUtf16String
		iconStream: iconStream
		kind: kind
		item: answer.
	^answer!

CreateContextMenuItem: label iconStream: iconStream kind: kind item: item
	"Private - Invoke the CreateContextMenuItem() method of the COM object.

		HRESULT __stdcall CreateContextMenuItem(
			[in]LPWSTR Label,
			[in]IStream* iconStream,
			[in]COREWEBVIEW2_CONTEXT_MENU_ITEM_KIND Kind,
			[out, retval]ICoreWebView2ContextMenuItem** item);"

	^E_NOTIMPL!

CreateCoreWebView2CompositionController: aWindowHandle handler: anICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler
	"Private - Invoke the CreateCoreWebView2CompositionController() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2CompositionController(
			wireHWND ParentWindow,
			ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler* handler);"

	"Not implemented in this version"

	^anICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler notImplemented!

createCoreWebView2CompositionController: parentWindow thenDo: aDyadicValuable
	"Invoke the CreateCoreWebView2CompositionController() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler.
	self CreateCoreWebView2CompositionController: parentWindow handler: handler.
	handler free!

createCoreWebView2CompositionController: parentWindow withOptions: anICoreWebView2ControllerOptions thenDo: aDyadicValuable
	"Invoke the CreateCoreWebView2CompositionController() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler.
	self
		CreateCoreWebView2CompositionControllerWithOptions: parentWindow
		options: anICoreWebView2ControllerOptions
		handler: handler , handler free!

CreateCoreWebView2CompositionControllerWithOptions: aWindowHandle options: anICoreWebView2ControllerOptions handler: anICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler
	"Private - Invoke the CreateCoreWebView2CompositionControllerWithOptions() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2CompositionControllerWithOptions(
			[in]wireHWND ParentWindow,
			[in]ICoreWebView2ControllerOptions* options,
			[in]ICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler* handler);"

	^self CreateCoreWebView2CompositionController: aWindowHandle handler: anICoreWebView2CreateCoreWebView2CompositionControllerCompletedHandler!

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

createCoreWebView2Controller: parentWindow withOptions: options thenDo: aDyadicValuable
	"Invoke the CreateCoreWebView2ControllerWithOptions() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler.
	self CreateCoreWebView2ControllerWithOptions: parentWindow options: options handler: handler.
	handler free!

createCoreWebView2ControllerOptions
	"Answer the <ICoreWebView2ControllerOptions> result of invoking the CreateCoreWebView2ControllerOptions() method of the COM object."

	| answer |
	answer := ICoreWebView2ControllerOptions newPointer.
	self CreateCoreWebView2ControllerOptions: answer.
	^answer downCast!

CreateCoreWebView2ControllerOptions: options
	"Private - Invoke the CreateCoreWebView2ControllerOptions() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2ControllerOptions(
			[out, retval]ICoreWebView2ControllerOptions** options);"

	^E_NOTIMPL!

CreateCoreWebView2ControllerWithOptions: aWindowHandle options: anICoreWebView2ControllerOptions handler: anICoreWebView2CreateCoreWebView2ControllerCompletedHandler
	"Private - Invoke the CreateCoreWebView2ControllerWithOptions() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2ControllerWithOptions(
			[in]wireHWND ParentWindow,
			[in]ICoreWebView2ControllerOptions* options,
			[in]ICoreWebView2CreateCoreWebView2ControllerCompletedHandler* handler);"

	"The options are ignored at this level"
	^self CreateCoreWebView2Controller: aWindowHandle handler: anICoreWebView2CreateCoreWebView2ControllerCompletedHandler!

CreateCoreWebView2PointerInfo: pointerInfo
	"Private - Invoke the CreateCoreWebView2PointerInfo() method of the COM object.

		HRESULT __stdcall CreateCoreWebView2PointerInfo(
			[out, retval]ICoreWebView2PointerInfo** pointerInfo);"

	"Not implemented in this version"

	^E_NOTIMPL!

createFindOptions
	"Answer the <ICoreWebView2FindOptions> result of invoking the CreateFindOptions() method of the COM object."

	| answer |
	answer := ICoreWebView2FindOptions newPointer.
	self CreateFindOptions: answer.
	^answer asObject!

createFindOptions: aFindDetails
	"Answer an <ICoreWebView2FindOptions> configured with options from the <FindDetails> argument."

	^self createFindOptions
		ifNotNil: 
			[:options |
			options
				isCaseSensitive: aFindDetails isCaseSensitive;
				shouldMatchWord: aFindDetails isWholeWord;
				findTerm: aFindDetails pattern;
				yourself]!

CreateFindOptions: value
	"Private - Invoke the CreateFindOptions() method of the COM object.

		HRESULT __stdcall CreateFindOptions(
			[out, retval]ICoreWebView2FindOptions** value);"

	^E_NOTIMPL!

createObjectCollection: aCollection
	"Answer an <ICoreWebView2ObjectCollection> containing the IUknown's of the collection of COM objects in the argument."

	| answer unknowns pointers |
	unknowns := aCollection collect: [:each | each queryInterface: IUnknown].
	pointers := PointerArray withAll: unknowns elementClass: IUnknown.
	answer := ICoreWebView2ObjectCollection newPointer.
	self
		CreateObjectCollection: pointers size
		items: pointers
		objectCollection: answer.
	unknowns do: [:each | each free].
	^answer!

CreateObjectCollection: length items: items objectCollection: objectCollection
	"Private - Invoke the CreateObjectCollection() method of the COM object.

		HRESULT __stdcall CreateObjectCollection(
			[in]unsigned int length,
			[in]IUnknown** items,
			[out, retval]ICoreWebView2ObjectCollection** objectCollection);"

	^E_NOTIMPL!

createPointerInfo
	"Answer a new <ICoreWebView2PointerInfo> to be populated with settings to pass to a composition controller via SendPointerInput."

	| answer |
	answer := ICoreWebView2PointerInfo newPointer.
	self CreateCoreWebView2PointerInfo: answer.
	^answer asObject!

createPrintSettings
	"Answer the <ICoreWebView2PrintSettings> result of invoking the CreatePrintSettings() method of the COM object."

	| answer |
	answer := ICoreWebView2PrintSettings newPointer.
	self CreatePrintSettings: answer.
	^answer downCast!

CreatePrintSettings: printSettings
	"Private - Invoke the CreatePrintSettings() method of the COM object.

		HRESULT __stdcall CreatePrintSettings(
			[out, retval]ICoreWebView2PrintSettings** printSettings);"

	^E_NOTIMPL
!

createSharedBuffer: size
	"Answer the <ICoreWebView2SharedBuffer> result of invoking the CreateSharedBuffer() method of the COM object."

	| answer |
	answer := ICoreWebView2SharedBuffer newPointer.
	self CreateSharedBuffer: size shared_buffer: answer.
	^answer asObject!

CreateSharedBuffer: size shared_buffer: shared_buffer
	"Private - Invoke the CreateSharedBuffer() method of the COM object.

		HRESULT __stdcall CreateSharedBuffer(
			[in]unsigned __int64 Size,
			[out, retval]ICoreWebView2SharedBuffer** shared_buffer);"

	^E_NOTIMPL!

createWebFileSystemDirectoryHandle: path permission: permission
	"Answer the <ICoreWebView2FileSystemHandle> result of invoking the CreateWebFileSystemDirectoryHandle() method of the COM object."

	| answer |
	answer := ICoreWebView2FileSystemHandle newPointer.
	self
		CreateWebFileSystemDirectoryHandle: path
		permission: permission
		value: answer.
	^answer!

CreateWebFileSystemDirectoryHandle: path permission: permission value: value
	"Private - Invoke the CreateWebFileSystemDirectoryHandle() method of the COM object.

		HRESULT __stdcall CreateWebFileSystemDirectoryHandle(
			[in]LPWSTR Path,
			[in]COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION Permission,
			[out, retval]ICoreWebView2FileSystemHandle** value);"

	^E_NOTIMPL!

createWebFileSystemFileHandle: path permission: permission
	"Answer the <ICoreWebView2FileSystemHandle> result of invoking the CreateWebFileSystemFileHandle() method of the COM object."

	| answer |
	answer := ICoreWebView2FileSystemHandle newPointer.
	self
		CreateWebFileSystemFileHandle: path
		permission: permission
		value: answer.
	^answer!

CreateWebFileSystemFileHandle: path permission: permission value: value
	"Private - Invoke the CreateWebFileSystemFileHandle() method of the COM object.

		HRESULT __stdcall CreateWebFileSystemFileHandle(
			[in]LPWSTR Path,
			[in]COREWEBVIEW2_FILE_SYSTEM_HANDLE_PERMISSION Permission,
			[out, retval]ICoreWebView2FileSystemHandle** value);"

	^E_NOTIMPL!

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

	| answer contentStream |
	answer := ICoreWebView2WebResourceResponse newPointer.
	contentStream := content ifNotNil: [content queryInterface: IStream].
	self
		CreateWebResourceResponse: contentStream
		statusCode: statusCode
		reasonPhrase: reasonPhrase
		headers: headers
		response: answer.
	contentStream free.
	^answer!

CreateWebResourceResponse: content statusCode: statusCode reasonPhrase: reasonPhrase headers: headers response: response
	"Private - Invoke the CreateWebResourceResponse() method of the COM object.

		HRESULT __stdcall CreateWebResourceResponse(
			[in]IStream* Content,
			[in]int StatusCode,
			[in]LPWSTR ReasonPhrase,
			[in]LPWSTR Headers,
			[out, retval]ICoreWebView2WebResourceResponse** Response);"

	<virtual stdcall: hresult 5 IStream* int32 lpwstr lpwstr ICoreWebView2WebResourceResponse**>
	^self invalidCall: _failureCode!

displayOn: aWriteStream
	self isNull
		ifTrue: [super displayOn: aWriteStream]
		ifFalse: [aWriteStream nextPutAll: self browserVersionString]!

failureReportFolderPath
	"Answer the <lpwstr> value of the 'FailureReportFolderPath' property of the receiver."

	| ptr answer |
	ptr := TaskMemory new.
	self get_FailureReportFolderPath: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

get_BrowserVersionString: versionInfo
	"Private - Get the value of the 'BrowserVersionString' property of the receiver.

		HRESULT __stdcall BrowserVersionString(
			[out, retval]LPWSTR* versionInfo);"

	<virtual stdcall: hresult 6 lpwstr*>
	^self invalidCall: _failureCode!

get_FailureReportFolderPath: value
	"Private - Get the value of the 'FailureReportFolderPath' property of the receiver.

		HRESULT __stdcall FailureReportFolderPath(
			[out, retval]LPWSTR* value);"

	^E_NOTIMPL!

get_UserDataFolder: value
	"Private - Get the value of the 'UserDataFolder' property of the receiver.

		HRESULT __stdcall UserDataFolder(
			[out, retval]LPWSTR* value);"

	"Not implemented in this version"

	^E_NOTIMPL!

GetProcessExtendedInfos: anICoreWebView2GetProcessExtendedInfosCompletedHandler
	"Invoke the GetProcessExtendedInfos() method of the COM object.

		HRESULT __stdcall GetProcessExtendedInfos(
			[in]ICoreWebView2GetProcessExtendedInfosCompletedHandler* handler);"

	^anICoreWebView2GetProcessExtendedInfosCompletedHandler notImplemented!

getProcessExtendedInfosThenDo: aDyadicValuable
	"Invoke the CreateCoreWebView2ControllerWithOptions() method of the COM object."

	| handler |
	handler := (WebView2CompletionHandler completionBlock: aDyadicValuable)
				queryInterface: ICoreWebView2GetProcessExtendedInfosCompletedHandler.
	self GetProcessExtendedInfos: handler.
	handler free!

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

	<virtual stdcall: hresult 8 int64>
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
createContextMenuItem:iconStream:kind:!methods!public! !
CreateContextMenuItem:iconStream:kind:item:!COM Interfaces-ICoreWebView2Environment9!private! !
CreateCoreWebView2CompositionController:handler:!COM Interfaces-ICoreWebView2Environment3!methods!private! !
createCoreWebView2CompositionController:thenDo:!async requests!public! !
createCoreWebView2CompositionController:withOptions:thenDo:!async requests!public! !
CreateCoreWebView2CompositionControllerWithOptions:options:handler:!COM Interfaces-ICoreWebView2Environment10!private! !
CreateCoreWebView2Controller:handler:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
createCoreWebView2Controller:thenDo:!async requests!public! !
createCoreWebView2Controller:withOptions:thenDo:!async requests!public! !
createCoreWebView2ControllerOptions!methods!public! !
CreateCoreWebView2ControllerOptions:!COM Interfaces-ICoreWebView2Environment10!private! !
CreateCoreWebView2ControllerWithOptions:options:handler:!COM Interfaces-ICoreWebView2Environment10!private! !
CreateCoreWebView2PointerInfo:!COM Interfaces-ICoreWebView2Environment3!methods!private! !
createFindOptions!methods!public! !
createFindOptions:!methods!public! !
CreateFindOptions:!COM Interfaces-ICoreWebView2Environment15!private! !
createObjectCollection:!methods!public! !
CreateObjectCollection:items:objectCollection:!COM Interfaces-ICoreWebView2Environment14!private! !
createPointerInfo!methods!public! !
createPrintSettings!methods!public! !
CreatePrintSettings:!COM Interfaces-ICoreWebView2Environment6!methods!private! !
createSharedBuffer:!methods!public! !
CreateSharedBuffer:shared_buffer:!COM Interfaces-ICoreWebView2Environment12!private! !
createWebFileSystemDirectoryHandle:permission:!methods!public! !
CreateWebFileSystemDirectoryHandle:permission:value:!COM Interfaces-ICoreWebView2Environment14!private! !
createWebFileSystemFileHandle:permission:!methods!public! !
CreateWebFileSystemFileHandle:permission:value:!COM Interfaces-ICoreWebView2Environment14!private! !
createWebResourceRequest:method:postData:headers:!methods!public! !
CreateWebResourceRequest:method:postData:headers:request:!COM Interfaces-ICoreWebView2Environment2!displaying!private! !
createWebResourceResponse:statusCode:reasonPhrase:headers:!methods!public! !
CreateWebResourceResponse:statusCode:reasonPhrase:headers:response:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
displayOn:!displaying!public! !
failureReportFolderPath!properties!public! !
get_BrowserVersionString:!**auto generated**!COM Interfaces-ICoreWebView2Environment!private! !
get_FailureReportFolderPath:!COM Interfaces-ICoreWebView2Environment11!private!properties! !
get_UserDataFolder:!COM Interfaces-ICoreWebView2Environment7!private!properties! !
GetProcessExtendedInfos:!COM Interfaces-ICoreWebView2Environment13!public! !
getProcessExtendedInfosThenDo:!async requests!public! !
GetProcessInfos:!COM Interfaces-ICoreWebView2Environment8!methods!private! !
getProviderForHwnd:!methods!public! !
GetProviderForHwnd:provider:!COM Interfaces-ICoreWebView2Environment4!methods!private! !
processInfos!methods!public! !
Remove_BrowserProcessExited:!COM Interfaces-ICoreWebView2Environment5!events!private! !
Remove_NewBrowserVersionAvailable:!**auto generated**!COM Interfaces-ICoreWebView2Environment!events!private! !
Remove_ProcessInfosChanged:!COM Interfaces-ICoreWebView2Environment8!events!private! !
userDataFolder!properties!public! !
!

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
!

latestDerivation
	^##(super latestDerivation)! !

!WebView2.ICoreWebView2Environment class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
latestDerivation!enquiries!public! !
!

