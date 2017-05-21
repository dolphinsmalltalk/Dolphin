"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #ClosedCommandDescriptionIssueDialog
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClosedCommandDescriptionIssueDialog guid: (GUID fromString: '{2c4a1983-3026-4a8f-a9d4-6f33dd5bea95}')!
ClosedCommandDescriptionIssueDialog comment: ''!
!ClosedCommandDescriptionIssueDialog categoriesForClass!MVP-Presenters! !
!ClosedCommandDescriptionIssueDialog methodsFor!

addContextHelpProvider: helpProvider 
	"Add context sensative F1 help to self."

	| table |
	table := self view acceleratorTable.
	table isNil ifTrue: [table := AcceleratorTable new].
	table addCommand: ((ClosedCommandDescription 
				command: (Message selector: #openHelpFor: argument: self)
				description: 'Help'
				receiver: helpProvider) acceleratorKey: VK_F1; yourself) .
	"cdemers - 5/12/2004 The message bellow causes a deepCopy of the ClosedCommandDescription to be made, which makes a deepCopy of the arguments and the reciever.  This is probably not what a user would want, and can cause a long delay in opening the window.  The deepCopy happens in ShellView<<updateCombinedAcceleratorTable"
	self view acceleratorTable: table!

onViewOpened

	
	self addContextHelpProvider: self model subject.! !
!ClosedCommandDescriptionIssueDialog categoriesFor: #addContextHelpProvider:!public!unit tests! !
!ClosedCommandDescriptionIssueDialog categoriesFor: #onViewOpened!public!unit tests! !

!ClosedCommandDescriptionIssueDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 0 0 416 788230 ##(BorderLayout)  1 1 0 410 8 ##(ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 560 0 0 0 5 0 0 0 560 1180166 ##(ResourceIdentifier)  8 ##(Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  21 437 834 469 71 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 218 0 0 0 244 0 0 0 253 0 0 0] 98 0 834 193 193 0 27 0 0 0 234 256 928 590342 ##(Rectangle)  834 21 21 834 21 21 0 0 0 0 11967 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 706 202 208 98 2 770 800 98 2 834 1341 905 834 521 591 416 770 8 #menuBar: 98 1 0 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 158 2 0 0 196 1 0 0 162 3 0 0 235 2 0 0] 98 1 560 944 0 27 )! !
!ClosedCommandDescriptionIssueDialog class categoriesFor: #resource_Default_view!public!resources-views! !

