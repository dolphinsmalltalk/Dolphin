"Filed out from Dolphin Smalltalk"!

SQL_INTERVAL_STRUCT
	subclass: #SQL_DAY_SECOND_STRUCT
	instanceVariableNames: 'scaleExp'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_day' -> 16r8.
			'_OffsetOf_fraction' -> 16r18.
			'_OffsetOf_hour' -> 16rC.
			'_OffsetOf_minute' -> 16r10.
			'_OffsetOf_second' -> 16r14.
			'_SQL_DAY_SECOND_STRUCT_Size' -> 16r1C.
			'DefaultFractionScaler' -> 16rF4240
		}!

SQL_DAY_SECOND_STRUCT guid: (Core.GUID fromString: '{57e065d6-15bb-4a76-b1ab-892cbb690cd7}')!

SQL_DAY_SECOND_STRUCT comment: ''!

!SQL_DAY_SECOND_STRUCT categoriesForClass!External-Data-Structured! !

!SQL_DAY_SECOND_STRUCT methodsFor!

= anExternalStructure
	self == anExternalStructure ifTrue: [^true].
	self species == anExternalStructure species ifFalse: [^false].
	(self isNull or: [anExternalStructure isNull]) ifTrue: [^self isNull == anExternalStructure isNull].
	^self asSeconds = anExternalStructure asSeconds!

asDuration
	^self duration!

asSeconds
	"Answer the total <Number> of seconds in the interval described by the receiver."

	^((##((Array new: 13 withAll: [:interval | interval errorWrongIntervalType])
		at: SQL_IS_DAY put: [:interval | interval day * SecondsPerDay];
		at: SQL_IS_HOUR put: [:interval | interval hour * 3600];
		at: SQL_IS_MINUTE put: [:interval | interval minute * 60];
		at: SQL_IS_SECOND put: [:interval | interval getSeconds];
		at: SQL_IS_DAY_TO_HOUR put: [:interval | (interval day * 24 + interval hour) * 3600];
		at: SQL_IS_DAY_TO_MINUTE
			put: [:interval | ((interval day * 24 + interval hour) * 60 + interval minute) * 60];
		at: SQL_IS_DAY_TO_SECOND
			put: [:interval | ((interval day * 24 + interval hour) * 60 + interval minute) * 60 + interval getSeconds];
		at: SQL_IS_HOUR_TO_MINUTE put: [:interval | (interval hour * 60 + interval minute) * 60];
		at: SQL_IS_HOUR_TO_SECOND
			put: [:interval | (interval hour * 60 + interval minute) * 60 + interval getSeconds];
		at: SQL_IS_MINUTE_TO_SECOND put: [:interval | interval minute * 60 + interval getSeconds];
		yourself) at: self interval_type)
		value: self) * self sign!

day
	"Answer the <Integer> value of the receiver's 'day' field."

	^bytes uint32AtOffset: _OffsetOf_day!

day: anInteger
	"Set the receiver's 'day' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_day put: anInteger!

dbConvert: anObject for: aDBField
	(anObject species == self species or: [anObject isKindOf: Duration]) ifTrue: [^anObject].
	HRESULTError
		signal: anObject species displayString , '(' , anObject displayString , ') invalid: '
				, self valueClass displayString , ' expected'
		with: Win32Errors.STATUS_OBJECT_TYPE_MISMATCH.
	^nil!

duration
	"Answer the <Duration> represented by this interval. An error is thrown if the receiver is a year/month interval."

	^Duration seconds: self asSeconds!

duration: aDuration
	"Set the <Duration> of the interval described by the receiver. An error is thrown if the receiver is a year/month interval."

	(##((Array new: 13 withAll: [:interval :duration | interval errorWrongIntervalType])
		at: SQL_IS_DAY put: [:interval :duration | interval day: duration days];
		at: SQL_IS_HOUR put: [:interval :duration | interval hour: duration asSeconds // 3600];
		at: SQL_IS_MINUTE put: [:interval :duration | interval minute: duration asSeconds // 60];
		at: SQL_IS_SECOND put: [:interval :duration | interval setSeconds: duration asSeconds];
		at: SQL_IS_DAY_TO_HOUR
			put: 
				[:interval :duration |
				interval
					day: duration days;
					hour: duration hours];
		at: SQL_IS_DAY_TO_MINUTE
			put: 
				[:interval :duration |
				interval
					day: duration days;
					hour: duration hours;
					minute: duration minutes];
		at: SQL_IS_DAY_TO_SECOND
			put: 
				[:interval :duration |
				interval
					day: duration days;
					hour: duration hours;
					minute: duration minutes;
					setSeconds: duration seconds];
		at: SQL_IS_HOUR_TO_MINUTE
			put: 
				[:interval :duration |
				interval
					hour: duration days * 24 + duration hours;
					minute: duration minutes];
		at: SQL_IS_HOUR_TO_SECOND
			put: 
				[:interval :duration |
				interval
					hour: duration days * 24 + duration hours;
					minute: duration minutes;
					setSeconds: duration seconds];
		at: SQL_IS_MINUTE_TO_SECOND
			put: 
				[:interval :duration |
				interval
					minute: (duration days * 24 + duration hours) * 60 + duration minutes;
					setSeconds: duration seconds];
		yourself) at: self interval_type)
		value: self
		value: aDuration abs.
	self sign: aDuration sign!

fraction
	"Answer the <Integer> value of the receiver's 'fraction' field."

	^bytes uint32AtOffset: _OffsetOf_fraction!

fraction: anInteger
	"Set the receiver's 'fraction' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fraction put: anInteger!

getSeconds
	^(bytes uint32AtOffset: _OffsetOf_second) + ((bytes uint32AtOffset: _OffsetOf_fraction) / scaleExp)!

hash
	^self species hash + self asSeconds hash!

hour
	"Answer the <Integer> value of the receiver's 'hour' field."

	^bytes uint32AtOffset: _OffsetOf_hour!

hour: anInteger
	"Set the receiver's 'hour' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_hour put: anInteger!

initialize
	super initialize.
	scaleExp := DefaultFractionScaler!

minute
	"Answer the <Integer> value of the receiver's 'minute' field."

	^bytes uint32AtOffset: _OffsetOf_minute!

minute: anInteger
	"Set the receiver's 'minute' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_minute put: anInteger!

scale
	^scaleExp log truncated!

scale: anInteger
	"Set the seconds precision of the receiver."

	| fractionalSeconds |
	fractionalSeconds := self fraction / scaleExp.
	scaleExp := anInteger exp10.
	self fraction: (fractionalSeconds * scaleExp) truncated!

second
	"Answer the <Integer> value of the receiver's 'second' field."

	^bytes uint32AtOffset: _OffsetOf_second!

second: anInteger
	"Set the receiver's 'second' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_second put: anInteger!

setSeconds: aNumber
	bytes
		uint32AtOffset: _OffsetOf_second put: aNumber truncated;
		uint32AtOffset: _OffsetOf_fraction put: (aNumber fractionPart * scaleExp) truncated!

value
	^self duration!

value: anObject
	self duration: anObject asDuration!

valueClass
	^Duration! !

!SQL_DAY_SECOND_STRUCT categoriesForMethods!
=!comparing!public! !
asDuration!converting!public! !
asSeconds!converting!public! !
day!**compiled accessors**!public! !
day:!**compiled accessors**!public! !
dbConvert:for:!operations!public! !
duration!accessing!public! !
duration:!accessing!public! !
fraction!**compiled accessors**!public! !
fraction:!**compiled accessors**!public! !
getSeconds!accessing!private! !
hash!comparing!public! !
hour!**compiled accessors**!public! !
hour:!**compiled accessors**!public! !
initialize!initializing!private! !
minute!**compiled accessors**!public! !
minute:!**compiled accessors**!public! !
scale!accessing!public! !
scale:!initializing!public! !
second!**compiled accessors**!public! !
second:!**compiled accessors**!public! !
setSeconds:!accessing!private! !
value!accessing!public! !
value:!accessing!public! !
valueClass!constants!public! !
!

!SQL_DAY_SECOND_STRUCT class methodsFor!

defineFields
	"
		self compileDefinition

	typedef struct tagSQL_DAY_SECOND
	{
		SQLUINTEGER		day;
		SQLUINTEGER		hour;
		SQLUINTEGER		minute;
		SQLUINTEGER		second;
		SQLUINTEGER		fraction;
	} SQL_DAY_SECOND_STRUCT;"

	super defineFields.
	self
		defineField: #day type: UInt32Field new;
		defineField: #hour type: UInt32Field new;
		defineField: #minute type: UInt32Field new;
		defineField: #second type: UInt32Field new;
		defineField: #fraction type: UInt32Field new! !

!SQL_DAY_SECOND_STRUCT class categoriesForMethods!
defineFields!public!template definition! !
!

