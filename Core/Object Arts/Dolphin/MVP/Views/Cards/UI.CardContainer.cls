"Filed out from Dolphin Smalltalk"!

UI.AbstractCardContainer
	subclass: #'UI.CardContainer'
	instanceVariableNames: 'tabs'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CardContainer guid: (Core.GUID fromString: '{87b4c71c-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.CardContainer comment: 'A CardContainer is a <cardView> that allows each of its cards (sub-views) to appear with named tabs. The tab names are specified by the #arrangement aspects of the sub-views and appear in the z-order maintained by the container. The CardContainer uses a TabView to provide the name tabs.

Typically a CardContainer will be used for tab-style property pages within a dialog. For another example, the Categories/Protocols/Variables pane in the Class Hierarchy Browser is implemented using a CardContainer.

Instance Variables:
	tabs	<TabView> holding the name tabs.

'!

!UI.CardContainer categoriesForClass!MVP-Views! !

!UI.CardContainer methodsFor!

arrangementOf: aView put: anObject 
	"Set the arrangement parameter for aView in the receiver layout manager 
	to be anObject. Usually anObject will be a String to be used to identify
	the card. This is also added to the tab view associated with the receiver."

	| existingTab |
	existingTab := aView arrangement.
	super arrangementOf: aView put: anObject.
	(tabs model includes: existingTab) 
		ifTrue: 
			["If the view already has an arrangement, just do an update of the tab 
			instead of removing it and adding it. This will keep the tabs in order"
			| index |
			index := tabs model identityIndexOf: existingTab.
			tabs model at: index put: anObject]
		ifFalse: [tabs model add: anObject]!

backcolor: aColorOrNil 
	"Sets the background colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	backcolor := aColorOrNil.
	tabs backcolor: aColorOrNil!

createTabs
	"Private - Add a <TabView> as a non-managed sub-view of the receiver"

	tabs notNil ifTrue: [^self].
	tabs := self newTabs.
	tabs isManaged: false.
	self basicAddSubView: tabs.
	tabs backcolor: nil!

defaultBackcolor
	^Color.Face3d!

defaultViewClass
	^TabViewXP!

ensureTabsAtBack
	"Private - Force the associated tab view to be behind all our managed sub-views so that it
	does not obscure them. We must do this silently without causing an #onZOrderChanged."

	self hasOwnTabs 
		ifTrue: 
			[tabs 
				setWindowPosAfter: HWND_BOTTOM
				x: 0
				y: 0
				width: 0
				height: 0
				flags: ##(SWP_NOSIZE | SWP_NOMOVE)]!

filerProxyIn: anSTxOutFiler
	"Private - Answer a filer proxy that represents the receiver for use with the <STxOutFiler> argument."

	| proxy |
	proxy := super filerProxyIn: anSTxOutFiler.
	anSTxOutFiler isStable
		ifTrue: 
			[| namedCards |
			"Ensure the managed sub-views are in the tab order"
			namedCards := LookupTable withAll: layoutManager names.
			proxy subViews: ((self tabs model asArray collect: [:each | namedCards at: each]) , proxy subViews) distinct].
	^proxy!

getImageBlock
	"Answer the block to use to find out the image index of an object that will
	be placed displayed in the TabView associated with the receiver."

	^tabs getImageBlock!

getImageBlock: aOneArgBlock 
	"Set the block to use to find out the image index of an object that will
	be placed in the TabView associated with the receiver"

	tabs getImageBlock: aOneArgBlock!

getTextBlock
	"Answer the block to use to find out the text of an object that will
	be placed displayed in the TabView associated with the receiver."

	^tabs getTextBlock!

getTextBlock: aOneArgBlock 
	"Set the block to use to find out the text of an object that will
	be placed in the TabView associated with the receiver"

	tabs getTextBlock: aOneArgBlock!

hasButtons
	"Answer whether the receiver has buttons instead of tabs."

	^tabs hasButtons!

hasButtons: aBoolean 
	"Set whether or not the receiver has buttons instead of tabs."

	^tabs hasButtons: aBoolean!

hasHotTracking
	"Answer whether the receiver has the hot-tracking style whereby tabs that are hovered over are automatically selected."

	^tabs hasHotTracking!

hasHotTracking: aBoolean 
	"Sets the receiver to hot-track the selection or not depending on the value of aBoolean."

	tabs hasHotTracking: aBoolean!

hasOwnTabs
	"Answer whether the tabs associated with the receiver are owned by the receiver. This will
	normally be the case, unless embedded in a SlidingCardContainer that supplies the tabs."

	^tabs parentView == self!

implicitInsets: aLayoutContext
	"Private - Answer a <Rectangle> whose edges specify the implicit distance (in pixels) by
	which the sub views have to be inset from the border of the receiver."

	"Implementation Note: We must calculate this to allow space for the TabView's decoration
	(the tabs themselves, borders, etc)."

	| rect clientRect |
	self hasOwnTabs ifFalse: [^Rectangle new].
	rect := aLayoutContext rectangleOf: tabs.
	clientRect := tabs calcClientRectangleFromRectangle: rect.
	^rect insetBy: clientRect!

isDropTarget: aBoolean 
	tabs isDropTarget: aBoolean.
	^super isDropTarget: aBoolean!

isInverted
	"Answer whether the receiver is in one of the 'inverted' orientations (that is with tabs to bottom or the right)."

	^tabs isInverted!

isInverted: aBoolean
	Notification deprecated.	"D6: Use #tabOrientation:"
	^tabs isInverted: aBoolean!

isMultiline
	"Answers whether the receiver can display multiple lines of tabs."

	^tabs isMultiline!

isMultiline: aBoolean 
	"Set whether the receiver can display multiple lines of tabs."

	tabs isMultiline: aBoolean!

isTabStop
	"Answers whether the receiver is a tab stop."

	^tabs isTabStop!

isTabStop: aBoolean 
	"Set whether or not the receiver is a tab stop."

	^tabs isTabStop: aBoolean!

isVertical
	"Answer whether the receiver has a vertical orientation (i.e. with tabs to right or left, rather than top or bottom)."

	^tabs isVertical!

isVertical: aBoolean
	Notification deprecated.	"D6: Use #tabOrientation:"
	^tabs isVertical: aBoolean!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver. Force the tab view to be the same size
	as the receiver, then ask for the standard layout to continue."

	self hasOwnTabs 
		ifTrue: [aLayoutContext setView: tabs rectangle: (0 @ 0 extent: (aLayoutContext extentOf: self))].
	super layout: aLayoutContext!

newTabs
	^self defaultViewClass new!

onCardChangedFrom: previousView to: currentView
	"Private - The current card has been changed in the layout manager. 
	Select the appropriate tab in the receiver to reflect this, and trigger
	our own card change event."

	tabs selection: currentView arrangement.
	super onCardChangedFrom: previousView to: currentView!

onEraseRequired: aColorEvent 
	"Handler for erase background event - erase to the background colour,
	or answer nil if no colour is set to accept the default window processing."

	"CardContainers are completely covered by their unmanaged TabView child."

	^true!

onSubViewAdded: aView
	"Private - Received when aView has been added to the receiver. Ensure that the associated
	tab view is sent to the back"

	self ensureTabsAtBack.
	super onSubViewAdded: aView.
!

onTabChanged
	"Private - A tab has been selected by the user. 
	Ask our layout manager to show the appropriate view"

	| tabName |
	tabName := tabs selectionIfNone: [^self].
	self cardLayout showCardWithArrangement: tabName.

	"Note: Without the followng focus shift, Windows can loop endlessly if the receiver gains 
	focus and a key is typed."
	self hasFocusDeeply ifTrue: [self tabOntoCurrentCard]!

onTabChanging: aSelectionChangingEvent
	"Private - A tab has been selected by the user."

	self trigger: #currentCardChanging: with: aSelectionChangingEvent!

onViewCreated
	super onViewCreated.
	self createTabs.
	tabs
		when: #selectionChanging:
			send: #onTabChanging:
			to: self;
		when: #selectionChanged
			send: #onTabChanged
			to: self!

onZOrderChanged
	"Private - Received when the ZOrder of the receiver's subview has been changed.
	Rebuild the assocaited tab view to reflect the new ordering"

	super onZOrderChanged.
	self ensureTabsAtBack.
	self refreshTabs



	!

preTranslateKeyboardInput: aMSG 
	"Answer whether the receiver would like to consume the argument aMSG,
	which is a keyboard message."

	^tabs preTranslateKeyboardInput: aMSG!

queryTabOrientation: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self tabOrientation == aCommandQuery command arguments first!

queryViewMode: aCommandQuery
	aCommandQuery
		beEnabled;
		isChecked: self viewMode == aCommandQuery command arguments first!

refreshTabs
	"Rebuild the associated tab view to include all the managed subviews
	of the receiver in the correct z order sequence"

	| currentCard layout |
	layout := self cardLayout.
	currentCard := layout currentCard.
	tabs model list: (self cards collect: [:each | each arrangement]) asOrderedCollection.
	currentCard ifNotNil: [layout showCard: currentCard]!

removeSubView: aView
	"Removes aView as a subview of the receiver. First remove
	any associated tab. If aView is indeed a subview of the receiver then it is destroyed. If not,
	it continues to live."

	| arrangement |
	arrangement := self arrangementOf: aView.
	tabs model remove: arrangement ifAbsent: nil.
	super removeSubView: aView!

tabOrientation
	"Answer a <Symbol> naming the orientation of the receiver. This primarily controls where the
	tab strip is displayed and is one of #left, #right, #top (the default) or #bottom."

	^tabs tabOrientation!

tabOrientation: aSymbol 
	"Set the orientation of the receiver. This primarily controls where the tab strip is
	displayed. The <Symbol> argument can be one of #left, #right, #top (the default) or
	#bottom."

	<commandQuery: #queryTabOrientation:>
	tabs tabOrientation: aSymbol!

tabs
	^tabs!

updateTabs
	"Update the tabs to reflect change in text/icon etc. We assume the arrangement object identity has not changed; if it
	has then #refreshTabs is more appropriate."

	tabs updateAll!

viewMode
	"Answer the view mode of the TabView associated with the receiver.
	This can be one of:
		#noIcons
		#smallIcons
		#largeIcons"

	^tabs viewMode!

viewMode: aSymbol 
	"Sets the view mode of the TabView associated with the receiver to aSymbol.
	This can be one of:
		#noIcons
		#smallIcons
		#largeIcons"

	<commandQuery: #queryViewMode:>
	tabs viewMode: aSymbol!

wmPrint: message wParam: wParam lParam: lParam
	"Private - Handle WM_PRINT."

	"Implementation Note: For some reason the DefWindowProc implementation seems to paint the
	TabView over the top of the current card (even though at the back in the z-order), so we
	need to take control."

	| result canvas insetRect prev card |
	self ensureLayoutValid.
	result := self
				defaultWindowProcessing: message
				wParam: wParam
				lParam: lParam.
	card := self currentCard.
	(card isNil or: [lParam noMask: PRF_CHILDREN]) ifTrue: [^result].
	insetRect := self actualInsets: (LayoutContext forContainer: self parentView).
	canvas := Canvas withNonOwnedDC: wParam.
	prev := canvas offsetWindowOrigin: (insetRect topLeft + (0 @ 0)) * -1.
	card
		sendMessage: message
		wParam: wParam
		lParam: lParam.
	canvas windowOrigin: prev.
	^result! !

!UI.CardContainer categoriesForMethods!
arrangementOf:put:!accessing!public! !
backcolor:!accessing!public! !
createTabs!helpers!private! !
defaultBackcolor!public! !
defaultViewClass!constants!public! !
ensureTabsAtBack!operations!private! !
filerProxyIn:!binary filing!private! !
getImageBlock!adapters!public! !
getImageBlock:!adapters!public! !
getTextBlock!adapters!public! !
getTextBlock:!adapters!public! !
hasButtons!accessing-styles!public! !
hasButtons:!accessing-styles!public! !
hasHotTracking!accessing-styles!public! !
hasHotTracking:!accessing-styles!public! !
hasOwnTabs!public!testing! !
implicitInsets:!accessing!private! !
isDropTarget:!accessing!public! !
isInverted!accessing-styles!public! !
isInverted:!accessing-styles!public! !
isMultiline!accessing!public! !
isMultiline:!accessing!public! !
isTabStop!accessing!public! !
isTabStop:!accessing-styles!public! !
isVertical!accessing-styles!public! !
isVertical:!accessing-styles!public! !
layout:!geometry!public! !
newTabs!helpers!private! !
onCardChangedFrom:to:!event handling!private! !
onEraseRequired:!event handling!public! !
onSubViewAdded:!event handling!private! !
onTabChanged!event handling!private! !
onTabChanging:!event handling!private! !
onViewCreated!event handling!private! !
onZOrderChanged!event handling!private! !
preTranslateKeyboardInput:!public! !
queryTabOrientation:!commands-queries!private! !
queryViewMode:!commands-queries!private! !
refreshTabs!public!updating! !
removeSubView:!public! !
tabOrientation!accessing-styles!public! !
tabOrientation:!accessing-styles!public! !
tabs!accessing!private! !
updateTabs!public!updating! !
viewMode!accessing!public! !
viewMode:!accessing!public! !
wmPrint:wParam:lParam:!private! !
!

!UI.CardContainer class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.CardContainer} 38 #{Core.Array} 16 nil nil 50 2 8 1409286144 131073 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 0 nil nil nil nil 550 #{Core.IdentityDictionary} 0 nil 18 #{UI.TabViewXP} 50 28 nil 32 50 2 8 1140916736 1 240 838 2 #{UI.ListModel} 178 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 240 nil nil 518 #{Core.Message} #displayString 8 #() 386 #iconImageIndex 416 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 578 701 501 240 530 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 240 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 250 0 0 0] 8 #() 578 193 193 nil 27 482 50 1 530 #createAt:extent: 50 2 578 6143 21 578 701 501 32 658 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 4 1 0 0] 50 1 240 720 nil 27)! !

!UI.CardContainer class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

