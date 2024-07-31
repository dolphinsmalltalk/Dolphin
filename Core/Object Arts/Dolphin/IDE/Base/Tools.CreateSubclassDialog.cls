"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.CreateSubclassDialog'
	instanceVariableNames: 'packagesPresenter subclassesPresenter namePresenter namespacePresenter usePackagePresenter package superclassPresenter isNonInstantiablePresenter isVariablePresenter isBytesPresenter attributesPresenter'
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

canChangeAttributes
	^attributesPresenter view isEnabled!

chooseNamespace
	(ChooseNamespaceDialog createOn: namespacePresenter model) showModal.
	self validate!

chooseSuperclass
	SmalltalkSystem current
		chooseClass: superclassPresenter model
		caption: 'Choose Superclass…'
		allowNil: true!

classDetails
	^Refactory.Browser.ClassDetails new
		className: self subclassFullName;
		superclass: self superclass;
		isBytes: self isBytes;
		isNonInstantiable: self isNonInstantiable;
		isVariable: self isVariable;
		isPointers: self isBytes not;
		package: self package;
		yourself
		
		!

createComponents
	super createComponents.
	validationResultPresenter
		filterBlock: [:result | result presenter ~~ namePresenter or: [self subclassName notEmpty]];
		hintFont: SmalltalkSystem current defaultFont.
	namePresenter := self add: TextPresenter new name: 'className'.
	namespacePresenter := self add: TextPresenter new name: 'namespace'.
	superclassPresenter := self add: TextPresenter new name: 'superclass'.
	attributesPresenter := self add: Presenter new name: 'attributes'.
	isNonInstantiablePresenter := self add: BooleanPresenter new name: 'isNonInstantiable'.
	isVariablePresenter := self add: BooleanPresenter new name: 'isVariable'.
	isBytesPresenter := self add: BooleanPresenter new name: 'isBytes'.
	packagesPresenter := self add: (PackageSelector new
						autoSelect: false;
						yourself)
				name: 'package'.
	subclassesPresenter := self add: ChoicePresenter new name: 'subclasses'.
	usePackagePresenter := self add: BooleanPresenter new name: 'setPackage'.
	usePackagePresenter model: true!

createSchematicWiring
	super createSchematicWiring.
	namePresenter
		when: #valueChanged
		send: #onNameChanged
		to: self.
	packagesPresenter
		when: #selectionChanged
		send: #onPackageSelected
		to: self.
	usePackagePresenter
		when: #valueChanged
		send: #onIsPackagedChanged
		to: self.
	superclassPresenter
		when: #valueChanged
		send: #onSuperclassChanged
		to: self.
	isBytesPresenter
		when: #valueChanged
		send: #onIsBytesChanged
		to: self.
	isNonInstantiablePresenter
		when: #valueChanged
		send: #onIsAbstractChanged
		to: self!

defaultNamespaceForSubclassOf: aClass
	^##(LookupTable withAll: {Namespace -> Root. SharedPool -> OS}) at: aClass
		ifAbsent: [aClass localEnvironment]!

disableAttributeChanges
	attributesPresenter view
		isEnabled: false;
		subViewsDo: [:each | each isEnabled: false]!

isBytes
	^isBytesPresenter model value!

isBytes: aBoolean
	isBytesPresenter model value: aBoolean!

isNonInstantiable
	^isNonInstantiablePresenter model value!

isNonInstantiable: aBoolean
	isNonInstantiablePresenter model value: aBoolean!

isPackaged
	^usePackagePresenter model value!

isVariable
	^isVariablePresenter model value!

isVariable: aBoolean
	isVariablePresenter model value: aBoolean!

model: aSubjectModel
	| aClassOrNil |
	super model: aSubjectModel.
	aClassOrNil := aSubjectModel value.
	package := SmalltalkSystem current defaultPackage.
	superclassPresenter model: aClassOrNil.
	aClassOrNil
		ifNil: [namespacePresenter model: Smalltalk asValue]
		ifNotNil: [namespacePresenter model: (self defaultNamespaceForSubclassOf: aClassOrNil)].
	self onSuperclassChanged!

onIsAbstractChanged
	self setNameFont!

onIsBytesChanged
	| isBytes |
	isBytes := self isBytes.
	self isVariable: isBytes.
	isVariablePresenter view isEnabled: isBytes not.
	self deferredValidate!

onIsPackagedChanged
	self isPackaged
		ifTrue: 
			[package := packagesPresenter selectionOrNil.
			packagesPresenter isEnabled: true]
		ifFalse: 
			[package := nil.
			packagesPresenter isEnabled: false].
	self deferredValidate!

onNameChanged
	"Private - The subclass name has been edited. Initiate delayed validation."

	self deferredValidate!

onPackageSelected
	package := packagesPresenter selectionOrNil.
	self deferredValidate!

onSuperclassChanged
	| superClass |
	superClass := self superclass.
	superClass isNil
		ifTrue: [subclassesPresenter choices: Smalltalk allRoots]
		ifFalse: 
			[subclassesPresenter choices: superClass subclasses.
			package isNil ifTrue: [package := superClass owningPackage]].
	self updateAttributes; deferredValidate!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	self
		updateAttributes;
		updatePackage;
		setNameFont!

package
	^package!

package: aPackage
	package := aPackage == Package uncommitted ifFalse: [aPackage].
	self isOpen ifTrue: [self updatePackage]!

setNameFont
	| font nameView |
	nameView := namePresenter view.
	font := nameView actualFont copy.
	font isItalic: self isNonInstantiable.
	nameView font: font!

subclasses
	^subclassesPresenter model value ?? #()!

subclassFullName
	^namespacePresenter value fullNameFor: self subclassName!

subclassFullName: aString
	| bindingRef |
	bindingRef := aString asQualifiedReference.
	self
		subclassNamespace: bindingRef environment ?? Smalltalk;
		subclassName: bindingRef unqualifiedName!

subclassName
	^namePresenter value!

subclassName: aString
	namePresenter value: aString!

subclassNamespace
	"Private - Answer the <Namespace> into which which we are defining a subclass."

	^namespacePresenter value!

subclassNamespace: aNamespace
	"Private - Set the <Namespace> into which which we are defining a subclass."

	namespacePresenter value: aNamespace!

superclass
	^superclassPresenter value!

superclass: aClass
	superclassPresenter value: aClass!

updateAttributes
	| superClass |
	self canChangeAttributes ifFalse: [^self].
	attributesPresenter view subViewsDo: [:each | each isEnabled: true].
	superClass := self superclass.
	superClass ifNil: [^self].
	superClass isVariable
		ifTrue: 
			[self isVariable: true.
			isVariablePresenter view isEnabled: false.
			isBytesPresenter view isEnabled: false.
			self isBytes: superClass isBytes]
		ifFalse: 
			[self
				isVariable: false;
				isBytes: false.
			isBytesPresenter view isEnabled: superClass instSize == 0]!

updatePackage
	package isNil 
		ifTrue: [usePackagePresenter value: false]
		ifFalse: 
			[usePackagePresenter value: true.
			packagesPresenter selection: package]!

validateModel
	^self validateName
		ifNil: [self validateSuperclass ifNil: [self validatePackage ifNil: [ValidationResult new]]]!

validateName
	| result unqualifiedName namespace |
	result := ValidationResult new.
	result presenter: namePresenter.
	unqualifiedName := self subclassName.
	result caption: 'Invalid name for new class'.
	unqualifiedName isEmpty
		ifTrue: 
			[^result
				errorMessage: 'Please specify a new class name';
				yourself].
	(BindingReference isQualifiedName: unqualifiedName)
		ifTrue: 
			[^result
				errorMessage: 'New class name cannot be qualified';
				yourself].
	(ClassBuilder isValidClassName: unqualifiedName)
		ifFalse: 
			[^result
				errorMessage: ClassBuilder.ErrorInvalidClassName << unqualifiedName;
				yourself].
	namespace := self subclassNamespace.
	(namespace localBindingFor: unqualifiedName)
		ifNotNil: 
			[^result
				errorMessage: ClassBuilder.ErrorAlreadyExists << {namespace. unqualifiedName};
				yourself].
	^nil!

validatePackage
	^(self isPackaged and: [self package isNil])
		ifTrue: 
			[(ValidationResult errorMessage: 'No package selected')
				caption: 'Incomplete input';
				presenter: (self view viewNamed: 'packages');
				yourself]!

validateSuperclass
	^self validateSuperclass: self classDetails!

validateSuperclass: aClassDetails
	| result superclass |
	superclass := aClassDetails superclass.
	superclass ifNil: [^nil].
	result := self systemModel validateCreateSubclass: aClassDetails.
	result value ifTrue: [^nil].
	^result
		presenter: superclassPresenter;
		caption: 'Incompatible superclass';
		yourself!

validationResultPresenterClass
	^ValidationHintPresenter! !

!Tools.CreateSubclassDialog categoriesForMethods!
canChangeAttributes!public!testing! !
chooseNamespace!commands!private! !
chooseSuperclass!commands!public! !
classDetails!accessing!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultNamespaceForSubclassOf:!helpers!private! !
disableAttributeChanges!modes!public! !
isBytes!private!testing! !
isBytes:!accessing!private! !
isNonInstantiable!private!testing! !
isNonInstantiable:!accessing!private! !
isPackaged!accessing!private! !
isVariable!private!testing! !
isVariable:!accessing!private! !
model:!accessing!public! !
onIsAbstractChanged!private!updating! !
onIsBytesChanged!event handling!private! !
onIsPackagedChanged!event handling!private! !
onNameChanged!event handling!private! !
onPackageSelected!event handling!private! !
onSuperclassChanged!event handling!private! !
onViewOpened!event handling!public! !
package!accessing!public! !
package:!accessing!public! !
setNameFont!private!updating! !
subclasses!accessing!public! !
subclassFullName!accessing!public! !
subclassFullName:!accessing!public! !
subclassName!accessing!public! !
subclassName:!accessing!public! !
subclassNamespace!accessing!private! !
subclassNamespace:!accessing!private! !
superclass!accessing!public! !
superclass:!accessing!public! !
updateAttributes!private!updating! !
updatePackage!private!updating! !
validateModel!private!validation! !
validateName!private!validation! !
validatePackage!private!validation! !
validateSuperclass!private!validation! !
validateSuperclass:!private!testing! !
validationResultPresenterClass!constants!public! !
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
	(aClassOrNil notNil and: [aClassOrNil includesBehavior: Namespace])
		ifTrue: 
			[dialog
				caption: 'New Namespace Class...';
				disableAttributeChanges].
	^dialog!

refactoringView
	^'Refactoring view'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 240 nil nil nil 5 nil nil nil 240 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[12 0 0 0 140 1 0 0 121 1 0 0 175 1 0 0] 193 272 8 '' 240 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 210 1 1 18 #{UI.ContainerView} 50 15 nil 576 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 18 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140916352 1025 800 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 800 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[100 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 193 832 nil 800 386 #setMarginWidths: 50 1 8 #(3 3) 800 3 8 #() 546 193 193 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 1 1154 #fixedParentRight -53 1154 #fixedPreviousTop -3 1154 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 1232 nil nil nil 5 nil nil nil 1232 nil nil 898 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 2 0 0 0 100 0 0 0 22 0 0 0] 193 1264 nil 1232 386 #text: 50 1 8 'New &class name:' 1232 3 8 #() 546 193 193 nil 27 1122 1154 #fixedParentLeft 1 1154 #fixedViewLeft 201 1154 #fixedParentTop 5 1216 41 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140850816 262145 1568 nil 880 nil 5 nil nil nil 1568 nil nil 898 nil nil 3 #perChar nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[100 0 0 0 31 0 0 0 82 1 0 0 51 0 0 0] 193 1600 nil 1568 386 #setMarginWidths: 50 1 8 #(3 3) 1568 3 8 #() 546 193 193 nil 45 1122 1168 1 1184 -53 1200 -1 1216 41 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1140924416 1 1856 nil 880 nil 5 nil nil nil 1856 nil nil 1350 4 #{UI.CommandDescription} #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[89 1 0 0 31 0 0 0 109 1 0 0 51 0 0 0] 193 1888 8 '…' 1856 386 #isEnabled: 8 #(false) 1856 3 8 #() 546 193 193 nil 29 1122 1168 15 1536 41 1200 1 1216 41 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 2176 nil nil nil 5 nil nil nil 2176 nil nil 898 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 32 0 0 0 100 0 0 0 52 0 0 0] 193 2208 nil 2176 386 #text: 50 1 8 '&Namespace:' 2176 3 8 #() 546 193 193 nil 27 1122 1520 1 1536 201 1154 #fixedPreviousBottom 21 1216 41 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140850816 262145 2480 nil nil nil 5 nil nil nil 2480 nil nil 898 nil nil 3 #perChar nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[100 0 0 0 60 0 0 0 82 1 0 0 80 0 0 0] 193 2512 nil 2480 386 #setMarginWidths: 50 1 8 #(3 3) 2480 3 8 #() 546 193 193 nil 45 1122 1168 1 1184 -53 1200 -1 1216 41 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1140924416 1 2768 nil 880 nil 5 nil nil nil 2768 nil nil 1922 #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[89 1 0 0 60 0 0 0 109 1 0 0 80 0 0 0] 193 2800 8 '…' 2768 386 #isEnabled: 8 #(false) 2768 3 8 #() 546 193 193 nil 29 1122 1168 15 1536 41 1200 1 1216 41 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 3072 nil nil nil 5 nil nil nil 3072 nil nil 898 nil nil nil 338 50 2 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 61 0 0 0 100 0 0 0 81 0 0 0] 193 3104 nil 3072 386 #text: 50 1 8 '&Superclass:' 3072 3 8 #() 546 193 193 nil 27 1122 1520 1 1536 201 2464 21 1216 41 18 #{UI.ContainerView} 50 15 nil 656 50 2 8 1140850688 131073 3360 nil nil nil 5 nil nil nil 3360 722 754 #{Core.LookupTable} 50 8 18 #{UI.GroupBox} 50 14 nil 3360 50 2 8 1140981767 1 3472 nil nil nil 5 nil nil nil 3472 nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 109 1 0 0 50 0 0 0] 193 3504 8 'Attributes' 3472 3 8 #() 546 193 193 nil 27 1122 1520 1 1184 1 1552 1 1154 #fixedParentBottom 1 18 #{UI.CheckBox} 50 16 nil 3360 50 2 8 1409363203 1 3728 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 3728 nil nil 898 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[12 0 0 0 18 0 0 0 92 0 0 0 40 0 0 0] 193 3760 8 '&Abstract?' 3728 3 8 #() 546 193 193 nil 27 1122 1520 25 1536 161 1552 37 1216 45 18 #{UI.CheckBox} 50 16 nil 3360 50 2 8 1409363203 1 4048 3794 nil nil 3840 false nil nil 5 nil nil nil 4048 nil nil 898 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[92 0 0 0 18 0 0 0 180 0 0 0 40 0 0 0] 193 4080 8 '&Indexable?' 4048 3 8 #() 546 193 193 nil 27 1122 1168 1 1536 177 1200 1 1216 45 18 #{UI.CheckBox} 50 16 nil 3360 50 2 8 1409363203 1 4320 3794 nil nil 3840 false nil nil 5 nil nil nil 4320 nil nil 898 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[180 0 0 0 18 0 0 0 235 0 0 0 40 0 0 0] 193 4352 8 '&Bytes?' 4320 3 8 #() 546 193 193 nil 27 1122 1168 1 1536 111 1200 1 1216 45 754 #{Core.IdentityDictionary} 50 6 4320 8 'isBytes' 3728 8 'isNonInstantiable' 4048 8 'isVariable' nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 86 0 0 0 109 1 0 0 136 0 0 0] 193 3392 8 '' 3360 3 50 4 3728 4048 4320 3472 546 193 193 nil 27 1122 1520 1 1184 1 2464 13 1216 101 754 #{Core.IdentityDictionary} 50 10 3360 8 'attributes' 1856 8 'chooseNamespace' 800 8 'className' 1568 8 'namespace' 2480 8 'superclass' nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 0 0 0 0 109 1 0 0 140 0 0 0] 193 688 8 '' 656 3 50 9 1232 800 2176 1568 1856 3072 2480 2768 3360 546 193 193 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 576 50 2 8 1140850688 131073 5120 nil nil nil 5 nil nil nil 5120 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 546 1 7 546 1 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 140 0 0 0 109 1 0 0 128 1 0 0] 193 5152 8 '' 5120 3 50 1 18 #{UI.ContainerView} 50 15 nil 5120 50 2 8 1140850688 131073 5488 nil nil nil 21 nil nil nil 5488 210 1 1 18 #{UI.CheckBox} 50 16 nil 5488 50 2 8 1140924419 1 5568 3794 nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 5682 #hash 8 #() false nil nil 5 nil nil nil 5568 nil nil 898 nil nil nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 193 5600 8 '&Packaged?' 5568 3 8 #() 546 193 193 nil 27 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 5488 50 2 8 1140850688 131073 5936 nil nil nil 5 nil nil nil 5936 306 #{Tools.PackageSelector} #resource_Choice_view nil 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 24 0 0 0 109 1 0 0 241 0 0 0] 193 5968 8 '' 5936 3 528 546 193 193 nil 27 754 5248 50 2 5568 8 'setPackage' 5282 546 1 -1 546 1 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[0 0 0 0 3 0 0 0 109 1 0 0 244 0 0 0] 193 5520 8 '' 5488 3 50 2 5568 5936 546 193 193 nil 27 546 193 193 nil 27 5250 0 5282 546 1 1 546 1 1 338 50 1 386 #createWindow: 50 1 434 466 8 #[12 0 0 0 12 0 0 0 121 1 0 0 140 1 0 0] 193 608 8 '' 576 3 50 2 656 5120 546 193 193 nil 27 5250 0 5282 546 25 25 546 25 21 nil nil nil nil 1 nil nil nil 546 521 601 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 338 50 2 386 #createWindow: 50 1 518 #{UI.CreateDialog} 5282 546 7679 21 546 8489 981 193 32 386 #setWindowText: 50 1 8 'Create Class…' 32 1 50 2 576 240 546 193 193 nil 29)!

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
subclassOf:inPackage:!operations!public! !
!

