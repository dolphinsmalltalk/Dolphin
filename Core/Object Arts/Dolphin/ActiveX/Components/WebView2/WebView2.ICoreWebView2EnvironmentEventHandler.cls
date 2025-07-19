"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2EnvironmentEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2EnvironmentEventHandler guid: (OS.COM.IID fromString: '{b809c496-20d4-4920-bdb5-eaf88ca6dc4d}')!

WebView2.ICoreWebView2EnvironmentEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2EnvironmentEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 environment object.'!

!WebView2.ICoreWebView2EnvironmentEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Environment* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Environment* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2EnvironmentEventHandler categoriesForMethods!
Invoke:args:!event handling!public! !
!

