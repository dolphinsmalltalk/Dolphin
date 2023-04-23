"Filed out from Dolphin Smalltalk"!

UI.ControlBarAbstract
	subclass: #'UI.StatusBar'
	instanceVariableNames: 'parts leftOverSeparator layoutManager'
	classVariableNames: ''
	imports: #(#{OS.StatusBarConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.StatusBar guid: (Core.GUID fromString: '{87b4c72e-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.StatusBar comment: '`StatusBar` is a `<compositeView>` implementing the Windows "Msctls_Statusbar32" common control.

`StatusBar` holds a list of items, sub-instances of `StatusBarItemAbstract`, matching the order of items in the control. Items may be added and deleted once the view has been created. It also allows a name to be associated with each item. 

Note that, internally, an additional separator is placed as the first item in the status common control when there are no user parts. This is because the common control does not allow you to remove all the items completely.

## Instance Variables:
  `parts`				`<Array>` of `StatusBarItemAbstract`.
  `leftOverSeparator`	`StatusBarNullItem`
  `layoutManager`		`<layoutManager>` or `nil`, for managing the layout of sub-views, if any.

'!
!UI.StatusBar categoriesForClass!MVP-Views! !
!UI.StatusBar methodsFor!

addItem: aStatusBarItem
	"Append a new <StatusBarItem> to the list of items displayed in the receiver. Answer the new item."

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
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(350 @ 20)!

defaultWindowStyle
	"Private - Answer a default base style to use when creating the receiver"

	^super defaultWindowStyle bitOr: ##(SBARS_SIZEGRIP | SBARS_TOOLTIPS)!

getItemRect: anInteger
	"Private - Answer a <RECTL> describing the bounds of item at the specified zero-based <Integer> index."

	| rect |
	rect := RECTL newBuffer.
	self
		sendMessage: SB_GETRECT
		wParam: anInteger
		lpParam: rect.
	"There is an apparent bug in the status bar control in that it may report the rectangle of the last item wrongly"
	(rect width == 0 and: [self width > 0]) ifTrue: [rect width: self width].
	^rect!

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

indexOfItem: aStatusBarItem 
	"Private - Answer the 1-based <integer> index of the <StatusBarItem> argument, or 0 if it is not one of the receiver's parts."

	^parts identityIndexOf: aStatusBarItem!

initialize
	"Private - Initialize the state of the receiver."

	"Note that we ensure that an empty separator is included as the first part. This is because of an apparent common control bug when you remove the last part in a status view, the SB_SETPARTS will return an error."

	super initialize.
	(leftOverSeparator := StatusBarNullItem separator: 0) parentView: self.
	parts := { leftOverSeparator }!

invalidateItem: aStatusBarItem
	self invalidateRect: (self getItemRect: (self indexOfItem: aStatusBarItem) - 1)!

itemAtIndex: anInteger
	"Answers the <StatusBarItem> at the specified 1-based <integer> in the receiver."

	^parts at: anInteger!

itemFromId: anInteger
	"Private - Answers the sub-item of the receiver with the specified 0-based <integer> item spec."

	^parts lookup: anInteger + 1!

items
	"Private - Answer the receiver's parts as an <OrderedCollection> of <StatusItem>s."

	^parts asOrderedCollection!

items: aCollection
	"Private - Sets the receiver's collection of <StatusItem>s to those in the <collection>, tools."

	"Implementation Note: The items are stored as an <Array> for efficiency since they are generally not changed once the view has been created."

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
	part drawItem: (Canvas withNonOwnedDC: drawItemStruct hDC) bounding: drawItemStruct rcItem.
	^true!

onViewCreated
	"The receiver window has been created. Copy the info held
	in instance variables across to it."

	super onViewCreated.
	self setControlBackcolor.
	self setRightEdges.
	1 to: parts size
		do: 
			[:i |
			| part |
			part := parts at: i.
			part parentView: self.
			self setItemText: part at: i]!

rectangleOfItem: aStatusBarItem 
	^self itemRect: (self indexOfItem: aStatusBarItem)!

removeItem: aStatusBarItem
	"Remove the specified <StatusBarItem> from the receiver's visible parts. Answer the argument."

	"Note that we always ensure that there is one part, the leftOverSeparator, registered with the common control to get around a bug in the control."

	| index |
	index := self indexOfItem: aStatusBarItem.
	index == 0 ifTrue: [^self errorNotFound: aStatusBarItem].
	parts size == 1 ifTrue: [self addItem: leftOverSeparator].
	parts := parts copyWithoutIndex: index.
	aStatusBarItem parentView: nil.
	self setRightEdges.
	index to: parts size do: [:i | self setItemText: (parts at: i) at: i].
	^aStatusBarItem!

rightEdgesForWidth: anInteger
	| edges width right fixedWidth numResizable numParts horizontalGap share |
	numParts := parts size.
	numParts < 1
		ifTrue: 
			["Control can't actually contain no parts, so we put a dummy one in."
			^Int32Array with: -1].
	numResizable := 0.
	fixedWidth := 0.
	edges := self sbGetBorders.
	1 to: numParts
		do: 
			[:i |
			width := (parts at: i) width.
			width == -1 ifTrue: [numResizable := numResizable + 1] ifFalse: [fixedWidth := fixedWidth + width]].
	right := edges at: 1.
	horizontalGap := edges at: 3.
	"Note `share` can be a Fraction. This is slow, but there are typically only a few parts (max 256), and avoids accumulating rounding error."
	share := numResizable == 0
				ifFalse: 
					[(anInteger - right - fixedWidth - self sizeGripWidth - ((numParts - 1) * horizontalGap))
						/ numResizable].
	edges := Int32Array new: numParts.
	1 to: numParts
		do: 
			[:i |
			width := (parts at: i) width.
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
	answer := Int32Array new: 3.
	self
		sendMessage: SB_GETBORDERS
		wParam: 0
		lpParam: answer.
	^answer!

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

setItemText: aStatusBarItem at: anInteger
	"Private - Set the SB_SETTEXT of the receiver's common control for specified one of the receiver's <StatusBarItem>s."

	"In the case of owner-drawn items, this amounts to an instruction to the control to request re-draw of the item, and we don't need to pass the text here."

	| style |
	style := aStatusBarItem style.
	self
		sendMessageNz: SB_SETTEXT
		wParam: (style bitOr: anInteger - 1)
		lpParam: ((style allMask: SBT_OWNERDRAW) ifFalse: [aStatusBarItem getText asUtf16String])!

setRightEdges
	"Private - Inform the common control of the right edge for each of the receiver's parts."

	^self setRightEdges: self clientWidth!

setRightEdges: anInteger
	| edges |
	edges := self rightEdgesForWidth: anInteger.
	self
		sendMessageNz: SB_SETPARTS
		wParam: edges size
		lpParam: edges!

setWindowText: aString 
	"Private - Sets the text of the receiver. There is a bug in
	the status common control which will fail if the first part has
	SBT_OWNERDRAW set."

	^self!

size
	"Answer the size of the receiver's contents."

	^self contents size!

sizeGripWidth
	^self hasSizeGrip ifTrue: [SystemMetrics current scrollThumbExtent x] ifFalse: [0]!

updateItem: aStatusBarItem
	"Private - Update the controls knowledge of this part."

	| index |
	index := self indexOfItem: aStatusBarItem.
	index == 0 ifTrue: [^self].
	self setRightEdges.
	self setItemText: aStatusBarItem at: index.
	self invalidateRect: (self getItemRect: index - 1)! !
!UI.StatusBar categoriesForMethods!
addItem:!adding!items!public! !
addItem:name:!adding!items!public! !
contents!accessing!public! !
defaultExtent!constants!private! !
defaultWindowStyle!constants!private! !
getItemRect:!geometry!private! !
getWindowText!accessing!private!win32 bug fix! !
getWindowTextLength!accessing!private!win32 bug fix! !
hasSizeGrip!accessing-styles!public! !
hasSizeGrip:!accessing-styles!public! !
hasToolTips!accessing-styles!public! !
hasToolTips:!accessing-styles!public! !
indexOfItem:!items!private! !
initialize!initializing!private! !
invalidateItem:!drawing!public! !
itemAtIndex:!items!public! !
itemFromId:!accessing!private! !
items!accessing!private! !
items:!accessing!private! !
layout:!geometry!private! !
layoutManager!geometry!public! !
layoutManager:!geometry!public! !
onDrawItem:!event handling-win32!public! !
onViewCreated!event handling!public! !
rectangleOfItem:!accessing!private! !
removeItem:!items!public!removing! !
rightEdgesForWidth:!geometry!private! !
sbGetBorders!accessing!private! !
sbGetTipText:!accessing!private! !
setControlBackcolor:!helpers!private! !
setItem:tipText:!operations!private! !
setItemText:at:!accessing!private! !
setRightEdges!helpers!private! !
setRightEdges:!helpers!private! !
setWindowText:!accessing!private!win32 bug fix! !
size!accessing!public! !
sizeGripWidth!constants!private! !
updateItem:!private!updating! !
!

!UI.StatusBar class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Status_bar
	"Answer the literal data from which the 'Status bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Status_bar)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.StatusBar} 34 21 nil nil 34 2 8 1409288460 1 416 nil 917510 #{Graphics.Color} #default nil 5 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 918022 #{Graphics.Point} 193 193 nil 416 nil 8 1814628368 170 192 8 #() nil nil nil 34 1 1050438 1 #{UI.StatusBarItem} 8193 -1 416 nil 786950 #{Core.Message} #displayString 8 #() 722 #iconImageIndex 8 #() nil 1311814 1 #{UI.StatusBarNullItem} 8705 1 416 nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 594 12287 21 594 701 45 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 93 25 0 0 32 0 0 0] 8 #() 594 193 193 nil 29)!

themePartName
	^'STATUS'
!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'msctls_statusbar32'! !
!UI.StatusBar class categoriesForMethods!
icon!constants!public! !
resource_Status_bar!public!resources-views! !
themePartName!constants!private! !
winClassName!constants!private! !
!

