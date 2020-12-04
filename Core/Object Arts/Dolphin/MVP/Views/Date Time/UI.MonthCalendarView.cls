"Filed out from Dolphin Smalltalk 7"!

UI.DateTimeCommonControl subclass: #'UI.MonthCalendarView'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.MonthCalendarView guid: (Core.GUID fromString: '{7a3bc35d-5d09-4328-91de-d863711be2ea}')!
UI.MonthCalendarView comment: '`MonthCalendarView` is a `<valueView>` implementing the Windows "SysMonthCal32" common control, referred to as the "Month Calendar Control" in the MSDN documentation. 

The `<valueModel>` associated with a `MonthCalendarView` must always yield a value that can be converted to a `SYSTEMTIME` using `#asSYSTEMTIME` after mapping through the installed type converter (e.g. a `DateAndTime`), although any time portion is ignored. A `MonthCalendarView` will normally be used in conjunction with a `DatePresenter`.
'!
!UI.MonthCalendarView categoriesForClass!MVP-Views! !
!UI.MonthCalendarView methodsFor!

calculateExtent: aLayoutContext 
	"Private - Answer a calculated preferred extent for the receiver."

	#todo.	"Work out preferred extent for multiple months, depending on configuration - see MSDN"
	^self mcmGetMinReqRect extent!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^##(200 @ 200)!

dtNotificationMap
	^##((Array new: MCN_FIRST - MCN_LAST + 1 withAll: #nmDummy:)
		at: MCN_FIRST - MCN_SELECT + 1 put: #mcnSelect:;
		at: MCN_FIRST - MCN_GETDAYSTATE + 1 put: #nmDummy:;
		at: MCN_FIRST - MCN_SELCHANGE + 1 put: #mcnSelChange:;
		at: MCN_FIRST - MCN_VIEWCHANGE + 1 put: #nmDummy:;
		yourself)!

firstDayOfWeek
	"Answer the <integer> number of the first day of the week, with 0 being Monday thru 6 for Sunday."

	^self mcmGetFirstDayOfWeek lowWord + 1!

firstDayOfWeek: anInteger 
	self mcmSetFirstDayOfWeek: anInteger - 1!

getRangeMessage
	^MCM_GETRANGE!

getSystemTime
	| answer |
	answer := SYSTEMTIME new.
	^(self
		sendMessage: MCM_GETCURSEL
		wParam: 0
		lpParam: answer) asBoolean ifTrue: [answer]!

hasToday
	"Answers whether the receiver displays todays date in  text at the bottom
	of the view."

	^(self baseStyleAllMask: MCS_NOTODAY) not!

hasToday: aBoolean 
	self 
		baseStyleMask: MCS_NOTODAY
		set: aBoolean not
		recreateIfChanged: false!

hasTodayCircle
	"Answers whether the receiver circles todays date in the calendar.
	Note that on Windows XP, with the default theme, this is actually a 
	red square border around the cell for the current date."

	^(self baseStyleAllMask: MCS_NOTODAYCIRCLE) not!

hasTodayCircle: aBoolean 
	self 
		baseStyleMask: MCS_NOTODAYCIRCLE
		set: aBoolean not
		recreateIfChanged: false!

hasWeekNumbers
	"Answers whether the receiver displays week numbers to the left of the rows."

	^self baseStyleAllMask: MCS_WEEKNUMBERS!

hasWeekNumbers: aBoolean 
	self 
		baseStyleMask: MCS_WEEKNUMBERS
		set: aBoolean
		recreateIfChanged: false!

mcmGetFirstDayOfWeek
	^self sendMessage: MCM_GETFIRSTDAYOFWEEK!

mcmGetMinReqRect
	| rect |
	rect := RECTL new.
	self
		sendMessage: MCM_GETMINREQRECT
		wParam: 0
		lpParam: rect.
	^rect asRectangle!

mcmGetToday
	| answer |
	answer := SYSTEMTIME new.
	^(self
		sendMessage: MCM_GETTODAY
		wParam: 0
		lpParam: answer) asBoolean ifTrue: [answer]!

mcmSetFirstDayOfWeek: anInteger 
	^self 
		sendMessage: MCM_SETFIRSTDAYOFWEEK
		wParam: 0
		lpParam: (anInteger bitAnd: 16rFFFF)!

mcnSelChange: pNMHDR 
	self updateModel.
	^0!

mcnSelect: pNMHDR
	^0
!

modelClass
	"Private - Answer the expected class of model."

	^Date!

nmFirst
	^MCN_FIRST + 1!

onViewCreated
	"The receiver window has been created. Copy the info held in instance variables across to
	it."

	super onViewCreated.
	self setControlBackcolor!

setControlBackcolor: aColor 
	"The control itself defaults to 'Color window' for its background"

	self 
		sendMessage: MCM_SETCOLOR
		wParam: MCSC_BACKGROUND
		lParam: aColor asCOLORREF!

setRangeMessage
	^MCM_SETRANGE!

setSystemTime: aSYSTEMTIME 
	"Private - Set the control's current date/time to the <SYSTEMTIME> arugment."

	self 
		sendMessage: MCM_SETCURSEL
		wParam: 0
		lpParam: aSYSTEMTIME!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	^super state
		add: (MessageSend
					receiver: self
					selector: #mcmSetFirstDayOfWeek:
					argument: self mcmGetFirstDayOfWeek lowWord);
		yourself!

today
	^self mcmGetToday asDate! !
!UI.MonthCalendarView categoriesFor: #calculateExtent:!geometry!private! !
!UI.MonthCalendarView categoriesFor: #defaultExtent!constants!private! !
!UI.MonthCalendarView categoriesFor: #dtNotificationMap!private! !
!UI.MonthCalendarView categoriesFor: #firstDayOfWeek!accessing!public! !
!UI.MonthCalendarView categoriesFor: #firstDayOfWeek:!accessing!public! !
!UI.MonthCalendarView categoriesFor: #getRangeMessage!constants!private! !
!UI.MonthCalendarView categoriesFor: #getSystemTime!accessing!private! !
!UI.MonthCalendarView categoriesFor: #hasToday!accessing-styles!public! !
!UI.MonthCalendarView categoriesFor: #hasToday:!accessing-styles!public! !
!UI.MonthCalendarView categoriesFor: #hasTodayCircle!accessing-styles!public! !
!UI.MonthCalendarView categoriesFor: #hasTodayCircle:!accessing-styles!public! !
!UI.MonthCalendarView categoriesFor: #hasWeekNumbers!accessing-styles!public! !
!UI.MonthCalendarView categoriesFor: #hasWeekNumbers:!accessing-styles!public! !
!UI.MonthCalendarView categoriesFor: #mcmGetFirstDayOfWeek!accessing!private! !
!UI.MonthCalendarView categoriesFor: #mcmGetMinReqRect!accessing!private! !
!UI.MonthCalendarView categoriesFor: #mcmGetToday!accessing!private! !
!UI.MonthCalendarView categoriesFor: #mcmSetFirstDayOfWeek:!accessing!private! !
!UI.MonthCalendarView categoriesFor: #mcnSelChange:!event handling-win32!private! !
!UI.MonthCalendarView categoriesFor: #mcnSelect:!event handling-win32!private! !
!UI.MonthCalendarView categoriesFor: #modelClass!accessing!private! !
!UI.MonthCalendarView categoriesFor: #nmFirst!constants!private! !
!UI.MonthCalendarView categoriesFor: #onViewCreated!event handling!public! !
!UI.MonthCalendarView categoriesFor: #setControlBackcolor:!accessing!private! !
!UI.MonthCalendarView categoriesFor: #setRangeMessage!constants!private! !
!UI.MonthCalendarView categoriesFor: #setSystemTime:!accessing!private! !
!UI.MonthCalendarView categoriesFor: #state!accessing!private! !
!UI.MonthCalendarView categoriesFor: #today!accessing!public! !

!UI.MonthCalendarView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^Date today asValue!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysMonthCal32'! !
!UI.MonthCalendarView class categoriesFor: #defaultModel!models!public! !
!UI.MonthCalendarView class categoriesFor: #winClassName!constants!private! !

