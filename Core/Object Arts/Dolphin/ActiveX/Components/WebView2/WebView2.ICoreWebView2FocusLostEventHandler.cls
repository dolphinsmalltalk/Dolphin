"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FocusChangedEventHandler
	subclass: #'WebView2.ICoreWebView2FocusLostEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FocusLostEventHandler guid: (OS.COM.IID fromString: '{75135371-3cd0-49b8-8f44-6d65838c5eb1}')!

WebView2.ICoreWebView2FocusLostEventHandler comment: ''!

!WebView2.ICoreWebView2FocusLostEventHandler categoriesForClass!COM-Interfaces! !

!WebView2.ICoreWebView2FocusLostEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_LostFocus: self token: tokenBuffer!

basicUnregister
	source Remove_LostFocus: token! !

!WebView2.ICoreWebView2FocusLostEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2FocusLostEventHandler class methodsFor!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#focusLost! !

!WebView2.ICoreWebView2FocusLostEventHandler class categoriesForMethods!
eventName!constants!public! !
!

