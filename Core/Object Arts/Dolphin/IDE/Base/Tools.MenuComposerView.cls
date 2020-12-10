"Filed out from Dolphin Smalltalk 7"!

UI.View subclass: #'Tools.MenuComposerView'
	instanceVariableNames: 'selectionIndex painter'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MenuComposerView guid: (Core.GUID fromString: '{87b4c710-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.MenuComposerView comment: 'MenuComposerView is an abstract superclass for a <valueView> used to emulate a <Menu> in the <MenuComposer>.

Instance Variables:
	selectionIndex		<integer> holding the index of the currently selected menu item.
	painter			<menuPainter> responsible for rendering the emulated menu being composed.
'!
!Tools.MenuComposerView categoriesForClass!MVP-Views! !
!Tools.MenuComposerView methodsFor!

arena
	^self creationParentView!

conflictingAccelerators: menuItems 
	"Set the Set of menu items with conflicting accelerator keys."

	painter conflictingAccelerators: menuItems!

createDragImage: anInteger 
	^self evaluateWithCanvas: [:canvas | painter createDragImage: anInteger using: canvas]!

defaultWindowStyle
	"Private - Answer the default basic window creation style.
	If the view is later given a parent then WS_CHILD will be set."

	^super defaultWindowStyle | WS_CHILD!

evaluateWithCanvas: aBlockClosure 
	| canvas answer |
	canvas := self canvas.
	answer := [aBlockClosure value: canvas] ensure: [canvas free].
	^answer!

hasSelection
	"Answer whether the receiver has an item selected."

	^self selectionOrNil notNil!

indexOfItem: menuItem
	"Private - Answer the index of menuItem in the receivers model."

	^self menu items indexOf: menuItem!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	self selectionByIndex: 0!

insertBefore: anInteger position: aPoint canvas: aCanvas 
	"Answer whether an insertion at the <Point>, aPoint, should 
	place the new object before or after the item with the specified <integer> index."

	^painter 
		insertBefore: anInteger
		position: aPoint
		canvas: aCanvas!

itemAt: aPoint 
	"Private - Answer the menu item of the model which spatially coincides
	with position or 0 if there is none."

	^(1 to: self menu size) detect: [:itemIndex | (self itemRect: itemIndex) containsPoint: aPoint]
		ifNone: [0]!

itemRect: anInteger 
	^self evaluateWithCanvas: [:canvas | painter itemRect: anInteger using: canvas]!

menu
	"Answer the menu which the receiver is displaying."

	^self model value!

onEraseRequired: aColorEvent
	"Handler for erase background. Note that we do not fill the background here,
	it is drawn in onPaintRequired: in a flicker reduction attempt."

	^1!

onInputMaskRequired: anEvent 
	"Handler for a WM_GETDLGCODE request from Windows."

	"Implementation Note: We need to request all keys in order to get WM_SYSCHAR messages for
	shortcut key navigation, which we then use for selecting the relevant command or sub-menu."

	^DLGC_WANTALLKEYS!

onLeftButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse left button double click event."

	self hasSelection ifTrue: [
		self creationParentView presenter trigger: #actionPerformed with: self].
	^0!

onPaintRequired: aPaintEvent 
	self model isNil ifTrue: [^self].
	self arena hideDragCursor.
	
	[painter 
		paintMenuOn: aPaintEvent canvas
		in: self clientRectangle
		selected: self selectionByIndex] 
			ensure: [self arena showDragCursor]!

originForSubmenu: itemIndex 
	"Answer the position in the receivers parent view at which a MenuItem's submenu should be
	opened."

	^self position 
		+ (self evaluateWithCanvas: [:canvas | painter offsetForSubmenu: itemIndex canvas: canvas])!

refreshContents
	"The model held by the associated presenter has been replaced."

	self menu 
		ifNotNil: 
			[:m | 
			painter := m painterClass forMenu: m.
			self extent: (self evaluateWithCanvas: [:canvas | painter calculateGeometry: canvas])].
	self invalidateRect: nil erase: false!

selectionByIndex
	"Answer the index of the item currently selected or 0 if there is no selection."

	^selectionIndex!

selectionByIndex: index
	"Set the index of the selected item. This will not update the receivers on screen
	appearance."

	selectionIndex := index!

selectionOrNil
	"Answer the selected menu item of the receiver or nil if there is none."

	^self selectionByIndex isZero ifFalse: [self menu itemAt: self selectionByIndex]!

wmSysChar: message wParam: wParam lParam: lParam 
	"Private - Handles a WM_SYSCOMMAND message. From MSDN:
	The WM_SYSCHAR message is posted to the window with the keyboard focus when a WM_SYSKEYDOWN
	message is translated by the TranslateMessage function. It specifies the character code of a
	system character key that is, a character key that is pressed while the ALT key is down. "

	| char selected |
	char := (Character codePoint: wParam) asUppercase.
	selected := self menu items findFirst: 
					[:each | 
					| string index |
					string := each text.
					(index := string indexOf: $&) ~~ 0 and: 
							[| mnemonic |
							mnemonic := (string at: index + 1) asUppercase.
							mnemonic == char]].
	^selected == 0 
		ifFalse: 
			[self arena onItemIn: self selectedAtIndex: selected.
			0]! !
!Tools.MenuComposerView categoriesFor: #arena!accessing!private! !
!Tools.MenuComposerView categoriesFor: #conflictingAccelerators:!accessing!public! !
!Tools.MenuComposerView categoriesFor: #createDragImage:!public!tracking! !
!Tools.MenuComposerView categoriesFor: #defaultWindowStyle!constants!private! !
!Tools.MenuComposerView categoriesFor: #evaluateWithCanvas:!private!testing! !
!Tools.MenuComposerView categoriesFor: #hasSelection!public!testing! !
!Tools.MenuComposerView categoriesFor: #indexOfItem:!private!searching! !
!Tools.MenuComposerView categoriesFor: #initialize!initializing!private! !
!Tools.MenuComposerView categoriesFor: #insertBefore:position:canvas:!public!testing! !
!Tools.MenuComposerView categoriesFor: #itemAt:!private!searching! !
!Tools.MenuComposerView categoriesFor: #itemRect:!public! !
!Tools.MenuComposerView categoriesFor: #menu!accessing!public! !
!Tools.MenuComposerView categoriesFor: #onEraseRequired:!event handling!painting!public! !
!Tools.MenuComposerView categoriesFor: #onInputMaskRequired:!event handling!public! !
!Tools.MenuComposerView categoriesFor: #onLeftButtonDoubleClicked:!event handling!public! !
!Tools.MenuComposerView categoriesFor: #onPaintRequired:!event handling!painting!public! !
!Tools.MenuComposerView categoriesFor: #originForSubmenu:!accessing!public! !
!Tools.MenuComposerView categoriesFor: #refreshContents!public!updating! !
!Tools.MenuComposerView categoriesFor: #selectionByIndex!public!selection! !
!Tools.MenuComposerView categoriesFor: #selectionByIndex:!public!selection! !
!Tools.MenuComposerView categoriesFor: #selectionOrNil!public!selection! !
!Tools.MenuComposerView categoriesFor: #wmSysChar:wParam:lParam:!event handling-win32!private! !

!Tools.MenuComposerView class methodsFor!

icon
	"Answers an <Icon> that can be used to represent this class."

	^MenuComposer icon!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^super publishedEventsOfInstances
		add: #actionPerformed;
		yourself.
! !
!Tools.MenuComposerView class categoriesFor: #icon!constants!public! !
!Tools.MenuComposerView class categoriesFor: #publishedEventsOfInstances!events!public! !

