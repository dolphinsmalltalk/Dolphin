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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 610 1 1 nil nil 410 #{UI.ReferenceView} 34 14 nil 640 34 2 8 1140850688 131073 720 nil nil nil 7 nil nil nil 720 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 349 11 578 341 61 720 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 5 0 0 0 88 1 0 0 35 0 0 0] 8 #() 578 193 193 nil 27 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1409286144 131073 1024 nil nil nil 7 nil nil nil 1024 852806 1 #{UI.FlowLayout} 17 17 9 170 192 34 2 410 #{UI.PushButton} 34 20 nil 1024 34 2 8 1141055488 1 1152 nil nil nil 7 nil nil nil 1152 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #none 8 'None' 1 1 nil nil false nil nil nil 818 34 3 866 #createAt:extent: 34 2 578 5 17 578 151 47 1152 866 #isEnabled: 8 #(false) 1152 866 #text: 34 1 8 'None' 1152 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 8 0 0 0 77 0 0 0 31 0 0 0] 8 #() 1008 nil 29 8 'none' 1180166 #{Graphics.Rectangle} 578 5 17 578 1 1 818 34 1 866 #createAt:extent: 34 2 578 1 11 578 171 61 1024 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 85 0 0 0 35 0 0 0] 34 1 1152 1008 nil 27 nil 170 192 992 1522 578 1 11 578 1 1 818 34 1 866 #createAt:extent: 34 2 578 21 633 578 689 71 640 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 98 1 0 0 95 1 0 0] 34 2 1024 720 1008 nil 27 nil nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 132097 1936 nil nil nil 7 nil nil nil 1936 786 #{Tools.ClassHierarchySelector} #resource_Default_view nil 818 34 1 866 #createAt:extent: 34 2 578 21 21 578 689 613 1936 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 60 1 0 0] 992 1008 nil 27 170 192 34 2 1936 8 'classSelector' 1522 578 21 21 578 21 21 nil nil nil nil 59387 nil nil nil 578 661 521 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 818 34 2 866 #createAt:extent: 34 2 578 12287 21 578 761 801 416 866 #text: 34 1 8 'Choose Class…' 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 123 25 0 0 154 1 0 0] 34 2 1936 640 1008 nil 27)! !
!Tools.ChooseClassDialog class categoriesForMethods!
icon!accessing!constants!public! !
on:choices:caption:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

