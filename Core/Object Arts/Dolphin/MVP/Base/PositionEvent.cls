"Filed out from Dolphin Smalltalk X6"!

WindowsEvent subclass: #PositionEvent
	instanceVariableNames: 'lpwp'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PositionEvent guid: (GUID fromString: '{CD69A072-3606-11D3-93BD-00A024CA708A}')!
PositionEvent comment: 'PositionEvent is the class of <Event> associated with a window reposition event originating from a WM_WINDOWPOSCHANGING or WM_WINDOWPOSCHANGED message.'!
!PositionEvent categoriesForClass!MVP-Views-Events! !
!PositionEvent methodsFor!

extent
	"Answer the extent of the window after the size event.
	N.B. This is not the width of the client area, but the external dimension.
	If the client area is required, it can be requested by simply sending an
	#clientExtent message to the window."

	^self width @ self height!

extent: aPoint
	"Set the extent of the window for the size event.
	N.B. This is not the width of the client area, but the external dimension."

	self width: aPoint x; height: aPoint y!

flags
	"Answer an <integer> containing the SWP_XXX flags associated with 
	this position change event."

	^lpwp flags!

height
	"Answer the height of the window after the size event.
	N.B. This is not the height of the client area, but the external dimension.
	If the client area is required, it can be requested by simply sending an
	#clientExtent message to the window."

	^lpwp cy!

height: anInteger
	"Set the height of the window for the size event.
	N.B. This is not the height of the client area, but the external dimension."

	^lpwp cy: anInteger!

isActivate
	"Answer whether the receiver is describing a window activation event."

	^lpwp flags noMask: SWP_NOACTIVATE!

isClientAreaChanged
	"Answer whether the receiver is describing a change in the client area."

	^(lpwp flags bitAnd: ##(SWP_NOSIZE | SWP_FRAMECHANGED)) ~= SWP_NOSIZE!

isMove
	"Answer whether the receiver is describing a move event."

	^lpwp flags noMask: SWP_NOMOVE!

isRectangleChanged
	"Answer whether the receiver is describing a position change
	event which has really affected the layout of the window, i.e.
	either or both of the position and size have been changed."

	^self lpwp isRectangleChanged!

isResize
	"Answer whether the receiver is describing a resize event."

	^lpwp flags noMask: SWP_NOSIZE!

isVisibilityChange
	"Answer whether the receiver is describing a hide/show event."

	^lpwp flags anyMask: ##(SWP_SHOWWINDOW | SWP_HIDEWINDOW)!

isZOrderChanged
	"Answer whether the receiver is describing a z-order change."

	^lpwp flags noMask: SWP_NOZORDER!

lpwp
	"Private - Answer the value of the receiver's 'lpwp' instance variable."

	^lpwp!

makeStruct
	"Private - Create the WINDOWPOS structure from the message lParam."

	lpwp := WINDOWPOS fromAddress: lParam.!

position
	"Answer the position of the window origin."

	^self x @ self y!

printLParamOn: aStream 
	"Private - Append a textual representation of the receiver's lParam
	to aStream, in a format appropriate for the type of event."

	aStream print: self lpwp!

rectangle
	^lpwp rectangle!

width
	"Answer the width of the window after the size event.
	N.B. This is not the width of the client area, but the external dimension.
	If the client area is required, it can be requested by simply sending an
	#clientExtent message to the window."

	^lpwp cx!

width: anInteger
	"Set the width of the window forthe size event.
	N.B. This is not the width of the client area, but the external dimension."

	^lpwp cx: anInteger!

x
	"Answer the x-position of the window origin."

	^lpwp x!

y
	"Answer the y-position of the window origin."

	^lpwp y! !
!PositionEvent categoriesFor: #extent!accessing!public! !
!PositionEvent categoriesFor: #extent:!accessing!public! !
!PositionEvent categoriesFor: #flags!accessing!public! !
!PositionEvent categoriesFor: #height!accessing!public! !
!PositionEvent categoriesFor: #height:!accessing!public! !
!PositionEvent categoriesFor: #isActivate!public!testing! !
!PositionEvent categoriesFor: #isClientAreaChanged!public!testing! !
!PositionEvent categoriesFor: #isMove!public!testing! !
!PositionEvent categoriesFor: #isRectangleChanged!public!testing! !
!PositionEvent categoriesFor: #isResize!public!testing! !
!PositionEvent categoriesFor: #isVisibilityChange!public!testing! !
!PositionEvent categoriesFor: #isZOrderChanged!public!testing! !
!PositionEvent categoriesFor: #lpwp!accessing!private! !
!PositionEvent categoriesFor: #makeStruct!initializing!private! !
!PositionEvent categoriesFor: #position!accessing!public! !
!PositionEvent categoriesFor: #printLParamOn:!development!printing!private! !
!PositionEvent categoriesFor: #rectangle!accessing!public! !
!PositionEvent categoriesFor: #width!accessing!public! !
!PositionEvent categoriesFor: #width:!accessing!public! !
!PositionEvent categoriesFor: #x!accessing!public! !
!PositionEvent categoriesFor: #y!accessing!public! !

!PositionEvent class methodsFor!

handle: wndHandle message: msgInteger wParam: wInteger lParam: lInteger 
	"Answer an instance of the receiver containing the message details specified by the
	parameters."

	"Implementation Note: The args are in the order of the receiver's instance variables, and
	all we need to do to initialize the object is copy them directly across, therefore we can
	use the special create and initialize primitive."

	^(super 
		handle: wndHandle
		message: msgInteger
		wParam: wInteger
		lParam: lInteger)
		makeStruct;
		yourself! !
!PositionEvent class categoriesFor: #handle:message:wParam:lParam:!instance creation!public! !

