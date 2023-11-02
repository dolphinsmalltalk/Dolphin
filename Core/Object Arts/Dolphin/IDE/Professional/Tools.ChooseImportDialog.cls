"Filed out from Dolphin Smalltalk"!

Tools.ChooseNamespaceDialog
	subclass: #'Tools.ChooseImportDialog'
	instanceVariableNames: 'private hintBubble namespacesOnly'
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
	namespacesOnly := self add: BooleanPresenter new name: 'namespacesOnly'.
	"Commonly one wants to import a Namespace, rather than any other type of class, so show only Namespaces by default"
	namespacesOnly value: true!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"

	super createSchematicWiring.
	private
		when: #valueChanged
		send: #onPrivateChanged
		to: self.
	namespacesOnly
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
	namespacesOnly value
		ifTrue: 
			[self
				classes: self class namespacesClassHierarchy;
				caption: 'Choose Namespace to Import...']
		ifFalse:
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 21 639 210 689 65 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 63 1 0 0 98 1 0 0 95 1 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 242 1 9 nil 18 #{UI.ContainerView} 50 15 nil 576 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 242 1 1 nil nil 18 #{UI.CheckBox} 50 16 nil 656 50 2 8 1409363203 1 736 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 736 nil nil 518 #{UI.NullConverter} nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 389 1 210 301 61 736 418 #text: 50 1 8 '&Namespaces Only' 736 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 194 0 0 0 0 0 0 0 88 1 0 0 30 0 0 0] 8 #() 560 nil 27 18 #{UI.CheckBox} 50 16 nil 656 50 2 8 1409363203 1 1088 802 nil nil 848 false nil nil 5 nil nil nil 1088 nil nil 866 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 1 210 301 61 1088 418 #text: 50 1 8 '&Private?' 1088 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 150 0 0 0 30 0 0 0] 8 #() 560 nil 27 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 736 8 'namespacesOnly' 1088 8 'private' nil 370 50 1 418 #createAt:extent: 50 2 210 1 559 210 689 61 656 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 23 1 0 0 88 1 0 0 53 1 0 0] 50 2 1088 736 560 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 576 50 2 8 1140850688 132097 1600 nil nil nil 5 nil nil nil 1600 338 #{Tools.ClassHierarchySelector} #resource_Default_view nil 370 50 1 418 #createAt:extent: 50 2 210 1 1 210 689 551 1600 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 88 1 0 0 19 1 0 0] 544 560 nil 27 1378 #{Core.IdentityDictionary} 50 2 1600 8 'classSelector' nil 370 50 1 418 #createAt:extent: 50 2 210 21 21 210 689 619 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 98 1 0 0 63 1 0 0] 50 2 1600 656 560 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 1 nil nil nil 210 661 521 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 761 801 32 418 #text: 50 1 8 'Choose Namespace to Import…' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 123 13 0 0 154 1 0 0] 50 2 576 272 560 nil 27)! !
!Tools.ChooseImportDialog class categoriesForMethods!
namespacesClassHierarchy!constants!private! !
on:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

