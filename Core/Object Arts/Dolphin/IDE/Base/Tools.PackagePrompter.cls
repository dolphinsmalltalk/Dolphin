"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'Tools.PackagePrompter'
	instanceVariableNames: 'packagesPresenter notPackagedPresenter defaultPackage'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.PackagePrompter guid: (Core.GUID fromString: '{ed9a3d68-797c-4678-adf9-520204c0023f}')!

Tools.PackagePrompter comment: 'self show'!

!Tools.PackagePrompter categoriesForClass!MVP-Presenters! !

!Tools.PackagePrompter methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	packagesPresenter := self add: (PackageSelector new
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

model: aValueModel
	super model: aValueModel.
	self validater: 
			[:pkg |
			pkg isNil
				ifTrue: 
					[(ValidationResult errorMessage: 'Please select a package')
						caption: 'Incomplete Input';
						presenter: packagesPresenter;
						yourself]
				ifFalse: [ValidationResult new]]!

onPackageSelected
	self value: packagesPresenter selectionOrNil!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.
	packagesPresenter selectionOrNil: self model value!

toggleSetPackage
	notPackagedPresenter model value 
		ifFalse: 
			[self value: packagesPresenter selectionOrNil.
			packagesPresenter isEnabled: true]
		ifTrue: 
			[self value: defaultPackage.
			packagesPresenter isEnabled: false]!

validationResultPresenterClass
	^ValidationHintPresenter! !

!Tools.PackagePrompter categoriesForMethods!
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultPackage:!accessing!private! !
model:!accessing!public! !
onPackageSelected!event handling!public! !
onViewOpened!event handling!public! !
toggleSetPackage!commands!public! !
validationResultPresenterClass!constants!public! !
!

!Tools.PackagePrompter class methodsFor!

icon
	"Answers an Icon that can be used to represent this class."

	^SmalltalkSystem current icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog 518 #{Graphics.Point} 501 701 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 21 17 18 #{UI.CheckBox} 50 16 nil 32 50 2 8 1140924419 1 272 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 272 nil nil 518 #{UI.NullConverter} nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 10 0 0 0 53 1 0 0 31 0 0 0] 193 304 8 'Not packaged?' 272 3 8 #() 130 193 193 nil 27 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 434 50 1 482 #createWindow: 50 1 530 562 8 #[10 0 0 0 125 1 0 0 53 1 0 0 155 1 0 0] 193 688 8 '' 656 3 8 #() 130 193 193 nil 27 nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 912 nil nil nil 5 nil nil nil 912 722 #{Tools.PackageSelector} #resource_Single_package_selector nil 434 50 1 482 #createWindow: 50 1 530 562 8 #[10 0 0 0 39 0 0 0 53 1 0 0 117 1 0 0] 193 944 8 '' 912 3 880 130 193 193 nil 27 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 4 912 8 'packages' 272 8 'unpackaged' 518 #{Graphics.Rectangle} 130 21 21 130 21 21 nil nil nil nil 1 nil nil nil 130 501 311 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 434 50 2 482 #createWindow: 50 1 518 #{UI.CreateDialog} 1218 130 7679 21 130 8349 941 193 32 482 #setWindowText: 50 1 8 'Choose Package…' 32 1 50 3 912 656 272 130 193 193 nil 29)!

showModalOn: aModel caption: aString default: aPackage
	"Creates an instance of the receiver with a default view and connected to aModel and the
	specified caption <String>. The view is displayed modal to the current active window.
	Answers the result of dialog if confirmed or nil cancelled. The OK button in the dialog will
	only be enabled if there is a package selected other than the initial value."

	^(self createOn: aModel)
		defaultPackage: aPackage;
		caption: aString;
		showModal! !

!Tools.PackagePrompter class categoriesForMethods!
icon!accessing!constants!public! !
resource_Default_view!public!resources-views! !
showModalOn:caption:default:!instance creation!public! !
!

