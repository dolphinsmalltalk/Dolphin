"Filed out from Dolphin Smalltalk 7"!

UI.ValueDialog subclass: #'Tools.MenuComposer'
	instanceVariableNames: 'arena menuViews conflictingAccelerators'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MenuComposer guid: (Core.GUID fromString: '{87b4c6aa-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.MenuComposer comment: 'MenuComposer is a <valueDialogPresenter> that can be used to edit a <Menu> held in its <valueModel>.

Instance Variables:
	arena			<compositeView> which is the arena where the menu is being edited.
	menuViews		<OrderedCollection> of <MenuComposerView>''s representing the menu(s) being edited.
	conflictingAccelerators	<Set> of <integer> conflicting accelerator codes.
'!
!Tools.MenuComposer categoriesForClass!MVP-Presenters! !
!Tools.MenuComposer methodsFor!

addCommand
	"Append a new empty command to the current menu."

	self addItem: self newCommandItem.!

addItem: menuItem
	"Private - Add menuItem after the position of the current selection."

	| selectionView index |
	selectionView := self selectionView.
	index := selectionView selectionByIndex.
	self addItem: menuItem view: selectionView index: index + 1!

addItem: menuItem view: menuView index: index 
	"Private - Add a menuItem to the current selectionView."

	| destinationMenu |
	destinationMenu := menuView menu.
	self update: menuView
		do: 
			[destinationMenu insertItem: menuItem at: index.
			self generateAcceleratorConflicts]!

addMenu
	"Apend a new menu to the current menu."

	self addItem: self newMenu.!

addSeparator
	"Append a new Separator divider to the current menu."

	self addItem: DividerMenuItem separator!

apply
	"Apply the changes cached in the receiver back to the model. We strip out
	any uintitled command items and menus if possible."

	self stripUntitled: self menu.
	self menu size = 0 ifTrue: [self value: nil].
	super apply!

arena
	"Answer the View where the menus are drawn."

	^arena!

clearSelection
	"Removes the current selections from the receiver"

	| index selectionView |
	selectionView := self selectionView.
	index := selectionView selectionByIndex.
	self removeItemView: selectionView index: index!

closeSubmenuViewsOf: aView 
	"Private - Close any deeper menus than aView."

	self dragCoordinator hideDragCursor.
	
	[| enumerateViews subView |
	enumerateViews := menuViews copy.
	[(subView := enumerateViews last) == aView] whileFalse: 
			[menuViews removeLast.
			subView parentView removeSubView: subView.
			enumerateViews removeLast]] 
			ensure: [self dragCoordinator showDragCursor]!

collectAcceleratorsOf: menuOrItem into: aBag 
	"Private - Populate aBag with all the accelerator key codes
	used in the receiver."

	| accel |
	menuOrItem itemsDo: [:each | self collectAcceleratorsOf: each into: aBag].
	accel := menuOrItem acceleratorKey.
	accel = 0 ifFalse: [aBag add: accel]!

commandItemClass
	^CommandMenuItem!

copySelection
	"Copies the primary selection to the clipboard"

	UI.Clipboard current setObject: self selection!

cutSelection
	"Cuts the current selections to the clipboard"

	self copySelection; clearSelection
!

dragCoordinator
	"Private - Answer the drag object used to synchronize writing to the receivers view."

	^arena!

ensureMinimumMenuContents: aMenu 
	"Private - We have to ensure that there is at least one item
	in a menu for our selection based system to work. Here
	we ensure that by adding a command entry if need be."

	aMenu size = 0 
		ifTrue: [aMenu addItem: (aMenu isMenuBar ifTrue: [self newMenu] ifFalse: [self newCommandItem])]
		ifFalse: [aMenu itemsDo: [:item | item hasSubmenu ifTrue: [self ensureMinimumMenuContents: item]]]!

generateAcceleratorConflicts
	"Private - Generate the receivers set of conflicting accelerator keys and update
	all the open menu views to the new state. A conflicting accelerator key is one
	which is used by more than one menu item across the top level menu and all its
	sub-menus."

	| accels |
	accels := Bag new.
	self collectAcceleratorsOf: self menu into: accels.
	conflictingAccelerators := (accels
				removeAll: accels asSet;
				yourself) asSet.
	menuViews do: 
			[:menuView |
			self generateAcceleratorConflicts: menuView.
			menuView invalidate]!

generateAcceleratorConflicts: menuView
	"Private - Update menuView to reflect the current set of conflicting accelerator keys."

	| conflicts |
	conflicts := Set new.
	menuView menu itemsDo: 
			[:item |
			| acceleratorKey |
			acceleratorKey := item acceleratorKey.
			(conflictingAccelerators includes: acceleratorKey) ifTrue: [conflicts add: item]].
	menuView conflictingAccelerators: conflicts!

hasClipboard
	"Private - Answer true if there is a menu item on the clipboard"

	^(Clipboard current getObjectClassIfNone: [])
		ifNil: [false]
		ifNotNil: [:class | (class includesBehavior: Menu) or: [class includesBehavior: MenuItem]]!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	conflictingAccelerators := Set new!

menu
	"Answer the top level menu which the receiver is editing. If nil then we create a suitable
	base menu here."

	| menu |
	menu := self value.
	menu isNil ifTrue: [self value: (menu := self class menuClass new)].
	^menu!

menuClass
	"Private - Answer the base menu class that instances of the receiver will edit|"

	^self class menuClass!

model: aSubjectModel
	"Connect the receiver to aSubjectModel onto a Menu. Since the MenuComposer
	works by modifying a menu's contents in place we must force a copy to be made here."

	super model: aSubjectModel.	
	self value: self value copy.
!

mutateIntoCommand
	"Private - Mutate the selected item into a <CommandMenuItem>."

	self mutateSelection: 
			[:item |
			| proceed |
			proceed := true.
			(item items select: [:e | e command notNil and: [e command ~~ #noCommand]]) notEmpty
				ifTrue: 
					[(MessageBox
						confirm: ('The menu <1p> has sub-items that will be lost.<n><n>Are you sure you want to contine?'
								expandMacrosWith: item description)
						caption: 'Mutate Menu into Command...') ifFalse: [proceed := false]].
			proceed ifTrue: [self commandItemClass commandDescription: item commandDescription]]!

mutateIntoMenu
	"Private - Mutate the selected item into a <Menu>."

	self mutateSelection: 
			[:item | 
			(self newMenu)
				name: item commandDescription commandSymbol;
				text: item description;
				yourself]!

mutateSelection: mutateBlock 
	| menuView index aMenu item newItem |
	menuView := self selectionView.
	aMenu := menuView menu.
	index := menuView selectionByIndex.
	item := aMenu itemAt: index.
	newItem := mutateBlock value: item.
	newItem isNil 
		ifFalse: 
			[self update: menuView
				do: 
					[aMenu
						removeItemAt: index;
						insertItem: newItem at: index]]!

newCommandItem
	"Private - Answer a new CommandItem."

	| item itemClass |
	itemClass := self commandItemClass.
	item := itemClass new.
	item commandDescription description: self untitledPrefix , 'command'.
	^item!

newMenu
	"Private - Answer a new <Menu>."

	| item |
	"Note we always want a new <Menu> here, never a <MenuBar>."
	item := Menu new
				text: self untitledPrefix , 'menu';
				yourself.
	self ensureMinimumMenuContents: item.
	^item!

onItemFrom: aMenuComposerView at: anInteger droppedBefore: beforeBoolean copy: copyBoolean
	"Private - Try and move the source item to the current selection point."

	| destView destMenu destIndex sourceView sourceMenu sourceItem updateSourceView |
	destView := self selectionView.
	destMenu := destView menu.
	destIndex := destView selectionByIndex.
	sourceMenu := aMenuComposerView menu.
	sourceItem := sourceMenu itemAt: anInteger.
	(sourceMenu == destMenu and: [anInteger = destIndex]) ifTrue: [^self].
	menuViews do: 
			[:menuView |
			menuView menu == sourceItem
				ifTrue: 
					[Sound warningBeep.
					^self]].
	self closeSubmenuViewsOf: destView.
	sourceView := menuViews detect: [:menuView | menuView menu == sourceMenu] ifNone: [].
	updateSourceView := sourceView notNil and: [copyBoolean not].
	copyBoolean ifTrue: [sourceItem := sourceItem copy] ifFalse: [sourceMenu removeItemAt: anInteger].
	self ensureMinimumMenuContents: sourceMenu.
	sourceMenu == destMenu
		ifTrue: [anInteger < destIndex ifTrue: [destIndex := destIndex - 1]]
		ifFalse: 
			[updateSourceView
				ifTrue: 
					[anInteger < sourceView selectionByIndex
						ifTrue: [sourceView selectionByIndex: sourceView selectionByIndex - 1]]].
	beforeBoolean
		ifTrue: 
			[destMenu insertItem: sourceItem at: destIndex.
			destView selectionByIndex: destIndex]
		ifFalse: 
			[destMenu insertItem: sourceItem at: destIndex + 1.
			destView selectionByIndex: destIndex + 1].
	self generateAcceleratorConflicts.
	menuViews inject: nil
		into: 
			[:last :each |
			last notNil
				ifTrue: 
					[each position: (last originForSubmenu: last selectionByIndex).
					each refreshContents.
					each]
				ifFalse: 
					[(each == destView or: [updateSourceView and: [each == sourceView]])
						ifTrue: 
							[each refreshContents.
							each]]].
	self openSelectedSubmenuOf: destView!

onItemIn: aView selectedAtIndex: index 
	"Private - A menu item has been selected in a menu (either by being clicked
	over or by having another menu item dragger over it - i.e. this is also used
	for drag highlighting). Close any deeper menus and hilight the item in its menu.

	Note that we minimize the invalidating of the menu view to include only the
	old and new selection rectangles."

	| currentView oldIndex |
	currentView := self selectionView.
	(currentView ~~ aView or: [currentView selectionByIndex ~= index]) ifFalse: [^self].
	self closeSubmenuViewsOf: aView.
	oldIndex := aView selectionByIndex.
	aView selectionByIndex: index.
	oldIndex == 0 ifFalse: [aView invalidateRect: (aView itemRect: oldIndex) erase: false].
	aView invalidateRect: (aView itemRect: index) erase: false.
	self openSelectedSubmenuOf: aView!

onMenuClicked: aMouseEvent 
	| index |
	index := self trackMouse: aMouseEvent.
	index isZero 
		ifFalse: 
			[self arena 
				beginDrag: aMouseEvent
				of: index
				in: aMouseEvent window]!

onMenuTrack: aMouseEvent 
	self trackMouse: aMouseEvent!

onViewOpened
	"Private - The receiver's view has been connected.
	Set the menu into the composer."

	| menuView |
	super onViewOpened.
	arena := self view viewNamed: 'arena'.
	menuViews := OrderedCollection new.
	(self arena)
		when: #itemIn:selectedAtIndex:
			send: #onItemIn:selectedAtIndex:
			to: self;
		when: #actionPerformed
			send: #properties
			to: self;
		when: #itemFrom:at:droppedBefore:copy:
			send: #onItemFrom:at:droppedBefore:copy:
			to: self.
	self generateAcceleratorConflicts.
	self ensureMinimumMenuContents: self menu.
	menuView := self openMenu: self menu at: self topMenuInset.
	self onItemIn: menuView selectedAtIndex: 1!

openMenu: aMenu at: position
	"Private - Create a new view onto aMenu an open it to the
	receivers view at position. Answer menuView."

	self dragCoordinator hideDragCursor.
	^
	[| menuView |
	menuView := MenuComposerView new.
	menuViews addLast: menuView.
	self arena addSubView: menuView.
	menuView
		when: #leftButtonPressed:
			send: #onMenuClicked:
			to: self;
		when: #mouseMoved:
			send: #onMenuTrack:
			to: self.
	menuView
		position: position;
		model: aMenu asValue.
	self generateAcceleratorConflicts: menuView.
	menuView zOrderTop.
	menuView]
			ensure: [self dragCoordinator showDragCursor]!

openSelectedSubmenuOf: aView 
	"Private - Open the submenu of the selected item of aView."

	| selected |
	selected := aView selectionOrNil.
	selected size > 0 
		ifTrue: [self openMenu: selected at: (aView originForSubmenu: aView selectionByIndex)]!

pasteClipboard
	"Pastes clipboard contents into the primary selection. We can assume that the clipboard
	contains a single view to paste"

	| selectionView index |
	selectionView := self selectionView.
	index := selectionView selectionByIndex.
	self
		addItem: Clipboard current getObject
		view: selectionView
		index: index!

properties
	"Open a dialog to allow editing of the selected menu item."

	| menuView |
	self selection edit.
	menuView := self selectionView.
	self update: menuView do: [self generateAcceleratorConflicts]!

queryCommand: query 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| command |
	command := query commandSymbol.
	command == #pasteClipboard 
		ifTrue: 
			[query isEnabled: self hasClipboard.
			^true].
	command == #mutateIntoMenu 
		ifTrue: 
			[| item |
			item := self selection.
			query isEnabled: (item notNil and: [item isKindOf: self commandItemClass]).
			^true].
	command == #mutateIntoCommand
		ifTrue: 
			[| item |
			item := self selection.
			query isEnabled: (item notNil and: [item isKindOf: self menuClass]).
			^true].

	^super queryCommand: query!

removeItemView: menuView index: index 
	"Private - Removes the current selections from the receiver"

	self update: menuView
		do: 
			[| aMenu |
			aMenu := menuView menu.
			aMenu removeItemAt: index.
			self ensureMinimumMenuContents: aMenu.
			self generateAcceleratorConflicts.
			menuView selectionByIndex: (index min: aMenu size)]!

selection
	"Answer the selected menu item."

	^self selectionView selectionOrNil!

selectionView
	"Private - Anser the menu which the current selection can be in.

	Note that the only case where a menuView does not have a selection and
	so we return the first view, is during the process of building the top
	level menuView for the first time."

	^menuViews reverse detect: [:menuView | menuView hasSelection] ifNone: [menuViews first]!

stripUntitled: aMenu 
	"Private - This will strip all untitled commands or untitled menus
	which only contain no entries.
	Note how we recurse down through the items."

	aMenu items copy do: [:each | self stripUntitled: each].
	aMenu items copy 
		do: [:each | (each size = 0 and: [each text beginsWith: self untitledPrefix]) ifTrue: [aMenu removeItem: each]]!

topMenuInset
	"Private - Anser the offset of the top menu from the origin of
	the receivers client view."

	^10@10!

trackMouse: aMouseEvent 
	| menu index |
	menu := aMouseEvent window.
	index := menu itemAt: aMouseEvent position.
	index == 0 
		ifFalse: 
			[self arena onItemIn: menu selectedAtIndex: index.
			menu setFocus].
	^index!

untitledPrefix
	"Private - Answer the prefix to be used for as yet untitled menus and items."

	^'untitled '!

update: aMenuComposerView do: operation 
	self closeSubmenuViewsOf: aMenuComposerView.
	operation value.
	aMenuComposerView refreshContents.
	self openSelectedSubmenuOf: aMenuComposerView! !
!Tools.MenuComposer categoriesFor: #addCommand!commands!public! !
!Tools.MenuComposer categoriesFor: #addItem:!adding!private! !
!Tools.MenuComposer categoriesFor: #addItem:view:index:!adding!private! !
!Tools.MenuComposer categoriesFor: #addMenu!commands!public! !
!Tools.MenuComposer categoriesFor: #addSeparator!commands!public! !
!Tools.MenuComposer categoriesFor: #apply!commands!public! !
!Tools.MenuComposer categoriesFor: #arena!accessing!public! !
!Tools.MenuComposer categoriesFor: #clearSelection!commands!public! !
!Tools.MenuComposer categoriesFor: #closeSubmenuViewsOf:!operations!private! !
!Tools.MenuComposer categoriesFor: #collectAcceleratorsOf:into:!helpers!private! !
!Tools.MenuComposer categoriesFor: #commandItemClass!commands!private! !
!Tools.MenuComposer categoriesFor: #copySelection!commands!public! !
!Tools.MenuComposer categoriesFor: #cutSelection!commands!public! !
!Tools.MenuComposer categoriesFor: #dragCoordinator!constants!drag & drop!private! !
!Tools.MenuComposer categoriesFor: #ensureMinimumMenuContents:!helpers!private! !
!Tools.MenuComposer categoriesFor: #generateAcceleratorConflicts!helpers!private! !
!Tools.MenuComposer categoriesFor: #generateAcceleratorConflicts:!helpers!private! !
!Tools.MenuComposer categoriesFor: #hasClipboard!private!testing! !
!Tools.MenuComposer categoriesFor: #initialize!initializing!private! !
!Tools.MenuComposer categoriesFor: #menu!accessing!public! !
!Tools.MenuComposer categoriesFor: #menuClass!constants!private! !
!Tools.MenuComposer categoriesFor: #model:!accessing!public! !
!Tools.MenuComposer categoriesFor: #mutateIntoCommand!commands!private! !
!Tools.MenuComposer categoriesFor: #mutateIntoMenu!commands!private! !
!Tools.MenuComposer categoriesFor: #mutateSelection:!helpers!private! !
!Tools.MenuComposer categoriesFor: #newCommandItem!helpers!private! !
!Tools.MenuComposer categoriesFor: #newMenu!helpers!private! !
!Tools.MenuComposer categoriesFor: #onItemFrom:at:droppedBefore:copy:!drag & drop!event handling!private! !
!Tools.MenuComposer categoriesFor: #onItemIn:selectedAtIndex:!event handling!private! !
!Tools.MenuComposer categoriesFor: #onMenuClicked:!event handling!private! !
!Tools.MenuComposer categoriesFor: #onMenuTrack:!event handling!private! !
!Tools.MenuComposer categoriesFor: #onViewOpened!adding!private! !
!Tools.MenuComposer categoriesFor: #openMenu:at:!operations!private! !
!Tools.MenuComposer categoriesFor: #openSelectedSubmenuOf:!operations!private! !
!Tools.MenuComposer categoriesFor: #pasteClipboard!commands!public! !
!Tools.MenuComposer categoriesFor: #properties!commands!public! !
!Tools.MenuComposer categoriesFor: #queryCommand:!commands!private! !
!Tools.MenuComposer categoriesFor: #removeItemView:index:!private!removing! !
!Tools.MenuComposer categoriesFor: #selection!public!selection! !
!Tools.MenuComposer categoriesFor: #selectionView!private!selection! !
!Tools.MenuComposer categoriesFor: #stripUntitled:!operations!private! !
!Tools.MenuComposer categoriesFor: #topMenuInset!constants!private! !
!Tools.MenuComposer categoriesFor: #trackMouse:!helpers!private! !
!Tools.MenuComposer categoriesFor: #untitledPrefix!constants!private! !
!Tools.MenuComposer categoriesFor: #update:do:!operations!private! !

!Tools.MenuComposer class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^self menuClass new asValue!

icon
	"Answers an Icon that can be used to represent this class."

	^self menuClass icon
!

menuClass
	"Private - Answer the base menu class that instances of the receiver will edit|"

	^Menu!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 133 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 2 1049094 ##(Core.Association) 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 704 nil nil nil 7 nil nil nil 704 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 704 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 15 -3 578 1351 71 800 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 254 255 255 255 170 2 0 0 33 0 0 0] 8 #() 578 193 193 nil 27 nil nil nil 170 192 1088 1180166 ##(Graphics.Rectangle) 578 15 1 578 17 15 898 138 144 34 1 962 #createAt:extent: 34 2 578 5 669 578 1381 81 704 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 78 1 0 0 180 2 0 0 118 1 0 0] 34 1 800 1104 nil 27 1 674 410 ##(Tools.MenuComposerArena) 34 20 nil 416 34 2 8 1140850688 393217 1376 nil 917510 ##(Graphics.Color) #applicationWorkspace nil 7 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #cutSelection 8 'Cu&t' 1 1 nil nil nil 1522 1 1554 #copySelection 8 '&Copy' 1 1 nil nil nil 1522 1 1554 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 1522 1 1554 #clearSelection 8 '&Delete' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1522 1 1554 #addMenu 8 'Add &Menu' 1 1 nil nil nil 1522 1 1554 #addCommand 8 '&Add Command' 1 1 nil nil nil 1522 1 1554 #addSeparator 8 'Add &Separator' 1 1 nil nil nil 1746 4097 1474 nil true 34 2 1522 1 1554 #mutateIntoMenu 8 '&Menu' 1 1 nil nil nil 1522 1 1554 #mutateIntoCommand 8 '&Command' 1 1 nil nil nil 8 'M&utate Into' nil 1 nil nil nil nil nil 1760 1522 1 1554 #properties 8 'P&roperties' 1 1 nil nil nil 8 'Menu Composer' nil 1 nil nil nil nil nil nil nil 1376 nil 170 192 1088 1138 578 1 1 578 1 1 nil nil nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 5 5 578 1381 665 1376 962 #contextMenu: 34 1 1488 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 2 0 0 0 180 2 0 0 78 1 0 0] 8 #() 1104 nil 27 3 true 170 192 34 2 1376 8 'arena' 1138 578 5 5 578 5 5 658246 4 ##(UI.MenuBar) nil true 34 2 1474 nil true 34 3 1522 1 1554 #addMenu 8 '&Menu' 9371 1 nil nil nil 1522 1 1554 #addCommand 8 '&Command' 9373 1 nil nil nil 1522 1 1554 #addSeparator 8 '&Separator' 9595 1 nil nil nil 8 '&Add' nil 1 nil nil 45831 nil nil 1474 nil true 34 6 1522 1 1554 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 1522 1 1554 #copySelection 8 '&Copy' 9351 1 nil nil nil 1522 1 1554 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 1522 1 1554 #clearSelection 8 '&Delete' 1629 1 nil nil nil 1746 4097 1522 1 1554 #properties 8 'P&roperties' 5363 1 nil nil nil 8 '&Edit' nil 1 nil nil 45843 nil nil 8 'Menu Composer Bar' nil 1 nil nil nil nil nil nil nil nil 25619 nil nil nil 578 521 641 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 1996777232 898 138 144 34 2 962 #createAt:extent: 34 2 578 6143 21 578 1421 871 416 962 #text: 34 1 8 'Menu Composer' 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 197 14 0 0 189 1 0 0] 34 2 1376 704 1104 nil 27 )! !
!Tools.MenuComposer class categoriesFor: #defaultModel!models!public! !
!Tools.MenuComposer class categoriesFor: #icon!constants!public! !
!Tools.MenuComposer class categoriesFor: #menuClass!constants!private! !
!Tools.MenuComposer class categoriesFor: #resource_Default_view!public!resources-views! !

