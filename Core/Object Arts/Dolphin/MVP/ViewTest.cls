"Filed out from Dolphin Smalltalk"!

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

testFontChangePropagationFromDesktop
	"Note that this test may be quite slow if there are more than a few windows open. The particular culprit is the TreeView - it responds very slowly to a WM_SETFONT, although this is partly because it has to have available the text of all the nodes in order to be able to calculate its layout correctly. When the TreeView is in #dynamic update mode, which is true of the trees in the class browser, getting the current text involves sending a callback to request the text. Since the callback has to be sent for every node currently in the tree (not just the displayed nodes) this can take some time. Even when not in #dynamic update mode, the calculation done by the control is not fast. The test also has to change the desktop font twice, so the propagation cost is incurred twice."

	| edit savedDesktopFont expected actual |
	edit := presenter view.
	savedDesktopFont := View desktop font.
	self assert: edit getFont equals: savedDesktopFont.
	expected := Font name: 'Comic Sans' pointSize: 24.
	"If this fails, the user's (unusual) choice of desktop font happens to be the same, and the test will be inconclusive"
	self deny: expected equals: savedDesktopFont.
	actual := 
			["Inject the font into the Desktop view in expectation of font change propagation from there"
			View desktop font: expected.
			self assert: edit parentView actualFont equals: expected.
			"We retrieve the actual font set into the control - if the propagation from the desktop worked, then this will be the modified desktop font."
			edit getFont]
					ensure: [View desktop font: savedDesktopFont].
	self assert: actual equals: expected!

testFontChangePropagationFromSettingsChange
	"The desktop font can be changed by a theme change."

	| edit shell savedDesktopFont expected actual |
	edit := presenter view.
	shell := edit parentView.
	savedDesktopFont := View desktop font.
	self assert: edit getFont equals: savedDesktopFont.
	expected := Font name: 'Comic Sans' pointSize: 24.
	"If this fails, the user's (unusual) choice of desktop font happens to be the same, and the test will be inconclusive"
	self deny: expected equals: savedDesktopFont.
	actual := 
			["Inject the font into the Desktop view without triggering font change propagation from there"
			View desktop basicFont: expected.

			"Pretend we've changed the icon title font, but don't actually do so. Changing this setting doesn't send a change notification any more anyway, so we simulate the change."
			shell
				wmSettingChange: WM_SETTINGCHANGE
				wParam: SPI_SETICONTITLELOGFONT
				lParam: 0.
			"Top-level views should have the new font applied"
			self assert: edit parentView actualFont equals: expected.
			"We retrieve the actual font set into the control - if propagation of the settings change worked, then this will be the modified desktop font."
			edit getFont]
					ensure: [View desktop font: savedDesktopFont].
	"Child views should have the new font applied too"
	self assert: actual equals: expected!

testFontChangePropagationFromShell
	| edit shell expected actual |
	edit := presenter view.
	shell := edit topView.
	expected := Font name: 'Comic Sans' pointSize: 24.
	shell font: expected.
	self assert: edit parentView actualFont equals: expected.
	"We retrieve the actual font set into the control - if the propagation from the parent shell worked, then this will be the new font."
	actual := edit getFont.
	self assert: actual equals: expected!

testRecreateMaintainsModelConnection
	presenter model value: 'aaa'.
	self assert: presenter view value equals: 'aaa'.
	presenter view hasBorder: true.
	presenter model value: 'bbb'.
	"If this fails, then the view did not receive a #valueChanged event from the model"
	self assert: presenter view value equals: 'bbb'! !

!ViewTest categoriesForMethods!
classToTest!helpers!private! !
testFontChangePropagationFromDesktop!public!unit tests! !
testFontChangePropagationFromSettingsChange!public!unit tests! !
testFontChangePropagationFromShell!public!unit tests! !
testRecreateMaintainsModelConnection!public!unit tests! !
!

