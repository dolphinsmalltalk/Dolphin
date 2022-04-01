"Filed out from Dolphin Smalltalk"!

UI.Dialog subclass: #'Tools.CreateSubclassDialog'
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

namespace
	"Private - Answer the <Namespace> into which which we are defining a subclass."

	^namespacePresenter value!

namespace: aNamespace
	"Private - Set the <Namespace> into which which we are defining a subclass."

	namespacePresenter value: aNamespace!

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
	self namespace: bindingRef environment ?? Smalltalk.
	self subclassName: bindingRef unqualifiedName!

subclassName
	^namePresenter value!

subclassName: aString
	namePresenter value: aString!

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
	namespace := self namespace.
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
namespace!accessing!private! !
namespace:!accessing!private! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 25 793 578 731 71 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 140 1 0 0 121 1 0 0 175 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 610 1 1 410 #{UI.ContainerView} 34 15 nil 944 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 1048838 #{UI.FramingLayout} 170 176 34 18 410 #{UI.StaticText} 34 16 nil 1024 34 2 8 1140850944 1 1152 nil nil nil 7 nil nil nil 1152 nil 8 1809959840 1049094 #{UI.NullConverter} nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 5 578 201 41 1152 786 #text: 34 1 8 'New &class name:' 1152 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 100 0 0 0 22 0 0 0] 8 #() 928 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 1 1490 #fixedViewLeft 201 1490 #fixedParentTop 5 1490 #fixedViewTop 41 410 #{UI.TextEdit} 34 16 nil 1024 34 2 8 1140916352 1025 1568 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1568 nil 8 1809915648 1234 nil nil 5 738 34 2 786 #createAt:extent: 34 2 578 201 1 578 477 45 1568 786 #setMarginWidths: 34 1 8 #(3 3) 1568 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 0 0 0 0 82 1 0 0 22 0 0 0] 8 #() 928 nil 27 1458 1490 #fixedPreviousRight 1 1490 #fixedParentRight -53 1490 #fixedPreviousTop -3 1552 45 410 #{UI.TextEdit} 34 16 nil 1024 34 2 8 1140850816 262145 1952 nil nil nil 7 nil nil nil 1952 nil 8 1809915648 1234 nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 201 121 578 477 41 1952 786 #setMarginWidths: 34 1 8 #(3 3) 1952 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 60 0 0 0 82 1 0 0 80 0 0 0] 8 #() 928 nil 27 1458 1904 1 1920 -53 1936 -1 1552 41 410 #{UI.PushButton} 34 20 nil 1024 34 2 8 1140924416 1 2256 nil 1648 nil 7 nil nil nil 2256 nil 8 1809920128 1377606 4 #{UI.CommandDescription} #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 691 121 578 41 41 2256 786 #isEnabled: 8 #(false) 2256 786 #text: 34 1 8 '…' 2256 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 60 0 0 0 109 1 0 0 80 0 0 0] 8 #() 928 nil 29 1458 1904 15 1520 41 1936 1 1552 41 410 #{UI.StaticText} 34 16 nil 1024 34 2 8 1140850944 1 2624 nil nil nil 7 nil nil nil 2624 nil 8 1809959840 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 123 578 201 41 2624 786 #text: 34 1 8 '&Superclass:' 2624 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 61 0 0 0 100 0 0 0 81 0 0 0] 8 #() 928 nil 27 1458 1504 1 1520 201 1490 #fixedPreviousBottom 21 1552 41 410 #{UI.PushButton} 34 20 nil 1024 34 2 8 1140924416 1 2944 nil 1648 nil 7 nil nil nil 2944 nil 8 1809920128 2338 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 691 63 578 41 41 2944 786 #isEnabled: 8 #(false) 2944 786 #text: 34 1 8 '…' 2944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 1 0 0 31 0 0 0 109 1 0 0 51 0 0 0] 8 #() 928 nil 29 1458 1904 15 1520 41 1936 1 1552 41 410 #{UI.ContainerView} 34 15 nil 1024 34 2 8 1140850688 131073 3296 nil nil nil 7 nil nil nil 3296 1090 170 176 34 8 410 #{UI.CheckBox} 34 16 nil 3296 34 2 8 1409363203 1 3408 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 3408 nil 8 1809920128 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 361 37 578 111 45 3408 786 #text: 34 1 8 '&Bytes?' 3408 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 18 0 0 0 235 0 0 0 40 0 0 0] 8 #() 928 nil 27 1458 1904 1 1520 111 1936 1 1552 45 410 #{UI.GroupBox} 34 14 nil 3296 34 2 8 1140981767 1 3776 nil nil nil 7 nil nil nil 3776 nil 8 1809920128 738 34 2 786 #createAt:extent: 34 2 578 1 1 578 731 101 3776 786 #text: 34 1 8 'Attributes' 3776 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 50 0 0 0] 8 #() 928 nil 27 1458 1504 1 1920 1 1536 1 1490 #fixedParentBottom 1 410 #{UI.CheckBox} 34 16 nil 3296 34 2 8 1409363203 1 4080 3474 nil nil 3520 false nil nil 7 nil nil nil 4080 nil 8 1809920128 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 25 37 578 161 45 4080 786 #text: 34 1 8 '&Abstract?' 4080 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 18 0 0 0 92 0 0 0 40 0 0 0] 8 #() 928 nil 27 1458 1504 25 1520 161 1536 37 1552 45 410 #{UI.CheckBox} 34 16 nil 3296 34 2 8 1409363203 1 4400 3474 nil nil 3520 false nil nil 7 nil nil nil 4400 nil 8 1809920128 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 185 37 578 177 45 4400 786 #text: 34 1 8 '&Indexable?' 4400 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 0 0 0 18 0 0 0 180 0 0 0 40 0 0 0] 8 #() 928 nil 27 1458 1904 1 1520 177 1936 1 1552 45 170 192 34 6 3408 8 'isBytes' 4080 8 'isNonInstantiable' 4400 8 'isVariable' nil 738 34 1 786 #createAt:extent: 34 2 578 1 173 578 731 101 3296 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 86 0 0 0 109 1 0 0 136 0 0 0] 34 4 4080 4400 3408 3776 928 nil 27 1458 1504 1 1920 1 2928 13 1552 101 410 #{UI.TextEdit} 34 16 nil 1024 34 2 8 1140850816 262145 4960 nil 1648 nil 7 nil nil nil 4960 nil 8 1809915648 1234 nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 201 63 578 477 41 4960 786 #setMarginWidths: 34 1 8 #(3 3) 4960 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 31 0 0 0 82 1 0 0 51 0 0 0] 8 #() 928 nil 27 1458 1904 1 1920 -53 1936 -1 1552 41 410 #{UI.StaticText} 34 16 nil 1024 34 2 8 1140850944 1 5264 nil nil nil 7 nil nil nil 5264 nil 8 1809959840 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 65 578 201 41 5264 786 #text: 34 1 8 '&Namespace:' 5264 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 32 0 0 0 100 0 0 0 52 0 0 0] 8 #() 928 nil 27 1458 1504 1 1520 201 2928 21 1552 41 170 192 34 10 1568 8 'className' 1952 8 'superclass' 2944 8 'chooseNamespace' 3296 8 'attributes' 4960 8 'namespace' nil 738 34 1 786 #createAt:extent: 34 2 578 1 1 578 731 281 1024 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 140 0 0 0] 34 9 1152 1568 5264 4960 2944 2624 1952 2256 3296 928 nil 27 nil nil nil 410 #{UI.ContainerView} 34 15 nil 944 34 2 8 1140850688 131073 5824 nil nil nil 7 nil nil nil 5824 1376774 #{UI.ProportionalLayout} 170 176 912 false 170 192 912 1180166 #{Graphics.Rectangle} 578 1 7 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 281 578 731 489 5824 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 140 0 0 0 109 1 0 0 128 1 0 0] 34 1 410 #{UI.ContainerView} 34 15 nil 5824 34 2 8 1140850688 131073 6160 nil nil nil 23 nil nil nil 6160 610 1 1 410 #{UI.CheckBox} 34 16 nil 6160 34 2 8 1140924419 1 6240 3474 nil false 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 6354 #hash 8 #() false nil nil 7 nil nil nil 6240 nil 8 1809920128 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 -1 578 731 51 6240 786 #text: 34 1 8 '&Packaged?' 6240 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 109 1 0 0 24 0 0 0] 8 #() 928 nil 27 nil nil nil 410 #{UI.ReferenceView} 34 14 nil 6160 34 2 8 1140850688 131073 6656 nil nil nil 7 nil nil nil 6656 706 #{Tools.PackageSelector} #resource_Choice_view nil 738 34 1 786 #createAt:extent: 34 2 578 1 49 578 731 435 6656 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 109 1 0 0 241 0 0 0] 912 928 nil 27 170 192 34 2 6240 8 'setPackage' 5954 578 1 -1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 7 578 731 483 6160 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 109 1 0 0 244 0 0 0] 34 2 6240 6656 928 nil 27 928 nil 27 170 192 912 5954 578 1 1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 25 25 578 731 769 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 12 0 0 0 121 1 0 0 140 1 0 0] 34 2 1024 5824 928 nil 27 170 192 912 5954 578 25 25 578 25 21 nil nil nil nil 31795 nil nil nil 578 521 601 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 1999274064 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 811 961 416 786 #text: 34 1 8 'Create Class…' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 148 25 0 0 234 1 0 0] 34 2 944 640 928 nil 27)!

resource_Refactoring_view
	"Answer the literal data from which the 'Refactoring view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Refactoring_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 25 797 578 841 71 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 142 1 0 0 176 1 0 0 177 1 0 0] 8 #() 578 193 193 nil 27 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 944 nil nil nil 7 nil nil nil 944 610 1 1 410 #{UI.ContainerView} 34 15 nil 944 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 1048838 #{UI.FramingLayout} 170 176 34 18 410 #{UI.TextEdit} 34 16 nil 1024 34 2 8 1140850816 262145 1152 nil nil nil 7 nil nil nil 1152 nil 8 1809915648 1049094 #{UI.NullConverter} nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 201 115 578 587 41 1152 786 #setMarginWidths: 34 1 8 #(3 3) 1152 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 57 0 0 0 137 1 0 0 77 0 0 0] 8 #() 928 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedPreviousRight 1 1490 #fixedParentRight -53 1490 #fixedPreviousTop -1 1490 #fixedViewTop 41 410 #{UI.PushButton} 34 20 nil 1024 34 2 8 1140924416 1 1568 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 1568 nil 8 1809920128 1377606 4 #{UI.CommandDescription} #chooseSuperclass 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 801 115 578 41 41 1568 786 #isEnabled: 8 #(false) 1568 786 #text: 34 1 8 '…' 1568 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 57 0 0 0 164 1 0 0 77 0 0 0] 8 #() 928 nil 29 1458 1504 15 1490 #fixedViewLeft 41 1536 1 1552 41 410 #{UI.StaticText} 34 16 nil 1024 34 2 8 1140850944 1 1984 nil nil nil 7 nil nil nil 1984 nil 8 1809959840 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 117 578 201 45 1984 786 #text: 34 1 8 '&Superclass:' 1984 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 58 0 0 0 100 0 0 0 80 0 0 0] 8 #() 928 nil 27 1458 1490 #fixedParentLeft 1 1968 201 1490 #fixedPreviousBottom 17 1552 45 410 #{UI.ContainerView} 34 15 nil 1024 34 2 8 1140850688 131073 2320 nil nil nil 7 nil nil nil 2320 1090 170 176 34 8 410 #{UI.CheckBox} 34 16 nil 2320 34 2 8 1409363203 1 2432 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 7 nil nil nil 2432 nil 8 1809920128 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 185 37 578 177 45 2432 786 #text: 34 1 8 '&Indexable?' 2432 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 92 0 0 0 18 0 0 0 180 0 0 0 40 0 0 0] 8 #() 928 nil 27 1458 1504 1 1968 177 1536 1 1552 45 410 #{UI.CheckBox} 34 16 nil 2320 34 2 8 1409363203 1 2800 2498 nil nil 2544 false nil nil 7 nil nil nil 2800 nil 8 1809920128 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 361 37 578 111 45 2800 786 #text: 34 1 8 '&Bytes?' 2800 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 18 0 0 0 235 0 0 0 40 0 0 0] 8 #() 928 nil 27 1458 1504 1 1968 111 1536 1 1552 45 410 #{UI.CheckBox} 34 16 nil 2320 34 2 8 1409363203 1 3120 2498 nil nil 2544 false nil nil 7 nil nil nil 3120 nil 8 1809920128 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 25 37 578 161 45 3120 786 #text: 34 1 8 '&Abstract?' 3120 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 18 0 0 0 92 0 0 0 40 0 0 0] 8 #() 928 nil 27 1458 2288 25 1968 161 1490 #fixedParentTop 37 1552 45 410 #{UI.GroupBox} 34 14 nil 2320 34 2 8 1140981767 1 3456 nil nil nil 7 nil nil nil 3456 nil 8 1809920128 738 34 2 786 #createAt:extent: 34 2 578 1 1 578 841 101 3456 786 #text: 34 1 8 'Attributes' 3456 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 1 0 0 50 0 0 0] 8 #() 928 nil 27 1458 2288 1 1520 1 3440 1 1490 #fixedParentBottom 1 170 192 34 6 3120 8 'isNonInstantiable' 2432 8 'isVariable' 2800 8 'isBytes' nil 738 34 1 786 #createAt:extent: 34 2 578 1 167 578 841 101 2320 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 83 0 0 0 164 1 0 0 133 0 0 0] 34 4 3120 2432 2800 3456 928 nil 27 1458 2288 1 1520 1 2304 13 1552 101 410 #{UI.TextEdit} 34 16 nil 1024 34 2 8 1140850816 262145 4000 nil 1648 nil 7 nil nil nil 4000 nil 8 1809915648 1234 nil nil 7 738 34 2 786 #createAt:extent: 34 2 578 201 61 578 587 41 4000 786 #setMarginWidths: 34 1 8 #(3 3) 4000 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 30 0 0 0 137 1 0 0 50 0 0 0] 8 #() 928 nil 27 1458 1504 1 1520 -53 1536 1 1552 41 410 #{UI.TextEdit} 34 16 nil 1024 34 2 8 1140916352 1025 4304 nil 1648 nil 7 nil nil nil 4304 nil 8 1809915648 1234 nil nil 5 738 34 2 786 #createAt:extent: 34 2 578 201 1 578 587 45 4304 786 #setMarginWidths: 34 1 8 #(3 3) 4304 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 100 0 0 0 0 0 0 0 137 1 0 0 22 0 0 0] 8 #() 928 nil 27 1458 1504 1 1520 -53 1536 -3 1552 45 410 #{UI.StaticText} 34 16 nil 1024 34 2 8 1140850944 1 4608 nil nil nil 7 nil nil nil 4608 nil 8 1809959840 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 5 578 201 45 4608 786 #text: 34 1 8 'New &class name:' 4608 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 2 0 0 0 100 0 0 0 24 0 0 0] 8 #() 928 nil 27 1458 2288 1 1968 201 3440 5 1552 45 410 #{UI.PushButton} 34 20 nil 1024 34 2 8 1140924416 1 4912 nil 1648 nil 7 nil nil nil 4912 nil 8 1809920128 1682 #chooseNamespace 8 '…' 1 1 nil nil false nil nil nil 738 34 3 786 #createAt:extent: 34 2 578 801 61 578 41 41 4912 786 #isEnabled: 8 #(false) 4912 786 #text: 34 1 8 '…' 4912 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 144 1 0 0 30 0 0 0 164 1 0 0 50 0 0 0] 8 #() 928 nil 29 1458 1504 15 1968 41 1536 1 1552 41 410 #{UI.StaticText} 34 16 nil 1024 34 2 8 1140850944 1 5264 nil nil nil 7 nil nil nil 5264 nil 8 1809959840 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 61 578 201 45 5264 786 #text: 34 1 8 '&Namespace:' 5264 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 30 0 0 0 100 0 0 0 52 0 0 0] 8 #() 928 nil 27 1458 2288 1 1968 201 2304 17 1552 45 170 192 34 10 4304 8 'className' 1152 8 'superclass' 2320 8 'attributes' 4000 8 'namespace' 4912 8 'chooseNamespace' nil 738 34 1 786 #createAt:extent: 34 2 578 1 1 578 841 279 1024 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 164 1 0 0 139 0 0 0] 34 9 4608 4304 5264 4000 4912 1984 1152 1568 2320 928 nil 27 nil nil nil 410 #{UI.ContainerView} 34 15 nil 944 34 2 8 1140850688 131073 5824 nil nil nil 7 nil nil nil 5824 1376774 #{UI.ProportionalLayout} 170 176 912 false 170 192 34 2 410 #{UI.ListView} 34 45 nil 5824 34 2 8 1140953161 1025 5968 787270 2 #{UI.ListModel} 138 144 912 nil 1769478 #{Kernel.IdentitySearchPolicy} 1648 nil 7 nil nil nil 5968 nil 8 1809872048 786950 #{Core.Message} #displayString 8 #() 6130 #iconImageIndex 6160 1639750 1 #{Graphics.IconImageManager} nil nil nil 578 65 65 nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 'Subclasses' 409 #left 6144 6130 #<= 8 #() nil nil 5968 nil 3 nil nil #report 8 #() nil 133185 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 425 7 578 417 493 5968 786 #text: 34 1 8 'Subclasses' 5968 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 212 0 0 0 3 0 0 0 164 1 0 0 249 0 0 0] 8 #() 928 nil 35 8 'subclasses' 1180166 #{Graphics.Rectangle} 578 1 7 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 279 578 841 499 5824 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 164 1 0 0 132 1 0 0] 34 3 410 #{UI.ContainerView} 34 15 nil 5824 34 2 8 1140850688 131073 6784 nil nil nil 23 nil nil nil 6784 610 1 1 410 #{UI.CheckBox} 34 16 nil 6784 34 2 8 1140924419 1 6864 2498 nil false 1835526 #{Kernel.PluggableSearchPolicy} 6130 #= 8 #() 6130 #hash 8 #() false nil nil 7 nil nil nil 6864 nil 8 1809920128 1234 nil nil nil 738 34 2 786 #createAt:extent: 34 2 578 1 -1 578 415 51 6864 786 #text: 34 1 8 '&Packaged?' 6864 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 255 255 255 255 207 0 0 0 24 0 0 0] 8 #() 928 nil 27 nil nil nil 410 #{UI.ReferenceView} 34 14 nil 6784 34 2 8 1140850688 131073 7264 nil nil nil 7 nil nil nil 7264 706 #{Tools.PackageSelector} #resource_Choice_view nil 738 34 1 786 #createAt:extent: 34 2 578 1 49 578 415 445 7264 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 24 0 0 0 207 0 0 0 246 0 0 0] 912 928 nil 27 170 192 34 4 6864 8 'setPackage' 7264 8 'package' 6578 578 1 -1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 1 7 578 415 493 6784 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 3 0 0 0 207 0 0 0 249 0 0 0] 34 2 6864 7264 928 nil 27 410 #{UI.Splitter} 34 12 nil 5824 34 2 8 1140850688 1 7728 nil nil nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 7728 nil 1 #left nil nil nil 578 1 1 578 9 9 nil 7824 nil 738 34 1 786 #createAt:extent: 34 2 578 415 7 578 11 493 7728 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 207 0 0 0 3 0 0 0 212 0 0 0 249 0 0 0] 8 #() 928 nil 27 5968 928 nil 27 170 192 912 6578 578 1 1 578 1 1 738 34 1 786 #createAt:extent: 34 2 578 25 21 578 841 777 944 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 0 0 0 10 0 0 0 176 1 0 0 142 1 0 0] 34 2 1024 5824 928 nil 27 170 192 912 6578 578 25 21 578 25 17 nil nil nil nil 31527 nil nil nil 578 621 581 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 1999274064 738 34 2 786 #createAt:extent: 34 2 578 12287 21 578 921 961 416 786 #text: 34 1 8 'Create Class…' 416 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 203 25 0 0 234 1 0 0] 34 2 944 640 928 nil 27)!

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

