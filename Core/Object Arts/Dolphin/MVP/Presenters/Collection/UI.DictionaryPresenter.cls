"Filed out from Dolphin Smalltalk"!

UI.HashedCollectionPresenter
	subclass: #'UI.DictionaryPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.DictionaryPresenter guid: (Core.GUID fromString: '{8337cb38-a2d9-47dc-95f6-b262e86adca6}')!
UI.DictionaryPresenter comment: ''!
!UI.DictionaryPresenter categoriesForClass!MVP-Presenters! !
!UI.DictionaryPresenter methodsFor!

elements
	^self value associations 
		asSortedCollection: [:x :y | x key displayString < y key displayString]!

removeElement: anAssociation
	self value: ((self value)
				removeKey: anAssociation key;
				yourself)! !
!UI.DictionaryPresenter categoriesForMethods!
elements!accessing!public! !
removeElement:!private!removing! !
!

!UI.DictionaryPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Dictionary new asValue! !
!UI.DictionaryPresenter class categoriesForMethods!
defaultModel!models!public! !
!

