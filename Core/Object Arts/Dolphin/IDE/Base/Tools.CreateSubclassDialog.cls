"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'Tools.CreateSubclassDialog'
	instanceVariableNames: 'packagesPresenter subclassesPresenter namePresenter namespacePresenter usePackagePresenter package superclassPresenter hintBubble isNonInstantiablePresenter isVariablePresenter isBytesPresenter attributesPresenter'
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
	^self validateModel value!

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

closeBubble
	hintBubble
		ifNotNil: 
			[hintBubble close.
			hintBubble := nil]!

createComponents
	super createComponents.
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

deferredValidate
	self closeBubble.
	self view setTimer: ValidationTimerId interval: self validationDwell!

disableAttributeChanges
	attributesPresenter view
		isEnabled: false;
		subViewsDo: [:each | each isEnabled: false]!

getHintCaption: aValidationResult
	^aValidationResult caption
		ifNil: [aValidationResult hint iconStyle == #error ifTrue: ['Invalid Input']]!

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

queryCommand: aCommandQuery
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[aCommandQuery isEnabled: self canApply.
			^true].
	^super queryCommand: aCommandQuery!

setNameFont
	| font nameView |
	nameView := namePresenter view.
	font := nameView actualFont copy.
	font isItalic: self isNonInstantiable.
	nameView font: font!

shouldShowValidationHint: aValidationResult
	^aValidationResult hint notNil
		and: [aValidationResult presenter ~~ namePresenter or: [self subclassName notEmpty]]!

showValidationResult: aValidationResult
	self closeBubble.
	(self shouldShowValidationHint: aValidationResult)
		ifTrue: 
			[hintBubble := MessageBubble new.
			hintBubble
				caption: (self getHintCaption: aValidationResult);
				font: self hintFont;
				timeout: self hintDwell;
				position: aValidationResult presenter view screenRectangle centerRight;
				exceptionDescription: aValidationResult hint;
				isSilent: true;
				open]!

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
	^self validateSuperclass
		ifNil: [self validatePackage ifNil: [self validateName ifNil: [ValidationResult new]]]!

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
	| superclass aValidationResult |
	superclass := self superclass.
	superclass ifNil: [^nil].
	aValidationResult := ValidationResult new
				presenter: superclassPresenter;
				caption: 'Incompatible superclass';
				yourself.
	(ClassBuilder.Unsubclassable includes: superclass)
		ifTrue: 
			[^aValidationResult
				errorMessage: ClassBuilder.ErrorUnsubclassable << superclass;
				yourself].
	self isBytes
		ifTrue: 
			[superclass isPointers
				ifTrue: 
					[superclass instSize > 0
						ifTrue: 
							[^aValidationResult
								errorMessage: ClassBuilder.ErrorByteSubclassOfFixed << superclass;
								yourself].
					superclass isVariable
						ifTrue: 
							[^aValidationResult
								errorMessage: ClassBuilder.ErrorByteSubclassOfVariable << superclass;
								yourself]].
			^nil].
	"Validate pointer class"
	superclass isBytes
		ifTrue: 
			[^aValidationResult
				errorMessage: ClassBuilder.ErrorPointerSubclassOfBytes << superclass;
				yourself].
	(superclass isVariable and: [self isVariable not])
		ifTrue: 
			[^aValidationResult
				errorMessage: ClassBuilder.ErrorFixedSubclassOfVariable << superclass;
				yourself].
	^nil! !
!Tools.CreateSubclassDialog categoriesForMethods!
canApply!private!testing! !
canChangeAttributes!public!testing! !
chooseNamespace!commands!private! !
chooseSuperclass!commands!public! !
classDetails!accessing!public! !
closeBubble!helpers!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultNamespaceForSubclassOf:!helpers!private! !
deferredValidate!event handling!private! !
disableAttributeChanges!modes!public! !
getHintCaption:!helpers!private! !
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
queryCommand:!commands!private! !
setNameFont!private!updating! !
shouldShowValidationHint:!private!testing! !
showValidationResult:!helpers!private! !
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
validateSuperclass!private!testing! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 135 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 272 nil nil nil 7 nil nil nil 272 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 25 793 210 731 71 272 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 140 1 0 0 121 1 0 0 175 1 0 0] 8 #() 210 193 193 nil 27 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 576 nil nil nil 7 nil nil nil 576 242 1 1 18 #{UI.ContainerView} 50 15 nil 576 50 2 8 1140850688 131073 656 nil nil nil 7 nil nil nil 656 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 9 18 #{UI.ContainerView} 50 15 nil 656 50 2 8 1140850688 131073 784 nil nil nil 7 nil nil nil 784 722 754 4 18 #{UI.CheckBox} 50 16 nil 784 50 2 8 1409363203 1 880 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 880 nil 8 1853182784 518 #{UI.NullConverter} nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 185 37 210 177 45 880 418 #text: 50 1 8 '&Indexable?' 880 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 0 0 0 18 0 0 0 180 0 0 0 40 0 0 0] 8 #() 560 nil 27 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedPreviousRight 1 1282 #fixedViewLeft 177 1282 #fixedPreviousTop 1 1282 #fixedViewTop 45 18 #{UI.CheckBox} 50 16 nil 784 50 2 8 1409363203 1 1360 946 nil nil 992 false nil nil 7 nil nil nil 1360 nil 8 1853182784 1026 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 25 37 210 161 45 1360 418 #text: 50 1 8 '&Abstract?' 1360 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 18 0 0 0 92 0 0 0 40 0 0 0] 8 #() 560 nil 27 1250 1282 #fixedParentLeft 25 1312 161 1282 #fixedParentTop 37 1344 45 18 #{UI.CheckBox} 50 16 nil 784 50 2 8 1409363203 1 1712 946 nil nil 992 false nil nil 7 nil nil nil 1712 nil 8 1853182784 1026 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 361 37 210 111 45 1712 418 #text: 50 1 8 '&Bytes?' 1712 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 18 0 0 0 235 0 0 0 40 0 0 0] 8 #() 560 nil 27 1250 1296 1 1312 111 1328 1 1344 45 18 #{UI.GroupBox} 50 14 nil 784 50 2 8 1140981767 1 2032 nil nil nil 7 nil nil nil 2032 nil 8 1853182784 370 50 2 418 #createAt:extent: 50 2 210 1 1 210 731 101 2032 418 #text: 50 1 8 'Attributes' 2032 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 50 0 0 0] 8 #() 560 nil 27 1250 1680 1 1282 #fixedParentRight 1 1696 1 1282 #fixedParentBottom 1 550 #{Core.IdentityDictionary} 3 880 8 'isVariable' 1360 8 'isNonInstantiable' 1712 8 'isBytes' nil 370 50 1 418 #createAt:extent: 50 2 210 1 173 210 731 101 784 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 86 0 0 0 109 1 0 0 136 0 0 0] 50 4 1360 880 1712 2032 560 nil 27 1250 1680 1 2320 1 1282 #fixedPreviousBottom 13 1344 101 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1140924416 1 2608 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 2608 nil 8 1853182784 1350 4 #{UI.CommandDescription} #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 370 50 3 418 #createAt:extent: 50 2 210 691 121 210 41 41 2608 418 #isEnabled: 8 #(false) 2608 418 #text: 50 1 8 '…' 2608 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 60 0 0 0 109 1 0 0 80 0 0 0] 8 #() 560 nil 29 1250 1296 15 1312 41 1328 1 1344 41 18 #{UI.PushButton} 50 20 nil 656 50 2 8 1140924416 1 3008 nil 2688 nil 7 nil nil nil 3008 nil 8 1853182784 2722 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 370 50 3 418 #createAt:extent: 50 2 210 691 63 210 41 41 3008 418 #isEnabled: 8 #(false) 3008 418 #text: 50 1 8 '…' 3008 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 31 0 0 0 109 1 0 0 51 0 0 0] 8 #() 560 nil 29 1250 1296 15 1312 41 1328 1 1344 41 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 3360 nil nil nil 7 nil nil nil 3360 nil 8 1853387904 1026 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 123 210 201 41 3360 418 #text: 50 1 8 '&Superclass:' 3360 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 61 0 0 0 100 0 0 0 81 0 0 0] 8 #() 560 nil 27 1250 1680 1 1312 201 2592 21 1344 41 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 3664 nil nil nil 7 nil nil nil 3664 nil 8 1853387904 1026 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 65 210 201 41 3664 418 #text: 50 1 8 '&Namespace:' 3664 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 0 0 0 100 0 0 0 52 0 0 0] 8 #() 560 nil 27 1250 1680 1 1312 201 2592 21 1344 41 18 #{UI.StaticText} 50 16 nil 656 50 2 8 1140850944 1 3968 nil nil nil 7 nil nil nil 3968 nil 8 1853387904 1026 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 5 210 201 41 3968 418 #text: 50 1 8 'New &class name:' 3968 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 100 0 0 0 22 0 0 0] 8 #() 560 nil 27 1250 1680 1 1312 201 1696 5 1344 41 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140850816 262145 4272 nil 2688 nil 7 nil nil nil 4272 nil 8 1853175488 1026 nil nil 3 #perChar nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 201 63 210 477 41 4272 418 #setMarginWidths: 50 1 8 #(3 3) 4272 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 31 0 0 0 82 1 0 0 51 0 0 0] 8 #() 560 nil 45 1250 1296 1 2320 -53 1328 -1 1344 41 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140916352 1025 4576 nil 2688 nil 7 nil nil nil 4576 nil 8 1853175488 1026 nil nil 1 #perChar nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 201 1 210 477 45 4576 418 #setMarginWidths: 50 1 8 #(3 3) 4576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 8 #() 560 nil 45 1250 1296 1 2320 -53 1328 -3 1344 45 18 #{UI.TextEdit} 50 20 nil 656 50 2 8 1140850816 262145 4880 nil nil nil 7 nil nil nil 4880 nil 8 1853175488 1026 nil nil 3 #perChar nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 201 121 210 477 41 4880 418 #setMarginWidths: 50 1 8 #(3 3) 4880 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 60 0 0 0 82 1 0 0 80 0 0 0] 8 #() 560 nil 45 1250 1296 1 2320 -53 1328 -1 1344 41 2354 5 784 8 'attributes' 3008 8 'chooseNamespace' 4272 8 'namespace' 4576 8 'className' 4880 8 'superclass' nil 370 50 1 418 #createAt:extent: 50 2 210 1 1 210 731 281 656 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 140 0 0 0] 50 9 3968 4576 3664 4272 3008 3360 4880 2608 784 560 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 576 50 2 8 1140850688 131073 5424 nil nil nil 7 nil nil nil 5424 518 #{UI.ProportionalLayout} 754 0 false 2354 0 518 #{Graphics.Rectangle} 210 1 7 210 1 1 370 50 1 418 #createAt:extent: 50 2 210 1 281 210 731 489 5424 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 140 0 0 0 109 1 0 0 128 1 0 0] 50 1 18 #{UI.ContainerView} 50 15 nil 5424 50 2 8 1140850688 131073 5760 nil nil nil 23 nil nil nil 5760 242 1 1 18 #{UI.CheckBox} 50 16 nil 5760 50 2 8 1140924419 1 5840 946 nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 5954 #hash 8 #() false nil nil 7 nil nil nil 5840 nil 8 1853182784 1026 nil nil nil 370 50 2 418 #createAt:extent: 50 2 210 1 -1 210 731 51 5840 418 #text: 50 1 8 '&Packaged?' 5840 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 8 #() 560 nil 27 nil nil nil 18 #{UI.ReferenceView} 50 14 nil 5760 50 2 8 1140850688 131073 6256 nil nil nil 7 nil nil nil 6256 338 #{Tools.PackageSelector} #resource_Choice_view nil 370 50 1 418 #createAt:extent: 50 2 210 1 49 210 731 435 6256 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 109 1 0 0 241 0 0 0] 544 560 nil 27 2354 1 5840 8 'setPackage' 5554 210 1 -1 210 1 1 370 50 1 418 #createAt:extent: 50 2 210 1 7 210 731 483 5760 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 109 1 0 0 244 0 0 0] 50 2 5840 6256 560 nil 27 560 nil 27 2354 0 5554 210 1 1 210 1 1 370 50 1 418 #createAt:extent: 50 2 210 25 25 210 731 769 576 498 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 121 1 0 0 140 1 0 0] 50 2 656 5424 560 nil 27 2354 0 5554 210 25 25 210 25 21 nil nil nil nil 13311 nil nil nil 210 521 601 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil 8 2011790800 370 50 2 418 #createAt:extent: 50 2 210 6143 21 210 811 961 32 418 #text: 50 1 8 'Create Class…' 32 498 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 148 13 0 0 234 1 0 0] 50 2 576 272 560 nil 27)!

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

