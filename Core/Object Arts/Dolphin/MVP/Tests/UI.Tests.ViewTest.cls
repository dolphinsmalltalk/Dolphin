"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.ViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.ViewTest guid: (Core.GUID fromString: '{cf223394-a19e-45f9-a270-551c288901ef}')!

UI.Tests.ViewTest comment: ''!

!UI.Tests.ViewTest methodsFor!

classToTest
	^TextPresenter!

simulateIconTitleFontChange: aShellView
	aShellView settingChanged: (SettingsChangeEvent
				window: aShellView
				message: WM_SETTINGCHANGE
				wParam: SPI_SETICONTITLELOGFONT
				lParam: 0)!

testDesignRectangle
	| rect view designRect |
	view := presenter view.
	rect := view getRect.
	designRect := rect scaledBy: USER_DEFAULT_SCREEN_DPI / view dpi.
	self assert: view designExtent equals: designRect extent.
	view designRectangle: designRect.
	self assert: (view extent closeTo: rect extent precision: 1).
	self assert: (view position closeTo: rect origin precision: 1)!

testDisplayString
	| subject |
	self assert: presenter view displayString equals: 'view'.
	subject := ShellView new.
	self assert: subject displayString equals: 'UI.ShellView'!

testFontChangePropagationFromDesktop
	"Note that this test may be quite slow if there are more than a few windows open. The particular culprit is the TreeView - it responds very slowly to a WM_SETFONT, although this is partly because it has to have available the text of all the nodes in order to be able to calculate its layout correctly. When the TreeView is in #dynamic update mode, which is true of the trees in the class browser, getting the current text involves sending a callback to request the text. Since the callback has to be sent for every node currently in the tree (not just the displayed nodes) this can take some time. Even when not in #dynamic update mode, the calculation done by the control is not fast. The test also has to change the desktop font twice, so the propagation cost is incurred twice."

	| edit savedDesktopFont expected actual |
	edit := presenter view.
	savedDesktopFont := View desktop font.
	self assert: edit getFont equals: View desktop actualFont.
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
	savedDesktopFont := View desktop font.
	edit := presenter view.
	shell := edit parentView.
	self assert: edit getFont equals: View desktop actualFont.
	expected := Font name: 'Comic Sans' pointSize: 24.
	"If this fails, the user's (unusual) choice of desktop font happens to be the same, and the test will be inconclusive"
	self deny: expected equals: savedDesktopFont.
	actual := 
			["Inject the font into the Desktop view without triggering font change propagation from there"
			View desktop basicFont: expected.

			"Pretend we've changed the icon title font, but don't actually do so. Changing this setting through the API doesn't send a change notification any more anyway, so we simulate the change."
			self simulateIconTitleFontChange: shell.
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

testPrintString
	| subject |
	self assert: presenter view printString
		equals: 'a TextEdit(<1d>, ''view'')' << presenter view handle.
	subject := ShellView new.
	self assert: subject printString equals: 'a ShellView(NULL, ''UI.ShellView'')'!

testRecreateMaintainsModelConnection
	presenter model value: 'aaa'.
	self assert: presenter view value equals: 'aaa'.
	presenter view hasBorder: true.
	presenter model value: 'bbb'.
	"If this fails, then the view did not receive a #valueChanged event from the model"
	self assert: presenter view value equals: 'bbb'! !

!UI.Tests.ViewTest categoriesForMethods!
classToTest!helpers!private! !
simulateIconTitleFontChange:!helpers!private! !
testDesignRectangle!public!unit tests! !
testDisplayString!public!unit tests! !
testFontChangePropagationFromDesktop!public!unit tests! !
testFontChangePropagationFromSettingsChange!public!unit tests! !
testFontChangePropagationFromShell!public!unit tests! !
testPrintString!public!unit tests! !
testRecreateMaintainsModelConnection!public!unit tests! !
!

