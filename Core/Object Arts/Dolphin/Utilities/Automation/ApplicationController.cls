"Filed out from Dolphin Smalltalk X6"!

Object subclass: #ApplicationController
	instanceVariableNames: 'wshShell execResult autoIt'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ApplicationController guid: (GUID fromString: '{37BB2896-882C-46A6-B13C-05DC3DD7EB2B}')!
ApplicationController comment: 'This class provides services for automating applications (other than through ActiveX Automation) and requires third party AutoIt (Version 2) ActiveX control to be installed. See http://www.hiddensoft.com/AutoIt/.'!
!ApplicationController categoriesForClass!Kernel-Objects! !
!ApplicationController methodsFor!

activate
	"Activate the controlled application (i.e. bring it to the foreground). Answers whether the
	request succeeeded."

	"Note: Despite requesting that the Windows scripting host wait until the application has
	been activated, it appears to be necessary to pause before sending any keys."

	^self activate: self processId!

activate: anObject 
	^self activate: anObject timeout: 0!

activate: anObject timeout: anInteger 
	(wshShell appActivate: anObject wait: anInteger ~= 0) ifFalse: [^false].
	^anInteger = 0 or: 
			["The WshShell definition of waiting doesn't seem to be very reliable"
			anObject isInteger 
				ifTrue: 
					[#todo.	"Find the window to wait for"
					true]
				ifFalse: [(self autoIt winWaitActive: anObject nTimeout: anInteger // 1000) = 0]]!

attachProcessId: anInteger 
	execResult := DummyWshExec attachProcessId: anInteger!

autoIt
	^autoIt!

closeWindow: aString
	self autoIt WinClose: aString!

environment
	^wshShell environment!

exec: aString 
	execResult := wshShell exec: aString!

initialize
	wshShell := IWshShell3 newWshShell.
	autoIt := AutoItIControl new!

interKeyDelay: anInteger 
	autoIt SetKeyDelay: anInteger!

isWindowActive: aString
	^(self autoIt ifWinActive: aString) ~= 0 !

processId
	^execResult processID!

sendKeys: aString 
	"Send the key sequence in the <String> argument to the current active window.
	The controlled application must be active, or the keys will be sent elsewhere!!"

	self autoIt Send: aString.
	"wshShell sendKeys: aString wait: true.
	Processor sleep: 30"!

sleep: anInteger
	self autoIt Sleep: anInteger!

terminate
	execResult terminate!

waitForWindow: aString timeout: anInteger 
	^(self autoIt winWait: aString nTimeout: anInteger // 1) = 0!

waitUntil: aBlock timeout: anInteger 
	anInteger / 100 timesRepeat: 
			[self sleep: 100.
			aBlock value ifTrue: [^true]].
	^false!

workingDirectory
	^wshShell currentDirectory!

workingDirectory: aString
	wshShell currentDirectory: aString! !
!ApplicationController categoriesFor: #activate!operations!public! !
!ApplicationController categoriesFor: #activate:!operations!public! !
!ApplicationController categoriesFor: #activate:timeout:!operations!public! !
!ApplicationController categoriesFor: #attachProcessId:!initializing!private! !
!ApplicationController categoriesFor: #autoIt!private! !
!ApplicationController categoriesFor: #closeWindow:!operations!public! !
!ApplicationController categoriesFor: #environment!public! !
!ApplicationController categoriesFor: #exec:!public! !
!ApplicationController categoriesFor: #initialize!initializing!private! !
!ApplicationController categoriesFor: #interKeyDelay:!operations!public! !
!ApplicationController categoriesFor: #isWindowActive:!operations!public! !
!ApplicationController categoriesFor: #processId!accessing!public! !
!ApplicationController categoriesFor: #sendKeys:!operations!public! !
!ApplicationController categoriesFor: #sleep:!operations!public! !
!ApplicationController categoriesFor: #terminate!public! !
!ApplicationController categoriesFor: #waitForWindow:timeout:!operations!public! !
!ApplicationController categoriesFor: #waitUntil:timeout:!public! !
!ApplicationController categoriesFor: #workingDirectory!public! !
!ApplicationController categoriesFor: #workingDirectory:!public! !

!ApplicationController class methodsFor!

attachProcessId: anInteger 
	"Answer a new instance of the receiver for automating the specified process."

	^(self new)
		attachProcessId: anInteger;
		yourself!

exec: aString 
	"Fork off a new process give the specified command line and answer a new instance of a the receiver
	which can be used to automate it."

	^(self new)
		exec: aString;
		yourself!

new
	^self basicNew initialize! !
!ApplicationController class categoriesFor: #attachProcessId:!instance creation!public! !
!ApplicationController class categoriesFor: #exec:!public! !
!ApplicationController class categoriesFor: #new!instance creation!public! !

