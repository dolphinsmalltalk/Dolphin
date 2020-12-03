"Filed out from Dolphin Smalltalk 7"!

UI.Dialog subclass: #'UI.ProgressDialog'
	instanceVariableNames: 'progressPresenter operation process textPresenter flags priority'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'AllowCancelMask' -> 16r1.
		'IsReusableMask' -> 16r2
	}!
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
!UI.ProgressDialog categoriesFor: #allowCancel!accessing!public! !
!UI.ProgressDialog categoriesFor: #allowCancel:!accessing!public! !
!UI.ProgressDialog categoriesFor: #answer!accessing!public! !
!UI.ProgressDialog categoriesFor: #cancel!commands!public! !
!UI.ProgressDialog categoriesFor: #createComponents!initializing!public! !
!UI.ProgressDialog categoriesFor: #defaultOperation!operations!private! !
!UI.ProgressDialog categoriesFor: #deferredClose!operations!private! !
!UI.ProgressDialog categoriesFor: #forkOperation!operations!public! !
!UI.ProgressDialog categoriesFor: #initialize!initializing!private! !
!UI.ProgressDialog categoriesFor: #isReusable!accessing!public! !
!UI.ProgressDialog categoriesFor: #isReusable:!accessing!public! !
!UI.ProgressDialog categoriesFor: #operation!accessing!public! !
!UI.ProgressDialog categoriesFor: #operation:!accessing!public! !
!UI.ProgressDialog categoriesFor: #priority!accessing!public! !
!UI.ProgressDialog categoriesFor: #priority:!accessing!public! !
!UI.ProgressDialog categoriesFor: #progress!accessing!public! !
!UI.ProgressDialog categoriesFor: #queryCommand:!commands!private! !
!UI.ProgressDialog categoriesFor: #show!operations!public! !
!UI.ProgressDialog categoriesFor: #showModal!operations!public! !
!UI.ProgressDialog categoriesFor: #text:!accessing!public! !
!UI.ProgressDialog categoriesFor: #value:!accessing!public! !

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Compact_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12845056 65664) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 nil 170 192 34 4 410 ##(UI.ProgressBar) 34 15 nil 416 34 2 8 1140850688 1 640 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) 1 nil nil 7 nil nil nil 640 nil 8 1920349872 1049094 ##(UI.NullConverter) nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 33 67 578 681 31 640 882 #range: 34 1 852742 ##(Core.Interval) 1 201 3 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 33 0 0 0 100 1 0 0 48 0 0 0] 8 #() 578 193 193 nil 27 8 'progress' 410 ##(UI.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1120 nil nil nil 7 nil nil nil 1120 nil 8 1920531648 786 nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 578 33 17 578 681 41 1120 882 #text: 34 1 8 'Description of operation goes here' 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 8 0 0 0 100 1 0 0 28 0 0 0] 8 #() 1088 nil 27 8 'text' nil nil nil nil nil 3 nil nil 578 1081 311 nil 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 818 138 144 34 2 882 #createAt:extent: 34 2 578 6143 21 578 761 261 416 882 #text: 34 1 8 'Please wait...' 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 140 0 0 0] 34 3 1120 640 410 ##(UI.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1712 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1712 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 818 138 144 34 2 882 #createAt:extent: 34 2 578 553 117 578 161 47 1712 882 #text: 34 1 8 '&Cancel' 1712 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 1 0 0 58 0 0 0 100 1 0 0 81 0 0 0] 8 #() 1088 nil 29 1088 nil 27)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 1048838 ##(UI.FramingLayout) 170 176 34 6 410 ##(UI.ProgressBar) 34 15 nil 416 34 2 8 1140850688 1 672 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) 1 nil nil 7 nil nil nil 672 nil 8 1920349872 1049094 ##(UI.NullConverter) nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 31 101 578 671 41 672 914 #range: 34 1 852742 ##(Core.Interval) 1 201 3 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 50 0 0 0 94 1 0 0 70 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 31 1170 #fixedParentRight -27 1170 #fixedParentTop 101 1170 #fixedViewTop 41 410 ##(UI.StaticText) 34 16 nil 416 34 2 8 1140850944 1 1248 nil nil nil 7 nil nil nil 1248 nil 8 1920531648 818 nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 41 21 578 661 69 1248 914 #text: 34 1 8 'Description of operation goes here
Up to two lines of text permitted' 1248 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 10 0 0 0 94 1 0 0 44 0 0 0] 8 #() 1120 nil 27 1138 1184 41 1200 -27 1216 21 1232 69 410 ##(UI.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1568 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1568 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 850 138 144 34 2 914 #createAt:extent: 34 2 578 541 157 578 161 51 1568 914 #text: 34 1 8 '&Cancel' 1568 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 1 0 0 78 0 0 0 94 1 0 0 103 0 0 0] 8 #() 1120 nil 29 1138 1170 #fixedViewRight -159 1200 -27 1170 #fixedViewBottom -49 1170 #fixedParentBottom -15 170 192 34 4 672 8 'progress' 1248 8 'text' nil nil nil nil nil 3 nil nil 578 1081 301 578 511 301 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 850 138 144 34 2 914 #createAt:extent: 34 2 578 6143 21 578 761 301 416 914 #text: 34 1 8 'Please wait...' 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 160 0 0 0] 34 3 1248 672 1568 1120 nil 27)!

resource_No_cancel_view
	"Answer the literal data from which the 'No cancel view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_No_cancel_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12845056 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 1048838 ##(UI.FramingLayout) 170 176 34 4 410 ##(UI.StaticText) 34 16 nil 416 34 2 8 1140850944 1 672 nil nil nil 7 nil nil nil 672 nil 8 1920531648 1049094 ##(UI.NullConverter) nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 41 21 578 661 65 672 850 #text: 34 1 8 'Description of operation goes here
Up to two lines of text permitted' 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 10 0 0 0 94 1 0 0 42 0 0 0] 8 #() 578 193 193 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 41 1090 #fixedParentRight -27 1090 #fixedParentTop 21 1090 #fixedViewTop 65 410 ##(UI.ProgressBar) 34 15 nil 416 34 2 8 1140850688 1 1168 918598 2 ##(UI.ValueHolder) nil nil 1441798 ##(Kernel.NeverSearchPolicy) 1 nil nil 7 nil nil nil 1168 nil 8 1920349872 754 nil nil 786 138 144 34 2 850 #createAt:extent: 34 2 578 31 111 578 671 41 1168 850 #range: 34 1 852742 ##(Core.Interval) 1 201 3 1168 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 55 0 0 0 94 1 0 0 75 0 0 0] 8 #() 1040 nil 27 1058 1104 31 1120 -27 1136 111 1152 41 170 192 34 4 672 8 'text' 1168 8 'progress' nil nil nil nil nil 3 nil nil 578 1081 311 578 511 241 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 786 138 144 34 2 850 #createAt:extent: 34 2 578 6143 21 578 761 261 416 850 #text: 34 1 8 'Please wait...' 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 140 0 0 0] 34 2 672 1168 1040 nil 27)!

resource_Numeric_progress_dialog
	"Answer the literal data from which the 'Numeric progress dialog' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Numeric_progress_dialog)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(12582912 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 165 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 655878 ##(Graphics.Point) 193 193 nil 416 nil 170 192 34 2 410 ##(UI.StaticText) 34 16 nil 416 34 2 8 1140850945 1 640 nil nil nil 7 nil 498 nil true 530 8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 592 nil 640 nil 8 1920531648 984134 1 ##(UI.NumberToText) nil 8 '' 1049350 ##(OS.WindowsLocale) 852998 ##(OS.NUMBERFMTW) 8 #[2 0 0 0 1 0 0 0 3 0 0 0 232 149 214 5 200 149 214 5 1 0 0 0] 8 '.' nil 8 ',' 4115 170 192 34 26 8225 3 85 8 'Monday' 37 3 95 8 'Saturday' 31 8 ',' 89 8 'Wednesday' 35 5 93 8 'Friday' 29 8 '.' 87 8 'Tuesday' 97 8 'Sunday' 33 8 '3;0' 91 8 'Thursday' nil nil 1310982 ##(Core.MessageSequence) 138 144 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 35 27 578 311 71 640 1186 #text: 34 1 8 '100' 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 13 0 0 0 172 0 0 0 48 0 0 0] 8 #() 578 193 193 nil 27 8 'progress' nil nil nil nil nil 3 nil nil nil nil 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2005493520 1122 138 144 34 2 1186 #createAt:extent: 34 2 578 6143 21 578 391 251 416 1186 #text: 34 1 8 'Please wait...' 416 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 194 12 0 0 135 0 0 0] 34 2 410 ##(UI.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1664 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1664 nil 8 1920683440 1377606 4 ##(UI.CommandDescription) #cancel 8 '&Cancel' 1 1 nil nil false nil nil nil 1122 138 144 34 2 1186 #createAt:extent: 34 2 578 103 107 578 171 51 1664 1186 #text: 34 1 8 '&Cancel' 1664 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 0 0 0 53 0 0 0 136 0 0 0 78 0 0 0] 8 #() 1376 nil 29 640 1376 nil 27)!

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
!UI.ProgressDialog class categoriesFor: #create:operation:!instance creation!public! !
!UI.ProgressDialog class categoriesFor: #defaultModel!models!public! !
!UI.ProgressDialog class categoriesFor: #example1!examples!public! !
!UI.ProgressDialog class categoriesFor: #example2!examples!public! !
!UI.ProgressDialog class categoriesFor: #example3!examples!public! !
!UI.ProgressDialog class categoriesFor: #icon!constants!public! !
!UI.ProgressDialog class categoriesFor: #operation:!instance creation!public! !
!UI.ProgressDialog class categoriesFor: #resource_Compact_view!public!resources-views! !
!UI.ProgressDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.ProgressDialog class categoriesFor: #resource_No_cancel_view!public!resources-views! !
!UI.ProgressDialog class categoriesFor: #resource_Numeric_progress_dialog!public!resources-views! !
!UI.ProgressDialog class categoriesFor: #showModal:while:!instance creation!public! !
!UI.ProgressDialog class categoriesFor: #showModalWhile:!instance creation!public! !

