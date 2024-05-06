"Filed out from Dolphin Smalltalk"!

Dialog subclass: #ProgressDialog
	instanceVariableNames: 'progressPresenter operation process textPresenter flags priority'
	classVariableNames: 'AllowCancelMask IsReusableMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProgressDialog guid: (GUID fromString: '{87b4c6ab-026e-11d3-9fd7-00a0cc3e4a32}')!

ProgressDialog comment: 'ProgressDialog is a <valueDialogPresenter> that can be used to indicate the progress of a background operation. The <valueModel> is used to hold a <number> that describes the current amount of progress through the operation. Typically, with the standard views, this will be an <integer> between 0 and 100%.

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

!ProgressDialog categoriesForClass!MVP-Presenters! !

!ProgressDialog methodsFor!

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

	process terminate.
	process := nil.
	super cancel!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	progressPresenter := self add: NumberPresenter new name: 'progress'.
	textPresenter := self add: TextPresenter new name: 'text'

!

defaultOperation
	"Private - Provide a default operation to avoid walkback if none."

	^[:progress | 
		progress
			caption: 'Sample Progress Dialog';
			text: 'Dialog created without an operation, so we provide a default!!'.
		0 to: 100 by: 5 do: [:i | 
			(Delay forMilliseconds: 200) wait.
			progress value: i.
		].
		(Delay forMilliseconds: 1000) wait.
		progress deferredClose.
	]!

deferredClose
	
	[self apply.
	self isReusable ifTrue: [self view hide] ifFalse: [self view close]] 
			postToMessageQueue!

forkOperation
	"Private - Start the receiver's operation at the current priority
	(the user supplied operation can modify the priority, if desired,
	by means of a 'Processor activeProces priority: X' expression)."

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
	"Answer whether the progress diialog is re-usable."

	^flags allMask: IsReusableMask!

isReusable: aBoolean 
	"Set whether the progress diialog is re-usable. If re-useable then th dialog is hidden,
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

queryCommand: query
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| cmd |
	cmd := query commandSymbol.

	cmd == #cancel ifTrue: [
		"Note that we need to force ourselves as the command target to disable cancel"
		query isEnabled: self allowCancel; receiver: self.
		^true].

	^super queryCommand: query

!

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

text: progressText
	"Set the descriptive text displayed in the receiver to be the <readableString>,
	progressText."

	textPresenter model value: progressText!

value: progressValue
	"Set the numeric progress displayed in the receiver to be the <Integer>,
	progressValue."

	progressPresenter value: progressValue! !

!ProgressDialog categoriesForMethods!
allowCancel!accessing!public! !
allowCancel:!accessing!public! !
answer!accessing!public! !
cancel!commands!public! !
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
queryCommand:!commands!private! !
show!operations!public! !
showModal!operations!public! !
text:!accessing!public! !
value:!accessing!public! !
!

!ProgressDialog class methodsFor!

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
		caption: 'Modeless progress...';
		show!

example3
	"A simple modal progress dialog with an alternative view.
		ProgressDialog example3
	"

	^(self 
		create: 'Numeric progress dialog'
		operation: [:progress | 
		10 to: 1 by: -1 do: [:i | progress value: i. Processor sleep: 400 milliseconds]. 'completed'])
			caption: 'Count down ...';
			allowCancel: false;
			showModal!

icon
	"Answers an Icon that can be used to represent this class."

	^ProgressBar icon
!

initialize
	AllowCancelMask := 1.
	IsReusableMask := 2!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Compact_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65664) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 4 410 ##(Smalltalk.ProgressBar) 34 15 nil 416 34 2 8 1140850688 1 640 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 nil nil 7 nil nil nil 640 nil 8 1903758288 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 33 67 578 681 31 640 882 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 33 0 0 0 100 1 0 0 48 0 0 0] 8 #() 578 193 193 nil 27 8 'progress' 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1120 nil nil nil 7 nil nil nil 1120 nil 8 1903849936 786 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 578 33 17 578 681 41 1120 882 #text: 34 1 8 'Description of operation goes here' 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 8 0 0 0 100 1 0 0 28 0 0 0] 8 #() 1088 nil 27 8 'text' nil nil nil nil nil 3 nil nil 578 1081 311 nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 818 138 144 34 3 882 #createAt:extent: 34 2 578 3839 21 578 761 261 416 882 #text: 34 1 8 'Please wait...' 416 882 #updateMenuBar 8 #() 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 251 8 0 0 140 0 0 0] 34 3 1120 640 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1744 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1744 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 578 553 117 578 161 47 1744 882 #text: 34 1 8 '&Cancel' 1744 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 1 0 0 58 0 0 0 100 1 0 0 81 0 0 0] 8 #() 1088 nil 29 1088 nil 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 6 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 672 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 672 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 541 157 578 161 51 672 898 #text: 34 1 8 '&Cancel' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 1 0 0 78 0 0 0 94 1 0 0 103 0 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -159 1138 #fixedParentRight -27 1138 #fixedViewBottom -49 1138 #fixedParentBottom -15 410 ##(Smalltalk.ProgressBar) 34 15 nil 416 34 2 8 1140850688 1 1216 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 nil nil 7 nil nil nil 1216 nil 8 1903758288 852486 ##(Smalltalk.NullConverter) nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 578 31 101 578 671 41 1216 898 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 1216 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 50 0 0 0 94 1 0 0 70 0 0 0] 8 #() 1088 nil 27 1106 1138 #fixedParentLeft 31 1168 -27 1138 #fixedParentTop 101 1138 #fixedViewTop 41 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1680 nil nil nil 7 nil nil nil 1680 nil 8 1903849936 1362 nil nil nil 834 138 144 34 2 898 #createAt:extent: 34 2 578 41 21 578 661 69 1680 898 #text: 34 1 8 'Description of operation goes here
Up to two lines of text permitted' 1680 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 10 0 0 0 94 1 0 0 44 0 0 0] 8 #() 1088 nil 27 1106 1632 41 1168 -27 1648 21 1664 69 170 192 34 4 1216 8 'progress' 1680 8 'text' nil nil nil nil nil 3 nil nil 578 1081 301 578 511 301 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 834 138 144 34 3 898 #createAt:extent: 34 2 578 3839 21 578 761 301 416 898 #text: 34 1 8 'Please wait...' 416 898 #updateMenuBar 8 #() 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 251 8 0 0 160 0 0 0] 34 3 1680 1216 672 1088 nil 27 )!

resource_No_cancel_view
	"Answer the literal data from which the 'No cancel view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_No_cancel_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 672 nil nil nil 5 nil nil nil 672 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 41 21 578 661 65 672 850 #text: 34 1 8 'Description of operation goes here
Up to two lines of text permitted' 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 10 0 0 0 94 1 0 0 42 0 0 0] 8 #() 578 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 41 1090 #fixedParentRight -27 1090 #fixedParentTop 21 1090 #fixedViewTop 65 410 ##(Smalltalk.ProgressBar) 34 15 nil 416 34 2 8 1140850688 1 1168 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 nil nil 5 nil nil nil 1168 nil 8 1915019648 754 nil nil 786 138 144 34 2 850 #createAt:extent: 34 2 578 31 111 578 671 41 1168 850 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 1168 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 55 0 0 0 94 1 0 0 75 0 0 0] 8 #() 1040 nil 27 1058 1104 31 1120 -27 1136 111 1152 41 170 192 34 4 672 8 'text' 1168 8 'progress' nil nil nil nil nil 3 nil nil 578 1081 311 578 511 241 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 786 138 144 34 3 850 #createAt:extent: 34 2 578 1541 951 578 761 261 416 850 #text: 34 1 8 'Please wait...' 416 850 #updateMenuBar 8 #() 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 3 0 0 219 1 0 0 126 4 0 0 93 2 0 0] 34 2 672 1168 1040 nil 27 )!

resource_Numeric_progress_dialog
	"Answer the literal data from which the 'Numeric progress dialog' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Numeric_progress_dialog)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(12582912 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 2 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 640 nil nil nil 7 nil 498 nil true 530 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 592 nil 640 nil 8 1903849936 787206 ##(Smalltalk.NumberToText) nil 8 '' nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 35 27 578 311 71 640 882 #text: 34 1 8 '100' 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 13 0 0 0 172 0 0 0 48 0 0 0] 8 #() 578 193 193 nil 27 8 'progress' nil nil nil nil nil 3 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 818 138 144 34 3 882 #createAt:extent: 34 2 578 3839 21 578 391 251 416 882 #text: 34 1 8 'Please wait...' 416 882 #updateMenuBar 8 #() 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 66 8 0 0 135 0 0 0] 34 2 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1392 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 1392 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 578 103 107 578 171 51 1392 882 #text: 34 1 8 '&Cancel' 1392 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 0 0 0 53 0 0 0 136 0 0 0 78 0 0 0] 8 #() 1072 nil 29 640 1072 nil 27 )!

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

!ProgressDialog class categoriesForMethods!
create:operation:!instance creation!public! !
defaultModel!models!public! !
example1!examples!public! !
example2!examples!public! !
example3!examples!public! !
icon!constants!public! !
initialize!public! !
operation:!instance creation!public! !
resource_Compact_view!public!resources-views! !
resource_Default_view!public!resources-views! !
resource_No_cancel_view!public!resources-views! !
resource_Numeric_progress_dialog!public!resources-views! !
showModal:while:!instance creation!public! !
showModalWhile:!instance creation!public! !
!

