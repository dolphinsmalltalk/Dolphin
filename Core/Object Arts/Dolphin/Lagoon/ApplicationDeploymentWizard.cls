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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 608 nil nil nil 7 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 736 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 736 nil 8 1796035392 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 193 768 8 '&Save Configuration' 736 962 #isEnabled: 8 #(false) 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 11 1218 #fixedViewLeft 241 1218 #fixedParentTop 1 1218 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1296 nil 816 nil 7 nil nil nil 1296 nil 8 1796035392 850 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 193 1328 8 '< &Back' 1296 962 #isEnabled: 8 #(false) 1296 3 8 #() 1154 193 193 nil 29 1186 1218 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1248 131 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1680 nil 816 nil 7 nil nil nil 1680 nil 8 1796035392 850 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 193 1712 8 '&Reset' 1680 962 #isEnabled: 8 #(false) 1680 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedViewRight -129 1218 #fixedParentRight -429 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2048 nil 816 nil 7 nil nil nil 2048 nil 8 1796035392 850 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 193 2080 8 '&Deploy' 2048 962 #isEnabled: 8 #(false) 2048 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedParentLeft 9 1248 139 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2400 nil 816 nil 7 nil nil nil 2400 nil 8 1796035392 850 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 193 2432 8 '&Next >' 2400 962 #isEnabled: 8 #(false) 2400 3 8 #() 1154 193 193 nil 29 1186 1232 11 1248 131 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2736 nil 816 nil 7 nil nil nil 2736 nil 8 1796035392 850 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 193 2768 8 'Cancel' 2736 3 8 #() 1154 193 193 nil 29 1186 2016 -137 2032 -11 1264 1 1280 49 170 192 34 2 2048 8 'deploy' 590342 ##(Smalltalk.Rectangle) 1154 11 13 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 193 640 8 'Buttons' 608 3 34 6 2048 1296 2400 1680 736 2736 1154 193 193 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3328 nil nil nil 7 nil nil nil 3328 656710 1 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 3488 nil nil nil 5 nil nil nil 3488 674 170 176 34 28 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 3600 nil 816 nil 5 nil nil nil 3600 nil 8 1796035392 850 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 193 3632 8 'S&how it' 3600 962 #isEnabled: 8 #(false) 3600 3 8 #() 1154 193 193 nil 29 1186 2384 441 1248 139 1264 661 1280 45 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 3936 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 3936 nil 8 1796035392 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 193 3968 8 'Create single file, "To Go" distributable.' 3936 3 8 #() 1154 193 193 nil 27 1186 2384 31 1248 431 1264 211 1280 81 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 4304 4002 nil nil 4048 true nil nil 5 nil nil nil 4304 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 193 4336 8 'Log &class references' 4304 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 251 1264 661 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 4608 nil nil nil 5 nil nil nil 4608 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[21 0 0 0 193 0 0 0 211 0 0 0 233 0 0 0] 193 4640 nil 4608 962 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 4608 3 8 #() 1154 193 193 nil 27 1186 2384 43 1248 381 1264 387 1280 81 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140850688 262145 4928 nil nil nil 5 nil nil nil 4928 nil 8 1796028096 4082 nil nil 1 898 138 144 34 3 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 193 4960 nil 4928 962 #isEnabled: 8 #(false) 4928 962 #setMarginWidths: 34 1 8 #(3 3) 4928 3 8 #() 1154 193 193 nil 27 1186 2384 441 2032 -109 1264 597 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 5280 nil nil nil 5 nil nil nil 5280 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 249 0 0 0 25 2 0 0 33 1 0 0] 193 5312 nil 5280 962 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 5280 3 8 #() 1154 193 193 nil 27 1186 2384 31 2032 -39 1264 499 1280 81 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140916352 1025 5600 nil 816 nil 5 nil nil nil 5600 nil 8 1796028096 4082 nil nil 1 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 193 5632 nil 5600 962 #setMarginWidths: 34 1 8 #(3 3) 5600 3 8 #() 1154 193 193 nil 27 1186 2384 431 2032 -109 1264 151 1280 41 410 ##(Smalltalk.ComboBox) 34 17 nil 3488 34 2 8 1144063491 1025 5920 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 816 nil 5 nil nil nil 5920 nil 8 1795644720 ##(Smalltalk.BasicListAbstract) 8 #() 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 199 0 0 0 246 1 0 0 222 0 0 0] 193 5952 8 '' 5920 3 8 #() 1154 193 193 nil 27 1186 2384 441 2032 -109 1264 399 1280 43 410 ##(Smalltalk.ContainerView) 34 15 nil 3488 34 2 8 1140850688 131073 6304 nil 816 nil 5 nil nil nil 6304 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 6304 34 2 8 1140850944 1 6384 4002 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 6498 #hash 8 #() 787206 ##(Smalltalk.GdiplusImage) nil true 2032390 ##(Smalltalk.GdiplusImageFromFileInitializer) nil 8 'Resources\LagoonLogo.bmp' 1703942 ##(Smalltalk.InstallRelativeFileLocator) 802 #face3d nil 5 nil nil nil 6384 nil 8 4294902547 4082 nil nil nil 6592 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 6416 nil 6384 962 #text: 34 1 8 'Graphic' 6384 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 6304 34 2 8 1140855108 1 6944 nil 816 nil 5 nil nil nil 6944 nil 8 2030322544 4082 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 6976 nil 6944 962 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 2: \par
\par
Choose an Executable File and RuntimeSessionManager\par
\par
\par
\par
}
' 6944 962 #textLimit: 8 #(1073741823) 6944 962 #resetCharFormat 6032 6944 3 8 #() 1154 193 193 nil 27 170 192 6032 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 6336 8 'Heading' 6304 3 34 2 6944 6384 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 7632 nil 816 nil 5 nil nil nil 7632 nil 8 1796035392 850 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 193 7664 8 '...' 7632 962 #isEnabled: 8 #(false) 7632 3 8 #() 1154 193 193 nil 29 1186 2016 -47 2032 -41 1264 151 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 7968 nil nil nil 5 nil nil nil 7968 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 193 8000 nil 7968 962 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 7968 3 8 #() 1154 193 193 nil 27 1186 2384 31 2032 -109 1264 309 1280 71 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 8288 nil nil nil 5 nil nil nil 8288 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 193 8320 nil 8288 962 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 8288 3 8 #() 1154 193 193 nil 27 1186 2384 31 1248 389 1264 141 1280 81 410 ##(Smalltalk.GroupBox) 34 14 nil 3488 34 2 8 1140850695 65 8608 nil 816 nil 5 nil nil nil 8608 nil 8 1796035392 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 139 0 0 0 65 2 0 0 244 0 0 0] 193 8640 8 '' 8608 3 8 #() 1154 193 193 nil 27 1186 2384 1 2032 41 1264 279 1280 211 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 8880 4002 nil nil 4048 true nil nil 5 nil nil nil 8880 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 193 8912 8 'Write &log file' 8880 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 251 1264 597 1280 41 170 192 34 14 8880 8 'writeLogFile' 5600 8 'executableName' 3600 8 'showLog' 4304 8 'logReferencesToClasses' 4928 8 'logFileName' 5920 8 'runtimeSessionManagerClass' 3936 8 'isToGo' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 3520 8 'Step 2' 3488 1 34 14 6304 8288 5600 7632 3936 7968 4608 5920 5280 8880 4304 4928 3600 8608 1154 193 193 nil 27 3458 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 9520 nil nil nil 5 nil nil nil 9520 674 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 9632 nil nil nil 5 nil nil nil 9632 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 193 9664 nil 9632 962 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 9632 3 8 #() 1154 193 193 nil 27 1186 2384 31 2032 -109 1264 171 1280 191 410 ##(Smalltalk.ContainerView) 34 15 nil 9520 34 2 8 1140850688 131073 9952 nil 816 nil 5 nil nil nil 9952 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 9952 34 2 8 1140850944 1 10032 4002 nil false 6466 6498 #= 8 #() 6498 #hash 6560 6578 nil true 6610 nil 8 'Resources\LagoonLogo.bmp' 6672 6688 nil 5 nil nil nil 10032 nil 8 4294902547 4082 nil nil nil 10176 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 10064 nil 10032 962 #text: 34 1 8 'Graphic' 10032 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 9952 34 2 8 1140855108 1 10464 nil 816 nil 5 nil nil nil 10464 nil 8 2030322544 4082 nil nil 41 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 10496 nil 10464 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 3:\par
\par
Configure how the ImageStripper removes unwanted packages\par
\par
\par
\par
}
' 10464 962 #textLimit: 8 #(1073741823) 10464 962 #resetCharFormat 6032 10464 3 8 #() 1154 193 193 nil 27 170 192 6032 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 9984 8 'Heading' 9952 3 34 2 10464 10032 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 11120 nil nil nil 5 nil nil nil 11120 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 193 11152 nil 11120 962 #text: 34 1 8 'Root package:' 11120 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 201 1264 389 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 9520 34 2 8 1140924451 1 11440 4002 nil nil 4048 true nil nil 5 nil nil nil 11440 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 193 11472 8 'Remove redundant &packages' 11440 3 8 #() 1154 193 193 nil 27 1186 2384 59 1248 329 1264 599 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 11744 nil nil nil 5 nil nil nil 11744 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 193 11776 nil 11744 962 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 11744 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 499 1280 109 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 262145 12064 nil nil nil 5 nil nil nil 12064 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 193 12096 nil 12064 962 #text: 34 1 8 '' 12064 3 8 #() 1154 193 193 nil 27 1186 2384 361 2032 -107 1264 389 1280 41 170 192 34 4 11440 8 'stripRedundantPackages' 12064 8 'rootPackage' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 9552 8 'Step 3' 9520 1 34 6 9952 9632 11120 12064 11744 11440 1154 193 193 nil 27 3458 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 12640 nil nil nil 5 nil nil nil 12640 674 170 176 34 24 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 12752 nil nil nil 5 nil nil nil 12752 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 193 12784 nil 12752 962 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 12752 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -57 1264 149 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13072 4002 nil nil 4048 true nil nil 5 nil nil nil 13072 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 193 13104 8 'Remove redundant &classes' 13072 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 441 1218 #fixedPreviousBottom 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13392 4002 nil nil 4048 true nil nil 5 nil nil nil 13392 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 193 13424 8 'Remove redundant &resources' 13392 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 1218 #fixedPreviousTop 1 1280 49 410 ##(Smalltalk.GroupBox) 34 14 nil 12640 34 2 8 1140850695 65 13712 nil 816 nil 5 nil nil nil 13712 nil 8 1796035392 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 193 13744 8 '' 13712 3 8 #() 1154 193 193 nil 27 1186 2384 -17 2032 19 1264 281 1280 229 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 13984 nil nil nil 5 nil nil nil 13984 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 193 14016 nil 13984 962 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 13984 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -7 13376 51 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14304 4002 nil nil 4048 false nil nil 5 nil nil nil 14304 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 193 14336 8 'Preserve &aspect set methods' 14304 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 13696 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 14608 nil nil nil 5 nil nil nil 14608 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 193 14640 nil 14608 962 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 14608 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -67 13376 51 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14928 4002 nil nil 4048 false nil nil 5 nil nil nil 14928 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 193 14960 8 'Remove #shouldNot&Implement methods' 14928 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 13696 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 15232 4002 nil nil 4048 false nil nil 5 nil nil nil 15232 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 193 15264 8 'Remove #&subclassResponsibility methods' 15232 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 441 13376 17 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 15536 4002 nil nil 4048 false nil nil 5 nil nil nil 15536 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 193 15568 8 'Remove redundant &methods' 15536 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 441 13376 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 15840 4002 nil nil 4048 false nil nil 5 nil nil nil 15840 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 193 15872 8 'Remove #&deprecated methods' 15840 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 441 13376 1 1280 49 410 ##(Smalltalk.ContainerView) 34 15 nil 12640 34 2 8 1140850688 131073 16144 nil 816 nil 5 nil nil nil 16144 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 16144 34 2 8 1140850944 1 16224 4002 nil false 6466 6498 #= 8 #() 6498 #hash 6560 6578 nil true 6610 nil 8 'Resources\LagoonLogo.bmp' 6672 6688 nil 5 nil nil nil 16224 nil 8 4294902547 4082 nil nil nil 16368 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 16256 nil 16224 962 #text: 34 1 8 'Graphic' 16224 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 16144 34 2 8 1140855108 1 16656 nil 816 nil 5 nil nil nil 16656 nil 8 2030322544 4082 nil nil 41 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 16688 nil 16656 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 4:\par
\par
Configure how the ImageStripper removes unwanted classes and methods\par
\par
\par
\par
}
' 16656 962 #textLimit: 8 #(1073741823) 16656 962 #resetCharFormat 6032 16656 3 8 #() 1154 193 193 nil 27 170 192 6032 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 16176 8 'Heading' 16144 3 34 2 16656 16224 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 170 192 34 14 13392 8 'stripRedundantResources' 14304 8 'preserveAspectSetters' 15840 8 'stripDeprecatedMethods' 14928 8 'stripShouldNotImplement' 13072 8 'stripRedundantClasses' 15536 8 'stripRedundantMethods' 15232 8 'stripSubclassResponsibility' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 12672 8 'Step 4' 12640 1 34 12 16144 12752 13072 13392 14608 15536 14304 13984 15840 14928 15232 13712 1154 193 193 nil 27 3458 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 17648 nil nil nil 5 nil nil nil 17648 674 170 176 34 12 410 ##(Smalltalk.ReferenceView) 34 14 nil 17648 34 2 8 1140850688 131073 17760 nil nil nil 5 nil nil nil 17760 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 163 0 0 0 24 2 0 0 27 1 0 0] 193 17792 8 '' 17760 3 6032 1154 193 193 nil 27 1186 2384 33 2032 -41 1264 327 1280 241 410 ##(Smalltalk.PushButton) 34 20 nil 17648 34 2 8 1140924416 1 18032 nil 816 nil 5 nil nil nil 18032 nil 8 1796035392 850 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 193 18064 8 'Custom &Options' 18032 962 #isEnabled: 8 #(false) 18032 3 8 #() 1154 193 193 nil 29 1186 2384 881 1248 211 1264 661 1280 51 410 ##(Smalltalk.ContainerView) 34 15 nil 17648 34 2 8 1140850688 131073 18368 nil 816 nil 5 nil nil nil 18368 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 18368 34 2 8 1140850944 1 18448 4002 nil false 6466 6498 #= 8 #() 6498 #hash 6560 6578 nil true 6610 nil 8 'Resources\LagoonLogo.bmp' 6672 6688 nil 5 nil nil nil 18448 nil 8 4294902547 4082 nil nil nil 18592 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 18480 nil 18448 962 #text: 34 1 8 'Graphic' 18448 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 18368 34 2 8 1140855108 1 18880 nil 816 nil 5 nil nil nil 18880 nil 8 2030322544 4082 nil nil 41 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 18912 nil 18880 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 7:\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\par
}
' 18880 962 #textLimit: 8 #(1073741823) 18880 962 #resetCharFormat 6032 18880 3 8 #() 1154 193 193 nil 27 170 192 6032 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 18400 8 'Heading' 18368 3 34 2 18880 18448 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 19536 nil nil nil 5 nil nil nil 19536 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 66 0 0 0 24 2 0 0 156 0 0 0] 193 19568 nil 19536 962 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 19536 3 8 #() 1154 193 193 nil 27 1186 2384 33 2032 -41 1264 133 1280 181 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 19856 nil nil nil 5 nil nil nil 19856 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 193 19888 nil 19856 962 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 19856 3 8 #() 1154 193 193 nil 27 1186 2384 31 1248 791 1264 651 1280 71 410 ##(Smalltalk.StatusBar) 34 18 nil 17648 34 2 8 1140850700 1 20176 nil nil nil 5 nil 498 nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 193 nil nil 20176 nil 8 1795833056 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 20176 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'preStripScriptErrors' 138 144 34 1 20368 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 20176 nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 193 20208 8 '' 20176 3 8 #() 1154 193 193 nil 27 1186 2384 31 2032 -37 1264 571 1280 41 170 192 34 2 17760 8 'preStripScript' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 17680 8 'Step 7' 17648 1 34 6 18368 19536 17760 20176 19856 18032 1154 193 193 nil 27 3458 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 20896 nil nil nil 5 nil nil nil 20896 674 170 176 34 18 410 ##(Smalltalk.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 21008 nil nil nil 5 nil nil nil 21008 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 193 21040 nil 21008 962 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 21008 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 321 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 21328 4002 nil nil 4048 true nil nil 5 nil nil nil 21328 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 193 21360 8 'Remove class meta-&information' 21328 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 249 1280 59 410 ##(Smalltalk.GroupBox) 34 14 nil 20896 34 2 8 1140850695 65 21632 nil 816 nil 5 nil nil nil 21632 nil 8 1796035392 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 193 21664 8 '' 21632 3 8 #() 1154 193 193 nil 27 1186 2384 -17 2032 19 1264 521 1280 229 410 ##(Smalltalk.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 21904 4002 nil nil 4048 false nil nil 5 nil nil nil 21904 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 193 21936 8 'Compile E&xternal Structures' 21904 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 649 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 22208 nil nil nil 5 nil nil nil 22208 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 193 22240 nil 22208 962 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 22208 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 549 1280 89 410 ##(Smalltalk.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 22528 4002 nil nil 4048 false nil nil 5 nil nil nil 22528 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 193 22560 8 'Retain instance &variable names' 22528 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 389 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 22832 4002 nil nil 4048 false nil nil 5 nil nil nil 22832 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 193 22864 8 'Remove class &GUIDs' 22832 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 459 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 23136 nil nil nil 5 nil nil nil 23136 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 193 23168 nil 23136 962 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 23136 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 149 1280 99 410 ##(Smalltalk.ContainerView) 34 15 nil 20896 34 2 8 1140850688 131073 23456 nil 816 nil 5 nil nil nil 23456 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 23456 34 2 8 1140850944 1 23536 4002 nil false 6466 6498 #= 8 #() 6498 #hash 6560 6578 nil true 6610 nil 8 'Resources\LagoonLogo.bmp' 6672 6688 nil 5 nil nil nil 23536 nil 8 4294902547 4082 nil nil nil 23680 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 23568 nil 23536 962 #text: 34 1 8 'Graphic' 23536 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 23456 34 2 8 1140855108 1 23968 nil 816 nil 5 nil nil nil 23968 nil 8 2030322544 4082 nil nil 41 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 24000 nil 23968 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 5:\par
\par
Decide what meta-level information is required at runtime\par
\par
\par
\par
}
' 23968 962 #textLimit: 8 #(1073741823) 23968 962 #resetCharFormat 6032 23968 3 8 #() 1154 193 193 nil 27 170 192 6032 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 23488 8 'Heading' 23456 3 34 2 23968 23536 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 170 192 34 8 22528 8 'retainInstVarNames' 22832 8 'stripClassGuids' 21328 8 'stripClassInfo' 21904 8 'compileExternalStructures' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 20928 8 'Step 5' 20896 1 34 9 23456 23136 21328 21008 22528 22832 22208 21904 21632 1154 193 193 nil 27 3458 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 24912 nil nil nil 5 nil nil nil 24912 674 170 176 34 14 410 ##(Smalltalk.ContainerView) 34 15 nil 24912 34 2 8 1140850688 131073 25024 nil 816 nil 5 nil nil nil 25024 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 25024 34 2 8 1140850944 1 25104 4002 nil false 6466 6498 #= 8 #() 6498 #hash 6560 6578 nil true 6610 nil 8 'Resources\LagoonLogo.bmp' 6672 6688 nil 5 nil nil nil 25104 nil 8 4294902547 4082 nil nil nil 25248 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 25136 nil 25104 962 #text: 34 1 8 'Graphic' 25104 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 25024 34 2 8 1140855108 1 25536 nil 816 nil 5 nil nil nil 25536 nil 8 2030322544 4082 nil nil 41 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 25568 nil 25536 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Final Step:\par
\par
Deployment\par
\par
\par
\par
}
' 25536 962 #textLimit: 8 #(1073741823) 25536 962 #resetCharFormat 6032 25536 3 8 #() 1154 193 193 nil 27 170 192 6032 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 25056 8 'Heading' 25024 3 34 2 25536 25104 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 26192 nil nil nil 5 nil nil nil 26192 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 193 26224 nil 26192 962 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 26192 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 641 1280 59 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850955 262145 26512 nil nil nil 5 nil nil nil 26512 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 193 26544 nil 26512 962 #text: 34 1 8 '' 26512 3 8 #() 1154 193 193 nil 27 1186 2384 281 2032 -97 1264 269 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 26832 nil nil nil 5 nil 498 nil true 20258 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 193 nil nil 26832 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 193 26864 nil 26832 962 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 26832 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -97 1264 349 1280 139 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 27200 nil nil nil 5 nil nil nil 27200 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 193 27232 nil 27200 962 #text: 34 1 8 'E&xecutable name:' 27200 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 189 1264 269 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 27520 nil nil nil 5 nil 498 nil true 20258 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 193 nil nil 27520 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 193 27552 nil 27520 962 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 27520 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -137 1264 529 1280 81 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 27888 nil nil nil 5 nil nil nil 27888 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 193 27920 nil 27888 962 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 27888 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -97 1264 161 1280 81 170 192 34 2 26512 8 'executablePath2' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 24944 8 'Final step' 24912 1 34 7 25024 27888 27200 26512 27520 26832 26192 1154 193 193 nil 27 3458 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 28448 nil 816 nil 7 nil nil nil 28448 674 170 176 34 8 410 ##(Smalltalk.TextEdit) 34 16 nil 28448 34 2 8 1140850816 262145 28560 nil 802 #whiteSmoke nil 7 nil nil nil 28560 nil 8 1796028096 4082 nil nil 35 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 193 28592 nil 28560 962 #setMarginWidths: 34 1 8 #(3 3) 28560 3 8 #() 1154 193 193 nil 27 1186 2384 421 2032 -49 13376 3 1280 41 410 ##(Smalltalk.ImageView) 34 21 nil 28448 34 2 8 1140850944 1 28896 4002 nil false 6466 6498 #= 8 #() 6498 #hash 6560 6578 nil true 6610 nil 8 'Resources\LagoonSideBar.jpg' 6672 816 nil 7 nil nil nil 28896 nil 8 4294902547 4082 nil nil nil 29040 #scaleToFit 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 193 28928 nil 28896 962 #text: 34 1 8 'Lagoon Graphic' 28896 3 8 #() 1154 193 193 nil 27 1186 2384 1 1248 379 1264 1 1280 741 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28448 34 2 8 1140855110 1 29344 nil 816 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 29458 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 29458 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 29458 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29458 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29522 4097 29410 nil true 34 3 29458 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29458 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29458 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29522 4097 29458 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29344 nil 8 2030322544 4082 nil nil 43 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 193 29376 nil 29344 962 #contextMenu: 34 1 29424 29344 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click Next to continue.\par
\par
\par
\pard\qc\par
}
' 29344 962 #textLimit: 8 #(1073741823) 29344 962 #resetCharFormat 6032 29344 3 8 #() 1154 193 193 nil 27 1186 2384 419 1248 549 1264 681 1280 49 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28448 34 2 8 1140855110 1 30416 nil 816 nil 7 29410 nil true 34 10 29458 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 29522 4097 29458 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 29458 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 29458 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29458 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29522 4097 29410 nil true 34 3 29458 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29458 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29458 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29522 4097 29458 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 30416 nil 8 2030322544 4082 nil nil 43 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 193 30448 nil 30416 962 #contextMenu: 34 1 30480 30416 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
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
' 30416 962 #textLimit: 8 #(1073741823) 30416 962 #resetCharFormat 6032 30416 3 8 #() 1154 193 193 nil 27 1186 2384 419 2032 -47 1264 1 1280 489 170 192 34 2 28560 8 'executablePath1' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 28480 8 'Intro' 28448 3 34 4 28896 30416 28560 29344 1154 193 193 nil 27 3458 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 31680 nil nil nil 5 nil nil nil 31680 674 170 176 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 31680 34 2 8 1140850944 1 31792 nil nil nil 5 nil nil nil 31792 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 193 31824 nil 31792 962 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 31792 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 229 1280 149 410 ##(Smalltalk.StaticText) 34 16 nil 31680 34 2 8 1140850944 1 32112 nil nil nil 5 nil nil nil 32112 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 193 32144 nil 32112 962 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 32112 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 249 1264 401 1280 121 410 ##(Smalltalk.ContainerView) 34 15 nil 31680 34 2 8 1140850688 131073 32432 nil 816 nil 5 nil nil nil 32432 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 32432 34 2 8 1140850944 1 32512 4002 nil false 6466 6498 #= 8 #() 6498 #hash 6560 6578 nil true 6610 nil 8 'Resources\LagoonLogo.bmp' 6672 6688 nil 5 nil nil nil 32512 nil 8 4294902547 4082 nil nil nil 32656 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 32544 nil 32512 962 #text: 34 1 8 'Graphic' 32512 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 32432 34 2 8 1140855108 1 32944 nil 816 nil 5 nil nil nil 32944 nil 8 2030322544 4082 nil nil 41 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 32976 nil 32944 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 1:\par
\par
Choose an ImageStripper to perform the deployment process\par
\par
\par
\par
}
' 32944 962 #textLimit: 8 #(1073741823) 32944 962 #resetCharFormat 6032 32944 3 8 #() 1154 193 193 nil 27 170 192 6032 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 32464 8 'Heading' 32432 3 34 2 32944 32512 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.ComboBox) 34 17 nil 31680 34 2 8 1144063491 1025 33600 5986 138 144 6032 nil 6064 816 nil 5 nil nil nil 33600 nil 8 1795644720 ##(Smalltalk.BasicListAbstract) 6096 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[174 0 0 0 204 0 0 0 241 1 0 0 227 0 0 0] 193 33632 8 '' 33600 3 8 #() 1154 193 193 nil 27 1186 2384 349 2032 -119 1264 409 1280 41 170 192 34 2 33600 8 'imageStripperClass' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 31712 8 'Step 1' 31680 1 34 4 32432 31792 32112 33600 1154 193 193 nil 27 3458 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 34144 nil nil nil 5 nil nil nil 34144 674 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 34144 34 2 8 1140850944 1 34256 nil nil nil 5 nil nil nil 34256 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 193 34288 nil 34256 962 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 34256 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -97 1264 161 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 34144 34 2 8 1140924451 1 34576 4002 nil nil 4048 true nil nil 5 nil nil nil 34576 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 193 34608 8 'Fold duplicate s&trings' 34576 3 8 #() 1154 193 193 nil 27 1186 2384 71 1248 379 1264 451 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 34144 34 2 8 1140924451 1 34880 4002 nil nil 4048 true nil nil 5 nil nil nil 34880 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 193 34912 8 'Fold duplicate b&ytecode arrays' 34880 3 8 #() 1154 193 193 nil 27 1186 2384 71 1248 379 1264 511 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 34144 34 2 8 1140850944 1 35184 nil nil nil 5 nil nil nil 35184 nil 8 1796240416 4082 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 193 35216 nil 35184 962 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 35184 3 8 #() 1154 193 193 nil 27 1186 2384 31 2032 -117 1264 391 1280 49 410 ##(Smalltalk.ContainerView) 34 15 nil 34144 34 2 8 1140850688 131073 35504 nil 816 nil 5 nil nil nil 35504 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 35504 34 2 8 1140850944 1 35584 4002 nil false 6466 6498 #= 8 #() 6498 #hash 6560 6578 nil true 6610 nil 8 'Resources\LagoonLogo.bmp' 6672 6688 nil 5 nil nil nil 35584 nil 8 4294902547 4082 nil nil nil 35728 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 35616 nil 35584 962 #text: 34 1 8 'Graphic' 35584 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 35504 34 2 8 1140855108 1 36016 nil 816 nil 5 nil nil nil 36016 nil 8 2030322544 4082 nil nil 41 nil 7042 8 #[0 0 0 0 0 0 0 0 176 0 70 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 36048 nil 36016 962 #text: 34 1 7250 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 6:\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 36016 962 #textLimit: 8 #(1073741823) 36016 962 #resetCharFormat 6032 36016 3 8 #() 1154 193 193 nil 27 170 192 6032 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 35536 8 'Heading' 35504 3 34 2 36016 35584 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 34144 34 2 8 1140924451 1 36672 4002 nil nil 4048 false nil nil 5 nil nil nil 36672 nil 8 1796035392 4082 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 193 36704 8 'Remove &Class Builder' 36672 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 209 1280 41 410 ##(Smalltalk.GroupBox) 34 14 nil 34144 34 2 8 1140850695 65 36976 nil 816 nil 5 nil nil nil 36976 nil 8 1796035392 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 193 37008 8 '' 36976 3 8 #() 1154 193 193 nil 27 1186 2384 1 2032 1 1264 327 1280 393 170 192 34 6 36672 8 'stripClassBuilder' 34880 8 'stripDuplicateBytecodes' 34576 8 'stripDuplicateStrings' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 34176 8 'Step 6' 34144 1 34 7 35504 34256 36672 35184 34576 34880 36976 1154 193 193 nil 27 28448 nil nil nil 170 192 34 2 28448 8 'Intro' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 193 3360 8 '' 3328 3 34 9 28448 31680 3488 9520 12640 20896 34144 17648 24912 1154 193 193 nil 27 170 192 34 2 3328 8 'Steps' 3090 1154 1 1 1154 1 1 nil nil nil nil 3 nil nil 1154 2049 881 1154 1151 881 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2008255760 898 138 144 34 2 962 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1042 8 #[255 9 0 0 10 0 0 0 62 12 0 0 194 1 0 0] 193 416 962 #setWindowText: 34 1 8 'Lagoon Deployment Wizard' 416 1 34 2 3328 608 1154 193 193 nil 27 )!

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

