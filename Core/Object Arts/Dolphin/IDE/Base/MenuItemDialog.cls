"Filed out from Dolphin Smalltalk"!

Dialog subclass: #MenuItemDialog
	instanceVariableNames: 'titlePresenter commandPresenter iconPresenter imageModel iconIdPresenter inspector cardsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MenuItemDialog guid: (GUID fromString: '{ec0e406d-75f7-437d-8d69-34cfd92846b7}')!

MenuItemDialog comment: 'MenuItemDialog is the abstract class of <dialogPresenter>s used to edit menu entries.

Instance Variables:
	titlePresenter		<TextPresenter> for the #title aspect.
	commandPresenter	<TextPresenter> for the #commandString aspect.
	iconPresenter		<ImagePresenter>
	imageModel			<ValueAspectAdaptor>
	iconIdPresenter		<TextPresenter>
'!

!MenuItemDialog categoriesForClass!Unclassified! !

!MenuItemDialog methodsFor!

chooseIcon
	Icon choose ifNotNil: [:icon | imageModel value: icon]!

clearIcon
	imageModel value: nil!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	titlePresenter := self add: TextPresenter new name: 'title'.
	commandPresenter := self add: TextPresenter new name: 'command'.
	iconPresenter := self add: ImagePresenter new name: 'icon'.
	iconIdPresenter := self add: TextPresenter new name: 'iconId'.
	inspector := self add: PublishedAspectInspector new name: 'inspector'
!

createSchematicWiring
	super createSchematicWiring.
	inspector 
		when: #inspecteeChanged
		send: #onInspecteeChanged
		to: self!

model: aCommandMenuItem
	"Set the model associated with the receiver."

	| aspectBuffer |
	super model: aCommandMenuItem.
	aspectBuffer := self model.
	titlePresenter model: (aspectBuffer aspectValue: #description).
	commandPresenter model: (aspectBuffer aspectValue: #commandString).
	imageModel := aspectBuffer aspectValue: #image.
	iconPresenter model: (ValueConverter subject: imageModel
				typeConverter: (PluggableTypeConverter leftToRight: [:icon | icon asMenuBitmap]
						rightToLeft: [:icon | icon])).
	iconIdPresenter model: (ValueConverter subject: imageModel
				typeConverter: (PluggableTypeConverter leftToRight: [:icon | icon printString]
						rightToLeft: [:id | Icon fromId: id])).
	inspector model: aspectBuffer value!

onCardChanged
	cardsPresenter currentCard = inspector view parentView ifTrue: [inspector refresh]!

onInspecteeChanged
	self model notifyChanged!

onViewOpened
	super onViewOpened.
	cardsPresenter := self view viewNamed: 'cards'.
	cardsPresenter 
		when: #currentCardChanged
		send: #onCardChanged
		to: self!

queryCommand: aCommandQuery 
	"Enters details about a potential command for the receiver into the <CommandQuery>
	arugment."

	| cmd |
	cmd := aCommandQuery commandSymbol.
	#clearIcon == cmd 
		ifTrue: 
			[aCommandQuery isEnabled: imageModel value notNil.
			^true].
	^super queryCommand: aCommandQuery ! !

!MenuItemDialog categoriesForMethods!
chooseIcon!commands!private! !
clearIcon!commands!private! !
createComponents!public! !
createSchematicWiring!initializing!public! !
model:!public! !
onCardChanged!event handling!private! !
onInspecteeChanged!event handling!private! !
onViewOpened!event handling!public! !
queryCommand:!public! !
!

!MenuItemDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^Menu icon
! !

!MenuItemDialog class categoriesForMethods!
icon!constants!public! !
!

