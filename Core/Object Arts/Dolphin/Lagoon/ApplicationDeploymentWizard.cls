"Filed out from Dolphin Smalltalk"!

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

!ApplicationDeploymentWizard categoriesForMethods!
accept!commands!public! !
addToCommandRoute:!commands!public! !
apply!commands!public! !
browseForExecutableName!commands!public! !
canDeploy!public!testing! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultExtension!constants!private! !
deployApplication!commands!public! !
exeFileTypes!constants!private! !
hasExistingLog!public!testing! !
hasLog!public!testing! !
help!commands!public! !
model:!accessing!public! !
onExecutableNameChanged!event handling!private! !
onImageStripperClassChanged!event handling!private! !
onViewOpened!event handling!public! !
queryCommand:!commands!private! !
refreshContents!accessing!private! !
reset!commands!public! !
sessionManagerOrShellChoices!accessing!private! !
showLog!commands!public! !
strip!commands!private! !
validateUserInterface!operations!public! !
!

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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 608 nil nil nil 7 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 736 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 736 nil 8 1962759008 1180998 4 ##(Smalltalk.CommandDescription) #reset 8 '&Reset' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 193 768 8 '&Reset' 736 962 #isEnabled: 8 #(false) 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -129 1218 #fixedParentRight -429 1218 #fixedParentTop 1 1218 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1296 nil 816 nil 7 nil nil nil 1296 nil 8 1962759008 850 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 193 1328 8 '< &Back' 1296 962 #isEnabled: 8 #(false) 1296 3 8 #() 1154 193 193 nil 29 1186 1218 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1218 #fixedViewLeft 131 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1696 nil 816 nil 7 nil nil nil 1696 nil 8 1962759008 850 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 193 1728 8 '&Save Configuration' 1696 962 #isEnabled: 8 #(false) 1696 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedPreviousRight 11 1680 241 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2048 nil 816 nil 7 nil nil nil 2048 nil 8 1962759008 850 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 193 2080 8 '&Next >' 2048 962 #isEnabled: 8 #(false) 2048 3 8 #() 1154 193 193 nil 29 1186 2032 11 1680 131 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2384 nil 816 nil 7 nil nil nil 2384 nil 8 1962759008 850 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 193 2416 8 '&Deploy' 2384 962 #isEnabled: 8 #(false) 2384 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedParentLeft 9 1680 139 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2736 nil 816 nil 7 nil nil nil 2736 nil 8 1962759008 850 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 193 2768 8 'Cancel' 2736 3 8 #() 1154 193 193 nil 29 1186 1232 -137 1248 -11 1264 1 1280 49 170 192 34 2 2384 8 'deploy' 590342 ##(Smalltalk.Rectangle) 1154 11 13 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 193 640 8 'Buttons' 608 3 34 6 2384 1296 2048 736 1696 2736 1154 193 193 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3328 nil nil nil 7 nil nil nil 3328 656710 1 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 3488 nil nil nil 5 nil nil nil 3488 674 170 176 34 28 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 3600 nil nil nil 5 nil nil nil 3600 nil 8 1962964032 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[21 0 0 0 187 0 0 0 238 0 0 0 219 0 0 0] 193 3632 nil 3600 962 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 3600 3 8 #() 1154 193 193 nil 27 1186 2720 43 1680 435 1264 375 1280 65 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 3936 nil nil nil 5 nil nil nil 3936 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 148 0 0 0 23 2 0 0 183 0 0 0] 193 3968 nil 3936 962 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 3936 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -43 1264 297 1280 71 410 ##(Smalltalk.ContainerView) 34 15 nil 3488 34 2 8 1140850688 131073 4256 nil 816 nil 5 nil nil nil 4256 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 4256 34 2 8 1140850944 1 4336 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4466 #hash 8 #() 787206 ##(Smalltalk.GdiplusImage) nil true 2032390 ##(Smalltalk.GdiplusImageFromFileInitializer) nil 8 'Resources\LagoonLogo.bmp' 1703942 ##(Smalltalk.InstallRelativeFileLocator) 802 #face3d nil 5 nil nil nil 4336 nil 8 4294902547 3682 nil nil nil 4560 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 4368 nil 4336 962 #text: 34 1 8 'Graphic' 4336 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 4256 34 2 8 1140855108 1 4912 nil 816 nil 5 nil nil nil 4912 nil 8 1463894896 3682 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 4944 nil 4912 962 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 2: \par
\par
Choose an Executable File and RuntimeSessionManager\par
\par
\par
\par
}
' 4912 962 #textLimit: 8 #(1073741823) 4912 962 #resetCharFormat 8 #() 4912 3 8 #() 1154 193 193 nil 27 170 192 5312 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 4288 8 'Heading' 4256 3 34 2 4912 4336 1154 193 193 nil 27 1186 2720 1 1248 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 5616 4402 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 517 nil nil nil 5616 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 108 0 0 0 231 0 0 0 133 0 0 0] 193 5648 8 'Create single file, "To Go" distributable.' 5616 3 8 #() 1154 193 193 nil 27 1186 2720 33 1680 431 1264 217 1280 51 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140916352 1025 5952 nil 816 nil 5 nil nil nil 5952 nil 8 1962751712 3682 nil nil 1 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 193 5984 nil 5952 962 #setMarginWidths: 34 1 8 #(3 3) 5952 3 8 #() 1154 193 193 nil 27 1186 2720 431 1248 -109 1264 151 1280 41 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140850688 262145 6272 nil nil nil 5 nil nil nil 6272 nil 8 1962751712 3682 nil nil 1 898 138 144 34 3 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 193 6304 nil 6272 962 #isEnabled: 8 #(false) 6272 962 #setMarginWidths: 34 1 8 #(3 3) 6272 3 8 #() 1154 193 193 nil 27 1186 2720 441 1248 -109 1264 597 1280 41 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 6624 nil 816 nil 5 nil nil nil 6624 nil 8 1962759008 850 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 70 1 0 0 33 1 0 0 92 1 0 0] 193 6656 8 'S&how it' 6624 962 #isEnabled: 8 #(false) 6624 3 8 #() 1154 193 193 nil 29 1186 2720 441 1680 139 1264 653 1280 45 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 6960 nil nil nil 5 nil nil nil 6960 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 193 6992 nil 6960 962 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 6960 3 8 #() 1154 193 193 nil 27 1186 2720 31 1680 389 1264 141 1280 81 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 7280 4402 nil nil 5712 true nil nil 5 nil nil nil 7280 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 193 7312 8 'Write &log file' 7280 3 8 #() 1154 193 193 nil 27 1186 2720 61 1680 251 1264 597 1280 41 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 7584 nil 816 nil 5 nil nil nil 7584 nil 8 1962759008 850 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 193 7616 8 '...' 7584 962 #isEnabled: 8 #(false) 7584 3 8 #() 1154 193 193 nil 29 1186 1232 -47 1248 -41 1264 151 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 7920 nil nil nil 5 nil nil nil 7920 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 241 0 0 0 24 2 0 0 30 1 0 0] 193 7952 nil 7920 962 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 7920 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -41 1264 483 1280 91 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 8240 4402 nil nil 5712 true nil nil 5 nil nil nil 8240 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 70 1 0 0 155 0 0 0 90 1 0 0] 193 8272 8 'Log &class references' 8240 3 8 #() 1154 193 193 nil 27 1186 2720 61 1680 251 1264 653 1280 41 410 ##(Smalltalk.GroupBox) 34 14 nil 3488 34 2 8 1140850695 65 8544 nil 816 nil 5 nil nil nil 8544 nil 8 1962759008 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[1 0 0 0 133 0 0 0 44 2 0 0 233 0 0 0] 193 8576 8 '' 8544 3 8 #() 1154 193 193 nil 27 1186 2720 3 1248 -1 1264 267 1280 201 410 ##(Smalltalk.ComboBox) 34 17 nil 3488 34 2 8 1144063491 1025 8816 590662 2 ##(Smalltalk.ListModel) 138 144 5312 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 816 nil 5 nil nil nil 8816 nil 8 1962368288 ##(Smalltalk.BasicListAbstract) 8 #() 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 0 0 0 192 0 0 0 247 1 0 0 156 1 0 0] 193 8848 8 '' 8816 3 8 #() 1154 193 193 nil 27 1186 2720 495 1248 -107 1264 385 1280 47 170 192 34 14 5952 8 'executableName' 6624 8 'showLog' 8816 8 'runtimeSessionManagerClass' 5616 8 'isToGo' 8240 8 'logReferencesToClasses' 7280 8 'writeLogFile' 6272 8 'logFileName' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 3520 8 'Step 2' 3488 1 34 14 4256 6960 5952 7584 5616 3936 3600 8816 7920 7280 8240 6272 6624 8544 1154 193 193 nil 27 3458 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 9520 nil nil nil 5 nil nil nil 9520 674 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 9632 nil nil nil 5 nil nil nil 9632 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 193 9664 nil 9632 962 #text: 34 1 8 'Root package:' 9632 3 8 #() 1154 193 193 nil 27 1186 2720 81 1680 201 1264 389 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 9520 34 2 8 1140924451 1 9952 4402 nil nil 5712 true nil nil 5 nil nil nil 9952 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 193 9984 8 'Remove redundant &packages' 9952 3 8 #() 1154 193 193 nil 27 1186 2720 59 1680 329 1264 599 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 262145 10256 nil nil nil 5 nil nil nil 10256 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 193 10288 nil 10256 962 #text: 34 1 8 '' 10256 3 8 #() 1154 193 193 nil 27 1186 2720 361 1248 -107 1264 389 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 10576 nil nil nil 5 nil nil nil 10576 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 193 10608 nil 10576 962 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10576 3 8 #() 1154 193 193 nil 27 1186 2720 29 1248 -107 1264 499 1280 109 410 ##(Smalltalk.ContainerView) 34 15 nil 9520 34 2 8 1140850688 131073 10896 nil 816 nil 5 nil nil nil 10896 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 10896 34 2 8 1140850944 1 10976 4402 nil false 4434 4466 #= 8 #() 4466 #hash 4528 4546 nil true 4578 nil 8 'Resources\LagoonLogo.bmp' 4640 4656 nil 5 nil nil nil 10976 nil 8 4294902547 3682 nil nil nil 11120 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 11008 nil 10976 962 #text: 34 1 8 'Graphic' 10976 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 10896 34 2 8 1140855108 1 11408 nil 816 nil 5 nil nil nil 11408 nil 8 1463894896 3682 nil nil 41 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 11440 nil 11408 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 3:\par
\par
Configure how the ImageStripper removes unwanted packages\par
\par
\par
\par
}
' 11408 962 #textLimit: 8 #(1073741823) 11408 962 #resetCharFormat 5312 11408 3 8 #() 1154 193 193 nil 27 170 192 5312 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 10928 8 'Heading' 10896 3 34 2 11408 10976 1154 193 193 nil 27 1186 2720 1 1248 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 12064 nil nil nil 5 nil nil nil 12064 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 193 12096 nil 12064 962 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 12064 3 8 #() 1154 193 193 nil 27 1186 2720 31 1248 -109 1264 171 1280 191 170 192 34 4 9952 8 'stripRedundantPackages' 10256 8 'rootPackage' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 9552 8 'Step 3' 9520 1 34 6 10896 12064 9632 10256 10576 9952 1154 193 193 nil 27 3458 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 12640 nil nil nil 5 nil nil nil 12640 674 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 12752 4402 nil nil 5712 true nil nil 5 nil nil nil 12752 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 193 12784 8 'Remove redundant &classes' 12752 3 8 #() 1154 193 193 nil 27 1186 2720 61 1680 441 1218 #fixedPreviousBottom 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 13072 nil nil nil 5 nil nil nil 13072 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 193 13104 nil 13072 962 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 13072 3 8 #() 1154 193 193 nil 27 1186 2720 29 1248 -57 1264 149 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13392 4402 nil nil 5712 false nil nil 5 nil nil nil 13392 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 36 1 0 0 250 0 0 0 60 1 0 0] 193 13424 8 'Remove #&deprecated methods' 13392 3 8 #() 1154 193 193 nil 27 1186 2720 61 1680 441 13056 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13696 4402 nil nil 5712 true nil nil 5 nil nil nil 13696 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 193 13728 8 'Remove redundant &resources' 13696 3 8 #() 1154 193 193 nil 27 1186 2032 121 1680 423 1218 #fixedPreviousTop 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14016 4402 nil nil 5712 false nil nil 5 nil nil nil 14016 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 193 14048 8 'Remove #&subclassResponsibility methods' 14016 3 8 #() 1154 193 193 nil 27 1186 2720 61 1680 441 13056 13 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14320 4402 nil nil 5712 false nil nil 5 nil nil nil 14320 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 220 0 0 0 250 0 0 0 244 0 0 0] 193 14352 8 'Remove redundant &methods' 14320 3 8 #() 1154 193 193 nil 27 1186 2720 61 1680 441 13056 7 1280 49 410 ##(Smalltalk.GroupBox) 34 14 nil 12640 34 2 8 1140850695 65 14624 nil 816 nil 5 nil nil nil 14624 nil 8 1962759008 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 193 14656 8 '' 14624 3 8 #() 1154 193 193 nil 27 1186 2720 -17 1248 19 1264 281 1280 229 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14896 4402 nil nil 5712 false nil nil 5 nil nil nil 14896 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 220 0 0 0 9 2 0 0 244 0 0 0] 193 14928 8 'Preserve &aspect set methods' 14896 3 8 #() 1154 193 193 nil 27 1186 2032 121 1680 423 14000 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 15200 nil nil nil 5 nil nil nil 15200 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 157 0 0 0 29 2 0 0 217 0 0 0] 193 15232 nil 15200 962 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 15200 3 8 #() 1154 193 193 nil 27 1186 2720 29 1248 -31 13056 51 1280 121 410 ##(Smalltalk.ContainerView) 34 15 nil 12640 34 2 8 1140850688 131073 15520 nil 816 nil 5 nil nil nil 15520 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 15520 34 2 8 1140850944 1 15600 4402 nil false 4434 4466 #= 8 #() 4466 #hash 4528 4546 nil true 4578 nil 8 'Resources\LagoonLogo.bmp' 4640 4656 nil 5 nil nil nil 15600 nil 8 4294902547 3682 nil nil nil 15744 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 15632 nil 15600 962 #text: 34 1 8 'Graphic' 15600 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 15520 34 2 8 1140855108 1 16032 nil 816 nil 5 nil nil nil 16032 nil 8 1463894896 3682 nil nil 41 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 16064 nil 16032 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 4:\par
\par
Configure how the ImageStripper removes unwanted classes and methods\par
\par
\par
\par
}
' 16032 962 #textLimit: 8 #(1073741823) 16032 962 #resetCharFormat 5312 16032 3 8 #() 1154 193 193 nil 27 170 192 5312 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 15552 8 'Heading' 15520 3 34 2 16032 15600 1154 193 193 nil 27 1186 2720 1 1248 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 16688 4402 nil nil 5712 false nil nil 5 nil nil nil 16688 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 36 1 0 0 9 2 0 0 60 1 0 0] 193 16720 8 'Remove #shouldNot&Implement methods' 16688 3 8 #() 1154 193 193 nil 27 1186 2032 121 1680 423 14000 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 16992 nil nil nil 5 nil nil nil 16992 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 12 1 0 0 41 2 0 0 36 1 0 0] 193 17024 nil 16992 962 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 16992 3 8 #() 1154 193 193 nil 27 1186 2720 29 1248 -7 13056 49 1280 49 170 192 34 14 12752 8 'stripRedundantClasses' 14016 8 'stripSubclassResponsibility' 13392 8 'stripDeprecatedMethods' 16688 8 'stripShouldNotImplement' 14896 8 'preserveAspectSetters' 14320 8 'stripRedundantMethods' 13696 8 'stripRedundantResources' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 12672 8 'Step 4' 12640 1 34 12 15520 13072 12752 13696 15200 14320 14896 16992 13392 16688 14016 14624 1154 193 193 nil 27 3458 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 17648 nil nil nil 5 nil nil nil 17648 674 170 176 34 12 410 ##(Smalltalk.ReferenceView) 34 14 nil 17648 34 2 8 1140850688 131073 17760 nil nil nil 5 nil nil nil 17760 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 163 0 0 0 24 2 0 0 27 1 0 0] 193 17792 8 '' 17760 3 5312 1154 193 193 nil 27 1186 2720 33 1248 -41 1264 327 1280 241 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 18032 nil nil nil 5 nil nil nil 18032 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 63 1 0 0 154 1 0 0 98 1 0 0] 193 18064 nil 18032 962 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 18032 3 8 #() 1154 193 193 nil 27 1186 2720 31 1680 791 1264 639 1280 71 410 ##(Smalltalk.ContainerView) 34 15 nil 17648 34 2 8 1140850688 131073 18352 nil 816 nil 5 nil nil nil 18352 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 18352 34 2 8 1140850944 1 18432 4402 nil false 4434 4466 #= 8 #() 4466 #hash 4528 4546 nil true 4578 nil 8 'Resources\LagoonLogo.bmp' 4640 4656 nil 5 nil nil nil 18432 nil 8 4294902547 3682 nil nil nil 18576 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 18464 nil 18432 962 #text: 34 1 8 'Graphic' 18432 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 18352 34 2 8 1140855108 1 18864 nil 816 nil 5 nil nil nil 18864 nil 8 1463894896 3682 nil nil 41 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 18896 nil 18864 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 7:\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\par
}
' 18864 962 #textLimit: 8 #(1073741823) 18864 962 #resetCharFormat 5312 18864 3 8 #() 1154 193 193 nil 27 170 192 5312 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 18384 8 'Heading' 18352 3 34 2 18864 18432 1154 193 193 nil 27 1186 2720 1 1248 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 19520 nil nil nil 5 nil nil nil 19520 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 66 0 0 0 24 2 0 0 156 0 0 0] 193 19552 nil 19520 962 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 19520 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -41 1264 133 1280 181 410 ##(Smalltalk.StatusBar) 34 21 nil 17648 34 2 8 1140850700 1 19840 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 19840 nil 8 1962556608 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 19840 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'preStripScriptErrors' nil nil nil 138 144 34 1 20016 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 19840 nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 193 19872 8 '' 19840 3 8 #() 1154 193 193 nil 29 1186 2720 31 1248 -37 1264 571 1280 41 410 ##(Smalltalk.PushButton) 34 20 nil 17648 34 2 8 1140924416 1 20304 nil 816 nil 5 nil nil nil 20304 nil 8 1962759008 850 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[184 1 0 0 67 1 0 0 33 2 0 0 92 1 0 0] 193 20336 8 'Custom &Options' 20304 962 #isEnabled: 8 #(false) 20304 3 8 #() 1154 193 193 nil 29 1186 2720 881 1680 211 1264 647 1280 51 170 192 34 2 17760 8 'preStripScript' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 17680 8 'Step 7' 17648 1 34 6 18352 19520 17760 19840 18032 20304 1154 193 193 nil 27 3458 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 20880 nil nil nil 5 nil nil nil 20880 674 170 176 34 18 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 20992 4402 nil nil 5712 false nil nil 5 nil nil nil 20992 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 193 21024 8 'Remove class &GUIDs' 20992 3 8 #() 1154 193 193 nil 27 1186 2720 81 1680 369 1264 459 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 21296 nil nil nil 5 nil nil nil 21296 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 73 0 0 0 24 2 0 0 123 0 0 0] 193 21328 nil 21296 962 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 21296 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -41 1264 147 1280 101 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 21616 4402 nil nil 5712 false nil nil 5 nil nil nil 21616 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 193 21648 8 'Retain instance &variable names' 21616 3 8 #() 1154 193 193 nil 27 1186 2720 81 1680 369 1264 389 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 21920 4402 nil nil 5712 true nil nil 5 nil nil nil 21920 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 193 21952 8 'Remove class meta-&information' 21920 3 8 #() 1154 193 193 nil 27 1186 2720 81 1680 369 1264 249 1280 59 410 ##(Smalltalk.GroupBox) 34 14 nil 20880 34 2 8 1140850695 65 22224 nil 816 nil 5 nil nil nil 22224 nil 8 1962759008 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 193 22256 8 '' 22224 3 8 #() 1154 193 193 nil 27 1186 2720 -17 1248 19 1264 521 1280 229 410 ##(Smalltalk.ContainerView) 34 15 nil 20880 34 2 8 1140850688 131073 22496 nil 816 nil 5 nil nil nil 22496 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 22496 34 2 8 1140850944 1 22576 4402 nil false 4434 4466 #= 8 #() 4466 #hash 4528 4546 nil true 4578 nil 8 'Resources\LagoonLogo.bmp' 4640 4656 nil 5 nil nil nil 22576 nil 8 4294902547 3682 nil nil nil 22720 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 22608 nil 22576 962 #text: 34 1 8 'Graphic' 22576 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 22496 34 2 8 1140855108 1 23008 nil 816 nil 5 nil nil nil 23008 nil 8 1463894896 3682 nil nil 41 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 23040 nil 23008 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 5:\par
\par
Decide what meta-level information is required at runtime\par
\par
\par
\par
}
' 23008 962 #textLimit: 8 #(1073741823) 23008 962 #resetCharFormat 5312 23008 3 8 #() 1154 193 193 nil 27 170 192 5312 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 22528 8 'Heading' 22496 3 34 2 23008 22576 1154 193 193 nil 27 1186 2720 1 1248 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 23664 4402 nil nil 5712 false nil nil 5 nil nil nil 23664 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 62 1 0 0 224 0 0 0 86 1 0 0] 193 23696 8 'Compile E&xternal Structures' 23664 3 8 #() 1154 193 193 nil 27 1186 2720 81 1680 369 1264 637 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 23968 nil nil nil 5 nil nil nil 23968 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 158 0 0 0 24 2 0 0 193 0 0 0] 193 24000 nil 23968 962 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 23968 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -41 1264 317 1280 71 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 24288 nil nil nil 5 nil nil nil 24288 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 17 1 0 0 19 2 0 0 62 1 0 0] 193 24320 nil 24288 962 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 24288 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -51 1264 547 1280 91 170 192 34 8 20992 8 'stripClassGuids' 21616 8 'retainInstVarNames' 23664 8 'compileExternalStructures' 21920 8 'stripClassInfo' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 20912 8 'Step 5' 20880 1 34 9 22496 21296 21920 23968 21616 20992 24288 23664 22224 1154 193 193 nil 27 3458 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 24896 nil nil nil 5 nil nil nil 24896 674 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 25008 nil nil nil 5 nil nil nil 25008 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 57 1 0 0 14 2 0 0 87 1 0 0] 193 25040 nil 25008 962 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 25008 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -61 1264 627 1280 61 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850955 262145 25328 nil nil nil 5 nil nil nil 25328 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[140 0 0 0 129 0 0 0 252 1 0 0 149 0 0 0] 193 25360 nil 25328 962 #text: 34 1 8 '' 25328 3 8 #() 1154 193 193 nil 27 1186 2720 281 1248 -97 1264 259 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 25648 nil nil nil 5 nil nil nil 25648 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 78 0 0 0 14 2 0 0 118 0 0 0] 193 25680 nil 25648 962 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 25648 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -61 1264 157 1280 81 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 25968 nil nil nil 5 nil nil nil 25968 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 173 0 0 0 14 2 0 0 236 0 0 0] 193 26000 nil 25968 962 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 25968 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -61 1264 347 1280 127 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 26288 nil nil nil 5 nil nil nil 26288 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 129 0 0 0 134 0 0 0 153 0 0 0] 193 26320 nil 26288 962 #text: 34 1 8 'E&xecutable name:' 26288 3 8 #() 1154 193 193 nil 27 1186 2720 81 1680 189 1264 259 1280 49 410 ##(Smalltalk.ContainerView) 34 15 nil 24896 34 2 8 1140850688 131073 26608 nil 816 nil 5 nil nil nil 26608 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 26608 34 2 8 1140850944 1 26688 4402 nil false 4434 4466 #= 8 #() 4466 #hash 4528 4546 nil true 4578 nil 8 'Resources\LagoonLogo.bmp' 4640 4656 nil 5 nil nil nil 26688 nil 8 4294902547 3682 nil nil nil 26832 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 26720 nil 26688 962 #text: 34 1 8 'Graphic' 26688 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 26608 34 2 8 1140855108 1 27120 nil 816 nil 5 nil nil nil 27120 nil 8 1463894896 3682 nil nil 41 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 27152 nil 27120 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Final Step:\par
\par
Deployment\par
\par
\par
\par
}
' 27120 962 #textLimit: 8 #(1073741823) 27120 962 #resetCharFormat 5312 27120 3 8 #() 1154 193 193 nil 27 170 192 5312 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 26640 8 'Heading' 26608 3 34 2 27120 26688 1154 193 193 nil 27 1186 2720 1 1248 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 27776 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 27776 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 250 0 0 0 14 2 0 0 44 1 0 0] 193 27808 nil 27776 962 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 27776 3 8 #() 1154 193 193 nil 27 1186 2720 33 1248 -61 1264 501 1280 101 170 192 34 2 25328 8 'executablePath2' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 24928 8 'Final step' 24896 1 34 7 26608 25648 26288 25328 27776 25968 25008 1154 193 193 nil 27 3458 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 28384 nil 816 nil 7 nil nil nil 28384 674 170 176 34 8 410 ##(Smalltalk.ImageView) 34 21 nil 28384 34 2 8 1140850944 1 28496 4402 nil false 4434 4466 #= 8 #() 4466 #hash 4528 4546 nil true 4578 nil 8 'Resources\LagoonSideBar.jpg' 4640 816 nil 7 nil nil nil 28496 nil 8 4294902547 3682 nil nil nil 28640 #scaleToFit 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 193 28528 nil 28496 962 #text: 34 1 8 'Lagoon Graphic' 28496 3 8 #() 1154 193 193 nil 27 1186 2720 1 1680 379 1264 1 1280 741 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28384 34 2 8 1140855110 1 28944 nil 816 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 29058 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 29058 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 29058 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29058 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29122 4097 29010 nil true 34 3 29058 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29058 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29058 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29122 4097 29058 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28944 nil 8 1463894896 3682 nil nil 43 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 193 28976 nil 28944 962 #contextMenu: 34 1 29024 28944 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16\par
Welcome to the Dolphin Lagoon Application Deployment Wizard\par
\par
This wizard helps you configure an ImageStripper that can be used to strip unnecessary objects from your Dolphin image and to deploy it to an executable (EXE) file. \par
\par
\par
\par
\par
If the ImageStripper attached to this wizard has already been configured then you may immediately deploy this image to the executable file below by clicking the Deploy button.\par
\par
}
' 28944 962 #textLimit: 8 #(1073741823) 28944 962 #resetCharFormat 5312 28944 3 8 #() 1154 193 193 nil 27 1186 2720 419 1248 -47 1264 1 1280 489 410 ##(Smalltalk.TextEdit) 34 16 nil 28384 34 2 8 1140850816 262145 30016 nil 802 #whiteSmoke nil 7 nil nil nil 30016 nil 8 1962751712 3682 nil nil 35 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 193 30048 nil 30016 962 #setMarginWidths: 34 1 8 #(3 3) 30016 3 8 #() 1154 193 193 nil 27 1186 2720 421 1248 -49 13056 3 1280 41 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28384 34 2 8 1140855110 1 30352 nil 816 nil 7 29010 nil true 34 10 29058 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 29122 4097 29058 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 29058 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 29058 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29058 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29122 4097 29010 nil true 34 3 29058 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29058 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29058 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29122 4097 29058 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 30352 nil 8 1463894896 3682 nil nil 43 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 193 30384 nil 30352 962 #contextMenu: 34 1 30416 30352 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click Next to continue.\par
\par
\par
\pard\qc\par
}
' 30352 962 #textLimit: 8 #(1073741823) 30352 962 #resetCharFormat 5312 30352 3 8 #() 1154 193 193 nil 27 1186 2720 419 1680 549 1264 681 1280 49 170 192 34 2 30016 8 'executablePath1' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 28416 8 'Intro' 28384 3 34 4 28496 28944 30016 30352 1154 193 193 nil 27 3458 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 31616 nil nil nil 5 nil nil nil 31616 674 170 176 34 8 410 ##(Smalltalk.ContainerView) 34 15 nil 31616 34 2 8 1140850688 131073 31728 nil 816 nil 5 nil nil nil 31728 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 31728 34 2 8 1140850944 1 31808 4402 nil false 4434 4466 #= 8 #() 4466 #hash 4528 4546 nil true 4578 nil 8 'Resources\LagoonLogo.bmp' 4640 4656 nil 5 nil nil nil 31808 nil 8 4294902547 3682 nil nil nil 31952 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 31840 nil 31808 962 #text: 34 1 8 'Graphic' 31808 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 31728 34 2 8 1140855108 1 32240 nil 816 nil 5 nil nil nil 32240 nil 8 1463894896 3682 nil nil 41 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 32272 nil 32240 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 1:\par
\par
Choose an ImageStripper to perform the deployment process\par
\par
\par
\par
}
' 32240 962 #textLimit: 8 #(1073741823) 32240 962 #resetCharFormat 5312 32240 3 8 #() 1154 193 193 nil 27 170 192 5312 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 31760 8 'Heading' 31728 3 34 2 32240 31808 1154 193 193 nil 27 1186 2720 1 1248 1 1264 1 1280 121 410 ##(Smalltalk.ComboBox) 34 17 nil 31616 34 2 8 1144063491 1025 32896 8882 138 144 5312 nil 8944 816 nil 5 nil nil nil 32896 nil 8 1962368288 ##(Smalltalk.BasicListAbstract) 8976 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[174 0 0 0 204 0 0 0 241 1 0 0 171 1 0 0] 193 32928 8 '' 32896 3 8 #() 1154 193 193 nil 27 1186 2720 349 1248 -119 1264 409 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 31616 34 2 8 1140850944 1 33200 nil nil nil 5 nil nil nil 33200 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 193 33232 nil 33200 962 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 33200 3 8 #() 1154 193 193 nil 27 1186 2720 81 1680 249 1264 401 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 31616 34 2 8 1140850944 1 33520 nil nil nil 5 nil nil nil 33520 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 193 33552 nil 33520 962 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33520 3 8 #() 1154 193 193 nil 27 1186 2720 29 1248 -107 1264 229 1280 149 170 192 34 2 32896 8 'imageStripperClass' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 31648 8 'Step 1' 31616 1 34 4 31728 33520 33200 32896 1154 193 193 nil 27 3458 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 34080 nil nil nil 5 nil nil nil 34080 674 170 176 34 14 410 ##(Smalltalk.GroupBox) 34 14 nil 34080 34 2 8 1140850695 65 34192 nil 816 nil 5 nil nil nil 34192 nil 8 1962759008 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 193 34224 8 '' 34192 3 8 #() 1154 193 193 nil 27 1186 2720 1 1248 1 1264 327 1280 393 410 ##(Smalltalk.ContainerView) 34 15 nil 34080 34 2 8 1140850688 131073 34464 nil 816 nil 5 nil nil nil 34464 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 34464 34 2 8 1140850944 1 34544 4402 nil false 4434 4466 #= 8 #() 4466 #hash 4528 4546 nil true 4578 nil 8 'Resources\LagoonLogo.bmp' 4640 4656 nil 5 nil nil nil 34544 nil 8 4294902547 3682 nil nil nil 34688 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 34576 nil 34544 962 #text: 34 1 8 'Graphic' 34544 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 34464 34 2 8 1140855108 1 34976 nil 816 nil 5 nil nil nil 34976 nil 8 1463894896 3682 nil nil 41 nil 5010 8 #[0 0 0 0 0 0 0 0 160 0 185 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 35008 nil 34976 962 #text: 34 1 5218 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 6:\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 34976 962 #textLimit: 8 #(1073741823) 34976 962 #resetCharFormat 5312 34976 3 8 #() 1154 193 193 nil 27 170 192 5312 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 34496 8 'Heading' 34464 3 34 2 34976 34544 1154 193 193 nil 27 1186 2720 1 1248 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 34080 34 2 8 1140850944 1 35632 nil nil nil 5 nil nil nil 35632 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 193 35664 nil 35632 962 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 35632 3 8 #() 1154 193 193 nil 27 1186 2720 29 1248 -97 1264 161 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 34080 34 2 8 1140924451 1 35952 4402 nil nil 5712 false nil nil 5 nil nil nil 35952 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 193 35984 8 'Remove &Class Builder' 35952 3 8 #() 1154 193 193 nil 27 1186 2720 81 1680 369 1264 209 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 34080 34 2 8 1140924451 1 36256 4402 nil nil 5712 true nil nil 5 nil nil nil 36256 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 193 36288 8 'Fold duplicate s&trings' 36256 3 8 #() 1154 193 193 nil 27 1186 2720 71 1680 379 1264 451 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 34080 34 2 8 1140850944 1 36560 nil nil nil 5 nil nil nil 36560 nil 8 1962964032 3682 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 193 36592 nil 36560 962 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 36560 3 8 #() 1154 193 193 nil 27 1186 2720 31 1248 -117 1264 391 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 34080 34 2 8 1140924451 1 36880 4402 nil nil 5712 true nil nil 5 nil nil nil 36880 nil 8 1962759008 3682 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 193 36912 8 'Fold duplicate b&ytecode arrays' 36880 3 8 #() 1154 193 193 nil 27 1186 2720 71 1680 379 1264 511 1280 41 170 192 34 6 35952 8 'stripClassBuilder' 36256 8 'stripDuplicateStrings' 36880 8 'stripDuplicateBytecodes' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 34112 8 'Step 6' 34080 1 34 7 34464 35632 35952 36560 36256 36880 34192 1154 193 193 nil 27 28384 nil nil nil 170 192 34 2 28384 8 'Intro' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 193 3360 8 '' 3328 3 34 9 28384 31616 3488 9520 12640 20880 34080 17648 24896 1154 193 193 nil 27 170 192 34 2 3328 8 'Steps' nil nil nil nil nil 3 nil nil 1154 2049 881 1154 1151 881 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2005832576 nil nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3090 1154 10751 21 1154 11901 901 193 416 962 #setWindowText: 34 1 8 'Lagoon Deployment Wizard' 416 1 34 2 3328 608 1154 193 193 nil 29 )!

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

!ApplicationDeploymentWizard class categoriesForMethods!
defaultAdditionalAccelerators!constants!private! !
defaultModel!models!public! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!development!public! !
resource_Default_view!public!resources-views! !
saveImageOnDeploy!options!public! !
saveImageOnDeploy:!options!public! !
toolsFolderIcon!accessing!public! !
!

