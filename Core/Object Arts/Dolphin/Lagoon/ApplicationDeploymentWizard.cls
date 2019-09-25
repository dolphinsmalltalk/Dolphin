"Filed out from Dolphin Smalltalk 7"!

ValueDialog subclass: #ApplicationDeploymentWizard
	instanceVariableNames: 'imageStripperClass executableName executablePath1 executablePath2 rootPackage runtimeSessionManagerClass stripRedundantMethods stripDeprecatedMethods stripShouldNotImplement stripRedundantPackages stripRedundantClasses preserveAspectSetters stripDuplicateStrings stripDuplicateBytecodes stripClassInfo retainInstVarNames stripClassGuids stripClassBuilder unused stripRedundantResources compileExternalStructures writeLogFile preStripScriptWorkspace preStripScriptErrors logFileName logReferencesToClasses stepsView isToGo stripSubclassResponsibility'
	classVariableNames: 'SaveImageOnDeploy'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ApplicationDeploymentWizard guid: (GUID fromString: '{87b4c6a1-026e-11d3-9fd7-00a0cc3e4a32}')!
ApplicationDeploymentWizard comment: 'ApplicationDeploymentWizard is a <dialogPresenter> used to edit the contents of an <ImageStripper> model.

Instance Variables:
	executableName		<TextPresenter> for the #executableName aspect
	rootPackage		<TextPresenter> for the #rootPackage aspect
	runtimeSessionManagerClass	<ChoicePresenter> for the #runtimeSessionManagerClass aspect
	stripRedundantMethods	<BooleanPresenter> for the #stripRedundantMethods aspect
	stripDeprecatedMethods	<BooleanPresenter> for the #stripDeprecatedMethods aspect
	stripShouldNotImplement	<BooleanPresenter> for the #stripShouldNotImplement aspect
	stripRedundantClasses	<BooleanPresenter> for the #stripRedundantClasses aspect
	preserveAspectSetters	<BooleanPresenter> for the #preserveAspectSetters aspect
	stripDuplicateStrings	<BooleanPresenter> for the #stripDuplicateStrings aspect
	stripDuplicateBytecodes	<BooleanPresenter> for the #stripDuplicateBytecodes aspect
	stripClassInfo		<BooleanPresenter> for the #stripClassInfo aspect
	retainInstVarNames		<BooleanPresenter> for the #retainInstVarNames aspect
	stripClassGuids		<BooleanPresenter> for the #stripClassGuids aspect
	stripClassBuilder		<BooleanPresenter> for the #stripClassBuilder aspect
	stripEmptyMethodDictionaries	<BooleanPresenter> for the #stripEmptyMethodDictionaries aspect
	stripRedundantResources	<BooleanPresenter> for the #stripRedundantResources aspect
	compileExternalStructures	<BooleanPresenter> for the #compileExternalStructures aspect
	writeLogFile		<BooleanPresenter> for the #writeLogFile aspect
	executablePath		<TextPresenter> for the #executablePath aspect
	preStripScript		<TextPresenter> for the #preStripScript aspect

Class Variables:
	SystemIcon		<UndefinedObject>

'!
!ApplicationDeploymentWizard categoriesForClass!MVP-Presenters! !
!ApplicationDeploymentWizard methodsFor!

accept
	"Accept any changes and perform a test compilation"

	preStripScriptWorkspace compileAll.
	self value preStripScript: preStripScriptWorkspace plainText
!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next."

	"Implementation Note: We want to make sure that the Steps card view and the image stripper
	are always in the route"

	route
		appendTarget: stepsView;
		appendTarget: self model value;
		appendPresenter: self!

apply
	"Apply the changes cached in the receiver back to the original model. "
	
	self accept.
	super apply.!

browseForExecutableName
	"Browse for the name of the executable to create"

	| filename defaultExtension |
	defaultExtension := self defaultExtension.
	filename := executableName value.
	(filename isEmpty and: [rootPackage value notNil])
		ifTrue: 
			["Suggest a sensible default name"
			defaultExtension := self value exeFileExtension.
			filename := File path: rootPackage value packageFileName extension: defaultExtension].
	filename := (FileSaveDialog on: filename)
				fileTypes: (self exeFileTypes copyWith: FileDialog allFilesType);
				defaultExtension: defaultExtension;
				caption: 'Choose target';
				showModal.
	filename notNil ifTrue: [executableName value: filename]!

canDeploy
	"Answer true if the receiver can currently deploy"

	| stripper |
	stripper := self value.
	^stripper rootPackage notNil and: [stripper canDeploy]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	executableName := self add: TextPresenter new name: 'executableName'.
	executablePath1 := self add: TextPresenter new name: 'executablePath1'.
	executablePath2 := self add: TextPresenter new name: 'executablePath2'.
	rootPackage := self add: TextPresenter new name: 'rootPackage'.
	preStripScriptWorkspace := self add: Smalltalk developmentSystem workspaceClass new
				name: 'preStripScript'.
	preStripScriptErrors := self add: ValuePresenter new name: 'preStripScriptErrors'.
	imageStripperClass := self add: ChoicePresenter new name: 'imageStripperClass'.
	imageStripperClass choices: ImageStripper withAllSubclasses.
	runtimeSessionManagerClass := self add: ChoicePresenter new name: 'runtimeSessionManagerClass'.
	isToGo := self add: BooleanPresenter new name: 'isToGo'.
	stripRedundantPackages := self add: BooleanPresenter new name: 'stripRedundantPackages'.
	stripRedundantClasses := self add: BooleanPresenter new name: 'stripRedundantClasses'.
	stripDeprecatedMethods := self add: BooleanPresenter new name: 'stripDeprecatedMethods'.
	stripShouldNotImplement := self add: BooleanPresenter new name: 'stripShouldNotImplement'.
	stripSubclassResponsibility := self add: BooleanPresenter new name: 'stripSubclassResponsibility'.
	stripRedundantMethods := self add: BooleanPresenter new name: 'stripRedundantMethods'.
	preserveAspectSetters := self add: BooleanPresenter new name: 'preserveAspectSetters'.
	stripDuplicateStrings := self add: BooleanPresenter new name: 'stripDuplicateStrings'.
	stripDuplicateBytecodes := self add: BooleanPresenter new name: 'stripDuplicateBytecodes'.
	compileExternalStructures := self add: BooleanPresenter new name: 'compileExternalStructures'.
	stripClassInfo := self add: BooleanPresenter new name: 'stripClassInfo'.
	retainInstVarNames := self add: BooleanPresenter new name: 'retainInstVarNames'.
	stripClassGuids := self add: BooleanPresenter new name: 'stripClassGuids'.
	stripClassBuilder := self add: BooleanPresenter new name: 'stripClassBuilder'.
	stripRedundantResources := self add: BooleanPresenter new name: 'stripRedundantResources'.
	writeLogFile := self add: BooleanPresenter new name: 'writeLogFile'.
	logFileName := self add: TextPresenter new name: 'logFileName'.
	logReferencesToClasses := self add: BooleanPresenter new name: 'logReferencesToClasses'!

createSchematicWiring
	"Create the trigger wiring for the receiver"
	
	super createSchematicWiring.
	imageStripperClass when: #valueChanged send: #onImageStripperClassChanged to: self.
	executableName when: #valueChanged send: #onExecutableNameChanged to: self.
	preStripScriptWorkspace when: #valueChanged send: #onPreStripScriptChanged to: self.

!

defaultExtension
	"Private - Answer the default extension to use for the executable file"

	^runtimeSessionManagerClass value imageExtension!

deployApplication
	"Strips the image according to the receiver's model and deploys it to an executable file.
	The development system will exit following this action"

	"Apply the current changes and save/strip the image"

	self ok.
	SessionManager inputState queueDeferredAction: [self strip]!

exeFileTypes
	"Private - Answer an <Array> two element Arrays suitable for adding to a FileDialog
	with the fileTypes: message to display executable files."

	^#(('DLLs (*.dll)' '*.dll')
		('Executable Files (*.exe)' '*.exe'))!

hasExistingLog
	"Answer true if the receiver has an existing log file"

	^self hasLog and: [ File exists: logFileName value ]!

hasLog
	"Answer true if the receiver currently has a log file selected"

	^self canDeploy & writeLogFile value!

help
	"Bring up a help page for this tool."

	SmalltalkSystem current openHelpTopicForTool: self!

model: anImageStripperValueModel
	"Connects the receiver to anImageStripperValueModel"

	super model: anImageStripperValueModel.
	self model when: #valueChanged send: #refreshContents to: self.
	self value: self value copy.
	!

onExecutableNameChanged
	"Private - The executable name has been changed. Update the executablePath field to show the full
	path of this"

	executablePath1 model notifyChanged.
	executablePath2 model notifyChanged.
	logFileName model notifyChanged.
!

onImageStripperClassChanged
	"Private - The image stripper class has been changed. Update the model with a new instance of this class"

	"See if there is an appropriate session manager subclass in the package"

	| newStripper package |
	package := rootPackage value.
	newStripper := (imageStripperClass value new)
				rootPackage: package;
				yourself.
	self value: newStripper!

onViewOpened
	"Received when the receiver's view has been connected."

	super onViewOpened.

	"Locate the card view containing the steps. We need to cache this to add it
	to the command routing in #addToCommandRoute:."
	stepsView := self view viewNamed: 'Steps'.

	"Normally the user interface is validated after the view is shown. However, since we use
	#validateUserInterface to control the visibility of some views it's better to preempt this
	here."
	self validateUserInterface.
	self onExecutableNameChanged.

	"If deployable, make Deploy the default button"
	self canDeploy ifTrue: [(self view viewNamed: 'deploy') isDefault: true]!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>,  query."

	| command |
	command := query commandSymbol.
	command == #deployApplication
		ifTrue: 
			[query isEnabled: self canDeploy.
			^true].
	command == #showLog
		ifTrue: 
			[query isEnabled: self hasExistingLog.
			^true].
	^super queryCommand: query!

refreshContents
	"Private - Connects the receiver to an ImageStripper held in it's value model"

	| aspectBuffer |
	super onValueChanged.
	aspectBuffer := self value.
	executableName model: (aspectBuffer aspectValue: #executableName).
	executablePath1 model: (aspectBuffer aspectValue: #executablePath).
	executablePath2 model: executablePath1 model.
	rootPackage model: (aspectBuffer aspectValue: #rootPackage).
	imageStripperClass value: self value class.
	runtimeSessionManagerClass choices: self sessionManagerOrShellChoices.
	runtimeSessionManagerClass model: (aspectBuffer aspectValue: #runtimeSessionManagerClass).
	isToGo model: (aspectBuffer aspectValue: #isToGo).
	stripRedundantPackages model: (aspectBuffer aspectValue: #stripRedundantPackages).
	stripRedundantClasses model: (aspectBuffer aspectValue: #stripRedundantClasses).
	stripRedundantMethods model: (aspectBuffer aspectValue: #stripRedundantMethods).
	stripDeprecatedMethods model: (aspectBuffer aspectValue: #stripDeprecatedMethods).
	stripShouldNotImplement model: (aspectBuffer aspectValue: #stripShouldNotImplement).
	stripSubclassResponsibility model: (aspectBuffer aspectValue: #stripSubclassResponsibility).
	preserveAspectSetters model: (aspectBuffer aspectValue: #preserveAspectSetters).
	stripDuplicateStrings model: (aspectBuffer aspectValue: #stripDuplicateStrings).
	stripDuplicateBytecodes model: (aspectBuffer aspectValue: #stripDuplicateBytecodes).
	stripClassInfo model: (aspectBuffer aspectValue: #stripClassInfo).
	retainInstVarNames model: (aspectBuffer aspectValue: #retainInstVarNames).
	stripClassGuids model: (aspectBuffer aspectValue: #stripClassGuids).
	stripClassBuilder model: (aspectBuffer aspectValue: #stripClassBuilder).
	stripRedundantResources model: (aspectBuffer aspectValue: #stripRedundantResources).
	compileExternalStructures model: (aspectBuffer aspectValue: #compileExternalStructures).
	writeLogFile model: (aspectBuffer aspectValue: #writeLogFile).
	logFileName model: (aspectBuffer aspectValue: #logFileName).
	logReferencesToClasses model: (aspectBuffer aspectValue: #logReferencesToClasses).

	"Assign the pre-strip script. We want to silently compile the script to display errors using the
	standard syntax colouring mechanism. Unfortunately, due to the anomalous nature of SmalltalkWorkpace
	(which doesn't have a real model connection) we can't access the contents of the script until
	the view has been opened. At this point (when the receiver is starting up) the view is not yet
	present so we must queue the compilation as a deferred action. Horrid!!"
	preStripScriptWorkspace errorModel: preStripScriptErrors model.
	preStripScriptWorkspace evaluationContext: self value.
	
	[preStripScriptWorkspace text: self value preStripScript.
	preStripScriptWorkspace compileAll] 
			postToMessageQueue!

reset
	(MessageBox 
		confirm: 'All deployment options will be reset to their defaults and any current settings will be lost.

Are you sure you would like to continue?') 
			ifFalse: [^self].
	self value: ((ImageStripper new)
				rootPackage: self value rootPackage;
				stripRedundantClasses: true;
				yourself)!

sessionManagerOrShellChoices
	| rootPackageAllClasses |
	rootPackageAllClasses := (self model aspectValue: #rootPackage) value classes.
	^(rootPackageAllClasses select: [:each | each respondsTo: #installNew]) asSortedCollection!

showLog
	"displays the exsiting log sile written by a previous invocation of the receiver"

	EnvironmentBrowserShell show browseExecutableManifestFile: logFileName value!

strip
	"Private - Strips the image according to the receiver's image stripper
	and deploys it to an executable file. The development system will exit 
	following this action"

	self class saveImageOnDeploy ifTrue: [Smalltalk developmentSystem saveImage].
	self value deploy!

validateUserInterface
	"Set the state of the receiver accordingly. This method is sent at judicious times
	in an attempt to ensure that the receivers state is up to date. "

	| hasRootPackage stripInfo |

	super validateUserInterface.

	"Check for root package"
	hasRootPackage := self value rootPackage notNil.
	stripRedundantClasses view isEnabled: hasRootPackage.
	stripRedundantPackages view isEnabled: hasRootPackage.
	stripRedundantResources view isEnabled: stripRedundantClasses value.
	hasRootPackage ifFalse: [ 
		stripRedundantPackages value: false.
		stripRedundantClasses value: false ].

	"When we are able to deploy show the executable file on the first page"
	executablePath1 view isWindowVisible: self canDeploy.
	logFileName view isWindowVisible: self hasLog.

	"The preserve aspect setters option is only available if we are removing methods"
	preserveAspectSetters view isEnabled: stripRedundantMethods value.

	stripInfo := stripClassInfo value.
	retainInstVarNames view isEnabled: stripInfo.
	stripClassGuids view isEnabled: stripInfo.

	! !
!ApplicationDeploymentWizard categoriesFor: #accept!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #addToCommandRoute:!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #apply!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #browseForExecutableName!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #canDeploy!public!testing! !
!ApplicationDeploymentWizard categoriesFor: #createComponents!initializing!public! !
!ApplicationDeploymentWizard categoriesFor: #createSchematicWiring!initializing!public! !
!ApplicationDeploymentWizard categoriesFor: #defaultExtension!constants!private! !
!ApplicationDeploymentWizard categoriesFor: #deployApplication!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #exeFileTypes!constants!private! !
!ApplicationDeploymentWizard categoriesFor: #hasExistingLog!public!testing! !
!ApplicationDeploymentWizard categoriesFor: #hasLog!public!testing! !
!ApplicationDeploymentWizard categoriesFor: #help!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #model:!accessing!public! !
!ApplicationDeploymentWizard categoriesFor: #onExecutableNameChanged!event handling!private! !
!ApplicationDeploymentWizard categoriesFor: #onImageStripperClassChanged!event handling!private! !
!ApplicationDeploymentWizard categoriesFor: #onViewOpened!event handling!public! !
!ApplicationDeploymentWizard categoriesFor: #queryCommand:!commands!private! !
!ApplicationDeploymentWizard categoriesFor: #refreshContents!accessing!private! !
!ApplicationDeploymentWizard categoriesFor: #reset!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #sessionManagerOrShellChoices!accessing!private! !
!ApplicationDeploymentWizard categoriesFor: #showLog!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #strip!commands!private! !
!ApplicationDeploymentWizard categoriesFor: #validateUserInterface!operations!public! !

!ApplicationDeploymentWizard class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators , #(#(#help 'F1'))!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ImageStripper new asValue!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Lagoon Deployment Wizard'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver.

		self initialize.
	"

	SaveImageOnDeploy := true.
	Smalltalk developmentSystem registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published the receiver."

	^super publishedAspects
		add: (Aspect boolean: #saveImageOnDeploy);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 37 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 15 1 31 86 135 1] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 768 nil 8 1903885040 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 685 13 578 241 49 768 994 #isEnabled: 8 #(false) 768 994 #text: 34 1 8 '&Save Configuration' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 11 1266 #fixedViewLeft 241 1266 #fixedParentTop 1 1266 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1344 nil 848 nil 7 nil nil nil 1344 nil 8 1903885040 882 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 217 13 578 131 49 1344 994 #isEnabled: 8 #(false) 1344 994 #text: 34 1 8 '< &Back' 1344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1296 131 1312 1 1328 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1760 nil 848 nil 7 nil nil nil 1760 nil 8 1903885040 882 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 955 13 578 139 49 1760 994 #text: 34 1 8 'Cancel' 1760 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedViewRight -137 1266 #fixedParentRight -11 1312 1 1328 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2128 nil 848 nil 7 nil nil nil 2128 nil 8 1903885040 882 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 19 13 578 139 49 2128 994 #isEnabled: 8 #(false) 2128 994 #text: 34 1 8 '&Deploy' 2128 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedParentLeft 9 1296 139 1312 1 1328 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2512 nil 848 nil 7 nil nil nil 2512 nil 8 1903885040 882 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 545 13 578 131 49 2512 994 #isEnabled: 8 #(false) 2512 994 #text: 34 1 8 '&Reset' 2512 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 2096 -129 2112 -429 1312 1 1328 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2880 nil 848 nil 7 nil nil nil 2880 nil 8 1903885040 882 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 357 13 578 131 49 2880 994 #isEnabled: 8 #(false) 2880 994 #text: 34 1 8 '&Next >' 2880 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1280 11 1296 131 1312 1 1328 49 170 192 34 2 2128 8 'deploy' 590342 ##(Smalltalk.Rectangle) 578 11 13 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 723 578 1119 81 640 994 #text: 34 1 8 'Buttons' 640 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 2128 1344 2880 2512 768 1760 1216 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3568 nil nil nil 7 nil nil nil 3568 655878 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 3728 nil nil nil 5 nil nil nil 3728 706 170 176 34 28 410 ##(Smalltalk.TextEdit) 34 16 nil 3728 34 2 8 1140850688 262145 3840 nil nil nil 5 nil nil nil 3840 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 1 930 138 144 34 2 994 #createAt:extent: 34 2 578 441 597 578 565 41 3840 994 #isEnabled: 8 #(false) 3840 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 2496 441 2112 -109 1312 597 1328 41 410 ##(Smalltalk.ComboBox) 34 17 nil 3728 34 2 8 1144063491 1025 4160 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 848 nil 5 nil nil nil 4160 nil 8 1903738896 ##(Smalltalk.BasicListAbstract) 4272 401 930 138 144 34 1 994 #createAt:extent: 34 2 578 441 399 578 565 43 4160 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 199 0 0 0 246 1 0 0 220 0 0 0] 8 #() 1216 nil 27 1234 2496 441 2112 -109 1312 399 1328 43 410 ##(Smalltalk.ContainerView) 34 15 nil 3728 34 2 8 1140850688 131073 4512 nil 848 nil 5 nil nil nil 4512 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 4512 34 2 8 1140850944 1 4592 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4722 #hash 8 #() 657478 3 ##(Smalltalk.OLEPicture) nil true 1703942 ##(Smalltalk.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 524806 ##(Smalltalk.IPicture) nil nil 578 321 327 578 8467 8627 834 #face3d nil 5 nil nil nil 4592 nil 8 4294902547 3922 nil nil nil 4816 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 4592 994 #text: 34 1 8 'Graphic' 4592 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 4512 34 2 8 1140855108 1 5248 nil 848 nil 5 nil nil nil 5248 nil 8 1363032592 3922 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 5248 994 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 2: \par
\f1\fs16\par
Choose an Executable File and RuntimeSessionManager\b0\par
\par
\par
\par
}
' 5248 994 #textLimit: 8 #(1073741823) 5248 994 #resetCharFormat 4272 5248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4272 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 4512 994 #text: 34 1 8 'Heading' 4512 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 5248 4592 1216 nil 27 1234 2496 1 2112 1 1312 1 1328 121 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 5968 nil nil nil 5 nil nil nil 5968 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 43 387 578 381 81 5968 994 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 5968 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 193 0 0 0 211 0 0 0 233 0 0 0] 8 #() 1216 nil 27 1234 2496 43 1296 381 1312 387 1328 81 410 ##(Smalltalk.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 6288 nil 848 nil 5 nil nil nil 6288 nil 8 1903885040 882 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 1025 151 578 49 41 6288 994 #isEnabled: 8 #(false) 6288 994 #text: 34 1 8 '...' 6288 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1216 nil 29 1234 2096 -47 2112 -41 1312 151 1328 41 410 ##(Smalltalk.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 6656 4658 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 6656 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 211 578 431 81 6656 994 #text: 34 1 8 'Create single file, "To Go" distributable.' 6656 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1216 nil 27 1234 2496 31 1296 431 1312 211 1328 81 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 7024 nil nil nil 5 nil nil nil 7024 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 141 578 389 81 7024 994 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 7024 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 8 #() 1216 nil 27 1234 2496 31 1296 389 1312 141 1328 81 410 ##(Smalltalk.TextEdit) 34 16 nil 3728 34 2 8 1140916352 1025 7344 nil 848 nil 5 nil nil nil 7344 nil 8 1903872368 3922 nil nil 1 930 138 144 34 1 994 #createAt:extent: 34 2 578 431 151 578 575 41 7344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1216 nil 27 1234 2496 431 2112 -109 1312 151 1328 41 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 7616 nil nil nil 5 nil nil nil 7616 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 309 578 975 71 7616 994 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 7616 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 1216 nil 27 1234 2496 31 2112 -109 1312 309 1328 71 410 ##(Smalltalk.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 7936 nil 848 nil 5 nil nil nil 7936 nil 8 1903885040 882 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 441 661 578 139 45 7936 994 #isEnabled: 8 #(false) 7936 994 #text: 34 1 8 'S&how it' 7936 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1216 nil 29 1234 2496 441 1296 139 1312 661 1328 45 410 ##(Smalltalk.GroupBox) 34 14 nil 3728 34 2 8 1140850695 65 8304 nil 848 nil 5 nil nil nil 8304 nil 8 1903885040 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 279 578 1155 211 8304 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 244 0 0 0] 8 #() 1216 nil 27 1234 2496 1 2112 41 1312 279 1328 211 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 8560 nil nil nil 5 nil nil nil 8560 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 499 578 1045 81 8560 994 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 8560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 249 0 0 0 25 2 0 0 33 1 0 0] 8 #() 1216 nil 27 1234 2496 31 2112 -39 1312 499 1328 81 410 ##(Smalltalk.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 8880 4658 nil nil 6752 true nil nil 5 nil nil nil 8880 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 597 578 251 41 8880 994 #text: 34 1 8 'Write &log file' 8880 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 2496 61 1296 251 1312 597 1328 41 410 ##(Smalltalk.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 9216 4658 nil nil 6752 true nil nil 5 nil nil nil 9216 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 661 578 251 41 9216 994 #text: 34 1 8 'Log &class references' 9216 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1216 nil 27 1234 2496 61 1296 251 1312 661 1328 41 170 192 34 14 9216 8 'logReferencesToClasses' 4160 8 'runtimeSessionManagerClass' 6656 8 'isToGo' 8880 8 'writeLogFile' 3840 8 'logFileName' 7344 8 'executableName' 7936 8 'showLog' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 3728 994 #text: 34 1 8 'Step 2' 3728 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 4512 7024 7344 6288 6656 7616 5968 4160 8560 8880 9216 3840 7936 8304 1216 nil 27 3698 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 9920 nil nil nil 5 nil nil nil 9920 706 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 9920 34 2 8 1140850944 1 10032 nil nil nil 5 nil nil nil 10032 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 499 578 979 109 10032 994 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10032 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -107 1312 499 1328 109 410 ##(Smalltalk.ContainerView) 34 15 nil 9920 34 2 8 1140850688 131073 10352 nil 848 nil 5 nil nil nil 10352 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 10352 34 2 8 1140850944 1 10432 4658 nil false 4690 4722 #= 8 #() 4722 #hash 4784 4802 nil true 4848 8 'Resources\LagoonLogo.bmp' 4896 4930 nil nil 578 321 327 578 8467 8627 4992 nil 5 nil nil nil 10432 nil 8 4294902547 3922 nil nil nil 10576 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 10432 994 #text: 34 1 8 'Graphic' 10432 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 10352 34 2 8 1140855108 1 10896 nil 848 nil 5 nil nil nil 10896 nil 8 1363032592 3922 nil nil 41 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 10896 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 3:\f1\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\par
\b0\par
\par
\par
}
' 10896 994 #textLimit: 8 #(1073741823) 10896 994 #resetCharFormat 4272 10896 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4272 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 10352 994 #text: 34 1 8 'Heading' 10352 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 10896 10432 1216 nil 27 1234 2496 1 2112 1 1312 1 1328 121 410 ##(Smalltalk.CheckBox) 34 16 nil 9920 34 2 8 1140924451 1 11584 4658 nil nil 6752 true nil nil 5 nil nil nil 11584 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 59 599 578 329 49 11584 994 #text: 34 1 8 'Remove redundant &packages' 11584 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 8 #() 1216 nil 27 1234 2496 59 1296 329 1312 599 1328 49 410 ##(Smalltalk.StaticText) 34 16 nil 9920 34 2 8 1140850944 1 11920 nil nil nil 5 nil nil nil 11920 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 171 578 975 191 11920 994 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 11920 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1216 nil 27 1234 2496 31 2112 -109 1312 171 1328 191 410 ##(Smalltalk.StaticText) 34 16 nil 9920 34 2 8 1140850944 1 12240 nil nil nil 5 nil nil nil 12240 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 389 578 201 41 12240 994 #text: 34 1 8 'Root package:' 12240 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1216 nil 27 1234 2496 81 1296 201 1312 389 1328 41 410 ##(Smalltalk.StaticText) 34 16 nil 9920 34 2 8 1140850944 262145 12560 nil nil nil 5 nil nil nil 12560 nil 8 1903849936 3922 nil nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 361 389 578 647 41 12560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1216 nil 27 1234 2496 361 2112 -107 1312 389 1328 41 170 192 34 4 12560 8 'rootPackage' 11584 8 'stripRedundantPackages' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 9920 994 #text: 34 1 8 'Step 3' 9920 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 10352 11920 12240 12560 10032 11584 1216 nil 27 3698 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 13120 nil nil nil 5 nil nil nil 13120 706 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 nil 13120 34 2 8 1140924451 1 13232 4658 nil nil 6752 false nil nil 5 nil nil nil 13232 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 645 578 441 49 13232 994 #text: 34 1 8 'Remove #&subclassResponsibility methods' 13232 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 1216 nil 27 1234 2496 61 1296 441 1266 #fixedPreviousBottom 17 1328 49 410 ##(Smalltalk.StaticText) 34 16 nil 13120 34 2 8 1140850944 1 13584 nil nil nil 5 nil nil nil 13584 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 533 578 1079 49 13584 994 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 13584 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -7 13568 51 1328 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13120 34 2 8 1140924451 1 13904 4658 nil nil 6752 false nil nil 5 nil nil nil 13904 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 581 578 441 49 13904 994 #text: 34 1 8 'Remove #&deprecated methods' 13904 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 1216 nil 27 1234 2496 61 1296 441 13568 1 1328 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13120 34 2 8 1140924451 1 14240 4658 nil nil 6752 false nil nil 5 nil nil nil 14240 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 435 578 441 49 14240 994 #text: 34 1 8 'Remove redundant &methods' 14240 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 1216 nil 27 1234 2496 61 1296 441 13568 1 1328 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13120 34 2 8 1140924451 1 14576 4658 nil nil 6752 true nil nil 5 nil nil nil 14576 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 217 578 423 49 14576 994 #text: 34 1 8 'Remove redundant &resources' 14576 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1216 nil 27 1234 1280 121 1296 423 1266 #fixedPreviousTop 1 1328 49 410 ##(Smalltalk.StaticText) 34 16 nil 13120 34 2 8 1140850944 1 14928 nil nil nil 5 nil nil nil 14928 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 315 578 1019 121 14928 994 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 14928 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -67 13568 51 1328 121 410 ##(Smalltalk.GroupBox) 34 14 nil 13120 34 2 8 1140850695 65 15248 nil 848 nil 5 nil nil nil 15248 nil 8 1903885040 930 138 144 34 1 994 #createAt:extent: 34 2 578 -17 281 578 1151 229 15248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1216 nil 27 1234 2496 -17 2112 19 1312 281 1328 229 410 ##(Smalltalk.CheckBox) 34 16 nil 13120 34 2 8 1140924451 1 15504 4658 nil nil 6752 false nil nil 5 nil nil nil 15504 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 435 578 423 49 15504 994 #text: 34 1 8 'Preserve &aspect set methods' 15504 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1216 nil 27 1234 1280 121 1296 423 14912 1 1328 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13120 34 2 8 1140924451 1 15840 4658 nil nil 6752 true nil nil 5 nil nil nil 15840 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 217 578 441 49 15840 994 #text: 34 1 8 'Remove redundant &classes' 15840 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 1216 nil 27 1234 2496 61 1296 441 13568 1 1328 49 410 ##(Smalltalk.ContainerView) 34 15 nil 13120 34 2 8 1140850688 131073 16176 nil 848 nil 5 nil nil nil 16176 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 16176 34 2 8 1140850944 1 16256 4658 nil false 4690 4722 #= 8 #() 4722 #hash 4784 4802 nil true 4848 8 'Resources\LagoonLogo.bmp' 4896 4930 nil nil 578 321 327 578 8467 8627 4992 nil 5 nil nil nil 16256 nil 8 4294902547 3922 nil nil nil 16400 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 16256 994 #text: 34 1 8 'Graphic' 16256 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 16176 34 2 8 1140855108 1 16720 nil 848 nil 5 nil nil nil 16720 nil 8 1363032592 3922 nil nil 41 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 16720 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 4:\par
\f1\fs16\par
\f0 Configure how the ImageStripper removes unwanted classes and methods\b0\f1\par
\par
\par
\par
}
' 16720 994 #textLimit: 8 #(1073741823) 16720 994 #resetCharFormat 4272 16720 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4272 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 16176 994 #text: 34 1 8 'Heading' 16176 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 16720 16256 1216 nil 27 1234 2496 1 2112 1 1312 1 1328 121 410 ##(Smalltalk.StaticText) 34 16 nil 13120 34 2 8 1140850944 1 17408 nil nil nil 5 nil nil nil 17408 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 1029 69 17408 994 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 17408 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -57 1312 149 1328 69 410 ##(Smalltalk.CheckBox) 34 16 nil 13120 34 2 8 1140924451 1 17728 4658 nil nil 6752 false nil nil 5 nil nil nil 17728 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 581 578 423 49 17728 994 #text: 34 1 8 'Remove #shouldNot&Implement methods' 17728 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1216 nil 27 1234 1280 121 1296 423 14912 1 1328 49 170 192 34 14 17728 8 'stripShouldNotImplement' 13232 8 'stripSubclassResponsibility' 15840 8 'stripRedundantClasses' 14240 8 'stripRedundantMethods' 15504 8 'preserveAspectSetters' 13904 8 'stripDeprecatedMethods' 14576 8 'stripRedundantResources' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 13120 994 #text: 34 1 8 'Step 4' 13120 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 16176 17408 15840 14576 14928 14240 15504 13584 13904 17728 13232 15248 1216 nil 27 3698 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 18432 nil nil nil 5 nil nil nil 18432 706 170 176 34 12 410 ##(Smalltalk.StatusBar) 34 18 nil 18432 34 2 8 1140850700 1 18544 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 18544 nil 8 1903688272 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 18544 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'preStripScriptErrors' 138 144 34 1 18736 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 18544 nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 31 571 578 1047 41 18544 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 8 #() 1216 nil 27 1234 2496 31 2112 -37 1312 571 1328 41 410 ##(Smalltalk.StaticText) 34 16 nil 18432 34 2 8 1140850944 1 19008 nil nil nil 5 nil nil nil 19008 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 1047 169 19008 994 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 19008 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 25 2 0 0 158 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -39 1312 149 1328 169 410 ##(Smalltalk.ReferenceView) 34 14 nil 18432 34 2 8 1140850688 131073 19328 nil nil nil 5 nil nil nil 19328 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 31 321 578 1045 251 19328 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 25 2 0 0 29 1 0 0] 4272 1216 nil 27 1234 2496 31 2112 -39 1312 321 1328 251 410 ##(Smalltalk.PushButton) 34 20 nil 18432 34 2 8 1140924416 1 19584 nil 848 nil 5 nil nil nil 19584 nil 8 1903885040 882 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 881 661 578 211 51 19584 994 #isEnabled: 8 #(false) 19584 994 #text: 34 1 8 'Custom &Options' 19584 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1216 nil 29 1234 2496 881 1296 211 1312 661 1328 51 410 ##(Smalltalk.StaticText) 34 16 nil 18432 34 2 8 1140850944 1 19952 nil nil nil 5 nil nil nil 19952 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 651 578 791 71 19952 994 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 19952 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1216 nil 27 1234 2496 31 1296 791 1312 651 1328 71 410 ##(Smalltalk.ContainerView) 34 15 nil 18432 34 2 8 1140850688 131073 20272 nil 848 nil 5 nil nil nil 20272 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 20272 34 2 8 1140850944 1 20352 4658 nil false 4690 4722 #= 8 #() 4722 #hash 4784 4802 nil true 4848 8 'Resources\LagoonLogo.bmp' 4896 4930 nil nil 578 321 327 578 8467 8627 4992 nil 5 nil nil nil 20352 nil 8 4294902547 3922 nil nil nil 20496 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 20352 994 #text: 34 1 8 'Graphic' 20352 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 20272 34 2 8 1140855108 1 20816 nil 848 nil 5 nil nil nil 20816 nil 8 1363032592 3922 nil nil 41 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 20816 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 7:\f1\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\b0\par
}
' 20816 994 #textLimit: 8 #(1073741823) 20816 994 #resetCharFormat 4272 20816 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4272 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 20272 994 #text: 34 1 8 'Heading' 20272 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 20816 20352 1216 nil 27 1234 2496 1 2112 1 1312 1 1328 121 170 192 34 2 19328 8 'preStripScript' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 18432 994 #text: 34 1 8 'Step 7' 18432 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 20272 19008 19328 18544 19952 19584 1216 nil 27 3698 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 21776 nil nil nil 5 nil nil nil 21776 706 170 176 34 18 410 ##(Smalltalk.CheckBox) 34 16 nil 21776 34 2 8 1140924451 1 21888 4658 nil nil 6752 false nil nil 5 nil nil nil 21888 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 649 578 369 49 21888 994 #text: 34 1 8 'Compile E&xternal Structures' 21888 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1216 nil 27 1234 2496 81 1296 369 1312 649 1328 49 410 ##(Smalltalk.CheckBox) 34 16 nil 21776 34 2 8 1140924451 1 22224 4658 nil nil 6752 true nil nil 5 nil nil nil 22224 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 249 578 369 59 22224 994 #text: 34 1 8 'Remove class meta-&information' 22224 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1216 nil 27 1234 2496 81 1296 369 1312 249 1328 59 410 ##(Smalltalk.StaticText) 34 16 nil 21776 34 2 8 1140850944 1 22560 nil nil nil 5 nil nil nil 22560 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 549 578 979 89 22560 994 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 22560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -107 1312 549 1328 89 410 ##(Smalltalk.GroupBox) 34 14 nil 21776 34 2 8 1140850695 65 22880 nil 848 nil 5 nil nil nil 22880 nil 8 1903885040 930 138 144 34 1 994 #createAt:extent: 34 2 578 -17 521 578 1151 229 22880 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1216 nil 27 1234 2496 -17 2112 19 1312 521 1328 229 410 ##(Smalltalk.StaticText) 34 16 nil 21776 34 2 8 1140850944 1 23136 nil nil nil 5 nil nil nil 23136 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 979 99 23136 994 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 23136 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -107 1312 149 1328 99 410 ##(Smalltalk.StaticText) 34 16 nil 21776 34 2 8 1140850944 1 23456 nil nil nil 5 nil nil nil 23456 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 321 578 979 69 23456 994 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 23456 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -107 1312 321 1328 69 410 ##(Smalltalk.CheckBox) 34 16 nil 21776 34 2 8 1140924451 1 23776 4658 nil nil 6752 false nil nil 5 nil nil nil 23776 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 459 578 369 41 23776 994 #text: 34 1 8 'Remove class &GUIDs' 23776 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1216 nil 27 1234 2496 81 1296 369 1312 459 1328 41 410 ##(Smalltalk.ContainerView) 34 15 nil 21776 34 2 8 1140850688 131073 24112 nil 848 nil 5 nil nil nil 24112 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 24112 34 2 8 1140850944 1 24192 4658 nil false 4690 4722 #= 8 #() 4722 #hash 4784 4802 nil true 4848 8 'Resources\LagoonLogo.bmp' 4896 4930 nil nil 578 321 327 578 8467 8627 4992 nil 5 nil nil nil 24192 nil 8 4294902547 3922 nil nil nil 24336 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 24192 994 #text: 34 1 8 'Graphic' 24192 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 24112 34 2 8 1140855108 1 24656 nil 848 nil 5 nil nil nil 24656 nil 8 1363032592 3922 nil nil 41 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 24656 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 5:\f1\fs16\par
\par
Decide what meta-level information is required at runtime\par
\b0\par
\par
\par
}
' 24656 994 #textLimit: 8 #(1073741823) 24656 994 #resetCharFormat 4272 24656 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4272 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 24112 994 #text: 34 1 8 'Heading' 24112 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 24656 24192 1216 nil 27 1234 2496 1 2112 1 1312 1 1328 121 410 ##(Smalltalk.CheckBox) 34 16 nil 21776 34 2 8 1140924451 1 25344 4658 nil nil 6752 false nil nil 5 nil nil nil 25344 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 389 578 369 69 25344 994 #text: 34 1 8 'Retain instance &variable names' 25344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1216 nil 27 1234 2496 81 1296 369 1312 389 1328 69 170 192 34 8 22224 8 'stripClassInfo' 23776 8 'stripClassGuids' 25344 8 'retainInstVarNames' 21888 8 'compileExternalStructures' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 21776 994 #text: 34 1 8 'Step 5' 21776 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 24112 23136 22224 23456 25344 23776 22560 21888 22880 1216 nil 27 3698 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 26000 nil nil nil 5 nil nil nil 26000 706 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 26000 34 2 8 1140850944 1 26112 nil nil nil 5 nil nil nil 26112 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 269 578 189 49 26112 994 #text: 34 1 8 'E&xecutable name:' 26112 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1216 nil 27 1234 2496 81 1296 189 1312 269 1328 49 410 ##(Smalltalk.ContainerView) 34 15 nil 26000 34 2 8 1140850688 131073 26432 nil 848 nil 5 nil nil nil 26432 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 26432 34 2 8 1140850944 1 26512 4658 nil false 4690 4722 #= 8 #() 4722 #hash 4784 4802 nil true 4848 8 'Resources\LagoonLogo.bmp' 4896 4930 nil nil 578 321 327 578 8467 8627 4992 nil 5 nil nil nil 26512 nil 8 4294902547 3922 nil nil nil 26656 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 26512 994 #text: 34 1 8 'Graphic' 26512 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 26432 34 2 8 1140855108 1 26976 nil 848 nil 5 nil nil nil 26976 nil 8 1363032592 3922 nil nil 41 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 26976 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Final Step:\par
\f1\fs16\par
Deployment\b0\par
\par
\par
\par
}
' 26976 994 #textLimit: 8 #(1073741823) 26976 994 #resetCharFormat 4272 26976 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4272 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 26432 994 #text: 34 1 8 'Heading' 26432 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 26976 26512 1216 nil 27 1234 2496 1 2112 1 1312 1 1328 121 410 ##(Smalltalk.StaticText) 34 16 nil 26000 34 2 8 1140850944 1 27664 nil nil nil 5 nil nil nil 27664 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 641 578 979 59 27664 994 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 27664 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -107 1312 641 1328 59 410 ##(Smalltalk.StaticText) 34 16 nil 26000 34 2 8 1140850944 1 27984 nil nil nil 5 nil nil nil 27984 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 161 578 989 81 27984 994 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 27984 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -97 1312 161 1328 81 410 ##(Smalltalk.StaticText) 34 16 nil 26000 34 2 8 1140850944 1 28304 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 18656 nil 28304 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 529 578 949 81 28304 994 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 28304 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -137 1312 529 1328 81 410 ##(Smalltalk.StaticText) 34 16 nil 26000 34 2 8 1140850955 262145 28672 nil nil nil 5 nil nil nil 28672 nil 8 1903849936 3922 nil nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 281 269 578 737 41 28672 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1216 nil 27 1234 2496 281 2112 -97 1312 269 1328 41 410 ##(Smalltalk.StaticText) 34 16 nil 26000 34 2 8 1140850944 1 28944 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 18656 nil 28944 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 349 578 989 139 28944 994 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 28944 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -97 1312 349 1328 139 170 192 34 2 28672 8 'executablePath2' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 26000 994 #text: 34 1 8 'Final step' 26000 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 26432 27984 26112 28672 28304 28944 27664 1216 nil 27 3698 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 29584 nil 848 nil 7 nil nil nil 29584 706 170 176 34 8 410 ##(Smalltalk.RichTextEdit) 34 18 nil 29584 34 2 8 1140855110 1 29696 nil 848 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 882 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 29810 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29810 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29810 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29810 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29874 4097 29762 nil true 34 3 29810 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29810 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29810 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29874 4097 29810 1 882 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29696 nil 8 1363032592 3922 nil nil 43 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 5 994 #createAt:extent: 34 2 578 419 1 578 649 489 29696 994 #contextMenu: 34 1 29776 29696 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16\par
\f1\fs24 Welcome to the Dolphin Lagoon Application Deployment Wizard\f0\fs16\par
\par
This wizard helps you configure an ImageStripper that can be used to strip unnecessary objects from your Dolphin image and to deploy it to an executable (EXE) file. \par
\par
\par
\par
\par
If the ImageStripper attached to this wizard has already been configured then you may immediately deploy this image to the executable file below by clicking the \b Deploy \b0 button.\par
\par
}
' 29696 994 #textLimit: 8 #(1073741823) 29696 994 #resetCharFormat 4272 29696 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1216 nil 27 1234 2496 419 2112 -47 1312 1 1328 489 410 ##(Smalltalk.RichTextEdit) 34 18 nil 29584 34 2 8 1140855110 1 30768 nil 848 nil 7 29762 nil true 34 10 29810 1 882 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 29874 4097 29810 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29810 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29810 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29810 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29874 4097 29762 nil true 34 3 29810 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29810 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29810 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29874 4097 29810 1 882 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 30768 nil 8 1363032592 3922 nil nil 43 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 5 994 #createAt:extent: 34 2 578 419 681 578 549 49 30768 994 #contextMenu: 34 1 30832 30768 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click \b Next \b0 to continue.\par
\par
\par
\pard\qc\par
}
' 30768 994 #textLimit: 8 #(1073741823) 30768 994 #resetCharFormat 4272 30768 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1216 nil 27 1234 2496 419 1296 549 1312 681 1328 49 410 ##(Smalltalk.TextEdit) 34 16 nil 29584 34 2 8 1140850816 262145 31792 nil 834 #whiteSmoke nil 7 nil nil nil 31792 nil 8 1903872368 3922 nil nil 35 930 138 144 34 1 994 #createAt:extent: 34 2 578 421 491 578 645 41 31792 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1216 nil 27 1234 2496 421 2112 -49 13568 3 1328 41 410 ##(Smalltalk.ImageView) 34 21 nil 29584 34 2 8 1140850944 1 32080 4658 nil false 4690 4722 #= 8 #() 4722 #hash 4784 4802 nil true 4848 8 'Resources\LagoonSideBar.jpg' 4896 4930 nil nil 578 381 761 578 10055 20109 848 nil 7 nil nil nil 32080 nil 8 4294902547 3922 nil nil nil 32224 #centered 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 379 741 32080 994 #text: 34 1 8 'Lagoon Graphic' 32080 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1216 nil 27 1234 2496 1 1296 379 1312 1 1328 741 170 192 34 2 31792 8 'executablePath1' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 29584 994 #text: 34 1 8 'Intro' 29584 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 32080 29696 31792 30768 1216 nil 27 3698 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 32832 nil nil nil 5 nil nil nil 32832 706 170 176 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 32832 34 2 8 1144063491 1025 32944 4226 138 144 4272 nil 4304 848 nil 5 nil nil nil 32944 nil 8 1903738896 ##(Smalltalk.BasicListAbstract) 4272 401 930 138 144 34 1 994 #createAt:extent: 34 2 578 349 409 578 647 43 32944 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1216 nil 27 1234 2496 349 2112 -119 1312 409 1328 41 410 ##(Smalltalk.StaticText) 34 16 nil 32832 34 2 8 1140850944 1 33232 nil nil nil 5 nil nil nil 33232 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 229 578 979 149 33232 994 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33232 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -107 1312 229 1328 149 410 ##(Smalltalk.ContainerView) 34 15 nil 32832 34 2 8 1140850688 131073 33552 nil 848 nil 5 nil nil nil 33552 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 33552 34 2 8 1140850944 1 33632 4658 nil false 4690 4722 #= 8 #() 4722 #hash 4784 4802 nil true 4848 8 'Resources\LagoonLogo.bmp' 4896 4930 nil nil 578 321 327 578 8467 8627 4992 nil 5 nil nil nil 33632 nil 8 4294902547 3922 nil nil nil 33776 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 33632 994 #text: 34 1 8 'Graphic' 33632 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 33552 34 2 8 1140855108 1 34096 nil 848 nil 5 nil nil nil 34096 nil 8 1363032592 3922 nil nil 41 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 34096 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 1:\f1\fs16\par
\par
Choose an ImageStripper to perform the deployment process\b0\par
\par
\par
\par
}
' 34096 994 #textLimit: 8 #(1073741823) 34096 994 #resetCharFormat 4272 34096 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4272 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 33552 994 #text: 34 1 8 'Heading' 33552 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 34096 33632 1216 nil 27 1234 2496 1 2112 1 1312 1 1328 121 410 ##(Smalltalk.StaticText) 34 16 nil 32832 34 2 8 1140850944 1 34784 nil nil nil 5 nil nil nil 34784 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 401 578 249 121 34784 994 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 34784 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1216 nil 27 1234 2496 81 1296 249 1312 401 1328 121 170 192 34 2 32944 8 'imageStripperClass' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 32832 994 #text: 34 1 8 'Step 1' 32832 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 33552 33232 34784 32944 1216 nil 27 3698 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 35376 nil nil nil 5 nil nil nil 35376 706 170 176 34 14 410 ##(Smalltalk.ContainerView) 34 15 nil 35376 34 2 8 1140850688 131073 35488 nil 848 nil 5 nil nil nil 35488 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 35488 34 2 8 1140850944 1 35568 4658 nil false 4690 4722 #= 8 #() 4722 #hash 4784 4802 nil true 4848 8 'Resources\LagoonLogo.bmp' 4896 4930 nil nil 578 321 327 578 8467 8627 4992 nil 5 nil nil nil 35568 nil 8 4294902547 3922 nil nil nil 35712 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 35568 994 #text: 34 1 8 'Graphic' 35568 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 35488 34 2 8 1140855108 1 36032 nil 848 nil 5 nil nil nil 36032 nil 8 1363032592 3922 nil nil 41 nil 5346 8 #[0 0 0 0 0 0 0 0 160 0 226 3] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 36032 994 #text: 34 1 5538 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 6:\f1\fs16\par
\par
Miscellaneous stripping options\b0\par
\par
\par
\par
}
' 36032 994 #textLimit: 8 #(1073741823) 36032 994 #resetCharFormat 4272 36032 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4272 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 35488 994 #text: 34 1 8 'Heading' 35488 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 36032 35568 1216 nil 27 1234 2496 1 2112 1 1312 1 1328 121 410 ##(Smalltalk.GroupBox) 34 14 nil 35376 34 2 8 1140850695 65 36720 nil 848 nil 5 nil nil nil 36720 nil 8 1903885040 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 327 578 1115 393 36720 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1216 nil 27 1234 2496 1 2112 1 1312 327 1328 393 410 ##(Smalltalk.CheckBox) 34 16 nil 35376 34 2 8 1140924451 1 36976 4658 nil nil 6752 true nil nil 5 nil nil nil 36976 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 71 511 578 379 41 36976 994 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 36976 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1216 nil 27 1234 2496 71 1296 379 1312 511 1328 41 410 ##(Smalltalk.StaticText) 34 16 nil 35376 34 2 8 1140850944 1 37312 nil nil nil 5 nil nil nil 37312 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 391 578 967 49 37312 994 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 37312 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1216 nil 27 1234 2496 31 2112 -117 1312 391 1328 49 410 ##(Smalltalk.CheckBox) 34 16 nil 35376 34 2 8 1140924451 1 37632 4658 nil nil 6752 true nil nil 5 nil nil nil 37632 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 71 451 578 379 49 37632 994 #text: 34 1 8 'Fold duplicate s&trings' 37632 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1216 nil 27 1234 2496 71 1296 379 1312 451 1328 49 410 ##(Smalltalk.CheckBox) 34 16 nil 35376 34 2 8 1140924451 1 37968 4658 nil nil 6752 false nil nil 5 nil nil nil 37968 nil 8 1903885040 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 209 578 369 41 37968 994 #text: 34 1 8 'Remove &Class Builder' 37968 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1216 nil 27 1234 2496 81 1296 369 1312 209 1328 41 410 ##(Smalltalk.StaticText) 34 16 nil 35376 34 2 8 1140850944 1 38304 nil nil nil 5 nil nil nil 38304 nil 8 1903849936 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 161 578 989 49 38304 994 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 38304 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1216 nil 27 1234 2496 29 2112 -97 1312 161 1328 49 170 192 34 6 37968 8 'stripClassBuilder' 36976 8 'stripDuplicateBytecodes' 37632 8 'stripDuplicateStrings' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 35376 994 #text: 34 1 8 'Step 6' 35376 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 35488 38304 37968 37312 37632 36976 36720 1216 nil 27 29584 170 192 34 2 29584 8 'Intro' nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 1 578 1119 723 3568 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 29584 32832 3728 9920 13120 21776 35376 18432 26000 1216 nil 27 170 192 34 2 3568 8 'Steps' 3298 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 1998684880 930 138 144 34 3 994 #createAt:extent: 34 2 578 3839 21 578 1151 881 416 994 #text: 34 1 8 'Lagoon Deployment Wizard' 416 994 #updateMenuBar 4272 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 190 9 0 0 194 1 0 0] 34 2 3568 640 1216 nil 27 )!

saveImageOnDeploy
	"Answer whether the image will be saved before image stripping commences when initiated
	by instances of the receiver."

	^SaveImageOnDeploy!

saveImageOnDeploy: aBoolean
	"Set whether the image will be saved before image stripping commences when initiated
	by instances of the receiver."

	SaveImageOnDeploy := aBoolean!

toolsFolderIcon
	"Answer an instance of SmalltalkSystemIcon suitable for representing the
	receiver in the system folder."

	^SmalltalkSystemIcon showModal: self description: self displayString! !
!ApplicationDeploymentWizard class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!ApplicationDeploymentWizard class categoriesFor: #defaultModel!models!public! !
!ApplicationDeploymentWizard class categoriesFor: #displayOn:!displaying!public! !
!ApplicationDeploymentWizard class categoriesFor: #icon!constants!public! !
!ApplicationDeploymentWizard class categoriesFor: #initialize!initializing!private! !
!ApplicationDeploymentWizard class categoriesFor: #publishedAspects!development!public! !
!ApplicationDeploymentWizard class categoriesFor: #resource_Default_view!public!resources-views! !
!ApplicationDeploymentWizard class categoriesFor: #saveImageOnDeploy!options!public! !
!ApplicationDeploymentWizard class categoriesFor: #saveImageOnDeploy:!options!public! !
!ApplicationDeploymentWizard class categoriesFor: #toolsFolderIcon!accessing!public! !

