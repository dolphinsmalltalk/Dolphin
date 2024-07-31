"Filed out from Dolphin Smalltalk"!

Tools.ChooseNamespaceDialog
	subclass: #'Tools.ChooseImportDialog'
	instanceVariableNames: 'private namespacesOnly'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private})
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ChooseImportDialog guid: (Core.GUID fromString: '{0cd7d4a9-4b98-4d2d-9f04-5361024a98ba}')!

Tools.ChooseImportDialog comment: ''!

!Tools.ChooseImportDialog categoriesForClass!MVP-Presenters! !

!Tools.ChooseImportDialog methodsFor!

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
		to: self!

model: aValueModel
	super model: aValueModel.
	self validater: [:value | self validateSelection: value]!

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
	self clearValidationResult.
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

validateSelection: aBindingReference
	^aBindingReference
		ifNil: [ValidationResult errorMessage: 'Choose a <?namespace:class> to import' << namespacesOnly value]
		ifNotNil: 
			[((RBCondition isClassBinding: aBindingReference)
				& (RBCondition withBlock: 
							[| ns |
							ns := aBindingReference value.
							ns ~~ Root and: 
									[(ns class conformsToProtocol: #importableNamespace)
										and: [ns isVisiblyAbstract not or: [(ns includesBehavior: Namespace) not]]]]
						errorString: aBindingReference displayString , ' is <?:not >an importable namespace'))
					validate
				caption: 'Invalid selection';
				yourself]! !

!Tools.ChooseImportDialog categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
model:!accessing!public! !
onClassSelected!commands!event handling!private! !
onPrivateChanged!event handling!private! !
onToggleClasses!event handling!private! !
validateSelection:!helpers!private! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_Refactoring_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 63 1 0 0 98 1 0 0 95 1 0 0] 193 272 8 '' 240 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 210 1 9 nil 18 #{UI.ContainerView} 50 15 nil 576 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 210 1 1 nil nil 18 #{UI.CheckBox} 50 16 nil 656 50 2 8 1409363203 1 736 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 736 nil nil 518 #{UI.NullConverter} nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[194 0 0 0 0 0 0 0 88 1 0 0 30 0 0 0] 193 768 8 '&Namespaces Only' 736 3 8 #() 546 193 193 nil 27 18 #{UI.CheckBox} 50 16 nil 656 50 2 8 1409363203 1 1056 802 nil nil 848 false nil nil 5 nil nil nil 1056 nil nil 866 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 150 0 0 0 30 0 0 0] 193 1088 8 '&Private?' 1056 3 8 #() 546 193 193 nil 27 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 736 8 'namespacesOnly' 1056 8 'private' nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 23 1 0 0 88 1 0 0 53 1 0 0] 193 688 8 '' 656 3 50 2 1056 736 546 193 193 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 576 50 2 8 1140850688 132097 1552 nil nil nil 5 nil nil nil 1552 306 #{Tools.ClassHierarchySelector} #resource_Default_view nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 88 1 0 0 19 1 0 0] 193 1584 8 '' 1552 3 528 546 193 193 nil 27 1314 #{Core.IdentityDictionary} 50 2 1552 8 'classSelector' nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[10 0 0 0 10 0 0 0 98 1 0 0 63 1 0 0] 193 608 8 '' 576 3 50 2 1552 656 546 193 193 nil 27 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 546 21 21 546 21 21 nil nil nil nil 1 nil nil nil 546 661 521 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 338 50 2 386 #createWindow: 50 1 518 #{UI.CreateDialog} 2018 546 7679 21 546 8439 821 193 32 386 #setWindowText: 50 1 8 'Choose Namespace to Import…' 32 1 50 2 576 240 546 193 193 nil 29)! !

!Tools.ChooseImportDialog class categoriesForMethods!
namespacesClassHierarchy!constants!private! !
on:!instance creation!public! !
resource_Default_view!public!resources-views! !
!

