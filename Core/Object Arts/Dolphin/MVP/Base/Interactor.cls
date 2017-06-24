"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Interactor
	instanceVariableNames: 'presenter'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Interactor guid: (GUID fromString: '{6281dd52-ad59-468b-b5b9-c5594195cef8}')!
Interactor comment: ''!
!Interactor categoriesForClass!MVP-Interactors! !
!Interactor methodsFor!

onCaptureChanged: aViewOrNil 
	"Default handler for a mouse capture changed event from the event source."

	^self presenter onCaptureChanged: aViewOrNil!

onGetCursor: aSymbol
	"The named area of the view associated with the receiver has been hit.
	Answer the appropriate mouse cursor or nil to accept the default."

	^self presenter onGetCursor: aSymbol!

onKeyPressed: aKeyEvent
	"Default handler for the receiver's view receiving a key press event."

	^self presenter onKeyPressed: aKeyEvent!

onKeyReleased: aKeyEvent
	"Default handler for the receiver's view receiving a key up event."

	^self presenter onKeyReleased: aKeyEvent!

onKeyTyped: aKeyEvent
	"Default handler for the receiver's view receiving a key entry."

	^self presenter onKeyTyped: aKeyEvent!

onLeftButtonDoubleClicked: aMouseEvent 
	"Default handler for a mouse left button double-click event."

	^self presenter onLeftButtonDoubleClicked: aMouseEvent!

onLeftButtonPressed: aMouseEvent 
	"Default handler for a mouse left button down event."

	^self presenter onLeftButtonPressed: aMouseEvent!

onLeftButtonReleased: aMouseEvent 
	"Default handler for a mouse left button up event."

	^self presenter onLeftButtonReleased: aMouseEvent!

onMiddleButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse middle button double-click event."

	^self presenter onMiddleButtonDoubleClicked: aMouseEvent!

onMiddleButtonPressed: aMouseEvent 
	"Default handler for a mouse middle button down event."

	^self presenter onMiddleButtonPressed: aMouseEvent!

onMiddleButtonReleased: aMouseEvent 
	"Default handler for a mouse middle button up event."

	^self presenter onMiddleButtonReleased: aMouseEvent!

onMouseLeave: aMouseEvent 
	"Default handler for a mouse leave event over the receiver's view."

	^self presenter onMouseLeave: aMouseEvent!

onMouseMoved: aMouseEvent
	"Default handler for a mouse move event over the receiver's view."

	^self presenter onMouseMoved: aMouseEvent!

onMouseWheeled: aMouseWheelEvent
	"Default handler for a mouse wheel movement event."

	^self presenter onMouseWheeled: aMouseWheelEvent!

onRightButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse Right button double-click event."

	^self presenter onRightButtonDoubleClicked: aMouseEvent!

onRightButtonPressed: aMouseEvent
	"Default handler for a Right button down mouse event."

	^self presenter onRightButtonPressed: aMouseEvent!

onRightButtonReleased: aMouseEvent
	"Default handler for a Right button up mouse event."

	^self presenter onRightButtonReleased: aMouseEvent!

onSysKeyPressed: aKeyEvent
	"Default handler for the receiver's view receiving a sys key press event (e.g. Alt down)."

	^self presenter onSysKeyPressed: aKeyEvent!

onSysKeyReleased: aKeyEvent 
	"Default handler for the receiver's view receiving a sys key up event."

	^self presenter onSysKeyReleased: aKeyEvent!

onSysKeyTyped: aKeyEvent 
	"Default handler for the receiver's view receiving a sys key entry."

	^self presenter onSysKeyTyped: aKeyEvent!

onXButtonDoubleClicked: aMouseEvent 
	"Default handler for a mouse X button double-click event."

	^self presenter onXButtonDoubleClicked: aMouseEvent!

onXButtonPressed: aMouseEvent 
	"Default handler for a mouse X button down event."

	^self presenter onXButtonPressed: aMouseEvent!

onXButtonReleased: aMouseEvent 
	"Default handler for a mouse X button up event."

	^self presenter onXButtonReleased: aMouseEvent!

presenter
	^presenter!

setPresenter: aPresenter 
	"Private - Initialise the receiver's instance variables. Answer the receiver."

	presenter := aPresenter.
	^self!

view
	^self presenter view! !
!Interactor categoriesFor: #onCaptureChanged:!event handling!public! !
!Interactor categoriesFor: #onGetCursor:!event handling!public! !
!Interactor categoriesFor: #onKeyPressed:!event handling!public! !
!Interactor categoriesFor: #onKeyReleased:!event handling!public! !
!Interactor categoriesFor: #onKeyTyped:!event handling!public! !
!Interactor categoriesFor: #onLeftButtonDoubleClicked:!event handling!public! !
!Interactor categoriesFor: #onLeftButtonPressed:!event handling!public! !
!Interactor categoriesFor: #onLeftButtonReleased:!event handling!public! !
!Interactor categoriesFor: #onMiddleButtonDoubleClicked:!event handling!public! !
!Interactor categoriesFor: #onMiddleButtonPressed:!event handling!public! !
!Interactor categoriesFor: #onMiddleButtonReleased:!event handling!public! !
!Interactor categoriesFor: #onMouseLeave:!event handling!public! !
!Interactor categoriesFor: #onMouseMoved:!event handling!public! !
!Interactor categoriesFor: #onMouseWheeled:!event handling!public! !
!Interactor categoriesFor: #onRightButtonDoubleClicked:!event handling!public! !
!Interactor categoriesFor: #onRightButtonPressed:!event handling!public! !
!Interactor categoriesFor: #onRightButtonReleased:!event handling!public! !
!Interactor categoriesFor: #onSysKeyPressed:!event handling!public! !
!Interactor categoriesFor: #onSysKeyReleased:!event handling!public! !
!Interactor categoriesFor: #onSysKeyTyped:!event handling!public! !
!Interactor categoriesFor: #onXButtonDoubleClicked:!event handling!public! !
!Interactor categoriesFor: #onXButtonPressed:!event handling!public! !
!Interactor categoriesFor: #onXButtonReleased:!event handling!public! !
!Interactor categoriesFor: #presenter!accessing!public! !
!Interactor categoriesFor: #setPresenter:!accessing!private! !
!Interactor categoriesFor: #view!public!testing! !

!Interactor class methodsFor!

forPresenter: aPresenter
	^self basicNew
		setPresenter: aPresenter!

new
	"Use #view:target:"

	^self shouldNotImplement! !
!Interactor class categoriesFor: #forPresenter:!instance creation!public! !
!Interactor class categoriesFor: #new!instance creation!public! !

