"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2EventHandler
	subclass: #'WebView2.ICoreWebView2NotificationEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2NotificationEventHandler guid: (OS.COM.IID fromString: '{bd22e4d5-911b-46ee-be3a-1d1592cbc5af}')!

WebView2.ICoreWebView2NotificationEventHandler isNonInstantiable: true!

WebView2.ICoreWebView2NotificationEventHandler comment: 'Abstract class of event handler COM interfaces for events from a WebView2 notification object.'!

!WebView2.ICoreWebView2NotificationEventHandler methodsFor!

Invoke: sender args: args
	"Invoke the Invoke() method of the COM object.

		HRESULT __stdcall Invoke(
			[in]ICoreWebView2Notification* sender,
			[in]IUnknown* args);"

	<virtual stdcall: hresult 4 ICoreWebView2Notification* IUnknown*>
	^self invalidCall: _failureCode! !

!WebView2.ICoreWebView2NotificationEventHandler categoriesForMethods!
Invoke:args:!event handling!public! !
!

