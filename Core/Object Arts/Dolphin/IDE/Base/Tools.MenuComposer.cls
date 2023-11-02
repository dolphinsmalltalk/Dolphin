"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'Tools.MenuComposer'
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

	Clipboard current setObject: self selection!

cutSelection
	"Cuts the current selections to the clipboard"

	self copySelection; clearSelection
!

dragCoordinator
	"Private - Answer the drag object used to synchronize writing to the receiver's view."

	^arena!

ensureMinimumMenuContents: aMenu 
	"Private - We have to ensure that there is at least one item
	in a menu for our selection based system to work. Here
	we ensure that by adding a command entry if need be."

	aMenu size = 0 
		ifTrue: [aMenu addItem: (aMenu isMenuBar ifTrue: [self newMenu] ifFalse: [self newCommandItem])]
		ifFalse: [aMenu itemsDo: [:item | item hasSubmenu ifTrue: [self ensureMinimumMenuContents: item]]]!

generateAcceleratorConflicts
	"Private - Generate the receiver's set of conflicting accelerator keys and update
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
					[(MessageBox new
						caption: 'Mutate Menu into Command…';
						headline: 'Discard menu sub-items?';
						confirm: 'The menu <1p> has sub-items that will be lost.<n><n>Are you sure you want to contine?'
									<< item description)
							ifFalse: [proceed := false]].
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
	sourceView := menuViews detect: [:menuView | menuView menu == sourceMenu] ifNone: nil.
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
	the receiver's client view."

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
!Tools.MenuComposer categoriesForMethods!
addCommand!commands!public! !
addItem:!adding!private! !
addItem:view:index:!adding!private! !
addMenu!commands!public! !
addSeparator!commands!public! !
apply!commands!public! !
arena!accessing!public! !
clearSelection!commands!public! !
closeSubmenuViewsOf:!operations!private! !
collectAcceleratorsOf:into:!helpers!private! !
commandItemClass!commands!private! !
copySelection!commands!public! !
cutSelection!commands!public! !
dragCoordinator!constants!drag & drop!private! !
ensureMinimumMenuContents:!helpers!private! !
generateAcceleratorConflicts!helpers!private! !
generateAcceleratorConflicts:!helpers!private! !
hasClipboard!private!testing! !
initialize!initializing!private! !
menu!accessing!public! !
menuClass!constants!private! !
model:!accessing!public! !
mutateIntoCommand!commands!private! !
mutateIntoMenu!commands!private! !
mutateSelection:!helpers!private! !
newCommandItem!helpers!private! !
newMenu!helpers!private! !
onItemFrom:at:droppedBefore:copy:!drag & drop!event handling!private! !
onItemIn:selectedAtIndex:!event handling!private! !
onMenuClicked:!event handling!private! !
onMenuTrack:!event handling!private! !
onViewOpened!adding!private! !
openMenu:at:!operations!private! !
openSelectedSubmenuOf:!operations!private! !
pasteClipboard!commands!public! !
properties!commands!public! !
queryCommand:!commands!private! !
removeItemView:index:!private!removing! !
selection!public!selection! !
selectionView!private!selection! !
stripUntitled:!operations!private! !
topMenuInset!constants!private! !
trackMouse:!helpers!private! !
untitledPrefix!constants!private! !
update:do:!operations!private! !
!

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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 2 518 #{Core.Association} 18 #{Tools.MenuComposerArena} 50 20 nil 32 50 2 8 1140850688 393217 352 nil 6 #{Graphics.Color} #applicationWorkspace nil 5 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #cutSelection 8 'Cu&t' 1 1 nil nil nil 498 1 530 #copySelection 8 '&Copy' 1 1 nil nil nil 498 1 530 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 498 1 530 #clearSelection 8 '&Delete' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 498 1 530 #addMenu 8 'Add &Menu' 1 1 nil nil nil 498 1 530 #addCommand 8 '&Add Command' 1 1 nil nil nil 498 1 530 #addSeparator 8 'Add &Separator' 1 1 nil nil nil 722 4097 450 nil true 50 2 498 1 530 #mutateIntoMenu 8 '&Menu' 1 1 nil nil nil 498 1 530 #mutateIntoCommand 8 '&Command' 1 1 nil nil nil 8 'M&utate Into' nil 1 nil nil nil nil nil 736 498 1 530 #properties 8 'P&roperties' 1 1 nil nil nil 8 'Menu Composer' nil 1 nil nil nil nil nil nil nil 352 nil 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 210 1 1 210 1 1 nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 5 5 210 1381 665 352 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 2 0 0 0 180 2 0 0 78 1 0 0] 8 #() 210 193 193 nil 27 3 322 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 1440 nil nil nil 5 nil nil nil 1440 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 1440 50 2 8 1140850688 131073 1536 nil nil nil 5 nil nil nil 1536 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1218 50 1 1266 #createAt:extent: 50 2 210 15 -3 210 1351 71 1536 1346 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 7 0 0 0 254 255 255 255 170 2 0 0 33 0 0 0] 8 #() 1408 nil 27 nil nil nil 1122 0 1154 210 15 1 210 17 15 1218 50 1 1266 #createAt:extent: 50 2 210 5 669 210 1381 81 1440 1346 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 78 1 0 0 180 2 0 0 118 1 0 0] 50 1 1536 1408 nil 27 1 true 518 #{Kernel.STBIdentityDictionaryProxy} 1120 50 2 352 8 'arena' 1154 210 5 5 210 5 5 2886 4 #{UI.MenuBar} nil true 50 2 450 nil true 50 3 498 1 530 #addMenu 8 '&Menu' 9371 1 nil nil nil 498 1 530 #addCommand 8 '&Command' 9373 1 nil nil nil 498 1 530 #addSeparator 8 '&Separator' 9595 1 nil nil nil 8 '&Add' nil 1 nil nil nil nil nil 450 nil true 50 6 498 1 530 #cutSelection 8 'Cu&t' 9393 1 nil nil nil 498 1 530 #copySelection 8 '&Copy' 9351 1 nil nil nil 498 1 530 #pasteClipboard 8 '&Paste' 9389 1 nil nil nil 498 1 530 #clearSelection 8 '&Delete' 1629 1 nil nil nil 722 4097 498 1 530 #properties 8 'P&roperties' 5363 1 nil nil nil 8 '&Edit' nil 1 nil nil nil nil nil 8 'Menu Composer Bar' nil 1 nil nil nil nil nil nil nil nil 1 nil nil nil 210 521 641 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 1218 50 2 1266 #createAt:extent: 50 2 210 6143 21 210 1421 871 32 1266 #text: 50 1 8 'Menu Composer' 32 1346 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 197 14 0 0 189 1 0 0] 50 2 352 1440 1408 nil 27)! !
!Tools.MenuComposer class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
menuClass!constants!private! !
resource_Default_view!public!resources-views! !
!

