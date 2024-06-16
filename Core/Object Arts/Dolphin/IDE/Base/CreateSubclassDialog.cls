"Filed out from Dolphin Smalltalk"!

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

!CreateSubclassDialog categoriesForClass!MVP-Presenters! !

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

!CreateSubclassDialog categoriesForMethods!
canApply!private!testing! !
chooseSuperclass!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
environment!constants!private! !
isPackaged!commands!private! !
model:!accessing!public! !
onPackageSelected!event handling!private! !
onSuperclassChanged!event handling!private! !
onViewOpened!event handling!public! !
package!accessing!public! !
package:!accessing!public! !
queryCommand:!commands!private! !
subclasses!accessing!public! !
subclassName!accessing!public! !
subclassName:!accessing!public! !
superclass!accessing!public! !
toggleSetPackage!commands!private! !
updatePackage!private!updating! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[12 0 0 0 80 1 0 0 121 1 0 0 115 1 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 578 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 1168 nil nil nil 5 nil nil nil 1168 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 2 0 0 0 95 0 0 0 22 0 0 0] 193 1200 nil 1168 770 #text: 34 1 8 'New class name:' 1168 3 8 #() 930 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1522 #fixedViewLeft 191 1522 #fixedParentTop 5 1522 #fixedViewTop 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 1600 nil nil nil 5 nil nil nil 1600 nil 8 1759000288 1250 nil nil 7 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[95 0 0 0 32 0 0 0 82 1 0 0 52 0 0 0] 193 1632 nil 1600 770 #setMarginWidths: 34 1 8 #(3 3) 1600 3 8 #() 930 193 193 nil 27 1490 1522 #fixedPreviousRight 1 1522 #fixedParentRight -53 1522 #fixedPreviousTop -3 1584 41 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 1968 nil nil nil 5 nil nil nil 1968 nil 8 1759212608 1250 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 34 0 0 0 95 0 0 0 54 0 0 0] 193 2000 nil 1968 770 #text: 34 1 8 'Superclass:' 1968 3 8 #() 930 193 193 nil 27 1490 1536 1 1552 191 1522 #fixedPreviousBottom 25 1584 41 410 ##(Smalltalk.PushButton) 34 20 nil 1040 34 2 8 1140924416 1 2304 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 2304 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #chooseSuperclass 8 '...' 1 1 nil nil false nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[89 1 0 0 32 0 0 0 109 1 0 0 52 0 0 0] 193 2336 8 '...' 2304 770 #isEnabled: 8 #(false) 2304 3 8 #() 930 193 193 nil 29 1490 1522 #fixedViewRight -39 1936 1 1952 1 1584 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 2704 nil 2384 nil 5 nil nil nil 2704 nil 8 1759000288 1250 nil nil 5 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[95 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 193 2736 nil 2704 770 #setMarginWidths: 34 1 8 #(3 3) 2704 3 8 #() 930 193 193 nil 27 1490 1920 1 1936 -53 1952 -3 1584 45 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1040 34 2 8 1140850960 1 3024 nil nil nil 5 nil nil nil 3024 nil 8 1759212608 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 64 0 0 0 107 1 0 0 66 0 0 0] 193 3056 nil 3024 3 8 #() 930 193 193 nil 27 1490 1536 1 1936 1 1522 #fixedViewBottom -3 1522 #fixedParentBottom -7 170 192 34 4 1600 8 'superclass' 2704 8 'className' nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 109 1 0 0 70 0 0 0] 193 1072 8 '' 1040 3 34 6 1168 2704 1968 1600 2304 3024 930 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 3552 nil nil nil 5 nil nil nil 3552 1180166 ##(Smalltalk.ProportionalLayout) 170 176 912 false 170 192 912 590342 ##(Smalltalk.Rectangle) 930 1 7 930 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 70 0 0 0 109 1 0 0 68 1 0 0] 193 3584 8 '' 3552 3 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3552 34 2 8 1140850688 131073 3904 nil nil nil 21 nil nil nil 3904 578 1 1 410 ##(Smalltalk.CheckBox) 34 16 nil 3904 34 2 8 1140924419 1 3984 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4114 #hash 8 #() false nil nil 5 nil nil nil 3984 nil 8 1759007584 1250 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 193 4016 8 '&Packaged?' 3984 3 8 #() 930 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3904 34 2 8 1140850688 131073 4400 nil nil nil 5 nil nil nil 4400 674 ##(Smalltalk.PackageSelector) #resource_Choice_view nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 24 0 0 0 109 1 0 0 251 0 0 0] 193 4432 8 '' 4400 3 912 930 193 193 nil 27 170 192 34 2 3984 8 'setPackage' 3682 930 1 -1 930 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 3 0 0 0 109 1 0 0 254 0 0 0] 193 3936 8 '' 3904 3 34 2 3984 4400 930 193 193 nil 27 930 193 193 nil 27 170 192 912 3682 930 1 1 930 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[12 0 0 0 12 0 0 0 121 1 0 0 80 1 0 0] 193 992 8 '' 960 3 34 2 1040 3552 930 193 193 nil 27 170 192 912 3682 930 25 25 930 25 21 nil nil nil nil 10943 nil nil nil 930 521 601 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3682 930 1 1 930 811 841 193 416 770 #setWindowText: 34 1 8 'Create Class...' 416 1 34 2 960 608 930 193 193 nil 29 )!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 608 nil nil nil 5 nil nil nil 608 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[12 0 0 0 80 1 0 0 176 1 0 0 115 1 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 5 nil nil nil 960 578 1 1 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 1168 nil nil nil 5 nil nil nil 1168 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 36 0 0 0 95 0 0 0 57 0 0 0] 193 1200 nil 1168 770 #text: 34 1 8 'Superclass:' 1168 3 8 #() 930 193 193 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 1522 #fixedViewLeft 191 1522 #fixedPreviousBottom 25 1522 #fixedViewTop 43 410 ##(Smalltalk.PushButton) 34 20 nil 1040 34 2 8 1140924416 1 1600 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 1600 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #chooseSuperclass 8 '...' 1 1 nil nil false nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[144 1 0 0 33 0 0 0 164 1 0 0 53 0 0 0] 193 1632 8 '...' 1600 770 #isEnabled: 8 #(false) 1600 3 8 #() 930 193 193 nil 29 1490 1522 #fixedViewRight -39 1522 #fixedParentRight 1 1522 #fixedPreviousTop 1 1584 41 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 2032 nil 1680 nil 5 nil nil nil 2032 nil 8 1759000288 1250 nil nil 5 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[95 0 0 0 3 0 0 0 137 1 0 0 24 0 0 0] 193 2064 nil 2032 770 #setMarginWidths: 34 1 8 #(3 3) 2032 3 8 #() 930 193 193 nil 27 1490 1522 #fixedPreviousRight 1 2000 -53 2016 -3 1584 43 410 ##(Smalltalk.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 2368 nil nil nil 5 nil nil nil 2368 nil 8 1759212608 1250 nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 5 0 0 0 95 0 0 0 26 0 0 0] 193 2400 nil 2368 770 #text: 34 1 8 '&New class name:' 2368 3 8 #() 930 193 193 nil 27 1490 1536 1 1552 191 1522 #fixedParentTop 11 1584 43 410 ##(Smalltalk.StaticRectangle) 34 14 nil 1040 34 2 8 1140850960 1 2704 nil nil nil 5 nil nil nil 2704 nil 8 1759212608 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 64 0 0 0 162 1 0 0 66 0 0 0] 193 2736 nil 2704 3 8 #() 930 193 193 nil 27 1490 1536 1 2000 1 1522 #fixedViewBottom -3 1522 #fixedParentBottom -7 410 ##(Smalltalk.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 2992 nil nil nil 5 nil nil nil 2992 nil 8 1759000288 1250 nil nil 7 706 138 144 34 2 770 #createWindow: 34 1 818 850 8 #[95 0 0 0 33 0 0 0 137 1 0 0 54 0 0 0] 193 3024 nil 2992 770 #setMarginWidths: 34 1 8 #(3 3) 2992 3 8 #() 930 193 193 nil 27 1490 2352 1 2000 -53 2016 -5 1584 43 170 192 34 4 2032 8 'className' 2992 8 'superclass' nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 0 0 0 0 164 1 0 0 70 0 0 0] 193 1072 8 '' 1040 3 34 6 2368 2032 1168 2992 1600 2704 930 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 3552 nil nil nil 5 nil nil nil 3552 1180166 ##(Smalltalk.ProportionalLayout) 170 176 912 false 170 192 34 2 410 ##(Smalltalk.ListView) 34 45 nil 3552 34 2 8 1140953161 1025 3696 590662 2 ##(Smalltalk.ListModel) 138 144 912 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 1680 nil 5 nil nil nil 3696 nil 8 1759068368 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 930 65 65 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Subclasses' 409 #left ##(Smalltalk.BasicListAbstract) 459270 ##(Smalltalk.Message) #<= 8 #() nil nil 3696 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[212 0 0 0 3 0 0 0 164 1 0 0 0 1 0 0] 193 3728 8 'Subclasses' 3696 3 8 #() 930 193 193 nil 35 8 'subclasses' 590342 ##(Smalltalk.Rectangle) 930 1 7 930 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 70 0 0 0 164 1 0 0 70 1 0 0] 193 3584 8 '' 3552 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3552 34 2 8 1140850688 131073 4464 nil nil nil 21 nil nil nil 4464 578 1 1 410 ##(Smalltalk.CheckBox) 34 16 nil 4464 34 2 8 1140924419 1 4544 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 3986 #= 8 #() 3986 #hash 8 #() false nil nil 5 nil nil nil 4544 nil 8 1759007584 1250 nil nil nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 255 255 255 255 207 0 0 0 24 0 0 0] 193 4576 8 '&Packaged?' 4544 3 8 #() 930 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4464 34 2 8 1140850688 131073 4944 nil nil nil 5 nil nil nil 4944 674 ##(Smalltalk.PackageSelector) #resource_Choice_view nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 24 0 0 0 207 0 0 0 253 0 0 0] 193 4976 8 '' 4944 3 912 930 193 193 nil 27 170 192 34 4 4944 8 'package' 4544 8 'setPackage' 4242 930 1 -1 930 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[0 0 0 0 3 0 0 0 207 0 0 0 0 1 0 0] 193 4496 8 '' 4464 3 34 2 4544 4944 930 193 193 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3552 34 2 8 1140850688 1 5472 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 5472 nil 1 #left nil nil nil 930 1 1 930 9 9 nil 5568 nil 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[207 0 0 0 3 0 0 0 212 0 0 0 0 1 0 0] 193 5504 8 '' 5472 3 8 #() 930 193 193 nil 27 3696 930 193 193 nil 27 170 192 912 4242 930 1 1 930 1 1 706 138 144 34 1 770 #createWindow: 34 1 818 850 8 #[12 0 0 0 10 0 0 0 176 1 0 0 80 1 0 0] 193 992 8 '' 960 3 34 2 1040 3552 930 193 193 nil 27 170 192 912 4242 930 25 21 930 25 21 nil nil nil nil 10985 nil nil nil 930 621 581 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 706 138 144 34 2 770 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 4242 930 1 1 930 921 841 193 416 770 #setWindowText: 34 1 8 'Create Class...' 416 1 34 2 960 608 930 193 193 nil 29 )!

subclassOf: aClassOrNil inPackage: aPackage 
	| dialog |
	dialog := self newSubclassOf: aClassOrNil inPackage: aPackage.
	^dialog
		showModal;
		yourself! !

!CreateSubclassDialog class categoriesForMethods!
icon!accessing!constants!public! !
newSubclassOf:inPackage:!instance creation!public! !
refactoringView!constants!private! !
resource_Default_view!public!resources-views! !
resource_Refactoring_view!public!resources-views! !
subclassOf:inPackage:!operations!public! !
!

