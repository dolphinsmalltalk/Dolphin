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
!ApplicationDeploymentWizard categoriesForClass!Development!MVP-Presenters! !
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

deploy
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

	command == #deploy ifTrue: [
		query isEnabled: self canDeploy.
		^true].

	command == #showLog ifTrue: [
		query isEnabled: self hasExistingLog.
		^true].

	^super queryCommand: query
!

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

	EnvironmentBrowserShell show browseExecutableManfiestFile: logFileName value!

strip
	"Private - Strips the image according to the receiver's image stripper
	and deploys it to an executable file. The development system will exit 
	following this action"

	self class saveImageOnDeploy ifTrue: [Smalltalk developmentSystem saveImage].
	"Queue a deferred action to strip the image in such a way as to allow the receiver to be
	GC'd. In order to reduce the references from the deferred action we eschew the use of a
	block here - this is important to effective image stripping, as otherwise this wizard would
	end up in the affecting the outcome. Even with full block closures in D6 the use of a block
	would still end up creating a referenced to the deployment wizard class through the method
	reference."
	SessionManager inputState 
		queueDeferredAction: (MessageSend receiver: self value selector: #stripAndSaveWithProgress)!

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
!ApplicationDeploymentWizard categoriesFor: #deploy!commands!public! !
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 0 0 8 #(13369344 65536) 416 0 721158 ##(Smalltalk.SystemColor) 31 0 39 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 15 1 31 86 135 1] 328198 ##(Smalltalk.Point) 193 193 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140916224 393217 640 0 466 31 0 7 0 0 0 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 0 640 34 2 8 1140924416 1 784 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 7 0 0 0 784 0 8 4294908309 1180998 4 ##(Smalltalk.CommandDescription) #reset 8 '&Reset' 1 1 0 0 false 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 545 13 578 131 49 784 1026 #isEnabled: 8 #(false) 784 1026 #text: 34 1 8 '&Reset' 784 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 578 193 193 0 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -129 1298 #fixedParentRight -429 1298 #fixedParentTop 1 1298 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 0 640 34 2 8 1140924416 1 1376 0 850 880 0 7 0 0 0 1376 0 8 4294908309 914 #previousCard 8 '< &Back' 1 1 0 0 false 0 0 0 962 138 144 34 3 1026 #createAt:extent: 34 2 578 217 13 578 131 49 1376 1026 #isEnabled: 8 #(false) 1376 1026 #text: 34 1 8 '< &Back' 1376 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1248 0 29 1266 1298 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1298 #fixedViewLeft 131 1344 1 1360 49 410 ##(Smalltalk.PushButton) 34 20 0 640 34 2 8 1140924416 1 1824 0 850 880 0 7 0 0 0 1824 0 8 4294908309 914 #nextCard 8 '&Next >' 1 1 0 0 false 0 0 0 962 138 144 34 3 1026 #createAt:extent: 34 2 578 357 13 578 131 49 1824 1026 #isEnabled: 8 #(false) 1824 1026 #text: 34 1 8 '&Next >' 1824 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 1248 0 29 1266 1298 #fixedPreviousRight 11 1808 131 1344 1 1360 49 410 ##(Smalltalk.PushButton) 34 20 0 640 34 2 8 1140924416 1 2224 0 850 880 0 7 0 0 0 2224 0 8 4294908309 914 #ok 8 '&Save Configuration' 1 1 0 0 false 0 0 0 962 138 144 34 3 1026 #createAt:extent: 34 2 578 685 13 578 241 49 2224 1026 #isEnabled: 8 #(false) 2224 1026 #text: 34 1 8 '&Save Configuration' 2224 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 1248 0 29 1266 2208 11 1808 241 1344 1 1360 49 410 ##(Smalltalk.PushButton) 34 20 0 640 34 2 8 1140924416 1 2608 0 850 880 0 7 0 0 0 2608 0 8 4294908309 914 #cancel 8 'Cancel' 1 1 0 0 false 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 955 13 578 139 49 2608 1026 #text: 34 1 8 'Cancel' 2608 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1248 0 29 1266 1312 -137 1328 -11 1344 1 1360 49 410 ##(Smalltalk.PushButton) 34 20 0 640 34 2 8 1140924416 1 2960 0 850 880 0 7 0 0 0 2960 0 8 4294908309 914 #deploy 8 '&Deploy' 1 1 0 0 false 0 0 0 962 138 144 34 3 1026 #createAt:extent: 34 2 578 19 13 578 139 49 2960 1026 #isEnabled: 8 #(false) 2960 1026 #text: 34 1 8 '&Deploy' 2960 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1248 0 29 1266 1298 #fixedParentLeft 9 1808 139 1344 1 1360 49 170 192 34 2 2960 8 'deploy' 590342 ##(Smalltalk.Rectangle) 578 11 13 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 723 578 1119 81 640 1026 #text: 34 1 8 'Buttons' 640 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 2960 1376 1824 784 2224 2608 1248 0 27 0 0 410 ##(Smalltalk.WizardCardContainer) 34 15 0 416 34 2 8 1140850688 393217 3680 0 466 31 0 7 0 0 0 3680 655878 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 3856 0 466 31 0 5 0 0 0 3856 722 170 176 34 28 410 ##(Smalltalk.StaticText) 34 16 0 3856 34 2 8 1140850944 1 3984 0 0 0 5 0 0 0 3984 0 8 4294906927 852486 ##(Smalltalk.NullConverter) 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 31 141 578 389 81 3984 1026 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 3984 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 8 #() 1248 0 27 1266 3344 31 1808 389 1344 141 1360 81 410 ##(Smalltalk.GroupBox) 34 14 0 3856 34 2 8 1140850695 65 4320 0 850 880 0 5 0 0 0 4320 0 8 4294908309 962 138 144 34 1 1026 #createAt:extent: 34 2 578 1 291 578 1155 211 4320 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 65 2 0 0 250 0 0 0] 8 #() 1248 0 27 1266 3344 1 1328 41 1344 291 1360 211 410 ##(Smalltalk.TextEdit) 34 16 0 3856 34 2 8 1140850688 262145 4592 0 850 880 0 5 0 0 0 4592 0 8 4294910065 4066 0 0 1 962 138 144 34 2 1026 #createAt:extent: 34 2 578 441 591 578 565 41 4592 1026 #isEnabled: 8 #(false) 4592 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 39 1 0 0 246 1 0 0 59 1 0 0] 8 #() 1248 0 27 1266 3344 441 1328 -109 1344 591 1360 41 410 ##(Smalltalk.ContainerView) 34 15 0 3856 34 2 8 1140850688 131073 4912 0 850 880 0 5 0 0 0 4912 610 19 1 0 0 410 ##(Smalltalk.ImageView) 34 21 0 4912 34 2 8 1140850944 1 5008 721990 2 ##(Smalltalk.ValueHolder) 0 false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 5138 #hash 8 #() 657478 3 ##(Smalltalk.OLEPicture) 0 true 1703942 ##(Smalltalk.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 524806 ##(Smalltalk.IPicture) 0 0 578 321 327 578 8467 8627 466 31 0 5 0 0 0 5008 0 8 4294902547 4066 0 0 0 5232 #scale 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1003 11 578 103 101 5008 1026 #text: 34 1 8 'Graphic' 5008 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1248 0 27 0 410 ##(Smalltalk.RichTextEdit) 34 18 0 4912 34 2 8 1140855108 1 5664 0 850 880 0 5 0 0 0 5664 0 8 1756005200 4066 0 0 41 0 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 3 1026 #createAt:extent: 34 2 578 31 11 578 955 101 5664 1026 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 2: 
\par \f1\fs16 
\par Choose an Executable File and RuntimeSessionManager\b0 
\par 
\par 
\par 
\par }
' 5664 1026 #resetCharFormat 8 #() 5664 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1248 0 27 170 192 6032 3410 578 31 11 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 121 4912 1026 #text: 34 1 8 'Heading' 4912 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 5664 5008 1248 0 27 1266 3344 1 1328 1 1344 1 1360 121 410 ##(Smalltalk.StaticText) 34 16 0 3856 34 2 8 1140850944 1 6384 0 0 0 5 0 0 0 6384 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 43 399 578 381 81 6384 1026 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 6384 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 199 0 0 0 211 0 0 0 239 0 0 0] 8 #() 1248 0 27 1266 3344 43 1808 381 1344 399 1360 81 410 ##(Smalltalk.TextEdit) 34 16 0 3856 34 2 8 1140916352 1025 6704 0 850 880 0 5 0 0 0 6704 0 8 4294910065 4066 0 0 1 962 138 144 34 1 1026 #createAt:extent: 34 2 578 431 151 578 575 41 6704 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1248 0 27 1266 3344 431 1328 -109 1344 151 1360 41 410 ##(Smalltalk.StaticText) 34 16 0 3856 34 2 8 1140850944 1 6992 0 0 0 5 0 0 0 6992 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 31 511 578 1045 81 6992 1026 #text: 34 1 8 'The deployment process can write an HTML log file that describes the stripping actions performed and lists objects remaining in the image. This can be useful for debugging subsequent deployment problems.' 6992 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 255 0 0 0 25 2 0 0 39 1 0 0] 8 #() 1248 0 27 1266 3344 31 1328 -39 1344 511 1360 81 410 ##(Smalltalk.PushButton) 34 20 0 3856 34 2 8 1140924416 1 7312 0 850 880 0 5 0 0 0 7312 0 8 4294908309 914 #showLog 8 'S&how it' 1 1 0 0 false 0 0 0 962 138 144 34 3 1026 #createAt:extent: 34 2 578 441 661 578 139 45 7312 1026 #isEnabled: 8 #(false) 7312 1026 #text: 34 1 8 'S&how it' 7312 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1248 0 29 1266 3344 441 1808 139 1344 661 1360 45 410 ##(Smalltalk.CheckBox) 34 16 0 3856 34 2 8 1140924451 1 7696 5074 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) true 850 880 0 5 0 0 0 7696 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 61 661 578 251 41 7696 1026 #text: 34 1 8 'Log &class references' 7696 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1248 0 27 1266 3344 61 1808 251 1344 661 1360 41 410 ##(Smalltalk.CheckBox) 34 16 0 3856 34 2 8 1140924451 1 8080 5074 0 0 7792 false 850 880 0 5 0 0 0 8080 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 31 211 578 431 81 8080 1026 #text: 34 1 8 'Create single file, "To Go" distributable.' 8080 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1248 0 27 1266 3344 31 1808 431 1344 211 1360 81 410 ##(Smalltalk.ComboBox) 34 17 0 3856 34 2 8 1144063491 1025 8432 590662 2 ##(Smalltalk.ListModel) 138 144 6032 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 850 880 0 5 0 0 0 8432 0 8 4294909933 ##(Smalltalk.BasicListAbstract) 6032 401 962 138 144 34 1 1026 #createAt:extent: 34 2 578 441 411 578 565 43 8432 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 205 0 0 0 246 1 0 0 226 0 0 0] 8 #() 1248 0 27 1266 3344 441 1328 -109 1344 411 1360 43 410 ##(Smalltalk.CheckBox) 34 16 0 3856 34 2 8 1140924451 1 8784 5074 0 0 7792 true 850 880 0 5 0 0 0 8784 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 61 591 578 251 41 8784 1026 #text: 34 1 8 'Write &log file' 8784 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 155 0 0 0 59 1 0 0] 8 #() 1248 0 27 1266 3344 61 1808 251 1344 591 1360 41 410 ##(Smalltalk.StaticText) 34 16 0 3856 34 2 8 1140850944 1 9136 0 0 0 5 0 0 0 9136 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 31 321 578 975 71 9136 1026 #text: 34 1 8 'When deployed, an executable will contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 9136 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 246 1 0 0 195 0 0 0] 8 #() 1248 0 27 1266 3344 31 1328 -109 1344 321 1360 71 410 ##(Smalltalk.PushButton) 34 20 0 3856 34 2 8 1140924416 1 9456 0 850 880 0 5 0 0 0 9456 0 8 4294908309 914 #browseForExecutableName 8 '...' 1 1 0 0 false 0 0 0 962 138 144 34 3 1026 #createAt:extent: 34 2 578 1025 151 578 49 41 9456 1026 #isEnabled: 8 #(false) 9456 1026 #text: 34 1 8 '...' 9456 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1248 0 29 1266 1312 -47 1328 -41 1344 151 1360 41 170 192 34 14 8784 8 'writeLogFile' 8080 8 'isToGo' 7696 8 'logReferencesToClasses' 8432 8 'runtimeSessionManagerClass' 4592 8 'logFileName' 7312 8 'showLog' 6704 8 'executableName' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 3856 1026 #text: 34 1 8 'Step 2' 3856 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 4912 3984 6704 9456 8080 9136 6384 8432 6992 8784 7696 4592 7312 4320 1248 0 27 3826 5 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 10208 0 466 31 0 5 0 0 0 10208 722 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 0 10208 34 2 8 1140850944 1025 10336 0 0 0 5 0 0 0 10336 0 8 4294906927 4066 0 0 0 962 138 144 34 1 1026 #createAt:extent: 34 2 578 361 389 578 647 41 10336 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1248 0 27 1266 3344 361 1328 -107 1344 389 1360 41 410 ##(Smalltalk.ContainerView) 34 15 0 10208 34 2 8 1140850688 131073 10608 0 850 880 0 5 0 0 0 10608 610 19 1 0 0 410 ##(Smalltalk.ImageView) 34 21 0 10608 34 2 8 1140850944 1 10704 5074 0 false 5106 5138 #= 8 #() 5138 #hash 5200 5218 0 true 5264 8 'Resources\LagoonLogo.bmp' 5312 5346 0 0 578 321 327 578 8467 8627 466 31 0 5 0 0 0 10704 0 8 4294902547 4066 0 0 0 10848 #scale 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1003 11 578 103 101 10704 1026 #text: 34 1 8 'Graphic' 10704 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1248 0 27 0 410 ##(Smalltalk.RichTextEdit) 34 18 0 10608 34 2 8 1140855108 1 11184 0 850 880 0 5 0 0 0 11184 0 8 1756005200 4066 0 0 41 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 3 1026 #createAt:extent: 34 2 578 31 11 578 955 101 11184 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 3:\f1\fs16 
\par 
\par Configure how the ImageStripper removes unwanted packages
\par \b0 
\par 
\par 
\par }
' 11184 1026 #resetCharFormat 6032 11184 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1248 0 27 170 192 6032 3410 578 31 11 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 121 10608 1026 #text: 34 1 8 'Heading' 10608 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 11184 10704 1248 0 27 1266 3344 1 1328 1 1344 1 1360 121 410 ##(Smalltalk.StaticText) 34 16 0 10208 34 2 8 1140850944 1 11856 0 0 0 5 0 0 0 11856 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 499 578 979 109 11856 1026 #text: 34 1 8 'The stripper is most efficient if it is first allowed to remove packages which it considers to be redundant. Selecting this option (recommended) will strip out any packages that are not pre-requisites of the root package above.' 11856 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -107 1344 499 1360 109 410 ##(Smalltalk.CheckBox) 34 16 0 10208 34 2 8 1140924451 1 12176 5074 0 0 7792 true 850 880 0 5 0 0 0 12176 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 59 619 578 329 49 12176 1026 #text: 34 1 8 'Strip redundant &packages' 12176 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 53 1 0 0 193 0 0 0 77 1 0 0] 8 #() 1248 0 27 1266 3344 59 1808 329 1344 619 1360 49 410 ##(Smalltalk.StaticText) 34 16 0 10208 34 2 8 1140850944 1 12528 0 0 0 5 0 0 0 12528 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 31 171 578 975 191 12528 1026 #text: 34 1 8 'The ImageStripper must be associated with a root package so it can best determine the redundant objects in the image that can be removed. Note also that the image stripper configuration is saved in this package.

Currently the stripper is set to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 12528 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1248 0 27 1266 3344 31 1328 -109 1344 171 1360 191 410 ##(Smalltalk.StaticText) 34 16 0 10208 34 2 8 1140850944 1 12848 0 0 0 5 0 0 0 12848 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 81 389 578 201 41 12848 1026 #text: 34 1 8 'Root package:' 12848 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1248 0 27 1266 3344 81 1808 201 1344 389 1360 41 170 192 34 4 12176 8 'stripRedundantPackages' 10336 8 'rootPackage' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 10208 1026 #text: 34 1 8 'Step 3' 10208 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 10608 12528 12848 10336 11856 12176 1248 0 27 3826 7 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 13456 0 466 31 0 5 0 0 0 13456 722 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 0 13456 34 2 8 1140924451 1 13584 5074 0 0 7792 false 850 880 0 5 0 0 0 13584 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 641 581 578 403 49 13584 1026 #text: 34 1 8 'Strip #shouldNot&Implement methods' 13584 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1248 0 27 1266 2208 151 1808 403 1298 #fixedPreviousTop 1 1360 49 410 ##(Smalltalk.StaticText) 34 16 0 13456 34 2 8 1140850944 1 13952 0 0 0 5 0 0 0 13952 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 149 578 1029 69 13952 1026 #text: 34 1 8 'The ImageStripper automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be stripped (recommended).' 13952 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -57 1344 149 1360 69 410 ##(Smalltalk.CheckBox) 34 16 0 13456 34 2 8 1140924451 1 14272 5074 0 0 7792 true 850 880 0 5 0 0 0 14272 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 641 217 578 403 49 14272 1026 #text: 34 1 8 'Strip redundant &resources' 14272 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1248 0 27 1266 2208 151 1808 403 13936 1 1360 49 410 ##(Smalltalk.CheckBox) 34 16 0 13456 34 2 8 1140924451 1 14624 5074 0 0 7792 false 850 880 0 5 0 0 0 14624 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 71 435 578 421 49 14624 1026 #text: 34 1 8 'Strip redundant &methods' 14624 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 217 0 0 0 245 0 0 0 241 0 0 0] 8 #() 1248 0 27 1266 3344 71 1808 421 1298 #fixedPreviousBottom 1 1360 49 410 ##(Smalltalk.CheckBox) 34 16 0 13456 34 2 8 1140924451 1 14992 5074 0 0 7792 false 850 880 0 5 0 0 0 14992 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 71 645 578 421 49 14992 1026 #text: 34 1 8 'Strip #&subclassResponsibility methods' 14992 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 66 1 0 0 245 0 0 0 90 1 0 0] 8 #() 1248 0 27 1266 3344 71 1808 421 14976 17 1360 49 410 ##(Smalltalk.ContainerView) 34 15 0 13456 34 2 8 1140850688 131073 15344 0 850 880 0 5 0 0 0 15344 610 19 1 0 0 410 ##(Smalltalk.ImageView) 34 21 0 15344 34 2 8 1140850944 1 15440 5074 0 false 5106 5138 #= 8 #() 5138 #hash 5200 5218 0 true 5264 8 'Resources\LagoonLogo.bmp' 5312 5346 0 0 578 321 327 578 8467 8627 466 31 0 5 0 0 0 15440 0 8 4294902547 4066 0 0 0 15584 #scale 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1003 11 578 103 101 15440 1026 #text: 34 1 8 'Graphic' 15440 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1248 0 27 0 410 ##(Smalltalk.RichTextEdit) 34 18 0 15344 34 2 8 1140855108 1 15920 0 850 880 0 5 0 0 0 15920 0 8 1756005200 4066 0 0 41 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 3 1026 #createAt:extent: 34 2 578 31 11 578 955 101 15920 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 4:
\par \f1\fs16 
\par \f0 Configure how the ImageStripper removes unwanted classes and methods\b0\f1 
\par 
\par 
\par 
\par }
' 15920 1026 #resetCharFormat 6032 15920 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1248 0 27 170 192 6032 3410 578 31 11 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 121 15344 1026 #text: 34 1 8 'Heading' 15344 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 15920 15440 1248 0 27 1266 3344 1 1328 1 1344 1 1360 121 410 ##(Smalltalk.StaticText) 34 16 0 13456 34 2 8 1140850944 1 16592 0 0 0 5 0 0 0 16592 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 533 578 1079 49 16592 1026 #text: 34 1 8 'Some methods which may not be marked as redundant can also be removed.' 16592 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -7 14976 51 1360 49 410 ##(Smalltalk.StaticText) 34 16 0 13456 34 2 8 1140850944 1 16912 0 0 0 5 0 0 0 16912 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 315 578 1019 121 16912 1026 #text: 34 1 8 'Given a set of classes that the ImageStripper believes should be preserved in the image it can then attempt to determine the methods that can never be called and these can then be removed. This step may inadvertently remove some methods that are only called by #perform:. Aspect setting methods are commonly called in this manner and you can opt to forcibly preserve these.' 16912 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -67 14976 51 1360 121 410 ##(Smalltalk.CheckBox) 34 16 0 13456 34 2 8 1140924451 1 17232 5074 0 0 7792 false 850 880 0 5 0 0 0 17232 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 641 435 578 403 49 17232 1026 #text: 34 1 8 'Preserve &aspect set methods' 17232 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1248 0 27 1266 2208 151 1808 403 13936 1 1360 49 410 ##(Smalltalk.CheckBox) 34 16 0 13456 34 2 8 1140924451 1 17584 5074 0 0 7792 true 850 880 0 5 0 0 0 17584 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 71 217 578 421 49 17584 1026 #text: 34 1 8 'Strip redundant &classes' 17584 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 108 0 0 0 245 0 0 0 132 0 0 0] 8 #() 1248 0 27 1266 3344 71 1808 421 14976 1 1360 49 410 ##(Smalltalk.CheckBox) 34 16 0 13456 34 2 8 1140924451 1 17936 5074 0 0 7792 false 850 880 0 5 0 0 0 17936 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 71 581 578 421 49 17936 1026 #text: 34 1 8 'Strip #&deprecated methods' 17936 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 34 1 0 0 245 0 0 0 58 1 0 0] 8 #() 1248 0 27 1266 3344 71 1808 421 14976 1 1360 49 410 ##(Smalltalk.GroupBox) 34 14 0 13456 34 2 8 1140850695 65 18288 0 850 880 0 5 0 0 0 18288 0 8 4294908309 962 138 144 34 1 1026 #createAt:extent: 34 2 578 -17 281 578 1151 229 18288 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1248 0 27 1266 3344 -17 1328 19 1344 281 1360 229 170 192 34 14 17936 8 'stripDeprecatedMethods' 13584 8 'stripShouldNotImplement' 17232 8 'preserveAspectSetters' 14992 8 'stripSubclassResponsibility' 14624 8 'stripRedundantMethods' 14272 8 'stripRedundantResources' 17584 8 'stripRedundantClasses' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 13456 1026 #text: 34 1 8 'Step 4' 13456 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 15344 13952 17584 14272 16912 14624 17232 16592 17936 13584 14992 18288 1248 0 27 3826 9 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 18928 0 466 31 0 5 0 0 0 18928 722 170 176 34 12 410 ##(Smalltalk.ContainerView) 34 15 0 18928 34 2 8 1140850688 131073 19056 0 850 880 0 5 0 0 0 19056 610 19 1 0 0 410 ##(Smalltalk.ImageView) 34 21 0 19056 34 2 8 1140850944 1 19152 5074 0 false 5106 5138 #= 8 #() 5138 #hash 5200 5218 0 true 5264 8 'Resources\LagoonLogo.bmp' 5312 5346 0 0 578 321 327 578 8467 8627 466 31 0 5 0 0 0 19152 0 8 4294902547 4066 0 0 0 19296 #scale 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1003 11 578 103 101 19152 1026 #text: 34 1 8 'Graphic' 19152 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1248 0 27 0 410 ##(Smalltalk.RichTextEdit) 34 18 0 19056 34 2 8 1140855108 1 19632 0 850 880 0 5 0 0 0 19632 0 8 1756005200 4066 0 0 41 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 3 1026 #createAt:extent: 34 2 578 31 11 578 955 101 19632 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 7:\f1\fs16 
\par 
\par Configure any additional actions using a Pre-Strip Script and Custom options
\par \b0 
\par }
' 19632 1026 #resetCharFormat 6032 19632 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1248 0 27 170 192 6032 3410 578 31 11 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 121 19056 1026 #text: 34 1 8 'Heading' 19056 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 19632 19152 1248 0 27 1266 3344 1 1328 1 1344 1 1360 121 410 ##(Smalltalk.ReferenceView) 34 14 0 18928 34 2 8 1140850688 131073 20304 0 0 0 5 0 0 0 20304 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view 0 962 138 144 34 1 1026 #createAt:extent: 34 2 578 31 321 578 1045 251 20304 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 25 2 0 0 29 1 0 0] 6032 1248 0 27 1266 3344 31 1328 -39 1344 321 1360 251 410 ##(Smalltalk.StaticText) 34 16 0 18928 34 2 8 1140850944 1 20560 0 0 0 5 0 0 0 20560 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 149 578 1047 169 20560 1026 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the stripping process starts. You can do this using the pre-stripping script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 20560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 25 2 0 0 158 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -39 1344 149 1360 169 410 ##(Smalltalk.StatusBar) 34 18 0 18928 34 2 8 1140850700 1 20880 0 466 31 0 5 0 498 0 true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 0 20880 0 8 4294905385 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 20880 0 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'preStripScriptErrors' 138 144 34 1 21088 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 20880 0 0 962 138 144 34 1 1026 #createAt:extent: 34 2 578 31 571 578 1047 41 20880 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 8 #() 1248 0 27 1266 3344 31 1328 -37 1344 571 1360 41 410 ##(Smalltalk.PushButton) 34 20 0 18928 34 2 8 1140924416 1 21392 0 850 880 0 5 0 0 0 21392 0 8 4294908309 914 #editCustomOptions 8 'Custom &Options' 1 1 0 0 false 0 0 0 962 138 144 34 3 1026 #createAt:extent: 34 2 578 881 661 578 211 51 21392 1026 #isEnabled: 8 #(false) 21392 1026 #text: 34 1 8 'Custom &Options' 21392 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1248 0 29 1266 3344 881 1808 211 1344 661 1360 51 410 ##(Smalltalk.StaticText) 34 16 0 18928 34 2 8 1140850944 1 21776 0 0 0 5 0 0 0 21776 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 31 651 578 791 71 21776 1026 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 21776 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1248 0 27 1266 3344 31 1808 791 1344 651 1360 71 170 192 34 2 20304 8 'preStripScript' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 18928 1026 #text: 34 1 8 'Step 7' 18928 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 19056 20560 20304 20880 21776 21392 1248 0 27 3826 11 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 22368 0 466 31 0 5 0 0 0 22368 722 170 176 34 18 410 ##(Smalltalk.ContainerView) 34 15 0 22368 34 2 8 1140850688 131073 22496 0 850 880 0 5 0 0 0 22496 610 19 1 0 0 410 ##(Smalltalk.ImageView) 34 21 0 22496 34 2 8 1140850944 1 22592 5074 0 false 5106 5138 #= 8 #() 5138 #hash 5200 5218 0 true 5264 8 'Resources\LagoonLogo.bmp' 5312 5346 0 0 578 321 327 578 8467 8627 466 31 0 5 0 0 0 22592 0 8 4294902547 4066 0 0 0 22736 #scale 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1003 11 578 103 101 22592 1026 #text: 34 1 8 'Graphic' 22592 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1248 0 27 0 410 ##(Smalltalk.RichTextEdit) 34 18 0 22496 34 2 8 1140855108 1 23072 0 850 880 0 5 0 0 0 23072 0 8 1756005200 4066 0 0 41 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 3 1026 #createAt:extent: 34 2 578 31 11 578 955 101 23072 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 5:\f1\fs16 
\par 
\par Decide what meta-level information is required at runtime
\par \b0 
\par 
\par 
\par }
' 23072 1026 #resetCharFormat 6032 23072 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1248 0 27 170 192 6032 3410 578 31 11 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 121 22496 1026 #text: 34 1 8 'Heading' 22496 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 23072 22592 1248 0 27 1266 3344 1 1328 1 1344 1 1360 121 410 ##(Smalltalk.StaticText) 34 16 0 22368 34 2 8 1140850944 1 23744 0 0 0 5 0 0 0 23744 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 549 578 979 89 23744 1026 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 23744 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -107 1344 549 1360 89 410 ##(Smalltalk.CheckBox) 34 16 0 22368 34 2 8 1140924451 1 24064 5074 0 0 7792 false 850 880 0 5 0 0 0 24064 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 81 459 578 369 41 24064 1026 #text: 34 1 8 'Strip class &GUIDs' 24064 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1248 0 27 1266 3344 81 1808 369 1344 459 1360 41 410 ##(Smalltalk.CheckBox) 34 16 0 22368 34 2 8 1140924451 1 24416 5074 0 0 7792 true 850 880 0 5 0 0 0 24416 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 81 249 578 369 59 24416 1026 #text: 34 1 8 'Strip class meta-&information' 24416 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1248 0 27 1266 3344 81 1808 369 1344 249 1360 59 410 ##(Smalltalk.StaticText) 34 16 0 22368 34 2 8 1140850944 1 24768 0 0 0 5 0 0 0 24768 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 149 578 979 99 24768 1026 #text: 34 1 8 'Class category information is automatically stripped from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 24768 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -107 1344 149 1360 99 410 ##(Smalltalk.StaticText) 34 16 0 22368 34 2 8 1140850944 1 25088 0 0 0 5 0 0 0 25088 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 321 578 979 69 25088 1026 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 25088 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -107 1344 321 1360 69 410 ##(Smalltalk.CheckBox) 34 16 0 22368 34 2 8 1140924451 1 25408 5074 0 0 7792 false 850 880 0 5 0 0 0 25408 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 81 389 578 369 69 25408 1026 #text: 34 1 8 'Retain instance &variable names' 25408 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1248 0 27 1266 3344 81 1808 369 1344 389 1360 69 410 ##(Smalltalk.CheckBox) 34 16 0 22368 34 2 8 1140924451 1 25760 5074 0 0 7792 false 850 880 0 5 0 0 0 25760 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 81 649 578 369 49 25760 1026 #text: 34 1 8 'Compile E&xternal Structures' 25760 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1248 0 27 1266 3344 81 1808 369 1344 649 1360 49 410 ##(Smalltalk.GroupBox) 34 14 0 22368 34 2 8 1140850695 65 26112 0 850 880 0 5 0 0 0 26112 0 8 4294908309 962 138 144 34 1 1026 #createAt:extent: 34 2 578 -17 521 578 1151 229 26112 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1248 0 27 1266 3344 -17 1328 19 1344 521 1360 229 170 192 34 8 25408 8 'retainInstVarNames' 25760 8 'compileExternalStructures' 24416 8 'stripClassInfo' 24064 8 'stripClassGuids' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 22368 1026 #text: 34 1 8 'Step 5' 22368 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 22496 24768 24416 25088 25408 24064 23744 25760 26112 1248 0 27 3826 13 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 26704 0 466 31 0 5 0 0 0 26704 722 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 0 26704 34 2 8 1140850944 1 26832 0 0 0 5 0 0 0 26832 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 641 578 995 59 26832 1026 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 26832 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 255 1 0 0 93 1 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -107 1344 641 1360 59 410 ##(Smalltalk.StaticText) 34 16 0 26704 34 2 8 1140850955 262145 27152 0 0 0 5 0 0 0 27152 0 8 4294906927 4066 0 0 0 962 138 144 34 1 1026 #createAt:extent: 34 2 578 281 269 578 753 41 27152 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 4 2 0 0 154 0 0 0] 8 #() 1248 0 27 1266 3344 281 1328 -97 1344 269 1360 41 410 ##(Smalltalk.StaticText) 34 16 0 26704 34 2 8 1140850944 1 27424 0 0 0 5 0 0 0 27424 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 81 269 578 189 49 27424 1026 #text: 34 1 8 'E&xecutable name:' 27424 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1248 0 27 1266 3344 81 1808 189 1344 269 1360 49 410 ##(Smalltalk.StaticText) 34 16 0 26704 34 2 8 1140850944 1 27744 0 0 0 5 0 498 0 true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 21008 0 27744 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 529 578 965 81 27744 1026 #text: 34 1 8 'It is very important that, should the stripping operation fail for whatever reason, you do not save the partially stripped image.' 27744 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 240 1 0 0 48 1 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -137 1344 529 1360 81 410 ##(Smalltalk.ContainerView) 34 15 0 26704 34 2 8 1140850688 131073 28112 0 850 880 0 5 0 0 0 28112 610 19 1 0 0 410 ##(Smalltalk.ImageView) 34 21 0 28112 34 2 8 1140850944 1 28208 5074 0 false 5106 5138 #= 8 #() 5138 #hash 5200 5218 0 true 5264 8 'Resources\LagoonLogo.bmp' 5312 5346 0 0 578 321 327 578 8467 8627 466 31 0 5 0 0 0 28208 0 8 4294902547 4066 0 0 0 28352 #scale 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1019 11 578 103 101 28208 1026 #text: 34 1 8 'Graphic' 28208 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 1 0 0 5 0 0 0 48 2 0 0 55 0 0 0] 8 #() 1248 0 27 0 410 ##(Smalltalk.RichTextEdit) 34 18 0 28112 34 2 8 1140855108 1 28688 0 850 880 0 5 0 0 0 28688 0 8 1756005200 4066 0 0 41 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 3 1026 #createAt:extent: 34 2 578 31 11 578 971 101 28688 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Final Step:
\par \f1\fs16 
\par Deployment\b0 
\par 
\par 
\par 
\par }
' 28688 1026 #resetCharFormat 6032 28688 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 244 1 0 0 55 0 0 0] 8 #() 1248 0 27 170 192 6032 3410 578 31 11 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1131 121 28112 1026 #text: 34 1 8 'Heading' 28112 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 53 2 0 0 60 0 0 0] 34 2 28688 28208 1248 0 27 1266 3344 1 1328 1 1344 1 1360 121 410 ##(Smalltalk.StaticText) 34 16 0 26704 34 2 8 1140850944 1 29360 0 0 0 5 0 0 0 29360 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 161 578 1005 81 29360 1026 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the image stripping options you have chosen. To do this click ''Deploy''.
' 29360 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 4 2 0 0 120 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -97 1344 161 1360 81 410 ##(Smalltalk.StaticText) 34 16 0 26704 34 2 8 1140850944 1 29680 0 0 0 5 0 498 0 true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 21008 0 29680 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 349 578 1005 139 29680 1026 #text: 34 1 8 'Your development image will first be saved in its current state. 

The stripping process that follows may take several minutes depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that image stripping is complete.' 29680 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 4 2 0 0 243 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -97 1344 349 1360 139 170 192 34 2 27152 8 'executablePath2' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 26704 1026 #text: 34 1 8 'Final step' 26704 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 28112 29360 27424 27152 27744 29680 26832 1248 0 27 3826 15 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 30320 0 850 880 0 7 0 0 0 30320 722 170 176 34 8 410 ##(Smalltalk.TextEdit) 34 16 0 30320 34 2 8 1140850816 262145 30448 0 196934 1 ##(Smalltalk.RGB) 32238571 0 7 0 0 0 30448 0 8 4294910065 4066 0 0 35 962 138 144 34 1 1026 #createAt:extent: 34 2 578 421 491 578 645 41 30448 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1248 0 27 1266 3344 421 1328 -49 14976 3 1360 41 410 ##(Smalltalk.RichTextEdit) 34 18 0 30320 34 2 8 1140855110 1 30752 0 850 880 0 7 265030 4 ##(Smalltalk.Menu) 0 true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 914 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 30882 1 914 #bePlain 8 '&Plain' 1 1 0 0 0 30882 1 914 #toggleBold 8 '&Bold' 1 1 0 0 0 30882 1 914 #toggleItalic 8 '&Italic' 1 1 0 0 0 30882 1 914 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 30946 4097 30834 0 true 34 3 30882 1 914 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 30882 1 914 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 30882 1 914 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 30946 4097 30882 1 914 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 30752 0 8 1756005200 4066 0 0 43 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 4 1026 #createAt:extent: 34 2 578 419 681 578 549 49 30752 1026 #contextMenu: 34 1 30848 30752 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click \b Next \b0 to continue.
\par 
\par 
\par \pard\qc 
\par }
' 30752 1026 #resetCharFormat 6032 30752 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1248 0 27 1266 3344 419 1808 549 1344 681 1360 49 410 ##(Smalltalk.RichTextEdit) 34 18 0 30320 34 2 8 1140855110 1 31808 0 850 880 0 7 30834 0 true 34 10 30882 1 914 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 30946 4097 30882 1 914 #bePlain 8 '&Plain' 1 1 0 0 0 30882 1 914 #toggleBold 8 '&Bold' 1 1 0 0 0 30882 1 914 #toggleItalic 8 '&Italic' 1 1 0 0 0 30882 1 914 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 30946 4097 30834 0 true 34 3 30882 1 914 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 30882 1 914 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 30882 1 914 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 30946 4097 30882 1 914 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 31808 0 8 1756005200 4066 0 0 43 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 4 1026 #createAt:extent: 34 2 578 419 1 578 649 489 31808 1026 #contextMenu: 34 1 31888 31808 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 
\par \f1\fs24 Welcome to the Dolphin Lagoon Application Deployment Wizard\f0\fs16 
\par 
\par This wizard helps you configure an ImageStripper that can be used to strip unnecessary objects from your Dolphin image and to deploy it to an executable (EXE) file. 
\par 
\par 
\par 
\par 
\par If the ImageStripper attached to this wizard has already been configured then you may immediately deploy this image to the executable file below by clicking the \b Deploy \b0 button.
\par 
\par }
' 31808 1026 #resetCharFormat 6032 31808 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1248 0 27 1266 3344 419 1328 -47 1344 1 1360 489 410 ##(Smalltalk.ImageView) 34 21 0 30320 34 2 8 1140850944 1 32816 5074 0 false 5106 5138 #= 8 #() 5138 #hash 5200 5218 0 true 5264 8 'Resources\LagoonSideBar.jpg' 5312 5346 0 0 578 381 761 578 10055 20109 850 880 0 7 0 0 0 32816 0 8 4294902547 4066 0 0 0 32960 #centered 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 379 741 32816 1026 #text: 34 1 8 'Lagoon Graphic' 32816 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1248 0 27 1266 3344 1 1808 379 1344 1 1360 741 170 192 34 2 30448 8 'executablePath1' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 30320 1026 #text: 34 1 8 'Intro' 30320 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 32816 31808 30448 30752 1248 0 27 3826 17 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 33584 0 466 31 0 5 0 0 0 33584 722 170 176 34 8 410 ##(Smalltalk.StaticText) 34 16 0 33584 34 2 8 1140850944 1 33712 0 0 0 5 0 0 0 33712 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 229 578 979 149 33712 1026 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33712 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -107 1344 229 1360 149 410 ##(Smalltalk.StaticText) 34 16 0 33584 34 2 8 1140850944 1 34032 0 0 0 5 0 0 0 34032 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 81 401 578 249 121 34032 1026 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 34032 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1248 0 27 1266 3344 81 1808 249 1344 401 1360 121 410 ##(Smalltalk.ContainerView) 34 15 0 33584 34 2 8 1140850688 131073 34352 0 850 880 0 5 0 0 0 34352 610 19 1 0 0 410 ##(Smalltalk.ImageView) 34 21 0 34352 34 2 8 1140850944 1 34448 5074 0 false 5106 5138 #= 8 #() 5138 #hash 5200 5218 0 true 5264 8 'Resources\LagoonLogo.bmp' 5312 5346 0 0 578 321 327 578 8467 8627 466 31 0 5 0 0 0 34448 0 8 4294902547 4066 0 0 0 34592 #scale 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1003 11 578 103 101 34448 1026 #text: 34 1 8 'Graphic' 34448 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1248 0 27 0 410 ##(Smalltalk.RichTextEdit) 34 18 0 34352 34 2 8 1140855108 1 34928 0 850 880 0 5 0 0 0 34928 0 8 1756005200 4066 0 0 41 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 3 1026 #createAt:extent: 34 2 578 31 11 578 955 101 34928 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 1:\f1\fs16 
\par 
\par Choose an ImageStripper to perform the deployment process\b0 
\par 
\par 
\par 
\par }
' 34928 1026 #resetCharFormat 6032 34928 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1248 0 27 170 192 6032 3410 578 31 11 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 121 34352 1026 #text: 34 1 8 'Heading' 34352 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 34928 34448 1248 0 27 1266 3344 1 1328 1 1344 1 1360 121 410 ##(Smalltalk.ComboBox) 34 17 0 33584 34 2 8 1144063491 1025 35600 8498 138 144 6032 0 8560 850 880 0 5 0 0 0 35600 0 8 4294909933 ##(Smalltalk.BasicListAbstract) 6032 401 962 138 144 34 1 1026 #createAt:extent: 34 2 578 349 409 578 647 43 35600 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1248 0 27 1266 3344 349 1328 -119 1344 409 1360 41 170 192 34 2 35600 8 'imageStripperClass' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 33584 1026 #text: 34 1 8 'Step 1' 33584 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 34352 33712 34032 35600 1248 0 27 3826 19 410 ##(Smalltalk.ContainerView) 34 15 0 3680 34 2 8 1140850688 131073 36176 0 466 31 0 5 0 0 0 36176 722 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 0 36176 34 2 8 1140850944 1 36304 0 0 0 5 0 0 0 36304 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 31 391 578 967 49 36304 1026 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 36304 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1248 0 27 1266 3344 31 1328 -117 1344 391 1360 49 410 ##(Smalltalk.CheckBox) 34 16 0 36176 34 2 8 1140924451 1 36624 5074 0 0 7792 true 850 880 0 5 0 0 0 36624 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 71 451 578 379 49 36624 1026 #text: 34 1 8 'Fold duplicate s&trings' 36624 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1248 0 27 1266 3344 71 1808 379 1344 451 1360 49 410 ##(Smalltalk.CheckBox) 34 16 0 36176 34 2 8 1140924451 1 36976 5074 0 0 7792 false 850 880 0 5 0 0 0 36976 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 81 209 578 369 41 36976 1026 #text: 34 1 8 'Strip &Class Builder' 36976 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1248 0 27 1266 3344 81 1808 369 1344 209 1360 41 410 ##(Smalltalk.GroupBox) 34 14 0 36176 34 2 8 1140850695 65 37328 0 850 880 0 5 0 0 0 37328 0 8 4294908309 962 138 144 34 1 1026 #createAt:extent: 34 2 578 1 327 578 1115 393 37328 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1248 0 27 1266 3344 1 1328 1 1344 327 1360 393 410 ##(Smalltalk.CheckBox) 34 16 0 36176 34 2 8 1140924451 1 37600 5074 0 0 7792 true 850 880 0 5 0 0 0 37600 0 8 4294908309 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 71 511 578 379 41 37600 1026 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 37600 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1248 0 27 1266 3344 71 1808 379 1344 511 1360 41 410 ##(Smalltalk.StaticText) 34 16 0 36176 34 2 8 1140850944 1 37952 0 0 0 5 0 0 0 37952 0 8 4294906927 4066 0 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 29 161 578 989 49 37952 1026 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 37952 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1248 0 27 1266 3344 29 1328 -97 1344 161 1360 49 410 ##(Smalltalk.ContainerView) 34 15 0 36176 34 2 8 1140850688 131073 38272 0 850 880 0 5 0 0 0 38272 610 19 1 0 0 410 ##(Smalltalk.ImageView) 34 21 0 38272 34 2 8 1140850944 1 38368 5074 0 false 5106 5138 #= 8 #() 5138 #hash 5200 5218 0 true 5264 8 'Resources\LagoonLogo.bmp' 5312 5346 0 0 578 321 327 578 8467 8627 466 31 0 5 0 0 0 38368 0 8 4294902547 4066 0 0 0 38512 #scale 1 0 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1003 11 578 103 101 38368 1026 #text: 34 1 8 'Graphic' 38368 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1248 0 27 0 410 ##(Smalltalk.RichTextEdit) 34 18 0 38272 34 2 8 1140855108 1 38848 0 850 880 0 5 0 0 0 38848 0 8 1756005200 4066 0 0 41 0 5778 8 #[0 0 0 0 0 0 0 0 176 0 253 3] 962 138 144 34 3 1026 #createAt:extent: 34 2 578 31 11 578 955 101 38848 1026 #text: 34 1 5970 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 6:\f1\fs16 
\par 
\par Miscellaneous stripping options\b0 
\par 
\par 
\par 
\par }
' 38848 1026 #resetCharFormat 6032 38848 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1248 0 27 170 192 6032 3410 578 31 11 578 11 11 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 121 38272 1026 #text: 34 1 8 'Heading' 38272 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 38848 38368 1248 0 27 1266 3344 1 1328 1 1344 1 1360 121 170 192 34 6 36624 8 'stripDuplicateStrings' 37600 8 'stripDuplicateBytecodes' 36976 8 'stripClassBuilder' 0 962 138 144 34 2 1026 #createAt:extent: 34 2 578 1 1 578 1115 719 36176 1026 #text: 34 1 8 'Step 6' 36176 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 38272 37952 36976 36304 36624 37600 37328 1248 0 27 30320 170 192 34 2 30320 8 'Intro' 0 962 138 144 34 1 1026 #createAt:extent: 34 2 578 1 1 578 1119 723 3680 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 30320 33584 3856 10208 13456 22368 36176 18928 26704 1248 0 27 170 192 34 2 3680 8 'Steps' 3410 578 1 1 578 1 1 0 0 0 0 3 0 0 578 2049 881 578 1151 881 1 0 0 590598 ##(Smalltalk.Semaphore) 0 0 1 false 8 2008621888 962 138 144 34 3 1026 #createAt:extent: 34 2 578 3839 21 578 1151 881 416 1026 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1026 #updateMenuBar 6032 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 190 9 0 0 194 1 0 0] 34 2 3680 640 1248 0 27 )!

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

	^SmalltalkSystemIcon showModal: self description: self displayString!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
	Un-register the system tools folder icon for the receiver.

		self uninitialize

	Note: This method is in the 'must strip' category so that it is removed in the early
	stages of image stripping. It is not required during stripping, because the system
	folders are cleared down anyway, and it may generate an error if required parts
	of the development system have already been removed.
	"

	Smalltalk developmentSystem unregisterTool: self! !
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
!ApplicationDeploymentWizard class categoriesFor: #uninitialize!development!initializing!private! !

