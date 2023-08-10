"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'Tools.ChooseClassDialog'
	instanceVariableNames: 'classesPresenter allowNil nilButtonCaption validater'
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
	classesPresenter selectionOrNil: self value.
	(self view viewNamed: 'none' ifNone: [])
		ifNotNil: 
			[:noneButton |
			noneButton
				isWindowVisible: self allowNil;
				text: self nilButtonCaption]!

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
	^super queryCommand: query!

validate
	^self validater value: self value!

validater
	^self model validater!

validater: aMonadicValuable
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the current reply text as its argument first argument, and is expected to answer a <ValuationResult>, the value of which indicates whether the text is considered valid in context. The OK button is not enabled until the ValidationResult's value is true. The validator can also pass out a hint details to be displayed in a message bubble if desired (see ValidationResult for the options available). The hint is primarily intended as a means to explain to the user why the OK button is disabled, as this can otherwise be difficult to understand."

	self model validater: aMonadicValuable! !
!Tools.ChooseClassDialog categoriesForMethods!
allowNil!accessing!public! !
allowNil:!accessing!public! !
classes:!initializing!private! !
classesPresenterClass!constants!private! !
createClassesPresenter!initializing!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
initialize!initializing!private! !
nilButtonCaption!accessing!public! !
nilButtonCaption:!accessing!public! !
none!commands!public! !
onClassSelected!event handling!public! !
onViewOpened!event handling!public! !
packages:!public!selection! !
queryCommand:!commands!private! !
validate!operations!public! !
validater!accessing!public! !
validater:!initializing!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 242 1 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 272 50 2 8 1140850688 131073 352 nil nil nil 7 nil nil nil 352 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 349 11 210 341 61 352 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 5 0 0 0 88 1 0 0 35 0 0 0] 8 #() 210 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 272 50 2 8 1409286144 131073 656 nil nil nil 7 nil nil nil 656 838 1 #{UI.FlowLayout} 17 17 9 550 #{Core.IdentityDictionary} 1 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1141055488 1 784 nil nil nil 7 nil nil nil 784 nil 8 1853182784 1350 4 #{UI.CommandDescription} #none 8 'None' 1 1 nil nil false nil nil nil 450 50 3 498 #createAt:extent: 50 2 210 5 17 210 151 47 784 498 #isEnabled: 8 #(false) 784 498 #text: 50 1 8 'None' 784 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 8 0 0 0 77 0 0 0 31 0 0 0] 8 #() 640 nil 29 8 'none' 518 #{Graphics.Rectangle} 210 5 17 210 1 1 450 50 1 498 #createAt:extent: 50 2 210 1 11 210 171 61 656 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 85 0 0 0 35 0 0 0] 50 1 784 640 nil 27 nil 754 0 1154 210 1 11 210 1 1 450 50 1 498 #createAt:extent: 50 2 210 21 633 210 689 71 272 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 98 1 0 0 95 1 0 0] 50 2 656 352 640 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 132097 1568 nil nil nil 7 nil nil nil 1568 418 #{Tools.ClassHierarchySelector} #resource_Default_view nil 450 50 1 498 #createAt:extent: 50 2 210 21 21 210 689 613 1568 578 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 60 1 0 0] 624 640 nil 27 754 1 1568 8 'classSelector' 1154 210 21 21 210 21 21 nil nil nil nil 13967 nil nil nil 210 661 521 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 450 50 2 498 #createAt:extent: 50 2 210 6143 21 210 761 801 32 498 #text: 50 1 8 'Choose Class…' 32 578 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 154 1 0 0] 50 2 1568 272 640 nil 27)! !
!Tools.ChooseClassDialog class categoriesForMethods!
icon!accessing!constants!public! !
on:choices:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

