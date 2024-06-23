"Filed out from Dolphin Smalltalk"!

Object subclass: #SUnitBrowserAbsUIState
	instanceVariableNames: 'model'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SUnitBrowserAbsUIState guid: (GUID fromString: '{fe7a51b0-7675-4dfb-a250-eb2049abff16}')!

SUnitBrowserAbsUIState comment: ''!

!SUnitBrowserAbsUIState categoriesForClass!Unclassified! !

!SUnitBrowserAbsUIState methodsFor!

configuration

	^self model configuration!

greenBallIconSymbol

	^#greenBallIcon!

initializeModel: aModel

	self model: aModel!

model

	^model!

model: aModel

	model := aModel!

redBallIconSymbol

	^#redBallIcon! !

!SUnitBrowserAbsUIState categoriesForMethods!
configuration!accessing!private! !
greenBallIconSymbol!constants!private! !
initializeModel:!initializing!private! !
model!accessing!private! !
model:!accessing!private! !
redBallIconSymbol!constants!private! !
!

!SUnitBrowserAbsUIState class methodsFor!

newOn: aModel

	^self new
		initializeModel: aModel;
		yourself! !

!SUnitBrowserAbsUIState class categoriesForMethods!
newOn:!instantiating!public! !
!

