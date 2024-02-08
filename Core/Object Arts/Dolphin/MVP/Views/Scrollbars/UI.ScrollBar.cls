"Filed out from Dolphin Smalltalk"!

UI.ValueConvertingControlView
	subclass: #'UI.ScrollBar'
	instanceVariableNames: 'continuousTracking'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ScrollBar guid: (Core.GUID fromString: '{87b4c738-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ScrollBar comment: 'ScrollBar is a <valueView> implementing the Windows "msctls_progress32" common control. The <valueModel> associated with a ScrollBar must always yield an <integer> value when mapped through the installed type converter. A ScrollBar will normally be used in conjunction with a <NumberPresenter>.

Instance Variables:
	continuousTracking	<boolean> indicating whether the bar issues notification messages while being dragged.

'!

!UI.ScrollBar categoriesForClass!MVP-Views! !

!UI.ScrollBar methodsFor!

calculateExtent: aLayoutContext 
	"Private - Answer the calculated extent of the receiver that should be used by a
	layout manager during its layout process."

	^self calcExtentFromClientExtent: self defaultExtent!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the display DPI - see #creationExtent). Thereafter #preferredExtent is used when the desired size of a view is requested."

	^self isVertical ifTrue: [self class defaultHeight @ 200] ifFalse: [200 @ self class defaultWidth]!

displayValue
	"Private - Answer the displayed contents, the current scroll position,
	of the receiver"

	^self scrollPosition!

displayValue: anInteger
	"Private - Set the displayable contents of the receiver, the scroll position,
	 to anInteger"

	self scrollPosition: anInteger!

getScrollInfo: siStruct
	"Private - Ask windows for information about the receiver.
	Answer true if values were retrieved successfully."

	^User32
		getScrollInfo: self asParameter
		fnBar: SB_CTL
		lpsi: siStruct!

isTrackingContinuous
	"Answer whether the receiver will update the model as the thumb
	is dragged by the user, or only when they stop dragging."

	^continuousTracking!

isTrackingContinuous: aBoolean
	"Set whether the receiver will update the model as the thumb
	is dragged by the user, or only when they stop dragging."

	continuousTracking := aBoolean!

isVertical
	"Answer whether the receiver is vertically orientated."

	^self baseStyleAllMask: SB_VERT!

isVertical: boolean 
	"Set whether the receiver is vertically orientated."

	self 
		baseStyleMask: SB_VERT
		set: boolean
		recreateIfChanged: false!

onHScroll: aScrollEvent 
	"Handler for a horizontal scroll event."

	| currentValue newValue range pageSize |
	range := self range.
	pageSize := self pageSize max: 1.
	newValue := currentValue := self scrollPosition.
	self isTrackingContinuous 
		ifTrue: [aScrollEvent thumbTrack ifTrue: [newValue := aScrollEvent pos]]
		ifFalse: [aScrollEvent thumbPosition ifTrue: [newValue := aScrollEvent pos]].
	aScrollEvent lineRight ifTrue: [newValue := currentValue + 1].
	aScrollEvent lineLeft ifTrue: [newValue := currentValue - 1].
	aScrollEvent pageRight ifTrue: [newValue := currentValue + pageSize].
	aScrollEvent pageLeft ifTrue: [newValue := currentValue - pageSize].
	aScrollEvent top ifTrue: [newValue := range start].
	aScrollEvent bottom ifTrue: [newValue := range stop].
	newValue := newValue max: range start.
	newValue := newValue min: range stop - pageSize + 1.
	newValue ~= currentValue 
		ifTrue: 
			[self scrollPosition: newValue.
			self updateModel].
	^0!

onVScroll: aScrollEvent 
	"Handler for a vertical scroll event."

	| currentValue newValue range pageSize |
	range := self range.
	pageSize := self pageSize max: 1.
	newValue := currentValue := self scrollPosition.
	self isTrackingContinuous 
		ifTrue: [aScrollEvent thumbTrack ifTrue: [newValue := aScrollEvent pos]]
		ifFalse: [aScrollEvent thumbPosition ifTrue: [newValue := aScrollEvent pos]].
	aScrollEvent lineDown ifTrue: [newValue := currentValue + 1].
	aScrollEvent lineUp ifTrue: [newValue := currentValue - 1].
	aScrollEvent pageDown ifTrue: [newValue := currentValue + pageSize].
	aScrollEvent pageUp ifTrue: [newValue := currentValue - pageSize].
	aScrollEvent top ifTrue: [newValue := range start].
	aScrollEvent bottom ifTrue: [newValue := range stop].
	newValue := newValue max: range start.
	newValue := newValue min: range stop - pageSize + 1.
	newValue ~= currentValue 
		ifTrue: 
			[self scrollPosition: newValue.
			self updateModel].
	^0!

pageSize
	"Answer the page size of the receiver."

	| struct |
	struct := SCROLLINFO newBuffer
				maskIn: SIF_PAGE;
				yourself.
	self getScrollInfo: struct.
	^struct page!

pageSize: page
	"Set the page size of the receiver."

	self setScrollInfo: (SCROLLINFO newBuffer
				page: page;
				yourself)!

range
	"Answer the Interval range of the receiver."

	| struct |
	struct := SCROLLINFO newBuffer
				maskIn: SIF_RANGE;
				yourself.
	self getScrollInfo: struct.
	^struct range!

range: rangeInterval
	"Set the range of the receiver to rangeInterval."

	self setScrollInfo: (SCROLLINFO newBuffer
				range: rangeInterval;
				yourself).
	self refreshContents!

scrollPosition
	"Private - Answer the Integer scroll position of the scroll bars thumb. This is relative
	to its range rather than spatial position."

	| struct |
	struct := SCROLLINFO newBuffer
				maskIn: SIF_POS;
				yourself.
	self getScrollInfo: struct.
	^struct pos!

scrollPosition: positionInteger
	"Private - Set the scroll position of the receiver. This is an Integer within
	the scrollRange of the receiver."

	self setScrollInfo: (SCROLLINFO newBuffer
				pos: positionInteger;
				yourself)!

setScrollInfo: siStruct
	"Private - Set the specified scroll info for the receiver.
	A wrapper for the Win32 function. Answer the current position of the thumb."

	^User32
		setScrollInfo: self asParameter
		fnBar: SB_CTL
		lpsi: siStruct
		fRedraw: true!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	^super state
		add: (MessageSend
					receiver: self
					selector: #range:
					argument: self range);
		add: (MessageSend
					receiver: self
					selector: #pageSize:
					argument: self pageSize);
		yourself! !

!UI.ScrollBar categoriesForMethods!
calculateExtent:!geometry!private! !
defaultExtent!constants!private! !
displayValue!private!updating! !
displayValue:!private!updating! !
getScrollInfo:!accessing!private! !
isTrackingContinuous!accessing!public! !
isTrackingContinuous:!accessing!public! !
isVertical!modes!public! !
isVertical:!modes!public! !
onHScroll:!event handling!public! !
onVScroll:!event handling!public! !
pageSize!accessing!public! !
pageSize:!accessing!public! !
range!accessing!public! !
range:!accessing!public! !
scrollPosition!accessing!private! !
scrollPosition:!accessing!private! !
setScrollInfo:!accessing!private! !
state!accessing!private! !
!

!UI.ScrollBar class methodsFor!

defaultHeight
	^SystemMetrics current scrollThumbExtent y!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^0 asValue!

defaultWidth
	^SystemMetrics current scrollThumbExtent x!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	View registerMessageMappings: {WM_CTLCOLORSCROLLBAR -> #wmCtlColor:wParam:lParam:}!

themePartName
	^#ScrollBar!

uninitialize
	View unregisterMessageMappings: {WM_CTLCOLORSCROLLBAR }!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SCROLLBAR'
! !

!UI.ScrollBar class categoriesForMethods!
defaultHeight!constants!public! !
defaultModel!models!public! !
defaultWidth!constants!public! !
icon!constants!public! !
initialize!development!initializing!private! !
themePartName!constants!private! !
uninitialize!class hierarchy-removing!private! !
winClassName!constants!private! !
!

