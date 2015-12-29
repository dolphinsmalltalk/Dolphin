"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

Object subclass: #SUnitBrowserAbsUIState
	instanceVariableNames: 'model'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserAbsUIState guid: (GUID fromString: '{FE7A51B0-7675-4DFB-A250-EB2049ABFF16}')!
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

