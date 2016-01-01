"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #ProgressDialog
	instanceVariableNames: 'progressPresenter operation process textPresenter flags priority'
	classVariableNames: 'AllowCancelMask IsReusableMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProgressDialog guid: (GUID fromString: '{87B4C6AB-026E-11D3-9FD7-00A0CC3E4A32}')!
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
!ProgressDialog categoriesFor: #allowCancel!accessing!public! !
!ProgressDialog categoriesFor: #allowCancel:!accessing!public! !
!ProgressDialog categoriesFor: #answer!accessing!public! !
!ProgressDialog categoriesFor: #cancel!commands!public! !
!ProgressDialog categoriesFor: #createComponents!initializing!public! !
!ProgressDialog categoriesFor: #defaultOperation!operations!private! !
!ProgressDialog categoriesFor: #deferredClose!operations!private! !
!ProgressDialog categoriesFor: #forkOperation!operations!public! !
!ProgressDialog categoriesFor: #initialize!initializing!private! !
!ProgressDialog categoriesFor: #isReusable!accessing!public! !
!ProgressDialog categoriesFor: #isReusable:!accessing!public! !
!ProgressDialog categoriesFor: #operation!accessing!public! !
!ProgressDialog categoriesFor: #operation:!accessing!public! !
!ProgressDialog categoriesFor: #priority!accessing!public! !
!ProgressDialog categoriesFor: #priority:!accessing!public! !
!ProgressDialog categoriesFor: #progress!accessing!public! !
!ProgressDialog categoriesFor: #queryCommand:!commands!private! !
!ProgressDialog categoriesFor: #show!operations!public! !
!ProgressDialog categoriesFor: #showModal!operations!public! !
!ProgressDialog categoriesFor: #text:!accessing!public! !
!ProgressDialog categoriesFor: #value:!accessing!public! !

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
		1 to: 100 do: [:i | Processor sleep: 30. progress value: i; text: i displayString, '%']. 'completed']!

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
					Processor sleep: 100.
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
		10 to: 1 by: -1 do: [:i | progress value: i. Processor sleep: 400]. 'completed'])
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 25690113 131329 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 0 234 256 98 4 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850944 1 560 0 0 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 66 108 97 99 107 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 0 8 4294903241 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 722 33 17 722 681 41 560 866 8 #text: 98 1 8 'Description of operation goes here' 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 8 0 0 0 100 1 0 0 28 0 0 0] 98 0 722 193 193 0 27 8 'text' 410 8 ##(Smalltalk.ProgressBar)  98 15 0 416 98 2 8 1140850688 1 1120 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  1 482 8 4278190080 0 7 0 0 0 1120 0 8 4294903207 770 0 0 802 202 208 98 2 866 896 98 2 722 33 67 722 681 31 1120 866 8 #range: 98 1 525062 ##(Smalltalk.Interval)  1 201 3 1120 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 33 0 0 0 100 1 0 0 48 0 0 0] 98 0 1088 0 27 8 'progress' 0 0 0 0 0 3 0 0 722 1081 311 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1996696576 802 202 208 98 3 866 896 98 2 722 5119 21 722 761 251 416 866 976 98 1 8 'Please wait...' 416 866 8 #updateMenuBar 98 0 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 123 11 0 0 135 0 0 0] 98 3 560 1120 410 8 ##(Smalltalk.PushButton)  98 20 0 416 98 2 8 1140924416 1 1904 0 482 1280 0 7 0 0 0 1904 0 8 4294903211 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 '&Cancel' 1 1 0 0 32 0 0 0 802 202 208 98 2 866 896 98 2 722 553 117 722 161 41 1904 866 976 98 1 8 '&Cancel' 1904 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 1 0 0 58 0 0 0 100 1 0 0 78 0 0 0] 98 0 1088 0 29 1088 0 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 25690113 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 6 410 8 ##(Smalltalk.PushButton)  98 20 0 416 98 2 8 1140924416 1 592 0 482 512 0 7 0 0 0 592 0 8 4294903211 1180998 4 ##(Smalltalk.CommandDescription)  8 #cancel 8 '&Cancel' 1 1 0 0 32 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  541 171 898 161 51 592 834 8 #text: 98 1 8 '&Cancel' 592 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 1 0 0 85 0 0 0 94 1 0 0 110 0 0 0] 98 0 898 193 193 0 29 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedViewRight -159 1122 8 #fixedParentRight -27 1122 8 #fixedViewBottom -49 1122 8 #fixedParentBottom -11 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850944 1 1264 0 0 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 898 193 193 0 1264 0 8 4294903241 852486 ##(Smalltalk.NullConverter)  0 0 0 770 202 208 98 2 834 864 98 2 898 41 21 898 661 81 1264 834 960 98 1 8 'Description of operation goes here
Up to two lines of text permitted' 1264 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 10 0 0 0 94 1 0 0 50 0 0 0] 98 0 1072 0 27 1090 1122 8 #fixedParentLeft 41 1168 -27 1122 8 #fixedParentTop 21 1122 8 #fixedViewTop 81 410 8 ##(Smalltalk.ProgressBar)  98 15 0 416 98 2 8 1140850688 1 1808 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  1 482 512 0 7 0 0 0 1808 0 8 4294903207 1458 0 0 770 202 208 98 2 834 864 98 2 898 31 121 898 671 41 1808 834 8 #range: 98 1 525062 ##(Smalltalk.Interval)  1 201 3 1808 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 60 0 0 0 94 1 0 0 80 0 0 0] 98 0 1072 0 27 1090 1712 31 1168 -27 1744 121 1776 41 234 256 98 4 1808 8 'progress' 1264 8 'text' 0 0 0 0 0 3 0 0 898 1081 311 898 511 291 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1996696576 770 202 208 98 3 834 864 98 2 898 5119 21 898 761 311 416 834 960 98 1 8 'Please wait...' 416 834 8 #updateMenuBar 98 0 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 123 11 0 0 165 0 0 0] 98 3 1264 1808 592 1072 0 27 )!

resource_No_cancel_view
	"Answer the literal data from which the 'No cancel view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_No_cancel_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 25690113 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.ProgressBar)  98 15 0 416 98 2 8 1140850688 1 592 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  1 482 512 0 7 0 0 0 592 0 8 4294903207 852486 ##(Smalltalk.NullConverter)  0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  31 121 930 671 41 592 866 8 #range: 98 1 525062 ##(Smalltalk.Interval)  1 201 3 592 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 60 0 0 0 94 1 0 0 80 0 0 0] 98 0 930 193 193 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentLeft 31 1170 8 #fixedParentRight -27 1170 8 #fixedParentTop 121 1170 8 #fixedViewTop 41 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850944 1 1312 0 0 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 84 114 101 98 117 99 104 101 116 32 77 83 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 930 193 193 0 1312 0 8 4294903241 770 0 0 0 802 202 208 98 2 866 896 98 2 930 41 21 930 661 81 1312 866 8 #text: 98 1 8 'Description of operation goes here
Up to two lines of text permitted' 1312 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 10 0 0 0 94 1 0 0 50 0 0 0] 98 0 1120 0 27 1138 1184 41 1216 -27 1248 21 1280 81 234 256 98 4 592 8 'progress' 1312 8 'text' 0 0 0 0 0 3 0 0 930 1081 311 930 511 241 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 1996696576 802 202 208 98 3 866 896 98 2 930 5119 21 930 761 261 416 866 1648 98 1 8 'Please wait...' 416 866 8 #updateMenuBar 98 0 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 123 11 0 0 140 0 0 0] 98 2 1312 592 1120 0 27 )!

resource_Numeric_progress_dialog
	"Answer the literal data from which the 'Numeric progress dialog' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Numeric_progress_dialog)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(DialogView)  98 30 0 0 98 2 25165825 131073 416 0 524550 ##(ColorRef)  8 4278190080 0 133 0 0 0 416 0 234 256 98 2 410 8 ##(StaticText)  98 16 0 416 98 2 8 1140850945 1 560 0 0 0 5 0 263174 ##(Font)  0 16 459014 ##(LOGFONT)  8 #[237 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Point)  193 193 0 560 0 8 4294906439 787206 ##(NumberToText)  0 8 '' 0 0 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 722 35 27 722 311 71 560 882 8 #text: 98 1 8 '100' 560 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 13 0 0 0 172 0 0 0 48 0 0 0] 98 0 722 193 193 0 27 8 'progress' 0 0 0 0 0 13857 0 0 0 0 1 0 0 590598 ##(Semaphore)  0 0 1 0 8 2010572111 818 202 208 98 3 882 912 98 2 722 1405 1075 722 391 251 416 882 992 98 1 8 'Please wait...' 416 882 8 #menuBar: 98 1 0 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 2 0 0 25 2 0 0 129 3 0 0 150 2 0 0] 98 3 410 8 ##(PushButton)  98 17 0 416 98 2 8 1140924416 1 1440 0 482 512 0 5 0 0 0 1440 0 8 4294906781 1180998 4 ##(CommandDescription)  8 #ok 8 '&OK' 1 1 0 0 16 818 202 208 98 2 882 912 98 2 722 35 457 722 171 61 1440 882 992 98 1 8 '&OK' 1440 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 17 0 0 0 228 0 0 0 102 0 0 0 2 1 0 0] 98 0 1104 0 27 410 1456 98 17 0 416 98 2 8 1140924416 1 1824 0 482 512 0 5 0 0 0 1824 0 8 4294906781 1554 8 #cancel 8 '&Cancel' 1 1 0 0 32 818 202 208 98 2 882 912 98 2 722 105 117 722 171 51 1824 882 992 98 1 8 '&Cancel' 1824 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 0 0 0 58 0 0 0 137 0 0 0 83 0 0 0] 98 0 1104 0 27 560 1104 0 27 )!

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
!ProgressDialog class categoriesFor: #create:operation:!instance creation!public! !
!ProgressDialog class categoriesFor: #defaultModel!models!public! !
!ProgressDialog class categoriesFor: #example1!examples!public! !
!ProgressDialog class categoriesFor: #example2!examples!public! !
!ProgressDialog class categoriesFor: #example3!examples!public! !
!ProgressDialog class categoriesFor: #icon!constants!public! !
!ProgressDialog class categoriesFor: #initialize!public! !
!ProgressDialog class categoriesFor: #operation:!instance creation!public! !
!ProgressDialog class categoriesFor: #resource_Compact_view!public!resources-views! !
!ProgressDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!ProgressDialog class categoriesFor: #resource_No_cancel_view!public!resources-views! !
!ProgressDialog class categoriesFor: #resource_Numeric_progress_dialog!public!resources-views! !
!ProgressDialog class categoriesFor: #showModal:while:!instance creation!public! !
!ProgressDialog class categoriesFor: #showModalWhile:!instance creation!public! !

