"Filed out from Dolphin Smalltalk"!

GraphicsTool subclass: #Menu
	instanceVariableNames: 'items text name flags image imageManager id _reserved1 _reserved2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Menu guid: (GUID fromString: '{87b4c636-026e-11d3-9fd7-00a0cc3e4a32}')!

Menu comment: 'Menu is the class of objects use to represent popup menu''s in windows. A menu holds a list of items that may be commands, sub-menus, or dividers.

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

!Menu categoriesForClass!Graphics-Tools! !

!Menu methodsFor!

acceleratorKey
	"Answer the accelerator key code for the receiver.
	Menus have none, of course, but this is part of a composite
	pattern with MenuItem."

	^0!

addCommand: command description: aString 
	"Append a <CommandMenuItem> to the receiver configured with the specified command
	and description, and answer it."

	^self addItem: (CommandMenuItem command: command description: aString)!

addCommand: command description: aString  image: anImage
	"Append a <CommandMenuItem> to the receiver configured with the specified command
	and description, and answer it."

	^self addItem: (CommandMenuItem command: command description: aString image: anImage)!

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

allItems
	| allItems |
	allItems := OrderedCollection with: self.
	self itemsDo: [:each | allItems addAll: each allItems].
	^allItems!

allMenus
	^(OrderedCollection with: self)
		addAll: (self items select: [:each | each hasSubmenu]);
		yourself!

applyFlags
	| struct |
	(flags isNil or: [flags == 0]) ifTrue: [^self].
	struct := MENUINFO newBuffer.
	struct style: flags.
	(UserLibrary default setMenuInfo: self asParameter lpcmi: struct) ifFalse: [Sound errorBeep]!

basicFree
	"Private - Free the Menu resource handle and all submenus."

	| lib |
	lib := UserLibrary default.
	items keysAndValuesDo: 
			[:i :menuItem | 
			lib 
				removeMenu: handle
				uPosition: i - 1
				uFlags: MF_BYPOSITION.
			menuItem free].
	lib destroyMenu: handle!

basicRealize
	"Private - Realizes the handle for the context menu and all connected submenus."

	| info |
	super basicRealize.
	self applyFlags.
	info := MENUITEMINFOW newBuffer.
	items keysAndValuesDo: 
			[:i :each |
			each
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

	super clearCached.
	id := nil!

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

	^UserLibrary default createPopupMenu!

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
	(UserLibrary default deleteMenu: self handle uPosition: position-1 uFlags: MF_BYPOSITION)
		ifFalse: [UserLibrary default systemError]
!

description
	"Private - Answer a short textual description of the receiver's command.
	See also #command."

	^self text!

description: aString 
	self text: aString!

drawItemImage: itemImage on: hDC at: topLeft disabled: aBoolean
	| imageList extent imageIndex callback |
	extent := SystemMetrics current menuImageExtent.
	imageList := self imageManager imageListWithExtent: extent.
	imageIndex := self imageManager indexOfImage: itemImage.
	aBoolean
		ifFalse: 
			[imageList
				draw: imageIndex
				on: hDC
				at: topLeft.
			^self].
	"Use DrawState() API to get the correct disabled image look, but use the callback option
	because we want to draw out of an image list rather than from an icon or bitmap"
	callback := ExternalCallback block: 
					[:hdc :lData :wData :cx :cy |
					"Must draw on the DC supplied to the callback, not the original DC"
					imageList
						draw: wData
						on: hdc
						at: 0 @ 0.
					true]
				descriptor: ##(ExternalDescriptor returnType: 'bool'
						argumentTypes: 'handle intptr uintptr sdword sdword').
	UserLibrary default
		drawState: hDC
		hbr: nil
		lpOutputFunc: callback asParameter
		lData: nil
		wData: imageIndex
		x: topLeft x
		y: topLeft y
		cx: extent x
		cy: extent y
		fuFlags: ##(DST_COMPLEX | DSS_DISABLED).
	callback free!

findCommand: aSymbol
	"Answer the first <Menu>|<MenuItem> whose symbolic name or command matches the <Symbol> argument, or nil if there is no such item."

	^items detect: [:aMenuItem | aMenuItem command == aSymbol] ifNone: []!

flags: anInteger 
	flags := anInteger!

fromStrings: menuArray 
	"Private - Convert menuArray into a series of MenuItems.
	menuArray is an array of strings. 
	NB: Not realized yet."

	self text: (menuArray at: 1 ifAbsent: [^self]).
	menuArray 
		from: 2
		to: menuArray size
		do: 
			[:menuString | 
			self addItem: ((menuString isMemberOf: Array) 
						ifTrue: [self class fromStrings: menuString]
						ifFalse: [MenuItem fromString: menuString])]!

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
	^imageManager ifNil: [Icon imageManager]!

includesCommand: command
	^(self indexOfCommand: command ifAbsent: []) notNil!

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
				info: MENUITEMINFOW new]!

insertIntoMenu: parentMenu at: position info: aMENUITEMINFO
	"Append the receiver to the <Menu>, parentMenu, which can be nil if this is to be a 
	top-level menu."

	| hParent |
	hParent := parentMenu asParameter.
	self realize.
	hParent isNull ifTrue: [^self].
	aMENUITEMINFO subMenu: self text: self text.
	(UserLibrary default
		insertMenuItem: hParent
		uItem: position
		fByPosition: true
		lpmii: aMENUITEMINFO)
			ifFalse: [Win32Error signal: ('Unable to realize <1p> in >2p' expandMacrosWith: self with: parentMenu)]!

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

	(anInteger = 0 or: [anInteger = self id]) ifTrue: [^self].
	items do: 
			[:item | 
			| found |
			found := item itemWithId: anInteger.
			found notNil ifTrue: [^found]].
	^nil!

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
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream
		basicPrint: self;
		nextPut: $(; display: self text; nextPut: $)!

queryAllAlong: aCommandPolicy
	"Private - Query the command status for the receiver and each of its command items and
	immediate sub-menus using the specified <commandPolicy>. The checked/enabled/default status
	of each item is updated to reflect the command status (as determined by the <commandTarget>s
	on the route) at this time. If the receiver is itself named, then it is possible for the
	command targets to enable/disable the receiver. If enabled the command target which
	indicated its willingness to handle the command is sent an #onAboutToDisplayMenu: message to
	give it the opportunity to dynamically set or update the menu items. Only after the set of
	items on the menu has been determined are those items themselves routed around to determine
	their status, and to allow the text to be updated."

	| query itemInfo |
	query := self queryAlong: aCommandPolicy.
	query isEnabled ifTrue: [query receiver onAboutToDisplayMenu: self].
	itemInfo := MENUITEMINFOW new.
	items keysAndValuesDo: 
			[:i :menuItem |
			| itemQuery |
			itemQuery := menuItem queryAlong: aCommandPolicy.
			"Set the checked and enabled states, update the text (if desired), etc"
			itemInfo
				menuItem: menuItem
				text: itemQuery text
				state: (itemQuery isChecked ifTrue: [MFS_CHECKED] ifFalse: [MFS_UNCHECKED])
						| (itemQuery isEnabled ifTrue: [MFS_ENABLED] ifFalse: [MFS_DISABLED])
							| (itemQuery isDefault ifTrue: [MFS_DEFAULT] ifFalse: [0]).
			self setItem: i info: itemInfo]!

queryAllFromView: aView
	"Private - Query each menu item along a route from the <View>, aView."

	^self queryAllAlong: aView presenter commandPolicy.
!

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
			[(UserLibrary default
				removeMenu: self handle
				uPosition: index - 1
				uFlags: MF_BYPOSITION) ifFalse: [UserLibrary default systemError]].
	^removed!

replaceItem: oldMenuItem with: newMenuItem
	| index |
	index := items indexOf: oldMenuItem ifAbsent: [self errorNotFound: oldMenuItem].
	self itemAt: index put: newMenuItem!

setDefault: index
	"Set the item of the receiver with the specified 1-based <integer> index
	to be the default item. If the index is zero, then the menu has no default."

	UserLibrary default
		setMenuDefaultItem: self handle uItem: index - 1
		fByPos: TRUE!

setItem: anInteger info: aMENUITEMINFO 
	"Private - Set state and type information for the item of the receiver with specified
	<integer> index. This can control features such as whether the item is enabled or disabled,
	checked or unchecked (and if checked whether check-box or radio button style), command
	string, bitmap, etc. Answer whether the call succeeded."

	^UserLibrary default 
		setMenuItemInfo: self handle
		uItem: anInteger - 1
		fByPosition: true
		lpmii: aMENUITEMINFO!

showIn: aView position: aPos
	"Show top level of context menu on screen at position aPos."

	^UserLibrary default
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

typeFlags
	"Private - Answer the MENUITEMINFO style flags of the receiver (see
	Win32 SDK docs for fType field)."

	^0!

updateItem: indexInteger id: idInteger text: newText 
	"Private - Update the text of the menu item with the 1-based <integer> position, indexInteger, 
	within the receiver to the <readableString>, newText."

	UserLibrary default 
		modifyMenu: self handle 
		uPosition: indexInteger - 1
		uFlags: ##(MF_BYPOSITION | MFT_STRING)
		uIDNewItem: idInteger
		lpNewItem: newText! !

!Menu categoriesForMethods!
acceleratorKey!accessing!public! !
addCommand:description:!adding!public! !
addCommand:description:image:!adding!public! !
addCommandDescription:!adding!public! !
addItem:!adding!public! !
addSeparator!adding!public! !
addSubmenu:!adding!public! !
allItems!public! !
allMenus!public! !
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
isRadioButtonStyle!public! !
itemAt:!accessing!public! !
itemAt:put:!accessing!public! !
items!accessing!public! !
items:!accessing!public! !
itemsDo:!enumerating!public! !
itemWithId:!accessing!public! !
menuFromHandle:!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
notEmpty!public!testing! !
onDrawItem:!event handling-win32!private! !
postCopy!copying!public! !
printOn:!printing!public! !
queryAllAlong:!operations!public! !
queryAllFromView:!operations!private! !
queryAlong:!operations!public! !
registerAcceleratorKeyIn:!adding!public! !
removeItem:!public!removing! !
removeItemAt:!public!removing! !
replaceItem:with:!public!replacing! !
setDefault:!accessing!public! !
setItem:info:!accessing!private! !
showIn:position:!drawing!public! !
size!accessing!public! !
styleFlags!private!realizing/unrealizing! !
text!accessing!public! !
text:!accessing!public! !
typeFlags!private!realizing/unrealizing! !
updateItem:id:text:!accessing!private! !
!

Menu methodProtocol: #commandSource attributes: #(#readOnly) selectors: #(#commandDescription)!
Menu methodProtocol: #menuItem attributes: #(#readOnly) selectors: #(#acceleratorKey #command #hasSubmenu #id #image #insertIntoMenu:at:info: #items #menuFromHandle: #queryAlong: #registerAcceleratorKeyIn: #text)!

!Menu class methodsFor!

description: text
	"Answer a new instance of the receiver with the specified menu text."

	^self new
		text: text;
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
	View registerMessageMappings: self menuMessageMappings!

menuMessageMappings
	^{WM_CONTEXTMENU -> #wmContextMenu:wParam:lParam:.
		WM_INITMENU -> #wmInitMenu:wParam:lParam:.
		WM_INITMENUPOPUP -> #wmInitMenuPopup:wParam:lParam:}!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier Menu versions."
	^
	[:data | 
	| converted ver newInstance |
	converted := data.
	ver := anSTBClassFormat version.
	ver < 1 ifTrue: [converted := self stbConvertToVersion1: converted].
	ver < 2 ifTrue: [converted := self stbConvertToVersion2: converted].
	ver < 3 ifTrue: [converted := self stbConvertToVersion3: converted].
	ver < 4 ifTrue: ["No conversion needed - just adds inst vars"].
	newInstance := self basicNew.
	1 to: converted size
		do: [:i | newInstance instVarAt: i put: (converted at: i)].
	newInstance]!

stbConvertToVersion1: anArray 
	"Hmmm, what happened from version 1 to version 2?"

	^anArray!

stbConvertToVersion2: anArray 
	"Private - Version 2 adds 'name' instance variable, defaulting to nil."

	^anArray copyWith: nil!

stbConvertToVersion3: anArray 
	"Private - Version 3 adds flags, image, and bitmap instance variables.
	The flags must be zeroed, but the other two default to nil."

	| vars |
	self assert: [anArray size = 5].
	vars := (Array new: 8) 
				replaceFrom: 1
				to: anArray size
				with: anArray.
	vars at: 6 put: 0.
	^vars!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^4!

uninitialize
	View unregisterMessageMappings: {WM_CONTEXTMENU. WM_INITMENU. WM_INITMENUPOPUP}! !

!Menu class categoriesForMethods!
description:!instance creation!public! !
fromStrings:!instance creation!public! !
icon!constants!public! !
initialize!class initialization!development!public! !
menuMessageMappings!constants!must not strip!private! !
stbConvertFrom:!binary filing!public! !
stbConvertToVersion1:!binary filing!private! !
stbConvertToVersion2:!binary filing!private! !
stbConvertToVersion3:!binary filing!private! !
stbVersion!binary filing!public! !
uninitialize!class hierarchy-removing!private! !
!

