"Filed out from Dolphin Smalltalk"!

UI.ControlView
	subclass: #'UI.ControlBarAbstract'
	instanceVariableNames: 'names _tipText _unused17 _unused18'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ControlBarAbstract guid: (Core.GUID fromString: '{87b4c726-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ControlBarAbstract isNonInstantiable: true!

UI.ControlBarAbstract comment: '`ControlBarAbstract` is an abstract `<compositeView>` whose subclasses implement the standard Windows status bar and toolbar controls. It is necessary for control bars to support `<compositeView>` so that they are able to host additional sub-views under the management of a layout manager.

## Instance Variables:
  `names`		`IdentityDictionary` mapping sub-views to their names.
  `_tipText`	`Utf16String` or `nil`, tool tip text last shown.
'!

!UI.ControlBarAbstract categoriesForClass!MVP-Resources-Tool/Status bars!MVP-Views! !

!UI.ControlBarAbstract methodsFor!

actualInsets: aLayoutContext 
	"Private - Answer a Rectangle whose edges specify the actual inset (in pixels) by which the
	sub views are positioned away from the border of the receiver."

	^self insets!

actualPreferredExtent: aLayoutContext 
	"Private - Answer the preferred extent of the receiver given the suggested extent specifed
	by the <Point> argument. A preferred extent can be forced by setting the #preferredExtent
	aspect otherwise we see if one can be offered by any installed layout manager, and failing
	that try calculating an extent."

	^self preferredExtent 
		ifNil: 
			[self layoutManager 
				ifNotNil: [:manager | manager preferredLayoutExtentOf: self context: aLayoutContext]
				ifNil: [self calculateExtent: aLayoutContext]]!

addItem: anObject
	"Append a new item to the list of items displayed in the receiver. Answer the new item."

	^self subclassResponsibility!

addSubView: aView name: aNameString
	"Adds aView to the receiver's collection of managed sub-views and
	gives it aNameString. Answers aView"

	self name: (self addSubView: aView) as: aNameString.
	^aView
!

arrangementOf: aView
	"Answer the arrangement parameter for aView in the receiver's 
	layout manager. If no parameter has been explicitly set, or if the
	receiver has no layout manager then answer nil"

	self layoutManager notNil ifTrue: [
		^self layoutManager arrangementOf: aView ].
	^nil!

arrangementOf: aView put: anObject 
	"Set the arrangement parameter for aView in the receiver  
	layout manager to be anObject. If the parent has no layout manager 
	then a walkback will result"

	self layoutManager ifNotNil: 
			[:manager | 
			manager arrangementOf: aView put: anObject.
			self invalidateLayout]!

canAcceptSubViews
	"Answer true if the receiver can accept sub-views"

	^true!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color.Face3d!

defaultWindowExStyle
	"Private - Answer the default extended window creation style."

	^super defaultWindowExStyle bitOr: WS_EX_CONTROLPARENT!

defaultWindowStyle
	"Private - Answer a default base style to use when creating the receiver."

	"Implementation Note: We suppress the control bar's inclination to cling to its parent since
	we can achieve this readily with LayoutManagers."

	^(super defaultWindowStyle maskClear: WS_TABSTOP) bitOr: ##(CCS_NORESIZE | CCS_NOPARENTALIGN)!

errorDuplicateName: aString
	"Report that aString is already in use"

	^self error: 'duplicate name: ', aString
!

filerProxyIn: anSTxOutFiler
	"Private - Answer a filer proxy that represents the receiver for use with the <STxOutFiler> argument."

	(names notNil and: [anSTxOutFiler isStable])
		ifTrue: 
			["We override the names lookup table with a proxy in order that we can sort by the names to get a stable order."
			anSTxOutFiler override: names
				with: (STBIdentityDictionaryProxy class: names class
						associations: (names associations asSortedArray: [:a :b | a value <= b value]))].
	^super filerProxyIn: anSTxOutFiler!

getItemRect: anInteger
	"Private - Answer the bounding <RECTL> for the button at zero-based <Integer> index."

	^self subclassResponsibility!

hasDivider
	"Answers whether the receiver has a divider at its top edge (this is the
	CCS_NODIVIDER style)."

	^(self baseStyleAllMask: CCS_NODIVIDER) not!

hasDivider: aBoolean 
	"Set whether the receiver has a divider at its top edge (this is the
	CCS_NODIVIDER style)."

	^(self 
		baseStyleMask: CCS_NODIVIDER
		set: aBoolean not
		recreateIfChanged: false) ifTrue: [self frameChanged]!

indexOfItem: anObject
	^self subclassResponsibility!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	backcolor := Color default!

insets
	^Rectangle new!

isVertical
	"Answer whether the receiver has a vertical orientation."

	^self baseStyleAllMask: CCS_VERT!

isVertical: aBoolean 
	"Set whether or not the receiver a vertical orientation
	(i.e. with the buttons/tabs at the right of left hand sides
	instead of along the top or bottom)."

	(self 
		baseStyleMask: CCS_VERT
		set: aBoolean
		recreateIfChanged: false	"Modifiable after creation") ifTrue: [self invalidateLayout; invalidate]!

itemAtIndex: anInteger
	"Answers the item at the specified index in the receiver"

	^self subclassResponsibility!

itemRect: anInteger
	"Answer the bounding <Rectangle> for the receiver's item at the specified 1-based <integer> index."

	^(self getItemRect: anInteger - 1) asRectangle!

items
	^self subclassResponsibility!

items: aCollection
	self subclassResponsibility!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver."

	self layoutManager ifNotNil: [:manager | manager layoutContainer: self context: aLayoutContext].!

layoutManager: aLayoutManager
	"Set the layout manager for the receiver to aLayoutManager"

	^self subclassResponsibility
!

name: aView as: aNameStringOrNil
	"Sets the name of aView within the receiver to be aNameStringOrNil"

	"Redirect name request to the immediate parent of aView
	if we are not that parent"

	aView parentView == self ifFalse: [^aView parentView name: aView as: aNameStringOrNil].

	"Check that aView is one of our managed sub-views"
	"self assert: [ self managedSubViews  includes: aView ]."
	names isNil
		ifTrue: 
			[(aNameStringOrNil isNil or: [aNameStringOrNil isEmpty])
				ifFalse: [(names := IdentityDictionary new) at: aView put: aNameStringOrNil]]
		ifFalse: 
			[| exists |
			(aNameStringOrNil isNil or: [aNameStringOrNil isEmpty])
				ifTrue: 
					["Request to remove name for aView"
					^names removeKey: aView ifAbsent: nil].

			"Otherwise name is specified so check that it is unique"
			exists := names keyAtEqualValue: aNameStringOrNil ifAbsent: nil.
			(exists isNil or: [exists == self])
				ifTrue: [names at: aView put: aNameStringOrNil]
				ifFalse: [self errorDuplicateName: aNameStringOrNil]]!

nameOf: aView
	"Answer the name of aView within the receiver or nil
	if it has not been assigned a name"

	"Redirect request to the immediate parent of aView
	if we are not that parent"

	aView parentView == self ifFalse: [^aView parentView nameOf: aView].
	^names isNil ifFalse: [names lookup: aView]!

nmClick: pNMHDR
	"Default handler for a NM_CLICK notification message, pass 
	on to the clicked item, or answer nil to accept default processing."

	| struct |
	struct := NMMOUSE fromAddress: pNMHDR.
	^(self itemFromId: struct dwItemSpec) ifNotNil: [:item | item onClick: struct position]!

nmDblClk: pNMHDR
	"Default handler for a NM_DBLCLK notification message.
	Pass on to the clicked item, or answer nil to accept default processing.
	Note that this is never actually received for Toolbars."

	| struct |
	struct := NMMOUSE fromAddress: pNMHDR.
	^(self itemFromId: struct dwItemSpec) ifNotNil: [:item | item onDoubleClick: struct position]!

nmRClick: pNMHDR
	"Default handler for a NM_RCLICK notification message.
	Pass on to the clicked item, or answer nil to accept default processing."

	| struct |
	struct := NMMOUSE fromAddress: pNMHDR.
	^(self itemFromId: struct dwItemSpec) ifNotNil: [:item | item onRightClick: struct position]!

onSubViewAdded: aView
	"Received when aView has been added to the receiver.
	Can be overridden by subclasses to perform necessary housekeeping regarding the
	new contents of the receiver"

	super onSubViewAdded: aView.
	self invalidateLayout

	!

onTipTextRequired: aControlBarItem
	"Private - Text is required for the tool-tip associated with the specified item in the receiver."

	^aControlBarItem onTipTextRequired!

onZOrderChanged
	"Received when the Zorder of the subviews within the receiver has been
	directly changed. Can be overridden by subclasses to perform necessary 
	housekeeping regarding the new Zorder."

	self invalidateLayout.
	super onZOrderChanged!

preferredHeight
	"Private - Answer the <integer> number of pels that would be the ideal height for the client area of the receiver."

	^self subclassResponsibility!

removeItem: anObject
	"Remove an item from the receiver's contents. Answer the item."

	^self subclassResponsibility!

removeSubView: aView
	"Removes aView as a managed subview of the receiver. 
	If aView is indeed a subview of the receiver then it is destroyed. If not,
	it continues to live."

	super removeSubView: aView.
	self hasLayoutManager ifTrue: [self layoutManager removeSubView: aView].
	names isNil ifFalse: [names removeKey: aView ifAbsent: nil].
	^aView!

ttnGetDispInfo: anNMTTDISPINFOW
	"Private - Handler for the TTN_GETDISPINFOW notification message."

	| ret |
	ret := super ttnGetDispInfo: anNMTTDISPINFOW.
	"We must retain a reference to the tip text to prevent it being GC'd while still in use by the control.
	This should really be pushed up to ControlView, but that would create a difficult STB version upgrade."
	_tipText := anNMTTDISPINFOW text.
	^ret!

validateSubViewLayouts: anExternalHandle 
	"Private - Validate the layout of the visible sub-views of the receiver."

	self managedSubViewsDo: [:each | each validateLayout: anExternalHandle]!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time
	when the UI has been flagged as being invalid"

	self subViewsDo: [:each | each presenter validateUserInterface].
	super validateUserInterface.!

viewNamed: aString ifNone: aNiladicValuable
	"Answer the sub-view within the receiver's hierarchy with aString as its name. Evaluates the <niladicValuable>, aNiladicValuable, if no matching named view exists."

	names ifNotNil: [(names keyAtEqualValue: aString ifAbsent: nil) ifNotNil: [:subView | ^subView]].
	^(self subViewsFind: [:each | each isManaged ifTrue: [each viewNamed: aString ifNone: nil]])
		ifNil: [aNiladicValuable value]!

wmNotify: message wParam: wParam lParam: lParam
	"Private - Redirects WM_NOTIFY messages to the appropriate control as a notify message."

	"Overridden here to handle notifications from the receiver's tool tip control which does not itself have an associated View so cannot receive the redirected message.
	In any case it is more convenient to direct the notification to the receiver's #ttnNeedText: handler."

	| pnmhdr |
	pnmhdr := lParam asExternalAddress.
	(pnmhdr int32AtOffset: NMHDR._OffsetOf_code) == TTN_GETDISPINFOW ifTrue: [^self nmNotify: pnmhdr].
	^super
		wmNotify: message
		wParam: wParam
		lParam: lParam! !

!UI.ControlBarAbstract categoriesForMethods!
actualInsets:!accessing!private! !
actualPreferredExtent:!geometry!private! !
addItem:!adding!items!public! !
addSubView:name:!public!sub views! !
arrangementOf:!accessing!public! !
arrangementOf:put:!accessing!public! !
canAcceptSubViews!hierarchy!public!sub views!testing! !
defaultBackcolor!colors!constants!private! !
defaultWindowExStyle!constants!private! !
defaultWindowStyle!constants!private! !
errorDuplicateName:!exceptions!public! !
filerProxyIn:!binary filing!private! !
getItemRect:!geometry!private! !
hasDivider!accessing-styles!public! !
hasDivider:!accessing-styles!public! !
indexOfItem:!items!private! !
initialize!initializing!private! !
insets!accessing!private! !
isVertical!accessing-styles!public! !
isVertical:!accessing-styles!public! !
itemAtIndex:!items!public! !
itemRect:!geometry!public! !
items!accessing!private! !
items:!accessing!private! !
layout:!geometry!private! !
layoutManager:!geometry!public! !
name:as:!public!subpresenters! !
nameOf:!public!subpresenters! !
nmClick:!event handling-win32!public! !
nmDblClk:!event handling-win32!public! !
nmRClick:!event handling-win32!public! !
onSubViewAdded:!event handling!public! !
onTipTextRequired:!event handling!private! !
onZOrderChanged!event handling!public! !
preferredHeight!gemoetry!private! !
removeItem:!items!public!removing! !
removeSubView:!hierarchy!public!sub views! !
ttnGetDispInfo:!event handling-win32!private! !
validateSubViewLayouts:!geometry!private! !
validateUserInterface!operations!public! !
viewNamed:ifNone:!public!sub views! !
wmNotify:wParam:lParam:!event handling-win32!private! !
!

UI.ControlBarAbstract methodProtocol: #compositeView attributes: #(#readOnly) selectors: #(#addSubView: #allParents #allSubViews #arrangement #arrangement: #backcolor #backcolor: #canAcceptSubViews #canvas #clientExtent #clientHeight #clientRectangle #clientWidth #close #contextMenu #contextMenu: #cursor #cursorPosition #destroy #disable #disableRedraw #enable #enableRedraw #ensureLayoutValid #ensureRectangleVisible: #ensureSubView:rectangleVisible: #ensureSubViewVisible: #ensureVisible #extent #extent: #firstSubView #font #font: #forecolor #forecolor: #hasBorder #hasBorder: #hasClientEdge #hasClientEdge: #hasFocus #hasLayoutManager #hasStaticEdge #hasStaticEdge: #hasVisibleStyle #hasVisibleStyle: #height #height: #hide #invalidate #invalidateCalculatedExtent #invalidateLayout #invalidateRect: #invalidateRect:erase: #invalidateRgn: #invalidateUserInterface #isEnabled: #isGroupStop #isGroupStop: #isLayoutValid #isManaged #isManaged: #isTabStop #isTabStop: #isTopView #isTransparent #isTransparent: #isWindowVisible #layout #layoutExtent: #layoutManager #layoutManager: #managedSubViews #mapPoint:to: #mapRectangle:to: #model #model: #name #name: #nameOf: #needsValidateLayout #nextSiblingView #nonClientCanvas #onAboutToCreate #onBegin:drag: #onCommand: #onCreated: #onDestroyed #onEraseRequired: #onHScroll: #onModelChanged #onPaintRequired: #onSubViewAdded: #onSubViewRemoved: #onViewCreated #onVScroll: #onZOrderChanged #parentView #placement #placement: #plainText #position #position: #preferredExtent #preferredExtent: #presenter #presenter: #presenterConnectionPoint #preTranslateKeyboardInput: #preTranslateMessage: #preTranslateMouseInput: #previousSiblingView #queryContextMenu #recreate #rectangle #rectangle: #refreshContents #removeSubView: #resolution #screenRectangle #screenRectangle: #scrollBy:clip: #scrollBy:scroll:clip: #setCapture #styles #subViewFromPoint: #subViewFromPoint:flags: #subViews #tabFirst #tabNext #text #text: #topView #update #updateModel #usePreferredExtent #usePreferredExtent: #validate #validateLayout #validateRect: #validateUserInterface #viewNamed: #viewNamed:ifNone: #width #width: #withAllParents #withAllSubViews #x #x: #y #y: #zOrderAfter: #zOrderAfter:withFlags: #zOrderBottom #zOrderTop)!

!UI.ControlBarAbstract class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 'Toolbar.ico'!

initialize
	CommCtrlLibrary addInitFlag: ICC_BAR_CLASSES!

stbConvert: instVarArray fromVersion: verInteger
	"Convert from earlier version view by updating and answering the array of instance variables
	(for the View), instVarArray."

	| instVars |
	instVars := instVarArray.
	verInteger < 13 ifTrue: [instVars := super stbConvert: instVarArray fromVersion: verInteger].
	verInteger < 14 ifTrue: [instVars := self stbConvertFromVersion13: instVars].
	^instVars!

stbConvertFromVersion12: anArray 
	"Private - Perform an STB conversion from a version 12 <View> to version 13."

	| creationStyle |
	creationStyle := anArray at: 3.
	creationStyle at: 1 put: ((creationStyle at: 1) bitOr: CCS_NOPARENTALIGN).
	^super stbConvertFromVersion12: anArray!

stbConvertFromVersion13: anArray 
	"Private - Perform an STB conversion from a version 13 <ControlBarAbstract> to version 14.
	Adds _tipText instance variable and a couple of spares."

	| count |
	count := anArray size + 3.
	^(Array new: count)
		replaceFrom: 1 to: 15 with: anArray startingAt: 1;
		replaceFrom: 19 to: count with: anArray startingAt: 16;
		yourself!

stbVersion
	"14: Adds _tipText, and two spares"

	^14!

uninitialize
	#{UI.Slider} isDefined ifFalse: [CommCtrlLibrary removeInitFlag: ICC_BAR_CLASSES]! !

!UI.ControlBarAbstract class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
stbConvert:fromVersion:!binary filing!public! !
stbConvertFromVersion12:!binary filing!private! !
stbConvertFromVersion13:!binary filing!private! !
stbVersion!binary filing!public! !
uninitialize!class hierarchy-removing!public! !
!

