"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.MockMessageSend'
	instanceVariableNames: 'selector arguments argc behavior'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockMessageSend guid: (Core.GUID fromString: '{f4828fef-70cf-4c61-bf85-eb8bba6372d8}')!

XProgramming.SUnit.MockMessageSend comment: 'I am a message that a MockObject instance has been trained to expect.'!

!XProgramming.SUnit.MockMessageSend methodsFor!

matches: aMessage
	^(self matchesSelector: aMessage selector) and: [self matchesArguments: aMessage arguments]!

matchesArguments: anArray
	"implementation note: the MockObject any acts as a joker to say that the object is counted but we do not care of its value. See the class comment of MockObject."

	arguments ifNil: [^true].
	anArray size == argc ifFalse: [^false].
	1 to: argc do: [:i | | expected |
		expected := arguments at: i.
		(expected ~~ MockObject.Any and: [(anArray at: i) ~= expected]) ifTrue: [^false]].
	^true!

matchesSelector: aSymbol
	^selector == aSymbol!

on: aSymbol with: anArray do: aBlock
	selector := aSymbol.
	arguments := anArray.
	argc := (anArray ?? []) size.
	behavior := aBlock.
!

printOn: aStream
	aStream nextPutAll: selector.
	argc == 0 ifTrue: [^self].
	argc > 1 ifTrue: [aStream nextPutAll: ' ('].
	aStream space.
	arguments do: [:arg | arg printOn: aStream] separatedBy: [aStream nextPutAll: ', '].
	argc > 1 ifTrue: [aStream nextPutAll: ' )']!

selector
	^selector!

valueWithPossibleArgs: anArray
	^behavior valueWithPossibleArgs: anArray! !

!XProgramming.SUnit.MockMessageSend categoriesForMethods!
matches:!public!testing! !
matchesArguments:!public!testing! !
matchesSelector:!public!testing! !
on:with:do:!initialization!private! !
printOn:!printing!public! !
selector!accessing!public! !
valueWithPossibleArgs:!evaluating!private! !
!

!XProgramming.SUnit.MockMessageSend class methodsFor!

on: aSymbol with: anArray do: aBlock
	^self new
		on: aSymbol
			with: anArray
			do: aBlock;
		yourself! !

!XProgramming.SUnit.MockMessageSend class categoriesForMethods!
on:with:do:!instance creation!public! !
!

