"Filed out from Dolphin Smallalk"!

ValueConvertingControlView subclass: #WebView2View
	instanceVariableNames: 'webviewController webviewWindow'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebView2View guid: (GUID fromString: '{3a9f720c-51f6-49f2-8267-f2b3b878129c}')!
WebView2View comment: ''!
!WebView2View categoriesForClass!MVP-Resources-Misc! !
!WebView2View methodsFor!

defaultWindowProcessing: message wParam: wParam lParam: lParam
	"Private - Pass an event to the 'default' window procedure of the receiver."

	"Override back to the base implementation because the receiver is not actually a control, rather just a straight DolphinWindow."

	^UserLibrary default
		defWindowProc: handle
		msg: message
		wParam: wParam
		lParam: lParam!

displayValue
	"Private - Answer the displayed contents of the receiver.
	Must be overridden by subclasses"

	webviewWindow isNull ifTrue: [^nil].
	^webviewWindow source
!

displayValue: anObject
	"Private - Set the displayed contents of the receiver.
	Must be overridden by subclasses"

	webviewWindow isNull ifTrue: [^self].
	webviewWindow navigate: anObject ?? 'edge://settings/help'!

finalRelease
	"The last reference to the receiver (as a COM object) has been released."
!

Invoke: hresultInteger createdController: anICoreWebView2Controller
	hresultInteger == S_OK ifFalse: [^hresultInteger].
	"Resize the edge window to fill the receiver."
	webviewController := anICoreWebView2Controller.
	self resizeWebviewToFit.
	webviewWindow := anICoreWebView2Controller coreWebView2.
	self refreshContents!

Invoke: hresultInteger createdEnvironment: anICoreWebView2Environment
	hresultInteger == S_OK ifFalse: [^hresultInteger].
	^anICoreWebView2Environment createCoreWebView2Controller: handle
		handler: (self queryInterface: ICoreWebView2CreateCoreWebView2ControllerCompletedHandler)!

onPositionChanged: aPositionEvent
	(aPositionEvent isResize and: [webviewController notNull]) ifTrue: [self resizeWebviewToFit].
	^super onPositionChanged: aPositionEvent!

onViewCreated
	"The receiver has just been fully created. This is a suitable place to perform
	initialization of the window from the receiver's instance variables."

	WebView2Loader default
		createCoreWebView2EnvironmentWithOptions: nil
		userDataFolder: nil
		environmentOptions: nil
		environmentCreatedHandler: (self
				queryInterface: ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler)!

queryInterface: anInterfaceClass
	"Answer a new interface which supports the specified interface protocol
	(usually a class), or nil if the receiver does not support the interface."

	^self queryInterface: anInterfaceClass ifNone: []
!

queryInterface: anInterfaceClass ifNone: exceptionHandler 
	"Answer a new interface pointer which supports the specified interface protocol
	(usually a class). If the receiver does not support the interface, answer the
	result of evaluating the niladic valuable, exceptionHandler."

	^(self supportedInterfaces detect: [:ic | ic supportsInterface: anInterfaceClass]
		ifNone: []) 
			ifNil: [exceptionHandler value]
			ifNotNil: [:class | class on: self implementor: self]!

resizeWebviewToFit
	webviewController bounds: self clientRectangle!

subclassWindow: hWnd
	"Private - Override back to the base implementation because the receiver is not actually a control, rather just a straight DolphinWindow."

	self attachHandle: hWnd!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^{ICoreWebView2CreateCoreWebView2ControllerCompletedHandler.
		ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler}! !
!WebView2View categoriesForMethods!
defaultWindowProcessing:wParam:lParam:!dispatching!private! !
displayValue!private!updating! !
displayValue:!private!updating! !
finalRelease!public!realizing/unrealizing! !
Invoke:createdController:!COM Interfaces-ICoreWebView2CreateCoreWebView2ControllerCompletedHandler!private! !
Invoke:createdEnvironment:!COM Interfaces-ICoreWebView2CreateCoreWebView2EnvironmentCompletedHandler!private! !
onPositionChanged:!event handling!public! !
onViewCreated!event handling!public! !
queryInterface:!accessing-interfaces!public! !
queryInterface:ifNone:!accessing!accessing-interfaces!public! !
resizeWebviewToFit!COM Interfaces-ICoreWebView2CreateCoreWebView2ControllerCompletedHandler!private! !
subclassWindow:!operations!private! !
supportedInterfaces!constants!public! !
!

!WebView2View class methodsFor!

winClassName
	"Private - Answer the Windows class name, or atom, to be used when creating Windows attached
	to instances of the receiver."

	^self wndClassName! !
!WebView2View class categoriesForMethods!
winClassName!constants!private! !
!

