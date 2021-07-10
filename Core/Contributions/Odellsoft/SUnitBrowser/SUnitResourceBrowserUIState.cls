"Filed out from Dolphin Smalltalk"!

SUnitBrowserAbsUIState subclass: #SUnitResourceBrowserUIState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitResourceBrowserUIState guid: (GUID fromString: '{987711fe-782c-4a38-a20f-f1042f01b6d8}')!
SUnitResourceBrowserUIState comment: ''!
!SUnitResourceBrowserUIState categoriesForClass!Unclassified! !
!SUnitResourceBrowserUIState methodsFor!

colorSymbolFor: aResource

	self configuration showBackgroundColors
		ifFalse: [^#white].

	aResource isNil
		ifTrue: [^#white].

	^aResource isAvailable
		ifTrue: [#green]
		ifFalse: [#red]!

detailState

	| aStream |

	aStream := WriteStream on: (String new: 40).

	^aStream
		nextPutAll: self model availableCount printString;
		nextPutAll: ' available, ';
		nextPutAll: self model unavailableCount printString;
		nextPutAll: ' unavailable';
		contents!

iconSymbolFor: aResource

	self configuration showIcons not
		ifTrue: [^nil].

	^aResource isAvailable
		ifTrue: [self greenBallIconSymbol]
		ifFalse: [self redBallIconSymbol]!

resultStateColorSymbol

	^self model unavailableResources isEmpty
		ifTrue: [#commonGreen]
		ifFalse: [#red]! !
!SUnitResourceBrowserUIState categoriesForMethods!
colorSymbolFor:!color!public! !
detailState!public!strings! !
iconSymbolFor:!icons!public! !
resultStateColorSymbol!color!public! !
!

