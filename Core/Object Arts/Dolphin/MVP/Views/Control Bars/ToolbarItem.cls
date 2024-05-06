"Filed out from Dolphin Smalltalk"!

Object subclass: #ToolbarItem
	instanceVariableNames: 'toolbar'
	classVariableNames: ''
	poolDictionaries: 'ToolbarConstants'
	classInstanceVariableNames: ''!

ToolbarItem guid: (GUID fromString: '{87b4c4c6-026e-11d3-9fd7-00a0cc3e4a32}')!

ToolbarItem isAbstract: true!

ToolbarItem comment: '`ToolbarItem` is an abstract class whose subclasses represent the items held by a `Toolbar`.

## Instance Variables:
  `toolbar`		`Toolbar`

'!

!ToolbarItem categoriesForClass!MVP-Views-Support! !

!ToolbarItem methodsFor!

commandId
	"Private - Answer the Integer command identifier for the receiver"

	^0
!

getCommandId
	"Private - Determine and answer the Integer command identifier for the receiver."

	^0!

imageIndexIn: aWindow
	"Private - Answer the index of the bitmap from aWindows registered bitmaps
	which will be used for the receiver on the toolbar." 

	^self subclassResponsibility!

isDivider
	"Answer whether the receiver is a toolbar separator (similar in function to a menu divider item)."

	^false!

isDropdownStyle
	"Answers true if the receiver is a drop down style button"

	^false!

onClick: aPoint 
	"This toolbar item was left-clicked at the specified <Point>."

	self trigger: #clicked: with: aPoint!

onDoubleClick: aPoint 
	"This item was left double-clicked at the specified <Point>.
	Note that we don't seem to receive these at present."

	self trigger: #doubleClicked: with: aPoint!

onRightClick: aPoint 
	"This toolbar item was right-clicked at the specified <Point>."

	self trigger: #rightClicked: with: aPoint!

parent
	"Answer the parent view of the receiver."

	^self toolbar view!

style
	"Private - Answer the style of the receiver."

	^self subclassResponsibility!

textIndexIn: aToolbar
	"Private - Answer the index of the text which will be shown on the toolbar for the
	receiver."

	^self subclassResponsibility!

toolbar
	"Private - Answer the ToolBar in which the receiver exists."

	^toolbar!

toolbar: aToolbar
	"Private - Set the toolbar in which the receiver exists to aToolbar."

	toolbar := aToolbar!

update
	"Private - Update the associated Toolbar if we have one"

	self toolbar notNil ifTrue: [
		self toolbar updateAllItems  ]!

validateUserInterface: route
	"Set the UI state of the receiver. Overridden in subclasses"! !

!ToolbarItem categoriesForMethods!
commandId!commands!private! !
getCommandId!commands!private! !
imageIndexIn:!operations!private! !
isDivider!public!testing! !
isDropdownStyle!public!style! !
onClick:!event handling!public! !
onDoubleClick:!event handling!public! !
onRightClick:!event handling!public! !
parent!operations!public! !
style!private!style! !
textIndexIn:!operations!private! !
toolbar!accessing!private! !
toolbar:!accessing!private! !
update!accessing!private! !
validateUserInterface:!operations!public! !
!

!ToolbarItem class methodsFor!

buttonClass
	"Answer the subclass used to represent Toolbar buttons."

	^ToolbarButton!

editTools
	"Answer a collection of items which are the standard file tools (e.g. new, open, save)
	in the standard order."

	| bc |
	bc := self buttonClass.
	^(OrderedCollection new) 
		add: bc cutSelection;
		add: bc copySelection;
		add: bc pasteClipboard;
		add: bc clearSelection;
		add: bc undo;
		yourself.

	#todo "Is it necessary to create a new ToolbarButton each time, or can we share them?"!

fileTools
	"Answer a collection of items which are the standard file tools (e.g. new, open, save)
	in the standard order."

	| bc |
	bc := self buttonClass.
	^{bc fileNew. bc fileOpen. bc fileSave}.
	#todo	"Is it necessary to create a new ToolbarButton each time, or can we share them?"!

findTools
	"Answer a collection of items which are the standard file tools (e.g. new, open, save)
	in the standard order."

	| bc |
	bc := self buttonClass.
	^{bc find. bc findNext}!

stbVersion
	^1! !

!ToolbarItem class categoriesForMethods!
buttonClass!constants!public! !
editTools!instance creation!public! !
fileTools!instance creation!public! !
findTools!instance creation!public! !
stbVersion!public! !
!

