"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'Tools.ChooseClassDialog'
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
	validationResultPresenter positionBlock: [self hintPosition].
	self createClassesPresenter!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.
	classesPresenter 
		when: #selectionChanged
		send: #onClassSelected
		to: self.
	classesPresenter selectableItems
		when: #mouseWheeled:
			send: #onClassListScrolled:
			to: self;
		when: #verticalScroll:
			send: #onClassListScrolled:
			to: self!

getHintCaption: aValidationResult
	^aValidationResult caption
		ifNil: [aValidationResult hint iconStyle == #error ifTrue: ['Invalid choice']]!

hintPosition
	"Private - Answer a <Point> representing the screen co-ordinate at which the hint bubble's arrow should point."

	| treeView itemRect sel |
	treeView := classesPresenter selectableItems selectableItems view.
	sel := treeView selectionByIndex.
	itemRect := sel = 0 ifTrue: [treeView rectangle] ifFalse: [treeView itemRect: sel textOnly: true].
	^treeView mapPointToScreen: itemRect centerRight!

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
	<commandQuery: #allowNil>
	self value: nil.
	self ok!

onClassListScrolled: aWindowsEvent
	self clearValidationResult!

onClassSelected
	self value: classesPresenter selectionOrNil.
	self validate!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	"Unfortunately the selection is not represented as a value model, so we must sync. it manually"
	[classesPresenter selectionOrNil: self value] postToInputQueue.
	(self view viewNamed: 'none' ifNone: [])
		ifNotNil: 
			[:noneButton |
			noneButton
				isWindowVisible: self allowNil;
				text: self nilButtonCaption]!

packages: aCollection 
	"Set the packages selected in the receiver. Ignored at this level."

	!

validateModel
	(allowNil or: [self value notNil])
		ifFalse: 
			[^(ValidationResult errorMessage: 'Please select a class')
				caption: 'Incomplete Input';
				presenter: classesPresenter;
				yourself].
	^ValidationResult new!

validationResultPresenterClass
	^ValidationHintPresenter! !

!Tools.ChooseClassDialog categoriesForMethods!
allowNil!accessing!public! !
allowNil:!accessing!public! !
classes:!initializing!private! !
classesPresenterClass!constants!private! !
createClassesPresenter!initializing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
getHintCaption:!helpers!private! !
hintPosition!accessing!private! !
initialize!initializing!private! !
nilButtonCaption!accessing!public! !
nilButtonCaption:!accessing!public! !
none!commands!public! !
onClassListScrolled:!event handling!private! !
onClassSelected!event handling!public! !
onViewOpened!event handling!public! !
packages:!public!selection! !
validateModel!helpers!private! !
validationResultPresenterClass!constants!public! !
!

!Tools.ChooseClassDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^SmalltalkSystem current icon!

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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 210 1 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 240 50 2 8 1140850688 131073 320 nil nil nil 5 nil nil nil 320 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[174 0 0 0 5 0 0 0 88 1 0 0 35 0 0 0] 193 352 8 '' 320 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 240 50 2 8 1409286144 131073 656 nil nil nil 5 nil nil nil 656 838 1 #{UI.FlowLayout} 17 17 9 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 2 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1141055488 1 800 nil nil nil 5 nil nil nil 800 nil nil 1350 4 #{UI.CommandDescription} #none 8 'None' 1 1 nil nil false nil nil nil 418 50 2 466 #createWindow: 50 1 514 546 8 #[2 0 0 0 8 0 0 0 77 0 0 0 31 0 0 0] 193 832 8 'None' 800 466 #isEnabled: 8 #(false) 800 3 8 #() 626 193 193 nil 29 8 'none' 518 #{Graphics.Rectangle} 626 5 17 626 1 1 418 50 1 466 #createWindow: 50 1 514 546 8 #[0 0 0 0 5 0 0 0 85 0 0 0 35 0 0 0] 193 688 8 '' 656 3 50 1 800 626 193 193 nil 27 nil 550 #{Core.IdentityDictionary} 0 1122 626 1 11 626 1 1 418 50 1 466 #createWindow: 50 1 514 546 8 #[10 0 0 0 60 1 0 0 98 1 0 0 95 1 0 0] 193 272 8 '' 240 3 50 2 656 320 626 193 193 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 132097 1584 nil nil nil 5 nil nil nil 1584 386 #{Tools.ClassHierarchySelector} #resource_Default_view nil 418 50 1 466 #createWindow: 50 1 514 546 8 #[10 0 0 0 10 0 0 0 98 1 0 0 60 1 0 0] 193 1616 8 '' 1584 3 608 626 193 193 nil 27 754 1344 50 2 1584 8 'classSelector' 1122 626 21 21 626 21 21 nil nil nil nil 1 nil nil nil 626 661 521 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 418 50 2 466 #createWindow: 50 1 518 #{UI.CreateDialog} 1122 626 7679 21 626 8439 821 193 32 466 #setWindowText: 50 1 8 'Choose Class…' 32 1 50 2 1584 240 626 193 193 nil 29)! !

!Tools.ChooseClassDialog class categoriesForMethods!
icon!accessing!constants!public! !
on:choices:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

