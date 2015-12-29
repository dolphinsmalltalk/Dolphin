"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ItcConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcConverter guid: (GUID fromString: '{58334E0D-DB72-43FE-A5AC-5910A3F3A622}')!
ItcConverter comment: ''!
!ItcConverter categoriesForClass!Unclassified! !
!ItcConverter class methodsFor!

getDateDDMMYY: str 
	^Date 
		newDay: (str copyFrom: 1 to: 2) itcAsInteger
		monthIndex: (str copyFrom: 3 to: 4) itcAsInteger
		year: (str copyFrom: 5 to: 6) itcAsInteger + 2000.!

getDateDDMMYYYY: str 
	^Date 
		newDay: (str copyFrom: 1 to: 2) itcAsInteger
		monthIndex: (str copyFrom: 3 to: 4) itcAsInteger
		year: (str copyFrom: 5 to: 8) itcAsInteger!

getDateFromString: aString dateFormat: dateFormat 
	| separator tokens monthIndex dayIndex yearIndex str |
	aString isNilOrEmpty ifTrue: [^nil].
	yearIndex := 3.
	dateFormat = 'DD.MM.YYYY' 
		ifTrue: 
			[separator := $..
			monthIndex := 2.
			dayIndex := 1].
	dateFormat = 'DD/MM/YY' 
		ifTrue: 
			[separator := $/.
			monthIndex := 2.
			dayIndex := 1].
	dateFormat = 'MM/DD/YYYY' 
		ifTrue: 
			[separator := $/.
			monthIndex := 1.
			dayIndex := 2].
	dateFormat = 'YYYY-MM-DD' 
		ifTrue: 
			[separator := $-.
			yearIndex := 1.
			monthIndex := 2.
			dayIndex := 3].
	separator isNil ifTrue: [^nil].
	str := aString trimBlanks.
	tokens := str itcSubStrings: separator.
	"Check if date is enetered like 01062004, it should be understood as date without separators in format DDMMYY."
	(tokens size = 1 and: [str isAllDigits]) 
		ifTrue: 
			[yearIndex = 3 
				ifTrue: 
					[str size > 4 
						ifTrue: 
							[tokens := Array 
										with: (str copyFrom: 1 to: 2)
										with: (str copyFrom: 3 to: 4)
										with: (str copyFrom: 5 to: str size)]
						ifFalse: 
							[str size > 2 
								ifTrue: [tokens := Array with: (str copyFrom: 1 to: 2) with: (str copyFrom: 3 to: str size)]]]].
	(tokens size between: 1 and: 3) 
		ifTrue: 
			[| day month year |
			tokens := (tokens reject: [:each | each trimBlanks isEmpty]) 
						collect: [:each | self getIntegerFromString: each].
			day := tokens size < dayIndex ifTrue: [0] ifFalse: [tokens at: dayIndex].
			month := tokens size < monthIndex ifTrue: [Date today monthIndex] ifFalse: [tokens at: monthIndex].
			year := tokens size < yearIndex ifTrue: [Date today year] ifFalse: [tokens at: yearIndex].
			year < 50 ifTrue: [year := year + 2000].	" bad "
			year < 100 ifTrue: [year := year + 1900].
			(month >= 1 and: [month <= 12]) 
				ifTrue: 
					[day := (day max: 1) min: (Date daysInMonthIndex: month forYear: year).
					^Date 
						newDay: day
						monthIndex: month
						year: year]].
	^nil!

getDateYYMMDD: str 
	^Date 
		newDay: (str copyFrom: 5 to: 6) itcAsInteger
		monthIndex: (str copyFrom: 3 to: 4) itcAsInteger
		year: (str copyFrom: 1 to: 2) itcAsInteger + 2000!

getDateYYYYMMDD: str 
	^Date 
		newDay: (str copyFrom: 7 to: 8) itcAsInteger
		monthIndex: (str copyFrom: 5 to: 6) itcAsInteger
		year: (str copyFrom: 1 to: 4) itcAsInteger!

getDoubleFromString: aString 
	| tmp n decimalPoint mantissa exponent exponentIndex |
	aString isNil ifTrue: [^nil].
	"trim blanks"
	tmp := aString trimBlanks asUppercase.
	"trim leading zeroes"
	decimalPoint := $..
	[tmp size > 0 and: [(tmp at: 1) = $0]] whileTrue: [tmp := tmp copyFrom: 2 to: tmp size].
	tmp size > 0 
		ifTrue: 
			[tmp = 'INF' ifTrue: [^nil].
			tmp = '-INF' ifTrue: [^nil].
			tmp = 'NAN' ifTrue: [^nil].
			"handle negative values"
			(tmp at: 1) = $- 
				ifTrue: 
					[n := self getDoubleFromString: (tmp copyFrom: 2 to: tmp size).
					^n isNil ifFalse: [0 - n]].
			(tmp at: 1) = $+ ifTrue: [tmp := tmp copyFrom: 2 to: tmp size]].
	tmp 
		do: [:each | (each isDigit or: [each == decimalPoint or: [each == $E or: [each == $-]]]) ifFalse: [^nil]].
	(exponentIndex := tmp indexOf: $E) > 0 
		ifTrue: 
			[exponent := exponentIndex < tmp size ifTrue: [tmp copyFrom: exponentIndex + 1] ifFalse: [''].
			mantissa := tmp copyFrom: 1 to: exponentIndex - 1]
		ifFalse: 
			[exponent := nil.
			mantissa := tmp].
	exponent := exponent isNilOrEmpty ifTrue: [0] ifFalse: [exponent asDecimalOrFloat].
	mantissa := mantissa isNilOrEmpty ifTrue: [0] ifFalse: [mantissa asDecimalOrFloat].
	^mantissa * (10 raisedTo: exponent)!

getIntegerFromString: aString 
	^aString isNil ifTrue: [0] ifFalse: [aString itcAsInteger]!

getNumberFromString: aString 
	| session ts dp |
	session := (self respondsTo: #webSession) ifTrue: [self webSession].
	ts := session isNil ifFalse: [session thousandsSeparator].
	dp := session isNil 
				ifFalse: [session decimalPoint]
				ifTrue: 
					[aString isNilOrEmpty 
						ifFalse: [aString trimBlanks reverse detect: [:each | each isDigit not] ifNone: [$.]]].
	^self 
		getNumberFromString: aString
		scale: 25
		precision: 6
		thousandsSeparator: ts
		decimalPoint: dp!

getNumberFromString: aString scale: scale precision: precision thousandsSeparator: thousandsSeparator decimalPoint: decimalPoint 
	| tmp decimalString scaleString precisionString n |
	aString isNil ifTrue: [^nil].
	"trim blanks"
	tmp := aString trimBlanks.
	"trim leading zeroes"
	[tmp size > 0 and: [(tmp at: 1) = $0]] whileTrue: [tmp := tmp copyFrom: 2 to: tmp size].
	tmp size > 0 
		ifTrue: 
			["handle negative values"
			(tmp at: 1) = $- 
				ifTrue: 
					[n := self 
								getNumberFromString: (tmp copyFrom: 2 to: tmp size)
								scale: scale
								precision: precision
								thousandsSeparator: thousandsSeparator
								decimalPoint: decimalPoint.
					^n isNil ifFalse: [0 - n]].
			(tmp at: 1) = $+ ifTrue: [tmp := tmp copyFrom: 2 to: tmp size]].
	tmp do: 
			[:each | 
			(each isDigit 
				or: [each == decimalPoint or: [each == thousandsSeparator or: [#($. $, $  $') includes: each]]]) 
					ifFalse: [^nil]].
	decimalString := tmp select: [:each | each == decimalPoint or: [each isDigit]].
	(decimalString indexOf: decimalPoint) = 0 
		ifTrue: [scaleString := decimalString]
		ifFalse: 
			[scaleString := decimalString copyFrom: 1 to: (decimalString indexOf: decimalPoint) - 1.
			scaleString := scaleString copyFrom: (1 max: scaleString size - scale + 1) to: scaleString size.
			precisionString := (decimalString copyFrom: (decimalString indexOf: decimalPoint) + 1
						to: decimalString size) select: [:each | each isDigit].
			precisionString := precisionString copyFrom: 1 to: (precisionString size min: precision)].
	scaleString notEmpty 
		ifTrue: 
			[scaleString := scaleString copyFrom: (scaleString size - scale + 1 max: 1) to: scaleString size].
	scaleString isEmpty ifTrue: [scaleString := '0'].
	^(precision = 0 or: [precisionString isNil or: [precisionString isEmpty]]) 
		ifTrue: [scaleString asDecimalOrFloat]
		ifFalse: [(scaleString , '.' , precisionString) asDecimalOrFloat]!

getPortablePrintStringFromDecimal: aDecimal 
	^self getStringFromNumberWithMinimalDecimals: aDecimal decimalPoint: $.!

getShortStringFromDate: aDate dateFormat: dateFormat 
	| day month yearString |
	aDate isNil ifTrue: [^''].
	day := aDate dayOfMonth printString.
	day size = 1 ifTrue: [day := '0' , day].
	month := aDate monthIndex printString.
	month size = 1 ifTrue: [month := '0' , month].
	(aDate year > 1990 and: [aDate year < 2091]) 
		ifTrue: [yearString := (aDate year \\ 100) printString]
		ifFalse: [yearString := aDate year printString].
	yearString size < 2 ifTrue: [yearString := '0' , yearString].
	(dateFormat isNil or: [dateFormat = 'DD.MM.YYYY']) ifTrue: [^day , '.' , month , '.' , yearString].
	dateFormat = 'MM/DD/YYYY' ifTrue: [^month , '/' , day , '/' , yearString].
	dateFormat = 'DD.MM.' ifTrue: [^day , '.' , month , '.']!

getShortStringFromTime: aTime 
	| hours minutes |
	aTime notNil 
		ifTrue: 
			[hours := aTime hours printString.
			minutes := aTime minutes < 10 
						ifTrue: ['0' , aTime minutes printString]
						ifFalse: [aTime minutes printString].
			^hours , ':' , minutes]!

getStringFromDate: aDate dateFormat: dateFormat 
	| day month year |
	aDate isNil ifTrue: [^''].
	day := aDate dayOfMonth printString.
	month := aDate monthIndex printString.
	year := aDate year asLeadingZerosStringOfSize: 4.
	dateFormat = 'D.M.Y' ifTrue: [^day , '.' , month , '.' , year].
	month size = 1 ifTrue: [month := '0' , month].
	day size = 1 ifTrue: [day := '0' , day].
	(dateFormat isNil or: [dateFormat = 'DD.MM.YYYY']) ifTrue: [^day , '.' , month , '.' , year].
	(dateFormat isNil or: [dateFormat = 'DD.MM.YY']) 
		ifTrue: [^day , '.' , month , '.' , (year rightString: 2)].
	dateFormat = 'YYYY-MM-DD' ifTrue: [^year , '-' , month , '-' , day].
	dateFormat = 'DD-MM-YYYY' ifTrue: [^day , '-' , month , '-' , year].
	dateFormat = 'MM/DD/YYYY' ifTrue: [^month , '/' , day , '/' , year].
	dateFormat = 'YYYYMMDD' ifTrue: [^year , month , day].
	dateFormat = 'DDMMYYYY' ifTrue: [^day , month , year].
	dateFormat = 'YYMMDD' ifTrue: [^(year rightString: 2) , month , day].
	dateFormat = 'DDMMYY' ifTrue: [^day , month , (year rightString: 2)].
	self error: 'Invalid date format parameter'!

getStringFromNumber: aNumber scale: scale precision: precision thousandsSeparator: thousandsSeparator decimalPoint: decimalPoint 
	| q r n sign factor ws qStr rStr dp |
	aNumber isNil ifTrue: [^''].
	aNumber isString ifTrue: [^aNumber].
	dp := decimalPoint isNil ifTrue: [''] ifFalse: [decimalPoint asString].
	"We round number to number of decimals that are used by precision (same as with #roundTo:)."
	factor := 10.0s raisedTo: precision.
	n := (aNumber * factor) rounded / factor.
	sign := n < 0 
				ifTrue: 
					[n := 0.0s - n.
					'-']
				ifFalse: [''].
	q := n truncated.
	r := ((n - q) * factor) asInteger.
	rStr := precision == 0 
				ifTrue: 
					[dp := ''.
					'']
				ifFalse: 
					[rStr := r printString.
					rStr size + 1 to: precision
						do: 
							[:i | 
							i.
							rStr := '0' , rStr].
					rStr].
	thousandsSeparator isNil ifTrue: [^sign , q printString , dp , rStr].
	qStr := q printString reverse.
	ws := WriteStream on: (String new: qStr size * 2).
	qStr doWithIndex: 
			[:ch :i | 
			ws nextPut: ch.
			i \\ 3 == 0 ifTrue: [ws nextPut: thousandsSeparator]].
	qStr := ws contents reverse.
	qStr first == thousandsSeparator ifTrue: [qStr := qStr copyFrom: 2 to: qStr size].
	^sign , qStr , dp , rStr!

getStringFromNumberWithMinimalDecimals: aNumber decimalPoint: decimalPoint 
	| str |
	str := self 
				getStringFromNumber: aNumber
				scale: 20
				precision: 20
				thousandsSeparator: nil
				decimalPoint: decimalPoint.
	[(str includes: $.) and: [str last = $0]] whileTrue: [str := str copyFrom: 1 to: str size - 1].
	str last = decimalPoint ifTrue: [str := str copyFrom: 1 to: str size - 1].
	^str!

getStringFromString: aString requiredLength: requiredLength maxLength: maxLength acceptAlpha: acceptAlpha acceptDigits: acceptDigits upperCase: upperCase trimBlanks: trimBlanks 
	| newString |
	aString ifNil: [^nil].
	newString := aString copy.
	trimBlanks ifTrue: [newString := newString trimBlanks].
	upperCase ifTrue: [newString := newString asUppercase].
	(acceptDigits not and: [(newString select: [:each | each isDigit]) notEmpty]) 
		ifTrue: [^nil].
	(acceptAlpha not and: [(newString select: [:each | each isLetter]) notEmpty]) 
		ifTrue: [^nil].
	(newString size between: requiredLength and: maxLength) ifFalse: [^nil].
	^newString!

getStringFromTime: aTime 
	| hours minutes seconds |
	aTime notNil 
		ifTrue: 
			[hours := aTime hours printString.
			minutes := aTime minutes < 10 
						ifTrue: ['0' , aTime minutes printString]
						ifFalse: [aTime minutes printString].
			seconds := aTime seconds < 10 
						ifTrue: ['0' , aTime seconds printString]
						ifFalse: [aTime seconds printString].
			^hours , ':' , minutes , ':' , seconds]!

getStringFromTime: aTime format: format 
	| hours minutes seconds millisec |
	aTime isNil ifTrue: [^''].
	hours := aTime hours printString.
	hours size < 2 ifTrue: [hours := '0' , hours].
	minutes := aTime minutes printString.
	minutes size < 2 ifTrue: [minutes := '0' , minutes].
	seconds := aTime seconds printString.
	seconds size < 2 ifTrue: [seconds := '0' , seconds].
	"----"
	format = 'HHMMSS' ifTrue: [^hours , minutes , seconds].
	"----"
	millisec := aTime milliseconds printString.
	millisec size < 2 ifTrue: [millisec := '0' , millisec].
	format = 'HH:MM:SS.TT' ifTrue: [^hours , ':' , minutes , ':' , seconds , '.' , millisec].
	self error: 'Time format is not specified'!

getTimeFromString: aString 
	| stream hours minutes seconds |
	^aString notEmpty 
		ifTrue: 
			[stream := ReadStream on: ((aString replaceAll: $, with: $:) replaceAll: $. with: $:).
			hours := self getIntegerFromString: (stream upTo: $:).
			minutes := self getIntegerFromString: (stream upTo: $:).
			seconds := self getIntegerFromString: (stream upTo: $:).
			hours > 23 ifTrue: [hours := 23].
			minutes > 59 ifTrue: [minutes := 59].
			seconds > 99 ifTrue: [seconds := 99].
			Time 
				hours: hours
				minutes: minutes
				seconds: seconds]!

getTimeHHMMSS: str 
	^Time 
		hours: (str copyFrom: 1 to: 2) itcAsInteger
		minutes: (str copyFrom: 3 to: 4) itcAsInteger
		seconds: (str copyFrom: 5 to: 6) itcAsInteger!

ignore: characterCollection on: stream 
	[stream atEnd not and: [characterCollection includes: stream peek asInteger]] 
		whileTrue: [stream next]! !
!ItcConverter class categoriesFor: #getDateDDMMYY:!public! !
!ItcConverter class categoriesFor: #getDateDDMMYYYY:!public! !
!ItcConverter class categoriesFor: #getDateFromString:dateFormat:!public! !
!ItcConverter class categoriesFor: #getDateYYMMDD:!public! !
!ItcConverter class categoriesFor: #getDateYYYYMMDD:!public! !
!ItcConverter class categoriesFor: #getDoubleFromString:!public! !
!ItcConverter class categoriesFor: #getIntegerFromString:!public! !
!ItcConverter class categoriesFor: #getNumberFromString:!public! !
!ItcConverter class categoriesFor: #getNumberFromString:scale:precision:thousandsSeparator:decimalPoint:!public! !
!ItcConverter class categoriesFor: #getPortablePrintStringFromDecimal:!public! !
!ItcConverter class categoriesFor: #getShortStringFromDate:dateFormat:!public! !
!ItcConverter class categoriesFor: #getShortStringFromTime:!public! !
!ItcConverter class categoriesFor: #getStringFromDate:dateFormat:!public! !
!ItcConverter class categoriesFor: #getStringFromNumber:scale:precision:thousandsSeparator:decimalPoint:!public! !
!ItcConverter class categoriesFor: #getStringFromNumberWithMinimalDecimals:decimalPoint:!public! !
!ItcConverter class categoriesFor: #getStringFromString:requiredLength:maxLength:acceptAlpha:acceptDigits:upperCase:trimBlanks:!public! !
!ItcConverter class categoriesFor: #getStringFromTime:!public! !
!ItcConverter class categoriesFor: #getStringFromTime:format:!public! !
!ItcConverter class categoriesFor: #getTimeFromString:!public! !
!ItcConverter class categoriesFor: #getTimeHHMMSS:!public! !
!ItcConverter class categoriesFor: #ignore:on:!public! !

