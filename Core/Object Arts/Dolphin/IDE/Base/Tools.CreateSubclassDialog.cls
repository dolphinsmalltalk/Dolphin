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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 5 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 25 793 210 731 71 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 140 1 0 0 121 1 0 0 175 1 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 5 nil nil nil 576 242 1 1 18 #{UI.ContainerView} 50 15 nil 576 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 18 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140916352 1025 800 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 800 nil nil 518 #{UI.NullConverter} nil nil 1 #perChar nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 201 1 210 477 45 800 418 #setMarginWidths: 50 1 8 #(3 3) 800 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 8 #() 560 nil 45 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 1 1154 #fixedParentRight -53 1154 #fixedPreviousTop -3 1154 #fixedViewTop 45 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 1232 nil nil nil 5 nil nil nil 1232 nil nil 898 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 5 210 201 41 1232 418 #text: 50 1 8 'New &class name:' 1232 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 100 0 0 0 22 0 0 0] 8 #() 560 nil 27 1122 1154 #fixedParentLeft 1 1154 #fixedViewLeft 201 1154 #fixedParentTop 5 1216 41 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140850816 262145 1568 nil 880 nil 5 nil nil nil 1568 nil nil 898 nil nil 3 #perChar nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 201 63 210 477 41 1568 418 #setMarginWidths: 50 1 8 #(3 3) 1568 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 31 0 0 0 82 1 0 0 51 0 0 0] 8 #() 560 nil 45 1122 1168 1 1184 -53 1200 -1 1216 41 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1140924416 1 1856 nil 880 nil 5 nil nil nil 1856 nil nil 1350 4 #{UI.CommandDescription} #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 370 50 3 418 #createAt:extent: 50 2 210 691 63 210 41 41 1856 418 #isEnabled: 8 #(false) 1856 418 #text: 50 1 8 '…' 1856 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 31 0 0 0 109 1 0 0 51 0 0 0] 8 #() 560 nil 29 1122 1168 15 1536 41 1200 1 1216 41 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 2208 nil nil nil 5 nil nil nil 2208 nil nil 898 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 65 210 201 41 2208 418 #text: 50 1 8 '&Namespace:' 2208 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 0 0 0 100 0 0 0 52 0 0 0] 8 #() 560 nil 27 1122 1520 1 1536 201 1154 #fixedPreviousBottom 21 1216 41 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140850816 262145 2512 nil nil nil 5 nil nil nil 2512 nil nil 898 nil nil 3 #perChar nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 201 121 210 477 41 2512 418 #setMarginWidths: 50 1 8 #(3 3) 2512 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 60 0 0 0 82 1 0 0 80 0 0 0] 8 #() 560 nil 45 1122 1168 1 1184 -53 1200 -1 1216 41 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1140924416 1 2800 nil 880 nil 5 nil nil nil 2800 nil nil 1922 #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 370 50 3 418 #createAt:extent: 50 2 210 691 121 210 41 41 2800 418 #isEnabled: 8 #(false) 2800 418 #text: 50 1 8 '…' 2800 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 60 0 0 0 109 1 0 0 80 0 0 0] 8 #() 560 nil 29 1122 1168 15 1536 41 1200 1 1216 41 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 3136 nil nil nil 5 nil nil nil 3136 nil nil 898 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 123 210 201 41 3136 418 #text: 50 1 8 '&Superclass:' 3136 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 61 0 0 0 100 0 0 0 81 0 0 0] 8 #() 560 nil 27 1122 1520 1 1536 201 2496 21 1216 41 18 #{UI.ContainerView} 50 15 nil 656 50 2 8 1140850688 131073 3424 nil nil nil 5 nil nil nil 3424 722 754 #{Core.LookupTable} 50 8 18 #{UI.GroupBox} 50 14 nil 3424 50 2 8 1140981767 1 3536 nil nil nil 5 nil nil nil 3536 nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 1 210 731 101 3536 418 #text: 50 1 8 'Attributes' 3536 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 50 0 0 0] 8 #() 560 nil 27 1122 1520 1 1184 1 1552 1 1154 #fixedParentBottom 1 18 #{UI.CheckBox} 50 16 nil 3424 50 2 8 1409363203 1 3824 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 3824 nil nil 898 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 25 37 210 161 45 3824 418 #text: 50 1 8 '&Abstract?' 3824 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 18 0 0 0 92 0 0 0 40 0 0 0] 8 #() 560 nil 27 1122 1520 25 1536 161 1552 37 1216 45 18 #{UI.CheckBox} 50 16 nil 3424 50 2 8 1409363203 1 4176 3890 nil nil 3936 false nil nil 5 nil nil nil 4176 nil nil 898 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 185 37 210 177 45 4176 418 #text: 50 1 8 '&Indexable?' 4176 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 0 0 0 18 0 0 0 180 0 0 0 40 0 0 0] 8 #() 560 nil 27 1122 1168 1 1536 177 1200 1 1216 45 18 #{UI.CheckBox} 50 16 nil 3424 50 2 8 1409363203 1 4480 3890 nil nil 3936 false nil nil 5 nil nil nil 4480 nil nil 898 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 361 37 210 111 45 4480 418 #text: 50 1 8 '&Bytes?' 4480 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 18 0 0 0 235 0 0 0 40 0 0 0] 8 #() 560 nil 27 1122 1168 1 1536 111 1200 1 1216 45 754 #{Core.IdentityDictionary} 50 6 4480 8 'isBytes' 3824 8 'isNonInstantiable' 4176 8 'isVariable' nil 370 50 1 418 #createAt:extent: 50 2 210 1 173 210 731 101 3424 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 86 0 0 0 109 1 0 0 136 0 0 0] 50 4 3824 4176 4480 3536 560 nil 27 1122 1520 1 1184 1 2496 13 1216 101 754 #{Core.IdentityDictionary} 50 10 3424 8 'attributes' 1856 8 'chooseNamespace' 800 8 'className' 1568 8 'namespace' 2512 8 'superclass' nil 370 50 1 418 #createAt:extent: 50 2 210 1 1 210 731 281 656 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 140 0 0 0] 50 9 1232 800 2208 1568 1856 3136 2512 2800 3424 560 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 576 50 2 8 1140850688 131073 5280 nil nil nil 5 nil nil nil 5280 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 550 #{Core.IdentityDictionary} 0 518 #{Graphics.Rectangle} 210 1 7 210 1 1 370 50 1 418 #createAt:extent: 50 2 210 1 281 210 731 489 5280 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 140 0 0 0 109 1 0 0 128 1 0 0] 50 1 18 #{UI.ContainerView} 50 15 nil 5280 50 2 8 1140850688 131073 5648 nil nil nil 21 nil nil nil 5648 242 1 1 18 #{UI.CheckBox} 50 16 nil 5648 50 2 8 1140924419 1 5728 3890 nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 5842 #hash 8 #() false nil nil 5 nil nil nil 5728 nil nil 898 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 -1 210 731 51 5728 418 #text: 50 1 8 '&Packaged?' 5728 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 8 #() 560 nil 27 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 5648 50 2 8 1140850688 131073 6128 nil nil nil 5 nil nil nil 6128 338 #{Tools.PackageSelector} #resource_Choice_view nil 370 50 1 418 #createAt:extent: 50 2 210 1 49 210 731 435 6128 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 109 1 0 0 241 0 0 0] 544 560 nil 27 754 5408 50 2 5728 8 'setPackage' 5442 210 1 -1 210 1 1 370 50 1 418 #createAt:extent: 50 2 210 1 7 210 731 483 5648 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 109 1 0 0 244 0 0 0] 50 2 5728 6128 560 nil 27 560 nil 27 5410 0 5442 210 1 1 210 1 1 370 50 1 418 #createAt:extent: 50 2 210 25 25 210 731 769 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 121 1 0 0 140 1 0 0] 50 2 656 5280 560 nil 27 5410 0 5442 210 25 25 210 25 21 nil nil nil nil 1 nil nil nil 210 521 601 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 811 961 32 418 #text: 50 1 8 'Create Class…' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 148 13 0 0 234 1 0 0] 50 2 576 272 560 nil 27)!

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

