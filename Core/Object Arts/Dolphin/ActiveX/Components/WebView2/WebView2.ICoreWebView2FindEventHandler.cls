"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2FindEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FindEventHandler guid: (OS.COM.IID fromString: '{d6b76c45-aa04-4ec4-99ca-c986ddaf7392}')!

WebView2.ICoreWebView2FindEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2FindEventHandler comment: ''!

!WebView2.ICoreWebView2FindEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Find* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Find* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2FindEventHandler categoriesForMethods!
Invoke:args:!**auto generated**!COM Interfaces-ICoreWebView2FindActiveMatchIndexChangedEventHandler!public! !
!

