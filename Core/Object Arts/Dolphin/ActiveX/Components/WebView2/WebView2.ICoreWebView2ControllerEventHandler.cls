"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2ControllerEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2ControllerEventHandler guid: (OS.COM.IID fromString: '{70a7b6f3-90f7-44ec-89b2-e01509c22d31}')!

WebView2.ICoreWebView2ControllerEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2ControllerEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 controller object.'!

!WebView2.ICoreWebView2ControllerEventHandler methodsFor!

Invoke: anICoreWebView2Controller args: anIUknown
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Controller* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Controller* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2ControllerEventHandler categoriesForMethods!
Invoke:args:!event handling!public! !
!

