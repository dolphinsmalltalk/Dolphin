"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'UI.Tests.MessageBoxTest'
	instanceVariableNames: 'subject enablement'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.MessageBoxTest guid: (Core.GUID fromString: '{a542ef51-98e0-4476-82b5-0aaae88ef637}')!
UI.Tests.MessageBoxTest comment: ''!
!UI.Tests.MessageBoxTest categoriesForClass!Unclassified! !
!UI.Tests.MessageBoxTest methodsFor!

setUp
	subject := MessageBox new.
	"We need the message loop to run in the main process"
	subject beTaskModal.
	enablement := SessionManager inputState topLevelWindows
				collect: [:each | Pair first: each second: each isEnabled]!

tearDown
	subject ifNotNil: [subject destroy].
	subject := nil.
	enablement ifNotNil: [enablement do: [:each | each first isEnabled: each second]]!

testConfirm
	| buttonId expectedCaption newEnablement actualCaption |
	buttonId := OS.Win32Constants.IDYES.
	subject when: #created
		perform: 
			[actualCaption := (View fromHandle: subject handle) getWindowText.
			newEnablement := enablement collect: [:each | Pair first: each first second: each first isEnabled].
			
			["Enable the delay to visually inspect"

			"1 seconds wait."
			subject clickButton: buttonId]
					fork].
	self assert: (subject confirm: 'Test').
	"This is a convenient place to that the caption is set as expected and that task modal dialogs disable all top level views."
	self assert: actualCaption equals: 'Please confirm…'.
	self deny: (newEnablement anySatisfy: [:each | each second]).
	"Prior enablement should be restored"
	enablement do: [:each | self assert: each first isEnabled equals: each second].
	"If No is clicked, we expect false to be returned"
	buttonId := OS.Win32Constants.IDNO.
	"Also test that setting the caption works"
	expectedCaption := 'Hello World'.
	subject caption: expectedCaption.
	self assert: (subject
				confirm: 'Test'
				onYes: ['onYes']
				onNo: ['onNo']
				onCancel: ['onCancel'])
		equals: 'onNo'.
	self assert: actualCaption equals: expectedCaption.
	self assertIsNil: subject handle!

testDefaultable
	| response valueName dontShowMeThisDialogAgainKey created |
	subject isDefaultable: true.
	valueName := self displayString.
	subject uniqueId: valueName.
	dontShowMeThisDialogAgainKey := RegKey userRoot
				at: 'Software\Object Arts\Dolphin Smalltalk\DontShowMeThisDialogAgain'.
	"Ensure that the suppression is not present initially"
	dontShowMeThisDialogAgainKey removeSubValue: valueName ifAbsent: [].
	created := false.
	subject when: #created
		perform: 
			[created := true.
			
			["Enable the delay to visually inspect"

			"1 seconds wait."
			subject clickVerification: true.
			subject clickButton: OS.Win32Constants.IDYES]
					fork].
	subject defaultButton: 2.
	response := subject confirmOrCancel: 'Test'.
	self assert: created.
	"IDYES was clicked, not the default"
	self assert: response equals: #yes.
	"The suppression entry should be created in the registry"
	self assert: (dontShowMeThisDialogAgainKey valueAt: valueName) equals: OS.Win32Constants.IDYES.
	created := false.
	response := subject confirmOrCancel: 'Test'.
	self deny: created.
	"As IDYES was clicked originally, we will get that regardless of the default"
	self assert: response equals: #yes.
	created := false.
	subject defaultButton: 3.
	response := subject confirmOrCancel: 'Test'.
	self deny: created.
	self assert: response equals: #yes!

testSuppressible
	| response valueName dontShowMeThisDialogAgainKey created |
	subject isSuppressible: true.
	subject uniqueId: self displayString.
	valueName := subject globallyUniqueId.
	self assert: (valueName endsWith: self displayString).
	dontShowMeThisDialogAgainKey := RegKey userRoot
				at: 'Software\Microsoft\Windows\CurrentVersion\Explorer\DontShowMeThisDialogAgain'.
	"Ensure that the suppression is not present initially"
	dontShowMeThisDialogAgainKey removeSubValue: valueName ifAbsent: [].
	created := false.
	subject when: #created
		perform: 
			[created := true.
			
			["Enable the delay to visually inspect"

			"1 seconds wait."
			subject clickVerification: true.
			subject clickButton: OS.Win32Constants.IDYES]
					fork].
	subject defaultButton: 2.
	response := subject confirmOrCancel: 'Test'.
	self assert: created.
	"IDYES was clicked, not the default"
	self assert: response equals: #yes.
	"The suppression entry should be created in the registry"
	self assert: (dontShowMeThisDialogAgainKey valueAt: valueName) equals: 'NO'.
	created := false.
	response := subject confirmOrCancel: 'Test'.
	self deny: created.
	"Although IDYES was clicked originally, we will get the default this time regardless"
	self assert: response equals: #no.
	created := false.
	"Whatever the default button is should be the response, even if this was not the default button originally (the state is not saved in the registry, just that the dialog was suppressed)"
	subject defaultButton: 3.
	response := subject confirmOrCancel: 'Test'.
	self deny: created.
	self assert: response equals: #cancel! !
!UI.Tests.MessageBoxTest categoriesForMethods!
setUp!private!running! !
tearDown!private!running! !
testConfirm!public!unit tests! !
testDefaultable!public!unit tests! !
testSuppressible!public!unit tests! !
!

