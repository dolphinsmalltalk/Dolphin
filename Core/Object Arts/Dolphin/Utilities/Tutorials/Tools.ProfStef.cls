"Filed out from Dolphin Smalltalk 7"!

Tools.TutorialPlayer subclass: #'Tools.ProfStef'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'default'
	classConstants: {}!
Tools.ProfStef guid: (Core.GUID fromString: '{60f1ec8a-daba-4ccb-bbe6-a35d8192215a}')!
Tools.ProfStef comment: 'A ProfStef is the Smalltalk teacher. To start the tutorial, evaluate:
ProfStef go.

To go to the next lesson evaluate:
ProfStef next.

To execute your own tutorial:
ProfStef goOn: MyOwnTutorial

To see a table of contents with all defined tutorials:
ProfStef contents'!
!Tools.ProfStef categoriesForClass!Unclassified! !
!Tools.ProfStef methodsFor!

onViewDestroyed
	super onViewDestroyed.
	self class reset! !
!Tools.ProfStef categoriesFor: #onViewDestroyed!event handling!private! !

!Tools.ProfStef class methodsFor!

default 
	^ default ifNil: [default := super show]
!

defaultModel
	^Tools.SmalltalkSyntaxTutorial new!

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
!Tools.ProfStef class categoriesFor: #default!initialize!public! !
!Tools.ProfStef class categoriesFor: #defaultModel!public! !
!Tools.ProfStef class categoriesFor: #first!navigation!public! !
!Tools.ProfStef class categoriesFor: #go!navigation!public! !
!Tools.ProfStef class categoriesFor: #initialize!public! !
!Tools.ProfStef class categoriesFor: #next!navigation!public! !
!Tools.ProfStef class categoriesFor: #previous!navigation!public! !
!Tools.ProfStef class categoriesFor: #reset!initialize!private! !
!Tools.ProfStef class categoriesFor: #show!initialize!public! !

