"Filed out from Dolphin Smalltalk 7"!

TutorialPlayer subclass: #ProfStef
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'default'
	classConstants: {}!
ProfStef guid: (GUID fromString: '{60f1ec8a-daba-4ccb-bbe6-a35d8192215a}')!
ProfStef comment: 'A ProfStef is the Smalltalk teacher. To start the tutorial, evaluate:
ProfStef go.

To go to the next lesson evaluate:
ProfStef next.

To execute your own tutorial:
ProfStef goOn: MyOwnTutorial

To see a table of contents with all defined tutorials:
ProfStef contents'!
!ProfStef categoriesForClass!Unclassified! !
!ProfStef methodsFor!

onViewDestroyed
	super onViewDestroyed.
	self class reset! !
!ProfStef categoriesFor: #onViewDestroyed!event handling!private! !

!ProfStef class methodsFor!

default 
	^ default ifNil: [default := super show]
!

defaultModel 	
	^SmalltalkSyntaxTutorial new!

first
	"Move to the first lesson. We post to the input queue to avoid issues
	if the user has chosen to display a result - we don't want this
	inserted in our new contents."

	[self default first] postToInputQueue!

go
	self first.
!

initialize
	"
	self initialize.
	"
	Smalltalk developmentSystem addAdditionalToolsFolderIconFor: self description: 'Learn Smalltalk'!

next
	"Move to the next lesson. We post to the input queue to avoid issues
	if the user has chosen to display a result - we don't want this
	inserted in our new contents."

	[self default next] postToInputQueue!

previous
	"Move to the previous lesson. We post to the input queue to avoid issues
	if the user has chosen to display a result - we don't want this
	inserted in our new contents."

	[self default previous] postToInputQueue!

reset
	default := nil
!

show
	| profStef |
	profStef := self default.
	profStef view beActive.
	^profStef! !
!ProfStef class categoriesFor: #default!initialize!public! !
!ProfStef class categoriesFor: #defaultModel!public! !
!ProfStef class categoriesFor: #first!navigation!public! !
!ProfStef class categoriesFor: #go!navigation!public! !
!ProfStef class categoriesFor: #initialize!public! !
!ProfStef class categoriesFor: #next!navigation!public! !
!ProfStef class categoriesFor: #previous!navigation!public! !
!ProfStef class categoriesFor: #reset!initialize!private! !
!ProfStef class categoriesFor: #show!initialize!public! !

