"Filed out from Dolphin Smallalk"!

ICoreWebView2FocusChangedEventHandler subclass: #ICoreWebView2FocusLostEventHandler
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ICoreWebView2FocusLostEventHandler guid: (IID fromString: '{75135371-3cd0-49b8-8f44-6d65838c5eb1}')!
ICoreWebView2FocusLostEventHandler comment: ''!
!ICoreWebView2FocusLostEventHandler categoriesForClass!COM-Interfaces! !
!ICoreWebView2FocusLostEventHandler methodsFor!

basicRegister: tokenBuffer
	source Add_LostFocus: self token: tokenBuffer!

basicUnregister
	source Remove_LostFocus: token! !
!ICoreWebView2FocusLostEventHandler categoriesForMethods!
basicRegister:!private!realizing/unrealizing! !
basicUnregister!private!realizing/unrealizing! !
!

!ICoreWebView2FocusLostEventHandler class methodsFor!

eventName
	"Answer the symbolic name for this event (i.e. the SASE event trigger name)"

	^#focusLost! !
!ICoreWebView2FocusLostEventHandler class categoriesForMethods!
eventName!constants!public! !
!

