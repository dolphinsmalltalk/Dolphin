"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2DownloadOperationEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2DownloadOperationEventHandler guid: (OS.COM.IID fromString: '{623cba90-9162-4ce1-827d-e838af0dedf7}')!

WebView2.ICoreWebView2DownloadOperationEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2DownloadOperationEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 download operation object.'!

!WebView2.ICoreWebView2DownloadOperationEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2DownloadOperation* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2DownloadOperation* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2DownloadOperationEventHandler categoriesForMethods!
Invoke:args:!event handling!public! !
!

