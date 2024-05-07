"Filed out from Dolphin Smalltalk"!

WindowsEvent subclass: #PositionEvent
	instanceVariableNames: 'lpwp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PositionEvent guid: (GUID fromString: '{cd69a072-3606-11d3-93bd-00a024ca708a}')!

PositionEvent comment: 'PositionEvent is the class of <Event> associated with a window reposition event originating from a WM_WINDOWPOSCHANGING or WM_WINDOWPOSCHANGED message.'!

!PositionEvent categoriesForClass!MVP-Views-Events! !

!PositionEvent methodsFor!

extent
	"Answer the extent of the window after the size event.
	N.B. This is not the width of the client area, but the external dimension.
	If the client area is required, it can be requested by simply sending an
	#clientExtent message to the window."

	^self lpwp extent!

extent: aPoint
	"Set the extent of the window for the size event.
	N.B. This is not the width of the client area, but the external dimension."

	self width: aPoint x; height: aPoint y!

flags
	"Answer an <integer> containing the SWP_XXX flags associated with this position change event."

	"Implementation Note: For most PositionEvents we only need to access the flags, so optimise for this case, avoiding creation of a WINDOWPOS structure."

	^lParam dwordAtOffset: WINDOWPOS._OffsetOf_flags!

flags: anInteger
	"Answer an <integer> containing the SWP_XXX flags associated with this position change event."

	"Implementation Note: For most PositionEvents we only need to access the flags, so optimise for this case, avoiding creation of a WINDOWPOS structure."

	lParam dwordAtOffset: WINDOWPOS._OffsetOf_flags put: anInteger!

height
	"Answer the height of the window after the size event.
	N.B. This is not the height of the client area, but the external dimension.
	If the client area is required, it can be requested by simply sending an
	#clientExtent message to the window."

	^self lpwp cy!

height: anInteger
	"Set the height of the window for the size event.
	N.B. This is not the height of the client area, but the external dimension."

	^self lpwp cy: anInteger!

isActivate
	"Answer whether the receiver is describing a window activation event."

	^self flags noMask: SWP_NOACTIVATE!

isClientAreaChanged
	"Answer whether the receiver is describing a change in the client area."

	^(self flags bitAnd: ##(SWP_NOSIZE | SWP_FRAMECHANGED)) ~= SWP_NOSIZE!

isHideWindow
	"Answer whether the receiver is describing a hide event."

	^self flags anyMask: SWP_HIDEWINDOW!

isMove
	"Answer whether the receiver is describing a move event."

	^self flags noMask: SWP_NOMOVE!

isRectangleChanged
	"Answer whether the receiver is describing a position change event which has really affected the layout of the window, i.e. either or both of the position and size have been changed."

	^(self flags allMask: ##(SWP_NOMOVE | SWP_NOSIZE)) not!

isResize
	"Answer whether the receiver is describing a resize event."

	^self flags noMask: SWP_NOSIZE!

isVisibilityChange
	"Answer whether the receiver is describing a hide/show event."

	^self flags anyMask: ##(SWP_SHOWWINDOW | SWP_HIDEWINDOW)!

isZOrderChanged
	"Answer whether the receiver is describing a z-order change."

	^self flags noMask: SWP_NOZORDER!

lpwp
	"Private - Answer the value of the receiver's 'lpwp' instance variable."

	^lpwp ifNil: [lpwp := WINDOWPOS fromAddress: lParam]!

position
	"Answer the position of the window origin."

	^self lpwp position!

printLParamOn: aStream 
	"Private - Append a textual representation of the receiver's lParam
	to aStream, in a format appropriate for the type of event."

	aStream print: self lpwp!

rectangle
	^self lpwp rectangle!

width
	"Answer the width of the window after the size event.
	N.B. This is not the width of the client area, but the external dimension.
	If the client area is required, it can be requested by simply sending an
	#clientExtent message to the window."

	^self lpwp cx!

width: anInteger
	"Set the width of the window forthe size event.
	N.B. This is not the width of the client area, but the external dimension."

	^self lpwp cx: anInteger!

x
	"Answer the x-position of the window origin."

	^self lpwp x!

y
	"Answer the y-position of the window origin."

	^self lpwp y! !

!PositionEvent categoriesForMethods!
extent!accessing!public! !
extent:!accessing!public! !
flags!accessing!public! !
flags:!accessing!public! !
height!accessing!public! !
height:!accessing!public! !
isActivate!public!testing! !
isClientAreaChanged!public!testing! !
isHideWindow!public!testing! !
isMove!public!testing! !
isRectangleChanged!public!testing! !
isResize!public!testing! !
isVisibilityChange!public!testing! !
isZOrderChanged!public!testing! !
lpwp!accessing!private! !
position!accessing!public! !
printLParamOn:!development!printing!private! !
rectangle!accessing!public! !
width!accessing!public! !
width:!accessing!public! !
x!accessing!public! !
y!accessing!public! !
!

!PositionEvent class methodsFor!

window: aView message: msgInteger wParam: wInteger lParam: lInteger
	"Answer an instance of the receiver containing the message details specified by the parameters."

	^super
		window: aView
		message: msgInteger
		wParam: wInteger
		lParam: lInteger asExternalAddress! !

!PositionEvent class categoriesForMethods!
window:message:wParam:lParam:!instance creation!public! !
!

