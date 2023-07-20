"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Interactor'
	instanceVariableNames: 'presenter'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Interactor guid: (Core.GUID fromString: '{6281dd52-ad59-468b-b5b9-c5594195cef8}')!
UI.Interactor isNonInstantiable: true!
UI.Interactor comment: '`Interactor` is an abstract class of `<interactor>`s that provide a plug-in capability to replace a `<presenter>`s normal response to user input events with something else, either temporarily (such as for the duration of a drag session) or for the life of the presenter.

## Instance Variables:
  `presenter`		`<presenter>` for which the `Interactor` is processing user input.
'!
!UI.Interactor categoriesForClass!MVP-Interactors! !
!UI.Interactor methodsFor!

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

preTranslateKeyboardInput: aMSG 
	^self presenter preTranslateKeyboardInput: aMSG!

preTranslateMouseInput: aMSG 
	^self presenter preTranslateMouseInput: aMSG!

setPresenter: aPresenter 
	"Private - Initialise the receiver's instance variables. Answer the receiver."

	presenter := aPresenter.
	^self!

view
	^self presenter view! !
!UI.Interactor categoriesForMethods!
onCaptureChanged:!event handling!public! !
onGetCursor:!event handling!public! !
onKeyPressed:!event handling!public! !
onKeyReleased:!event handling!public! !
onKeyTyped:!event handling!public! !
onLeftButtonDoubleClicked:!event handling!public! !
onLeftButtonPressed:!event handling!public! !
onLeftButtonReleased:!event handling!public! !
onMiddleButtonDoubleClicked:!event handling!public! !
onMiddleButtonPressed:!event handling!public! !
onMiddleButtonReleased:!event handling!public! !
onMouseLeave:!event handling!public! !
onMouseMoved:!event handling!public! !
onMouseWheeled:!event handling!public! !
onRightButtonDoubleClicked:!event handling!public! !
onRightButtonPressed:!event handling!public! !
onRightButtonReleased:!event handling!public! !
onSysKeyPressed:!event handling!public! !
onSysKeyReleased:!event handling!public! !
onSysKeyTyped:!event handling!public! !
onXButtonDoubleClicked:!event handling!public! !
onXButtonPressed:!event handling!public! !
onXButtonReleased:!event handling!public! !
presenter!accessing!public! !
preTranslateKeyboardInput:!dispatching!public! !
preTranslateMouseInput:!dispatching!public! !
setPresenter:!accessing!private! !
view!public!testing! !
!

UI.Interactor methodProtocol: #interactor attributes: #(#readOnly) selectors: #(#onGetCursor: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMiddleButtonDoubleClicked: #onMiddleButtonPressed: #onMiddleButtonReleased: #onMouseLeave: #onMouseMoved: #onMouseWheeled: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSysKeyPressed: #onSysKeyReleased: #onSysKeyTyped: #onXButtonDoubleClicked: #onXButtonPressed: #onXButtonReleased:)!

!UI.Interactor class methodsFor!

forPresenter: aPresenter
	^self basicNew
		setPresenter: aPresenter!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Use #forPresenter:"

	^self shouldNotImplement!

stbConvertFrom: anSTBClassFormat
	"Convert from previous binary filer version. 
	Version Changes:
		1) Adds stateFlags variable to CapturingInteractor"

	anSTBClassFormat version < 1 ifTrue: [^[:data | (self stbConvertFromVersion0: data) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersion0: anArray
	"No change at this level"

	^anArray!

stbVersion
	^1! !
!UI.Interactor class categoriesForMethods!
forPresenter:!instance creation!public! !
icon!constants!public! !
new!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion0:!binary filing!private! !
stbVersion!binary filing!public! !
!

