"Filed out from Dolphin Smalltalk"!

ValueConvertingControlView subclass: #DateTimeCommonControl
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'DateTimeCommCtrlConstants'
	classInstanceVariableNames: ''!
DateTimeCommonControl guid: (GUID fromString: '{6c107e8a-4cd1-474f-bb07-c61aac8c12c9}')!
DateTimeCommonControl isAbstract: true!
DateTimeCommonControl comment: '`DateTimeCommonControl` is the abstract class of `<valueView>`s implementing the Windows date/time common controls. 

The `<valueModel>` associated with a `DateTimeCommonControl` must always yield a value that can be converted to a `SYSTEMTIME` using `#asParameter` after mapping through the installed type converter (e.g. a `DateAndTime`). A DateTimeCommonControl will normally be used in conjunction with a <DatePresenter>, or in some cases a <TimePresenter>.



'!
!DateTimeCommonControl categoriesForClass!MVP-Views! !
!DateTimeCommonControl methodsFor!

displayValue
	"Private - Answer the displayed contents of the receiver as a <Date> or <Time>,
	as appropriate, according to the current mode, or nil if no value is set."

	^self getSystemTime ifNotNil: [:systime | self modelClass fromSYSTEMTIME: systime]!

displayValue: aDateOrTimeOrNil 
	"Private - Set the displayed contents of the receiver from the argument."

	self displayValue = aDateOrTimeOrNil ifTrue: [^self].
	self setSystemTime: (aDateOrTimeOrNil notNil ifTrue: [aDateOrTimeOrNil asSYSTEMTIME])!

dtNotificationMap
	^self subclassResponsibility!

getRangeMessage
	^self subclassResponsibility!

getSystemTime
	^self subclassResponsibility!

maximum
	"Answer the maximum date/time allowed by the receiver, or nil
	if not limit is imposed"

	^self range last ifNotNil: [:max | self modelClass fromSYSTEMTIME: max]!

maximum: aDateOrTimeOrNil
	"Set the maximum date/time allowed by the receiver to aDateOrTimeOrNil.
	If nil then no maximum is imposed"

	| range |
	range := self range.
	range at: 2 put: (aDateOrTimeOrNil notNil ifTrue: [aDateOrTimeOrNil asSYSTEMTIME]).
	self range: range!

minimum
	"Answer the minimum date/time allowed by the receiver, or nil
	if no limit is imposed"

	^self range first ifNotNil: [:min | self modelClass fromSYSTEMTIME: min]!

minimum: aDateOrTimeOrNil
	"Set the minimum time stamp allowed by the receiver to aDateOrTimeOrNil.
	If nil then no minimum is imposed"

	| range |
	range := self range.
	range at: 1 put: (aDateOrTimeOrNil notNil ifTrue: [aDateOrTimeOrNil asSYSTEMTIME]).
	self range: range!

modelClass
	"Private - Answer the expected class of model."

	^self subclassResponsibility!

nmFirst
	^self subclassResponsibility!

nmNotify: pNMHDR
	"Private - Handler for a redirected MonthCal WM_NOTIFY message."

	^(self dtNotificationMap lookup: self nmFirst - (pNMHDR sdwordAtOffset: 8))
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

range
	"Answer a collection whose first element is either the minimum allowable SYSTEMTIME
	or nil if there is none, and its last element is the maximum allowable SYSTEMTIME
	or nil if there is none."

	| array gd |
	array := StructureArray length: 2 elementClass: SYSTEMTIME.
	array beUnfinalizable.
	gd := self 
				sendMessage: self getRangeMessage
				wParam: 0
				lpParam: array asParameter.
	^Array with: ((gd anyMask: GDTR_MIN) ifTrue: [(array at: 1) copy])
		with: ((gd anyMask: GDTR_MAX) ifTrue: [(array at: 2) copy])!

range: interval 
	"Set the allowable range of values. The first element of interval if either the
	minimum allowable SYSTEMTIME or nil if there isn't one. The last element is either the
	maximum allowable SYSTEMTIME or nil if there isn't one."

	| array gd |
	gd := 0.
	array := StructureArray length: 2 elementClass: SYSTEMTIME.
	array beUnfinalizable.
	interval first notNil 
		ifTrue: 
			[array at: 1 put: interval first asSYSTEMTIME.
			gd := gd bitOr: GDTR_MIN].
	interval last notNil 
		ifTrue: 
			[array at: 2 put: interval last asSYSTEMTIME.
			gd := gd bitOr: GDTR_MAX].
	(self 
		sendMessage: self setRangeMessage
		wParam: gd
		lpParam: array asParameter) asBoolean 
		ifFalse: [^self errorInCommonControlCall]!

setRangeMessage
	^self subclassResponsibility!

setSystemTime: aSYSTEMTIMEOrNil 
	"Private - Set the control's current date/time to the <SYSTEMTIME> arugment,
	or set it to none if the argument is nil."

	^self subclassResponsibility!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	^super state
		add: (MessageSend receiver: self selector: #range: argument: self range);
		yourself! !
!DateTimeCommonControl categoriesForMethods!
displayValue!private!updating! !
displayValue:!private!updating! !
dtNotificationMap!private! !
getRangeMessage!constants!private! !
getSystemTime!accessing!private! !
maximum!accessing!public! !
maximum:!accessing!public! !
minimum!accessing!public! !
minimum:!accessing!public! !
modelClass!accessing!private! !
nmFirst!constants!private! !
nmNotify:!event handling-win32!private! !
range!accessing!public! !
range:!accessing!public! !
setRangeMessage!constants!private! !
setSystemTime:!accessing!private! !
state!accessing!private! !
!

!DateTimeCommonControl class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - 
	self initialize.
	"

	CommCtrlLibrary
		initFlags: (CommCtrlLibrary initFlags maskSet: ICC_DATE_CLASSES);
		closeDefault!

uninitialize
	CommCtrlLibrary initFlags: (CommCtrlLibrary initFlags maskClear: ICC_DATE_CLASSES)! !
!DateTimeCommonControl class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!public! !
!

