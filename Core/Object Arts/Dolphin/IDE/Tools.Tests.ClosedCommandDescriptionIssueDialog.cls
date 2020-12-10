"Filed out from Dolphin Smalltalk 7"!

UI.Dialog subclass: #'Tools.Tests.ClosedCommandDescriptionIssueDialog'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClosedCommandDescriptionIssueDialog guid: (Core.GUID fromString: '{2c4a1983-3026-4a8f-a9d4-6f33dd5bea95}')!
Tools.Tests.ClosedCommandDescriptionIssueDialog comment: ''!
!Tools.Tests.ClosedCommandDescriptionIssueDialog categoriesForClass!MVP-Presenters! !
!Tools.Tests.ClosedCommandDescriptionIssueDialog methodsFor!

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
!Tools.Tests.ClosedCommandDescriptionIssueDialog categoriesFor: #addContextHelpProvider:!public!unit tests! !
!Tools.Tests.ClosedCommandDescriptionIssueDialog categoriesFor: #onViewOpened!public!unit tests! !

!Tools.Tests.ClosedCommandDescriptionIssueDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 21 423 578 449 71 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 211 0 0 0 234 0 0 0 246 0 0 0] 8 #() 578 193 193 nil 27 nil nil nil 170 192 928 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 10359 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 738 138 144 34 2 802 #createAt:extent: 34 2 578 1661 785 578 521 591 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 62 3 0 0 136 1 0 0 66 4 0 0 175 2 0 0] 34 1 640 944 nil 27 )! !
!Tools.Tests.ClosedCommandDescriptionIssueDialog class categoriesFor: #resource_Default_view!public!resources-views! !

