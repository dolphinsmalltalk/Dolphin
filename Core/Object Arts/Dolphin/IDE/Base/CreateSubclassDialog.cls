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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 25 673 594 731 71 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 1 0 0 121 1 0 0 115 1 0 0] 8 #() 594 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 976 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 976 626 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 976 34 2 8 1140850688 131073 1088 nil 1042 31 nil 7 nil nil nil 1088 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 1088 34 2 8 1140850944 1 1232 nil nil nil 7 nil nil nil 1232 nil 8 1906774720 852486 ##(Smalltalk.NullConverter) nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 69 594 191 41 1232 818 #text: 34 1 8 'Superclass:' 1232 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 95 0 0 0 54 0 0 0] 8 #() 960 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1586 #fixedViewLeft 191 1586 #fixedPreviousBottom 25 1586 #fixedViewTop 41 410 ##(Smalltalk.PushButton) 34 20 nil 1088 34 2 8 1140924416 1 1664 nil 466 496 nil 7 nil nil nil 1664 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #chooseSuperclass 8 '...' 1 1 nil nil false nil nil nil 754 138 144 34 3 818 #createAt:extent: 34 2 594 691 65 594 41 41 1664 818 #isEnabled: 8 #(false) 1664 818 #text: 34 1 8 '...' 1664 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 32 0 0 0 109 1 0 0 52 0 0 0] 8 #() 960 nil 29 1554 1586 #fixedViewRight -39 1586 #fixedParentRight 1 1586 #fixedPreviousTop 1 1648 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1088 34 2 8 1140916352 1025 2112 nil 466 496 nil 7 nil nil nil 2112 nil 8 1906818384 1314 nil nil 7 754 138 144 34 2 818 #createAt:extent: 34 2 594 191 65 594 487 41 2112 818 #setMarginWidths: 34 1 8 #(3 3) 2112 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 32 0 0 0 82 1 0 0 52 0 0 0] 8 #() 960 nil 27 1554 1586 #fixedPreviousRight 1 2080 -53 2096 -3 1648 41 410 ##(Smalltalk.StaticText) 34 16 nil 1088 34 2 8 1140850944 1 2464 nil nil nil 7 nil nil nil 2464 nil 8 1906774720 1314 nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 5 594 191 41 2464 818 #text: 34 1 8 'New class name:' 2464 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 95 0 0 0 22 0 0 0] 8 #() 960 nil 27 1554 1600 1 1616 191 1586 #fixedParentTop 5 1648 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1088 34 2 8 1140916352 1025 2800 nil 466 496 nil 7 nil nil nil 2800 nil 8 1906818384 1314 nil nil 5 754 138 144 34 2 818 #createAt:extent: 34 2 594 191 1 594 487 45 2800 818 #setMarginWidths: 34 1 8 #(3 3) 2800 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 8 #() 960 nil 27 1554 2448 1 2080 -53 2096 -3 1648 45 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1088 34 2 8 1140850960 1 3136 nil 466 496 nil 7 nil nil nil 3136 nil 8 1906774720 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 129 594 731 5 3136 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 109 1 0 0 66 0 0 0] 8 #() 960 nil 27 1554 1600 1 2080 1 1586 #fixedViewBottom -3 1586 #fixedParentBottom -7 170 192 34 4 2112 8 'superclass' 2800 8 'className' nil 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 1 594 731 141 1088 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 70 0 0 0] 34 6 2464 2800 1232 2112 1664 3136 960 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 976 34 2 8 1140850688 131073 3664 nil 1042 31 nil 7 nil nil nil 3664 1180166 ##(Smalltalk.ProportionalLayout) 170 176 944 false 170 192 944 590342 ##(Smalltalk.Rectangle) 594 1 7 594 1 1 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 141 594 731 509 3664 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 109 1 0 0 68 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 4032 nil 466 496 nil 23 nil nil nil 4032 626 1 1 410 ##(Smalltalk.CheckBox) 34 16 nil 4032 34 2 8 1140924419 1 4128 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4258 #hash 8 #() false 466 496 nil 7 nil nil nil 4128 nil 8 1906824432 1314 nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 -1 594 731 51 4128 818 #text: 34 1 8 '&Packaged?' 4128 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 8 #() 960 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4032 34 2 8 1140850688 131073 4592 nil nil nil 7 nil nil nil 4592 722 ##(Smalltalk.PackageSelector) #resource_Choice_view nil 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 49 594 731 455 4592 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 109 1 0 0 251 0 0 0] 944 960 nil 27 170 192 34 2 4128 8 'setPackage' 3810 594 1 -1 594 1 1 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 7 594 731 503 4032 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 109 1 0 0 254 0 0 0] 34 2 4128 4592 960 nil 27 960 nil 27 170 192 944 3810 594 1 1 594 1 1 754 138 144 34 1 818 #createAt:extent: 34 2 594 25 25 594 731 649 976 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 121 1 0 0 80 1 0 0] 34 2 1088 3664 960 nil 27 170 192 944 3810 594 25 25 594 25 21 nil nil nil nil 16967 nil nil nil 594 521 601 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 754 138 144 34 3 818 #createAt:extent: 34 2 594 3839 21 594 811 841 416 818 #text: 34 1 8 'Create Class...' 416 818 #updateMenuBar 944 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 20 9 0 0 174 1 0 0] 34 2 976 656 960 nil 27 )!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 25 673 594 841 71 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 1 0 0 176 1 0 0 115 1 0 0] 8 #() 594 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 976 nil nil nil 7 nil nil nil 976 626 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 976 34 2 8 1140850688 131073 1056 nil nil nil 7 nil nil nil 1056 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.TextEdit) 34 16 nil 1056 34 2 8 1140916352 1025 1184 nil 466 496 nil 7 nil nil nil 1184 nil 8 1906818384 852486 ##(Smalltalk.NullConverter) nil nil 7 754 138 144 34 2 818 #createAt:extent: 34 2 594 191 67 594 597 43 1184 818 #setMarginWidths: 34 1 8 #(3 3) 1184 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 33 0 0 0 137 1 0 0 54 0 0 0] 8 #() 960 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 1 1554 #fixedParentRight -53 1554 #fixedPreviousTop -5 1554 #fixedViewTop 43 410 ##(Smalltalk.PushButton) 34 20 nil 1056 34 2 8 1140924416 1 1632 nil 466 496 nil 7 nil nil nil 1632 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #chooseSuperclass 8 '...' 1 1 nil nil false nil nil nil 754 138 144 34 3 818 #createAt:extent: 34 2 594 801 67 594 41 41 1632 818 #isEnabled: 8 #(false) 1632 818 #text: 34 1 8 '...' 1632 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 33 0 0 0 164 1 0 0 53 0 0 0] 8 #() 960 nil 29 1522 1554 #fixedViewRight -39 1584 1 1600 1 1616 41 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 2048 nil nil nil 7 nil nil nil 2048 nil 8 1906774720 1282 nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 73 594 191 43 2048 818 #text: 34 1 8 'Superclass:' 2048 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 95 0 0 0 57 0 0 0] 8 #() 960 nil 27 1522 1554 #fixedParentLeft 1 1554 #fixedViewLeft 191 1554 #fixedPreviousBottom 25 1616 43 410 ##(Smalltalk.StaticText) 34 16 nil 1056 34 2 8 1140850944 1 2416 nil nil nil 7 nil nil nil 2416 nil 8 1906774720 1282 nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 11 594 191 43 2416 818 #text: 34 1 8 '&New class name:' 2416 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 95 0 0 0 26 0 0 0] 8 #() 960 nil 27 1522 2368 1 2384 191 1554 #fixedParentTop 11 1616 43 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1056 34 2 8 1140850960 1 2752 nil 466 496 nil 7 nil nil nil 2752 nil 8 1906774720 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 129 594 841 5 2752 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 164 1 0 0 66 0 0 0] 8 #() 960 nil 27 1522 2368 1 1584 1 1554 #fixedViewBottom -3 1554 #fixedParentBottom -7 410 ##(Smalltalk.TextEdit) 34 16 nil 1056 34 2 8 1140916352 1025 3056 nil 466 496 nil 7 nil nil nil 3056 nil 8 1906818384 1282 nil nil 5 754 138 144 34 2 818 #createAt:extent: 34 2 594 191 7 594 597 43 3056 818 #setMarginWidths: 34 1 8 #(3 3) 3056 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 3 0 0 0 137 1 0 0 24 0 0 0] 8 #() 960 nil 27 1522 1568 1 1584 -53 1600 -3 1616 43 170 192 34 4 1184 8 'superclass' 3056 8 'className' nil 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 1 594 841 141 1056 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 1 0 0 70 0 0 0] 34 6 2416 3056 2048 1184 1632 2752 960 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 976 34 2 8 1140850688 131073 3616 nil nil nil 7 nil nil nil 3616 1180166 ##(Smalltalk.ProportionalLayout) 170 176 944 false 170 192 34 2 410 ##(Smalltalk.ListView) 34 30 nil 3616 34 2 8 1140953161 1025 3760 590662 2 ##(Smalltalk.ListModel) 138 144 944 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 8 4278190080 nil 7 nil nil nil 3760 nil 8 1906899344 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 594 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Subclasses' 409 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 3760 nil 3 nil nil #report 944 nil 133185 nil 8 #(nil) 754 138 144 34 2 818 #createAt:extent: 34 2 594 425 7 594 417 507 3760 818 #text: 34 1 8 'Subclasses' 3760 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 212 0 0 0 3 0 0 0 164 1 0 0 0 1 0 0] 8 #() 960 nil 27 8 'subclasses' 590342 ##(Smalltalk.Rectangle) 594 1 7 594 1 1 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 141 594 841 513 3616 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 164 1 0 0 70 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3616 34 2 8 1140850688 131073 4544 nil nil nil 23 nil nil nil 4544 626 1 1 410 ##(Smalltalk.CheckBox) 34 16 nil 4544 34 2 8 1140924419 1 4624 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4754 #hash 8 #() false nil nil 7 nil nil nil 4624 nil 8 1906824432 1282 nil nil nil 754 138 144 34 2 818 #createAt:extent: 34 2 594 1 -1 594 415 51 4624 818 #text: 34 1 8 '&Packaged?' 4624 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 207 0 0 0 24 0 0 0] 8 #() 960 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4544 34 2 8 1140850688 131073 5072 nil nil nil 7 nil nil nil 5072 722 ##(Smalltalk.PackageSelector) #resource_Choice_view nil 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 49 594 415 459 5072 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 207 0 0 0 253 0 0 0] 944 960 nil 27 170 192 34 4 4624 8 'setPackage' 5072 8 'package' 4322 594 1 -1 594 1 1 754 138 144 34 1 818 #createAt:extent: 34 2 594 1 7 594 415 507 4544 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 207 0 0 0 0 1 0 0] 34 2 4624 5072 960 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3616 34 2 8 1140850688 1 5568 nil 466 496 nil 519 nil nil nil 5568 754 138 144 34 1 818 #createAt:extent: 34 2 594 415 7 594 11 507 5568 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 3 0 0 0 212 0 0 0 0 1 0 0] 8 #() 960 nil 27 3760 960 nil 27 170 192 944 4322 594 1 1 594 1 1 754 138 144 34 1 818 #createAt:extent: 34 2 594 25 21 594 841 653 976 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 10 0 0 0 176 1 0 0 80 1 0 0] 34 2 1056 3616 960 nil 27 170 192 944 4322 594 25 21 594 25 21 nil nil nil nil 17387 nil nil nil 594 621 581 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 754 138 144 34 3 818 #createAt:extent: 34 2 594 3839 21 594 921 841 416 818 #text: 34 1 8 'Create Class...' 416 818 #updateMenuBar 944 416 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 75 9 0 0 174 1 0 0] 34 2 976 656 960 nil 27 )!

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

