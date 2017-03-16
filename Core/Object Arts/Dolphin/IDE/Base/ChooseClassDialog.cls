"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #ChooseClassDialog
	instanceVariableNames: 'classesPresenter allowNil'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ChooseClassDialog guid: (GUID fromString: '{7a80fce1-9f6e-4c81-b2e1-ba93fa3c693a}')!
ChooseClassDialog comment: 'ChooseClassDialog is a <valueDialogPresenter> that can be used to prompt for a <Class>.

Instance Variables:
	classesPresenter		<classSelector> the presenter from which the choice of class can be made
	allowNil				<boolean>, controls whether the OK button is enabled when there is no selection

'!
!ChooseClassDialog categoriesForClass!MVP-Presenters! !
!ChooseClassDialog methodsFor!

allowNil
	^allowNil!

allowNil: aBoolean
	allowNil := aBoolean!

classesPresenterClass
	^ClassHierarchySelector!

createClassesPresenter
	classesPresenter := self add: self classesPresenterClass new name: 'classSelector'!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self createClassesPresenter!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.
	classesPresenter 
		when: #selectionChanged
		send: #onClassSelected
		to: self!

initialize
	super initialize.
	allowNil := false!

onClassSelected
	self value: classesPresenter selectionOrNil!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	"Unfortunately the selection is not represented as a value model, so we must sync. it manually"
	classesPresenter selectionOrNil: self model value!

packages: aCollection 
	"Set the packages selected in the receiver. Ignored at this level."

	!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| cmd |
	cmd := query commandSymbol.
	cmd == #ok 
		ifTrue: 
			[query isEnabled: (allowNil or: [self value notNil]).
			^true].
	^super queryCommand: query! !
!ChooseClassDialog categoriesFor: #allowNil!accessing!public! !
!ChooseClassDialog categoriesFor: #allowNil:!accessing!public! !
!ChooseClassDialog categoriesFor: #classesPresenterClass!constants!private! !
!ChooseClassDialog categoriesFor: #createClassesPresenter!initializing!private! !
!ChooseClassDialog categoriesFor: #createComponents!initializing!public! !
!ChooseClassDialog categoriesFor: #createSchematicWiring!initializing!public! !
!ChooseClassDialog categoriesFor: #initialize!initializing!private! !
!ChooseClassDialog categoriesFor: #onClassSelected!event handling!public! !
!ChooseClassDialog categoriesFor: #onViewOpened!event handling!public! !
!ChooseClassDialog categoriesFor: #packages:!public!selection! !
!ChooseClassDialog categoriesFor: #queryCommand:!commands!private! !

!ChooseClassDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^Smalltalk developmentSystem icon
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  21 643 834 705 71 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 65 1 0 0 106 1 0 0 100 1 0 0] 98 0 834 193 193 0 27 0 0 410 576 98 14 0 416 98 2 8 1140850688 132097 960 0 0 0 7 0 0 0 960 642 8 ##(Smalltalk.ClassHierarchySelector)  8 #resource_Default_view 0 706 202 208 98 1 770 800 98 2 834 21 21 834 705 623 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 106 1 0 0 65 1 0 0] 928 944 0 27 234 256 98 2 960 8 'classSelector' 590342 ##(Smalltalk.Rectangle)  834 21 21 834 21 21 0 0 0 0 14321 0 0 0 834 661 521 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 706 202 208 98 3 770 800 98 2 834 2799 21 834 761 801 416 770 8 #text: 98 1 8 'Choose Class...' 416 770 8 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 243 6 0 0 154 1 0 0] 98 2 960 560 944 0 27 )! !
!ChooseClassDialog class categoriesFor: #icon!accessing!constants!public! !
!ChooseClassDialog class categoriesFor: #resource_Default_view!public!resources-views! !

