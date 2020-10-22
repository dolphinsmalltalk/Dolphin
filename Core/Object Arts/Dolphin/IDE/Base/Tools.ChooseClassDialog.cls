"Filed out from Dolphin Smalltalk 7"!

UI.ValueDialog subclass: #'Tools.ChooseClassDialog'
	instanceVariableNames: 'classesPresenter allowNil nilButtonCaption'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ChooseClassDialog guid: (Core.GUID fromString: '{7a80fce1-9f6e-4c81-b2e1-ba93fa3c693a}')!
Tools.ChooseClassDialog comment: 'ChooseClassDialog is a <valueDialogPresenter> that can be used to prompt for a <Class>.

Instance Variables:
	classesPresenter		<classSelector> the presenter from which the choice of class can be made
	allowNil				<boolean>, controls whether the OK button is enabled when there is no selection

'!
!Tools.ChooseClassDialog categoriesForClass!MVP-Presenters! !
!Tools.ChooseClassDialog methodsFor!

allowNil
	^allowNil!

allowNil: aBoolean
	allowNil := aBoolean.
	(self view viewNamed: 'none') isWindowVisible: aBoolean!

classes: aClassHierarchyModel
	classesPresenter model: aClassHierarchyModel!

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
	allowNil := false.
	nilButtonCaption := '&None'!

nilButtonCaption
	^nilButtonCaption!

nilButtonCaption: aString
	nilButtonCaption := aString.
	(self view viewNamed: 'none') text: aString!

none
	self value: nil.
	self ok!

onClassSelected
	self value: classesPresenter selectionOrNil!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	"Unfortunately the selection is not represented as a value model, so we must sync. it manually"
	classesPresenter selectionOrNil: self model value.
	(self view viewNamed: 'none') 
		isWindowVisible: self allowNil;
		text: self nilButtonCaption!

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
	cmd == #none
		ifTrue: 
			[query isEnabled: allowNil.
			^true].
	^super queryCommand: query! !
!Tools.ChooseClassDialog categoriesFor: #allowNil!accessing!public! !
!Tools.ChooseClassDialog categoriesFor: #allowNil:!accessing!public! !
!Tools.ChooseClassDialog categoriesFor: #classes:!initializing!private! !
!Tools.ChooseClassDialog categoriesFor: #classesPresenterClass!constants!private! !
!Tools.ChooseClassDialog categoriesFor: #createClassesPresenter!initializing!private! !
!Tools.ChooseClassDialog categoriesFor: #createComponents!initializing!public! !
!Tools.ChooseClassDialog categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ChooseClassDialog categoriesFor: #initialize!initializing!private! !
!Tools.ChooseClassDialog categoriesFor: #nilButtonCaption!accessing!public! !
!Tools.ChooseClassDialog categoriesFor: #nilButtonCaption:!accessing!public! !
!Tools.ChooseClassDialog categoriesFor: #none!commands!public! !
!Tools.ChooseClassDialog categoriesFor: #onClassSelected!event handling!public! !
!Tools.ChooseClassDialog categoriesFor: #onViewOpened!event handling!public! !
!Tools.ChooseClassDialog categoriesFor: #packages:!public!selection! !
!Tools.ChooseClassDialog categoriesFor: #queryCommand:!commands!private! !

!Tools.ChooseClassDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^Smalltalk developmentSystem icon
!

on: aValueModel choices: aClassHierarchyModel caption: aString
	^(self on: aValueModel)
		classes: aClassHierarchyModel;
		createView: self defaultView;
		caption: aString;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 167 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 610 1 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 640 34 2 8 1140850688 131073 720 nil nil nil 7 nil nil nil 720 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 349 11 578 341 61 720 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 5 0 0 0 88 1 0 0 35 0 0 0] 8 #() 578 193 193 nil 27 410 ##(UI.ContainerView) 34 15 nil 640 34 2 8 1409286144 131073 1040 nil nil nil 7 nil nil nil 1040 852806 1 ##(UI.FlowLayout) 17 17 9 170 192 34 2 410 ##(UI.PushButton) 34 20 nil 1040 34 2 8 1141055488 1 1168 nil nil nil 7 nil nil nil 1168 nil 8 1907908560 1377606 4 ##(UI.CommandDescription) #none 8 'None' 1 1 nil nil false nil nil nil 818 138 144 34 3 882 #createAt:extent: 34 2 578 5 17 578 151 47 1168 882 #isEnabled: 8 #(false) 1168 882 #text: 34 1 8 'None' 1168 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 8 0 0 0 77 0 0 0 31 0 0 0] 8 #() 1024 nil 29 8 'none' 1180166 ##(Graphics.Rectangle) 578 5 17 578 1 1 818 138 144 34 1 882 #createAt:extent: 34 2 578 1 11 578 171 61 1040 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 85 0 0 0 35 0 0 0] 34 1 1168 1024 nil 27 nil 170 192 1008 1554 578 1 11 578 1 1 818 138 144 34 1 882 #createAt:extent: 34 2 578 21 633 578 689 71 640 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 98 1 0 0 95 1 0 0] 34 2 1040 720 1024 nil 27 nil nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 132097 2000 nil nil nil 7 nil nil nil 2000 786 ##(Tools.ClassHierarchySelector) #resource_Default_view nil 818 138 144 34 1 882 #createAt:extent: 34 2 578 21 21 578 689 613 2000 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 60 1 0 0] 1008 1024 nil 27 170 192 34 2 2000 8 'classSelector' 1554 578 21 21 578 21 21 nil nil nil nil 37277 nil nil nil 578 661 521 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2010539792 818 138 144 34 2 882 #createAt:extent: 34 2 578 6143 21 578 761 801 416 882 #text: 34 1 8 'Choose Class...' 416 962 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 154 1 0 0] 34 2 2000 640 1024 nil 27 )! !
!Tools.ChooseClassDialog class categoriesFor: #icon!accessing!constants!public! !
!Tools.ChooseClassDialog class categoriesFor: #on:choices:caption:!instance creation!public! !
!Tools.ChooseClassDialog class categoriesFor: #resource_Default_view!public!resources-views! !

