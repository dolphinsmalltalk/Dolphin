"Filed out from Dolphin Smalltalk X6.2"!

StsImportProxy subclass: #StsSqueakChangeSetProxy
	instanceVariableNames: 'stream changes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsSqueakChangeSetProxy guid: (GUID fromString: '{96256785-FE6D-4A1D-9318-F3E49FF1AA39}')!
StsSqueakChangeSetProxy comment: ''!
!StsSqueakChangeSetProxy categoriesForClass!Unclassified! !
!StsSqueakChangeSetProxy methodsFor!

changes
	changes isNil ifTrue: [changes := OrderedCollection new].
	^changes!

getClassDefinition: firstLine 
	| ws definition classInstVars classEdition |
	ws := WriteStream on: String new.
	"Read class definition. Variables are sorted alphabeticaly in export methods."
	ws
		nextPutAll: firstLine;
		cr;
		nextPutAll: self nextLineFromStream trimBlanks;
		cr;
		nextPutAll: self nextLineFromStream trimBlanks;
		cr;
		nextPutAll: self nextLineFromStream trimBlanks;
		cr.
	"Next line represents package, it is not used for now as StsClassEdition doesn't implement it."
	definition := self nextLineFromStream.
	classInstVars := (definition last == $!! or: [stream peekLine beginsWith: '!!']) 
				ifTrue: [ws nextPutAll: 'classInstanceVariableNames: ''''']
				ifFalse: [ws nextPutAll: self nextLineFromStream trimBlanks].
	definition last == $!! ifTrue: [ws nextPut: $!!].
	classInstVars last == $!! 
		ifTrue: [classInstVars := classInstVars copyFrom: 1 to: classInstVars size - 1].
	"First line is checked in this method calling. Last line can contain #classInstVarNames and it is not checked."
	('*instanceVariableNames:*classVariableNames:*poolDictionaries:*' 
		match: (definition := ws contents)) 
			ifFalse: [self error: 'Ilegal class definition at position: ' , stream position printString].
	(definition last == $!! or: [stream peekLine beginsWith: '!!']) 
		ifFalse: [self error: 'Ilegal class definition at position: ' , stream position printString].
	"Character $!! ends definition. If above conditions passes we can preasume that definition is correct. This checking is not perfect!!!!!!"
	definition last == $!! ifTrue: [definition := definition copyFrom: 1 to: definition size - 1].
	^(classEdition := StsClassEdition new)
		name: (firstLine subStrings last copyWithout: $#) asSymbol;
		definition: definition;
		timestamp: (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds));
		classDefinition: classEdition name asString , ' class ' , classInstVars;
		methods: #();
		classMethods: #();
		yourself!

getDateFromString: aString dateFormat: dateFormat 
	| separator tokens monthIndex dayIndex yearIndex str |
	(aString isNil or: [aString isEmpty]) ifTrue: [^nil].
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
	"preveri, ce kdo vnese npr. 01062004, da ga razume, kot datum brez separatorjev"
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

getIntegerFromString: aString 
	| negative str value i ch |
	^aString isNil 
		ifTrue: [0]
		ifFalse: 
			[(str := aString trimBlanks) isEmpty ifTrue: [^0].
			i := 1.
			(negative := str first = $-) ifTrue: [i := 2] ifFalse: [str first = $+ ifTrue: [i := 2]].
			value := 0.
			[i <= str size and: [(ch := str at: i) isDigit]] whileTrue: 
					[value := value * 10 + (ch asInteger - 48).
					i := i + 1].
			^negative ifTrue: [0 - value] ifFalse: [value]]!

getMethodDefinition: firstLine 
	| className ws categoryOrPackage date time methodSource develop |
	ws := ReadStream on: firstLine.
	ws next == $!! 
		ifFalse: [self error: 'Ilegal method definition at position: ' , stream position printString].
	className := (ws itcUpToAll: ' methodsFor: ''') asSymbol.
	(categoryOrPackage := ws itcUpToAll: ''' stamp: ''') first == $* 
		ifTrue: 
			["Represents package (used in loose methods generating), but we can't use it. Return default category."
			categoryOrPackage := 'public'].
	"Developer string can contain blank spaces so reverse lookup is used."
	ws := ReadStream on: (ws itcUpToAll: '''!!') reverse.
	time := self getTimeFromString: (ws itcUpToAll: ' ') reverse.
	date := self getDateFromString: (ws itcUpToAll: ' ') reverse dateFormat: 'MM/DD/YYYY'.
	develop := ws upToEnd reverse.
	methodSource := self getMethodSourceFromStream.
	"Create method edition object."
	^(StsMethodEdition new)
		methodClass: className;
		selector: (self getMethodSelectorFrom: methodSource lines first);
		categoriesString: categoryOrPackage;
		developer: develop;
		timestamp: (TimeStamp date: date time: time);
		source: methodSource;
		yourself!

getMethodSelectorFrom: aString 
	| str selector |
	str := aString subStrings.
	selector := ''.
	1 to: str size
		by: 2
		do: [:ind | selector := selector , (str at: ind)].
	^selector asSymbol!

getMethodSourceFromStream
	| ws ch methodEnd |
	methodEnd := false.
	ws := WriteStream on: (String new: 512).
	[stream atEnd or: [methodEnd]] whileFalse: 
			[(ch := stream next) == $!! 
				ifFalse: [ws nextPut: ch]
				ifTrue: 
					[(ch := stream next) == $!! 
						ifTrue: [ws nextPut: ch]
						ifFalse: [stream next == $!! ifTrue: [methodEnd := true] ifFalse: [self error: 'Ilegal method source.']]]].
	self nextLineFromStream.
	^ws contents!

getTimeFromString: aString 
	| rs hours minutes seconds |
	^aString notEmpty 
		ifTrue: 
			[rs := ReadStream on: ((aString replaceAll: $, with: $:) replaceAll: $. with: $:).
			hours := self getIntegerFromString: (rs upTo: $:).
			minutes := self getIntegerFromString: (rs upTo: $:).
			seconds := self getIntegerFromString: (rs upTo: $:).
			hours > 23 ifTrue: [hours := 23].
			minutes > 59 ifTrue: [minutes := 59].
			seconds > 99 ifTrue: [seconds := 99].
			Time 
				hours: hours
				minutes: minutes
				seconds: seconds]!

importClassDefinition: firstLine 
	self changes add: ((StsChangedClassNode new)
				description: 'class added';
				leftEdition: (self getClassDefinition: firstLine);
				yourself)!

importMethodDefinition: firstLine 
	self changes add: ((StsChangedMethodNode new)
				description: 'method added';
				leftEdition: (self getMethodDefinition: firstLine))!

load
	"Implements import for file created by #fileOutChangeForSqueakOn: methods."

	| str |
	str := self nextLineFromStream.
	[stream atEnd] whileFalse: 
			["StsChangedClassNode - removed or created new class."
			('*Smalltalk removeClassNamed: #*!!' match: str) 
				ifTrue: 
					["Removed class definition."
					self removedClassDefinition: str]
				ifFalse: 
					["StsChangedClassDefinitionNode - Changed class definition or new class definition."
					(('* variableSubclass: #*' match: str) or: ['* subclass: #*' match: str]) 
						ifTrue: [self importClassDefinition: str]
						ifFalse: 
							["StsChangedMethodNode, StsChangedLooseMethodNode - removed, changed, created method."
							('* removeSelector: *!!' match: str) 
								ifTrue: 
									["Removed method."
									self removedMethodDefinition: str]
								ifFalse: [('!!* methodsFor: * stamp: *!!' match: str) ifTrue: [self importMethodDefinition: str]]]].
			str := self nextLineFromStream]!

loadFrom: pathname 
	| fileStream str |
	
	[fileStream := FileStream read: pathname text: true.
	str := fileStream contents] ensure: 
				[fileStream close.
				fileStream := nil].
	(str copyFrom: 1 to: 3) = #[16rEF 16rBB 16rBF] asString 
		ifTrue: 
			["Decode UTF8 encoded files."
			str := str copyFrom: 4 to: str size.
			((str respondsTo: #webUTF8Decoded) and: 
					[(ChoicePrompter 
						choices: #('Convert source from UTF-8 to CP1250' 'No conversion, read file as it is')
						caption: 'Select extended char set conversion') = 'Convert source from UTF-8 to CP1250']) 
				ifTrue: 
					[Processor activeProcess webRequestCodePage: 'windows-1250'.
					str := str webUTF8Decoded]].
	stream := ReadStream on: str.
	^self
		load;
		changes!

nextLineFromStream
	| result |
	stream atEnd ifTrue: [^''].
	result := stream upTo: 13 asCharacter.
	stream peek = 10 asCharacter ifTrue: [stream next].
	^result!

removedClassDefinition: firstLine 
	self changes add: ((StsChangedClassNode new)
				description: 'class removed';
				elementDescription: (firstLine copyFrom: 30 to: firstLine size - 1) , ' class';
				yourself)!

removedMethodDefinition: firstLine 
	| tokens str |
	tokens := firstLine subStrings.
	str := tokens first.
	(tokens at: 2) = 'class' ifTrue: [str := str , ' class'].
	str := str , '>>' , (tokens last copyFrom: 2 to: tokens last size - 1).
	self changes add: ((StsChangedMethodNode new)
				elementDescription: str;
				description: 'method removed';
				yourself)! !
!StsSqueakChangeSetProxy categoriesFor: #changes!private! !
!StsSqueakChangeSetProxy categoriesFor: #getClassDefinition:!private! !
!StsSqueakChangeSetProxy categoriesFor: #getDateFromString:dateFormat:!DAL methods!public! !
!StsSqueakChangeSetProxy categoriesFor: #getIntegerFromString:!DAL methods!public! !
!StsSqueakChangeSetProxy categoriesFor: #getMethodDefinition:!private! !
!StsSqueakChangeSetProxy categoriesFor: #getMethodSelectorFrom:!private! !
!StsSqueakChangeSetProxy categoriesFor: #getMethodSourceFromStream!private! !
!StsSqueakChangeSetProxy categoriesFor: #getTimeFromString:!DAL methods!public! !
!StsSqueakChangeSetProxy categoriesFor: #importClassDefinition:!private! !
!StsSqueakChangeSetProxy categoriesFor: #importMethodDefinition:!private! !
!StsSqueakChangeSetProxy categoriesFor: #load!private! !
!StsSqueakChangeSetProxy categoriesFor: #loadFrom:!public! !
!StsSqueakChangeSetProxy categoriesFor: #nextLineFromStream!private! !
!StsSqueakChangeSetProxy categoriesFor: #removedClassDefinition:!private! !
!StsSqueakChangeSetProxy categoriesFor: #removedMethodDefinition:!private! !

