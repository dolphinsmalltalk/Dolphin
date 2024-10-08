﻿"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'UI.Menu'
	instanceVariableNames: 'items text name flags image metrics id lastQuery _reserved2'
	classVariableNames: 'DrawStateCallbackDescriptor'
	imports: #(#{OS.MENUITEMINFOW private} #{OS.MENUINFO private})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Menu guid: (Core.GUID fromString: '{87b4c636-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.Menu comment: 'Menu is the class of objects use to represent popup menu''s in windows. A menu holds a list of items that may be commands, sub-menus, or dividers.

Instance Variables:
	items			<sequencedReadableCollection>
	text				<String>. The name of the menu, as displayed to the user.
	name			<Symbol>. The symbolic name of the menu, if needed to enable/disable the entire menu. Normally nil.
	flags			<integer>. Various flags.
	image			<Icon> associated with the menu, displayed in its containing menu (if any).
	id				<integer>. Unique id of the menu, needed for custom draw support.
	imageManager	<ImageManager> used to manage the images on the menu, normally nil in which case the default <IconImageManager> is used.
	_reserved1		<UndefinedObject>. Reserved for future use.
	_reserved2		<UndefinedObject>. Reserved for future use.
'!

!UI.Menu categoriesForClass!Graphics-Tools! !

!UI.Menu methodsFor!

acceleratorKey
	"Answer the accelerator key code for the receiver.
	Menus have none, of course, but this is part of a composite
	pattern with MenuItem."

	^0!

addCommand: command description: aString
	"Append a <CommandMenuItem> to the receiver configured with the specified command
	and description, and answer it."

	^self addItem: (CommandMenuItem command: command description: aString)!

addCommand: command description: aString image: anImage
	"Append a <CommandMenuItem> to the receiver configured with the specified command
	and description, and answer it."

	^self addItem: (CommandMenuItem
				command: command
				description: aString
				image: anImage)!

addCommandDescription: aCommandDescription
	"Append a <CommandMenuItem> to the receiver configured with the specified 
	<commandDescription>, and answer it."

	^self addItem: (CommandMenuItem commandDescription: aCommandDescription)!

addItem: aMenuItem
	"Add aMenuItem as the last item of the receiver. Answer the newly added item."

	items := items copyWith: aMenuItem.
	self insertIntoMenu: aMenuItem at: items size+1.
	^aMenuItem!

addSeparator
	"Add standard separator as the last item of the receiver.
	Answer that separator."

	^self addItem: DividerMenuItem separator!

addSubmenu: aString
	"Append a sub-<Menu> to the receiver with the specified title, and answer it."

	^self addItem: (Menu description: aString)!

addSubmenu: aString image: anImage
	"Append a sub-<Menu> to the receiver with the specified title, and answer it."

	^self addItem: (Menu description: aString image: anImage)!

allItems
	"Answer all the menus and items, recursively, in the receiver in depth-first order starting with the receiver itself."

	| allItems |
	allItems := (Array new: 8) writeStream.
	self allItemsDo: [:each | allItems nextPut: each].
	^allItems contents!

allItemsDo: aMonadicValuable
	aMonadicValuable value: self.
	items do: [:each | each allItemsDo: aMonadicValuable]!

allMenus
	"Answer all the menus, recursively, in the receiver in depth-first order starting with the receiver itself."

	| menus |
	menus := Array writeStream.
	self allMenusDo: [:each | menus nextPut: each].
	^menus contents!

allMenusDo: aMonadicValuable
	aMonadicValuable value: self.
	items do: [:each | each allMenusDo: aMonadicValuable]!

applyFlags
	| struct |
	(flags isNil or: [flags == 0]) ifTrue: [^self].
	struct := MENUINFO newBuffer.
	struct style: flags.
	(User32 setMenuInfo: self asParameter lpcmi: struct) ifFalse: [Sound errorBeep]!

basicFree
	"Private - Free the Menu resource handle and all submenus."

	1 to: items size do: [:i | (items at: i) detach].
	User32 destroyMenu: handle!

basicRealize
	"Private - Realizes the handle for the context menu and all connected submenus."

	| info |
	super basicRealize.
	self applyFlags.
	info := MENUITEMINFOW newBuffer.
	1 to: items size
		do: 
			[:i |
			(items at: i)
				insertIntoMenu: self
				at: i
				info: info]!

clear
	"Delete all the receiver's sub-items."

	self isRealized
		ifTrue: 
			[items size to: 1
				by: -1
				do: [:i | self deleteItemAt: i]].
	items := {}!

clearCached
	"Private - Clear down the receiver's cached information and handles."

	handle := id := nil!

command
	"Answer the command selector for the receiver.
	Strictly speaking this is not a command, but it is useful  as part of a composite
	pattern with MenuItem (in fact as part of the <commandDescription> protocol)
	which enables us use the normal command querying process for routing, enabling,
	etc, of pop-up menus, as well as individual items."

	^self name!

commandDescription
	"Answer a <CommandDescription> for the receiver.
	See #command."

	^CommandDescription
		command: self command
		description: self description
		image: self image!

commandString
	"Answer a String representation of the receiver's command."

	^name ?? ''!

commandString: aString
	"Sets the receiver's command from the <readableString> representation, aString."

	| command |
	command := aString trimBlanks.
	name := command isEmpty ifFalse: [command asSymbol]!

createHandle
	"Private - Answer an external handle to a new popup menu."

	^User32 createPopupMenu!

defaultFlags
	"Private - Answer the default flags to be applied when realizing new instances of the receiver."

	"Implementation Note: The MNS_CHECKORBMP flag will share a single column in the menu for any
	check marks and items images, with checkmarks taking precedence. This looks better than the separate
	column mode, although note that pre D6 views will maintain the original behaviour of having
	separate checkmark and image columns unless they are modified by setting the #hasSharedImageColumn
	aspect to true."

	^MNS_CHECKORBMP!

deleteItemAt: position
	"Private - Delete the receiver's item at the specified one-based index."

	(items at: position) free.
	(User32
		deleteMenu: self handle
		uPosition: position - 1
		uFlags: MF_BYPOSITION) ifFalse: [User32 systemError]!

description
	"Private - Answer a short textual description of the receiver's command.
	See also #command."

	^self text!

description: aString 
	self text: aString!

detach
	"Private - Disassociate the receiver from its handle, and do the same for all sub-menus (recursively). Called when a parent menu is destroyed by a call to DestroyMenu, which is a recursive destroy."

	handle ifNil: [^self].
	self beUnfinalizable.
	self clearCached.
	1 to: items size do: [:i | (items at: i) detach]!

drawItemImage: itemImage on: hDC at: aPoint disabled: aBoolean
	| imageList extent imageIndex callback iconSize inset |
	extent := metrics menuImageExtent.
	iconSize := Icon standardSizeFor: extent.
	inset := (extent - iconSize) // 2.
	imageList := self imageManager imageListWithExtent: iconSize.
	imageIndex := self imageManager indexOfImage: itemImage.
	aBoolean
		ifFalse: 
			[imageList
				draw: imageIndex
				on: hDC
				at: aPoint + inset.
			^self].
	"Use DrawState() API to get the correct disabled image look, but use the callback option
	because we want to draw out of an image list rather than from an icon or bitmap"
	callback := External.Callback block: 
					[:hdc :lData :wData :cx :cy |
					"Must draw on the DC supplied to the callback, not the original DC"
					imageList
						draw: wData
						on: hdc
						at: inset.
					true]
				descriptor: DrawStateCallbackDescriptor.
	User32
		drawState: hDC
		hbr: nil
		lpOutputFunc: callback asParameter
		lData: nil
		wData: imageIndex
		x: aPoint x
		y: aPoint y
		cx: extent x
		cy: extent y
		fuFlags: ##(DST_COMPLEX bitOr: DSS_DISABLED).
	callback free!

findCommand: aSymbol
	"Answer the first <Menu>|<MenuItem> whose symbolic name or command matches the <Symbol> argument, or nil if there is no such item."

	^items detect: [:aMenuItem | aMenuItem command = aSymbol] ifNone: nil!

flags: anInteger 
	flags := anInteger!

fromStrings: anArray
	"Private - Convert menuArray into a series of MenuItems.
	menuArray is an array of strings. 
	NB: Not realized yet."

	| label |
	label := anArray lookup: 1.
	label ifNil: [^self].
	self text: label.
	anArray from: 2
		do: 
			[:each |
			self addItem: (each isString ifTrue: [MenuItem fromString: each] ifFalse: [Menu fromStrings: each])]!

hasSharedImageColumn
	"Answer whether the checkmark column is also used for images - if the answer is false then separate
	columns will be used for each, althought the image column will not be displayed unless needed.
	The default is now to have shared columns, although old views will maintain the original behaviour
	of having separate columns."

	^flags allMask: MNS_CHECKORBMP!

hasSharedImageColumn: aBoolean 
	"Set whether the checkmark column is also used for images, or there are separate columns for each.
	When the column is shared, checkmarks take precedence. The shared column mode looks better if the
	menu does not need any checkmarks."

	"Implementation Note: We don't support the MNS_NOCHECK mode (no checkmark column) as this
	is aesthetically unpleasant when there are no images since the whitespace to the left and right of
	the menu text is unbalanced, and a bit pointless when the menu has images since an image column
	will then be needed anyway, and in that case the shared column mode is almost identical."

	flags := (flags maskClear: ##(MNS_CHECKORBMP | MNS_NOCHECK)) mask: MNS_CHECKORBMP set: aBoolean!

hasSubmenu
	"Answer whether the receiver has a submenu connected to it."

	^true!

id
	"Answers the menu item identifier for the receiver."

	"Implementation Note: This is part of the <menuItem> protocol anyway, but we need 
	a unique id per sub-menu in order to be able to implement custom-drawing of the item
	images since the callback identifies these by id rather than position."

	id isNil ifTrue: [id := CommandDescription nextId].
	^id!

image
	"Answer the <Image> currently associated with this menu, or nil if none."

	^image!

image: anIcon 
	image := anIcon!

imageManager
	^Icon imageManager!

includesCommand: command
	^(self indexOfCommand: command ifAbsent: nil) notNil!

indexOfCommand: target
	"Private - Answer the index of the first <MenuItem> in the receiver
	whose command symbol matches the <Command>, target."

	^self indexOfCommand: target 
		ifAbsent: [self errorNotFound: target]!

indexOfCommand: target ifAbsent: exceptionHandler
	"Private - Answer the index of the first <MenuItem> within the receiver whose command 
	matches the <Command>, target, or if not present the result of evaluating the 
	<niladicValuable>, exceptionHandler."

	| index |
	index := items findFirst: [:item | item command = target].
	^index == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [index]!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	items := {}.
	text := String new.
	flags := self defaultFlags!

insertIntoMenu: aMenuItem at: anInteger
	self isRealized
		ifTrue: 
			[aMenuItem
				insertIntoMenu: self
				at: anInteger - 1
				info: MENUITEMINFOW newBuffer]!

insertIntoMenu: parentMenu at: position info: aMENUITEMINFO
	"Append the receiver to the <Menu>, parentMenu, which can be nil if this is to be a 
	top-level menu."

	| hParent |
	parentMenu
		ifNotNil: 
			[hParent := parentMenu asParameter.
			self metrics: parentMenu metrics].
	self realize.
	hParent isNull ifTrue: [^self].
	aMENUITEMINFO
		basicText: self text;
		wID: self id;
		hSubMenu: self asParameter;
		fMask: (image
					ifNil: [##(MIIM_SUBMENU | MIIM_STRING | MIIM_ID)]
					ifNotNil: 
						[aMENUITEMINFO setImage: image metrics: self metrics.
						##(MIIM_SUBMENU | MIIM_STRING | MIIM_ID | MIIM_BITMAP)]).
	(User32
		insertMenuItem: hParent
		uItem: position
		fByPosition: true
		lpmii: aMENUITEMINFO)
			ifFalse: 
				[Win32Error signal: ('Unable to realize <1p> in <2p>' expandMacrosWith: self with: parentMenu)]!

insertItem: item after: predecessor
	"Append the <MenuItem>, item,  to this menu after the <Command>, predecessor.
	Answer item."

	^self insertItem: item at: (self indexOfCommand: predecessor)+1!

insertItem: aMenuItem at: anInteger 
	"Insert the <MenuItem> into this menu at the <integer>
	position, shuffling any items currently at that index or
	below down one position."

	| newSize oldItems |
	oldItems := items.
	newSize := items size + 1.
	items := items copyEmpty: newSize.
	items
		replaceFrom: 1
			to: anInteger - 1
			with: oldItems
			startingAt: 1;
		at: anInteger put: aMenuItem;
		replaceFrom: anInteger + 1
			to: newSize
			with: oldItems
			startingAt: anInteger.
	self insertIntoMenu: aMenuItem at: anInteger.
	^aMenuItem!

insertItem: aMenuItem before: successor
	"Append aMenuItem to this menu before the <Command>, successor.
	Answer aMenuItem."

	^self insertItem: aMenuItem at: (self indexOfCommand: successor)!

isAutoDismiss
	^flags allMask: MNS_AUTODISMISS!

isAutoDismiss: aBoolean 
	flags := flags mask: MNS_AUTODISMISS set: aBoolean!

isDefault
	"Answer whether the receiver is expecting to be the default item on a menu."

	^false!

isDivider
	"Answer whether the receiver is a visual divider as opposed to a command item, 
	popup menu, or menu bar."

	^false!

isEmpty
	"Answer whether the has any items."

	^items isEmpty!

isMenuBar
	"Answer whether the receiver is a menu bar rather
	than a popup menu."

	^false!

isModeless
	^flags allMask: MNS_MODELESS!

isModeless: aBoolean 
	flags := flags mask: MNS_MODELESS set: aBoolean!

isRadioButtonStyle
	^false!

itemAt: anInteger
	"Answer the <MenuItem> at the specified <integer> index in the receiver."

	^items at: anInteger!

itemAt: anInteger put: aMenuItem 
	"Set the <MenuItem> at the specified <integer> index in the receiver."

	^items at: anInteger put: aMenuItem!

items
	"Answer an <OrderedCollection> of <MenuItem>s which are available from this menu.
	Note: We answer as an OrderedCollection for backwards compatibility and ease of
	external manipulation, even though the items are stored internally as an Array."

	^items asOrderedCollection!

items: collection
	"Sets the collection of <MenuItem>s which are available from this menu
	to the Array representation of the <sequencedReadableCollection> argument."

	items := collection asArray!

itemsDo: aMonadicValuable 
	items do: aMonadicValuable!

itemWithId: anInteger
	"Find and return the command in the menu associated with the specified id, or nil if not found."

	(anInteger == 0 or: [anInteger = self id]) ifTrue: [^self].
	1 to: items size do: [:i | ((items at: i) itemWithId: anInteger) ifNotNil: [:found | ^found]].
	^nil!

lastQuery
	^lastQuery
		ifNil: 
			[lastQuery := UI.CommandQuery new
						beEnabled;
						yourself]!

lastQuery: aCommandQuery
	lastQuery := aCommandQuery!

menuFromHandle: menuHandle 
	"Find and return the sub-menu associated with the specified handle."

	handle = menuHandle 
		ifTrue: [^self]
		ifFalse: 
			[items do: 
					[:item | 
					| found |
					found := item menuFromHandle: menuHandle.
					found notNil ifTrue: [^found]]].
	^nil!

metrics
	^metrics ifNil: [SystemMetrics current]!

metrics: aSystemMetrics
	metrics == aSystemMetrics ifTrue: [^self].
	self free.
	metrics := aSystemMetrics!

name
	"Answer the symbolic name of the receiver. The name is useful if the receiver is a dynamic
	menu whose contents are to be adjusted at run-time, or for which the application wishes to
	control the enablement state. This can be nil if the receiver is un-named, which is the
	default."

	^name!

name: aSymbolOrNil 
	name := (aSymbolOrNil isNil or: [aSymbolOrNil isEmpty]) ifFalse: [aSymbolOrNil asSymbol]!

notEmpty
	"Answer whether the has any items."

	^self isEmpty not!

onDrawItem: aDRAWITEMSTRUCT 
	"Private - Draw the image for an item in the receiver (if any)"

	| itemImage aMenuItem |
	aMenuItem := self itemWithId: aDRAWITEMSTRUCT itemID.
	aMenuItem isNil ifTrue: [^self].
	itemImage := aMenuItem image.
	itemImage isNil ifTrue: [^self].
	self 
		drawItemImage: itemImage
		on: aDRAWITEMSTRUCT hDC
		at: aDRAWITEMSTRUCT rcItem topLeft
		disabled: aDRAWITEMSTRUCT isGrayed!

postCopy
	"Apply any final flourish to the copy that may be required."

	super postCopy.
	items := items collect: [:each | each copy].
	^self!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer would want to see it."

	aStream
		basicPrint: self;
		nextPut: $(.
	self name
		ifNil: 
			[| label |
			label := self text.
			label isEmpty ifFalse: [aStream print: label]]
		ifNotNil: [:symbol | aStream print: symbol].
	aStream nextPut: $)!

queryAllAlong: aCommandPolicy recursive: aBoolean
	"Private - Query the command status for the receiver and each of its command items and
	immediate sub-menus using the specified <commandPolicy>. The checked/enabled/default status
	of each item is updated to reflect the command status (as determined by the <commandTarget>s
	on the route) at this time. If the receiver is itself named, then it is possible for the
	command targets to enable/disable the receiver. If enabled the command target which
	indicated its willingness to handle the command is sent an #onAboutToDisplayMenu: message to
	give it the opportunity to dynamically set or update the menu items. Only after the set of
	items on the menu has been determined are those items themselves routed around to determine
	their status, and to allow the text to be updated."

	| menuQuery itemInfo hMenu itemMetrics |
	menuQuery := self queryAlong: aCommandPolicy.
	menuQuery isEnabled ifTrue: [menuQuery receiver onAboutToDisplayMenu: self].
	itemInfo := MENUITEMINFOW newBuffer.
	hMenu := self handle.
	itemMetrics := self metrics.
	items keysAndValuesDo: 
			[:i :menuItem |
			(aBoolean and: [menuItem hasSubmenu])
				ifTrue: [menuItem queryAllAlong: aCommandPolicy recursive: true]
				ifFalse: 
					["Set the checked and enabled states, update the text (if desired), etc"
					(menuItem queryAlong: aCommandPolicy)
						ifNotNil: 
							[:query |
							| updated |

							updated := itemInfo updateQuery: menuItem lastQuery to: query metrics: itemMetrics.
							menuItem lastQuery: query.
							updated
								ifTrue: 
									[User32
										setMenuItemInfo: hMenu
										uItem: i - 1
										fByPosition: true
										lpmii: itemInfo]]]].
	^menuQuery!

queryAllFromView: aView
	"Private - Query each menu item along a route from the <View>, aView."

	^self queryAllAlong: aView presenter commandPolicy recursive: false!

queryAlong: aCommandPolicy
	"Answer a <CommandQuery> reflecting the current state of the receiver's command for the
	specified <commandPolicy>."

	^aCommandPolicy query: self commandDescription!

registerAcceleratorKeyIn: anAcceleratorTable
	"Register any keys associated with our menu items, and any submenus."

	items do: [:aMenuItem |
		aMenuItem registerAcceleratorKeyIn: anAcceleratorTable]!

removeItem: aMenuItem
	"Remove the specified <MenuItem> from the receiver."

	^self removeItemAt: (items indexOf: aMenuItem ifAbsent: [self errorNotFound: aMenuItem])!

removeItemAt: index
	"Remove the menu item at the specified <integer> index. Answer the removed <MenuItem>."

	| removed |
	removed := items at: index.
	items := items copyWithoutIndex: index.
	self isRealized
		ifTrue: 
			[(User32
				removeMenu: self handle
				uPosition: index - 1
				uFlags: MF_BYPOSITION) ifFalse: [User32 systemError]].
	^removed!

replaceItem: oldMenuItem with: newMenuItem
	| index |
	index := items indexOf: oldMenuItem ifAbsent: [self errorNotFound: oldMenuItem].
	self itemAt: index put: newMenuItem!

setDefault: index
	"Set the item of the receiver with the specified 1-based <integer> index
	to be the default item. If the index is zero, then the menu has no default."

	User32
		setMenuDefaultItem: self handle
		uItem: index - 1
		fByPos: TRUE!

showIn: aView position: aPos
	"Show top level of context menu on screen at position aPos."

	^User32
		trackPopupMenu: self asParameter
		uFlags: ##(TPM_LEFTALIGN | TPM_RIGHTBUTTON)
		x: aPos x
		y: aPos y
		nReserved: 0
		hWnd: aView asParameter
		prcRect: nil!

size
	"Answer the number of items (including separators) in the menu."

	^items size!

stbSaveOn: anSTBOutFiler
	| savedHandle savedId savedMetrics |
	savedMetrics := metrics.
	savedId := id.
	savedHandle := handle.
	metrics := id := handle := nil.
	[super stbSaveOn: anSTBOutFiler] ensure: 
			[handle := savedHandle.
			id := savedId.
			metrics := savedMetrics]!

styleFlags
	"Private - Answer the MENUITEMINFO style flags of the receiver (see
	Win32 SDK docs for fType field)."

	^0!

text
	"Answer the title of the Menu, used for menu items with this as a submenu."

	^text!

text: textString
	"Set the title of the Menu to textString."

	text := textString	!

toStrings
	^{ text } , (items collect: [:each | each toStrings])!

typeFlags
	"Private - Answer the MENUITEMINFO style flags of the receiver (see
	Win32 SDK docs for fType field)."

	^0! !

!UI.Menu categoriesForMethods!
acceleratorKey!accessing!public! !
addCommand:description:!adding!public! !
addCommand:description:image:!adding!public! !
addCommandDescription:!adding!public! !
addItem:!adding!public! !
addSeparator!adding!public! !
addSubmenu:!adding!public! !
addSubmenu:image:!adding!public! !
allItems!accessing!public! !
allItemsDo:!enumerating!public! !
allMenus!accessing!public! !
allMenusDo:!enumerating!public! !
applyFlags!private!realizing/unrealizing! !
basicFree!private!realizing/unrealizing! !
basicRealize!public!realizing/unrealizing! !
clear!public!removing! !
clearCached!private!realizing/unrealizing! !
command!accessing!public! !
commandDescription!accessing!public! !
commandString!accessing!public! !
commandString:!accessing!public! !
createHandle!public!realizing/unrealizing! !
defaultFlags!initializing!private! !
deleteItemAt:!accessing!private! !
description!accessing!private! !
description:!accessing!public! !
detach!private!realizing/unrealizing! !
drawItemImage:on:at:disabled:!helpers!private! !
findCommand:!public!searching! !
flags:!accessing!private! !
fromStrings:!converting!private! !
hasSharedImageColumn!public!testing! !
hasSharedImageColumn:!accessing!public! !
hasSubmenu!public!testing! !
id!accessing!public! !
image!accessing!public! !
image:!accessing!public! !
imageManager!accessing!private! !
includesCommand:!public!testing! !
indexOfCommand:!accessing!private! !
indexOfCommand:ifAbsent:!accessing!private! !
initialize!initializing!private! !
insertIntoMenu:at:!adding!private! !
insertIntoMenu:at:info:!public!realizing/unrealizing! !
insertItem:after:!adding!public! !
insertItem:at:!adding!public! !
insertItem:before:!adding!public! !
isAutoDismiss!public!testing! !
isAutoDismiss:!accessing!public! !
isDefault!accessing!public! !
isDivider!public!testing! !
isEmpty!public!testing! !
isMenuBar!public!testing! !
isModeless!public!testing! !
isModeless:!accessing!public! !
isRadioButtonStyle!public!testing! !
itemAt:!accessing!public! !
itemAt:put:!accessing!public! !
items!accessing!public! !
items:!accessing!public! !
itemsDo:!enumerating!public! !
itemWithId:!accessing!public! !
lastQuery!accessing!private! !
lastQuery:!accessing!private! !
menuFromHandle:!accessing!public! !
metrics!accessing!public! !
metrics:!accessing!private! !
name!accessing!public! !
name:!accessing!public! !
notEmpty!public!testing! !
onDrawItem:!event handling-win32!private! !
postCopy!copying!public! !
printOn:!printing!public! !
queryAllAlong:recursive:!operations!public! !
queryAllFromView:!operations!private! !
queryAlong:!operations!public! !
registerAcceleratorKeyIn:!adding!public! !
removeItem:!public!removing! !
removeItemAt:!public!removing! !
replaceItem:with:!public!replacing! !
setDefault:!accessing!public! !
showIn:position:!drawing!public! !
size!accessing!public! !
stbSaveOn:!binary filing!public! !
styleFlags!private!realizing/unrealizing! !
text!accessing!public! !
text:!accessing!public! !
toStrings!converting!public! !
typeFlags!private!realizing/unrealizing! !
!

UI.Menu methodProtocol: #commandSource attributes: #(#readOnly) selectors: #(#commandDescription)!
UI.Menu methodProtocol: #menuItem attributes: #(#readOnly) selectors: #(#acceleratorKey #command #hasSubmenu #id #image #insertIntoMenu:at:info: #items #menuFromHandle: #queryAlong: #registerAcceleratorKeyIn: #text)!

!UI.Menu class methodsFor!

description: aString
	"Answer a new instance of the receiver with the specified menu text."

	^self new
		text: aString;
		yourself!

description: aString image: anImage
	"Answer a new instance of the receiver with the specified menu text and image."

	^self new
		text: aString;
		image: anImage;
		yourself!

fromStrings: strings
	"Answer a new menu built from strings.
	strings is an array of arrays or nil if no menu is required.

	The first string is the title of the menu.

	After the first entry each string represent a menu item and
	can be in one of the following forms:
		(1)	'<title>/[keyString]/<command>'
	Menu Item with title as the text. This may include an & preceeding an Alt
	mnemonic. KeyString, if included, represents an accelerator key attached to this
	menu item, this is of the form [Ctrl+][Shift+]<key>, where key is a single character
	or a special key such as: Ins, Home, Del, etc. Command is processed if
	the menu item is chosen.
		(2)	'-'
	Separator menu item.
		(3)	'|'
	Menu break item.
		(4)	'||'
	Menu bar break item.
	Example: 
		Menu fromStrings: #('&File' 'Open//fileOpen' '-' '&Save/Ctrl+S/fileSave')
	"

	^self new
		fromStrings: strings;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	View registerMessageMappings: self menuMessageMappings.
	DrawStateCallbackDescriptor := External.FunctionDescriptor returnType: 'bool'
				argumentTypes: 'handle intptr uintptr int32 int32'!

menuMessageMappings
	^{WM_CONTEXTMENU -> #wmContextMenu:wParam:lParam:.
		WM_INITMENU -> #wmInitMenu:wParam:lParam:.
		WM_INITMENUPOPUP -> #wmInitMenuPopup:wParam:lParam:.
		WM_DRAWITEM -> #wmDrawItem:wParam:lParam:.
		WM_MEASUREITEM -> #wmMeasureItem:wParam:lParam:}!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier Menu versions."

	| ver |
	ver := anSTBClassFormat version.
	ver < 1 ifTrue: [^[:data | self stbConvertFromVersion0: data]].
	"Version 2 adds 'name' instance variable, but as it default to nil, we can skip it"
	ver < 3 ifTrue: [^[:data | self stbConvertFromVersion2: data]].
	ver < 4 ifTrue: [^[:data | self stbConvertFromVersion3: data]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersion0: anArray
	"1: items becomes an Array"

	^self stbConvertFromVersion2: (anArray shallowCopy
				at: 3 put: (anArray at: 3) asArray;
				yourself)!

stbConvertFromVersion2: anArray
	"Private - Version 3 (D6) adds flags, image, and bitmap instance variables.
	The flags must be zeroed, but the other two default to nil."

	^self stbConvertFromVersion3: ((Array new: 8)
				replaceFrom: 1
					to: anArray size
					with: anArray;
				at: 6 put: 0;
				yourself)!

stbConvertFromVersion3: anArray
	"Private - Just more vars - all nil initially"

	"End of the chain"
	^(anArray resize: 11) becomeA: self!

stbVersion
	"Answer the current binary filer version number for instances of the receiver.
		0: Dolphin 1-2: items, text
		1: ?
		2: Dolphin 4,5: Adds name
		3: Dolphin 6: Adds flags (0), image), and bitmap
		4: ? Adds imageManager (now metrics), id, _reserved1, reserved2
	"

	^4!

uninitialize
	| menuMessages |
	menuMessages := {WM_CONTEXTMENU. WM_INITMENU. WM_INITMENUPOPUP}.
	#{ControlView} isDefined ifFalse: [menuMessages := menuMessages , {WM_DRAWITEM. WM_MEASUREITEM}].
	View unregisterMessageMappings: menuMessages! !

!UI.Menu class categoriesForMethods!
description:!instance creation!public! !
description:image:!instance creation!public! !
fromStrings:!instance creation!public! !
icon!constants!public! !
initialize!class initialization!development!public! !
menuMessageMappings!constants!must not strip!private! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion0:!binary filing!private! !
stbConvertFromVersion2:!binary filing!private! !
stbConvertFromVersion3:!binary filing!private! !
stbVersion!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

