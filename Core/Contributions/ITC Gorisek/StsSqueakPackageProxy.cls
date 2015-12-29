"Filed out from Dolphin Smalltalk X6.2"!

StsPackageProxy subclass: #StsSqueakPackageProxy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsSqueakPackageProxy guid: (GUID fromString: '{AE63A81C-3E72-44BB-A614-5C152A4EA1F4}')!
StsSqueakPackageProxy comment: ''!
!StsSqueakPackageProxy categoriesForClass!Unclassified! !
!StsSqueakPackageProxy methodsFor!

createCompleteClassDefinition: classProxy name: className instVars: instVars classVars: classVars poolDicts: poolDicts classInstVars: classInstVars 
	| readStream definition |
	readStream := ReadStream on: classProxy definition.
	className isNil 
		ifTrue: [definition := readStream nextLine]
		ifFalse: 
			[definition := className.
			readStream nextLine].
	instVars isNil 
		ifTrue: [definition := definition , '
' , readStream nextLine]
		ifFalse: 
			[definition := definition , '
	' , instVars.
			readStream nextLine].
	classVars isNil 
		ifTrue: [definition := definition , '
' , readStream nextLine]
		ifFalse: 
			[definition := definition , '
	' , classVars.
			readStream nextLine].
	poolDicts isNil 
		ifTrue: [definition := definition , '
' , readStream nextLine]
		ifFalse: 
			[definition := definition , '
	' , poolDicts.
			readStream nextLine].
	classInstVars isNil 
		ifTrue: [definition := definition , '
' , readStream nextLine]
		ifFalse: 
			[definition := definition , '
	' , classInstVars.
			readStream nextLine].
	classProxy definition: definition!

importClassDefinition: firstLine 
	| classProxy tokens str className instVars classVars poolDicts |
	className := firstLine.
	(className isNil or: [self isClassBegin: firstLine]) ifFalse: [^false].
	tokens := className subStrings.
	(className endsWith: 'class') 
		ifTrue: 
			[classProxy := self findOrCreateClassNamed: (tokens at: 1) asSymbol.
			str := self nextLineFromStream trimBlanks.
			self 
				createCompleteClassDefinition: classProxy
				name: nil
				instVars: nil
				classVars: nil
				poolDicts: nil
				classInstVars: (self removeEndingSpace: 'classI' , (str copyFrom: 2 to: str size - 1))]
		ifFalse: 
			[str := tokens at: 3.
			classProxy := self findOrCreateClassNamed: (str copyFrom: 2 to: str size) asSymbol.
			instVars := self nextLineFromStream trimBlanks.
			classVars := self nextLineFromStream trimBlanks.
			str := self nextLineFromStream trimBlanks.
			poolDicts := str copyFrom: 1 to: str size.
			self 
				createCompleteClassDefinition: classProxy
				name: className
				instVars: (self removeEndingSpace: instVars)
				classVars: (self removeEndingSpace: classVars)
				poolDicts: (self removeEndingSpace: poolDicts)
				classInstVars: nil].
	(str := self nextLineFromStream) isEmpty 
		ifFalse: 
			["category := str subStrings at: 2"
			].
	^true!

importCommentFor: classProxy info: infoLine 
	| commentString nextLine |
	nextLine := self nextLineFromStream.
	commentString := ''.
	
	[nextLine notEmpty and: 
			[nextLine last = $!! 
				and: [nextLine size = 1 or: [nextLine size > 1 and: [(nextLine at: nextLine size - 1) ~= $!!]]]]] 
			whileFalse: 
				[commentString := commentString , '
' , nextLine.
				nextLine := self nextLineFromStream].
	commentString isEmpty ifFalse: [commentString := commentString , '
'].
	commentString := commentString , (nextLine copyFrom: 1 to: nextLine size - 1).
	classProxy comment: commentString!

importMethodsFor: classProxy info: infoLine 
	| methodInfo category methodSource method |
	methodInfo := self parseMethodInfo: infoLine.
	methodSource := self nextLineFromStream.
	[methodSource endsWith: '!! !!'] 
		whileFalse: [methodSource := methodSource , '
' , self nextLineFromStream].
	methodSource := self 
				replaceSqueakAssignmentWithStandardAssignmentIn: (methodSource copyFrom: 1 to: methodSource size - 3).
	method := (StsCompiledMethodProxy new)
				methodSource: (self undoubleMarkers: methodSource);
				methodClass: classProxy.
	(methodInfo at: 'developer' ifAbsent: []) isNil 
		ifFalse: [method developer: (methodInfo at: 'developer')].
	(methodInfo at: 'timestamp' ifAbsent: []) isNil 
		ifFalse: [method timestamp: (methodInfo at: 'timestamp')].
	category := methodInfo at: 'category' ifAbsent: [].
	category isNil 
		ifTrue: [method isPrivate: false]
		ifFalse: 
			[category = 'private' 
				ifTrue: [method isPrivate: true]
				ifFalse: [method categoriesString: category , '!!']].
	classProxy methodDictionary at: method selector put: method!

isClassBegin: aString 
	^('* subclass: *' match: aString) or: [aString endsWith: 'class']!

isMethodBegin: aString 
	^aString notEmpty and: [aString first = $!!]!

loadFrom: pathname 
	| str |
	classes := OrderedCollection new.
	looseMethods := OrderedCollection new.
	version := ''.
	comment := ''.
	resources := OrderedCollection new.
	name := File removeExtension: (File splitFilenameFrom: pathname).
	stream := FileStream read: pathname text: true.
	
	[
	[str := self nextLineFromStream.
	str isNil or: ['* subclass: *' match: str]] whileFalse: [].
	str isNil ifTrue: [^nil].
	[stream atEnd] whileFalse: 
			[[stream atEnd or: [(self isClassBegin: str) or: [self isMethodBegin: str]]] 
				whileFalse: [str := self nextLineFromStream].
			stream atEnd 
				ifFalse: 
					[(self isMethodBegin: str) ifTrue: [self parseMethod: str] ifFalse: [self importClassDefinition: str]].
			str := self nextLineFromStream]] 
			ensure: [stream close]!

manualPrerequisites
	^#()!

nextLineFromStream
	| result |
	stream atEnd ifTrue: [^''].
	result := stream upTo: 13 asCharacter.
	stream peek = 10 asCharacter ifTrue: [stream next].
	^result!

parseMethod: firstLine 
	| str token className classProxy isLoose |
	str := firstLine.
	token := str subStrings first.
	className := token copyFrom: 2 to: token size.
	classProxy := self classNamed: className asSymbol.
	(isLoose := classProxy isNil) ifTrue: [classProxy := StsClassProxy new name: className].
	(str subStrings at: 2) = 'class' 
		ifTrue: 
			[classProxy := classProxy metaClass.
			token := str subStrings at: 3]
		ifFalse: [token := str subStrings at: 2].
	(token = 'methodsFor:' or: [token = 'commentStamp:']) 
		ifTrue: 
			[token = 'methodsFor:' 
				ifTrue: 
					[self importMethodsFor: classProxy info: str.
					isLoose ifTrue: [looseMethods addAll: classProxy methods]].
			token = 'commentStamp:' ifTrue: [self importCommentFor: classProxy info: str]]
		ifFalse: [stream skipToAll: '!! !!']!

parseMethodInfo: aString 
	| result readStream stamp tokens date time tmpDeveloper |
	result := LookupTable new.
	readStream := ReadStream on: aString.
	readStream skipTo: $'.
	result at: 'category' put: (readStream upTo: $').
	readStream skipTo: $'.
	stamp := readStream upTo: $'.
	(stamp isNil or: [stamp isEmpty]) 
		ifFalse: 
			[tokens := stamp trimBlanks subStrings.
			tmpDeveloper := 'unknown Squeak developer'.
			date := Date today.
			time := Time fromSeconds: Time now asSeconds.
			tokens do: 
					[:each | 
					(each includes: $/) 
						ifTrue: [[date := Date fromString: each format: 'MM/DD/YYYY'] on: Error do: [:ex | ]]
						ifFalse: 
							[(each includes: $:) 
								ifTrue: [[time := Time fromString: each] on: Error do: [:ex | ]]
								ifFalse: [tmpDeveloper := each]]].
			result
				at: 'developer' put: tmpDeveloper;
				at: 'timestamp' put: (TimeStamp date: date time: time)].
	^result!

replaceSqueakAssignmentWithStandardAssignmentIn: sourceString 
	| rs ch ws |
	rs := ReadStream on: sourceString.
	ws := WriteStream on: String new.
	[rs atEnd] whileFalse: 
			[ch := rs next.
			ch = $_ 
				ifTrue: [ws nextPutAll: ':=']
				ifFalse: 
					[ch = $' 
						ifTrue: 
							[ws nextPut: $'.
							
							[rs atEnd ifTrue: [^ws contents].
							ch := rs next.
							ws nextPut: ch.
							ch = $'] 
									whileFalse]
						ifFalse: 
							[ch = $" 
								ifTrue: 
									[ws nextPut: $".
									
									[rs atEnd ifTrue: [^ws contents].
									ch := rs next.
									ws nextPut: ch.
									ch = $"] 
											whileFalse]
								ifFalse: 
									[ws nextPut: ch.
									ch = $$ ifTrue: [rs atEnd ifTrue: [^ws contents] ifFalse: [ws nextPut: rs next]]]]]].
	^ws contents! !
!StsSqueakPackageProxy categoriesFor: #createCompleteClassDefinition:name:instVars:classVars:poolDicts:classInstVars:!private! !
!StsSqueakPackageProxy categoriesFor: #importClassDefinition:!private! !
!StsSqueakPackageProxy categoriesFor: #importCommentFor:info:!private! !
!StsSqueakPackageProxy categoriesFor: #importMethodsFor:info:!private! !
!StsSqueakPackageProxy categoriesFor: #isClassBegin:!private! !
!StsSqueakPackageProxy categoriesFor: #isMethodBegin:!private! !
!StsSqueakPackageProxy categoriesFor: #loadFrom:!public! !
!StsSqueakPackageProxy categoriesFor: #manualPrerequisites!public! !
!StsSqueakPackageProxy categoriesFor: #nextLineFromStream!private! !
!StsSqueakPackageProxy categoriesFor: #parseMethod:!private! !
!StsSqueakPackageProxy categoriesFor: #parseMethodInfo:!private! !
!StsSqueakPackageProxy categoriesFor: #replaceSqueakAssignmentWithStandardAssignmentIn:!private! !

