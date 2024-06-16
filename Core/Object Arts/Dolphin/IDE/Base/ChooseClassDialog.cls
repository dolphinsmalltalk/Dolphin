"Filed out from Dolphin Smalltalk"!

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

!ChooseClassDialog categoriesForMethods!
allowNil!accessing!public! !
allowNil:!accessing!public! !
classesPresenterClass!constants!private! !
createClassesPresenter!initializing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
initialize!initializing!private! !
onClassSelected!event handling!public! !
onViewOpened!event handling!public! !
packages:!public!selection! !
queryCommand:!commands!private! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[10 0 0 0 60 1 0 0 98 1 0 0 95 1 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 132097 960 nil nil nil 5 nil nil nil 960 674 ##(Smalltalk.ClassHierarchySelector) #resource_Default_view nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[10 0 0 0 10 0 0 0 98 1 0 0 60 1 0 0] 193 992 8 '' 960 3 912 930 193 193 nil 27 170 192 34 2 960 8 'classSelector' 590342 ##(Smalltalk.Rectangle) 930 21 21 930 21 21 nil nil nil nil 10597 nil nil nil 930 661 521 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1250 930 1 1 930 761 801 193 416 770 #setWindowText: 34 1 8 'Choose Class...' 416 1 34 2 960 608 930 193 193 nil 29 )! !

!ChooseClassDialog class categoriesForMethods!
icon!accessing!constants!public! !
resource_Default_view!public!resources-views! !
!

