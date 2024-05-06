"Filed out from Dolphin Smalltalk"!

ValueDialog subclass: #PackagePrompter
	instanceVariableNames: 'packagesPresenter notPackagedPresenter defaultPackage validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PackagePrompter guid: (GUID fromString: '{ed9a3d68-797c-4678-adf9-520204c0023f}')!

PackagePrompter comment: 'self show'!

!PackagePrompter categoriesForClass!MVP-Presenters! !

!PackagePrompter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	packagesPresenter := self add: ((PackageSelector new)
						autoSelect: false;
						yourself)
				name: 'packages'.
	notPackagedPresenter := self add: BooleanPresenter new name: 'unpackaged'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	packagesPresenter 
		when: #selectionChanged
		send: #onPackageSelected
		to: self.
	notPackagedPresenter 
		when: #valueChanged
		send: #toggleSetPackage
		to: self!

defaultPackage: aPackageOrNil 
	defaultPackage := aPackageOrNil ifNil: [Package uncommitted].
	notPackagedPresenter view text: ('<1p>?' expandMacrosWith: defaultPackage name)!

initialize
	"Private - Initialize the receiver"

	super initialize.
	validationBlock := self class defaultValidationBlock!

onPackageSelected
	self value: packagesPresenter selectionOrNil!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	packagesPresenter selectionOrNil: self model value!

queryCommand: query 
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| cmd |
	cmd := query commandSymbol.
	cmd == #ok 
		ifTrue: 
			[query isEnabled: (self validationBlock value: self value).
			^true].
	^super queryCommand: query!

toggleSetPackage
	notPackagedPresenter model value 
		ifFalse: 
			[self value: packagesPresenter selectionOrNil.
			packagesPresenter isEnabled: true]
		ifTrue: 
			[self value: defaultPackage.
			packagesPresenter isEnabled: false]!

validationBlock
	^validationBlock!

validationBlock: aBlock 
	"Set the <monadicValuable> used validate the current package selection. The valuable is
	passed the current package selection as its argument, and is expected to answer whether it
	is valid. The OK button is not enabled until the validationBlock answers true."

	validationBlock := aBlock! !

!PackagePrompter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultPackage:!accessing!private! !
initialize!initializing!private! !
onPackageSelected!event handling!public! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
toggleSetPackage!commands!public! !
validationBlock!accessing!public! !
validationBlock:!accessing!public! !
!

!PackagePrompter class methodsFor!

defaultValidationBlock
	^[:package | package notNil]!

icon
	"Answers an Icon that can be used to represent this class."

	^Smalltalk developmentSystem icon
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog 328198 ##(Smalltalk.Point) 501 701 133 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 21 17 410 ##(Smalltalk.CheckBox) 34 16 nil 416 34 2 8 1140924419 1 656 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 656 nil 8 1915188384 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 498 21 21 498 599 43 656 898 #text: 34 1 8 'Not packaged?' 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 53 1 0 0 31 0 0 0] 8 #() 498 193 193 nil 27 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1104 nil nil nil 5 nil nil nil 1104 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 834 138 144 34 1 898 #createAt:extent: 34 2 498 21 763 498 599 61 1104 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 125 1 0 0 53 1 0 0 155 1 0 0] 8 #() 1088 nil 27 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 1360 nil nil nil 5 nil nil nil 1360 1170 ##(Smalltalk.PackageSelector) #resource_Single_package_selector nil 834 138 144 34 1 898 #createAt:extent: 34 2 498 21 79 498 599 669 1360 1026 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 39 0 0 0 53 1 0 0 117 1 0 0] 1344 1088 nil 27 170 192 34 4 656 8 'unpackaged' 1360 8 'packages' 590342 ##(Smalltalk.Rectangle) 498 21 21 498 21 21 nil nil nil nil 12357 nil nil nil 498 501 311 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011052416 834 138 144 34 3 898 #createAt:extent: 34 2 498 1585 621 498 671 921 416 898 #text: 34 1 8 'Choose Package...' 416 898 #updateMenuBar 1344 416 1026 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 24 3 0 0 54 1 0 0 103 4 0 0 2 3 0 0] 34 3 1360 1104 656 1088 nil 27 )!

showModalOn: aModel caption: aString default: aPackage 
	"Creates an instance of the receiver with a default view and connected to aModel and the
	specified caption <String>. The view is displayed modal to the current active window.
	Answers the result of dialog if confirmed or nil cancelled. The OK button in the dialog will
	only be enabled if there is a package selected other than the initial value."

	^self 
		showModalOn: aModel
		caption: aString
		default: aPackage
		validationBlock: self defaultValidationBlock!

showModalOn: aModel caption: aString default: aPackage validationBlock: aBlock 
	"Creates an instance of the receiver with a default view and connected to aModel and the
	specified caption <String>. The view is displayed modal to the current active window.
	Answers the result of dialog if confirmed or nil cancelled. The OK button in the dialog will
	only be enabled when the <monadicValuable>, aBlock, evaluates to true when passed the
	current package selection."

	^(self createOn: aModel)
		defaultPackage: aPackage;
		caption: aString;
		validationBlock: aBlock;
		showModal! !

!PackagePrompter class categoriesForMethods!
defaultValidationBlock!constants!public! !
icon!accessing!constants!public! !
resource_Default_view!public!resources-views! !
showModalOn:caption:default:!instance creation!public! !
showModalOn:caption:default:validationBlock:!instance creation!public! !
!

