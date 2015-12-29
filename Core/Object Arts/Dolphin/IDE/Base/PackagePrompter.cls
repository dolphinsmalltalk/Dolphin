"Filed out from Dolphin Smalltalk X6"!

ValueDialog subclass: #PackagePrompter
	instanceVariableNames: 'packagesPresenter notPackagedPresenter defaultPackage validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackagePrompter guid: (GUID fromString: '{ED9A3D68-797C-4678-ADF9-520204C0023F}')!
PackagePrompter comment: 'self show'!
!PackagePrompter categoriesForClass!Development!MVP-Presenters! !
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
!PackagePrompter categoriesFor: #createComponents!initializing!public! !
!PackagePrompter categoriesFor: #createSchematicWiring!initializing!public! !
!PackagePrompter categoriesFor: #defaultPackage:!accessing!private! !
!PackagePrompter categoriesFor: #initialize!initializing!private! !
!PackagePrompter categoriesFor: #onPackageSelected!event handling!public! !
!PackagePrompter categoriesFor: #onViewOpened!event handling!public! !
!PackagePrompter categoriesFor: #queryCommand:!commands!private! !
!PackagePrompter categoriesFor: #toggleSetPackage!commands!public! !
!PackagePrompter categoriesFor: #validationBlock!accessing!public! !
!PackagePrompter categoriesFor: #validationBlock:!accessing!public! !

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 328198 ##(Smalltalk.Point)  501 701 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  21 17 410 8 ##(Smalltalk.CheckBox)  98 16 0 416 98 2 8 1140924419 1 576 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  32 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 576 0 8 4294903631 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 514 21 21 514 615 43 576 882 8 #text: 98 1 8 'Not packaged?' 576 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 61 1 0 0 31 0 0 0] 98 0 514 193 193 0 27 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140850688 131073 1120 0 0 0 7 0 0 0 1120 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.Presenter)  8 #resource_OK_Cancel_button_block 0 818 202 208 98 1 882 912 98 2 514 21 563 514 615 61 1120 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 25 1 0 0 61 1 0 0 55 1 0 0] 98 0 1104 0 27 0 0 410 1136 98 14 0 416 98 2 8 1140850688 131073 1424 0 0 0 7 0 0 0 1424 1202 8 ##(Smalltalk.PackageSelector)  8 #resource_Single_package_selector 0 818 202 208 98 1 882 912 98 2 514 21 79 514 615 469 1424 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 39 0 0 0 61 1 0 0 17 1 0 0] 1408 1104 0 27 234 256 98 4 1424 8 'packages' 576 8 'unpackaged' 590342 ##(Smalltalk.Rectangle)  514 21 21 514 21 21 0 0 0 0 38339 0 0 0 514 501 311 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 818 202 208 98 3 882 912 98 2 514 2799 21 514 671 711 416 882 992 98 1 8 'Choose Package...' 416 882 8 #updateMenuBar 1408 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 198 6 0 0 109 1 0 0] 98 3 1424 1120 576 1104 0 27 )!

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
!PackagePrompter class categoriesFor: #defaultValidationBlock!constants!public! !
!PackagePrompter class categoriesFor: #icon!accessing!constants!public! !
!PackagePrompter class categoriesFor: #resource_Default_view!public!resources-views! !
!PackagePrompter class categoriesFor: #showModalOn:caption:default:!instance creation!public! !
!PackagePrompter class categoriesFor: #showModalOn:caption:default:validationBlock:!instance creation!public! !

