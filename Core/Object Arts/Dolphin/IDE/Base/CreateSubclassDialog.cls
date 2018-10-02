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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 25 673 578 731 71 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 1 0 0 121 1 0 0 115 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 610 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 1168 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 1168 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 5 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 1 578 487 45 1168 802 #setMarginWidths: 34 1 8 #(3 3) 1168 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 8 #() 944 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 1 1570 #fixedParentRight -53 1570 #fixedPreviousTop -3 1570 #fixedViewTop 45 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 1648 nil nil nil 5 nil nil nil 1648 nil 8 1915124368 1298 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 69 578 191 41 1648 802 #text: 34 1 8 'Superclass:' 1648 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 95 0 0 0 54 0 0 0] 8 #() 944 nil 27 1538 1570 #fixedParentLeft 1 1570 #fixedViewLeft 191 1570 #fixedPreviousBottom 25 1632 41 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1040 34 2 8 1140850960 1 2016 nil nil nil 5 nil nil nil 2016 nil 8 1915124368 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 129 578 731 5 2016 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 109 1 0 0 66 0 0 0] 8 #() 944 nil 27 1538 1968 1 1600 1 1570 #fixedViewBottom -3 1570 #fixedParentBottom -7 410 ##(Smalltalk.PushButton) 34 20 nil 1040 34 2 8 1140924416 1 2304 nil 1248 nil 5 nil nil nil 2304 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #chooseSuperclass 8 '...' 1 1 nil nil false nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 578 691 65 578 41 41 2304 802 #isEnabled: 8 #(false) 2304 802 #text: 34 1 8 '...' 2304 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 32 0 0 0 109 1 0 0 52 0 0 0] 8 #() 944 nil 29 1538 1570 #fixedViewRight -39 1600 1 1616 1 1632 41 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 2704 nil nil nil 5 nil nil nil 2704 nil 8 1915124368 1298 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 5 578 191 41 2704 802 #text: 34 1 8 'New class name:' 2704 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 95 0 0 0 22 0 0 0] 8 #() 944 nil 27 1538 1968 1 1984 191 1570 #fixedParentTop 5 1632 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 3040 nil nil nil 5 nil nil nil 3040 nil 8 1915280032 1298 nil nil 7 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 65 578 487 41 3040 802 #setMarginWidths: 34 1 8 #(3 3) 3040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 32 0 0 0 82 1 0 0 52 0 0 0] 8 #() 944 nil 27 1538 1584 1 1600 -53 1616 -3 1632 41 170 192 34 4 3040 8 'superclass' 1168 8 'className' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 1 578 731 141 1040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 70 0 0 0] 34 6 2704 1168 1648 3040 2304 2016 944 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 3584 nil nil nil 5 nil nil nil 3584 1180166 ##(Smalltalk.ProportionalLayout) 170 176 928 false 170 192 928 590342 ##(Smalltalk.Rectangle) 578 1 7 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 141 578 731 509 3584 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 109 1 0 0 68 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 3936 nil nil nil 21 nil nil nil 3936 610 1 1 410 ##(Smalltalk.CheckBox) 34 16 nil 3936 34 2 8 1140924419 1 4016 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4146 #hash 8 #() false nil nil 5 nil nil nil 4016 nil 8 1915188384 1298 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 -1 578 731 51 4016 802 #text: 34 1 8 '&Packaged?' 4016 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 8 #() 944 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3936 34 2 8 1140850688 131073 4464 nil nil nil 5 nil nil nil 4464 706 ##(Smalltalk.PackageSelector) #resource_Choice_view nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 49 578 731 455 4464 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 109 1 0 0 251 0 0 0] 928 944 nil 27 170 192 34 2 4016 8 'setPackage' 3714 578 1 -1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 7 578 731 503 3936 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 109 1 0 0 254 0 0 0] 34 2 4016 4464 944 nil 27 944 nil 27 170 192 928 3714 578 1 1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 25 25 578 731 649 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 121 1 0 0 80 1 0 0] 34 2 1040 3584 944 nil 27 170 192 928 3714 578 25 25 578 25 21 nil nil nil nil 10635 nil nil nil 578 521 601 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 738 138 144 34 3 802 #createAt:extent: 34 2 578 1515 661 578 811 841 416 802 #text: 34 1 8 'Create Class...' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 2 0 0 74 1 0 0 138 4 0 0 238 2 0 0] 34 2 960 640 944 nil 27 )!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 25 673 578 841 71 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 1 0 0 176 1 0 0 115 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 610 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1040 34 2 8 1140850960 1 1168 nil nil nil 5 nil nil nil 1168 nil 8 1915124368 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 129 578 841 5 1168 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 164 1 0 0 66 0 0 0] 8 #() 944 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1442 #fixedParentRight 1 1442 #fixedViewBottom -3 1442 #fixedParentBottom -7 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 1520 nil nil nil 5 nil nil nil 1520 nil 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 7 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 67 578 597 43 1520 802 #setMarginWidths: 34 1 8 #(3 3) 1520 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 33 0 0 0 137 1 0 0 54 0 0 0] 8 #() 944 nil 27 1410 1442 #fixedPreviousRight 1 1472 -53 1442 #fixedPreviousTop -5 1442 #fixedViewTop 43 410 ##(Smalltalk.PushButton) 34 20 nil 1040 34 2 8 1140924416 1 1904 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 1904 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #chooseSuperclass 8 '...' 1 1 nil nil false nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 578 801 67 578 41 41 1904 802 #isEnabled: 8 #(false) 1904 802 #text: 34 1 8 '...' 1904 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 33 0 0 0 164 1 0 0 53 0 0 0] 8 #() 944 nil 29 1410 1442 #fixedViewRight -39 1472 1 1872 1 1888 41 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 2352 nil nil nil 5 nil nil nil 2352 nil 8 1915124368 1602 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 11 578 191 43 2352 802 #text: 34 1 8 '&New class name:' 2352 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 95 0 0 0 26 0 0 0] 8 #() 944 nil 27 1410 1456 1 1442 #fixedViewLeft 191 1442 #fixedParentTop 11 1888 43 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 2704 nil 1984 nil 5 nil nil nil 2704 nil 8 1915280032 1602 nil nil 5 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 7 578 597 43 2704 802 #setMarginWidths: 34 1 8 #(3 3) 2704 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 3 0 0 0 137 1 0 0 24 0 0 0] 8 #() 944 nil 27 1410 1856 1 1472 -53 1872 -3 1888 43 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 3024 nil nil nil 5 nil nil nil 3024 nil 8 1915124368 1602 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 73 578 191 43 3024 802 #text: 34 1 8 'Superclass:' 3024 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 95 0 0 0 57 0 0 0] 8 #() 944 nil 27 1410 1456 1 2672 191 1442 #fixedPreviousBottom 25 1888 43 170 192 34 4 2704 8 'className' 1520 8 'superclass' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 1 578 841 141 1040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 1 0 0 70 0 0 0] 34 6 2352 2704 3024 1520 1904 1168 944 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 3584 nil nil nil 5 nil nil nil 3584 1180166 ##(Smalltalk.ProportionalLayout) 170 176 928 false 170 192 34 2 410 ##(Smalltalk.ListView) 34 30 nil 3584 34 2 8 1140953161 1025 3728 590662 2 ##(Smalltalk.ListModel) 138 144 928 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1984 nil 5 nil nil nil 3728 nil 8 1915211424 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 578 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Subclasses' 409 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 3728 nil 3 nil nil #report 928 nil 133185 nil 8 #(nil) 738 138 144 34 2 802 #createAt:extent: 34 2 578 425 7 578 417 507 3728 802 #text: 34 1 8 'Subclasses' 3728 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 212 0 0 0 3 0 0 0 164 1 0 0 0 1 0 0] 8 #() 944 nil 27 8 'subclasses' 590342 ##(Smalltalk.Rectangle) 578 1 7 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 141 578 841 513 3584 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 164 1 0 0 70 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 4480 nil nil nil 21 nil nil nil 4480 610 1 1 410 ##(Smalltalk.CheckBox) 34 16 nil 4480 34 2 8 1140924419 1 4560 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4690 #hash 8 #() false nil nil 5 nil nil nil 4560 nil 8 1915188384 1602 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 -1 578 415 51 4560 802 #text: 34 1 8 '&Packaged?' 4560 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 207 0 0 0 24 0 0 0] 8 #() 944 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4480 34 2 8 1140850688 131073 5008 nil nil nil 5 nil nil nil 5008 706 ##(Smalltalk.PackageSelector) #resource_Choice_view nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 49 578 415 459 5008 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 207 0 0 0 253 0 0 0] 928 944 nil 27 170 192 34 4 4560 8 'setPackage' 5008 8 'package' 4258 578 1 -1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 7 578 415 507 4480 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 207 0 0 0 0 1 0 0] 34 2 4560 5008 944 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3584 34 2 8 1140850688 1 5504 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 5504 nil 1 #left nil nil nil 578 1 1 578 9 9 nil 5600 nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 415 7 578 11 507 5504 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 3 0 0 0 212 0 0 0 0 1 0 0] 8 #() 944 nil 27 3728 944 nil 27 170 192 928 4258 578 1 1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 25 21 578 841 653 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 10 0 0 0 176 1 0 0 80 1 0 0] 34 2 1040 3584 944 nil 27 170 192 928 4258 578 25 21 578 25 21 nil nil nil nil 10677 nil nil nil 578 621 581 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 738 138 144 34 3 802 #createAt:extent: 34 2 578 1461 661 578 921 841 416 802 #text: 34 1 8 'Create Class...' 416 802 #updateMenuBar 928 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 218 2 0 0 74 1 0 0 166 4 0 0 238 2 0 0] 34 2 960 640 944 nil 27 )!

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

