"Filed out from Dolphin Smalltalk"!

DateTimeCommonControl subclass: #DateTimePicker
	instanceVariableNames: 'displayFormat'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DateTimePicker guid: (GUID fromString: '{87b4c735-026e-11d3-9fd7-00a0cc3e4a32}')!
DateTimePicker comment: '`DateTimePicker` is a `<valueView>` implementing the Windows "SysDateTimePick32" common control, referred to as the "Date and Time Picker Control" in the MSDN documentation. 

The `<valueModel>` associated with a `DateTimePicker` must always yield a value that can be converted to a `SYSTEMTIME` by sending it `#asParameter` after mapping through the installed type converter (e.g. a `DateAndTime`). A `DateTimePicker` will normally be used in conjunction with a `DatePresenter` or a `TimePresenter`, and indeed when the class'' package is installed a `DateTimePicker` is used as the default views for both presenters.

## Example Usage:

```
	t := Time now asValue.
	p := TimePresenter showOn: t.
	t value.
```
Or:
```
	d := Date today asValue.
	p := DatePresenter showOn: d.
	d value
```

## Instance Variables:
  `displayFormat`		`String` or nil

'!
!DateTimePicker categoriesForClass!MVP-Views! !
!DateTimePicker methodsFor!

canShowNone
	"Answers true if the receiver can set no date or time"

	^self baseStyleAllMask: DTS_SHOWNONE!

canShowNone: aBoolean 
	"Sets the receiver to allow no time or date to be set if aBoolean is true."

	self 
		baseStyleMask: DTS_SHOWNONE
		set: aBoolean
		recreateIfChanged: true	"Recreate required for this change to take effect"!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to
	set the size of a view when it is created. Thereafter preferredExtent is
	used when the desired size of a view is requested."

	^##(200 @ 25)!

displayFormat
	"Answer the display format string for the receiver, or nil if it is using the
	default for the current mode"

	^displayFormat!

displayFormat: aStringOrNil
	"Set the display format string for the receiver to aStringrNil.
	If nil the receiver returns to using the default format for the current mode"

	displayFormat := aStringOrNil.
	self dtmSetFormat: aStringOrNil!

dtmSetFormat: aStringFormat
	"Set the display format of the receiver to aStringFormat"

	self sendMessage: DTM_SETFORMATW wParam: 0 lpParam: aStringFormat asUtf16String.!

dtmSetSystemTime: wFlags lpSysTime: aSYSTEMTIME
	"Set the receivers system time to aSYSTEMTIME or set it to none if the argument is nil."

	(self sendMessage: DTM_SETSYSTEMTIME wParam: wFlags lpParam: aSYSTEMTIME asParameter) == 0
		ifTrue: [ self errorInCommonControlCall ]!

dtnDateTimeChange: pNMHDR
	"The systemtime has been changed by the user."

	self updateModel.
	^0!

dtNotificationMap
	^##((Array new: DTN_FIRST - DTN_DATETIMECHANGE + 1 withAll: #nmDummy:)
		at: DTN_FIRST - DTN_DATETIMECHANGE + 1 put: #dtnDateTimeChange:;
		yourself)!

getRangeMessage
	^DTM_GETRANGE!

getSystemTime
	"Private - Answer the SYSTEMTIME of the receiver or nil if none selected."

	| time messageAnswer |
	time := SYSTEMTIME new.
	messageAnswer := self 
				sendMessage: DTM_GETSYSTEMTIME
				wParam: 0
				lpParam: time asParameter.
	^messageAnswer == GDT_VALID 
		ifTrue: [time]
		ifFalse: [messageAnswer == GDT_NONE ifFalse: [self errorInCommonControlCall]]!

hasLongDateFormat
	"Answers true if the receiver has long date format."

	^self baseStyleAllMask: DTS_LONGDATEFORMAT!

hasLongDateFormat: aBoolean 
	"Sets the receiver to have long date format to be set if aBoolean is true."

	self 
		baseStyleMask: DTS_LONGDATEFORMAT
		set: aBoolean
		recreateIfChanged: false!

hasUpDown
	"Answers true if the receiver has up down controls."

	^self baseStyleAllMask: DTS_UPDOWN!

hasUpDown: aBoolean 
	"Sets the receiver to have an up down control if aBoolean is true."

	self 
		baseStyleMask: DTS_UPDOWN
		set: aBoolean
		recreateIfChanged: true	"Recreate required for this change to take effect"!

isRightAligned
	"Answers true if the receivers calendar drop down is right aligned."

	^self baseStyleAllMask: DTS_RIGHTALIGN!

isRightAligned: aBoolean 
	"Sets the receiver to have right aligned calendar drop down to be set if aBoolean is true."

	self 
		baseStyleMask: DTS_RIGHTALIGN
		set: aBoolean
		recreateIfChanged: false!

isTimeMode
	"Answers true if the receiver is in time mode rather than date."

	^self baseStyleAllMask: DTS_TIMEFORMAT!

isTimeMode: aBoolean 
	"Sets the receiver to be in time mode if aBoolean is true."

	self 
		baseStyleMask: DTS_TIMEFORMAT
		set: aBoolean
		recreateIfChanged: false!

modelClass
	"Private - Answer the expected class of model, either Date or Time depending
	on the current mode set"

	^self isTimeMode ifTrue: [Time] ifFalse: [Date]
!

nmFirst
	^DTN_FIRST + 1!

onViewCreated
	"The receiver window has been created. Finish the job and apply any
	non default display format"

	super onViewCreated.
	self displayFormat notNil ifTrue: [self dtmSetFormat: self displayFormat]!

setRangeMessage
	^DTM_SETRANGE!

setSystemTime: aSYSTEMTIMEOrNil 
	"Private - Set the control's current date/time to the <SYSTEMTIME> argument, or 'none' if the argument is nil."

	| gd st |
	gd := GDT_VALID.
	st := aSYSTEMTIMEOrNil.
	aSYSTEMTIMEOrNil isNil 
		ifTrue: 
			[self canShowNone ifTrue: [gd := GDT_NONE] ifFalse: [st := DateAndTime now asSYSTEMTIME]].
	self dtmSetSystemTime: gd lpSysTime: st! !
!DateTimePicker categoriesForMethods!
canShowNone!accessing-styles!public! !
canShowNone:!accessing-styles!public! !
defaultExtent!constants!private! !
displayFormat!accessing!public! !
displayFormat:!accessing!public! !
dtmSetFormat:!accessing!public! !
dtmSetSystemTime:lpSysTime:!accessing!public! !
dtnDateTimeChange:!event handling-win32!public! !
dtNotificationMap!private! !
getRangeMessage!constants!private! !
getSystemTime!accessing!private! !
hasLongDateFormat!accessing-styles!public! !
hasLongDateFormat:!accessing-styles!public! !
hasUpDown!accessing-styles!public! !
hasUpDown:!accessing-styles!public! !
isRightAligned!accessing-styles!public! !
isRightAligned:!accessing-styles!public! !
isTimeMode!accessing-styles!public! !
isTimeMode:!accessing-styles!public! !
modelClass!accessing!private! !
nmFirst!constants!private! !
onViewCreated!event handling!public! !
setRangeMessage!constants!private! !
setSystemTime:!accessing!private! !
!

!DateTimePicker class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^Date today asValue!

themePartName
	^'DATEPICKER'!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysDateTimePick32'! !
!DateTimePicker class categoriesForMethods!
defaultModel!models!public! !
themePartName!constants!private!theming! !
winClassName!constants!private! !
!

