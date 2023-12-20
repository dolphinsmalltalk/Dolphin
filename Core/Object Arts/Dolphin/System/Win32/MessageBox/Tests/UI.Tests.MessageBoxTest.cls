"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'UI.Tests.MessageBoxTest'
	instanceVariableNames: 'subject enablement defaultButton buttonLabels caption radioButtonLabels'
	classVariableNames: ''
	imports: #(#{OS.MessageBoxConstants} #{OS.TaskDialogConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.MessageBoxTest guid: (Core.GUID fromString: '{a542ef51-98e0-4476-82b5-0aaae88ef637}')!
UI.Tests.MessageBoxTest comment: ''!
!UI.Tests.MessageBoxTest methodsFor!

getDialogInfo
	| subviews buttons dialog radioButtons |
	dialog := DialogView fromHandle: subject handle.
	caption := dialog getWindowText.
	subviews := OrderedCollection new.
	dialog allChildWindowHandlesDo: [:each | subviews addLast: (UI.View fromHandle: each)].
	buttons := Array writeStream.
	radioButtons := Array writeStream.
	subviews do: 
			[:each |
			each wndClassName = 'Button'
				ifTrue: 
					[((each getWindowStyle allMask: OS.ButtonConstants.BS_AUTORADIOBUTTON)
						ifTrue: [radioButtons ]
						ifFalse: [buttons]) nextPut: each]].
	buttons := buttons grabContents.
	radioButtons := radioButtons grabContents.
	radioButtonLabels := radioButtons collect: [:each | each getWindowText].
	buttonLabels := buttons collect: [:each | each getWindowText].
	defaultButton := (buttons
				select: [:each | each getWindowStyle allMask: OS.ButtonConstants.BS_DEFPUSHBUTTON]) single
				getWindowText!

loopUntil: aNiladicValuable
	| start |
	start := Delay millisecondClockValue.
	SessionManager inputState
		loopWhile: [aNiladicValuable value not and: [Delay millisecondClockValue - start < 2000]]!

openSubject
	^self openSubject: [subject open]!

openSubject: aNiladicValuable
	| result timer |
	Processor activeProcess isDebuggee ifTrue: [^aNiladicValuable value].
	"If there is an error in the test event handler that receive's the created event, then the message box will not close and the test will block waiting for user input.
	In order to avoid this stopping the test run in a CI build until the build times out, we add a short timeout here."
	timer := 
			[2 seconds wait.
			subject destroy] fork.
	result := aNiladicValuable value.
	timer terminate.
	^result!

setUp
	super setUp.
	subject := MessageBox new.
	"We need the message loop to run in the main process"
	subject beTaskModal.
	enablement := SessionManager inputState topLevelWindows
				collect: [:each | Pair first: each second: each isEnabled]!

tearDown
	subject
		ifNotNil: 
			[subject setEvents: nil.
			subject handle ifNotNil: [subject clickButton: OS.Win32Constants.IDOK].
			subject destroy].
	subject := nil.
	enablement ifNotNil: [enablement do: [:each | each first isEnabled: each second]].
	super tearDown!

testAbortRetryIgnore
	| buttonId expectedButtonLabels |
	buttonId := OS.Win32Constants.IDABORT.
	subject progressRange: (1 to: 50).
	subject when: #created
		perform: 
			[self getDialogInfo.
			
			["Enable the delay to visually inspect"

			subject progressPosition: 15.
			subject progressState: #error.
			"1 seconds wait."
			subject clickButton: buttonId]
					fork].
	subject
		buttonStyle: #abortRetryIgnore;
		defaultButton: 2.
	self assert: self openSubject equals: #abort.
	expectedButtonLabels := (802 to: 804) collect: [:each | String fromResourceId: each in: User32].
	self assert: buttonLabels equals: expectedButtonLabels.
	self assert: defaultButton equals: (expectedButtonLabels at: 2).
	self assert: caption equals: SessionManager.Current applicationName.
	buttonId := OS.Win32Constants.IDRETRY.
	subject defaultButton: 3.
	"Test merging of the custom buttons used to implement #abortRetryIgnore with user supplied custom buttons. Includes an extra button."
	subject customButtons: #(#(#abort 'Stop') #(#retry 'Debug') #(#help 'Help!!')).
	self assert: self openSubject equals: #retry.
	"Note that the user supplied buttons always appear first, whether replacing one of the base buttons or not"
	self assert: buttonLabels equals: {'Stop'. 'Debug'. 'Help!!'. expectedButtonLabels last}.
	self assert: defaultButton equals: 'Help!!'.
	self assertIsNil: subject handle!

testButtonClicked
	| clicked allow dialogView |
	subject modality: #application.
	subject caption: self printString.
	"Initially the click is refused"
	allow := false.
	subject when: #buttonClicked:accept:
		perform: 
			[:id :accept |
			accept value: allow.
			clicked := id].
	[subject open] fork.
	self loopUntil: [subject handle notNil].
	dialogView := View fromHandle: subject handle.
	self assert: dialogView isOpen.
	subject clickButton: OS.Win32Constants.IDOK.
	self loopUntil: [clicked notNil].
	self assert: clicked equals: OS.Win32Constants.IDOK.
	"Click was received, but should have been refused"
	self assert: dialogView isOpen.
	self assert: dialogView getWindowText equals: self printString.
	self assert: subject result isNil.
	"Now allow the click"
	allow := true.
	clicked := nil.
	subject clickButton: OS.Win32Constants.IDOK.
	"MessageBox.handle is nil'd in the handle for TDN_DESTROYED, before the TaskDialog call returns, and therefore before the result is available. Once the result is available, the call must have returned."
	self loopUntil: [subject result notNil].
	self assert: subject handle isNil.
	self assert: subject result equals: #ok!

testCancelRetryContinue
	| buttonId radioButtonId expectedButtonLabels |
	buttonId := OS.Win32Constants.IDCONTINUE.
	radioButtonId := 3.
	subject hasMarqueeProgress: true.
	subject when: #created
		perform: 
			[self getDialogInfo.
			
			["Enable the delay to visually inspect"

			"1 seconds wait."
			subject
				clickRadioButton: radioButtonId;
				clickButton: buttonId]
					fork].
	subject
		buttonStyle: #cancelRetryContinue;
		defaultButton: 3.
	"Add some radio buttons as well"
	subject
		radioButtons: #(#(#radio1 'Radio 1') #(#radio2 'Radio 2') #(#radio3 'Radio 3'));
		defaultRadioButton: 2.
	"Continue is mapped to #ignore"
	self assert: self openSubject equals: #ignore.
	expectedButtonLabels := #(801 809 810) collect: [:each | String fromResourceId: each in: User32].
	self assert: buttonLabels equals: expectedButtonLabels.
	self assert: defaultButton equals: (expectedButtonLabels at: 3).
	self assert: caption equals: SessionManager.Current applicationName.
	self assert: subject radioButton equals: #radio3.
	buttonId := OS.Win32Constants.IDTRYAGAIN.
	radioButtonId := 1.
	subject defaultButton: 1.
	"Test merging of the custom buttons used to implement #abortRetryIgnore with user supplied custom buttons. Includes an extra button."
	subject customButtons: #(#(#retry 'Debug')).
	self assert: self openSubject equals: #retry.
	"Note that the user supplied buttons always appear first, whether replacing one of the base buttons or not"
	self assert: buttonLabels equals: {'Debug'. expectedButtonLabels first. expectedButtonLabels last}.
	self assert: defaultButton equals: 'Debug'.
	self assert: subject radioButton equals: #radio1.
	self assertIsNil: subject handle!

testConfirm
	| buttonId expectedCaption newEnablement yes no |
	buttonId := OS.Win32Constants.IDYES.
	subject when: #created
		perform: 
			[self getDialogInfo.
			newEnablement := enablement collect: [:each | Pair first: each first second: each first isEnabled].
			
			["Enable the delay to visually inspect"

			"1 seconds wait."
			subject clickButton: buttonId]
					fork].
	self assert: (self openSubject: [subject confirm: 'Test']).
	yes := String fromResourceId: 805 in: User32.
	no := String fromResourceId: 806 in: User32.
	self assert: buttonLabels equals: {yes. no}.
	self assert: defaultButton equals: yes.
	self assert: caption equals: 'Please confirm…'.
	self deny: (newEnablement anySatisfy: [:each | each second]).
	"Prior enablement should be restored"
	enablement do: [:each | self assert: each first isEnabled equals: each second].
	"If No is clicked, we expect false to be returned"
	buttonId := OS.Win32Constants.IDNO.
	"Also test that setting the caption works"
	expectedCaption := 'Hello World'.
	subject caption: expectedCaption.
	"Test custom buttons replacing common buttons, and an extra button"
	subject customButtons: #(#(#yes 'Qui') #(#no 'Non') #(#help 'Help!!')).
	subject defaultButton: 3.
	subject icon: self class icon.
	self assert: subject iconId equals: 0.
	self
		assert: (self openSubject: 
					[subject
						confirm: 'Test'
						onYes: ['onYes']
						onNo: ['onNo']
						onCancel: ['onCancel']])
		equals: 'onNo'.
	self assert: buttonLabels equals: {'Qui'. 'Non'. 'Help!!'. String fromResourceId: 801 in: User32}.
	self assert: defaultButton equals: 'Help!!'.
	self assert: caption equals: expectedCaption.
	self assertIsNil: subject handle!

testDefaultable
	| response valueName dontShowMeThisDialogAgainKey |
	subject isDefaultable: true.
	valueName := self displayString.
	subject uniqueId: valueName.
	dontShowMeThisDialogAgainKey := RegKey userRoot
				createKey: 'Software\Object Arts\Dolphin Smalltalk\DontShowMeThisDialogAgain'.
	"Ensure that the suppression is not present initially"
	dontShowMeThisDialogAgainKey removeSubValue: valueName ifAbsent: [].
	defaultButton := nil.
	subject when: #created
		perform: 
			[self getDialogInfo.
			
			["Enable the delay to visually inspect"

			"1 seconds wait."
			subject clickVerification: true.
			subject clickButton: OS.Win32Constants.IDRETRY]
					fork].
	subject buttonStyle: #retryCancel; defaultButton: 2; headline: 'Test'.
	response := self openSubject.
	self assertNotNil: defaultButton.
	"IDRETRY was clicked, not the default"
	self assert: response equals: #retry.
	"The suppression entry should be created in the registry"
	self assert: (dontShowMeThisDialogAgainKey valueAt: valueName) equals: OS.Win32Constants.IDRETRY.
	defaultButton := nil.
	response := self openSubject.
	self assertIsNil: defaultButton.
	"As IDRETRY was clicked originally, we will get that regardless of the default"
	self assert: response equals: #retry.
	defaultButton := nil.
	subject buttonStyle: #cancelRetryContinue.
	subject defaultButton: 3.
	response := self openSubject.
	self assertIsNil: defaultButton.
	self assert: response equals: #retry!

testSetStyleMaskedBy
	subject
		iconStyle: #none;
		buttonStyle: #none;
		isSetForeground: false;
		modality: #application.
	subject
		setStyle: MB_ABORTRETRYIGNORE | MB_TASKMODAL | MB_SETFOREGROUND | MB_ICONERROR | MB_DEFBUTTON3 
		maskedBy: -1.
	self assert: subject iconStyle equals: #error.
	self assert: subject iconId equals: TD_ERROR_ICON.
	self assert: subject buttonStyle equals: #abortRetryIgnore.
	self assert: subject modality equals: #task.
	self assert: subject defaultButton equals: 3.
	self assert: subject isSetForeground.
	self deny: subject isTopMost.
	subject setStyle: MB_TOPMOST maskedBy: MB_MISCMASK|MB_TYPEMASK.
	self assert: subject iconStyle equals: #error.
	self assert: subject buttonStyle equals: #ok.
	self assert: subject modality equals: #task.
	self assert: subject defaultButton equals: 3.
	self deny: subject isSetForeground.
	self assert: subject isTopMost.
	subject setStyle: MB_OKCANCEL maskedBy: MB_TYPEMASK.
	self assert: subject iconStyle equals: #error.
	self assert: subject buttonStyle equals: #okCancel.
	self assert: subject modality equals: #task.
	self assert: subject defaultButton equals: 3.
	self deny: subject isSetForeground.
	self assert: subject isTopMost.
	subject setStyle: MB_ICONWARNING maskedBy: MB_ICONMASK.
	self assert: subject iconStyle equals: #warning.
	self assert: subject iconId equals: TD_WARNING_ICON.
	self assert: subject buttonStyle equals: #okCancel.
	self assert: subject modality equals: #task.
	self assert: subject defaultButton equals: 3.
	self deny: subject isSetForeground.
	self assert: subject isTopMost.
	subject setStyle: 0 maskedBy: MB_ICONMASK.
	self assert: subject iconStyle equals: #none.
	self assert: subject iconId equals: 0.
	self assert: subject buttonStyle equals: #okCancel.
	self assert: subject modality equals: #task.
	self assert: subject defaultButton equals: 3.
	self deny: subject isSetForeground.
	self assert: subject isTopMost.
	subject setStyle: 0 maskedBy: MB_MODEMASK.
	self assert: subject iconStyle equals: #none.
	self assert: subject buttonStyle equals: #okCancel.
	self assert: subject modality equals: #application.
	self assert: subject defaultButton equals: 3.
	self deny: subject isSetForeground.
	self assert: subject isTopMost.
	subject setStyle: 0 maskedBy: MB_MISCMASK.
	self assert: subject iconStyle equals: #none.
	self assert: subject buttonStyle equals: #okCancel.
	self assert: subject modality equals: #application.
	self assert: subject defaultButton equals: 3.
	self deny: subject isSetForeground.
	self deny: subject isTopMost.
!

testSuppressible
	| response valueName dontShowMeThisDialogAgainKey |
	subject isSuppressible: true.
	subject uniqueId: self displayString.
	valueName := subject globallyUniqueId.
	self assert: (valueName endsWith: self displayString).
	dontShowMeThisDialogAgainKey := RegKey userRoot
				createKey: 'Software\Microsoft\Windows\CurrentVersion\Explorer\DontShowMeThisDialogAgain'.
	"Ensure that the suppression is not present initially"
	dontShowMeThisDialogAgainKey removeSubValue: valueName ifAbsent: [].
	defaultButton := nil.
	subject when: #created
		perform: 
			[self getDialogInfo.
			
			["Enable the delay to visually inspect"

			"1 seconds wait."
			subject clickVerification: true.
			subject clickButton: OS.Win32Constants.IDYES]
					fork].
	subject defaultButton: 2.
	defaultButton := nil.
	response := self openSubject: [subject confirmOrCancel: 'Test'].
	self assertNotNil: defaultButton.
	"IDYES was clicked, not the default"
	self assert: response equals: #yes.
	"The suppression entry should be created in the registry"
	self assert: (dontShowMeThisDialogAgainKey valueAt: valueName) equals: 'NO'.
	defaultButton := nil.
	response := self openSubject: [subject confirmOrCancel: 'Test'].
	self assertIsNil: defaultButton.
	"Although IDYES was clicked originally, we will get the default this time regardless"
	self assert: response equals: #no.
	defaultButton := nil.
	"Whatever the default button is should be the response, even if this was not the default button originally (the state is not saved in the registry, just that the dialog was suppressed)"
	subject defaultButton: 3.
	response := self openSubject: [subject confirmOrCancel: 'Test'].
	self assertIsNil: defaultButton.
	self assert: response equals: #cancel! !
!UI.Tests.MessageBoxTest categoriesForMethods!
getDialogInfo!helpers!private! !
loopUntil:!helpers!private! !
openSubject!helpers!private! !
openSubject:!helpers!private! !
setUp!private!running! !
tearDown!private!running! !
testAbortRetryIgnore!public!unit tests! !
testButtonClicked!public!unit tests! !
testCancelRetryContinue!public!unit tests! !
testConfirm!public!unit tests! !
testDefaultable!public!unit tests! !
testSetStyleMaskedBy!public!unit tests! !
testSuppressible!public!unit tests! !
!

