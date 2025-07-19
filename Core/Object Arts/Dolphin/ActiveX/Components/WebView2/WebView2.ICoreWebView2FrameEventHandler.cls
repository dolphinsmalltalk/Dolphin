"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FrameEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FrameEventHandler guid: (OS.COM.IID fromString: '{cc80759b-1808-44d7-a6b8-30263d4c02e1}')!

WebView2.ICoreWebView2FrameEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2FrameEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 frame object.'!

!WebView2.ICoreWebView2FrameEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Frame* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Frame* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FrameEventHandler categoriesForMethods!
Invoke:args:!event handling!public! !
!

