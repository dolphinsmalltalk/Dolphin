"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.ProgressDialog'
	instanceVariableNames: 'progressPresenter operation process textPresenter flags priority'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'AllowCancelMask' -> 16r1. 'IsReusableMask' -> 16r2 }!

UI.ProgressDialog guid: (Core.GUID fromString: '{87b4c6ab-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ProgressDialog comment: 'ProgressDialog is a <valueDialogPresenter> that can be used to indicate the progress of a background operation. The <valueModel> is used to hold a <number> that describes the current amount of progress through the operation. Typically, with the standard views, this will be an <integer> between 0 and 100%.

The various [instance creation] methods accept a <monadicValuable> operation which is evaluated in a background process. The parameter passed to the operation is the <valueModel> of the ProgressDialog. It is then the responsibility of the operation, as it progresses, to periodically update this with the state of progress.

A ProgressDialog can be marked as re-usable. A re-usable ProgressDialog can be shown multiple times, and each time the operation is repeated.

The class includes a number of examples to demonstrate its use:
	ProgressDialog example1.
	ProgressDialog example2.
	ProgressDialog example3.

Instance Variables:
	progressPresenter	<NumberPresenter> displaying the current state of progress.
	operation			<monadicValuable> holding the operation to be performed.
	process			<Process> evaluating the operation.
	textPresenter		<TextPresenter> displaying the descriptive text to describe the operation.
	flags				<Integer>. Flags word.
	priority			<Integer>. Priority at which the operation is forked.

Class Variables:
	AllowCancelMask	<Integer>. Bit mask for allowCancel flag.
	IsReusableMask	<Integer>. Bit mask for isReusable flag.


'!

!UI.ProgressDialog categoriesForClass!MVP-Presenters! !

!UI.ProgressDialog methodsFor!

allowCancel
	"Answer whether the user is permitted to cancel the operation."

	^flags anyMask: AllowCancelMask!

allowCancel: aBoolean 
	"Set whether the user is permitted to cancel the operation."

	flags := flags mask: AllowCancelMask set: aBoolean.
	self invalidateUserInterface!

answer
	"Answer the model if the receiver was confirmed (with #apply, #okay) 
	or nil otherwise. Dereference the value from the model since this will
	be most useful"

	^self isConfirmed
		ifTrue: [ self model subject value ]
		ifFalse: [ nil ]!

cancel
	"Cancel the operation and close the receiver."

	<commandQuery: #queryCancel:>
	process terminate.
	process := nil.
	super cancel!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	progressPresenter := self add: NumberPresenter new name: 'progress'.
	textPresenter := self add: TextPresenter new name: 'text'!

defaultOperation
	"Private - Provide a default operation to avoid walkback if none."

	^
	[:progress |
	progress
		caption: 'Sample Progress Dialog';
		text: 'Dialog created without an operation, so we provide a default!!'.
	0 to: 100
		by: 5
		do: 
			[:i |
			(Delay forMilliseconds: 200) wait.
			progress value: i].
	(Delay forMilliseconds: 1000) wait.
	progress deferredClose]!

deferredClose
	
	[self apply.
	self isReusable ifTrue: [self view hide] ifFalse: [self view close]] 
			postToMessageQueue!

forkOperation
	"Private - Start the receiver's operation at the current priority
	(the user supplied operation can modify the priority, if desired,
	by means of a 'Processor activeProcess priority: X' expression)."

	operation ifNil: [operation := self defaultOperation].
	process := 
			[self model subject value: (operation value: self).
			self deferredClose] forkAt: self priority!

initialize
	"Private - Initialize the receiver"

	super initialize.
	flags := AllowCancelMask.
	priority := Processor userBackgroundPriority!

isReusable
	"Answer whether the progress dialog is re-usable."

	^flags allMask: IsReusableMask!

isReusable: aBoolean 
	"Set whether the progress dialog is re-usable. If re-useable then the dialog is hidden,
	rather than closed, at the end of the operation. The whole process can then be repeated by
	re-showing the dialog."

	flags := flags mask: IsReusableMask set: aBoolean!

operation
	"Answer the value of the receiver's instance variable 'operation'.
	This method was automatically generated, but may be modified."

	^operation!

operation: anObject
	"Set the value of the receiver's instance variable 'operation' to anObject.
	This method was automatically generated, but may be modified."

	operation := anObject!

priority
	"Answer the priority at which the operation was or will be forked."

	^priority!

priority: anInteger
	"Set the priority at which the operation was or will be forked.
	This must be a valid process priority level."

	(priority between: Processor systemBackgroundPriority 
			and: Processor highIOPriority) ifFalse: [self error: 'Invalid priority'].
	priority := anInteger

!

progress
	"Answer the current progress value.
	Useful with modeless progress dialogs."

	^progressPresenter value!

queryCancel: aCommandQuery
	aCommandQuery isEnabled: self allowCancel.
	"Note that we need to force ourselves as the command target to disable cancel"
	aCommandQuery receiver: self!

show
	"Start the operation, and show the receiver modelessly.
	The result of the operation (and the progress) can be queried from
	the receiver at any time using the messages #isConfirmed, #value, 
	and #progress.
	"

	self forkOperation.
	^super show!

showModal
	"Start the operation, and show the receiver's view as a modal dialog.
	Answer the result of the operation if the process runs to completion,
	or if cancelled or the process experiences an exception."

	self forkOperation.
	^super showModal!

startMarquee
	progressPresenter view
		isMarquee: true;
		startMarquee!

stopMarquee
	progressPresenter view
		stopMarquee;
		isMarquee: false!

text: progressText
	"Set the descriptive text displayed in the receiver to be the <readableString>,
	progressText."

	textPresenter model value: progressText!

value: progressValue
	"Set the numeric progress displayed in the receiver to be the <Integer>,
	progressValue."

	progressPresenter value: progressValue! !

!UI.ProgressDialog categoriesForMethods!
allowCancel!accessing!public! !
allowCancel:!accessing!public! !
answer!accessing!public! !
cancel!commands-actions!public! !
createComponents!initializing!public! !
defaultOperation!operations!private! !
deferredClose!operations!private! !
forkOperation!operations!public! !
initialize!initializing!private! !
isReusable!accessing!public! !
isReusable:!accessing!public! !
operation!accessing!public! !
operation:!accessing!public! !
priority!accessing!public! !
priority:!accessing!public! !
progress!accessing!public! !
queryCancel:!commands-queries!private! !
show!operations!public! !
showModal!operations!public! !
startMarquee!operations!public! !
stopMarquee!operations!public! !
text:!accessing!public! !
value:!accessing!public! !
!

!UI.ProgressDialog class methodsFor!

create: viewName operation: operation
	"Answer a new instance of the receiver with a view identified by viewName
	to evaluate the monadic valuable argument, operation, when the 
	instance is subsequently shown (e.g. by sending it #showModal).
	When the view is shown the operation is evaluated in a background 
	process, and is passed the progress dialog to be updated with its 
	progress (#value: 0..100, #text: aString). If the instances cancel button
	is pressed, then the operation is terminated and the answer is nil. If the operation 
	runs to completion, then the answer is result of the evaluation."

	^(self create: viewName)
		operation: operation!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue!

example1
	"A simple modal progress dialog. Notice how the progress text can also be set within
	the operation block. Try pressing cancel to see the effect on the answer.
		ProgressDialog example1
	"

	^self showModalWhile: [:progress | 
		1 to: 100 do: [:i | Processor sleep: 30 milliseconds. progress value: i; text: i displayString, '%']. 'completed']!

example2
	"A simple modeless progress dialog.
		x := ProgressDialog example2
	Try evaluating these expressions while the progress dialog is up:
		x progress.
		x isConfirmed.
		x answer.
	"

	^(self operation: 
			[:progress | 
			1 to: 100
				do: 
					[:i | 
					Processor sleep: 100 milliseconds.
					progress
						value: i;
						text: i displayString , '%'].
			'completed'])
		caption: 'Modeless progress…';
		show!

example3
	"A simple modal progress dialog with an alternative view.
		ProgressDialog example3
	"

	^(self 
		create: 'Numeric progress dialog'
		operation: [:progress | 
		10 to: 1 by: -1 do: [:i | progress value: i. Processor sleep: 400 milliseconds]. 'completed'])
			caption: 'Count down…';
			allowCancel: false;
			showModal!

icon
	"Answers an Icon that can be used to represent this class."

	^ProgressBar icon!

operation: operation
	"Answer a new instance of the receiver with the default view 
	to evaluate the monadic valuable argument, operation, when the 
	instance is subsequently shown (e.g. by sending it #showModal).
	When the view is shown the operation is evaluated in a background 
	process, and is passed a progress dialog to be updated with its 
	progress (#value: 0..100, #text: aString). If the instances cancel button
	is pressed, then the operation is terminated and the answer is nil. If the operation 
	runs to completion, then the answer is result of the evaluation."

	^self create: self defaultView operation: operation!

resource_Compact_view
	"Answer the literal data from which the 'Compact view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Compact_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12845056 65664) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 18 #{UI.ProgressBar} 50 15 nil 32 50 2 8 1140850688 1 256 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 1 nil nil 5 nil nil nil 256 nil nil 518 #{UI.NullConverter} nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[16 0 0 0 33 0 0 0 100 1 0 0 48 0 0 0] 193 288 8 '' 256 466 #range: 50 1 774 #{Core.Interval} 1 201 3 256 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'progress' 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 736 nil nil nil 5 nil nil nil 736 nil nil 386 nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[16 0 0 0 8 0 0 0 100 1 0 0 28 0 0 0] 193 768 nil 736 466 #text: 50 1 8 'Description of operation goes here' 736 3 8 #() 690 193 193 nil 27 8 'text' nil nil nil nil nil 1 nil nil 690 1081 311 nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 518 #{UI.CreateDialog} 518 #{Graphics.Rectangle} 690 7679 21 690 8439 281 193 32 466 #setWindowText: 50 1 8 'Please wait…' 32 1 50 3 736 256 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 1296 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1296 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[20 1 0 0 58 0 0 0 100 1 0 0 81 0 0 0] 193 1328 8 '&Cancel' 1296 3 8 #() 690 193 193 nil 29 690 193 193 nil 29)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 6 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 288 nil nil nil 5 nil nil nil 288 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[20 0 0 0 10 0 0 0 94 1 0 0 44 0 0 0] 193 320 nil 288 434 #text: 50 1 8 'Description of operation goes here
Up to two lines of text permitted' 288 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 41 690 #fixedParentRight -27 690 #fixedParentTop 21 690 #fixedViewTop 69 18 #{UI.ProgressBar} 50 15 nil 32 50 2 8 1140850688 1 768 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 1 nil nil 5 nil nil nil 768 nil nil 354 nil nil 386 50 2 434 #createWindow: 50 1 482 514 8 #[15 0 0 0 50 0 0 0 94 1 0 0 70 0 0 0] 193 800 8 '' 768 434 #range: 50 1 774 #{Core.Interval} 1 201 3 768 3 8 #() 626 193 193 nil 27 658 704 31 720 -27 736 101 752 41 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 1152 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 1152 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 386 50 1 434 #createWindow: 50 1 482 514 8 #[14 1 0 0 78 0 0 0 94 1 0 0 103 0 0 0] 193 1184 8 '&Cancel' 1152 3 8 #() 626 193 193 nil 29 658 690 #fixedViewRight -159 720 -27 690 #fixedViewBottom -49 690 #fixedParentBottom -15 242 #{Core.IdentityDictionary} 50 4 768 8 'progress' 288 8 'text' nil nil nil nil nil 1 nil nil 626 1081 301 626 511 301 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 386 50 2 434 #createWindow: 50 1 518 #{UI.CreateDialog} 518 #{Graphics.Rectangle} 626 7679 21 626 8439 321 193 32 434 #setWindowText: 50 1 8 'Please wait…' 32 1 50 3 288 768 1152 626 193 193 nil 29)!

resource_No_cancel_view
	"Answer the literal data from which the 'No cancel view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_No_cancel_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12845056 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 4 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 288 nil nil nil 5 nil nil nil 288 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[20 0 0 0 10 0 0 0 94 1 0 0 42 0 0 0] 193 320 nil 288 434 #text: 50 1 8 'Description of operation goes here
Up to two lines of text permitted' 288 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 41 690 #fixedParentRight -27 690 #fixedParentTop 21 690 #fixedViewTop 65 18 #{UI.ProgressBar} 50 15 nil 32 50 2 8 1140850688 1 768 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} 1 nil nil 5 nil nil nil 768 nil nil 354 nil nil 386 50 2 434 #createWindow: 50 1 482 514 8 #[15 0 0 0 55 0 0 0 94 1 0 0 75 0 0 0] 193 800 8 '' 768 434 #range: 50 1 774 #{Core.Interval} 1 201 3 768 3 8 #() 626 193 193 nil 27 658 704 31 720 -27 736 111 752 41 242 #{Core.IdentityDictionary} 50 4 768 8 'progress' 288 8 'text' nil nil nil nil nil 1 nil nil 626 1081 311 626 511 241 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 386 50 2 434 #createWindow: 50 1 518 #{UI.CreateDialog} 518 #{Graphics.Rectangle} 626 7679 21 626 8439 281 193 32 434 #setWindowText: 50 1 8 'Please wait…' 32 1 50 2 288 768 626 193 193 nil 29)!

resource_Numeric_progress_dialog
	"Answer the literal data from which the 'Numeric progress dialog' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Numeric_progress_dialog)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(12582912 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850945 1 256 nil nil nil 5 nil 130 nil true 162 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 256 nil nil 1094 1 #{UI.NumberToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[17 0 0 0 13 0 0 0 172 0 0 0 48 0 0 0] 193 288 nil 256 498 #text: 50 1 8 '100' 256 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'progress' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 450 50 2 498 #createWindow: 50 1 518 #{UI.CreateDialog} 518 #{Graphics.Rectangle} 690 7679 21 690 8069 271 193 32 498 #setWindowText: 50 1 8 'Please wait…' 32 1 50 2 18 #{UI.PushButton} 50 20 nil 32 50 2 8 1140924416 1 992 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 992 nil nil 1350 4 #{UI.CommandDescription} #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 450 50 1 498 #createWindow: 50 1 546 578 8 #[51 0 0 0 53 0 0 0 136 0 0 0 78 0 0 0] 193 1024 8 '&Cancel' 992 3 8 #() 690 193 193 nil 29 256 690 193 193 nil 29)!

showModal: viewName while: operation
	"Create a new instance of the receiver with a view identified by viewName
	to evaluate the monadic valuable argument, operation. The view is 
	displayed modal to the current active window. The operation is evaluated 
	in a background process, and is passed a progress dialog to be updated with its 
	progress (#value: 0..100, #text: aString). If the instances cancel button is pressed, then 
	the operation is terminated and the answer is nil. If the operation 
	runs to completion, then the answer is result of the evaluation."

	^(self create: viewName operation: operation)
		showModal!

showModalWhile: operation
	"Create a new instance of the receiver with its default view,
	to evaluate the monadic valuable argument, operation. The view is 
	displayed modal to the current active window. The operation is evaluated 
	in a background process, and is passed a progress dialog to be updated with its 
	progress (#value: 0..100, #text: aString). If the instances cancel button is pressed, then 
	the operation is terminated and the answer is nil. If the operation 
	runs to completion, then the answer is result of the evaluation."

	^self showModal: self defaultView while: operation! !

!UI.ProgressDialog class categoriesForMethods!
create:operation:!instance creation!public! !
defaultModel!models!public! !
example1!examples!public! !
example2!examples!public! !
example3!examples!public! !
icon!constants!public! !
operation:!instance creation!public! !
resource_Compact_view!public!resources-views! !
resource_Default_view!public!resources-views! !
resource_No_cancel_view!public!resources-views! !
resource_Numeric_progress_dialog!public!resources-views! !
showModal:while:!instance creation!public! !
showModalWhile:!instance creation!public! !
!

