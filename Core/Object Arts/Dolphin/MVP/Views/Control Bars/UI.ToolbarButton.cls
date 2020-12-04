"Filed out from Dolphin Smalltalk 7"!

UI.ToolbarItem subclass: #'UI.ToolbarButton'
	instanceVariableNames: 'style commandDescription commandId'
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
	^(query canPerform and: [query receiver respondsTo: #onTipTextRequired:]) 
		ifTrue: [query receiver onTipTextRequired: self]
		ifFalse: [self toolTipText]
		!

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
	mask := 0.
	query isEnabled ifTrue: [mask := mask bitOr: TBSTATE_ENABLED].
	query isChecked ifTrue: [mask := mask bitOr: ##(TBSTATE_CHECKED|TBSTATE_PRESSED)].
	self stateMask: mask! !
!UI.ToolbarButton categoriesFor: #checked!public!testing! !
!UI.ToolbarButton categoriesFor: #checked:!public!state! !
!UI.ToolbarButton categoriesFor: #command!commands!public! !
!UI.ToolbarButton categoriesFor: #command:!accessing!public! !
!UI.ToolbarButton categoriesFor: #commandDescription!accessing!public! !
!UI.ToolbarButton categoriesFor: #commandDescription:!accessing!public! !
!UI.ToolbarButton categoriesFor: #commandId!commands!private! !
!UI.ToolbarButton categoriesFor: #enabled!public!testing! !
!UI.ToolbarButton categoriesFor: #enabled:!public!state! !
!UI.ToolbarButton categoriesFor: #getCommandId!commands!private! !
!UI.ToolbarButton categoriesFor: #hide:!public!state! !
!UI.ToolbarButton categoriesFor: #indeterminate:!public!state! !
!UI.ToolbarButton categoriesFor: #initialize!initializing!private! !
!UI.ToolbarButton categoriesFor: #isChecked!public!testing! !
!UI.ToolbarButton categoriesFor: #isChecked:!public!state! !
!UI.ToolbarButton categoriesFor: #isCheckStyle!public!style! !
!UI.ToolbarButton categoriesFor: #isCheckStyle:!public!style! !
!UI.ToolbarButton categoriesFor: #isDropDownOnly!public!style! !
!UI.ToolbarButton categoriesFor: #isDropDownOnly:!public!style! !
!UI.ToolbarButton categoriesFor: #isDropdownStyle!public!style! !
!UI.ToolbarButton categoriesFor: #isDropdownStyle:!public!style! !
!UI.ToolbarButton categoriesFor: #isEnabled!public!testing! !
!UI.ToolbarButton categoriesFor: #isEnabled:!public!state! !
!UI.ToolbarButton categoriesFor: #isGroupStyle!public!style! !
!UI.ToolbarButton categoriesFor: #isGroupStyle:!public!style! !
!UI.ToolbarButton categoriesFor: #isHidden!public!testing! !
!UI.ToolbarButton categoriesFor: #isHidden:!public!state! !
!UI.ToolbarButton categoriesFor: #isIndeterminate!public!testing! !
!UI.ToolbarButton categoriesFor: #isIndeterminate:!public!state! !
!UI.ToolbarButton categoriesFor: #isPressed!public!testing! !
!UI.ToolbarButton categoriesFor: #isPressed:!public!state! !
!UI.ToolbarButton categoriesFor: #onTipTextRequired!event handling!public! !
!UI.ToolbarButton categoriesFor: #pressed!public!testing! !
!UI.ToolbarButton categoriesFor: #pressed:!public!state! !
!UI.ToolbarButton categoriesFor: #printOn:!development!printing!public! !
!UI.ToolbarButton categoriesFor: #rectangle!accessing!public! !
!UI.ToolbarButton categoriesFor: #screenRectangle!accessing!public! !
!UI.ToolbarButton categoriesFor: #stateMask:!public!state! !
!UI.ToolbarButton categoriesFor: #style!private!style! !
!UI.ToolbarButton categoriesFor: #style:!private!style! !
!UI.ToolbarButton categoriesFor: #text!accessing!public! !
!UI.ToolbarButton categoriesFor: #text:!accessing!public! !
!UI.ToolbarButton categoriesFor: #textIndexIn:!operations!private! !
!UI.ToolbarButton categoriesFor: #toolTipText!operations!public! !
!UI.ToolbarButton categoriesFor: #validateUserInterface:!operations!public! !

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

	"The standard find tool  is rather poor, and nobody uses it, so rather than:
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

	^(Bitmap fromId: 'FINDBAR.BMP' in: VMLibrary default)
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

	^(Bitmap fromId: 'LISTBAR.BMP' in: VMLibrary default)
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
	"Version 0 inst var layout was:
		ToolbarItem
			1: commandId
			2: unused
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

	^
	[:data |
	| newInstance |
	newInstance := self bitmapButtonClass basicNew.
	1 to: 3 do: [:i | newInstance instVarAt: i put: (data at: i + 2)].
	newInstance instVarAt: 4 put: (data at: 1).
	5 to: 6 do: [:i | newInstance instVarAt: i put: (data at: i + 1)].
	newInstance]!

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
!UI.ToolbarButton class categoriesFor: #bitmapButtonClass!constants!instance creation!public! !
!UI.ToolbarButton class categoriesFor: #clearSelection!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #copySelection!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #cutSelection!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #dolphinImage:command:description:!instance creation!private! !
!UI.ToolbarButton class categoriesFor: #dolphinToolsBitmap!instance creation!private! !
!UI.ToolbarButton class categoriesFor: #fileNew!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #fileOpen!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #fileSave!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #find!instance creation!public! !
!UI.ToolbarButton class categoriesFor: #findNext!instance creation!public! !
!UI.ToolbarButton class categoriesFor: #findToolsBitmap!constants!public! !
!UI.ToolbarButton class categoriesFor: #histImage:command:description:!instance creation-system buttons!private! !
!UI.ToolbarButton class categoriesFor: #historyBack!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #historyForward!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #icon!public! !
!UI.ToolbarButton class categoriesFor: #largeIconMode!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #listMode!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #listToolsBitmap!constants!public! !
!UI.ToolbarButton class categoriesFor: #newFolder!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #parentFolder!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #pasteClipboard!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #print!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #properties!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #redo!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #replace!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #reportMode!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #smallIconMode!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #sortDate!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #sortName!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #sortSize!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #sortType!instance creation-system buttons!public! !
!UI.ToolbarButton class categoriesFor: #stbConvertFrom:!binary filing!private! !
!UI.ToolbarButton class categoriesFor: #systemBitmap:image:command:description:!instance creation-system buttons!private! !
!UI.ToolbarButton class categoriesFor: #systemButtonClass!constants!instance creation!public! !
!UI.ToolbarButton class categoriesFor: #undo!instance creation!public! !

