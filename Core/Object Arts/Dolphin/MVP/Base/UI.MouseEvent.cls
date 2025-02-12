﻿"Filed out from Dolphin Smalltalk"!

UI.PointEvent
	subclass: #'UI.MouseEvent'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.MouseEvent guid: (Core.GUID fromString: '{87b4c555-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.MouseEvent comment: 'MouseEvent represents the class of events generated by mouse hardware input device, including movements. button press/release events, scrolling of the wheel (where present), and whatever other fiddly bit MS dreams up next.'!

!UI.MouseEvent categoriesForClass!Events!MVP-Views-Events! !

!UI.MouseEvent methodsFor!

button
	"Answer the symbolic name of the button to which this event relates."

	(message between: WM_LBUTTONDOWN and: WM_LBUTTONDBLCLK) ifTrue: [^#left].
	(message between: WM_RBUTTONDOWN and: WM_RBUTTONDBLCLK) ifTrue: [^#right].
	(message between: WM_MBUTTONDOWN and: WM_MBUTTONDBLCLK) ifTrue: [^#middle].
	(message between: WM_XBUTTONDOWN and: WM_XBUTTONDBLCLK)
		ifTrue: [wParam highWord == 1 ifTrue: [^#xButton1] ifFalse: [^#xButton2]].
	^nil!

buttonFlag
	"Answer the flag from the Win32 MK_ enumeration that corresponds to the button associated with this event."

	^self button ifNil: [0] ifNotNil: [:button | self class wParamFlags at: button]!

isButtonDown
	"Is the event associated with any mouse button being down?"

	^wParam anyMask: ##(MK_LBUTTON | MK_RBUTTON | MK_MBUTTON | MK_XBUTTON1 | MK_XBUTTON2)!

isCtrlDown
	"Answer whether the control key is down."

	^wParam anyMask: MK_CONTROL!

isLButtonDown
	"Answer whether the left mouse button is down."

	^wParam anyMask: MK_LBUTTON!

isMButtonDown
	"Answer whether the middle mouse button is down."

	^wParam anyMask: MK_MBUTTON!

isModifierDown
	"Answer whether the control or shift key is down."

	^wParam anyMask: ##(MK_CONTROL | MK_SHIFT)!

isRButtonDown
	"Answer whether the right mouse button is down."

	^wParam anyMask: MK_RBUTTON!

isSelectionButtonDown
	^wParam anyMask: ##(MK_LBUTTON | MK_RBUTTON)!

isShiftDown
	"Answer whether the shift key is down."

	^wParam anyMask: MK_SHIFT!

isXButtonDown: anInteger
	"Answer whether the specified X button (numbered either 1 or 2) is down."

	(anInteger between: 1 and: 2)
		ifFalse: [self error: 'Invalid X button number: ' , anInteger printString].
	^wParam anyMask: (MK_XBUTTON1 bitShift: anInteger - 1)!

printWParamOn: aStream
	| separator |
	separator := 
			[separator := '|'.
			''].
	#('MK_CONTROL' 'MK_SHIFT' 'MK_LBUTTON' 'MK_RBUTTON' 'MK_MBUTTON' 'MK_XBUTTON1' 'MK_XBUTTON2') do: 
			[:each |
			(wParam allMask: (Win32Constants at: each))
				ifTrue: 
					[aStream
						nextPutAll: separator value;
						nextPutAll: each]]! !

!UI.MouseEvent categoriesForMethods!
button!accessing!public! !
buttonFlag!accessing!public! !
isButtonDown!public!testing! !
isCtrlDown!public!testing! !
isLButtonDown!public!testing! !
isMButtonDown!public!testing! !
isModifierDown!public!testing! !
isRButtonDown!public!testing! !
isSelectionButtonDown!public!testing! !
isShiftDown!public!testing! !
isXButtonDown:!public!testing! !
printWParamOn:!development!printing!private! !
!

!UI.MouseEvent class methodsFor!

wParamFlags
	"Answer an <IdentityDictionary> mapping between the names of the mouse buttons and the corresponding flag that will be set in 'keys' (wParam) if that button was down at the time of the event."

	^##(IdentityDictionary withAll: {#left -> MK_LBUTTON.
				#right -> MK_RBUTTON.
				#middle -> MK_MBUTTON.
				#xButton1 -> MK_XBUTTON1.
				#xButton2 -> MK_XBUTTON2.
				#shift -> MK_SHIFT.
				#control -> MK_CONTROL})! !

!UI.MouseEvent class categoriesForMethods!
wParamFlags!constants!public! !
!

