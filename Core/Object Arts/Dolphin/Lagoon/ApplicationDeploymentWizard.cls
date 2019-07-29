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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 37 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 15 1 31 86 135 1] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 768 nil 8 1905130144 1180998 4 ##(Smalltalk.CommandDescription) #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 357 13 578 131 49 768 1010 #isEnabled: 8 #(false) 768 1010 #text: 34 1 8 '&Next >' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 11 1282 #fixedViewLeft 131 1282 #fixedParentTop 1 1282 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1360 nil 848 nil 7 nil nil nil 1360 nil 8 1905130144 898 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 685 13 578 241 49 1360 1010 #isEnabled: 8 #(false) 1360 1010 #text: 34 1 8 '&Save Configuration' 1360 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1296 11 1312 241 1328 1 1344 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1728 nil 848 nil 7 nil nil nil 1728 nil 8 1905130144 898 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 955 13 578 139 49 1728 1010 #text: 34 1 8 'Cancel' 1728 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #fixedViewRight -137 1282 #fixedParentRight -11 1328 1 1344 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2096 nil 848 nil 7 nil nil nil 2096 nil 8 1905130144 898 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 545 13 578 131 49 2096 1010 #isEnabled: 8 #(false) 2096 1010 #text: 34 1 8 '&Reset' 2096 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 2064 -129 2080 -429 1328 1 1344 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2464 nil 848 nil 7 nil nil nil 2464 nil 8 1905130144 898 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 19 13 578 139 49 2464 1010 #isEnabled: 8 #(false) 2464 1010 #text: 34 1 8 '&Deploy' 2464 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #fixedParentLeft 9 1312 139 1328 1 1344 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2848 nil 848 nil 7 nil nil nil 2848 nil 8 1905130144 898 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 217 13 578 131 49 2848 1010 #isEnabled: 8 #(false) 2848 1010 #text: 34 1 8 '< &Back' 2848 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1312 131 1328 1 1344 49 170 192 34 2 2464 8 'deploy' 590342 ##(Smalltalk.Rectangle) 578 11 13 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 723 578 1119 81 640 1010 #text: 34 1 8 'Buttons' 640 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 2464 2848 768 2096 1360 1728 1232 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3584 nil nil nil 7 nil nil nil 3584 655878 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 3744 nil nil nil 5 nil nil nil 3744 706 170 176 34 28 410 ##(Smalltalk.CheckBox) 34 16 nil 3744 34 2 8 1140924451 1 3856 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) true nil nil 5 nil nil nil 3856 nil 8 1905130144 852486 ##(Smalltalk.NullConverter) nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 597 578 251 41 3856 1010 #text: 34 1 8 'Write &log file' 3856 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 1232 nil 27 1250 2832 61 1312 251 1328 597 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 3744 34 2 8 1140850944 1 4256 nil nil nil 5 nil nil nil 4256 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 141 578 389 81 4256 1010 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 4256 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 8 #() 1232 nil 27 1250 2832 31 1312 389 1328 141 1344 81 410 ##(Smalltalk.PushButton) 34 20 nil 3744 34 2 8 1140924416 1 4576 nil 848 nil 5 nil nil nil 4576 nil 8 1905130144 898 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 441 661 578 139 45 4576 1010 #isEnabled: 8 #(false) 4576 1010 #text: 34 1 8 'S&how it' 4576 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1232 nil 29 1250 2832 441 1312 139 1328 661 1344 45 410 ##(Smalltalk.StaticText) 34 16 nil 3744 34 2 8 1140850944 1 4944 nil nil nil 5 nil nil nil 4944 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 43 387 578 381 81 4944 1010 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 4944 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 193 0 0 0 211 0 0 0 233 0 0 0] 8 #() 1232 nil 27 1250 2832 43 1312 381 1328 387 1344 81 410 ##(Smalltalk.TextEdit) 34 16 nil 3744 34 2 8 1140916352 1025 5264 nil 848 nil 5 nil nil nil 5264 nil 8 1905117472 4002 nil nil 1 946 138 144 34 1 1010 #createAt:extent: 34 2 578 431 151 578 575 41 5264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1232 nil 27 1250 2832 431 2080 -109 1328 151 1344 41 410 ##(Smalltalk.TextEdit) 34 16 nil 3744 34 2 8 1140850688 262145 5536 nil nil nil 5 nil nil nil 5536 nil 8 1905117472 4002 nil nil 1 946 138 144 34 2 1010 #createAt:extent: 34 2 578 441 597 578 565 41 5536 1010 #isEnabled: 8 #(false) 5536 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 1232 nil 27 1250 2832 441 2080 -109 1328 597 1344 41 410 ##(Smalltalk.GroupBox) 34 14 nil 3744 34 2 8 1140850695 65 5840 nil 848 nil 5 nil nil nil 5840 nil 8 1905130144 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 279 578 1155 211 5840 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 244 0 0 0] 8 #() 1232 nil 27 1250 2832 1 2080 41 1328 279 1344 211 410 ##(Smalltalk.ContainerView) 34 15 nil 3744 34 2 8 1140850688 131073 6096 nil 848 nil 5 nil nil nil 6096 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 6096 34 2 8 1140850944 1 6176 3922 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 6290 #hash 8 #() 657478 3 ##(Smalltalk.OLEPicture) nil true 1703942 ##(Smalltalk.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 524806 ##(Smalltalk.IPicture) nil nil 578 321 327 578 8467 8627 721158 ##(Smalltalk.SystemColor) 31 nil 5 nil nil nil 6176 nil 8 4294902547 4002 nil nil nil 6384 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 6176 1010 #text: 34 1 8 'Graphic' 6176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 6096 34 2 8 1140855108 1 6832 nil 848 nil 5 nil nil nil 6832 nil 8 2062694928 4002 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 6832 1010 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 2: \par
\f1\fs16\par
Choose an Executable File and RuntimeSessionManager\b0\par
\par
\par
\par
}
' 6832 1010 #textLimit: 8 #(1073741823) 6832 1010 #resetCharFormat 8 #() 6832 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 7216 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 6096 1010 #text: 34 1 8 'Heading' 6096 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 6832 6176 1232 nil 27 1250 2832 1 2080 1 1328 1 1344 121 410 ##(Smalltalk.StaticText) 34 16 nil 3744 34 2 8 1140850944 1 7568 nil nil nil 5 nil nil nil 7568 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 309 578 975 71 7568 1010 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 7568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 1232 nil 27 1250 2832 31 2080 -109 1328 309 1344 71 410 ##(Smalltalk.StaticText) 34 16 nil 3744 34 2 8 1140850944 1 7888 nil nil nil 5 nil nil nil 7888 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 499 578 1045 81 7888 1010 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 7888 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 249 0 0 0 25 2 0 0 33 1 0 0] 8 #() 1232 nil 27 1250 2832 31 2080 -39 1328 499 1344 81 410 ##(Smalltalk.CheckBox) 34 16 nil 3744 34 2 8 1140924451 1 8208 3922 nil nil 3968 true nil nil 5 nil nil nil 8208 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 661 578 251 41 8208 1010 #text: 34 1 8 'Log &class references' 8208 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1232 nil 27 1250 2832 61 1312 251 1328 661 1344 41 410 ##(Smalltalk.ComboBox) 34 17 nil 3744 34 2 8 1144063491 1025 8544 590662 2 ##(Smalltalk.ListModel) 138 144 7216 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 848 nil 5 nil nil nil 8544 nil 8 1904996688 ##(Smalltalk.BasicListAbstract) 7216 401 946 138 144 34 1 1010 #createAt:extent: 34 2 578 441 399 578 565 43 8544 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 199 0 0 0 246 1 0 0 220 0 0 0] 8 #() 1232 nil 27 1250 2832 441 2080 -109 1328 399 1344 43 410 ##(Smalltalk.CheckBox) 34 16 nil 3744 34 2 8 1140924451 1 8880 3922 nil nil 3968 false nil nil 5 nil nil nil 8880 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 211 578 431 81 8880 1010 #text: 34 1 8 'Create single file, "To Go" distributable.' 8880 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1232 nil 27 1250 2832 31 1312 431 1328 211 1344 81 410 ##(Smalltalk.PushButton) 34 20 nil 3744 34 2 8 1140924416 1 9216 nil 848 nil 5 nil nil nil 9216 nil 8 1905130144 898 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 1025 151 578 49 41 9216 1010 #isEnabled: 8 #(false) 9216 1010 #text: 34 1 8 '...' 9216 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1232 nil 29 1250 2064 -47 2080 -41 1328 151 1344 41 170 192 34 14 8208 8 'logReferencesToClasses' 5264 8 'executableName' 4576 8 'showLog' 5536 8 'logFileName' 3856 8 'writeLogFile' 8880 8 'isToGo' 8544 8 'runtimeSessionManagerClass' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 3744 1010 #text: 34 1 8 'Step 2' 3744 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 6096 4256 5264 9216 8880 7568 4944 8544 7888 3856 8208 5536 4576 5840 1232 nil 27 3714 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 9952 nil nil nil 5 nil nil nil 9952 706 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 9952 34 2 8 1140850944 1 10064 nil nil nil 5 nil nil nil 10064 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 389 578 201 41 10064 1010 #text: 34 1 8 'Root package:' 10064 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1232 nil 27 1250 2832 81 1312 201 1328 389 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 9952 34 2 8 1140850944 262145 10384 nil nil nil 5 nil nil nil 10384 nil 8 1905095040 4002 nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 361 389 578 647 41 10384 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1232 nil 27 1250 2832 361 2080 -107 1328 389 1344 41 410 ##(Smalltalk.CheckBox) 34 16 nil 9952 34 2 8 1140924451 1 10656 3922 nil nil 3968 true nil nil 5 nil nil nil 10656 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 59 599 578 329 49 10656 1010 #text: 34 1 8 'Remove redundant &packages' 10656 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 8 #() 1232 nil 27 1250 2832 59 1312 329 1328 599 1344 49 410 ##(Smalltalk.StaticText) 34 16 nil 9952 34 2 8 1140850944 1 10992 nil nil nil 5 nil nil nil 10992 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 499 578 979 109 10992 1010 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10992 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -107 1328 499 1344 109 410 ##(Smalltalk.StaticText) 34 16 nil 9952 34 2 8 1140850944 1 11312 nil nil nil 5 nil nil nil 11312 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 171 578 975 191 11312 1010 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 11312 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1232 nil 27 1250 2832 31 2080 -109 1328 171 1344 191 410 ##(Smalltalk.ContainerView) 34 15 nil 9952 34 2 8 1140850688 131073 11632 nil 848 nil 5 nil nil nil 11632 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 11632 34 2 8 1140850944 1 11712 3922 nil false 6258 6290 #= 8 #() 6290 #hash 6352 6370 nil true 6416 8 'Resources\LagoonLogo.bmp' 6464 6498 nil nil 578 321 327 578 8467 8627 6576 nil 5 nil nil nil 11712 nil 8 4294902547 4002 nil nil nil 11856 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 11712 1010 #text: 34 1 8 'Graphic' 11712 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 11632 34 2 8 1140855108 1 12176 nil 848 nil 5 nil nil nil 12176 nil 8 2062694928 4002 nil nil 41 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 12176 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 3:\f1\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\par
\b0\par
\par
\par
}
' 12176 1010 #textLimit: 8 #(1073741823) 12176 1010 #resetCharFormat 7216 12176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 7216 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 11632 1010 #text: 34 1 8 'Heading' 11632 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 12176 11712 1232 nil 27 1250 2832 1 2080 1 1328 1 1344 121 170 192 34 4 10384 8 'rootPackage' 10656 8 'stripRedundantPackages' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 9952 1010 #text: 34 1 8 'Step 3' 9952 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 11632 11312 10064 10384 10992 10656 1232 nil 27 3714 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 13152 nil nil nil 5 nil nil nil 13152 706 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 13264 3922 nil nil 3968 true nil nil 5 nil nil nil 13264 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 217 578 441 49 13264 1010 #text: 34 1 8 'Remove redundant &classes' 13264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 1232 nil 27 1250 2832 61 1312 441 1282 #fixedPreviousBottom 1 1344 49 410 ##(Smalltalk.StaticText) 34 16 nil 13152 34 2 8 1140850944 1 13616 nil nil nil 5 nil nil nil 13616 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 315 578 1019 121 13616 1010 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 13616 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -67 13600 51 1344 121 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 13936 3922 nil nil 3968 true nil nil 5 nil nil nil 13936 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 621 217 578 423 49 13936 1010 #text: 34 1 8 'Remove redundant &resources' 13936 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1232 nil 27 1250 1296 121 1312 423 1282 #fixedPreviousTop 1 1344 49 410 ##(Smalltalk.StaticText) 34 16 nil 13152 34 2 8 1140850944 1 14288 nil nil nil 5 nil nil nil 14288 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 533 578 1079 49 14288 1010 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 14288 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -7 13600 51 1344 49 410 ##(Smalltalk.GroupBox) 34 14 nil 13152 34 2 8 1140850695 65 14608 nil 848 nil 5 nil nil nil 14608 nil 8 1905130144 946 138 144 34 1 1010 #createAt:extent: 34 2 578 -17 281 578 1151 229 14608 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1232 nil 27 1250 2832 -17 2080 19 1328 281 1344 229 410 ##(Smalltalk.ContainerView) 34 15 nil 13152 34 2 8 1140850688 131073 14864 nil 848 nil 5 nil nil nil 14864 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 14864 34 2 8 1140850944 1 14944 3922 nil false 6258 6290 #= 8 #() 6290 #hash 6352 6370 nil true 6416 8 'Resources\LagoonLogo.bmp' 6464 6498 nil nil 578 321 327 578 8467 8627 6576 nil 5 nil nil nil 14944 nil 8 4294902547 4002 nil nil nil 15088 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 14944 1010 #text: 34 1 8 'Graphic' 14944 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 14864 34 2 8 1140855108 1 15408 nil 848 nil 5 nil nil nil 15408 nil 8 2062694928 4002 nil nil 41 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 15408 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 4:\par
\f1\fs16\par
\f0 Configure how the ImageStripper removes unwanted classes and methods\b0\f1\par
\par
\par
\par
}
' 15408 1010 #textLimit: 8 #(1073741823) 15408 1010 #resetCharFormat 7216 15408 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 7216 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 14864 1010 #text: 34 1 8 'Heading' 14864 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 15408 14944 1232 nil 27 1250 2832 1 2080 1 1328 1 1344 121 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 16096 3922 nil nil 3968 false nil nil 5 nil nil nil 16096 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 435 578 441 49 16096 1010 #text: 34 1 8 'Remove redundant &methods' 16096 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 1232 nil 27 1250 2832 61 1312 441 13600 1 1344 49 410 ##(Smalltalk.StaticText) 34 16 nil 13152 34 2 8 1140850944 1 16432 nil nil nil 5 nil nil nil 16432 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 1029 69 16432 1010 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 16432 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -57 1328 149 1344 69 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 16752 3922 nil nil 3968 false nil nil 5 nil nil nil 16752 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 621 581 578 423 49 16752 1010 #text: 34 1 8 'Remove #shouldNot&Implement methods' 16752 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1232 nil 27 1250 1296 121 1312 423 14272 1 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 17088 3922 nil nil 3968 false nil nil 5 nil nil nil 17088 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 621 435 578 423 49 17088 1010 #text: 34 1 8 'Preserve &aspect set methods' 17088 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1232 nil 27 1250 1296 121 1312 423 14272 1 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 17424 3922 nil nil 3968 false nil nil 5 nil nil nil 17424 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 645 578 441 49 17424 1010 #text: 34 1 8 'Remove #&subclassResponsibility methods' 17424 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 1232 nil 27 1250 2832 61 1312 441 13600 17 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 17760 3922 nil nil 3968 false nil nil 5 nil nil nil 17760 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 581 578 441 49 17760 1010 #text: 34 1 8 'Remove #&deprecated methods' 17760 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 1232 nil 27 1250 2832 61 1312 441 13600 1 1344 49 170 192 34 14 16096 8 'stripRedundantMethods' 16752 8 'stripShouldNotImplement' 13264 8 'stripRedundantClasses' 17088 8 'preserveAspectSetters' 17424 8 'stripSubclassResponsibility' 17760 8 'stripDeprecatedMethods' 13936 8 'stripRedundantResources' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 13152 1010 #text: 34 1 8 'Step 4' 13152 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 14864 16432 13264 13936 13616 16096 17088 14288 17760 16752 17424 14608 1232 nil 27 3714 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 18464 nil nil nil 5 nil nil nil 18464 706 170 176 34 12 410 ##(Smalltalk.StatusBar) 34 18 nil 18464 34 2 8 1140850700 1 18576 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 18576 nil 8 1904933456 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 18576 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'preStripScriptErrors' 138 144 34 1 18768 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 18576 nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 31 571 578 1047 41 18576 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 8 #() 1232 nil 27 1250 2832 31 2080 -37 1328 571 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 18464 34 2 8 1140850944 1 19040 nil nil nil 5 nil nil nil 19040 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 651 578 791 71 19040 1010 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 19040 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1232 nil 27 1250 2832 31 1312 791 1328 651 1344 71 410 ##(Smalltalk.StaticText) 34 16 nil 18464 34 2 8 1140850944 1 19360 nil nil nil 5 nil nil nil 19360 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 1047 169 19360 1010 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 19360 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 25 2 0 0 158 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -39 1328 149 1344 169 410 ##(Smalltalk.PushButton) 34 20 nil 18464 34 2 8 1140924416 1 19680 nil 848 nil 5 nil nil nil 19680 nil 8 1905130144 898 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 881 661 578 211 51 19680 1010 #isEnabled: 8 #(false) 19680 1010 #text: 34 1 8 'Custom &Options' 19680 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1232 nil 29 1250 2832 881 1312 211 1328 661 1344 51 410 ##(Smalltalk.ReferenceView) 34 14 nil 18464 34 2 8 1140850688 131073 20048 nil nil nil 5 nil nil nil 20048 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 31 321 578 1045 251 20048 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 25 2 0 0 29 1 0 0] 7216 1232 nil 27 1250 2832 31 2080 -39 1328 321 1344 251 410 ##(Smalltalk.ContainerView) 34 15 nil 18464 34 2 8 1140850688 131073 20304 nil 848 nil 5 nil nil nil 20304 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 20304 34 2 8 1140850944 1 20384 3922 nil false 6258 6290 #= 8 #() 6290 #hash 6352 6370 nil true 6416 8 'Resources\LagoonLogo.bmp' 6464 6498 nil nil 578 321 327 578 8467 8627 6576 nil 5 nil nil nil 20384 nil 8 4294902547 4002 nil nil nil 20528 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 20384 1010 #text: 34 1 8 'Graphic' 20384 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 20304 34 2 8 1140855108 1 20848 nil 848 nil 5 nil nil nil 20848 nil 8 2062694928 4002 nil nil 41 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 20848 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 7:\f1\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\b0\par
}
' 20848 1010 #textLimit: 8 #(1073741823) 20848 1010 #resetCharFormat 7216 20848 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 7216 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 20304 1010 #text: 34 1 8 'Heading' 20304 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 20848 20384 1232 nil 27 1250 2832 1 2080 1 1328 1 1344 121 170 192 34 2 20048 8 'preStripScript' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 18464 1010 #text: 34 1 8 'Step 7' 18464 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 20304 19360 20048 18576 19040 19680 1232 nil 27 3714 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 21808 nil nil nil 5 nil nil nil 21808 706 170 176 34 18 410 ##(Smalltalk.StaticText) 34 16 nil 21808 34 2 8 1140850944 1 21920 nil nil nil 5 nil nil nil 21920 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 549 578 979 89 21920 1010 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 21920 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -107 1328 549 1344 89 410 ##(Smalltalk.StaticText) 34 16 nil 21808 34 2 8 1140850944 1 22240 nil nil nil 5 nil nil nil 22240 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 979 99 22240 1010 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 22240 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -107 1328 149 1344 99 410 ##(Smalltalk.CheckBox) 34 16 nil 21808 34 2 8 1140924451 1 22560 3922 nil nil 3968 false nil nil 5 nil nil nil 22560 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 649 578 369 49 22560 1010 #text: 34 1 8 'Compile E&xternal Structures' 22560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1232 nil 27 1250 2832 81 1312 369 1328 649 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 21808 34 2 8 1140924451 1 22896 3922 nil nil 3968 false nil nil 5 nil nil nil 22896 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 389 578 369 69 22896 1010 #text: 34 1 8 'Retain instance &variable names' 22896 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1232 nil 27 1250 2832 81 1312 369 1328 389 1344 69 410 ##(Smalltalk.CheckBox) 34 16 nil 21808 34 2 8 1140924451 1 23232 3922 nil nil 3968 true nil nil 5 nil nil nil 23232 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 249 578 369 59 23232 1010 #text: 34 1 8 'Remove class meta-&information' 23232 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1232 nil 27 1250 2832 81 1312 369 1328 249 1344 59 410 ##(Smalltalk.ContainerView) 34 15 nil 21808 34 2 8 1140850688 131073 23568 nil 848 nil 5 nil nil nil 23568 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 23568 34 2 8 1140850944 1 23648 3922 nil false 6258 6290 #= 8 #() 6290 #hash 6352 6370 nil true 6416 8 'Resources\LagoonLogo.bmp' 6464 6498 nil nil 578 321 327 578 8467 8627 6576 nil 5 nil nil nil 23648 nil 8 4294902547 4002 nil nil nil 23792 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 23648 1010 #text: 34 1 8 'Graphic' 23648 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 23568 34 2 8 1140855108 1 24112 nil 848 nil 5 nil nil nil 24112 nil 8 2062694928 4002 nil nil 41 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 24112 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 5:\f1\fs16\par
\par
Decide what meta-level information is required at runtime\par
\b0\par
\par
\par
}
' 24112 1010 #textLimit: 8 #(1073741823) 24112 1010 #resetCharFormat 7216 24112 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 7216 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 23568 1010 #text: 34 1 8 'Heading' 23568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 24112 23648 1232 nil 27 1250 2832 1 2080 1 1328 1 1344 121 410 ##(Smalltalk.GroupBox) 34 14 nil 21808 34 2 8 1140850695 65 24800 nil 848 nil 5 nil nil nil 24800 nil 8 1905130144 946 138 144 34 1 1010 #createAt:extent: 34 2 578 -17 521 578 1151 229 24800 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1232 nil 27 1250 2832 -17 2080 19 1328 521 1344 229 410 ##(Smalltalk.StaticText) 34 16 nil 21808 34 2 8 1140850944 1 25056 nil nil nil 5 nil nil nil 25056 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 321 578 979 69 25056 1010 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 25056 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -107 1328 321 1344 69 410 ##(Smalltalk.CheckBox) 34 16 nil 21808 34 2 8 1140924451 1 25376 3922 nil nil 3968 false nil nil 5 nil nil nil 25376 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 459 578 369 41 25376 1010 #text: 34 1 8 'Remove class &GUIDs' 25376 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1232 nil 27 1250 2832 81 1312 369 1328 459 1344 41 170 192 34 8 23232 8 'stripClassInfo' 22896 8 'retainInstVarNames' 22560 8 'compileExternalStructures' 25376 8 'stripClassGuids' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 21808 1010 #text: 34 1 8 'Step 5' 21808 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 23568 22240 23232 25056 22896 25376 21920 22560 24800 1232 nil 27 3714 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 26032 nil nil nil 5 nil nil nil 26032 706 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 26032 34 2 8 1140850944 1 26144 nil nil nil 5 nil nil nil 26144 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 269 578 189 49 26144 1010 #text: 34 1 8 'E&xecutable name:' 26144 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1232 nil 27 1250 2832 81 1312 189 1328 269 1344 49 410 ##(Smalltalk.StaticText) 34 16 nil 26032 34 2 8 1140850944 1 26464 nil nil nil 5 nil nil nil 26464 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 161 578 989 81 26464 1010 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 26464 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -97 1328 161 1344 81 410 ##(Smalltalk.StaticText) 34 16 nil 26032 34 2 8 1140850944 1 26784 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 18688 nil 26784 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 529 578 949 81 26784 1010 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 26784 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -137 1328 529 1344 81 410 ##(Smalltalk.StaticText) 34 16 nil 26032 34 2 8 1140850955 262145 27152 nil nil nil 5 nil nil nil 27152 nil 8 1905095040 4002 nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 281 269 578 737 41 27152 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1232 nil 27 1250 2832 281 2080 -97 1328 269 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 26032 34 2 8 1140850944 1 27424 nil nil nil 5 nil nil nil 27424 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 641 578 979 59 27424 1010 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 27424 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -107 1328 641 1344 59 410 ##(Smalltalk.ContainerView) 34 15 nil 26032 34 2 8 1140850688 131073 27744 nil 848 nil 5 nil nil nil 27744 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 27744 34 2 8 1140850944 1 27824 3922 nil false 6258 6290 #= 8 #() 6290 #hash 6352 6370 nil true 6416 8 'Resources\LagoonLogo.bmp' 6464 6498 nil nil 578 321 327 578 8467 8627 6576 nil 5 nil nil nil 27824 nil 8 4294902547 4002 nil nil nil 27968 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 27824 1010 #text: 34 1 8 'Graphic' 27824 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 27744 34 2 8 1140855108 1 28288 nil 848 nil 5 nil nil nil 28288 nil 8 2062694928 4002 nil nil 41 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 28288 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Final Step:\par
\f1\fs16\par
Deployment\b0\par
\par
\par
\par
}
' 28288 1010 #textLimit: 8 #(1073741823) 28288 1010 #resetCharFormat 7216 28288 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 7216 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 27744 1010 #text: 34 1 8 'Heading' 27744 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 28288 27824 1232 nil 27 1250 2832 1 2080 1 1328 1 1344 121 410 ##(Smalltalk.StaticText) 34 16 nil 26032 34 2 8 1140850944 1 28976 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 18688 nil 28976 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 349 578 989 139 28976 1010 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 28976 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -97 1328 349 1344 139 170 192 34 2 27152 8 'executablePath2' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 26032 1010 #text: 34 1 8 'Final step' 26032 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 27744 26464 26144 27152 26784 28976 27424 1232 nil 27 3714 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 29616 nil 848 nil 7 nil nil nil 29616 706 170 176 34 8 410 ##(Smalltalk.RichTextEdit) 34 18 nil 29616 34 2 8 1140855110 1 29728 nil 848 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 898 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 29842 1 898 #bePlain 8 '&Plain' 1 1 nil nil nil 29842 1 898 #toggleBold 8 '&Bold' 1 1 nil nil nil 29842 1 898 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29842 1 898 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29906 4097 29794 nil true 34 3 29842 1 898 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29842 1 898 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29842 1 898 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29906 4097 29842 1 898 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29728 nil 8 2062694928 4002 nil nil 43 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 5 1010 #createAt:extent: 34 2 578 419 1 578 649 489 29728 1010 #contextMenu: 34 1 29808 29728 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}}
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
' 29728 1010 #textLimit: 8 #(1073741823) 29728 1010 #resetCharFormat 7216 29728 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1232 nil 27 1250 2832 419 2080 -47 1328 1 1344 489 410 ##(Smalltalk.ImageView) 34 21 nil 29616 34 2 8 1140850944 1 30800 3922 nil false 6258 6290 #= 8 #() 6290 #hash 6352 6370 nil true 6416 8 'Resources\LagoonSideBar.jpg' 6464 6498 nil nil 578 381 761 578 10055 20109 848 nil 7 nil nil nil 30800 nil 8 4294902547 4002 nil nil nil 30944 #centered 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 379 741 30800 1010 #text: 34 1 8 'Lagoon Graphic' 30800 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1232 nil 27 1250 2832 1 1312 379 1328 1 1344 741 410 ##(Smalltalk.RichTextEdit) 34 18 nil 29616 34 2 8 1140855110 1 31280 nil 848 nil 7 29794 nil true 34 10 29842 1 898 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 29906 4097 29842 1 898 #bePlain 8 '&Plain' 1 1 nil nil nil 29842 1 898 #toggleBold 8 '&Bold' 1 1 nil nil nil 29842 1 898 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29842 1 898 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29906 4097 29794 nil true 34 3 29842 1 898 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29842 1 898 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29842 1 898 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29906 4097 29842 1 898 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 31280 nil 8 2062694928 4002 nil nil 43 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 5 1010 #createAt:extent: 34 2 578 419 681 578 549 49 31280 1010 #contextMenu: 34 1 31344 31280 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click \b Next \b0 to continue.\par
\par
\par
\pard\qc\par
}
' 31280 1010 #textLimit: 8 #(1073741823) 31280 1010 #resetCharFormat 7216 31280 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1232 nil 27 1250 2832 419 1312 549 1328 681 1344 49 410 ##(Smalltalk.TextEdit) 34 16 nil 29616 34 2 8 1140850816 262145 32304 nil 196934 1 ##(Smalltalk.RGB) 32238571 nil 7 nil nil nil 32304 nil 8 1905117472 4002 nil nil 35 946 138 144 34 1 1010 #createAt:extent: 34 2 578 421 491 578 645 41 32304 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1232 nil 27 1250 2832 421 2080 -49 13600 3 1344 41 170 192 34 2 32304 8 'executablePath1' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 29616 1010 #text: 34 1 8 'Intro' 29616 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 30800 29728 32304 31280 1232 nil 27 3714 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 32880 nil nil nil 5 nil nil nil 32880 706 170 176 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 32880 34 2 8 1140850944 1 32992 nil nil nil 5 nil nil nil 32992 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 401 578 249 121 32992 1010 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 32992 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1232 nil 27 1250 2832 81 1312 249 1328 401 1344 121 410 ##(Smalltalk.StaticText) 34 16 nil 32880 34 2 8 1140850944 1 33312 nil nil nil 5 nil nil nil 33312 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 229 578 979 149 33312 1010 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33312 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -107 1328 229 1344 149 410 ##(Smalltalk.ContainerView) 34 15 nil 32880 34 2 8 1140850688 131073 33632 nil 848 nil 5 nil nil nil 33632 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 33632 34 2 8 1140850944 1 33712 3922 nil false 6258 6290 #= 8 #() 6290 #hash 6352 6370 nil true 6416 8 'Resources\LagoonLogo.bmp' 6464 6498 nil nil 578 321 327 578 8467 8627 6576 nil 5 nil nil nil 33712 nil 8 4294902547 4002 nil nil nil 33856 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 33712 1010 #text: 34 1 8 'Graphic' 33712 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 33632 34 2 8 1140855108 1 34176 nil 848 nil 5 nil nil nil 34176 nil 8 2062694928 4002 nil nil 41 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 34176 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 1:\f1\fs16\par
\par
Choose an ImageStripper to perform the deployment process\b0\par
\par
\par
\par
}
' 34176 1010 #textLimit: 8 #(1073741823) 34176 1010 #resetCharFormat 7216 34176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 7216 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 33632 1010 #text: 34 1 8 'Heading' 33632 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 34176 33712 1232 nil 27 1250 2832 1 2080 1 1328 1 1344 121 410 ##(Smalltalk.ComboBox) 34 17 nil 32880 34 2 8 1144063491 1025 34864 8610 138 144 7216 nil 8672 848 nil 5 nil nil nil 34864 nil 8 1904996688 ##(Smalltalk.BasicListAbstract) 7216 401 946 138 144 34 1 1010 #createAt:extent: 34 2 578 349 409 578 647 43 34864 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1232 nil 27 1250 2832 349 2080 -119 1328 409 1344 41 170 192 34 2 34864 8 'imageStripperClass' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 32880 1010 #text: 34 1 8 'Step 1' 32880 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 33632 33312 32992 34864 1232 nil 27 3714 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 35424 nil nil nil 5 nil nil nil 35424 706 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 35424 34 2 8 1140850944 1 35536 nil nil nil 5 nil nil nil 35536 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 391 578 967 49 35536 1010 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 35536 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1232 nil 27 1250 2832 31 2080 -117 1328 391 1344 49 410 ##(Smalltalk.GroupBox) 34 14 nil 35424 34 2 8 1140850695 65 35856 nil 848 nil 5 nil nil nil 35856 nil 8 1905130144 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 327 578 1115 393 35856 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1232 nil 27 1250 2832 1 2080 1 1328 327 1344 393 410 ##(Smalltalk.ContainerView) 34 15 nil 35424 34 2 8 1140850688 131073 36112 nil 848 nil 5 nil nil nil 36112 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 36112 34 2 8 1140850944 1 36192 3922 nil false 6258 6290 #= 8 #() 6290 #hash 6352 6370 nil true 6416 8 'Resources\LagoonLogo.bmp' 6464 6498 nil nil 578 321 327 578 8467 8627 6576 nil 5 nil nil nil 36192 nil 8 4294902547 4002 nil nil nil 36336 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 36192 1010 #text: 34 1 8 'Graphic' 36192 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 36112 34 2 8 1140855108 1 36656 nil 848 nil 5 nil nil nil 36656 nil 8 2062694928 4002 nil nil 41 nil 6930 8 #[0 0 0 0 0 0 0 0 176 0 0 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 36656 1010 #text: 34 1 7122 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 6:\f1\fs16\par
\par
Miscellaneous stripping options\b0\par
\par
\par
\par
}
' 36656 1010 #textLimit: 8 #(1073741823) 36656 1010 #resetCharFormat 7216 36656 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 7216 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 36112 1010 #text: 34 1 8 'Heading' 36112 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 36656 36192 1232 nil 27 1250 2832 1 2080 1 1328 1 1344 121 410 ##(Smalltalk.CheckBox) 34 16 nil 35424 34 2 8 1140924451 1 37344 3922 nil nil 3968 false nil nil 5 nil nil nil 37344 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 209 578 369 41 37344 1010 #text: 34 1 8 'Remove &Class Builder' 37344 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1232 nil 27 1250 2832 81 1312 369 1328 209 1344 41 410 ##(Smalltalk.CheckBox) 34 16 nil 35424 34 2 8 1140924451 1 37680 3922 nil nil 3968 true nil nil 5 nil nil nil 37680 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 451 578 379 49 37680 1010 #text: 34 1 8 'Fold duplicate s&trings' 37680 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1232 nil 27 1250 2832 71 1312 379 1328 451 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 35424 34 2 8 1140924451 1 38016 3922 nil nil 3968 true nil nil 5 nil nil nil 38016 nil 8 1905130144 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 511 578 379 41 38016 1010 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 38016 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1232 nil 27 1250 2832 71 1312 379 1328 511 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 35424 34 2 8 1140850944 1 38352 nil nil nil 5 nil nil nil 38352 nil 8 1905095040 4002 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 161 578 989 49 38352 1010 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 38352 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1232 nil 27 1250 2832 29 2080 -97 1328 161 1344 49 170 192 34 6 38016 8 'stripDuplicateBytecodes' 37344 8 'stripClassBuilder' 37680 8 'stripDuplicateStrings' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 35424 1010 #text: 34 1 8 'Step 6' 35424 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 36112 38352 37344 35536 37680 38016 35856 1232 nil 27 29616 170 192 34 2 29616 8 'Intro' nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 1 578 1119 723 3584 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 29616 32880 3744 9952 13152 21808 35424 18464 26032 1232 nil 27 170 192 34 2 3584 8 'Steps' 3314 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 1999208944 946 138 144 34 3 1010 #createAt:extent: 34 2 578 3839 21 578 1151 881 416 1010 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1010 #updateMenuBar 7216 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 190 9 0 0 194 1 0 0] 34 2 3584 640 1232 nil 27 )!

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

