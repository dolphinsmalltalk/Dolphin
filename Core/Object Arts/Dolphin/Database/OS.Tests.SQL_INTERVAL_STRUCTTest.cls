"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.SQL_INTERVAL_STRUCTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ODBCCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.SQL_INTERVAL_STRUCTTest guid: (Core.GUID fromString: '{4fdd0033-b9f6-4c37-bf4a-ae29c0aee2a6}')!

OS.Tests.SQL_INTERVAL_STRUCTTest comment: ''!

!OS.Tests.SQL_INTERVAL_STRUCTTest methodsFor!

testComparingDaysToSeconds
	| subjects |
	"Different ways of representing 2 days"
	subjects := {SQL_INTERVAL_STRUCT days: 2.
				SQL_INTERVAL_STRUCT hours: 48.
				SQL_INTERVAL_STRUCT minutes: 48 * 60.
				SQL_INTERVAL_STRUCT seconds: 48 * 60 * 60.
				SQL_INTERVAL_STRUCT days: 1 hours: 24.
				SQL_INTERVAL_STRUCT
					days: 1
					hours: 23
					minutes: 60.
				SQL_INTERVAL_STRUCT
					days: 1
					hours: 23
					minutes: 59
					seconds: 60}.
	subjects do: 
			[:outer |
			subjects do: 
					[:inner |
					self assert: outer equals: inner.
					self assert: outer hash equals: inner hash]]!

testComparingIncompatibleIntervals
	self deny: (SQL_INTERVAL_STRUCT days: 365) equals: (SQL_INTERVAL_STRUCT years: 1).
	self deny: (SQL_INTERVAL_STRUCT days: 365) hash equals: (SQL_INTERVAL_STRUCT years: 1) hash.!

testComparingYearsToMonths
	| subjects |
	"Different ways of representing 2 years"
	subjects := {SQL_INTERVAL_STRUCT years: 2.
				SQL_INTERVAL_STRUCT months: 24.
				SQL_INTERVAL_STRUCT years: 1 months: 12}.
	subjects do: 
			[:outer |
			subjects do: 
					[:inner |
					self assert: outer equals: inner.
					self assert: outer hash equals: inner hash]]!

testIncompatibleIntervals
	| years days |
	years := SQL_INTERVAL_STRUCT years: 2.
	days := SQL_INTERVAL_STRUCT days: 789.
	self should: [years value: days] raise: Error.
	self should: [days value: years] raise: Error!

testInstantiationDays
	#(-2 0 3 1.75 0.9999999 1.0000001) do: 
			[:each |
			| subject |
			subject := SQL_INTERVAL_STRUCT days: each.
			self assert: subject interval_sign equals: (each < 0 ifTrue: [1] ifFalse: [0]).
			self assert: subject interval_type equals: SQL_INTERVAL_STRUCT.SQL_IS_DAY.
			self assert: subject duration equals: each truncated days.
			self assert: subject day equals: each truncated abs.
			self assert: subject hour equals: 0.
			self assert: subject minute equals: 0.
			self assert: subject minute equals: 0.
			self assert: subject fraction equals: 0]!

testInstantiationHours
	#(-2 0 3 1.75 0.9999999 1.0000001 50 -55) do: 
			[:each |
			| subject |
			subject := SQL_INTERVAL_STRUCT hours: each.
			self assert: subject interval_sign equals: (each < 0 ifTrue: [1] ifFalse: [0]).
			self assert: subject interval_type equals: SQL_INTERVAL_STRUCT.SQL_IS_HOUR.
			self assert: subject value equals: each truncated hours.
			self assert: subject day equals: 0.
			self assert: subject hour equals: each truncated abs.
			self assert: subject minute equals: 0.
			self assert: subject minute equals: 0.
			self assert: subject fraction equals: 0]!

testInstantiationMinutes
	#(-2 0 3 1.75 0.9999999 1.0000001 50 -55 60 -60 61 -61) do: 
			[:each |
			| subject |
			subject := SQL_INTERVAL_STRUCT minutes: each.
			self assert: subject interval_sign equals: (each < 0 ifTrue: [1] ifFalse: [0]).
			self assert: subject interval_type equals: SQL_INTERVAL_STRUCT.SQL_IS_MINUTE.
			self assert: subject value equals: each truncated minutes.
			self assert: subject day equals: 0.
			self assert: subject hour equals: 0.
			self assert: subject minute equals: each truncated abs.
			self assert: subject second equals: 0.
			self assert: subject fraction equals: 0]!

testInstantiationMinutesToSeconds
	{-2 minutes.
		0 seconds.
		3 seconds.
		1.75 minutes.
		0.16875 seconds.
		726.125 seconds.
		1.109375 hours.
		60 seconds.
		-60 seconds.
		3600 seconds.
		-86475.375 seconds} do: 
				[:each |
				| subject |
				subject := (SQL_INTERVAL_STRUCT dbInterchangeType: SQL_C_INTERVAL_MINUTE_TO_SECOND)
							value: each;
							yourself.
				self assert: subject interval_sign equals: (each negative ifTrue: [1] ifFalse: [0]).
				self assert: subject value printString equals: each printString.
				self assert: subject day equals: 0.
				self assert: subject hour equals: 0.
				self assert: subject minute equals: each asSeconds abs // 60.
				self assert: subject second equals: each seconds truncated abs.
				self assert: subject fraction equals: (each seconds abs fractionPart * 1e6) truncated]!

testInstantiationMonths
	#(11 12 13 -18 0 30 18.75 0.9999999 1.0000001) do: 
			[:each |
			| subject |
			subject := SQL_INTERVAL_STRUCT months: each.
			self assert: subject interval_sign equals: (each < 0 ifTrue: [1] ifFalse: [0]).
			self assert: subject interval_type equals: SQL_INTERVAL_STRUCT.SQL_IS_MONTH.
			self assert: subject year equals: 0.
			self assert: subject month equals: each truncated abs.
			self assert: subject totalYears equals: each truncated / 12.
			self assert: subject years equals: (each quo: 12).
			self assert: subject months equals: (each rem: 12) truncated]!

testInstantiationSeconds
	#(-2 0 3 1.75 0.015625 1.046875 50 -55 60 -60 61 -61) do: 
			[:each |
			| subject |
			subject := SQL_INTERVAL_STRUCT seconds: each.
			self assert: subject interval_sign equals: (each < 0 ifTrue: [1] ifFalse: [0]).
			self assert: subject interval_type equals: SQL_INTERVAL_STRUCT.SQL_IS_SECOND.
			self assert: subject value equals: each seconds.
			self assert: subject day equals: 0.
			self assert: subject hour equals: 0.
			self assert: subject minute equals: 0.
			self assert: subject second equals: each abs truncated.
			self assert: subject fraction equals: each abs fractionPart * 1e6]!

testInstantiationYears
	#(-5 0 7 1.75 -1.25) do: 
			[:each |
			| subject |
			subject := SQL_INTERVAL_STRUCT years: each.
			self assert: subject interval_sign equals: (each < 0 ifTrue: [1] ifFalse: [0]).
			self assert: subject interval_type equals: SQL_INTERVAL_STRUCT.SQL_IS_YEAR.
			self assert: subject years equals: each truncated.
			self assert: subject months equals: 0.
			self assert: subject year equals: each truncated abs.
			self assert: subject month equals: 0]!

testInstantiationYearsToMonths
	| totalMonths |
	#(#(-5 8) #(0 0) #(7 13) #(1.75 1.25) #(-1.25 -3.5)) do: 
			[:pair |
			| subject years months |
			years := pair first.
			months := pair second.
			totalMonths := years * 12 + months.
			subject := SQL_INTERVAL_STRUCT years: years months: months.
			self assert: subject interval_sign equals: (pair first < 0 ifTrue: [1] ifFalse: [0]).
			self assert: subject interval_type equals: SQL_INTERVAL_STRUCT.SQL_IS_YEAR_TO_MONTH.
			self assert: subject years equals: (totalMonths quo: 12).
			self assert: subject months equals: (totalMonths rem: 12) truncated.
			self assert: subject year equals: (totalMonths quo: 12) abs.
			self assert: subject month equals: (totalMonths rem: 12) truncated abs]!

testPrintStringDays
	| subject |
	subject := SQL_INTERVAL_STRUCT days: 123.
	self assert: subject printString equals: 'a SQL_DAY_SECOND_STRUCT(sign=1 day=123)'!

testPrintStringDaysToHours
	| subject |
	subject := SQL_INTERVAL_STRUCT days: 1 hours: 25.
	self assert: subject printString equals: 'a SQL_DAY_SECOND_STRUCT(sign=1 day=2 hour=1)'!

testPrintStringDaysToMinutes
	| subject |
	subject := SQL_INTERVAL_STRUCT
				days: 1
				hours: 25
				minutes: 125.
	self assert: subject printString
		equals: 'a SQL_DAY_SECOND_STRUCT(sign=1 day=2 hour=3 minute=5)'!

testPrintStringDaysToSeconds
	| subject |
	subject := SQL_INTERVAL_STRUCT
				days: 1
				hours: 25
				minutes: 125
				seconds: 97.1234567.
	self assert: subject printString
		equals: 'a SQL_DAY_SECOND_STRUCT(sign=1 day=2 hour=3 minute=6 second=37 fraction=123456)'!

testPrintStringHours
	| subject |
	subject := SQL_INTERVAL_STRUCT hours: 23.
	self assert: subject printString equals: 'a SQL_DAY_SECOND_STRUCT(sign=1 hour=23)'!

testPrintStringHoursToMinutes
	| subject |
	subject := SQL_INTERVAL_STRUCT hours: -25.5 minutes: -125.
	self assert: subject printString equals: 'a SQL_DAY_SECOND_STRUCT(sign=-1 hour=27 minute=35)'!

testPrintStringHoursToSeconds
	| subject |
	subject := SQL_INTERVAL_STRUCT hours: -25.5 minutes: -125 seconds: -67.5.
	self assert: subject printString equals: 'a SQL_DAY_SECOND_STRUCT(sign=-1 hour=27 minute=36 second=7 fraction=500000)'!

testPrintStringMinutes
	| subject |
	subject := SQL_INTERVAL_STRUCT minutes: 102.
	self assert: subject printString equals: 'a SQL_DAY_SECOND_STRUCT(sign=1 minute=102)'!

testPrintStringMinutesToSeconds
	| subject |
	subject := SQL_INTERVAL_STRUCT minutes: -125 seconds: 67.125.
	self assert: subject printString
		equals: 'a SQL_DAY_SECOND_STRUCT(sign=-1 minute=123 second=52 fraction=875000)'!

testPrintStringSeconds
	| subject |
	subject := SQL_INTERVAL_STRUCT seconds: 3601.1234567.
	self assert: subject printString
		equals: 'a SQL_DAY_SECOND_STRUCT(sign=1 second=3601 fraction=123456)'!

testSecondsScale
	| subject |
	subject := SQL_INTERVAL_STRUCT seconds: -67 / 64.
	self assert: subject scale equals: 6.
	self assert: subject value equals: (-67 / 64) seconds.
	self assert: subject sign equals: -1.
	self assert: subject second equals: 1.
	self assert: subject fraction equals: 46875.
	subject scale: 7.
	self assert: subject scale equals: 7.
	self assert: subject fraction equals: 468750.
	self assert: subject value equals: (-67 / 64) seconds.
	subject value: (143 / 128) seconds.
	self assert: subject value equals: (143 / 128 asScaledDecimal: 7) seconds.
	self assert: subject fraction equals: 1171875.
	subject scale: 5.
	self assert: subject fraction equals: 11718.
	self assert: subject value asSeconds closeTo: 1.11718!

testSetDaysFromDays
	| subject |
	subject := SQL_INTERVAL_STRUCT days: 0.
	subject value: 3 days.
	self assert: subject value equals: 3 days.
	"Fractional hours can be passed, but will be lost in this case"
	subject value: -3.5 days.
	self assert: subject value equals: -3 days!

testSetDaysFromHours
	| subject |
	subject := SQL_INTERVAL_STRUCT days: 0.
	subject value: (24 - 1) hours.
	self assert: subject value equals: 0 days.
	"Fractional hours can be passed, but will be lost in this case"
	subject value: 24.2 hours.
	self assert: subject value equals: 1 days.
	subject value: -24 hours.
	self assert: subject value equals: -1 days!

testSetDaysFromMinutes
	| subject |
	subject := SQL_INTERVAL_STRUCT days: 0.
	subject value: (24 * 60 - 1) minutes.
	self assert: subject value equals: 0 days.
	subject value: (24 * 60) minutes.
	self assert: subject value equals: 1 days.
	subject value: (-24 * 60) minutes.
	self assert: subject value equals: -1 days.
	subject value: 19585.75 minutes.
	self assert: subject value equals: 13 days!

testSetDaysFromSeconds
	| subject |
	subject := SQL_INTERVAL_STRUCT days: 0.
	subject value: (24 * 60 * 60 - 0.0000001) seconds.
	self assert: subject duration equals: 0 days.
	subject value: (24 * 60 * 60) seconds.
	self assert: subject duration equals: 1 days.
	subject value: (-24 * 60 * 60) seconds.
	self assert: subject value equals: -1 days!

testSetHoursFromDays
	| subject |
	subject := SQL_INTERVAL_STRUCT hours: 23.
	self assert: subject value equals: 23 hours.
	#(7 -2.5 0 0.5 -0.5 365) do: 
			[:each |
			| days |
			days := each days.
			subject value: days.
			self assert: subject value equals: days.
			self assert: subject day equals: 0.
			self assert: (subject hour * subject sign) hours equals: days]!

testSetHoursFromHours
	| subject |
	subject := SQL_INTERVAL_STRUCT hours: 23.
	self assert: subject value equals: 23 hours.
	#(7 -2.5 0 0.5 -0.5 23 24 25) do: 
			[:each |
			| hours |
			subject value: each hours.
			self assert: subject value equals: each truncated hours.
			self assert: subject day equals: 0.
			self assert: (subject hour * subject sign) hours equals: each truncated hours]!

testSetHoursFromMinutes
	| subject |
	subject := SQL_INTERVAL_STRUCT hours: 1.
	subject value: 59 minutes.
	self assert: subject value equals: 0 hours.
	subject value: (24 * 60 - 1) minutes.
	self assert: subject value equals: 23 hours.
	subject value: (-7 * 24 * 60) minutes.
	self assert: subject value equals: -7 days!

testSetHoursFromSeconds
	| subject |
	subject := SQL_INTERVAL_STRUCT hours: 1.
	subject value: 3599 seconds.
	self assert: subject value equals: 0 hours.
	subject value: (24 * 3600 - 1) seconds.
	self assert: subject value equals: 23 hours.
	subject value: (7 * 24 * 3600) seconds.
	self assert: subject value equals: 7 days!

testSetMinutesFromDays
	| subject |
	subject := SQL_INTERVAL_STRUCT minutes: 59.
	self assert: subject value equals: 59 minutes.
	subject value: 7 days.
	self assert: subject value equals: 7 days.
	subject value: -7 days.
	self assert: subject value equals: -7 days!

testSetMinutesToSecondsFromSeconds
	| subject |
	subject := SQL_INTERVAL_STRUCT minutes: 59 seconds: 59.9999999.
	self assert: subject value printString equals: '0:00:59:59.999999'.
	subject value: (24 * 60 - 1) minutes.
	self assert: subject value equals: 23 hours + 59 minutes.
	subject value: (7 * 24 * 60) minutes.
	self assert: subject value equals: 7 days!

testSetMonthsFromMonths
	| subject |
	subject := SQL_INTERVAL_STRUCT dbInterchangeType: SQL_C_INTERVAL_MONTH.
	subject totalMonths: 25.
	self assert: subject interval_sign equals: 0.
	self assert: subject year equals: 0.
	self assert: subject month equals: 25.
	self assert: subject years equals: 25 // 12.
	self assert: subject totalYears equals: 25 / 12.
	self assert: subject months equals: 1.
	subject totalMonths: 2.5.
	self assert: subject interval_sign equals: 0.
	self assert: subject year equals: 0.
	self assert: subject month equals: 2.
	self assert: subject years equals: 0.
	self assert: subject totalYears equals: 1 / 6.
	self assert: subject months equals: 2.
	subject totalMonths: -24.5.
	self assert: subject interval_sign equals: 1.
	self assert: subject year equals: 0.
	self assert: subject month equals: 24.
	self assert: subject years equals: -2.
	self assert: subject months equals: 0!

testSetMonthsFromYears
	| subject |
	subject := SQL_INTERVAL_STRUCT dbInterchangeType: SQL_C_INTERVAL_MONTH.
	subject totalYears: 2.
	self assert: subject interval_sign equals: 0.
	self assert: subject year equals: 0.
	self assert: subject month equals: 24.
	self assert: subject years equals: 2.
	self assert: subject month equals: 24.
	self assert: subject months equals: 0.
	self assert: subject totalMonths equals: 24.
	subject totalYears: 2.5.
	self assert: subject interval_sign equals: 0.
	self assert: subject year equals: 0.
	self assert: subject month equals: 30.
	self assert: subject totalYears equals: 2.5.
	self assert: subject years equals: 2.
	self assert: subject months equals: 6.
	self assert: subject totalMonths equals: 30.
	subject totalYears: -2.5.
	self assert: subject interval_sign equals: 1.
	self assert: subject year equals: 0.
	self assert: subject month equals: 30.
	self assert: subject totalYears equals: -2.5.
	self assert: subject years equals: -2.
	self assert: subject totalMonths equals: -30.
	self assert: subject months equals: -6!

testSetYearsFromMonths
	| subject |
	subject := SQL_INTERVAL_STRUCT dbInterchangeType: SQL_C_INTERVAL_YEAR.
	subject totalMonths: 26.5.
	self assert: subject interval_sign equals: 0.
	self assert: subject year equals: 2.
	self assert: subject month equals: 0.
	self assert: subject years equals: 2.
	self assert: subject months equals: 0.
	self assert: subject totalMonths equals: 24.
	"Less than one year, so zero"
	subject totalMonths: 6.
	self assert: subject interval_sign equals: 0.
	self assert: subject year equals: 0.
	self assert: subject month equals: 0.
	self assert: subject years equals: 0.
	self assert: subject months equals: 0.
	self assert: subject totalMonths equals: 0.
	subject totalMonths: -13.5.
	self assert: subject interval_sign equals: 1.
	self assert: subject year equals: 1.
	self assert: subject month equals: 0.
	self assert: subject years equals: -1.
	self assert: subject months equals: 0.
	self assert: subject totalMonths equals: -12!

testSetYearsFromYears
	| subject |
	subject := SQL_INTERVAL_STRUCT dbInterchangeType: SQL_C_INTERVAL_YEAR.
	subject totalYears: 6.5.
	self assert: subject interval_sign equals: 0.
	self assert: subject year equals: 6.
	self assert: subject month equals: 0.
	self assert: subject totalYears equals: 6.
	self assert: subject years equals: 6.
	self assert: subject months equals: 0.
	self assert: subject totalMonths equals: 72.
	subject totalYears: -5.
	self assert: subject interval_sign equals: 1.
	self assert: subject year equals: 5.
	self assert: subject month equals: 0.
	self assert: subject totalYears equals: -5.
	self assert: subject years equals: -5.
	self assert: subject totalMonths equals: -60.
	self assert: subject months equals: 0! !

!OS.Tests.SQL_INTERVAL_STRUCTTest categoriesForMethods!
testComparingDaysToSeconds!public!unit tests! !
testComparingIncompatibleIntervals!public!unit tests! !
testComparingYearsToMonths!public!unit tests! !
testIncompatibleIntervals!public!unit tests! !
testInstantiationDays!public!unit tests! !
testInstantiationHours!public!unit tests! !
testInstantiationMinutes!public!unit tests! !
testInstantiationMinutesToSeconds!public!unit tests! !
testInstantiationMonths!public!unit tests! !
testInstantiationSeconds!public!unit tests! !
testInstantiationYears!public!unit tests! !
testInstantiationYearsToMonths!public!unit tests! !
testPrintStringDays!public!unit tests! !
testPrintStringDaysToHours!public!unit tests! !
testPrintStringDaysToMinutes!public!unit tests! !
testPrintStringDaysToSeconds!public!unit tests! !
testPrintStringHours!public!unit tests! !
testPrintStringHoursToMinutes!public!unit tests! !
testPrintStringHoursToSeconds!public!unit tests! !
testPrintStringMinutes!public!unit tests! !
testPrintStringMinutesToSeconds!public!unit tests! !
testPrintStringSeconds!public!unit tests! !
testSecondsScale!public!unit tests! !
testSetDaysFromDays!public!unit tests! !
testSetDaysFromHours!public!unit tests! !
testSetDaysFromMinutes!public!unit tests! !
testSetDaysFromSeconds!public!unit tests! !
testSetHoursFromDays!public!unit tests! !
testSetHoursFromHours!public!unit tests! !
testSetHoursFromMinutes!public!unit tests! !
testSetHoursFromSeconds!public!unit tests! !
testSetMinutesFromDays!public!unit tests! !
testSetMinutesToSecondsFromSeconds!public!unit tests! !
testSetMonthsFromMonths!public!unit tests! !
testSetMonthsFromYears!public!unit tests! !
testSetYearsFromMonths!public!unit tests! !
testSetYearsFromYears!public!unit tests! !
!

