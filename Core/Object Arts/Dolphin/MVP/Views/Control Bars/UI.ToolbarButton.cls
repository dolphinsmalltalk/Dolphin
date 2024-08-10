"Filed out from Dolphin Smalltalk"!

UI.ToolbarItem
	subclass: #'UI.ToolbarButton'
	instanceVariableNames: 'style commandDescription commandId textcolor font'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ToolbarButton guid: (Core.GUID fromString: '{5a6ae0df-57b0-4ba0-be4a-c1cd1ccc6def}')!

UI.ToolbarButton isNonInstantiable: true!

UI.ToolbarButton comment: '`ToolbarButton` is the abstract class of `Toolbar` buttons.  The button is a `<commandSource>` capable of storing `CommandDescription` to be fired when the button is pressed. Each button has an image, the provision of which is implemented by subclasses. The dimensions of the images within the bitmap are held by the containing `Toolbar` in its `#bitmapExtent` aspect.

## Instance Variables:
  `style`				`<integer>` representing the Window''s style of the item.
  `commandDescription`	`CommandDescription` or `nil`; the item''s command.  
  `commandId`			`<integer>`  ID of the item''s command (or zero if none).
'!

!UI.ToolbarButton categoriesForClass!MVP-Views-Support! !

!UI.ToolbarButton methodsFor!

checked
	#deprecated.
	^self isChecked!

checked: aBoolean
	#deprecated.
	self isChecked: aBoolean!

command
	"Answer the <commandMessage> for the receiver or nil if one has not been set."

	^self commandDescription command!

command: commandMessage
	"Sets the command associated with the receiver to the <commandMessage> argument."

	self commandDescription command: commandMessage!

commandDescription
	^commandDescription!

commandDescription: aCommandDescription
	commandDescription := aCommandDescription!

commandId
	"Private - Answer the Integer command identifier for the receiver"

	^commandId!

enabled
	#deprecated.
	^self isEnabled!

enabled: aBoolean
	#deprecated.
	self isEnabled: aBoolean!

font
	^font!

font: aFont
	font := aFont!

getCommandId
	"Private - Determine and answer the Integer command identifier for the receiver"

	commandId := self commandDescription id.
	^commandId!

hide: aBoolean
	#deprecated.
	self isHidden: aBoolean!

indeterminate: aBoolean
	#deprecated.
	self isIndeterminate: aBoolean!

initialize
	"Private - Initialize the state of the receiver."

	style := BTNS_BUTTON
!

isChecked
	^self toolbar tbIsButtonChecked: self commandId!

isChecked: aBoolean
	self toolbar tbCheckButton: self commandId state: aBoolean.

	"Most Microsoft app's also set the 'pressed' state too, and this does look better."
	self isPressed: aBoolean!

isCheckStyle
	"Answers true if the receiver is a check style button that toggles between pressed and
	unpressed states when clicked."

	^self style allMask: BTNS_CHECK!

isCheckStyle: aBoolean
	"Sets the receiver to be a check style button according to aBoolean"

	self style: (self style mask: BTNS_CHECK set: aBoolean)!

isDropDownOnly
	"Answers true if the receiver is a drop-down arrow ONLY (as opposed
	to both a push button and a drop-down)."

	^self style allMask: BTNS_WHOLEDROPDOWN!

isDropDownOnly: aBoolean
	"Set whether the receiver is a drop-down arrow ONLY (as opposed
	to both a push button and a drop-down)."

	self style: (self style mask: BTNS_DROPDOWN | BTNS_WHOLEDROPDOWN set: aBoolean)!

isDropdownStyle
	"Answers true if the receiver is a drop down style button"

	^self style allMask: BTNS_DROPDOWN!

isDropdownStyle: aBoolean
	"Sets the receiver to be a drop down style button according to aBoolean"

	self style: (self style mask: BTNS_DROPDOWN set: aBoolean)!

isEnabled
	"Answer whether the receiver is enabled."

	^self toolbar tbIsButtonEnabled: self commandId!

isEnabled: aBoolean
	self toolbar tbEnableButton: self commandId state: aBoolean!

isGroupStyle
	"Answers true if the receiver is a group button that will be reset if others in its group
	are pressed"

	^self style allMask: BTNS_GROUP!

isGroupStyle: aBoolean 
	"Sets the receiver to be a group style button according to aBoolean. A group button is like
	a radio button in that once pressed it remains pressed until another button in the group is
	pressed."

	self style: (self style mask: BTNS_GROUP set: aBoolean)!

isHidden
	^self toolbar tbIsButtonHidden: self commandId!

isHidden: aBoolean
	self toolbar tbHideButton: self commandId state: aBoolean!

isIndeterminate
	^self toolbar tbIsButtonIndeterminate: self commandId!

isIndeterminate: aBoolean
	self toolbar tbIndeterminate: self commandId state: aBoolean!

isPressed
	^self toolbar tbIsButtonPressed: self commandId!

isPressed: aBoolean
	self toolbar tbPressButton: self commandId state: aBoolean!

onTipTextRequired
	"Tool-tip text is required for the receiver. We give the first <commandTarget>
	on the command route which is prepared to accept the command the opportunity to
	dynamically supply the tip text, otherwise just use that associated with the receiver."

	| query |
	query := self parent queryCommandRouteFor: self commandDescription.
	^(query canPerform and: [query receiver respondsTo: #onTipTextRequired:query:])
		ifTrue: [query receiver onTipTextRequired: self query: query]
		ifFalse: [self toolTipText]!

pressed
	#deprecated.
	^self isPressed!

pressed: aBoolean
	#deprecated.
	self isPressed: aBoolean!

printOn: aStream
	"Append a representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; print: self command; nextPut: $)!

rectangle
	"Answer the receiver's bounding Rectangle in the parent coordinate system"

	^(self toolbar tbGetRect: self commandId) asRectangle!

screenRectangle
	"Answer the receiver's bounding Rectangle in the parent coordinate system"

	^self toolbar mapRectangle: self rectangle to: View desktop!

stateMask: stateMask
	"Set the TBSTATE_XXX flags of the receiver to the <integer> stateMask."

	self toolbar tbSetState: self commandId state: stateMask!

stbSaveOn: anSTxOutFiler
	| saved |
	"We don't want to save down the command id because it is unstable and needs to be reallocated when the toolbar is realized anyway"
	saved := commandId.
	commandId := nil.
	[super stbSaveOn: anSTxOutFiler] ensure: [commandId := saved]!

style
	"Private - Answer the style of the receiver."

	^style!

style: styleInteger
	"Private - Set the style of the receiver. "

	style := styleInteger.
	self update!

text
	"Answers a short String description of the receiver's command. Uses the String
	representation of the command itself if no explicit description has been
	provided"

	^self commandDescription description!

text: aString
	"Sets the String description of the receiver's command."

	^self commandDescription description: aString!

textcolor
	^textcolor!

textcolor: aColor
	textcolor := aColor!

textIndexIn: aToolbar
	"Private - Answer the text for the receiver to aToolbar and answer the
	index of this text"

	^aToolbar addString: self text!

toolTipText
	"Answer a String suitable for displaying in a Tool tip control."

	^self commandDescription toolTipText!

validateUserInterface: route
	"Set the enable/checked state of the receiver using the <commandRoute>, route."

	| query mask |
	query := route query: self commandDescription.
	"Set the state all at once to improve performance"
	mask := query isEnabled ifTrue: [TBSTATE_ENABLED] ifFalse: [0].
	query isChecked ifTrue: [mask := mask bitOr: ##(TBSTATE_CHECKED|TBSTATE_PRESSED)].
	self stateMask: mask! !

!UI.ToolbarButton categoriesForMethods!
checked!public!testing! !
checked:!public!state! !
command!commands!public! !
command:!accessing!public! !
commandDescription!accessing!public! !
commandDescription:!accessing!public! !
commandId!commands!private! !
enabled!public!testing! !
enabled:!public!state! !
font!accessing!public! !
font:!accessing!public! !
getCommandId!commands!private! !
hide:!public!state! !
indeterminate:!public!state! !
initialize!initializing!private! !
isChecked!public!testing! !
isChecked:!public!state! !
isCheckStyle!public!style! !
isCheckStyle:!public!style! !
isDropDownOnly!public!style! !
isDropDownOnly:!public!style! !
isDropdownStyle!public!style! !
isDropdownStyle:!public!style! !
isEnabled!public!testing! !
isEnabled:!public!state! !
isGroupStyle!public!style! !
isGroupStyle:!public!style! !
isHidden!public!testing! !
isHidden:!public!state! !
isIndeterminate!public!testing! !
isIndeterminate:!public!state! !
isPressed!public!testing! !
isPressed:!public!state! !
onTipTextRequired!event handling!public! !
pressed!public!testing! !
pressed:!public!state! !
printOn:!development!printing!public! !
rectangle!accessing!public! !
screenRectangle!accessing!public! !
stateMask:!public!state! !
stbSaveOn:!binary filing!public! !
style!private!style! !
style:!private!style! !
text!accessing!public! !
text:!accessing!public! !
textcolor!accessing!public! !
textcolor:!accessing!public! !
textIndexIn:!operations!private! !
toolTipText!operations!public! !
validateUserInterface:!operations!public! !
!

!UI.ToolbarButton class methodsFor!

bitmapButtonClass
	"Answer the subclass of the receiver which is used to represent buttons with images from arbitrary bitmaps."

	^ToolbarBitmapButton!

clearSelection
	"Answer a sub-instance of the receiver for the #clearSelection command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_DELETE
		command: #clearSelection
		description: 'Delete'!

copySelection
	"Answer a sub-instance of the receiver for the #copySelection command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_COPY
		command: #copySelection
		description: 'Copy'!

cutSelection
	"Answer a sub-instance of the receiver for the #cutSelection command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_CUT
		command: #cutSelection
		description: 'Cut'!

dolphinImage: bitmapIndex command: aCommand description: aString
	"Private - Answer a new instance of the receiver using a Dolphin system toolbar bitmap
	identified by bitmapName and issuing aCommand"

	^self bitmapButtonClass
		bitmap: self dolphinToolsBitmap
		index: bitmapIndex
		commandDescription: (CommandDescription command: aCommand description: aString)!

dolphinToolsBitmap
	"Private - Answer the bitmap for the internal Dolphin tool button images"

	^(Bitmap fromId: 'Tools.bmp') isShared: true!

fileNew
	"Answer a sub-instance of the receiver for the #fileNew command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_FILENEW
		command: #fileNew
		description: 'New'!

fileOpen
	"Answer a sub-instance of the receiver for the #fileOpen command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_FILEOPEN
		command: #fileOpen
		description: 'Open'!

fileSave
	"Answer a sub-instance of the receiver for the #fileSave command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_FILESAVE
		command: #fileSave
		description: 'Save'!

find
	"Answer a sub-instance of the receiver for the #find command"

	"The standard find tool is rather poor, and nobody uses it, so rather than:
	^self standardImage: STD_FIND command: #find description: 'Find'"

	^self bitmapButtonClass
		bitmap: self findToolsBitmap
		index: 0
		commandDescription: (CommandDescription command: #find description: 'Find')!

findNext
	"Answer a sub-instance of the receiver for the #findNext command"

	^self bitmapButtonClass
		bitmap: self findToolsBitmap
		index: 1
		commandDescription: (CommandDescription command: #findNext description: 'Find Next')!

findToolsBitmap
	"Note that the find tools (like the list tools) are pulled from resources located in the VM/executable,
	rather than development resources, to avoid the need for the user to ship the development
	resources DLL just because the find or list toolbars are used.
	Note that the bitmap is shared, and should not be modified."

	^(Bitmap fromId: 'FINDBAR.BMP' in: VM)
		setMap3DColors: true;
		isShared: true;
		yourself!

histImage: bitmapIndex command: aCommand description: aString
	"Private - Answer a new instance of the receiver using the standard system History
	toolbar bitmap identified by bitmapName and issuing aCommand"

	^self systemButtonClass
		bitmapId: IDB_HIST_SMALL_COLOR
		index: bitmapIndex
		commandDescription: (CommandDescription command: aCommand description: aString)!

historyBack
	"Answer a sub-instance of the receiver for the #historyBack command"

	^(self histImage: HIST_BACK command: #historyBack description: 'Back')
		isDropdownStyle: true;
		yourself!

historyForward
	"Answer a sub-instance of the receiver for the #historyForward command"

	^(self histImage: HIST_FORWARD command: #historyForward description: 'Forward')
		isDropdownStyle: true;
		yourself!

icon
	^PushButton icon!

largeIconMode
	"Answer a sub-instance of the receiver for the #largeIcons command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_LARGEICONS
		command: #largeIconMode
		description: 'Large Icons'!

listMode
	"Answer a sub-instance of the receiver for the #listStyle command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_LIST
		command: #listMode
		description: 'View List'!

listToolsBitmap
	"Note that the list tools (like the find tools) are pulled from resources located in the VM/executable,
	rather than development resources, to avoid the need for the user to ship the development
	resources DLL just because the find or list toolbars are used.
	Note that the bitmap is shared, and should not be modified."

	^(Bitmap fromId: 'LISTBAR.BMP' in: VM)
		setMap3DColors: true;
		isShared: true;
		yourself!

newFolder
	"Answer a sub-instance of the receiver for the #newFolder command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_NEWFOLDER
		command: #newFolder
		description: 'Create New Folder'!

parentFolder
	"Answer a sub-instance of the receiver for the #parentFolder command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_PARENTFOLDER
		command: #parentFolder
		description: 'Up One Level'!

pasteClipboard
	"Answer a sub-instance of the receiver for the #pasteClipboard command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_PASTE
		command: #pasteClipboard
		description: 'Paste'!

print
	"Answer a sub-instance of the receiver for the #print command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_PRINT
		command: #print
		description: 'Print'!

properties
	"Answer a sub-instance of the receiver for the #properties command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_PROPERTIES
		command: #properties
		description: 'Properties'!

redo
	"Answer a sub-instance of the receiver for the #redo command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_REDOW
		command: #redo
		description: 'Redo'!

replace
	"Answer a sub-instance of the receiver for the #replace command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_REPLACE
		command: #replace
		description: 'Replace'!

reportMode
	"Answer a sub-instance of the receiver for the #reportStyle command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_DETAILS
		command: #reportMode
		description: 'View Details'!

smallIconMode
	"Answer a sub-instance of the receiver for the #smallIcons command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_SMALLICONS
		command: #smallIconMode
		description: 'Small Icons'!

sortDate
	"Answer a sub-instance of the receiver for the #sortDate command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_SORTDATE
		command: #sortDate
		description: 'Sort by Date'!

sortName
	"Answer a sub-instance of the receiver for the #sortName command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_SORTNAME
		command: #sortName
		description: 'Sort by Name'!

sortSize
	"Answer a sub-instance of the receiver for the #sortSize command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_SORTSIZE
		command: #sortSize
		description: 'Sort by Size'!

sortType
	"Answer a sub-instance of the receiver for the #sortType command"

	^self
		systemBitmap: IDB_VIEW_SMALL_COLOR
		image: VIEW_SORTTYPE
		command: #sortType
		description: 'Sort by Type'!

stbConvertFrom: anSTBClassFormat
	anSTBClassFormat version == 0
		ifTrue: 
			[^
			[:data |
			"Need to remap former concrete ToolbarButtons to ToolbarBitmapButtons."
			(self stbConvertFromVersion0: data) becomeA: ToolbarBitmapButton]].
	anSTBClassFormat version == 1
		ifTrue: [^[:data | (self stbConvertFromVersion1: data) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersion0: anArray
	"Version 0 inst var layout was:
		ToolbarItem
			1: commandId
			2: text (unused)
			3: window (toolbar)
			4: style
			5: commandDescription
		ToolbarButton (which was concrete, and equivalent to ToolbarBitmapButton)
			6: bitmap
			7: bitmapIndex

	Version 1 inst var layout for ToolbarBitmapButton is:
		ToolbarItem
			1: toolbar
		ToolbarButton
			2: style
			3: commandDescription
			4: commandId
		ToolbarBitmapButton
			5: bitmap
			6: bitmapIndex
	"

	^{ anArray at: 3. anArray at: 4. anArray at: 5. anArray at: 1. nil. nil. anArray at: 6. anArray at: 7 }!

stbConvertFromVersion1: anArray
	"Version 2 adds textcolor and font"

	| count |
	count := anArray size + 2.
	^(Array new: count)
		replaceFrom: 1
			to: 4
			with: anArray
			startingAt: 1;
		replaceFrom: 7
			to: count
			with: anArray
			startingAt: 5;
		yourself!

stbVersion
	^2!

systemBitmap: anInteger image: bitmapIndex command: aCommand description: aString
	^self systemButtonClass
		bitmapId: anInteger
		index: bitmapIndex
		commandDescription: (CommandDescription command: aCommand description: aString)!

systemButtonClass
	"Answer the subclass of the receiver which implements system toolbar buttons."

	^ToolbarSystemButton!

undo
	"Answer a sub-instance of the receiver for the #undo command"

	^self
		systemBitmap: IDB_STD_SMALL_COLOR
		image: STD_UNDO
		command: #undo
		description: 'Undo'! !

!UI.ToolbarButton class categoriesForMethods!
bitmapButtonClass!constants!instance creation!public! !
clearSelection!instance creation-system buttons!public! !
copySelection!instance creation-system buttons!public! !
cutSelection!instance creation-system buttons!public! !
dolphinImage:command:description:!instance creation!private! !
dolphinToolsBitmap!instance creation!private! !
fileNew!instance creation-system buttons!public! !
fileOpen!instance creation-system buttons!public! !
fileSave!instance creation-system buttons!public! !
find!instance creation!public! !
findNext!instance creation!public! !
findToolsBitmap!constants!public! !
histImage:command:description:!instance creation-system buttons!private! !
historyBack!instance creation-system buttons!public! !
historyForward!instance creation-system buttons!public! !
icon!public! !
largeIconMode!instance creation-system buttons!public! !
listMode!instance creation-system buttons!public! !
listToolsBitmap!constants!public! !
newFolder!instance creation-system buttons!public! !
parentFolder!instance creation-system buttons!public! !
pasteClipboard!instance creation-system buttons!public! !
print!instance creation-system buttons!public! !
properties!instance creation-system buttons!public! !
redo!instance creation-system buttons!public! !
replace!instance creation-system buttons!public! !
reportMode!instance creation-system buttons!public! !
smallIconMode!instance creation-system buttons!public! !
sortDate!instance creation-system buttons!public! !
sortName!instance creation-system buttons!public! !
sortSize!instance creation-system buttons!public! !
sortType!instance creation-system buttons!public! !
stbConvertFrom:!binary filing!private! !
stbConvertFromVersion0:!binary filing!private! !
stbConvertFromVersion1:!binary filing!private! !
stbVersion!public! !
systemBitmap:image:command:description:!instance creation-system buttons!private! !
systemButtonClass!constants!instance creation!public! !
undo!instance creation!public! !
!

