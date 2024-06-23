"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.LinkButtonTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.LinkButtonTest guid: (Core.GUID fromString: '{2af000e8-54bd-40b6-8dc6-d0014babc42c}')!

UI.Tests.LinkButtonTest comment: ''!

!UI.Tests.LinkButtonTest methodsFor!

classToTest
	^LinkButton!

testClickLinkFiresCommand
	| text |
	presenter text: 'Test'.
	self assert: presenter commandDescription description equals: 'Test'.
	"This command will cause the shell to be hidden when fired"
	presenter command: #hide.
	self assert: presenter isWindowVisible.
	self leftClickAt: 10 @ 10.
	self assert: presenter isWindowVisible not.
	presenter topView show.
	"Now try clicking over an area of the text that is not part of the link"
	text := 'Click <a>here</a> to hide me'.
	presenter text: text.
	self assert: presenter commandDescription description equals: 'Click here to hide me'.
	SessionManager inputState pumpMessages.
	self assert: presenter isWindowVisible.
	self leftClickAt: 10 @ 10.
	self assert: presenter isWindowVisible!

testGetSetText
	presenter text: 'Test'.
	"SysLink control seems to have a bug, and returns the length of the text plus the null
	terminator in response to WM_GETTEXTLENGTH (the null is supposed to be excluded)"
	self assert: presenter text equals: '<a>Test</a>'!

testQueryCommandEnablement
	presenter text: 'Test'.
	self assert: presenter commandDescription description equals: 'Test'.
	"This command will cause the shell to be hidden when fired"
	presenter command: #test.
	self assert: presenter isWindowVisible.
	presenter validateUserInterface.
	self assert: presenter isEnabled not.
	presenter command: #hide.
	presenter
		invalidateUserInterface;
		validateUserInterface.
	self assert: presenter isEnabled!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view command |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view text equals: '<a>Click to Close</a>'.
	command := view commandDescription.
	self assert: command command identicalTo: #close.
	self assert: command description equals: 'Click to Close'.
	self deny: command hasAcceleratorKey.
	self assert: command isAbortable.
	self deny: command isModalCommand.
	self assertIsNil: command image! !

!UI.Tests.LinkButtonTest categoriesForMethods!
classToTest!helpers!private! !
testClickLinkFiresCommand!public!unit tests! !
testGetSetText!public!unit tests! !
testQueryCommandEnablement!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.LinkButtonTest class methodsFor!

resource_Link_button_D6
	"Answer the literal data from which the 'Link button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Link_button)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(LinkButton) 98 15 0 0 98 2 8 1140916224 1 416 0 524550 ##(ColorRef) 8 4278190080 0 517 0 0 0 416 0 8 4294906965 1180998 4 ##(CommandDescription) 8 #close 8 'Click to Close' 1 1 0 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 21 31 754 111 71 416 690 8 #text: 98 1 8 '<a>Click to Close</a>' 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 15 0 0 0 65 0 0 0 50 0 0 0] 98 0 754 193 193 0 27)!

resource_Link_button_D7
	"Answer the literal data from which the 'Link button' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Link_button)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.LinkButton) 34 15 nil nil 34 2 8 1140916224 1 416 nil 327686 ##(Smalltalk.Color) #default nil 519 nil nil nil 416 nil 8 1904508208 1180998 4 ##(Smalltalk.CommandDescription) #close 8 'Click to Close' 1 1 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 690 111 71 416 642 #text: 34 1 8 '<a>Click to Close</a>' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 182 7 0 0 45 0 0 0] 8 #() 690 193 193 nil 27)! !

!UI.Tests.LinkButtonTest class categoriesForMethods!
resource_Link_button_D6!public!resources-views! !
resource_Link_button_D7!public!resources-views! !
!

