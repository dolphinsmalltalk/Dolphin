"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2CompositionControllerEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2CompositionControllerEventHandler guid: (OS.COM.IID fromString: '{52c09739-6c36-40aa-83bd-03403423a5fe}')!

WebView2.ICoreWebView2CompositionControllerEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2CompositionControllerEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 composition controller object.'!

!WebView2.ICoreWebView2CompositionControllerEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2CompositionController* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2CompositionController* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2CompositionControllerEventHandler categoriesForMethods!
Invoke:args:!event handling!public! !
!

