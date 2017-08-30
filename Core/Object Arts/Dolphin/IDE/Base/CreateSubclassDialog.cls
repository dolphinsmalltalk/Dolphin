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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 672 0 0 0 7 0 0 0 672 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 25 683 610 747 71 672 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 85 1 0 0 129 1 0 0 120 1 0 0] 98 0 610 193 193 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1056 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 0 0 1056 642 1 1 410 1072 98 15 0 1056 98 2 8 1140850688 131073 1184 0 1138 31 0 7 0 0 0 1184 852230 ##(Smalltalk.FramingLayout)  234 240 98 12 410 8 ##(Smalltalk.PushButton)  98 17 0 1184 98 2 8 1140924416 1 1328 0 482 512 0 7 0 0 0 1328 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseSuperclass 8 '...' 1 1 0 0 32 818 202 208 98 3 882 912 98 2 610 707 61 610 41 41 1328 882 8 #isEnabled: 98 1 32 1328 882 8 #text: 98 1 8 '...' 1328 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 97 1 0 0 30 0 0 0 117 1 0 0 50 0 0 0] 98 0 1040 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedViewRight -39 1810 8 #fixedParentRight 1 1810 8 #fixedPreviousTop 1 1810 8 #fixedViewTop 41 410 8 ##(Smalltalk.StaticRectangle)  98 14 0 1184 98 2 8 1140850960 1 1952 0 482 512 0 7 0 0 0 1952 0 8 4294903625 818 202 208 98 1 882 912 98 2 610 1 129 610 747 5 1952 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 117 1 0 0 66 0 0 0] 98 0 1040 0 27 1778 1810 8 #fixedParentLeft 1 1856 1 1810 8 #fixedViewBottom -3 1810 8 #fixedParentBottom -7 410 8 ##(Smalltalk.TextEdit)  98 16 0 1184 98 2 8 1140916352 1025 2336 0 482 512 0 7 0 0 0 2336 0 8 4294903807 852486 ##(Smalltalk.NullConverter)  0 0 7 818 202 208 98 3 882 912 98 2 610 181 61 610 513 41 2336 882 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 2336 882 8 #isTextModified: 98 1 32 2336 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 90 0 0 0 30 0 0 0 90 1 0 0 50 0 0 0] 98 0 1040 0 27 1778 1810 8 #fixedPreviousRight 1 1856 -53 1888 -3 1920 41 410 8 ##(Smalltalk.StaticText)  98 16 0 1184 98 2 8 1140850944 1 2816 0 0 0 7 0 0 0 2816 0 8 4294903625 2450 0 0 0 818 202 208 98 2 882 912 98 2 610 1 5 610 181 41 2816 882 1680 98 1 8 'New class name:' 2816 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 90 0 0 0 22 0 0 0] 98 0 1040 0 27 1778 2240 1 1810 8 #fixedViewLeft 181 1810 8 #fixedParentTop 5 1920 41 410 2352 98 16 0 1184 98 2 8 1140916352 1025 3216 0 482 512 0 7 0 0 0 3216 0 8 4294903807 2450 0 0 5 818 202 208 98 3 882 912 98 2 610 181 1 610 513 41 3216 882 2608 98 1 2642 3 1 3 3216 882 2688 98 1 32 3216 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 90 0 0 0 0 0 0 0 90 1 0 0 20 0 0 0] 98 0 1040 0 27 1778 2784 1 1856 -53 1888 -3 1920 41 410 2832 98 16 0 1184 98 2 8 1140850944 1 3584 0 0 0 7 0 0 0 3584 0 8 4294903625 2450 0 0 0 818 202 208 98 2 882 912 98 2 610 1 65 610 181 41 3584 882 1680 98 1 8 'Superclass:' 3584 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 0 0 0 90 0 0 0 52 0 0 0] 98 0 1040 0 27 1778 2240 1 3152 181 1810 8 #fixedPreviousBottom 25 1920 41 234 256 98 4 2336 8 'superclass' 3216 8 'className' 0 818 202 208 98 1 882 912 98 2 610 1 1 610 747 141 1184 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 117 1 0 0 70 0 0 0] 98 6 2816 3216 3584 2336 1328 1952 1040 0 27 0 0 0 410 1072 98 15 0 1056 98 2 8 1140850688 131073 4160 0 1138 31 0 7 0 0 0 4160 1180166 ##(Smalltalk.ProportionalLayout)  234 240 1024 32 234 256 1024 590342 ##(Smalltalk.Rectangle)  610 1 7 610 1 1 818 202 208 98 1 882 912 98 2 610 1 141 610 747 519 4160 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 117 1 0 0 73 1 0 0] 98 1 410 1072 98 15 0 4160 98 2 8 1140850688 131073 4528 0 482 512 0 23 0 0 0 4528 642 1 1 410 8 ##(Smalltalk.CheckBox)  98 16 0 4528 98 2 8 1140924419 1 4624 721990 2 ##(Smalltalk.ValueHolder)  0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 4770 8 #hash 98 0 32 482 512 0 7 0 0 0 4624 0 8 4294903631 2450 0 0 0 818 202 208 98 2 882 912 98 2 610 1 -1 610 747 51 4624 882 1680 98 1 8 '&Packaged?' 4624 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 117 1 0 0 24 0 0 0] 98 0 1040 0 27 0 0 0 410 688 98 14 0 4528 98 2 8 1140850688 131073 5136 0 0 0 7 0 0 0 5136 754 8 ##(Smalltalk.PackageSelector)  8 #resource_Choice_view 0 818 202 208 98 1 882 912 98 2 610 1 49 610 747 465 5136 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 117 1 0 0 0 1 0 0] 1024 1040 0 27 234 256 98 2 4624 8 'setPackage' 4306 610 1 -1 610 1 1 818 202 208 98 1 882 912 98 2 610 1 7 610 747 513 4528 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 117 1 0 0 3 1 0 0] 98 2 4624 5136 1040 0 27 1040 0 27 234 256 1024 4306 610 1 1 610 1 1 818 202 208 98 1 882 912 98 2 610 25 25 610 747 659 1056 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 129 1 0 0 85 1 0 0] 98 2 1184 4160 1040 0 27 234 256 1024 4306 610 25 25 610 25 21 0 0 0 0 35165 0 0 0 610 521 601 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 818 202 208 98 3 882 912 98 2 610 2799 21 610 811 841 416 882 1680 98 1 8 'Create Class...' 416 882 8 #updateMenuBar 1024 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 12 7 0 0 174 1 0 0] 98 2 1056 672 1040 0 27 )!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 672 0 0 0 7 0 0 0 672 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 610 25 683 610 857 71 672 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 85 1 0 0 184 1 0 0 120 1 0 0] 98 0 610 193 193 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1056 0 0 0 7 0 0 0 1056 642 1 1 410 1072 98 15 0 1056 98 2 8 1140850688 131073 1152 0 0 0 7 0 0 0 1152 852230 ##(Smalltalk.FramingLayout)  234 240 98 12 410 8 ##(Smalltalk.TextEdit)  98 16 0 1152 98 2 8 1140916352 1025 1280 0 482 512 0 7 0 0 0 1280 0 8 4294903807 852486 ##(Smalltalk.NullConverter)  0 0 7 818 202 208 98 3 882 912 98 2 610 181 67 610 623 43 1280 882 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1280 882 8 #isTextModified: 98 1 32 1280 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 90 0 0 0 33 0 0 0 145 1 0 0 54 0 0 0] 98 0 1040 0 27 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedPreviousRight 1 1746 8 #fixedParentRight -53 1746 8 #fixedPreviousTop -5 1746 8 #fixedViewTop 43 410 8 ##(Smalltalk.StaticText)  98 16 0 1152 98 2 8 1140850944 1 1888 0 0 0 7 0 0 0 1888 0 8 4294903625 1394 0 0 0 818 202 208 98 2 882 912 98 2 610 1 11 610 181 43 1888 882 8 #text: 98 1 8 '&New class name:' 1888 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 90 0 0 0 26 0 0 0] 98 0 1040 0 27 1714 1746 8 #fixedParentLeft 1 1746 8 #fixedViewLeft 181 1746 8 #fixedParentTop 11 1856 43 410 8 ##(Smalltalk.StaticRectangle)  98 14 0 1152 98 2 8 1140850960 1 2336 0 482 512 0 7 0 0 0 2336 0 8 4294903625 818 202 208 98 1 882 912 98 2 610 1 129 610 857 5 2336 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 172 1 0 0 66 0 0 0] 98 0 1040 0 27 1714 2240 1 1792 1 1746 8 #fixedViewBottom -3 1746 8 #fixedParentBottom -7 410 1904 98 16 0 1152 98 2 8 1140850944 1 2688 0 0 0 7 0 0 0 2688 0 8 4294903625 1394 0 0 0 818 202 208 98 2 882 912 98 2 610 1 73 610 181 43 2688 882 2128 98 1 8 'Superclass:' 2688 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 90 0 0 0 57 0 0 0] 98 0 1040 0 27 1714 2240 1 2272 181 1746 8 #fixedPreviousBottom 25 1856 43 410 8 ##(Smalltalk.PushButton)  98 17 0 1152 98 2 8 1140924416 1 3040 0 482 512 0 7 0 0 0 3040 0 8 4294903631 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseSuperclass 8 '...' 1 1 0 0 32 818 202 208 98 3 882 912 98 2 610 817 67 610 41 41 3040 882 8 #isEnabled: 98 1 32 3040 882 2128 98 1 8 '...' 3040 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 152 1 0 0 33 0 0 0 172 1 0 0 53 0 0 0] 98 0 1040 0 27 1714 1746 8 #fixedViewRight -39 1792 1 1824 1 1856 41 410 1296 98 16 0 1152 98 2 8 1140916352 1025 3520 0 482 512 0 7 0 0 0 3520 0 8 4294903807 1394 0 0 5 818 202 208 98 3 882 912 98 2 610 181 7 610 623 43 3520 882 1552 98 1 1586 3 1 3 3520 882 1632 98 1 32 3520 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 90 0 0 0 3 0 0 0 145 1 0 0 24 0 0 0] 98 0 1040 0 27 1714 1760 1 1792 -53 1824 -3 1856 43 234 256 98 4 3520 8 'className' 1280 8 'superclass' 0 818 202 208 98 1 882 912 98 2 610 1 1 610 857 141 1152 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 172 1 0 0 70 0 0 0] 98 6 1888 3520 2688 1280 3040 2336 1040 0 27 0 0 0 410 1072 98 15 0 1056 98 2 8 1140850688 131073 4112 0 0 0 7 0 0 0 4112 1180166 ##(Smalltalk.ProportionalLayout)  234 240 1024 32 234 256 98 2 410 8 ##(Smalltalk.ListView)  98 30 0 4112 98 2 8 1140953161 1025 4256 590662 2 ##(Smalltalk.ListModel)  202 208 1024 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 8 4278190080 0 7 0 0 0 4256 0 8 4294903801 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 610 65 65 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Subclasses' 417 8 #left 4464 8 ##(Smalltalk.SortedCollection)  0 0 4256 0 3 0 0 8 #report 1024 0 133185 0 0 818 202 208 98 2 882 912 98 2 610 433 7 610 425 517 4256 882 2128 98 1 8 'Subclasses' 4256 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 216 0 0 0 3 0 0 0 172 1 0 0 5 1 0 0] 98 0 1040 0 27 8 'subclasses' 590342 ##(Smalltalk.Rectangle)  610 1 7 610 1 1 818 202 208 98 1 882 912 98 2 610 1 141 610 857 523 4112 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 172 1 0 0 75 1 0 0] 98 3 410 1072 98 15 0 4112 98 2 8 1140850688 131073 5120 0 0 0 23 0 0 0 5120 642 1 1 410 8 ##(Smalltalk.CheckBox)  98 16 0 5120 98 2 8 1140924419 1 5200 721990 2 ##(Smalltalk.ValueHolder)  0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 5346 8 #hash 98 0 32 0 0 7 0 0 0 5200 0 8 4294903631 1394 0 0 0 818 202 208 98 2 882 912 98 2 610 1 -1 610 423 51 5200 882 2128 98 1 8 '&Packaged?' 5200 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 211 0 0 0 24 0 0 0] 98 0 1040 0 27 0 0 0 410 688 98 14 0 5120 98 2 8 1140850688 131073 5696 0 0 0 7 0 0 0 5696 754 8 ##(Smalltalk.PackageSelector)  8 #resource_Choice_view 0 818 202 208 98 1 882 912 98 2 610 1 49 610 423 469 5696 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 211 0 0 0 2 1 0 0] 1024 1040 0 27 234 256 98 4 5200 8 'setPackage' 5696 8 'package' 4898 610 1 -1 610 1 1 818 202 208 98 1 882 912 98 2 610 1 7 610 423 517 5120 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 211 0 0 0 5 1 0 0] 98 2 5200 5696 1040 0 27 410 8 ##(Smalltalk.Splitter)  98 12 0 4112 98 2 8 1140850688 1 6224 0 482 512 0 519 0 0 0 6224 818 202 208 98 1 882 912 98 2 610 423 7 610 11 517 6224 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 211 0 0 0 3 0 0 0 216 0 0 0 5 1 0 0] 98 0 1040 0 27 4256 1040 0 27 234 256 1024 4898 610 1 1 610 1 1 818 202 208 98 1 882 912 98 2 610 25 21 610 857 663 1056 978 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 10 0 0 0 184 1 0 0 85 1 0 0] 98 2 1152 4112 1040 0 27 234 256 1024 4898 610 25 21 610 25 21 0 0 0 0 35371 0 0 0 610 621 581 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 818 202 208 98 3 882 912 98 2 610 2799 21 610 921 841 416 882 2128 98 1 8 'Create Class...' 416 882 8 #updateMenuBar 1024 416 978 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 67 7 0 0 174 1 0 0] 98 2 1056 672 1040 0 27 )!

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

