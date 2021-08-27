"Filed out from Dolphin Smalltalk"!

UI.Dialog subclass: #'Tools.CreateSubclassDialog'
	instanceVariableNames: 'packagesPresenter subclassesPresenter namePresenter namespacePresenter usePackagePresenter package superclassPresenter'
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
			[(BindingReference isQualifiedName: namePresenter value) not and: 
					[| candidateName |
					candidateName := self subclassName.
					candidateName notEmpty and: 
							[(ClassBuilder isValidClassName: candidateName)
								and: [candidateName asQualifiedReference isDefined not]]]]!

chooseNamespace
	| choice namespaces |
	namespaces := ClassHierarchyModel withRoots: (Namespace subclasses copyWithout: SharedPool).
	choice := namespacePresenter model.
	(ChooseClassDialog
		on: choice
		choices: namespaces
		caption: 'Select Namespace…')
		showModal!

chooseSuperclass
	SmalltalkSystem current
		chooseClass: superclassPresenter model
		caption: 'Choose Superclass…'
		allowNil: true!

createComponents
	super createComponents.
	namePresenter := self add: TextPresenter new name: 'className'.
	namespacePresenter := self add: TextPresenter new name: 'namespace'.
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

defaultNamespaceForSubclassOf: aClass
	^##(LookupTable withAll: {Namespace -> Root. SharedPool -> OS}) at: aClass
		ifAbsent: [aClass localEnvironment]!

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
	aClassOrNil
		ifNil: 
			[namespacePresenter model: Smalltalk asValue.
			namePresenter model: 'ProtoObject2' asValue]
		ifNotNil: 
			[namespacePresenter model: (self defaultNamespaceForSubclassOf: aClassOrNil).
			namePresenter model: aClassOrNil name asValue].
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
	^namespacePresenter value fullNameFor: namePresenter value!

subclassName: aString
	| bindingRef |
	bindingRef := aString asQualifiedReference.
	namespacePresenter value: (bindingRef environment ifNil: [Smalltalk]).
	namePresenter value: bindingRef unqualifiedName!

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
chooseNamespace!commands!private! !
chooseSuperclass!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultNamespaceForSubclassOf:!helpers!private! !
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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 167 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 25 723 578 731 71 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 105 1 0 0 121 1 0 0 140 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 610 1 1 410 ##(UI.ContainerView) 34 15 nil 944 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 1048838 ##(UI.FramingLayout) 170 176 34 18 410 ##(UI.StaticText) 34 16 nil 1024 34 2 8 1140850944 1 1152 nil nil nil 7 nil nil nil 1152 nil 8 1879886752 1049094 ##(UI.NullConverter) nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 65 578 201 41 1152 786 #text: 34 1 8 '&Namespace:' 1152 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 0 0 0 100 0 0 0 52 0 0 0] 8 #() 928 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1490 #fixedViewLeft 201 1490 #fixedPreviousBottom 21 1490 #fixedViewTop 41 410 ##(UI.StaticText) 34 16 nil 1024 34 2 8 1140850944 1 1568 nil nil nil 7 nil nil nil 1568 nil 8 1879886752 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 5 578 201 41 1568 786 #text: 34 1 8 'New &class name:' 1568 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 100 0 0 0 22 0 0 0] 8 #() 928 nil 27 1458 1504 1 1520 201 1490 #fixedParentTop 5 1552 41 410 ##(UI.StaticRectangle) 34 14 nil 1024 34 2 8 1140850960 1 1888 nil nil nil 7 nil nil nil 1888 nil 8 1879886752 738 34 1 786 #createAt:extent: 34 2 578 1 179 578 731 5 1888 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 89 0 0 0 109 1 0 0 91 0 0 0] 8 #() 928 nil 27 1458 1504 1 1490 #fixedParentRight 1 1490 #fixedViewBottom -3 1490 #fixedParentBottom -7 410 ##(UI.PushButton) 34 20 nil 1024 34 2 8 1140924416 1 2176 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 2176 nil 8 1879847040 1377606 4 ##(UI.CommandDescription) #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 691 121 578 41 41 2176 786 #isEnabled: 8 #(false) 2176 786 #text: 34 1 8 '…' 2176 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 60 0 0 0 109 1 0 0 80 0 0 0] 8 #() 928 nil 29 1458 1490 #fixedPreviousRight 15 1520 41 1490 #fixedPreviousTop 1 1552 41 410 ##(UI.TextEdit) 34 16 nil 1024 34 2 8 1140850816 262145 2608 nil nil nil 7 nil nil nil 2608 nil 8 1879842560 1234 nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 201 121 578 477 41 2608 786 #setMarginWidths: 34 1 8 #(3 3) 2608 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 60 0 0 0 82 1 0 0 80 0 0 0] 8 #() 928 nil 27 1458 2576 1 2128 -53 2592 -1 1552 41 410 ##(UI.StaticText) 34 16 nil 1024 34 2 8 1140850944 1 2912 nil nil nil 7 nil nil nil 2912 nil 8 1879886752 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 123 578 201 41 2912 786 #text: 34 1 8 '&Superclass:' 2912 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 61 0 0 0 100 0 0 0 81 0 0 0] 8 #() 928 nil 27 1458 1504 1 1520 201 1536 21 1552 41 410 ##(UI.PushButton) 34 20 nil 1024 34 2 8 1140924416 1 3216 nil 2256 nil 7 nil nil nil 3216 nil 8 1879847040 2290 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 691 63 578 41 41 3216 786 #isEnabled: 8 #(false) 3216 786 #text: 34 1 8 '…' 3216 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 31 0 0 0 109 1 0 0 51 0 0 0] 8 #() 928 nil 29 1458 2576 15 1520 41 2592 1 1552 41 410 ##(UI.TextEdit) 34 16 nil 1024 34 2 8 1140916352 1025 3568 nil 2256 nil 7 nil nil nil 3568 nil 8 1879842560 1234 nil nil 5 738 34 2 786 #createAt:extent: 34 2 578 201 1 578 477 45 3568 786 #setMarginWidths: 34 1 8 #(3 3) 3568 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 8 #() 928 nil 27 1458 2576 1 2128 -53 2592 -3 1552 45 410 ##(UI.TextEdit) 34 16 nil 1024 34 2 8 1140850816 262145 3872 nil 2256 nil 7 nil nil nil 3872 nil 8 1879842560 1234 nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 201 63 578 477 41 3872 786 #setMarginWidths: 34 1 8 #(3 3) 3872 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 31 0 0 0 82 1 0 0 51 0 0 0] 8 #() 928 nil 27 1458 2576 1 2128 -53 2592 -1 1552 41 170 192 34 8 2608 8 'superclass' 3216 8 'chooseNamespace' 3568 8 'className' 3872 8 'namespace' nil 738 34 1 786 #createAt:extent: 34 2 578 1 1 578 731 191 1024 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 95 0 0 0] 34 9 1568 3568 1152 3872 3216 2912 2608 2176 1888 928 nil 27 nil nil nil 410 ##(UI.ContainerView) 34 15 nil 944 34 2 8 1140850688 131073 4416 nil nil nil 7 nil nil nil 4416 1376774 ##(UI.ProportionalLayout) 170 176 912 false 170 192 912 1180166 ##(Graphics.Rectangle) 578 1 7 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 191 578 731 509 4416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 95 0 0 0 109 1 0 0 93 1 0 0] 34 1 410 ##(UI.ContainerView) 34 15 nil 4416 34 2 8 1140850688 131073 4752 nil nil nil 23 nil nil nil 4752 610 1 1 410 ##(UI.CheckBox) 34 16 nil 4752 34 2 8 1140924419 1 4832 918598 2 ##(UI.ValueHolder) nil false 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 4962 #hash 8 #() false nil nil 7 nil nil nil 4832 nil 8 1879847040 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 -1 578 731 51 4832 786 #text: 34 1 8 '&Packaged?' 4832 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 8 #() 928 nil 27 nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 4752 34 2 8 1140850688 131073 5264 nil nil nil 7 nil nil nil 5264 706 ##(Tools.PackageSelector) #resource_Choice_view nil 738 34 1 786 #createAt:extent: 34 2 578 1 49 578 731 455 5264 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 109 1 0 0 251 0 0 0] 912 928 nil 27 170 192 34 2 4832 8 'setPackage' 4546 578 1 -1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 7 578 731 503 4752 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 109 1 0 0 254 0 0 0] 34 2 4832 5264 928 nil 27 928 nil 27 170 192 912 4546 578 1 1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 25 25 578 731 699 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 121 1 0 0 105 1 0 0] 34 2 1024 4416 928 nil 27 170 192 912 4546 578 25 25 578 25 21 nil nil nil nil 25989 nil nil nil 578 521 601 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2001958528 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 811 891 416 786 #text: 34 1 8 'Create Class…' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 148 25 0 0 199 1 0 0] 34 2 944 640 928 nil 27 )!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 167 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Presenter) #resource_OK_Cancel_button_block nil 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 25 723 578 841 71 640 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 105 1 0 0 176 1 0 0 140 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 610 1 1 410 ##(UI.ContainerView) 34 15 nil 944 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 1048838 ##(UI.FramingLayout) 170 176 34 18 410 ##(UI.StaticText) 34 16 nil 1024 34 2 8 1140850944 1 1152 nil nil nil 7 nil nil nil 1152 nil 8 1879886752 1049094 ##(UI.NullConverter) nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 5 578 201 41 1152 786 #text: 34 1 8 'New &class name:' 1152 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 100 0 0 0 22 0 0 0] 8 #() 928 nil 27 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 1 1490 #fixedViewLeft 201 1490 #fixedParentTop 5 1490 #fixedViewTop 41 410 ##(UI.PushButton) 34 20 nil 1024 34 2 8 1140924416 1 1568 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 1568 nil 8 1879847040 1377606 4 ##(UI.CommandDescription) #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 801 63 578 41 41 1568 786 #isEnabled: 8 #(false) 1568 786 #text: 34 1 8 '…' 1568 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 31 0 0 0 164 1 0 0 51 0 0 0] 8 #() 928 nil 29 1458 1490 #fixedPreviousRight 15 1520 41 1490 #fixedPreviousTop 1 1552 41 410 ##(UI.StaticText) 34 16 nil 1024 34 2 8 1140850944 1 2000 nil nil nil 7 nil nil nil 2000 nil 8 1879886752 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 123 578 201 41 2000 786 #text: 34 1 8 '&Superclass:' 2000 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 61 0 0 0 100 0 0 0 81 0 0 0] 8 #() 928 nil 27 1458 1504 1 1520 201 1490 #fixedPreviousBottom 21 1552 41 410 ##(UI.TextEdit) 34 16 nil 1024 34 2 8 1140850816 262145 2320 nil 1648 nil 7 nil nil nil 2320 nil 8 1879842560 1234 nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 201 63 578 587 41 2320 786 #setMarginWidths: 34 1 8 #(3 3) 2320 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 31 0 0 0 137 1 0 0 51 0 0 0] 8 #() 928 nil 27 1458 1968 1 1490 #fixedParentRight -53 1984 -1 1552 41 410 ##(UI.PushButton) 34 20 nil 1024 34 2 8 1140924416 1 2640 nil 1648 nil 7 nil nil nil 2640 nil 8 1879847040 1682 #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 801 121 578 41 41 2640 786 #isEnabled: 8 #(false) 2640 786 #text: 34 1 8 '…' 2640 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 60 0 0 0 164 1 0 0 80 0 0 0] 8 #() 928 nil 29 1458 1968 15 1520 41 1984 1 1552 41 410 ##(UI.TextEdit) 34 16 nil 1024 34 2 8 1140916352 1025 2992 nil 1648 nil 7 nil nil nil 2992 nil 8 1879842560 1234 nil nil 5 738 34 2 786 #createAt:extent: 34 2 578 201 1 578 587 45 2992 786 #setMarginWidths: 34 1 8 #(3 3) 2992 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 0 0 0 0 137 1 0 0 22 0 0 0] 8 #() 928 nil 27 1458 1968 1 2624 -53 1984 -3 1552 45 410 ##(UI.StaticRectangle) 34 14 nil 1024 34 2 8 1140850960 1 3296 nil nil nil 7 nil nil nil 3296 nil 8 1879886752 738 34 1 786 #createAt:extent: 34 2 578 1 179 578 841 5 3296 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 89 0 0 0 164 1 0 0 91 0 0 0] 8 #() 928 nil 27 1458 1504 1 2624 1 1490 #fixedViewBottom -3 1490 #fixedParentBottom -7 410 ##(UI.StaticText) 34 16 nil 1024 34 2 8 1140850944 1 3568 nil nil nil 7 nil nil nil 3568 nil 8 1879886752 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 65 578 201 41 3568 786 #text: 34 1 8 '&Namespace:' 3568 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 0 0 0 100 0 0 0 52 0 0 0] 8 #() 928 nil 27 1458 1504 1 1520 201 2304 21 1552 41 410 ##(UI.TextEdit) 34 16 nil 1024 34 2 8 1140850816 262145 3872 nil nil nil 7 nil nil nil 3872 nil 8 1879842560 1234 nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 201 121 578 587 41 3872 786 #setMarginWidths: 34 1 8 #(3 3) 3872 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 60 0 0 0 137 1 0 0 80 0 0 0] 8 #() 928 nil 27 1458 1968 1 2624 -53 1984 -1 1552 41 170 192 34 8 2992 8 'className' 2320 8 'namespace' 3872 8 'superclass' 1568 8 'chooseNamespace' nil 738 34 1 786 #createAt:extent: 34 2 578 1 1 578 841 191 1024 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 1 0 0 95 0 0 0] 34 9 1152 2992 3568 2320 1568 2000 3872 2640 3296 928 nil 27 nil nil nil 410 ##(UI.ContainerView) 34 15 nil 944 34 2 8 1140850688 131073 4416 nil nil nil 7 nil nil nil 4416 1376774 ##(UI.ProportionalLayout) 170 176 912 false 170 192 34 2 410 ##(UI.ListView) 34 45 nil 4416 34 2 8 1140953161 1025 4560 787270 2 ##(UI.ListModel) 138 144 912 nil 1769478 ##(Kernel.IdentitySearchPolicy) 1648 nil 7 nil nil nil 4560 nil 8 1879798960 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil 578 65 65 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Subclasses' 409 #left ##(UI.BasicListAbstract) 786950 ##(Core.Message) #<= 8 #() nil nil 4560 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 425 7 578 417 507 4560 786 #text: 34 1 8 'Subclasses' 4560 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 212 0 0 0 3 0 0 0 164 1 0 0 0 1 0 0] 8 #() 928 nil 35 8 'subclasses' 1180166 ##(Graphics.Rectangle) 578 1 7 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 191 578 841 513 4416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 95 0 0 0 164 1 0 0 95 1 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 4416 34 2 8 1140850688 131073 5328 nil nil nil 23 nil nil nil 5328 610 1 1 410 ##(UI.CheckBox) 34 16 nil 5328 34 2 8 1140924419 1 5408 918598 2 ##(UI.ValueHolder) nil false 1704454 ##(Core.PluggableSearchPolicy) 4850 #= 8 #() 4850 #hash 8 #() false nil nil 7 nil nil nil 5408 nil 8 1879847040 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 -1 578 415 51 5408 786 #text: 34 1 8 '&Packaged?' 5408 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 207 0 0 0 24 0 0 0] 8 #() 928 nil 27 nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 5328 34 2 8 1140850688 131073 5824 nil nil nil 7 nil nil nil 5824 706 ##(Tools.PackageSelector) #resource_Choice_view nil 738 34 1 786 #createAt:extent: 34 2 578 1 49 578 415 459 5824 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 207 0 0 0 253 0 0 0] 912 928 nil 27 170 192 34 4 5408 8 'setPackage' 5824 8 'package' 5122 578 1 -1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 7 578 415 507 5328 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 207 0 0 0 0 1 0 0] 34 2 5408 5824 928 nil 27 410 ##(UI.Splitter) 34 12 nil 4416 34 2 8 1140850688 1 6288 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 6288 nil 1 #left nil nil nil 578 1 1 578 9 9 nil 6384 nil 738 34 1 786 #createAt:extent: 34 2 578 415 7 578 11 507 6288 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 3 0 0 0 212 0 0 0 0 1 0 0] 8 #() 928 nil 27 4560 928 nil 27 170 192 912 5122 578 1 1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 25 21 578 841 703 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 10 0 0 0 176 1 0 0 105 1 0 0] 34 2 1024 4416 928 nil 27 170 192 912 5122 578 25 21 578 25 21 nil nil nil nil 26291 nil nil nil 578 621 581 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 nil 8 2001958528 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 921 891 416 786 #text: 34 1 8 'Create Class…' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 203 25 0 0 199 1 0 0] 34 2 944 640 928 nil 27 )!

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

