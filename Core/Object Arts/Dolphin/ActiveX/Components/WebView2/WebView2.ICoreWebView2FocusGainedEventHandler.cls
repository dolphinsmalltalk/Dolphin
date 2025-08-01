﻿"Filed out from Dolphin Smalltalk"!

WebView2.ICoreWebView2FocusChangedEventHandler
	subclass: #'WebView2.ICoreWebView2FocusGainedEventHandler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

WebView2.ICoreWebView2FocusGainedEventHandler guid: (OS.COM.IID fromString: '{ed0fa868-afef-4800-9392-483a8ab6a225}')!

WebView2.ICoreWebView2FocusGainedEventHandler comment: ''!

!WebView2.ICoreWebView2FocusGainedEventHandler categoriesForClass!COM-Interfaces! !

!WebView2.ICoreWebView2FocusGainedEventHandler methodsFor!

basicRegister: tokenBuffer with: anICoreWebView2Controller
	anICoreWebView2Controller Add_GotFocus: self token: tokenBuffer!

basicUnregister: anInteger from: anICoreWebView2Controller
	anICoreWebView2Controller Remove_GotFocus: anInteger! !

!WebView2.ICoreWebView2FocusGainedEventHandler categoriesForMethods!
basicRegister:with:!private!realizing/unrealizing! !
basicUnregister:from:!private!realizing/unrealizing! !
!

!WebView2.ICoreWebView2FocusGainedEventHandler class methodsFor!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#focusGained! !

!WebView2.ICoreWebView2FocusGainedEventHandler class categoriesForMethods!
eventName!constants!public! !
!

