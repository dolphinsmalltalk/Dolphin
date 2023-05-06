"Filed out from Dolphin Smalltalk"!

UI.ValueConvertingControlView
	subclass: #'UI.Slider'
	instanceVariableNames: 'autoTickFrequency _reserved1 _reserved2'
	classVariableNames: ''
	imports: #(#{OS.TrackBarConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'HorizontalTickStyles'
				-> (IdentityDictionary withAll: { #bothSides -> 16r8. #bottom -> 16r0. #top -> 16r4 }).
			'TickStyleMask' -> 16rC.
			'VerticalTickStyles'
				-> (IdentityDictionary withAll: { #bothSides -> 16r8. #left -> 16r4. #right -> 16r0 })
		}!
UI.Slider guid: (Core.GUID fromString: '{425d0eab-542e-11d3-998b-d5ca2c3c1d61}')!
UI.Slider comment: 'Slider is a <valueView> implementing the Windows "msctls_trackbar32" common control. The <valueModel> associated with a Slider must always yield an <integer> value when mapped through the installed type converter. A Slider will normally be used in conjunction with a <NumberPresenter>.

Thanks to Ian Bartholomew for donating his original version of this class.'!
!UI.Slider categoriesForClass!MVP-Views! !
!UI.Slider methodsFor!

applicableTickStyles
	^self isVertical ifTrue: [VerticalTickStyles] ifFalse: [HorizontalTickStyles]!

autoTickFrequency: anInteger 
	autoTickFrequency := anInteger.
	self hasAutoTicks ifTrue: [self sendMessage: TBM_SETTICFREQ wParam: anInteger]!

backcolorChanged
	super backcolorChanged.
	"Must recreate this particular control in order for it to request the background colour it seems"
	self recreate!

channelRectangle
	"Answer a <Rectangle> representing the area of the receiver occupied by the slider channel."

	^self getRect: TBM_GETCHANNELRECT!

clearTicks
	"Clears the current ticks"

	self sendMessage: TBM_CLEARTICS wParam: true asParameter.
	self sendMessage: TBM_SETTICFREQ wParam: 1!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^##(100 @ 35)!

displayValue
	"Private - Answer the displayable contents of the receiver"

	^self sendMessage: TBM_GETPOS!

displayValue: anInteger 
	"Private - Set the displayable contents of the receiver"

	self 
		sendMessage: TBM_SETPOS
		wParam: true asParameter
		lParam: anInteger!

getRect: msgInteger
	| rect |
	rect := RECTL newBuffer.
	self
		sendMessage: msgInteger
		wParam: 0
		lpParam: rect.
	^rect asRectangle!

hasAutoTicks
	"Answer whether the receiver automatically add ticks when the #range is set (one tick for
	each integral element in the range)."

	^self baseStyleAllMask: TBS_AUTOTICKS!

hasAutoTicks: aBoolean 
	"Set the receiver to automatically add ticks when #range: is subsequently set. 
	Note that explicitly setting the #ticks attribute will turn off auto-ticks."

	self 
		baseStyleMask: TBS_AUTOTICKS
		set: aBoolean
		recreateIfChanged: false.
	aBoolean ifTrue: [self range: self range] ifFalse: [self clearTicks]!

hasFixedLength
	"Private - Answer whether the receiver's slider has a fixed length"

	^self baseStyleAllMask: TBS_FIXEDLENGTH!

hasFixedLength: aBoolean 
	"Private - Set whether the receiver's slider has a fixed length"

	self 
		baseStyleMask: TBS_FIXEDLENGTH
		set: aBoolean
		recreateIfChanged: false!

hasThumb
	"Answer whether the receiver displays a thumb"

	^(self baseStyleAllMask: TBS_NOTHUMB) not!

hasThumb: aBoolean 
	"Set whether the receiver displays a thumb."

	self 
		baseStyleMask: TBS_NOTHUMB
		set: aBoolean not
		recreateIfChanged: false!

hasTicks
	"Answer whether the receiver displays ticks or not"

	^(self baseStyleAllMask: TBS_NOTICKS) not!

hasTicks: aBoolean 
	"Set  whether the receiver displays ticks or not."

	self 
		baseStyleMask: TBS_NOTICKS
		set: aBoolean not
		recreateIfChanged: false!

hasToolTips
	"Answer whether the receiver displays tool tips."

	^self baseStyleAllMask: TBS_TOOLTIPS!

hasToolTips: aBoolean 
	"Set whether the receiver displays tool tips."

	self baseStyleMask: TBS_TOOLTIPS set: aBoolean!

initialize
	super initialize.
	autoTickFrequency := 1!

isSelectionEnabled
	"Private - Answer whether the receiver selects a range"

	^self baseStyleAllMask: TBS_ENABLESELRANGE!

isSelectionEnabled: aBoolean 
	"Private - Set whether the receiver selects a range."

	self 
		baseStyleMask: TBS_ENABLESELRANGE
		set: aBoolean
		recreateIfChanged: false!

isVertical
	"Answer whether the receiver is vertically orientated."

	^self baseStyleAllMask: TBS_VERT!

isVertical: aBoolean 
	"Set whether the receiver is vertically orientated."

	self 
		baseStyleMask: TBS_VERT
		set: aBoolean
		recreateIfChanged: false!

lineSize
	"Answer the current line size of the receiver.  This is the distance the slider will move in
	response to a cursor key press."

	^self sendMessage: TBM_GETLINESIZE!

lineSize: anInteger 
	"Set the current line size of the receiver, answering the previous line size."

	^self 
		sendMessage: TBM_SETLINESIZE
		wParam: 0
		lParam: anInteger!

onHScroll: aScrollEvent 
	self updateModel.
	^0!

onVScroll: aScrollEvent 
	self updateModel.
	^0!

pageSize
	"Answer the current page size of the receiver. This is the distance the slider will move in
	response to a Page Up or Page Down key press."

	^self sendMessage: TBM_GETPAGESIZE!

pageSize: anInteger 
	"Set the current page size of the receiver, answering the previous page size."

	^self 
		sendMessage: TBM_SETPAGESIZE
		wParam: 0
		lParam: anInteger!

range
	"Answer an <Interval> specifying the current bar range of the receiver."

	^(self sendMessage: TBM_GETRANGEMIN) to: (self sendMessage: TBM_GETRANGEMAX) by: autoTickFrequency!

range: anIntegerInterval
	"Set the receiver's bar range to the <Interval> argument. Note that the start, stop and
	increment of the Interval must be <integer>s, the step must be positive, and the interval
	should not be empty. The 'step' of the interval is used to position the ticks (if
	auto-generated)."

	self autoTickFrequency: anIntegerInterval step.
	self
		sendMessage: TBM_SETRANGEMIN
		wParam: 0
		lParam: anIntegerInterval start.
	self
		sendMessage: TBM_SETRANGEMAX
		wParam: 1
		lParam: anIntegerInterval stop!

selectionRange
	"Answer the current selection range of the receiver, or nil if their is none."

	^self isSelectionEnabled 
		ifTrue: [(self sendMessage: TBM_GETSELSTART) to: (self sendMessage: TBM_GETSELEND)]!

selectionRange: anIntervalOrNil 
	"Set the receiver's selection range to anIntegerIntervalOrNil."

	anIntervalOrNil notNil 
		ifTrue: 
			[self isSelectionEnabled: true.
			self 
				sendMessage: TBM_SETSELSTART
				wParam: false asParameter
				lParam: anIntervalOrNil start.
			self 
				sendMessage: TBM_SETSELEND
				wParam: true asParameter
				lParam: anIntervalOrNil stop]
		ifFalse: [self isSelectionEnabled: false]!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	| state |
	state := super state.
	"If auto-ticks is on, we must avoid manually setting the ticks, which will turn off auto-ticks"
	self hasAutoTicks
		ifFalse: 
			[self ticks
				ifNotNil: 
					[:ticks |
					state add: (MessageSend
								receiver: self
								selector: #ticks:
								argument: ticks)]].
	#(#(#pageSize: #pageSize 20) #(#lineSize: #lineSize 1) #(#range: #range nil) #(#selectionRange: #selectionRange nil) #(#thumbLength: #thumbLength nil))
		do: 
			[:each |
			| value |
			value := self perform: each second.
			value = each last
				ifFalse: 
					[state add: (MessageSend
								receiver: self
								selector: each first
								argument: value)]].
	^state!

tbmClearSel
	self sendMessage: TBM_CLEARSEL wParam: true asParameter!

tbmGetBuddy: aBoolean 
	"Private - Get the handle of the buddy window. If aBoolean is true we answer
	the buddy window above/left, false answers below/right."

	^self sendMessage: TBM_GETBUDDY wParam: aBoolean asParameter!

tbmGetTicPos: anInteger 
	"Private - Answer the physical position (on the trackbar) in pixels of the anInteger'th tick 
	or -1 if anInteger is invalid"

	^self sendMessage: TBM_GETTICPOS wParam: anInteger!

tbmGetToolTips
	"Private - Answer the handle of the tooltip control associated with the trackbar"

	^self sendMessage: TBM_GETTOOLTIPS!

tbmGetUnicodeFormat
	"Private - Answer the UNICODE character format for the control"

	^self sendMessage: TBM_GETUNICODEFORMAT!

tbmSetBuddy: aBoolean handle: aHandle 
	"Private - Set the buddy window at aBoolean (Top/Left or Bottom/Right) to be the window with
	handle aHandle"

	^self 
		sendMessage: TBM_SETBUDDY
		wParam: aBoolean asParameter
		lParam: aHandle!

tbmSetTipSide: anInteger 
	"Private - Set the side of the control where the tool tip is placed"

	^self sendMessage: TBM_SETTIPSIDE wParam: anInteger!

tbmSetToolTips: aHandle 
	"Private - Set the handle to be used for the tool tip window"

	^self sendMessage: TBM_SETTOOLTIPS wParam: aHandle!

thumbLength
	"Answer the length, in pixels, of the thumb, or nil if the thumb metrics are left up to the control."

	^self hasFixedLength ifTrue: [self sendMessage: TBM_GETTHUMBLENGTH]!

thumbLength: anIntegerOrNil 
	"Set the length, in pixels, of the thumb.
	Note that will have no effect unless the receiver is of fixed length."

	anIntegerOrNil isNil 
		ifTrue: [self hasFixedLength: false]
		ifFalse: 
			[self hasFixedLength: true.
			self sendMessage: TBM_SETTHUMBLENGTH wParam: anIntegerOrNil]!

thumbRectangle
	"Answer a <Rectangle> giving the position and extent of the slider thumb."

	^self getRect: TBM_GETTHUMBRECT!

ticks
	"Answer a collection giving the current tick marks or an empty array if there are none.
	Note that the collection is in no particular order."

	| count ticks pdw range |
	range := self range.
	self hasAutoTicks ifTrue: [^range asArray].
	count := self sendMessage: TBM_GETNUMTICS.
	count = 0
		ifTrue: 
			["#hasTicks = false"
			^#()].
	ticks := Array writeStream.
	ticks nextPut: range start.
	pdw := self sendMessage: TBM_GETPTICS.
	pdw isNull
		ifFalse: [ticks nextPutAll: (UInt32Array fromAddress: pdw asExternalAddress length: count - 2) asArray].
	ticks nextPut: range stop.
	^ticks contents!

ticks: aCollection
	"Show the tick marks in aCollection. Any existing ticks are removed."

	"For legacy reasons we allow the argument to be nil."

	| range lower upper |
	aCollection ifNil: [^self].
	self clearTicks.
	self hasAutoTicks: false.
	aCollection isEmpty
		ifTrue: 
			[self hasTicks: false.
			^self].
	self hasTicks: true.
	range := self range.
	lower := range start + 1.
	upper := range stop - 1.
	aCollection do: 
			[:each |
			(each between: lower and: upper)
				ifTrue: 
					[self
						sendMessage: TBM_SETTIC
						wParam: 0
						lParam: each]]!

tickStyle
	"Answer a <Symbol> identifiying the position of the receiver's ticks."

	| alignment |
	alignment := self baseStyle bitAnd: TickStyleMask.
	^self applicableTickStyles keyAtValue: alignment!

tickStyle: aSymbol 
	"Set the position of the receiver's ticks. These can be either above, below or on both sides
	of the channel if the receiver has a horizontal orientation, or left, right or on both sides
	if the receiver is vertical."

	self 
		baseStyle: (HorizontalTickStyles at: aSymbol ifAbsent: [VerticalTickStyles at: aSymbol])
		maskedBy: TickStyleMask
		recreateIfChanged: false! !
!UI.Slider categoriesForMethods!
applicableTickStyles!constants!private! !
autoTickFrequency:!accessing!private! !
backcolorChanged!accessing!helpers!private! !
channelRectangle!accessing!public! !
clearTicks!operations!public! !
defaultExtent!constants!private! !
displayValue!private!updating! !
displayValue:!private!updating! !
getRect:!helpers!private! !
hasAutoTicks!accessing-styles!public!updating! !
hasAutoTicks:!accessing-styles!public!updating! !
hasFixedLength!accessing-styles!private!updating! !
hasFixedLength:!accessing-styles!private!updating! !
hasThumb!accessing-styles!public!updating! !
hasThumb:!accessing-styles!public!updating! !
hasTicks!accessing-styles!public!updating! !
hasTicks:!accessing-styles!public!updating! !
hasToolTips!accessing-styles!public!updating! !
hasToolTips:!accessing-styles!public!updating! !
initialize!initializing!public! !
isSelectionEnabled!accessing-styles!private! !
isSelectionEnabled:!accessing-styles!private! !
isVertical!accessing-styles!public! !
isVertical:!accessing-styles!public! !
lineSize!accessing!public! !
lineSize:!accessing!public! !
onHScroll:!event handling!private! !
onVScroll:!event handling!private! !
pageSize!accessing!public! !
pageSize:!accessing!public! !
range!accessing!public! !
range:!accessing!public! !
selectionRange!accessing!public! !
selectionRange:!accessing!public! !
state!accessing!private! !
tbmClearSel!helpers!private! !
tbmGetBuddy:!helpers!private! !
tbmGetTicPos:!helpers!private! !
tbmGetToolTips!helpers!private! !
tbmGetUnicodeFormat!helpers!private! !
tbmSetBuddy:handle:!helpers!private! !
tbmSetTipSide:!helpers!private! !
tbmSetToolTips:!helpers!private! !
thumbLength!accessing!public! !
thumbLength:!accessing!public! !
thumbRectangle!accessing!public! !
ticks!accessing!public! !
ticks:!operations!public! !
tickStyle!accessing!public! !
tickStyle:!accessing!public! !
!

!UI.Slider class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^0 asValue!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	CommCtrlLibrary addInitFlag: ICC_BAR_CLASSES.
	self addClassConstant: 'TickStyleMask' value: ##(TBS_TOP | TBS_BOTH | TBS_BOTTOM).
	self addClassConstant: 'HorizontalTickStyles'
		value: (IdentityDictionary new
				at: #top put: TBS_TOP;
				at: #bottom put: TBS_BOTTOM;
				at: #bothSides put: TBS_BOTH;
				shrink;
				beReadOnlyObject;
				yourself).
	self addClassConstant: 'VerticalTickStyles'
		value: (IdentityDictionary new
				at: #left put: TBS_LEFT;
				at: #right put: TBS_RIGHT;
				at: #bothSides put: TBS_BOTH;
				shrink;
				shrink;
				yourself)!

stbConvertFromVersion9: anArray 
	"Private - Perform an STB conversion from a version 9 (or earlier) <View> to version 10,
	i.e. autoTickFrequency and two spare inst. var's added."

	^(super stbConvertFromVersion9: anArray) , #(1 nil nil)!

themePartName
	^'TRACKBAR'!

uninitialize
	#{UI.ControlBarAbstract} isDefined ifFalse: [CommCtrlLibrary removeInitFlag: ICC_BAR_CLASSES]!

winClassName
	"Answer the name of the Windows window class to use when realizing the receiver."

	^'msctls_trackbar32'! !
!UI.Slider class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!development!initializing!private! !
stbConvertFromVersion9:!binary filing!private! !
themePartName!constants!private! !
uninitialize!class hierarchy-removing!public! !
winClassName!constants!private! !
!

