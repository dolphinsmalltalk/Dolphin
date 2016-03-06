"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #LinkButtonTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LinkButtonTest guid: (GUID fromString: '{2AF000E8-54BD-40B6-8DC6-D0014BABC42C}')!
LinkButtonTest comment: ''!
!LinkButtonTest categoriesForClass!Unclassified! !
!LinkButtonTest methodsFor!

classToTest
	^LinkButton!

testClickLinkFiresCommand
	| text |
	presenter text: 'Test'.
	self assert: presenter commandDescription description = 'Test'.
	"This command will cause the shell to be hidden when fired"
	presenter command: #hide.
	self assert: presenter isWindowVisible.
	self leftClickAt: 10 @ 10.
	self assert: presenter isWindowVisible not.
	presenter topView show.
	"Now try clicking over an area of the text that is not part of the link"
	text := 'Click <a>here</a> to hide me'.
	presenter text: text.
	self assert: presenter commandDescription description = 'Click here to hide me'.
	SessionManager inputState pumpMessages.
	self assert: presenter isWindowVisible.
	self leftClickAt: 10 @ 10.
	self assert: presenter isWindowVisible!

testQueryCommandEnablement
	presenter text: 'Test'.
	self assert: presenter commandDescription description = 'Test'.
	"This command will cause the shell to be hidden when fired"
	presenter command: #test.
	self assert: presenter isWindowVisible.
	presenter validateUserInterface.
	self assert: presenter isEnabled not.
	presenter command: #hide.
	presenter
		invalidateUserInterface;
		validateUserInterface.
	self assert: presenter isEnabled! !
!LinkButtonTest categoriesFor: #classToTest!helpers!private! !
!LinkButtonTest categoriesFor: #testClickLinkFiresCommand!public!unit tests! !
!LinkButtonTest categoriesFor: #testQueryCommandEnablement!public!unit tests! !

