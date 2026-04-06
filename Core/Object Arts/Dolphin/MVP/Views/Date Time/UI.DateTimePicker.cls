"Filed out from Dolphin Smalltalk"!

UI.DateTimeCommonControl
	subclass: #'UI.DateTimePicker'
	instanceVariableNames: 'displayFormat'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'DTM_GETMCCOLOR' -> 16r1007.
			'DTM_GETMCFONT' -> 16r100A.
			'DTM_GETMONTHCAL' -> 16r1008.
			'DTM_GETRANGE' -> 16r1003.
			'DTM_GETSYSTEMTIME' -> 16r1001.
			'DTM_SETFORMATW' -> 16r1032.
			'DTM_SETMCCOLOR' -> 16r1006.
			'DTM_SETMCFONT' -> 16r1009.
			'DTM_SETRANGE' -> 16r1004.
			'DTM_SETSYSTEMTIME' -> 16r1002.
			'DTN_CLOSEUP' -> -16r2F1.
			'DTN_DATETIMECHANGE' -> -16r2F7.
			'DTN_DROPDOWN' -> -16r2F2.
			'DTN_FIRST' -> -16r2E4.
			'DTN_FIRST2' -> -16r2F1.
			'DTN_FORMATA' -> -16r2F4.
			'DTN_FORMATQUERYA' -> -16r2F3.
			'DTN_FORMATQUERYW' -> -16r2E6.
			'DTN_FORMATW' -> -16r2E7.
			'DTN_LAST' -> -16r2E9.
			'DTN_LAST2' -> -16r31F.
			'DTN_USERSTRINGA' -> -16r2F6.
			'DTN_USERSTRINGW' -> -16r2E9.
			'DTN_WMKEYDOWNA' -> -16r2F5.
			'DTN_WMKEYDOWNW' -> -16r2E8.
			'DTS_APPCANPARSE' -> 16r10.
			'DTS_LONGDATEFORMAT' -> 16r4.
			'DTS_RIGHTALIGN' -> 16r20.
			'DTS_SHORTDATEFORMAT' -> 16r0.
			'DTS_SHOWNONE' -> 16r2.
			'DTS_TIMEFORMAT' -> 16r9.
			'DTS_UPDOWN' -> 16r1
		}!

UI.DateTimePicker guid: (Core.GUID fromString: '{87b4c735-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.DateTimePicker comment: '`DateTimePicker` is a `<valueView>` implementing the Windows "SysDateTimePick32" common control, referred to as the "Date and Time Picker Control" in the MSDN documentation. 

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

!UI.DateTimePicker categoriesForClass!MVP-Views! !

!UI.DateTimePicker methodsFor!

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
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

	^##(200 @ 25)!

displayFormat
	"Answer the display format string for the receiver, or nil if it is using the
	default for the current mode"

	^displayFormat!

displayFormat: aStringOrNil
	"Set the display format string for the receiver to aStringOrNil.
	If nil the receiver returns to using the default format for the current mode"

	displayFormat := aStringOrNil.
	self dtmSetFormat: aStringOrNil!

dtmSetFormat: aStringFormat
	"Set the display format of the receiver to aStringFormat"

	self sendMessage: DTM_SETFORMATW wParam: 0 lpParam: aStringFormat asUtf16String.!

dtmSetSystemTime: wFlags lpSysTime: aSYSTEMTIME
	"Set the receiver's system time to aSYSTEMTIME or set it to none if the argument is nil."

	self
		sendMessageNz: DTM_SETSYSTEMTIME
		wParam: wFlags
		lpParam: aSYSTEMTIME asParameter!

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
	"Answers true if the receiver's calendar drop down is right aligned."

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

	^self isTimeMode ifTrue: [Time] ifFalse: [Date]!

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
		ifTrue: [self canShowNone ifTrue: [gd := GDT_NONE] ifFalse: [st := DateAndTime now asSYSTEMTIME]].
	self dtmSetSystemTime: gd lpSysTime: st!

stateText
	^''! !

!UI.DateTimePicker categoriesForMethods!
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
stateText!accessing!private! !
!

!UI.DateTimePicker class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^Date today asValue!

themePartName
	^'DATEPICKER'!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysDateTimePick32'! !

!UI.DateTimePicker class categoriesForMethods!
defaultModel!models!public! !
themePartName!constants!private!theming! !
winClassName!constants!private! !
!

