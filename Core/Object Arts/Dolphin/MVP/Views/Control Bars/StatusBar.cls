"Filed out from Dolphin Smalltalk"!

ControlBarAbstract subclass: #StatusBar
	instanceVariableNames: 'parts leftOverSeparator layoutManager'
	classVariableNames: ''
	poolDictionaries: 'StatusBarConstants'
	classInstanceVariableNames: ''!

StatusBar guid: (GUID fromString: '{87b4c72e-026e-11d3-9fd7-00a0cc3e4a32}')!

StatusBar comment: '`StatusBar` is a `<compositeView>` implementing the Windows "Msctls_Statusbar32" common control.

`StatusBar` holds a list of items, sub-instances of `StatusBarItemAbstract`, matching the order of items in the control. Items may be added and deleted once the view has been created. It also allows a name to be associated with each item. 

Note that, internally, an additional separator is  placed as the first item in the status common control when there are no user parts. This is because the common control does not allow you to remove all the items completely.

## Instance Variables:
  `parts`				`<Array>` of `StatusBarItemAbstract`.
  `leftOverSeparator`	`StatusBarNullItem`
  `layoutManager`		`<layoutManager>` or `nil`, for managing the layout of sub-views, if any.

'!

!StatusBar categoriesForClass!MVP-Views! !

!StatusBar methodsFor!

addItem: aStatusBarItem 
	"Append a new <StatusBarItem> to the list of items displayed in the receiver. Answer the new
	item."

	aStatusBarItem parentView: self.
	parts := self contents copyWith: aStatusBarItem.
	self updateItem: aStatusBarItem.
	^aStatusBarItem!

addItem: aStatusBarItem name: aString 
	"Append a new <StatusBarItem> to the list of items displayed in the receiver, associating
	the new item with the specified <String> name. Answer the new item."

	self addItem: aStatusBarItem.
	self name: aStatusBarItem as: aString.
	^aStatusBarItem!

contents
	"Answer a copy of all the accessible parts of the receiver."

	^parts copyWithout: leftOverSeparator!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter preferredExtent is used when the desired size of a view is requested."

	^##(350 @ 20)!

defaultWindowStyle
	"Private - Answer a default base style to use when creating the receiver"

	^super defaultWindowStyle bitOr: ##(SBARS_SIZEGRIP | SBARS_TOOLTIPS)!

getWindowText
	"Private - Answers the text from the receiver. There is a bug in
	the status common control which will fail if the first part has
	SBT_OWNERDRAW set."

	^''!

getWindowTextLength
	"Private - Answers the length of text for the receiver. There is
	a bug in the status common control which will fail if the first part
	has SBT_OWNERDRAW set."

	^0!

hasSizeGrip
	"Answers true if the receiver has a sizeing grip.
	i.e. it has the SBARS_SIZEGRIP style"

	^self baseStyleAllMask: SBARS_SIZEGRIP!

hasSizeGrip: aBoolean 
	"Sets the receiver to have a sizeing grip if aBoolean is true. This is the SBARS_SIZEGRIP
	style."

	" Implementation Note: Help doesn't specify, but recreate is required to add or remove this
	style. Also, on XP turning off the style has no effect if the status bar is created or
	recreated as a child of a window with a resizable frame."

	self 
		baseStyleMask: SBARS_SIZEGRIP
		set: aBoolean
		recreateIfChanged: true!

hasToolTips
	"Answer whether or not the receiver has tool tips (i.e. the SBARS_TOOLTIPS style)."

	^self baseStyleAllMask: SBARS_TOOLTIPS!

hasToolTips: aBoolean 
	"Set whether or not the receiver has tool tips (i.e. the SBARS_TOOLTIPS style)."

	"Implementation Note: Help says recreate needed to add this style."

	self 
		baseStyleMask: SBARS_TOOLTIPS
		set: aBoolean
		recreateIfChanged: true!

indexFromPoint: aPoint 
	"Private - Answer the index of the object in the list under the <Point> argument, or nil if
	none."

	^(1 to: parts size) detect: [:i | (self itemRect: i) containsPoint: aPoint] ifNone: [0]!

indexOfItem: part 
	"Private - Answer the 1-based <integer> index of part."

	^parts identityIndexOf: part!

initialize
	"Private - Initialize the state of the receiver.

	Note that we ensure that an empty separator is included as
	the first part. This is because of an apparent common control bug
	when you remove the last part in a status view, the SB_SETPARTS will
	return an error."

	super initialize.
	(leftOverSeparator := StatusBarNullItem separator: 0) parentView: self.
	parts := {leftOverSeparator}!

itemAtIndex: anIntegerIndex 
	"Answers the status bar item at anIntegerIndex in the receiver"

	^parts at: anIntegerIndex!

itemFromId: dwItemSpec
	"Private - Answers the sub-item of the receiver with the specified <integer> item spec."

	^parts lookup: dwItemSpec + 1!

itemRect: anInteger
	"Answer the bounding <Rectangle> for the item at the specified 1-based <Integer> index."

	| rect |
	rect := (self sbGetRect: anInteger - 1) asRectangle.
	"There is an apparent bug in the status bar control in that it may report the rectangle of
	the last item wrongly"
	(rect width = 0 and: [self width > 0]) ifTrue: [rect width: self width].
	^rect!

items
	"Private - Answer the receiver's <OrderedCollection> of <StatusItem>s."

	^parts asOrderedCollection!

items: aCollection
	"Private - Sets the receiver's collection of <StatusItem>s to those in 
	the <collection>, tools.
	Implementation Note: The items are stored as an <Array> to save space."

	aCollection size > 256 ifTrue: [self error: 'Too many items'].
	parts := aCollection asArray.
	self recreate!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver."

	"Implementation Note: After performing the normal layout operation we want to recalculate
	the widths of the automatically resizing items."

	super layout: aLayoutContext.
	self setRightEdges: (aLayoutContext clientRectangleOf: self) width!

layoutManager
	"Answer the layout manager for the receiver"

	^layoutManager!

layoutManager: aLayoutManager 
	"Set the layout manager for the receiver to aLayoutManager"

	layoutManager := aLayoutManager.
	self basicInvalidateLayout!

onDrawItem: drawItemStruct 
	| part |
	part := parts at: drawItemStruct itemID + 1.
	part drawItem: (Canvas withNonOwnedDC: drawItemStruct hDC)
		bounding: drawItemStruct rcItem asRectangle.
	^true!

onViewCreated
	"The receiver window has been created. Copy the info held
	in instance variables across to it."

	super onViewCreated.
	self setControlBackcolor.
	self setRightEdges.
	parts do: 
			[:part |
			part parentView: self.
			self setItemText: part]!

rectangleOfItem: aStatusBarItem 
	^self itemRect: (self indexOfItem: aStatusBarItem)!

removeItem: aStatusBarItem
	"Remove aStatusOwnerDraw from the receivers contents of visible parts.
	Answer aStatusOwnerDraw.

	Note that we always ensure that there is one part, the leftOverSeparator,
	registered with the common control to get around a bug in the control."

	| partIndex |
	partIndex := parts indexOfItem: aStatusBarItem.
	parts size = 1 ifTrue: [self addItem: leftOverSeparator].
	parts remove: aStatusBarItem.
	aStatusBarItem parentView: nil.
	self setRightEdges.
	parts
		from: partIndex
		to: parts size
		do: [:part | self setItemText: part].
	^aStatusBarItem!

resolutionScaledBy: aPoint
	super resolutionScaledBy: aPoint.
	parts do: [:each | each resolutionScaledBy: aPoint]!

rightEdgesForWidth: anInteger
	| edges right fixedWidth numResizable widths numParts borders horizontalGap share |
	numParts := parts size.
	numParts < 1
		ifTrue: 
			["Control can't actually contain no parts, so we put a dummy one in."
			^SDWORDArray with: -1].
	numResizable := 0.
	fixedWidth := 0.
	borders := self sbGetBorders.
	horizontalGap := borders at: 3.
	widths := Array new: numParts.
	1 to: numParts
		do: 
			[:i |
			| width |
			width := (parts at: i) width.
			width = -1 ifTrue: [numResizable := numResizable + 1] ifFalse: [fixedWidth := fixedWidth + width].
			widths at: i put: width].
	right := borders at: 1.
	"Note `share` can be a Fraction. This is slow, but there are typically only a few parts (max 256), and avoids accumulating rounding error."
	share := numResizable == 0
				ifFalse: 
					[(anInteger - right - fixedWidth - self sizeGripWidth - ((numParts - 1) * horizontalGap))
						/ numResizable].
	edges := SDWORDArray new: numParts.
	1 to: numParts
		do: 
			[:i |
			| width |
			width := widths at: i.
			right := right + (width == -1 ifTrue: [share] ifFalse: [width]).
			edges at: i put: right truncated.
			right := right + horizontalGap].
	^edges!

sbGetBorders
	"Private - Answer a <sequencedReadableCollection> containing:

	 1	width of the horizontal border (width inset for the bar)
	 2	width of the vertical border (height inset for the bar)
	 3	gap between parts (i.e. width of gap between item rectangles)"

	| answer |
	answer := SDWORDArray new: 3.
	self 
		sendMessage: SB_GETBORDERS
		wParam: 0
		lpParam: answer.
	^answer!

sbGetRect: anInteger 
	| rect |
	rect := RECT new.
	(self 
		sendMessage: SB_GETRECT
		wParam: anInteger
		lpParam: rect) == 0 
		ifTrue: 
			["self errorInCommonControlCall"
			].
	^rect!

sbGetTipText: anInteger
	| buf |
	buf := Utf16String new: INFOTIPSIZE.
	self
		sendMessage: SB_GETTIPTEXT
		wParam: (anInteger bitOr: ##(INFOTIPSIZE << 16))
		lpParam: buf.
	^buf trimNulls!

setControlBackcolor: aColor 
	self 
		sendMessage: SB_SETBKCOLOR
		wParam: 0
		lParam: aColor asCOLORREF!

setItem: aStatusBarItem tipText: aString
	"Private - Set the tool-tip text of the specified <StatusBarItem> of the receiver, to the <readableString, aString."

	"Note that tooltips are inoperative for owner-drawn items."

	self
		sendMessage: SB_SETTIPTEXT
		wParam: (self indexOfItem: aStatusBarItem) - 1
		lpParam: aString asUtf16String!

setItemText: aStatusBarItem
	"Private - Set the SB_SETTEXT of the receivers common control for	specified one of the receiver's <StatusBarItem>s."

	"In the case of owner-drawn items, this amounts to an instruction to the control to request re-draw of the item."

	| index style lParam |
	(index := self indexOfItem: aStatusBarItem) == 0 ifTrue: [^self].
	style := aStatusBarItem style.
	lParam := (style allMask: SBT_OWNERDRAW)
				ifTrue: 
					["If owner drawn, we don't need to pass the text"
					0]
				ifFalse: [aStatusBarItem getText asUtf16String].
	(self
		sendMessage: SB_SETTEXT
		wParam: (style bitOr: index - 1)
		lpParam: lParam) == 0
		ifTrue: [^self errorInCommonControlCall]!

setRightEdges
	"Private - Inform the common control of the right edge for each of the receiver's parts."

	^self setRightEdges: self clientWidth!

setRightEdges: anInteger
	| edges |
	edges := self rightEdgesForWidth: anInteger.
	(self
		sendMessage: SB_SETPARTS
		wParam: edges size
		lpParam: edges) == 0
		ifTrue: [^self errorInCommonControlCall]!

setWindowText: aString 
	"Private - Sets the text of the receiver. There is a bug in
	the status common control which will fail if the first part has
	SBT_OWNERDRAW set."

	^self!

size
	"Answer the size of the receivers contents."

	^self contents size!

sizeGripWidth
	^self hasSizeGrip ifTrue: [SystemMetrics current scrollThumbExtent x] ifFalse: [0]!

updateItem: aStatusBarItem
	"Private - Update the controls knowledge of this part."

	self setRightEdges.
	self setItemText: aStatusBarItem.
	self invalidateRect: (self rectangleOfItem: aStatusBarItem)! !

!StatusBar categoriesForMethods!
addItem:!adding!items!public! !
addItem:name:!adding!items!public! !
contents!accessing!public! !
defaultExtent!constants!private! !
defaultWindowStyle!constants!private! !
getWindowText!accessing!private!win32 bug fix! !
getWindowTextLength!accessing!private!win32 bug fix! !
hasSizeGrip!accessing-styles!public! !
hasSizeGrip:!accessing-styles!public! !
hasToolTips!accessing-styles!public! !
hasToolTips:!accessing-styles!public! !
indexFromPoint:!accessing!enquiries!private! !
indexOfItem:!items!private! !
initialize!initializing!private! !
itemAtIndex:!items!public! !
itemFromId:!accessing!private! !
itemRect:!geometry!public! !
items!accessing!private! !
items:!accessing!private! !
layout:!geometry!private! !
layoutManager!geometry!public! !
layoutManager:!geometry!public! !
onDrawItem:!event handling-win32!public! !
onViewCreated!event handling!public! !
rectangleOfItem:!accessing!private! !
removeItem:!items!public!removing! !
resolutionScaledBy:!geometry!private! !
rightEdgesForWidth:!geometry!private! !
sbGetBorders!accessing!private! !
sbGetRect:!accessing!private! !
sbGetTipText:!accessing!private! !
setControlBackcolor:!helpers!private! !
setItem:tipText:!operations!private! !
setItemText:!accessing!private! !
setRightEdges!helpers!private! !
setRightEdges:!helpers!private! !
setWindowText:!accessing!private!win32 bug fix! !
size!accessing!public! !
sizeGripWidth!constants!private! !
updateItem:!private!updating! !
!

!StatusBar class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Status_bar
	"Answer the literal data from which the 'Status bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Status_bar)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StatusBar) 34 18 nil nil 34 2 8 1409288460 1 416 nil 327686 ##(Smalltalk.Color) #default nil 5 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 8 1903688272 170 192 8 #() 34 1 853766 ##(Smalltalk.StatusBarItem) 1 -1 416 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 722 #iconImageIndex 8 #() nil 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 416 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 3839 21 594 701 45 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 32 0 0 0] 8 #() 594 193 193 nil 27 )!

themePartName
	^'STATUS'
!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'msctls_statusbar32'! !

!StatusBar class categoriesForMethods!
icon!constants!public! !
resource_Status_bar!public!resources-views! !
themePartName!constants!private! !
winClassName!constants!private! !
!

