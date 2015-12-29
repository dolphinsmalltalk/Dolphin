"Filed out from Dolphin Smalltalk X6.2"!

ToolbarItem subclass: #ToolbarButton
	instanceVariableNames: 'bitmap bitmapIndex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ToolbarButton guid: (GUID fromString: '{87B4C700-026E-11D3-9FD7-00A0CC3E4A32}')!
ToolbarButton comment: 'ToolbarButton represents a user defined button for a <Toolbar>. The button is a <commandSource> capable of storing <CommandDescription>s to be fired when the button is pressed. Each button has an image which is identified by an index within a supplied <Bitmap>. The dimensions of the images within the bitmap are held by the parent <Toolbar> in its #bitmapExtent aspect.

Instance Variables:
	bitmap		<Bitmap> contain one or more button images.
	bitmapIndex	<integer> index of this button''s image within the bitmap.

Class Variables:
	StandardTools	<DIBSection> of standard tool images.


'!
!ToolbarButton categoriesForClass!MVP-Views-Support! !
!ToolbarButton methodsFor!

bitmap
	"Answer the bitmap for the receiver."

	^bitmap!

bitmap: aBitmap
	"Set aBitmap (or a shared copy of it) as the bitmap for the receiver."

	bitmap := aBitmap asSharedCopy.
	"We always want toolbar button bitmaps to do colour mapping or they look nasty, especially under Win2K."
	bitmap setMap3DColors: true.
	self update!

bitmap: aBitmap index: anInteger commandDescription: aCommandDescription

	"Private - Initialize the instance variables of the receiver."

	bitmap := aBitmap.
	bitmapIndex := anInteger.
	commandDescription := aCommandDescription.
	self isCheckStyle: false!

bitmapIndex
	"Answer the index of receivers sub-bitmap within its bitmap."

	^bitmapIndex!

bitmapIndex: anInteger
	"Set the index of receivers sub-bitmap within its bitmap to anInteger."

	bitmapIndex := anInteger.
	self update
!

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

getCommandId
	"Private - Determine and answer the Integer command identifier for the receiver"

	commandId := self commandDescription id.
	^commandId!

imageIndexIn: aToolbar
	"Private - Add the bitmap for the receiver to aToolbar.
	Answer the index of the bitmap within aToolbar's registered bitmaps"

	^aToolbar addBitmap: self bitmap index: self bitmapIndex
!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	self style: BTNS_BUTTON
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
!ToolbarButton categoriesFor: #bitmap!accessing!public! !
!ToolbarButton categoriesFor: #bitmap:!accessing!public! !
!ToolbarButton categoriesFor: #bitmap:index:commandDescription:!initializing!private! !
!ToolbarButton categoriesFor: #bitmapIndex!accessing!public! !
!ToolbarButton categoriesFor: #bitmapIndex:!accessing!public! !
!ToolbarButton categoriesFor: #command!commands!public! !
!ToolbarButton categoriesFor: #command:!accessing!public! !
!ToolbarButton categoriesFor: #commandDescription!accessing!public! !
!ToolbarButton categoriesFor: #commandDescription:!accessing!public! !
!ToolbarButton categoriesFor: #commandId!commands!private! !
!ToolbarButton categoriesFor: #getCommandId!commands!private! !
!ToolbarButton categoriesFor: #imageIndexIn:!operations!private! !
!ToolbarButton categoriesFor: #initialize!initializing!private! !
!ToolbarButton categoriesFor: #isChecked!public!testing! !
!ToolbarButton categoriesFor: #isChecked:!public!state! !
!ToolbarButton categoriesFor: #isCheckStyle!public!style! !
!ToolbarButton categoriesFor: #isCheckStyle:!public!style! !
!ToolbarButton categoriesFor: #isDropDownOnly!public!style! !
!ToolbarButton categoriesFor: #isDropDownOnly:!public!style! !
!ToolbarButton categoriesFor: #isDropdownStyle!public!style! !
!ToolbarButton categoriesFor: #isDropdownStyle:!public!style! !
!ToolbarButton categoriesFor: #isEnabled!public!testing! !
!ToolbarButton categoriesFor: #isEnabled:!public!state! !
!ToolbarButton categoriesFor: #isGroupStyle!public!style! !
!ToolbarButton categoriesFor: #isGroupStyle:!public!style! !
!ToolbarButton categoriesFor: #isHidden!public!testing! !
!ToolbarButton categoriesFor: #isHidden:!public!state! !
!ToolbarButton categoriesFor: #isIndeterminate!public!testing! !
!ToolbarButton categoriesFor: #isIndeterminate:!public!state! !
!ToolbarButton categoriesFor: #isPressed!public!testing! !
!ToolbarButton categoriesFor: #isPressed:!public!state! !
!ToolbarButton categoriesFor: #onTipTextRequired!event handling!public! !
!ToolbarButton categoriesFor: #printOn:!development!printing!public! !
!ToolbarButton categoriesFor: #rectangle!accessing!public! !
!ToolbarButton categoriesFor: #screenRectangle!accessing!public! !
!ToolbarButton categoriesFor: #stateMask:!public!state! !
!ToolbarButton categoriesFor: #text!accessing!public! !
!ToolbarButton categoriesFor: #text:!accessing!public! !
!ToolbarButton categoriesFor: #textIndexIn:!operations!private! !
!ToolbarButton categoriesFor: #toolTipText!operations!public! !
!ToolbarButton categoriesFor: #validateUserInterface:!operations!public! !

ToolbarButton methodProtocol: #commandSource attributes: #(#readOnly) selectors: #(#commandDescription)!

!ToolbarButton class methodsFor!

bitmap: aBitmap index: bitmapIndex commandDescription: aCommandDescription
	"Answer a new instance of the receiver containing the bitmapIndex'd subimage of aBitmap."

	^super new
		bitmap: aBitmap
		index: bitmapIndex
		commandDescription: aCommandDescription!

clearSelection
	"Answer a sub-instance of the receiver for the #clearSelection command"

	^self standardImage: STD_DELETE command: #clearSelection description: 'Delete'!

copySelection
	"Answer a sub-instance of the receiver for the #copySelection command"

	^self standardImage: STD_COPY command: #copySelection description: 'Copy'!

cutSelection
	"Answer a sub-instance of the receiver for the #cutSelection command"

	^self standardImage: STD_CUT command: #cutSelection description: 'Cut'!

dolphinImage: bitmapIndex command: aCommand description: aString
	"Private - Answer a new instance of the receiver using a Dolphin system toolbar bitmap
	identified by bitmapName and issuing aCommand"

	^self 	bitmap: self dolphinToolsBitmap
		index: bitmapIndex 
		commandDescription: (CommandDescription command: aCommand description: aString)!

dolphinToolsBitmap
	"Private - Answer the bitmap for the internal Dolphin tool button images"

	^(Bitmap fromId: 'Tools.bmp') isShared: true!

fileNew
	"Answer a sub-instance of the receiver for the #fileNew command"

	^self standardImage: STD_FILENEW command: #fileNew description: 'New'!

fileOpen
	"Answer a sub-instance of the receiver for the #fileOpen command"

	^self standardImage: STD_FILEOPEN command: #fileOpen description: 'Open'!

fileSave
	"Answer a sub-instance of the receiver for the #fileSave command"

	^self  standardImage: STD_FILESAVE command: #fileSave description: 'Save'!

find
	"Answer a sub-instance of the receiver for the #find command"

	"The standard find tool  is rather poor, and nobody uses it, so rather than:
	^self standardImage: STD_FIND command: #find description: 'Find'"

	^self 
		bitmap: self findToolsBitmap
		index: 0
		commandDescription: (CommandDescription command: #find description: 'Find')!

findNext
	"Answer a sub-instance of the receiver for the #findNext command"

	^self 
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
		bitmap: IDB_HIST_SMALL_COLOR 
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

	^self viewImage: VIEW_LARGEICONS command: #largeIconMode description: 'Large Icons'!

listMode
	"Answer a sub-instance of the receiver for the #listStyle command"

	^self viewImage: VIEW_LIST command: #listMode description: 'View List'!

listToolsBitmap
	"Note that the list tools (like the find tools) are pulled from resources located in the VM/executable,
	rather than development resources, to avoid the need for the user to ship the development
	resources DLL just because the find or list toolbars are used.
	Note that the bitmap is shared, and should not be modified."

	^(Bitmap fromId: 'LISTBAR.BMP' in: VMLibrary default)
		setMap3DColors: true;
		isShared: true;
		yourself!

new
	"Answer a new default ToolbarButton"

	^self dolphinImage: 35 command: #noCommand description: 'No command'!

newFolder
	"Answer a sub-instance of the receiver for the #newFolder command"

	^self viewImage: VIEW_NEWFOLDER command: #newFolder description: 'Create New Folder'!

parentFolder
	"Answer a sub-instance of the receiver for the #parentFolder command"

	^self viewImage: VIEW_PARENTFOLDER command: #parentFolder description: 'Up One Level'!

pasteClipboard
	"Answer a sub-instance of the receiver for the #pasteClipboard command"

	^self standardImage: STD_PASTE command: #pasteClipboard description: 'Paste'!

print
	"Answer a sub-instance of the receiver for the #print command"

	^self standardImage: STD_PRINT command: #print description: 'Print'!

properties
	"Answer a sub-instance of the receiver for the #properties command"

	^self standardImage: STD_PROPERTIES command: #properties description: 'Properties'!

redo
	"Answer a sub-instance of the receiver for the #redo command"

	^self standardImage: STD_REDOW command: #redo description: 'Redo'!

replace
	"Answer a sub-instance of the receiver for the #replace command"

	^self standardImage: STD_REPLACE command: #replace description: 'Replace'!

reportMode
	"Answer a sub-instance of the receiver for the #reportStyle command"

	^self viewImage: VIEW_DETAILS command: #reportMode description: 'View Details'!

smallIconMode
	"Answer a sub-instance of the receiver for the #smallIcons command"

	^self viewImage: VIEW_SMALLICONS command: #smallIconMode description: 'Small Icons'!

sortDate
	"Answer a sub-instance of the receiver for the #sortDate command"

	^self viewImage: VIEW_SORTDATE command: #sortDate description: 'Sort by Date'!

sortName
	"Answer a sub-instance of the receiver for the #sortName command"

	^self viewImage: VIEW_SORTNAME command: #sortName description: 'Sort by Name'!

sortSize
	"Answer a sub-instance of the receiver for the #sortSize command"

	^self viewImage: VIEW_SORTSIZE command: #sortSize description: 'Sort by Size'!

sortType
	"Answer a sub-instance of the receiver for the #sortType command"

	^self viewImage: VIEW_SORTTYPE command: #sortType description: 'Sort by Type'!

standardImage: bitmapIndex command: aCommand description: aString
	"Private - Answer a new instance of the receiver using a Standard system toolbar bitmap
	identified by bitmapName and issuing aCommand"

	^self systemButtonClass 
		bitmap: IDB_STD_SMALL_COLOR 
		index: bitmapIndex 
		commandDescription: (CommandDescription command: aCommand description: aString)!

systemButtonClass
	"Answer the subclass of the receiver which implements system toolbar buttons."

	^ToolbarSystemButton!

undo
	"Answer a sub-instance of the receiver for the #undo command"

	^self standardImage: STD_UNDO command: #undo description: 'Undo'!

viewImage: bitmapIndex command: aCommand description: aString
	"Private - Answer a new instance of the receiver using a system View toolbar bitmap
	identified by bitmapName and issuing aCommand"

	^self systemButtonClass 
		bitmap: IDB_VIEW_SMALL_COLOR 
		index: bitmapIndex
		commandDescription: (CommandDescription command: aCommand description: aString)! !
!ToolbarButton class categoriesFor: #bitmap:index:commandDescription:!instance creation!public! !
!ToolbarButton class categoriesFor: #clearSelection!instance creation!public! !
!ToolbarButton class categoriesFor: #copySelection!instance creation!public! !
!ToolbarButton class categoriesFor: #cutSelection!instance creation!public! !
!ToolbarButton class categoriesFor: #dolphinImage:command:description:!instance creation!private! !
!ToolbarButton class categoriesFor: #dolphinToolsBitmap!instance creation!private! !
!ToolbarButton class categoriesFor: #fileNew!instance creation!public! !
!ToolbarButton class categoriesFor: #fileOpen!instance creation!public! !
!ToolbarButton class categoriesFor: #fileSave!instance creation!public! !
!ToolbarButton class categoriesFor: #find!instance creation!public! !
!ToolbarButton class categoriesFor: #findNext!instance creation!public! !
!ToolbarButton class categoriesFor: #findToolsBitmap!constants!public! !
!ToolbarButton class categoriesFor: #histImage:command:description:!instance creation!private! !
!ToolbarButton class categoriesFor: #historyBack!instance creation!public! !
!ToolbarButton class categoriesFor: #historyForward!instance creation!public! !
!ToolbarButton class categoriesFor: #icon!public! !
!ToolbarButton class categoriesFor: #largeIconMode!instance creation!public! !
!ToolbarButton class categoriesFor: #listMode!instance creation!public! !
!ToolbarButton class categoriesFor: #listToolsBitmap!constants!public! !
!ToolbarButton class categoriesFor: #new!instance creation!public! !
!ToolbarButton class categoriesFor: #newFolder!instance creation!public! !
!ToolbarButton class categoriesFor: #parentFolder!instance creation!public! !
!ToolbarButton class categoriesFor: #pasteClipboard!instance creation!public! !
!ToolbarButton class categoriesFor: #print!instance creation!public! !
!ToolbarButton class categoriesFor: #properties!instance creation!public! !
!ToolbarButton class categoriesFor: #redo!instance creation!public! !
!ToolbarButton class categoriesFor: #replace!instance creation!public! !
!ToolbarButton class categoriesFor: #reportMode!instance creation!public! !
!ToolbarButton class categoriesFor: #smallIconMode!instance creation!public! !
!ToolbarButton class categoriesFor: #sortDate!instance creation!public! !
!ToolbarButton class categoriesFor: #sortName!instance creation!public! !
!ToolbarButton class categoriesFor: #sortSize!instance creation!public! !
!ToolbarButton class categoriesFor: #sortType!instance creation!public! !
!ToolbarButton class categoriesFor: #standardImage:command:description:!instance creation!private! !
!ToolbarButton class categoriesFor: #systemButtonClass!constants!instance creation!public! !
!ToolbarButton class categoriesFor: #undo!instance creation!public! !
!ToolbarButton class categoriesFor: #viewImage:command:description:!instance creation!private! !

