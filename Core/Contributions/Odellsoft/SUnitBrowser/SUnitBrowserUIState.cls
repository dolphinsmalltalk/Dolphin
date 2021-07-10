"Filed out from Dolphin Smalltalk"!

SUnitBrowserAbsUIState subclass: #SUnitBrowserUIState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserUIState guid: (GUID fromString: '{6d60a596-d4ba-4107-81f5-58ba06dde6db}')!
SUnitBrowserUIState comment: ''!
!SUnitBrowserUIState categoriesForClass!Unclassified! !
!SUnitBrowserUIState methodsFor!

areAnyTestsCompleted

	^self testResult areAnyTestsCompleted!

colorSymbolFor: aTest

	| resultState |

	self configuration showBackgroundColors
		ifFalse: [^self notYetRunColorSymbol].

	resultState := self resultStateFor: aTest.

	resultState isNil
		ifTrue: [^self notYetRunColorSymbol].

	^resultState = #failWithError
		ifTrue: [self errorColorSymbol]
		ifFalse: [
			resultState = #fail
				ifTrue: [self failureColorSymbol]
				ifFalse: [self passedColorSymbol]]!

detailState

	| aStream |

	aStream := WriteStream on: (String new: 60).

	^aStream
		nextPutAll: self testResult passedCount printString;
		nextPutAll: ' passed, ';
		nextPutAll: self testResult failureCount printString;
		nextPutAll: ' failure(s), ';
		nextPutAll: self testResult errorCount printString;
		nextPutAll: ' error(s) out of ';
		nextPutAll: self model numberOfTests printString;
		nextPutAll: ' test(s)';
		contents!

errorColorSymbol

	^#red!

failureColorSymbol

	^#yellow!

grayBallIconSymbol

	^#grayBallIcon!

iconSymbolFor: aTest

	| resultState |

	self configuration showIcons not
		ifTrue: [^nil].

	resultState := self resultStateFor: aTest.

	resultState isNil
		ifTrue: [^self grayBallIconSymbol].

	^resultState = #failWithError
		ifTrue: [self redBallIconSymbol]
		ifFalse: [
			resultState = #fail
				ifTrue: [self yellowBallIconSymbol]
				ifFalse: [self greenBallIconSymbol]]!

notYetRunColorSymbol

	^#white!

passedColorSymbol

	^#commonGreen!

resultStateColorSymbol

	self areAnyTestsCompleted
		ifFalse: [^#gray].

	^self testResult hasErrors
		ifTrue: [self errorColorSymbol]
		ifFalse: [
			self testResult hasFailures
				ifTrue: [self failureColorSymbol]
				ifFalse: [self passedColorSymbol]]!

resultStateFor: aTest

	| allTests hasError hasFailure hasPassed |

	self testResult isNil
		ifTrue: [^nil].

	allTests := aTest allTests.

	hasError := allTests anySatisfy:[:each | self testResult isError: each].

	hasError
		ifTrue: [^#failWithError].

	hasFailure := allTests anySatisfy: [:each | self testResult isFailure: each].

	hasFailure
		ifTrue: [^#fail].

	hasPassed := allTests anySatisfy: [:each | self testResult isPassed: each].

	hasPassed
		ifTrue: [^#passed].

	^nil!

resultStateString

	| aString |

	self areAnyTestsCompleted
		ifFalse: [^'- N/A -'].

	aString :=
		self testResult hasErrors
			ifTrue: ['Fail with Errors']
			ifFalse: [
				self testResult hasFailures
					ifTrue: ['Fail']
					ifFalse: ['Pass']].

	self testResult areAllTestsCompleted
		ifFalse: [aString := aString , ' (incomplete)'].

	^'- ' , aString , ' -'!

showAllColorSymbol

	^self configuration showAll
		ifTrue: [#green]
		ifFalse: [#red]!

showAllLabel

	^self configuration showAll
		ifTrue: ['All']
		ifFalse: ['Errors']!

testResult

	^self model testResult!

yellowBallIconSymbol

	^#yellowBallIcon! !
!SUnitBrowserUIState categoriesForMethods!
areAnyTestsCompleted!private!querying! !
colorSymbolFor:!color!public! !
detailState!public!strings! !
errorColorSymbol!constants!private! !
failureColorSymbol!constants!private! !
grayBallIconSymbol!constants!private! !
iconSymbolFor:!icons!public! !
notYetRunColorSymbol!constants!private! !
passedColorSymbol!constants!private! !
resultStateColorSymbol!color!public! !
resultStateFor:!icons!private! !
resultStateString!public!strings! !
showAllColorSymbol!color!public! !
showAllLabel!public!strings! !
testResult!accessing!private! !
yellowBallIconSymbol!constants!private! !
!

