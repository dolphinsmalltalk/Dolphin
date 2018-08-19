"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #CreateSubclassDialog
	instanceVariableNames: 'packagesPresenter subclassesPresenter namePresenter usePackagePresenter package superclassPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CreateSubclassDialog guid: (GUID fromString: '{97279c55-7e9a-41d4-ac28-bf3c10201966}')!
CreateSubclassDialog comment: 'CreateSubclassDialog implements a dialog for gather the information necessary to create classes in the IDE. 

Instance Variables:
	packagesPresenter		<PackageSelector>. Used to choose the package of the new class.
	subclassesPresenter		<MultipleChoicePresenter>. Used to choose subclasses of the new class (in Dolphin Professional)
	namePresenter			<TextPresenter>. Used to enter the name of the new class.
	usePackagePresenter		<BooleanPresenter>. Used to choose whether or not to package the new class (or leave unpackaged)
	package					<Package>. The chosen package.
	superclassPresenter		<TextPresenter> used to display the superclass of the new class.

'!
!CreateSubclassDialog categoriesForClass!Development!MVP-Presenters! !
!CreateSubclassDialog methodsFor!

canApply
	^(self isPackaged not or: [self package notNil]) and: 
			[| candidateName |
			candidateName := self subclassName.
			candidateName notEmpty and: 
					[(ClassBuilder isValidClassName: candidateName) 
						and: [(self environment includesKey: candidateName asSymbol) not]]]!

chooseSuperclass
	Smalltalk developmentSystem 
		chooseClass: superclassPresenter model
		caption: 'Choose Superclass...'
		allowNil: true!

createComponents
	super createComponents.
	namePresenter := self add: TextPresenter new name: 'className'.
	superclassPresenter := self add: TextPresenter new name: 'superclass'.
	packagesPresenter := self add: ((PackageSelector new)
						autoSelect: false;
						yourself)
				name: 'package'.
	subclassesPresenter := self add: ChoicePresenter new name: 'subclasses'.
	usePackagePresenter := self add: BooleanPresenter new name: 'setPackage'.
	usePackagePresenter model: true!

createSchematicWiring
	super createSchematicWiring.
	packagesPresenter 
		when: #selectionChanged
		send: #onPackageSelected
		to: self.
	usePackagePresenter 
		when: #valueChanged
		send: #toggleSetPackage
		to: self.
	superclassPresenter 
		when: #valueChanged
		send: #onSuperclassChanged
		to: self!

environment
	"Private - Answer the global environment for which we are defining a subclass."

	^self superclass isNil ifTrue: [Smalltalk] ifFalse: [self superclass environment]!

isPackaged
	^usePackagePresenter model value!

model: aSubjectModel 
	| aClassOrNil |
	super model: aSubjectModel.
	aClassOrNil := aSubjectModel value.
	package := Smalltalk developmentSystem defaultPackage.
	superclassPresenter model: aClassOrNil.
	namePresenter model: aClassOrNil name asValue.
	self onSuperclassChanged!

onPackageSelected
	package := packagesPresenter selectionOrNil!

onSuperclassChanged
	| superClass |
	superClass := self superclass.
	superClass isNil 
		ifTrue: [subclassesPresenter choices: Smalltalk allRoots]
		ifFalse: 
			[subclassesPresenter choices: superClass subclasses.
			package isNil ifTrue: [package := superClass owningPackage]]!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	self updatePackage!

package
	^package!

package: aPackage
	package := aPackage == Package uncommitted ifFalse: [aPackage].
	self isOpen ifTrue: [self updatePackage]!

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[aCommandQuery isEnabled: self canApply.
			^true].
	^super queryCommand: aCommandQuery!

subclasses
	^subclassesPresenter model value ?? #()!

subclassName
	^namePresenter value!

subclassName: aString 
	namePresenter value: aString!

superclass
	^superclassPresenter value!

toggleSetPackage
	self isPackaged 
		ifTrue: 
			[package := packagesPresenter selectionOrNil.
			packagesPresenter isEnabled: true]
		ifFalse: 
			[package := nil.
			packagesPresenter isEnabled: false]!

updatePackage
	package isNil 
		ifTrue: [usePackagePresenter value: false]
		ifFalse: 
			[usePackagePresenter value: true.
			packagesPresenter selection: package]! !
!CreateSubclassDialog categoriesFor: #canApply!private!testing! !
!CreateSubclassDialog categoriesFor: #chooseSuperclass!commands!public! !
!CreateSubclassDialog categoriesFor: #createComponents!initializing!public! !
!CreateSubclassDialog categoriesFor: #createSchematicWiring!initializing!public! !
!CreateSubclassDialog categoriesFor: #environment!constants!private! !
!CreateSubclassDialog categoriesFor: #isPackaged!commands!private! !
!CreateSubclassDialog categoriesFor: #model:!accessing!public! !
!CreateSubclassDialog categoriesFor: #onPackageSelected!event handling!private! !
!CreateSubclassDialog categoriesFor: #onSuperclassChanged!event handling!private! !
!CreateSubclassDialog categoriesFor: #onViewOpened!event handling!public! !
!CreateSubclassDialog categoriesFor: #package!accessing!public! !
!CreateSubclassDialog categoriesFor: #package:!accessing!public! !
!CreateSubclassDialog categoriesFor: #queryCommand:!commands!private! !
!CreateSubclassDialog categoriesFor: #subclasses!accessing!public! !
!CreateSubclassDialog categoriesFor: #subclassName!accessing!public! !
!CreateSubclassDialog categoriesFor: #subclassName:!accessing!public! !
!CreateSubclassDialog categoriesFor: #superclass!accessing!public! !
!CreateSubclassDialog categoriesFor: #toggleSetPackage!commands!private! !
!CreateSubclassDialog categoriesFor: #updatePackage!private!updating! !

!CreateSubclassDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^Icon fromId: 'NewClass.ico'
!

newSubclassOf: aClassOrNil inPackage: aPackage 
	| dialog |
	dialog := self on: aClassOrNil asValue.
	dialog
		package: aPackage;
		createView: (Smalltalk developmentSystem canRefactor 
					ifTrue: [self refactoringView]
					ifFalse: [self defaultView]).
	^dialog!

refactoringView
	^'Refactoring view'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 786950 ##(Smalltalk.ThemeColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 25 673 578 731 71 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 1 0 0 121 1 0 0 115 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 610 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 1168 nil nil nil 7 nil nil nil 1168 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 5 578 191 41 1168 802 #text: 34 1 8 'New class name:' 1168 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 95 0 0 0 22 0 0 0] 8 #() 944 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1522 #fixedViewLeft 191 1522 #fixedParentTop 5 1522 #fixedViewTop 41 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 1600 nil nil nil 7 nil nil nil 1600 nil 8 1912674480 1250 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 69 578 191 41 1600 802 #text: 34 1 8 'Superclass:' 1600 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 95 0 0 0 54 0 0 0] 8 #() 944 nil 27 1490 1536 1 1552 191 1522 #fixedPreviousBottom 25 1584 41 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1040 34 2 8 1140850960 1 1936 nil nil nil 7 nil nil nil 1936 nil 8 1912674480 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 129 578 731 5 1936 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 109 1 0 0 66 0 0 0] 8 #() 944 nil 27 1490 1536 1 1522 #fixedParentRight 1 1522 #fixedViewBottom -3 1522 #fixedParentBottom -7 410 ##(Smalltalk.PushButton) 34 20 nil 1040 34 2 8 1140924416 1 2240 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 2240 nil 8 1912725136 1180998 4 ##(Smalltalk.CommandDescription) #chooseSuperclass 8 '...' 1 1 nil nil false nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 578 691 65 578 41 41 2240 802 #isEnabled: 8 #(false) 2240 802 #text: 34 1 8 '...' 2240 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 32 0 0 0 109 1 0 0 52 0 0 0] 8 #() 944 nil 29 1490 1522 #fixedViewRight -39 2192 1 1522 #fixedPreviousTop 1 1584 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 2704 nil nil nil 7 nil nil nil 2704 nil 8 1912718128 1250 nil nil 7 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 65 578 487 41 2704 802 #setMarginWidths: 34 1 8 #(3 3) 2704 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 32 0 0 0 82 1 0 0 52 0 0 0] 8 #() 944 nil 27 1490 1522 #fixedPreviousRight 1 2192 -53 2688 -3 1584 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 3040 nil 2306 2336 nil 7 nil nil nil 3040 nil 8 1912718128 1250 nil nil 5 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 1 578 487 45 3040 802 #setMarginWidths: 34 1 8 #(3 3) 3040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 8 #() 944 nil 27 1490 3024 1 2192 -53 2688 -3 1584 45 170 192 34 4 3040 8 'className' 2704 8 'superclass' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 1 578 731 141 1040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 70 0 0 0] 34 6 1168 3040 1600 2704 2240 1936 944 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 3600 nil nil nil 7 nil nil nil 3600 1180166 ##(Smalltalk.ProportionalLayout) 170 176 928 false 170 192 928 590342 ##(Smalltalk.Rectangle) 578 1 7 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 141 578 731 509 3600 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 109 1 0 0 68 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3600 34 2 8 1140850688 131073 3952 nil nil nil 23 nil nil nil 3952 610 1 1 410 ##(Smalltalk.CheckBox) 34 16 nil 3952 34 2 8 1140924419 1 4032 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4162 #hash 8 #() false nil nil 7 nil nil nil 4032 nil 8 1912725136 1250 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 -1 578 731 51 4032 802 #text: 34 1 8 '&Packaged?' 4032 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 8 #() 944 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3952 34 2 8 1140850688 131073 4480 nil nil nil 7 nil nil nil 4480 706 ##(Smalltalk.PackageSelector) #resource_Choice_view nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 49 578 731 455 4480 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 109 1 0 0 251 0 0 0] 928 944 nil 27 170 192 34 2 4032 8 'setPackage' 3730 578 1 -1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 7 578 731 503 3952 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 109 1 0 0 254 0 0 0] 34 2 4032 4480 944 nil 27 944 nil 27 170 192 928 3730 578 1 1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 25 25 578 731 649 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 121 1 0 0 80 1 0 0] 34 2 1040 3600 944 nil 27 170 192 928 3730 578 25 25 578 25 21 nil nil nil nil 50527 nil nil nil 578 521 601 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 738 138 144 34 3 802 #createAt:extent: 34 2 578 3839 21 578 811 841 416 802 #text: 34 1 8 'Create Class...' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 20 9 0 0 174 1 0 0] 34 2 960 640 944 nil 27)!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 786950 ##(Smalltalk.ThemeColor) #dialog nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 25 673 578 841 71 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 1 0 0 176 1 0 0 115 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 610 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 1168 nil nil nil 7 nil nil nil 1168 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 73 578 191 43 1168 802 #text: 34 1 8 'Superclass:' 1168 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 95 0 0 0 57 0 0 0] 8 #() 944 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1522 #fixedViewLeft 191 1522 #fixedPreviousBottom 25 1522 #fixedViewTop 43 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 1600 nil nil nil 7 nil nil nil 1600 nil 8 1912718128 1250 nil nil 7 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 67 578 597 43 1600 802 #setMarginWidths: 34 1 8 #(3 3) 1600 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 33 0 0 0 137 1 0 0 54 0 0 0] 8 #() 944 nil 27 1490 1522 #fixedPreviousRight 1 1522 #fixedParentRight -53 1522 #fixedPreviousTop -5 1584 43 410 ##(Smalltalk.PushButton) 34 20 nil 1040 34 2 8 1140924416 1 1968 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 1968 nil 8 1912725136 1180998 4 ##(Smalltalk.CommandDescription) #chooseSuperclass 8 '...' 1 1 nil nil false nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 578 801 67 578 41 41 1968 802 #isEnabled: 8 #(false) 1968 802 #text: 34 1 8 '...' 1968 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 33 0 0 0 164 1 0 0 53 0 0 0] 8 #() 944 nil 29 1490 1522 #fixedViewRight -39 1936 1 1952 1 1584 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 2416 nil 2034 2064 nil 7 nil nil nil 2416 nil 8 1912718128 1250 nil nil 5 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 7 578 597 43 2416 802 #setMarginWidths: 34 1 8 #(3 3) 2416 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 3 0 0 0 137 1 0 0 24 0 0 0] 8 #() 944 nil 27 1490 1920 1 1936 -53 1952 -3 1584 43 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 2752 nil nil nil 7 nil nil nil 2752 nil 8 1912674480 1250 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 11 578 191 43 2752 802 #text: 34 1 8 '&New class name:' 2752 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 95 0 0 0 26 0 0 0] 8 #() 944 nil 27 1490 1536 1 1552 191 1522 #fixedParentTop 11 1584 43 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1040 34 2 8 1140850960 1 3088 nil nil nil 7 nil nil nil 3088 nil 8 1912674480 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 129 578 841 5 3088 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 164 1 0 0 66 0 0 0] 8 #() 944 nil 27 1490 1536 1 1936 1 1522 #fixedViewBottom -3 1522 #fixedParentBottom -7 170 192 34 4 2416 8 'className' 1600 8 'superclass' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 1 578 841 141 1040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 1 0 0 70 0 0 0] 34 6 2752 2416 1168 1600 1968 3088 944 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 3600 nil nil nil 7 nil nil nil 3600 1180166 ##(Smalltalk.ProportionalLayout) 170 176 928 false 170 192 34 2 410 ##(Smalltalk.ListView) 34 30 nil 3600 34 2 8 1140953161 1025 3744 590662 2 ##(Smalltalk.ListModel) 138 144 928 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 2034 8 4278190080 nil 7 nil nil nil 3744 nil 8 1912800272 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 578 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Subclasses' 409 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 3744 nil 3 nil nil #report 928 nil 133185 nil 8 #(nil) 738 138 144 34 2 802 #createAt:extent: 34 2 578 425 7 578 417 507 3744 802 #text: 34 1 8 'Subclasses' 3744 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 212 0 0 0 3 0 0 0 164 1 0 0 0 1 0 0] 8 #() 944 nil 27 8 'subclasses' 590342 ##(Smalltalk.Rectangle) 578 1 7 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 141 578 841 513 3600 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 164 1 0 0 70 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3600 34 2 8 1140850688 131073 4528 nil nil nil 23 nil nil nil 4528 610 1 1 410 ##(Smalltalk.CheckBox) 34 16 nil 4528 34 2 8 1140924419 1 4608 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4738 #hash 8 #() false nil nil 7 nil nil nil 4608 nil 8 1912725136 1250 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 -1 578 415 51 4608 802 #text: 34 1 8 '&Packaged?' 4608 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 207 0 0 0 24 0 0 0] 8 #() 944 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4528 34 2 8 1140850688 131073 5056 nil nil nil 7 nil nil nil 5056 706 ##(Smalltalk.PackageSelector) #resource_Choice_view nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 49 578 415 459 5056 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 207 0 0 0 253 0 0 0] 928 944 nil 27 170 192 34 4 4608 8 'setPackage' 5056 8 'package' 4306 578 1 -1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 7 578 415 507 4528 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 207 0 0 0 0 1 0 0] 34 2 4608 5056 944 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3600 34 2 8 1140850688 1 5552 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 5552 nil 1 #left nil nil nil 578 1 1 578 9 9 nil 5648 nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 415 7 578 11 507 5552 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 3 0 0 0 212 0 0 0 0 1 0 0] 8 #() 944 nil 27 3744 944 nil 27 170 192 928 4306 578 1 1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 25 21 578 841 653 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 10 0 0 0 176 1 0 0 80 1 0 0] 34 2 1040 3600 944 nil 27 170 192 928 4306 578 25 21 578 25 21 nil nil nil nil 50773 nil nil nil 578 621 581 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2007257760 738 138 144 34 3 802 #createAt:extent: 34 2 578 3839 21 578 921 841 416 802 #text: 34 1 8 'Create Class...' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 75 9 0 0 174 1 0 0] 34 2 960 640 944 nil 27)!

subclassOf: aClassOrNil inPackage: aPackage 
	| dialog |
	dialog := self newSubclassOf: aClassOrNil inPackage: aPackage.
	^dialog
		showModal;
		yourself! !
!CreateSubclassDialog class categoriesFor: #icon!accessing!constants!public! !
!CreateSubclassDialog class categoriesFor: #newSubclassOf:inPackage:!instance creation!public! !
!CreateSubclassDialog class categoriesFor: #refactoringView!constants!private! !
!CreateSubclassDialog class categoriesFor: #resource_Default_view!public!resources-views! !
!CreateSubclassDialog class categoriesFor: #resource_Refactoring_view!public!resources-views! !
!CreateSubclassDialog class categoriesFor: #subclassOf:inPackage:!operations!public! !

