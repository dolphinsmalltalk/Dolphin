"Filed out from Dolphin Smalltalk"!

UI.Dialog subclass: #'Tools.CreateSubclassDialog'
	instanceVariableNames: 'packagesPresenter subclassesPresenter namePresenter usePackagePresenter package superclassPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.CreateSubclassDialog guid: (Core.GUID fromString: '{97279c55-7e9a-41d4-ac28-bf3c10201966}')!
Tools.CreateSubclassDialog comment: 'CreateSubclassDialog implements a dialog for gather the information necessary to create classes in the IDE. 

Instance Variables:
	packagesPresenter		<PackageSelector>. Used to choose the package of the new class.
	subclassesPresenter		<MultipleChoicePresenter>. Used to choose subclasses of the new class (in Dolphin Professional)
	namePresenter			<TextPresenter>. Used to enter the name of the new class.
	usePackagePresenter		<BooleanPresenter>. Used to choose whether or not to package the new class (or leave unpackaged)
	package					<Package>. The chosen package.
	superclassPresenter		<TextPresenter> used to display the superclass of the new class.

'!
!Tools.CreateSubclassDialog categoriesForClass!MVP-Presenters! !
!Tools.CreateSubclassDialog methodsFor!

canApply
	^(self isPackaged not or: [self package notNil]) and: 
			[| candidateName |
			candidateName := self subclassName.
			candidateName notEmpty and: 
					[(ClassBuilder isValidClassName: candidateName)
						and: [(Smalltalk fullBindingFor: candidateName) isNil]]]!

chooseSuperclass
	SmalltalkSystem current
		chooseClass: superclassPresenter model
		caption: 'Choose Superclass…'
		allowNil: true!

createComponents
	super createComponents.
	namePresenter := self add: TextPresenter new name: 'className'.
	superclassPresenter := self add: TextPresenter new name: 'superclass'.
	packagesPresenter := self add: (PackageSelector new
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
	package := SmalltalkSystem current defaultPackage.
	superclassPresenter model: aClassOrNil.
	namePresenter model: aClassOrNil fullName asValue.
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
!Tools.CreateSubclassDialog categoriesForMethods!
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

!Tools.CreateSubclassDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^Icon fromId: 'NewClass.ico'
!

newSubclassOf: aClassOrNil inPackage: aPackage
	| dialog |
	dialog := self on: aClassOrNil asValue.
	dialog
		package: aPackage;
		createView: (SmalltalkSystem current canRefactor
					ifTrue: [self refactoringView]
					ifFalse: [self defaultView]).
	^dialog!

refactoringView
	^'Refactoring view'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 167 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 25 673 578 731 71 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 1 0 0 121 1 0 0 115 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 610 1 1 410 ##(UI.ContainerView) 34 15 nil 944 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 1048838 ##(UI.FramingLayout) 170 176 34 12 410 ##(UI.PushButton) 34 20 nil 1024 34 2 8 1140924416 1 1152 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1152 nil 8 1868462064 1377606 4 ##(UI.CommandDescription) #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 691 65 578 41 41 1152 786 #isEnabled: 8 #(false) 1152 786 #text: 34 1 8 '…' 1152 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 32 0 0 0 109 1 0 0 52 0 0 0] 8 #() 928 nil 29 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedViewRight -39 1570 #fixedParentRight 1 1570 #fixedPreviousTop 1 1570 #fixedViewTop 41 410 ##(UI.StaticRectangle) 34 14 nil 1024 34 2 8 1140850960 1 1648 nil nil nil 7 nil nil nil 1648 nil 8 1868316128 738 34 1 786 #createAt:extent: 34 2 578 1 129 578 731 5 1648 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 109 1 0 0 66 0 0 0] 8 #() 928 nil 27 1538 1570 #fixedParentLeft 1 1600 1 1570 #fixedViewBottom -3 1570 #fixedParentBottom -7 410 ##(UI.TextEdit) 34 16 nil 1024 34 2 8 1140916352 1025 1936 nil nil nil 7 nil nil nil 1936 nil 8 1868457584 1049094 ##(UI.NullConverter) nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 191 65 578 487 41 1936 786 #setMarginWidths: 34 1 8 #(3 3) 1936 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 32 0 0 0 82 1 0 0 52 0 0 0] 8 #() 928 nil 27 1538 1570 #fixedPreviousRight 1 1600 -53 1616 -3 1632 41 410 ##(UI.StaticText) 34 16 nil 1024 34 2 8 1140850944 1 2272 nil nil nil 7 nil nil nil 2272 nil 8 1868316128 2018 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 5 578 191 41 2272 786 #text: 34 1 8 'New class name:' 2272 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 95 0 0 0 22 0 0 0] 8 #() 928 nil 27 1538 1888 1 1570 #fixedViewLeft 191 1570 #fixedParentTop 5 1632 41 410 ##(UI.TextEdit) 34 16 nil 1024 34 2 8 1140916352 1025 2608 nil 1232 nil 7 nil nil nil 2608 nil 8 1868457584 2018 nil nil 5 738 34 2 786 #createAt:extent: 34 2 578 191 1 578 487 45 2608 786 #setMarginWidths: 34 1 8 #(3 3) 2608 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 8 #() 928 nil 27 1538 2256 1 1600 -53 1616 -3 1632 45 410 ##(UI.StaticText) 34 16 nil 1024 34 2 8 1140850944 1 2912 nil nil nil 7 nil nil nil 2912 nil 8 1868316128 2018 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 69 578 191 41 2912 786 #text: 34 1 8 'Superclass:' 2912 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 34 0 0 0 95 0 0 0 54 0 0 0] 8 #() 928 nil 27 1538 1888 1 2576 191 1570 #fixedPreviousBottom 25 1632 41 170 192 34 4 2608 8 'className' 1936 8 'superclass' nil 738 34 1 786 #createAt:extent: 34 2 578 1 1 578 731 141 1024 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 70 0 0 0] 34 6 2272 2608 2912 1936 1152 1648 928 nil 27 nil nil nil 410 ##(UI.ContainerView) 34 15 nil 944 34 2 8 1140850688 131073 3440 nil nil nil 7 nil nil nil 3440 1376774 ##(UI.ProportionalLayout) 170 176 912 false 170 192 912 1180166 ##(Graphics.Rectangle) 578 1 7 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 141 578 731 509 3440 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 109 1 0 0 68 1 0 0] 34 1 410 ##(UI.ContainerView) 34 15 nil 3440 34 2 8 1140850688 131073 3776 nil nil nil 23 nil nil nil 3776 610 1 1 410 ##(UI.CheckBox) 34 16 nil 3776 34 2 8 1140924419 1 3856 918598 2 ##(UI.ValueHolder) nil false 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 3986 #hash 8 #() false nil nil 7 nil nil nil 3856 nil 8 1868462064 2018 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 -1 578 731 51 3856 786 #text: 34 1 8 '&Packaged?' 3856 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 8 #() 928 nil 27 nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 3776 34 2 8 1140850688 131073 4288 nil nil nil 7 nil nil nil 4288 706 ##(Tools.PackageSelector) #resource_Choice_view nil 738 34 1 786 #createAt:extent: 34 2 578 1 49 578 731 455 4288 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 109 1 0 0 251 0 0 0] 912 928 nil 27 170 192 34 2 3856 8 'setPackage' 3570 578 1 -1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 7 578 731 503 3776 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 109 1 0 0 254 0 0 0] 34 2 3856 4288 928 nil 27 928 nil 27 170 192 912 3570 578 1 1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 25 25 578 731 649 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 121 1 0 0 80 1 0 0] 34 2 1024 3440 928 nil 27 170 192 912 3570 578 25 25 578 25 21 nil nil nil nil 22729 nil nil nil 578 521 601 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2004973120 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 811 841 416 786 #text: 34 1 8 'Create Class…' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 148 25 0 0 174 1 0 0] 34 2 944 640 928 nil 27 )!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 133 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 25 673 578 841 71 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 80 1 0 0 176 1 0 0 115 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 960 nil nil nil 7 nil nil nil 960 610 1 1 410 ##(UI.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 1048838 ##(UI.FramingLayout) 170 176 34 12 410 ##(UI.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 1168 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1168 nil 8 1801338832 1049094 ##(UI.NullConverter) nil nil 5 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 7 578 597 43 1168 802 #setMarginWidths: 34 1 8 #(3 3) 1168 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 3 0 0 0 137 1 0 0 24 0 0 0] 8 #() 944 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedPreviousRight 1 1554 #fixedParentRight -53 1554 #fixedPreviousTop -3 1554 #fixedViewTop 43 410 ##(UI.TextEdit) 34 16 nil 1040 34 2 8 1140916352 1025 1632 nil nil nil 7 nil nil nil 1632 nil 8 1801338832 1282 nil nil 7 738 138 144 34 2 802 #createAt:extent: 34 2 578 191 67 578 597 43 1632 802 #setMarginWidths: 34 1 8 #(3 3) 1632 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 33 0 0 0 137 1 0 0 54 0 0 0] 8 #() 944 nil 27 1522 1568 1 1584 -53 1600 -5 1616 43 410 ##(UI.PushButton) 34 20 nil 1040 34 2 8 1140924416 1 1952 nil 1248 nil 7 nil nil nil 1952 nil 8 1801347024 1377606 4 ##(UI.CommandDescription) #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 578 801 67 578 41 41 1952 802 #isEnabled: 8 #(false) 1952 802 #text: 34 1 8 '…' 1952 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 33 0 0 0 164 1 0 0 53 0 0 0] 8 #() 944 nil 29 1522 1554 #fixedViewRight -39 1584 1 1600 1 1616 41 410 ##(UI.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 2352 nil nil nil 7 nil nil nil 2352 nil 8 1801195232 1282 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 73 578 191 43 2352 802 #text: 34 1 8 'Superclass:' 2352 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 36 0 0 0 95 0 0 0 57 0 0 0] 8 #() 944 nil 27 1522 1554 #fixedParentLeft 1 1554 #fixedViewLeft 191 1554 #fixedPreviousBottom 25 1616 43 410 ##(UI.StaticText) 34 16 nil 1040 34 2 8 1140850944 1 2720 nil nil nil 7 nil nil nil 2720 nil 8 1801195232 1282 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 11 578 191 43 2720 802 #text: 34 1 8 '&New class name:' 2720 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 5 0 0 0 95 0 0 0 26 0 0 0] 8 #() 944 nil 27 1522 2672 1 2688 191 1554 #fixedParentTop 11 1616 43 410 ##(UI.StaticRectangle) 34 14 nil 1040 34 2 8 1140850960 1 3056 nil nil nil 7 nil nil nil 3056 nil 8 1801195232 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 129 578 841 5 3056 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 64 0 0 0 164 1 0 0 66 0 0 0] 8 #() 944 nil 27 1522 2672 1 1584 1 1554 #fixedViewBottom -3 1554 #fixedParentBottom -7 170 192 34 4 1632 8 'superclass' 1168 8 'className' nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 1 578 841 141 1040 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 1 0 0 70 0 0 0] 34 6 2720 1168 2352 1632 1952 3056 944 nil 27 nil nil nil 410 ##(UI.ContainerView) 34 15 nil 960 34 2 8 1140850688 131073 3568 nil nil nil 7 nil nil nil 3568 1376774 ##(UI.ProportionalLayout) 170 176 928 false 170 192 34 2 410 ##(UI.ListView) 34 45 nil 3568 34 2 8 1140953161 1025 3712 787270 2 ##(UI.ListModel) 138 144 928 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1248 nil 7 nil nil nil 3712 nil 8 1801282304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil 578 65 65 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Subclasses' 409 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() nil nil 3712 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 425 7 578 417 507 3712 802 #text: 34 1 8 'Subclasses' 3712 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 212 0 0 0 3 0 0 0 164 1 0 0 0 1 0 0] 8 #() 944 nil 35 8 'subclasses' 1180166 ##(Graphics.Rectangle) 578 1 7 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 141 578 841 513 3568 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 70 0 0 0 164 1 0 0 70 1 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 4512 nil nil nil 23 nil nil nil 4512 610 1 1 410 ##(UI.CheckBox) 34 16 nil 4512 34 2 8 1140924419 1 4592 918598 2 ##(UI.ValueHolder) nil false 1704454 ##(Core.PluggableSearchPolicy) 4002 #= 8 #() 4002 #hash 8 #() false nil nil 7 nil nil nil 4592 nil 8 1801347024 1282 nil nil nil 738 138 144 34 2 802 #createAt:extent: 34 2 578 1 -1 578 415 51 4592 802 #text: 34 1 8 '&Packaged?' 4592 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 207 0 0 0 24 0 0 0] 8 #() 944 nil 27 nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 4512 34 2 8 1140850688 131073 5024 nil nil nil 7 nil nil nil 5024 706 ##(Tools.PackageSelector) #resource_Choice_view nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 49 578 415 459 5024 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 207 0 0 0 253 0 0 0] 928 944 nil 27 170 192 34 4 5024 8 'package' 4592 8 'setPackage' 4290 578 1 -1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 1 7 578 415 507 4512 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 207 0 0 0 0 1 0 0] 34 2 4592 5024 944 nil 27 410 ##(UI.Splitter) 34 12 nil 3568 34 2 8 1140850688 1 5520 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 5520 nil 1 #left nil nil nil 578 1 1 578 9 9 nil 5616 nil 738 138 144 34 1 802 #createAt:extent: 34 2 578 415 7 578 11 507 5520 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 3 0 0 0 212 0 0 0 0 1 0 0] 8 #() 944 nil 27 3712 944 nil 27 170 192 928 4290 578 1 1 578 1 1 738 138 144 34 1 802 #createAt:extent: 34 2 578 25 21 578 841 653 960 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 10 0 0 0 176 1 0 0 80 1 0 0] 34 2 1040 3568 944 nil 27 170 192 928 4290 578 25 21 578 25 21 nil nil nil nil 25687 nil nil nil 578 621 581 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 1996777232 738 138 144 34 2 802 #createAt:extent: 34 2 578 6143 21 578 921 841 416 802 #text: 34 1 8 'Create Class…' 416 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 203 13 0 0 174 1 0 0] 34 2 960 640 944 nil 27 )!

subclassOf: aClassOrNil inPackage: aPackage 
	| dialog |
	dialog := self newSubclassOf: aClassOrNil inPackage: aPackage.
	^dialog
		showModal;
		yourself! !
!Tools.CreateSubclassDialog class categoriesForMethods!
icon!accessing!constants!public! !
newSubclassOf:inPackage:!instance creation!public! !
refactoringView!constants!private! !
resource_Default_view!public!resources-views! !
resource_Refactoring_view!public!resources-views! !
subclassOf:inPackage:!operations!public! !
!

