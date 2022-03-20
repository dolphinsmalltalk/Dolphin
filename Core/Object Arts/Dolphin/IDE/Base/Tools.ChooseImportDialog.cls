"Filed out from Dolphin Smalltalk"!

Tools.ChooseNamespaceDialog subclass: #'Tools.ChooseImportDialog'
	instanceVariableNames: 'private hintBubble includeClasses'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ChooseImportDialog guid: (Core.GUID fromString: '{0cd7d4a9-4b98-4d2d-9f04-5361024a98ba}')!
Tools.ChooseImportDialog comment: ''!
!Tools.ChooseImportDialog categoriesForClass!MVP-Presenters! !
!Tools.ChooseImportDialog methodsFor!

bufferedModelFor: aSubjectValueModel
	^(super bufferedModelFor: aSubjectValueModel) validater: 
			[:bindingRef |
			bindingRef
				ifNil: [ValidationResult errorMessage: 'Choose a class/namespace to import']
				ifNotNil: 
					[((RBCondition isClassBinding: bindingRef)
						& (RBCondition withBlock: 
									[| ns |
									ns := bindingRef value.
									ns ~~ Root and: 
											[(ns class conformsToProtocol: #importableNamespace)
												and: [ns isVisiblyAbstract not or: [(ns includesBehavior: Namespace) not]]]]
								errorString: bindingRef displayString , ' is <1?:not >an importable namespace'))
							validate
						caption: 'Invalid selection';
						yourself]]!

closeBubble
	hintBubble
		ifNotNil: 
			[hintBubble close.
			hintBubble := nil]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	private := self add: BooleanPresenter new name: 'private'.
	includeClasses := self add: BooleanPresenter new name: 'includeClasses'.!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.
	private
		when: #valueChanged
		send: #onPrivateChanged
		to: self.
	includeClasses
		when: #valueChanged
		send: #onToggleClasses
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
		ifNil: [aValidationResult hint iconStyle == #error ifTrue: ['Invalid Input']]!

hintPosition
	"Private - Answer a <Point> representing the screen co-ordinate at which the hint bubble's arrow should point."

	| treeView itemRect |
	treeView := classesPresenter selectableItems view.
	itemRect := treeView itemRect: treeView selectionByIndex textOnly: true.
	^treeView mapPointToScreen: itemRect centerRight !

onClassListScrolled: aWindowsEvent
	self closeBubble!

onClassSelected
	| bindingRef |
	classesPresenter selectionOrNil
		ifNotNil: 
			[:class |
			bindingRef := class asQualifiedReference.
			bindingRef isPrivate: private value].
	self
		value: bindingRef;
		validate!

onPrivateChanged
	self value ifNotNil: [:bindingRef | bindingRef isPrivate: private value]!

onToggleClasses
	| class |
	self closeBubble.
	class := classesPresenter selectionOrNil.
	includeClasses value
		ifFalse: 
			[self
				classes: self class namespacesClassHierarchy;
				caption: 'Choose Namespace to Import...']
		ifTrue: 
			[self
				classes: NamespaceHierarchyModel new;
				caption: 'Choose Namespace/Class to Import...'].
	classesPresenter selection: class ifAbsent: []!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG, which is a keyboard message."

	(aMSG isKeyPress: VK_RETURN)
		ifTrue: 
			[| button |
			"If the default button is disabled, it may be helpful to show validation errors"
			button := self view defaultButton.
			(button notNil and: [button isEnabled not]) ifTrue: [self validate]].
	^super preTranslateKeyboardInput: aMSG!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok
		ifTrue: 
			[aCommandQuery isEnabled: self isInputValid.
			^true].
	^super queryCommand: aCommandQuery!

showValidationResult: aValidationResult
	self closeBubble.
	(aValidationResult hint isNil or: [self value isNil]) ifTrue: [^self].
	hintBubble := MessageBubble new.
	hintBubble
		caption: (self getHintCaption: aValidationResult);
		font: self hintFont;
		timeout: self hintDwell;
		position: self hintPosition;
		exceptionDescription: aValidationResult hint;
		isSilent: true;
		open! !
!Tools.ChooseImportDialog categoriesForMethods!
bufferedModelFor:!helpers!private! !
closeBubble!helpers!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
getHintCaption:!helpers!private! !
hintPosition!accessing!private! !
onClassListScrolled:!event handling!private! !
onClassSelected!commands!event handling!private! !
onPrivateChanged!event handling!private! !
onToggleClasses!event handling!private! !
preTranslateKeyboardInput:!dispatching!public! !
queryCommand:!commands!private! !
showValidationResult:!helpers!private! !
!

!Tools.ChooseImportDialog class methodsFor!

namespacesClassHierarchy
	^ClassHierarchyModel withRoots: (Namespace subclasses copyWithout: Root) sort!

on: aValueModel
	^(super on: aValueModel)
		classes: self namespacesClassHierarchy;
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 610 1 1 nil nil 410 #{UI.ReferenceView} 34 14 nil 640 34 2 8 1140850688 131073 720 nil nil nil 7 nil nil nil 720 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 349 11 578 341 61 720 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 5 0 0 0 88 1 0 0 35 0 0 0] 8 #() 578 193 193 nil 27 410 #{UI.ContainerView} 34 15 nil 640 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 nil 170 192 34 2 410 #{UI.CheckBox} 34 16 nil 1024 34 2 8 1409363203 1 1120 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 1120 nil 8 1785475200 1049094 #{UI.NullConverter} nil nil nil 818 34 2 866 #createAt:extent: 34 2 578 1 11 578 331 61 1120 866 #text: 34 1 8 'Show refactoring changes?' 1120 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 165 0 0 0 35 0 0 0] 8 #() 1008 nil 27 8 'showChanges' nil 818 34 1 866 #createAt:extent: 34 2 578 1 11 578 341 61 1024 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 170 0 0 0 35 0 0 0] 34 1 1120 1008 nil 27 nil 170 192 992 1180166 #{Graphics.Rectangle} 578 1 11 578 1 1 818 34 1 866 #createAt:extent: 34 2 578 21 633 578 689 71 640 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 60 1 0 0 98 1 0 0 95 1 0 0] 34 2 720 1024 1008 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 1872 nil nil nil 7 nil nil nil 1872 610 1 9 nil 410 #{UI.ContainerView} 34 15 nil 1872 34 2 8 1140850688 131073 1952 nil nil nil 7 nil nil nil 1952 610 1 1 nil nil 410 #{UI.CheckBox} 34 16 nil 1952 34 2 8 1409363203 1 2032 1186 nil nil 1232 false nil nil 7 nil nil nil 2032 nil 8 1785475200 1266 nil nil nil 818 34 2 866 #createAt:extent: 34 2 578 389 1 578 301 61 2032 866 #text: 34 1 8 'Include All Classes?' 2032 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 194 0 0 0 0 0 0 0 88 1 0 0 30 0 0 0] 8 #() 1008 nil 27 410 #{UI.CheckBox} 34 16 nil 1952 34 2 8 1409363203 1 2336 1186 nil nil 1232 false nil nil 7 nil nil nil 2336 nil 8 1785475200 1266 nil nil nil 818 34 2 866 #createAt:extent: 34 2 578 1 1 578 301 61 2336 866 #text: 34 1 8 'Private?' 2336 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 150 0 0 0 30 0 0 0] 8 #() 1008 nil 27 nil 170 192 34 4 2032 8 'includeClasses' 2336 8 'private' nil 818 34 1 866 #createAt:extent: 34 2 578 1 553 578 689 61 1952 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 20 1 0 0 88 1 0 0 50 1 0 0] 34 2 2336 2032 1008 nil 27 nil nil 410 #{UI.ReferenceView} 34 14 nil 1872 34 2 8 1140850688 132097 2848 nil nil nil 7 nil nil nil 2848 786 #{Tools.ClassHierarchySelector} #resource_Default_view nil 818 34 1 866 #createAt:extent: 34 2 578 1 1 578 689 545 2848 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 16 1 0 0] 992 1008 nil 27 170 192 34 2 2848 8 'classSelector' nil 818 34 1 866 #createAt:extent: 34 2 578 21 21 578 689 613 1872 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 60 1 0 0] 34 2 2848 1952 1008 nil 27 170 192 992 1666 578 21 21 578 21 21 nil nil nil nil 21749 nil nil nil 578 661 521 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2008186960 818 34 2 866 #createAt:extent: 34 2 578 12287 21 578 761 801 416 866 #text: 34 1 8 'Choose Namespace to Import…' 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 123 25 0 0 154 1 0 0] 34 2 1872 640 1008 nil 27)! !
!Tools.ChooseImportDialog class categoriesForMethods!
namespacesClassHierarchy!constants!private! !
on:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

