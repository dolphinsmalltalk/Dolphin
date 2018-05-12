"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ToolbarItem
	instanceVariableNames: 'commandId unused window style commandDescription'
	classVariableNames: ''
	poolDictionaries: 'ToolbarConstants'
	classInstanceVariableNames: ''!
ToolbarItem guid: (GUID fromString: '{87b4c4c6-026e-11d3-9fd7-00a0cc3e4a32}')!
ToolbarItem isAbstract: true!
ToolbarItem comment: 'ToolbarItem is an abstract class whose subclasses represent the items held by a <Toolbar>.

Instance Variables:
	commandId	<integer> ID of the item''s command (or zero if none).
	unused		<UndefinedObject> reserved for future use.
	window		<Toolbar> containing the item.
	style		<integer> representing the Window''s style of the item.
	commandDescription	<CommandDescription> or nil, of the item''s command.  

'!
!ToolbarItem categoriesForClass!MVP-Views-Support! !
!ToolbarItem methodsFor!

commandId
	"Private - Answer the Integer command identifier for the receiver"

	^0
!

getCommandId
	"Private - Determine and answer the Integer command identifier for the receiver."

	^self commandId!

imageIndexIn: aWindow
	"Private - Answer the index of the bitmap from aWindows registered bitmaps
	which will be used for the receiver on the toolbar." 

	^self subclassResponsibility!

initialize
	"Private - Initialize the state of the receiver."

	style := 0.
!

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

	^style!

style: styleInteger
	"Private - Set the style of the receiver. "

	style := styleInteger.
	self update!

textIndexIn: aToolbar
	"Private - Answer the index of the text which will be shown on the toolbar for the
	receiver."

	^self subclassResponsibility!

toolbar
	"Private - Answer the ToolBar in which the receier exists."

	^window!

toolbar: aToolbar
	"Private - Set the toolbar in which the receiver exists to aToolbar."

	window := aToolbar!

update
	"Private - Update the associated Toolbar if we have one"

	self toolbar notNil ifTrue: [
		self toolbar updateAllItems  ]!

validateUserInterface: route
	"Set the UI state of the receiver. Overridden in subclasses"! !
!ToolbarItem categoriesFor: #commandId!commands!private! !
!ToolbarItem categoriesFor: #getCommandId!commands!private! !
!ToolbarItem categoriesFor: #imageIndexIn:!operations!private! !
!ToolbarItem categoriesFor: #initialize!initializing!private! !
!ToolbarItem categoriesFor: #isDivider!public!testing! !
!ToolbarItem categoriesFor: #isDropdownStyle!public!style! !
!ToolbarItem categoriesFor: #onClick:!event handling!public! !
!ToolbarItem categoriesFor: #onDoubleClick:!event handling!public! !
!ToolbarItem categoriesFor: #onRightClick:!event handling!public! !
!ToolbarItem categoriesFor: #parent!operations!public! !
!ToolbarItem categoriesFor: #style!private!style! !
!ToolbarItem categoriesFor: #style:!private!style! !
!ToolbarItem categoriesFor: #textIndexIn:!operations!private! !
!ToolbarItem categoriesFor: #toolbar!accessing!private! !
!ToolbarItem categoriesFor: #toolbar:!accessing!private! !
!ToolbarItem categoriesFor: #update!accessing!private! !
!ToolbarItem categoriesFor: #validateUserInterface:!operations!public! !

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
	^Array 
		with: bc fileNew
		with: bc fileOpen
		with: bc fileSave.

	#todo "Is it necessary to create a new ToolbarButton each time, or can we share them?"!

findTools
	"Answer a collection of items which are the standard file tools (e.g. new, open, save)
	in the standard order."

	| bc |
	bc := self buttonClass.
	^Array 
		with: bc find
		with: bc findNext.

!

new
	"Answer a new instance of the receiver."

	^super new initialize! !
!ToolbarItem class categoriesFor: #buttonClass!constants!public! !
!ToolbarItem class categoriesFor: #editTools!instance creation!public! !
!ToolbarItem class categoriesFor: #fileTools!instance creation!public! !
!ToolbarItem class categoriesFor: #findTools!instance creation!public! !
!ToolbarItem class categoriesFor: #new!instance creation!public! !

