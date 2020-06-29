"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SUnitBrowserAbsUIState
	instanceVariableNames: 'model'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!SUnitBrowserAbsUIState categoriesFor: #configuration!accessing!private! !
!SUnitBrowserAbsUIState categoriesFor: #greenBallIconSymbol!constants!private! !
!SUnitBrowserAbsUIState categoriesFor: #initializeModel:!initializing!private! !
!SUnitBrowserAbsUIState categoriesFor: #model!accessing!private! !
!SUnitBrowserAbsUIState categoriesFor: #model:!accessing!private! !
!SUnitBrowserAbsUIState categoriesFor: #redBallIconSymbol!constants!private! !

!SUnitBrowserAbsUIState class methodsFor!

newOn: aModel

	^self new
		initializeModel: aModel;
		yourself! !
!SUnitBrowserAbsUIState class categoriesFor: #newOn:!instantiating!public! !

