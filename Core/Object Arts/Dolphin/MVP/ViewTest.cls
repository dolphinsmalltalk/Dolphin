"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #ViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ViewTest guid: (GUID fromString: '{cf223394-a19e-45f9-a270-551c288901ef}')!
ViewTest comment: ''!
!ViewTest categoriesForClass!Unclassified! !
!ViewTest methodsFor!

classToTest
	^TextPresenter!

testFontChangePropagation
	| edit shell savedDesktopFont |
	edit := presenter view.
	shell := edit parentView.
	savedDesktopFont := View desktop font.
	
	[| expected actual |
	self assert: edit getFont equals: savedDesktopFont.
	expected := Font name: 'Comic Sans' pointSize: 12.
	View desktop font: expected.
	"Pretent we've changed the icon title font, but don't actually do so. It doesn't send a change notification any more anyway, so we simulate the change."
	shell
		wmSettingChange: WM_SETTINGCHANGE
		wParam: SPI_SETICONTITLELOGFONT
		lParam: 0.
	"We retrieve the actual font set into the control - if the propagation from the shell worked, then this will be the modified desktop font."
	actual := edit getFont.
	self assert: actual equals: expected]
			ensure: [View desktop font: savedDesktopFont]!

testRecreateMaintainsModelConnection
	presenter model value: 'aaa'.
	self assert: presenter view value equals: 'aaa'.
	presenter view hasBorder: true.
	presenter model value: 'bbb'.
	"If this fails, then the view did not receive a #valueChanged event from the model"
	self assert: presenter view value equals: 'bbb'! !
!ViewTest categoriesFor: #classToTest!helpers!private! !
!ViewTest categoriesFor: #testFontChangePropagation!public!unit tests! !
!ViewTest categoriesFor: #testRecreateMaintainsModelConnection!public!unit tests! !

