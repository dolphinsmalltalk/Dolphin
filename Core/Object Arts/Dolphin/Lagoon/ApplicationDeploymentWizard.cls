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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 608 nil nil nil 5 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 736 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 736 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 193 768 8 '&Next >' 736 962 #isEnabled: 8 #(false) 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 11 1218 #fixedViewLeft 131 1218 #fixedParentTop 1 1218 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1296 nil 816 nil 5 nil nil nil 1296 nil 8 1759007584 850 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 193 1328 8 '&Deploy' 1296 962 #isEnabled: 8 #(false) 1296 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedParentLeft 9 1248 139 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1648 nil 816 nil 5 nil nil nil 1648 nil 8 1759007584 850 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 193 1680 8 'Cancel' 1648 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedViewRight -137 1218 #fixedParentRight -11 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1984 nil 816 nil 5 nil nil nil 1984 nil 8 1759007584 850 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 193 2016 8 '&Save Configuration' 1984 962 #isEnabled: 8 #(false) 1984 3 8 #() 1154 193 193 nil 29 1186 1232 11 1248 241 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2320 nil 816 nil 5 nil nil nil 2320 nil 8 1759007584 850 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 193 2352 8 '< &Back' 2320 962 #isEnabled: 8 #(false) 2320 3 8 #() 1154 193 193 nil 29 1186 1218 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1248 131 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2704 nil 816 nil 5 nil nil nil 2704 nil 8 1759007584 850 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 193 2736 8 '&Reset' 2704 962 #isEnabled: 8 #(false) 2704 3 8 #() 1154 193 193 nil 29 1186 1952 -129 1968 -429 1264 1 1280 49 170 192 34 2 1296 8 'deploy' 590342 ##(Smalltalk.Rectangle) 1154 11 13 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 193 640 8 'Buttons' 608 3 34 6 1296 2320 736 2704 1984 1648 1154 193 193 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3328 nil nil nil 5 nil nil nil 3328 656710 1 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 3488 nil nil nil 5 nil nil nil 3488 674 170 176 34 28 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 3600 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 517 nil nil nil 3600 nil 8 1759007584 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 108 0 0 0 231 0 0 0 133 0 0 0] 193 3632 8 'Create single file, "To Go" distributable.' 3600 3 8 #() 1154 193 193 nil 27 1186 1632 33 1248 431 1264 217 1280 51 410 ##(Smalltalk.ComboBox) 34 17 nil 3488 34 2 8 1144063491 1025 3968 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 816 nil 5 nil nil nil 3968 nil 8 1758616864 ##(Smalltalk.BasicListAbstract) 8 #() 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 0 0 0 192 0 0 0 247 1 0 0 157 1 0 0] 193 4000 8 '' 3968 3 8 #() 1154 193 193 nil 27 1186 1632 495 1968 -107 1264 385 1280 47 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 4352 3666 nil nil 3712 true nil nil 5 nil nil nil 4352 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 70 1 0 0 155 0 0 0 90 1 0 0] 193 4384 8 'Log &class references' 4352 3 8 #() 1154 193 193 nil 27 1186 1632 61 1248 251 1264 653 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 4656 nil nil nil 5 nil nil nil 4656 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 148 0 0 0 23 2 0 0 183 0 0 0] 193 4688 nil 4656 962 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 4656 3 8 #() 1154 193 193 nil 27 1186 1632 33 1968 -43 1264 297 1280 71 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 4976 nil nil nil 5 nil nil nil 4976 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 193 5008 nil 4976 962 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 4976 3 8 #() 1154 193 193 nil 27 1186 1632 31 1248 389 1264 141 1280 81 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 5296 nil 816 nil 5 nil nil nil 5296 nil 8 1759007584 850 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 193 5328 8 '...' 5296 962 #isEnabled: 8 #(false) 5296 3 8 #() 1154 193 193 nil 29 1186 1952 -47 1968 -41 1264 151 1280 41 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 5632 nil 816 nil 5 nil nil nil 5632 nil 8 1759007584 850 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 70 1 0 0 33 1 0 0 92 1 0 0] 193 5664 8 'S&how it' 5632 962 #isEnabled: 8 #(false) 5632 3 8 #() 1154 193 193 nil 29 1186 1632 441 1248 139 1264 653 1280 45 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140850688 262145 5968 nil nil nil 5 nil nil nil 5968 nil 8 1759000288 3746 nil nil 1 898 138 144 34 3 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 193 6000 nil 5968 962 #isEnabled: 8 #(false) 5968 962 #setMarginWidths: 34 1 8 #(3 3) 5968 3 8 #() 1154 193 193 nil 27 1186 1632 441 1968 -109 1264 597 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 6320 3666 nil nil 3712 true nil nil 5 nil nil nil 6320 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 193 6352 8 'Write &log file' 6320 3 8 #() 1154 193 193 nil 27 1186 1632 61 1248 251 1264 597 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 6624 nil nil nil 5 nil nil nil 6624 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 241 0 0 0 24 2 0 0 30 1 0 0] 193 6656 nil 6624 962 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 6624 3 8 #() 1154 193 193 nil 27 1186 1632 33 1968 -41 1264 483 1280 91 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 6944 nil nil nil 5 nil nil nil 6944 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[21 0 0 0 187 0 0 0 238 0 0 0 219 0 0 0] 193 6976 nil 6944 962 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 6944 3 8 #() 1154 193 193 nil 27 1186 1632 43 1248 435 1264 375 1280 65 410 ##(Smalltalk.ContainerView) 34 15 nil 3488 34 2 8 1140850688 131073 7264 nil 816 nil 5 nil nil nil 7264 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 7264 34 2 8 1140850944 1 7344 3666 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 7458 #hash 8 #() 787206 ##(Smalltalk.GdiplusImage) nil true 2032390 ##(Smalltalk.GdiplusImageFromFileInitializer) nil 8 'Resources\LagoonLogo.bmp' 1703942 ##(Smalltalk.InstallRelativeFileLocator) 802 #face3d nil 5 nil nil nil 7344 nil 8 4294902547 3746 nil nil nil 7552 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 7376 nil 7344 962 #text: 34 1 8 'Graphic' 7344 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 7264 34 2 8 1140855108 1 7904 nil 816 nil 5 nil nil nil 7904 nil 8 1682719600 3746 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 7936 nil 7904 962 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 2: \par
\par
Choose an Executable File and RuntimeSessionManager\par
\par
\par
\par
}
' 7904 962 #textLimit: 8 #(1073741823) 7904 962 #resetCharFormat 4080 7904 3 8 #() 1154 193 193 nil 27 170 192 4080 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 7296 8 'Heading' 7264 3 34 2 7904 7344 1154 193 193 nil 27 1186 1632 1 1968 1 1264 1 1280 121 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140916352 1025 8592 nil 816 nil 5 nil nil nil 8592 nil 8 1759000288 3746 nil nil 1 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 193 8624 nil 8592 962 #setMarginWidths: 34 1 8 #(3 3) 8592 3 8 #() 1154 193 193 nil 27 1186 1632 431 1968 -109 1264 151 1280 41 410 ##(Smalltalk.GroupBox) 34 14 nil 3488 34 2 8 1140850695 65 8912 nil 816 nil 5 nil nil nil 8912 nil 8 1759007584 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[1 0 0 0 133 0 0 0 44 2 0 0 233 0 0 0] 193 8944 8 '' 8912 3 8 #() 1154 193 193 nil 27 1186 1632 3 1968 -1 1264 267 1280 201 170 192 34 14 3968 8 'runtimeSessionManagerClass' 4352 8 'logReferencesToClasses' 3600 8 'isToGo' 5968 8 'logFileName' 6320 8 'writeLogFile' 8592 8 'executableName' 5632 8 'showLog' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 3520 8 'Step 2' 3488 1 34 14 7264 4976 8592 5296 3600 4656 6944 3968 6624 6320 4352 5968 5632 8912 1154 193 193 nil 27 3458 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 9520 nil nil nil 5 nil nil nil 9520 674 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 9632 nil nil nil 5 nil nil nil 9632 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 193 9664 nil 9632 962 #text: 34 1 8 'Root package:' 9632 3 8 #() 1154 193 193 nil 27 1186 1632 81 1248 201 1264 389 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 262145 9952 nil nil nil 5 nil nil nil 9952 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 193 9984 nil 9952 962 #text: 34 1 8 '' 9952 3 8 #() 1154 193 193 nil 27 1186 1632 361 1968 -107 1264 389 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 9520 34 2 8 1140924451 1 10272 3666 nil nil 3712 true nil nil 5 nil nil nil 10272 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 193 10304 8 'Remove redundant &packages' 10272 3 8 #() 1154 193 193 nil 27 1186 1632 59 1248 329 1264 599 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 10576 nil nil nil 5 nil nil nil 10576 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 193 10608 nil 10576 962 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10576 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -107 1264 499 1280 109 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 10896 nil nil nil 5 nil nil nil 10896 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 193 10928 nil 10896 962 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 10896 3 8 #() 1154 193 193 nil 27 1186 1632 31 1968 -109 1264 171 1280 191 410 ##(Smalltalk.ContainerView) 34 15 nil 9520 34 2 8 1140850688 131073 11216 nil 816 nil 5 nil nil nil 11216 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 11216 34 2 8 1140850944 1 11296 3666 nil false 7426 7458 #= 8 #() 7458 #hash 7520 7538 nil true 7570 nil 8 'Resources\LagoonLogo.bmp' 7632 7648 nil 5 nil nil nil 11296 nil 8 4294902547 3746 nil nil nil 11440 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 11328 nil 11296 962 #text: 34 1 8 'Graphic' 11296 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 11216 34 2 8 1140855108 1 11728 nil 816 nil 5 nil nil nil 11728 nil 8 1682719600 3746 nil nil 41 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 11760 nil 11728 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 3:\par
\par
Configure how the ImageStripper removes unwanted packages\par
\par
\par
\par
}
' 11728 962 #textLimit: 8 #(1073741823) 11728 962 #resetCharFormat 4080 11728 3 8 #() 1154 193 193 nil 27 170 192 4080 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 11248 8 'Heading' 11216 3 34 2 11728 11296 1154 193 193 nil 27 1186 1632 1 1968 1 1264 1 1280 121 170 192 34 4 10272 8 'stripRedundantPackages' 9952 8 'rootPackage' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 9552 8 'Step 3' 9520 1 34 6 11216 10896 9632 9952 10576 10272 1154 193 193 nil 27 3458 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 12640 nil nil nil 5 nil nil nil 12640 674 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 12752 3666 nil nil 3712 false nil nil 5 nil nil nil 12752 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 36 1 0 0 250 0 0 0 60 1 0 0] 193 12784 8 'Remove #&deprecated methods' 12752 3 8 #() 1154 193 193 nil 27 1186 1632 61 1248 441 1218 #fixedPreviousBottom 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13072 3666 nil nil 3712 false nil nil 5 nil nil nil 13072 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 36 1 0 0 9 2 0 0 60 1 0 0] 193 13104 8 'Remove #shouldNot&Implement methods' 13072 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 1218 #fixedPreviousTop 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 13392 nil nil nil 5 nil nil nil 13392 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 193 13424 nil 13392 962 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 13392 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -67 13056 51 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13712 3666 nil nil 3712 false nil nil 5 nil nil nil 13712 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 193 13744 8 'Remove #&subclassResponsibility methods' 13712 3 8 #() 1154 193 193 nil 27 1186 1632 61 1248 441 13056 13 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14016 3666 nil nil 3712 false nil nil 5 nil nil nil 14016 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 220 0 0 0 9 2 0 0 244 0 0 0] 193 14048 8 'Preserve &aspect set methods' 14016 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 13376 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 14320 nil nil nil 5 nil nil nil 14320 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 193 14352 nil 14320 962 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 14320 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -57 1264 149 1280 69 410 ##(Smalltalk.GroupBox) 34 14 nil 12640 34 2 8 1140850695 65 14640 nil 816 nil 5 nil nil nil 14640 nil 8 1759007584 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 193 14672 8 '' 14640 3 8 #() 1154 193 193 nil 27 1186 1632 -17 1968 19 1264 281 1280 229 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14912 3666 nil nil 3712 true nil nil 5 nil nil nil 14912 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 193 14944 8 'Remove redundant &classes' 14912 3 8 #() 1154 193 193 nil 27 1186 1632 61 1248 441 13056 1 1280 49 410 ##(Smalltalk.ContainerView) 34 15 nil 12640 34 2 8 1140850688 131073 15216 nil 816 nil 5 nil nil nil 15216 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 15216 34 2 8 1140850944 1 15296 3666 nil false 7426 7458 #= 8 #() 7458 #hash 7520 7538 nil true 7570 nil 8 'Resources\LagoonLogo.bmp' 7632 7648 nil 5 nil nil nil 15296 nil 8 4294902547 3746 nil nil nil 15440 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 15328 nil 15296 962 #text: 34 1 8 'Graphic' 15296 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 15216 34 2 8 1140855108 1 15728 nil 816 nil 5 nil nil nil 15728 nil 8 1682719600 3746 nil nil 41 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 15760 nil 15728 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 4:\par
\par
Configure how the ImageStripper removes unwanted classes and methods\par
\par
\par
\par
}
' 15728 962 #textLimit: 8 #(1073741823) 15728 962 #resetCharFormat 4080 15728 3 8 #() 1154 193 193 nil 27 170 192 4080 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 15248 8 'Heading' 15216 3 34 2 15728 15296 1154 193 193 nil 27 1186 1632 1 1968 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 16384 3666 nil nil 3712 true nil nil 5 nil nil nil 16384 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 193 16416 8 'Remove redundant &resources' 16384 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 13376 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 16688 3666 nil nil 3712 false nil nil 5 nil nil nil 16688 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 220 0 0 0 250 0 0 0 244 0 0 0] 193 16720 8 'Remove redundant &methods' 16688 3 8 #() 1154 193 193 nil 27 1186 1632 61 1248 441 13056 7 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 16992 nil nil nil 5 nil nil nil 16992 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 12 1 0 0 41 2 0 0 36 1 0 0] 193 17024 nil 16992 962 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 16992 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -7 13056 49 1280 49 170 192 34 14 16384 8 'stripRedundantResources' 14912 8 'stripRedundantClasses' 16688 8 'stripRedundantMethods' 14016 8 'preserveAspectSetters' 13712 8 'stripSubclassResponsibility' 12752 8 'stripDeprecatedMethods' 13072 8 'stripShouldNotImplement' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 12672 8 'Step 4' 12640 1 34 12 15216 14320 14912 16384 13392 16688 14016 16992 12752 13072 13712 14640 1154 193 193 nil 27 3458 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 17648 nil nil nil 5 nil nil nil 17648 674 170 176 34 12 410 ##(Smalltalk.ContainerView) 34 15 nil 17648 34 2 8 1140850688 131073 17760 nil 816 nil 5 nil nil nil 17760 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 17760 34 2 8 1140850944 1 17840 3666 nil false 7426 7458 #= 8 #() 7458 #hash 7520 7538 nil true 7570 nil 8 'Resources\LagoonLogo.bmp' 7632 7648 nil 5 nil nil nil 17840 nil 8 4294902547 3746 nil nil nil 17984 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 17872 nil 17840 962 #text: 34 1 8 'Graphic' 17840 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 17760 34 2 8 1140855108 1 18272 nil 816 nil 5 nil nil nil 18272 nil 8 1682719600 3746 nil nil 41 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 18304 nil 18272 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 7:\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\par
}
' 18272 962 #textLimit: 8 #(1073741823) 18272 962 #resetCharFormat 4080 18272 3 8 #() 1154 193 193 nil 27 170 192 4080 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 17792 8 'Heading' 17760 3 34 2 18272 17840 1154 193 193 nil 27 1186 1632 1 1968 1 1264 1 1280 121 410 ##(Smalltalk.ReferenceView) 34 14 nil 17648 34 2 8 1140850688 131073 18928 nil nil nil 5 nil nil nil 18928 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 163 0 0 0 24 2 0 0 27 1 0 0] 193 18960 8 '' 18928 3 4080 1154 193 193 nil 27 1186 1632 33 1968 -41 1264 327 1280 241 410 ##(Smalltalk.StatusBar) 34 21 nil 17648 34 2 8 1140850700 1 19200 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 19200 nil 8 1758805184 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 19200 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'preStripScriptErrors' nil nil nil 138 144 34 1 19376 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 19200 nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 193 19232 8 '' 19200 3 8 #() 1154 193 193 nil 29 1186 1632 31 1968 -37 1264 571 1280 41 410 ##(Smalltalk.PushButton) 34 20 nil 17648 34 2 8 1140924416 1 19664 nil 816 nil 5 nil nil nil 19664 nil 8 1759007584 850 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[184 1 0 0 69 1 0 0 33 2 0 0 94 1 0 0] 193 19696 8 'Custom &Options' 19664 962 #isEnabled: 8 #(false) 19664 3 8 #() 1154 193 193 nil 29 1186 1632 881 1248 211 1264 651 1280 51 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 20000 nil nil nil 5 nil nil nil 20000 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 66 0 0 0 24 2 0 0 156 0 0 0] 193 20032 nil 20000 962 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 20000 3 8 #() 1154 193 193 nil 27 1186 1632 33 1968 -41 1264 133 1280 181 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 20320 nil nil nil 5 nil nil nil 20320 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 65 1 0 0 154 1 0 0 100 1 0 0] 193 20352 nil 20320 962 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 20320 3 8 #() 1154 193 193 nil 27 1186 1632 31 1248 791 1264 643 1280 71 170 192 34 2 18928 8 'preStripScript' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 17680 8 'Step 7' 17648 1 34 6 17760 20000 18928 19200 20320 19664 1154 193 193 nil 27 3458 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 20880 nil nil nil 5 nil nil nil 20880 674 170 176 34 18 410 ##(Smalltalk.GroupBox) 34 14 nil 20880 34 2 8 1140850695 65 20992 nil 816 nil 5 nil nil nil 20992 nil 8 1759007584 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 193 21024 8 '' 20992 3 8 #() 1154 193 193 nil 27 1186 1632 -17 1968 19 1264 521 1280 229 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 21264 nil nil nil 5 nil nil nil 21264 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 193 21296 nil 21264 962 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 21264 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -107 1264 549 1280 89 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 21584 nil nil nil 5 nil nil nil 21584 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 193 21616 nil 21584 962 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 21584 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -107 1264 149 1280 99 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 21904 3666 nil nil 3712 true nil nil 5 nil nil nil 21904 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 193 21936 8 'Remove class meta-&information' 21904 3 8 #() 1154 193 193 nil 27 1186 1632 81 1248 369 1264 249 1280 59 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 22208 3666 nil nil 3712 false nil nil 5 nil nil nil 22208 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 62 1 0 0 224 0 0 0 86 1 0 0] 193 22240 8 'Compile E&xternal Structures' 22208 3 8 #() 1154 193 193 nil 27 1186 1632 81 1248 369 1264 637 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 22512 nil nil nil 5 nil nil nil 22512 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 193 22544 nil 22512 962 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 22512 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -107 1264 321 1280 69 410 ##(Smalltalk.ContainerView) 34 15 nil 20880 34 2 8 1140850688 131073 22832 nil 816 nil 5 nil nil nil 22832 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 22832 34 2 8 1140850944 1 22912 3666 nil false 7426 7458 #= 8 #() 7458 #hash 7520 7538 nil true 7570 nil 8 'Resources\LagoonLogo.bmp' 7632 7648 nil 5 nil nil nil 22912 nil 8 4294902547 3746 nil nil nil 23056 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 22944 nil 22912 962 #text: 34 1 8 'Graphic' 22912 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 22832 34 2 8 1140855108 1 23344 nil 816 nil 5 nil nil nil 23344 nil 8 1682719600 3746 nil nil 41 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 23376 nil 23344 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 5:\par
\par
Decide what meta-level information is required at runtime\par
\par
\par
\par
}
' 23344 962 #textLimit: 8 #(1073741823) 23344 962 #resetCharFormat 4080 23344 3 8 #() 1154 193 193 nil 27 170 192 4080 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 22864 8 'Heading' 22832 3 34 2 23344 22912 1154 193 193 nil 27 1186 1632 1 1968 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 24000 3666 nil nil 3712 false nil nil 5 nil nil nil 24000 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 193 24032 8 'Retain instance &variable names' 24000 3 8 #() 1154 193 193 nil 27 1186 1632 81 1248 369 1264 389 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 24304 3666 nil nil 3712 false nil nil 5 nil nil nil 24304 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 193 24336 8 'Remove class &GUIDs' 24304 3 8 #() 1154 193 193 nil 27 1186 1632 81 1248 369 1264 459 1280 41 170 192 34 8 24304 8 'stripClassGuids' 24000 8 'retainInstVarNames' 22208 8 'compileExternalStructures' 21904 8 'stripClassInfo' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 20912 8 'Step 5' 20880 1 34 9 22832 21584 21904 22512 24000 24304 21264 22208 20992 1154 193 193 nil 27 3458 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 24896 nil nil nil 5 nil nil nil 24896 674 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 25008 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 25008 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 193 25040 nil 25008 962 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 25008 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -97 1264 349 1280 139 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850955 262145 25376 nil nil nil 5 nil nil nil 25376 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 193 25408 nil 25376 962 #text: 34 1 8 '' 25376 3 8 #() 1154 193 193 nil 27 1186 1632 281 1968 -97 1264 269 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 25696 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 25696 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 193 25728 nil 25696 962 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 25696 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -137 1264 529 1280 81 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 26064 nil nil nil 5 nil nil nil 26064 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 193 26096 nil 26064 962 #text: 34 1 8 'E&xecutable name:' 26064 3 8 #() 1154 193 193 nil 27 1186 1632 81 1248 189 1264 269 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 26384 nil nil nil 5 nil nil nil 26384 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 193 26416 nil 26384 962 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 26384 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -97 1264 161 1280 81 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 26704 nil nil nil 5 nil nil nil 26704 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 193 26736 nil 26704 962 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 26704 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -107 1264 641 1280 59 410 ##(Smalltalk.ContainerView) 34 15 nil 24896 34 2 8 1140850688 131073 27024 nil 816 nil 5 nil nil nil 27024 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 27024 34 2 8 1140850944 1 27104 3666 nil false 7426 7458 #= 8 #() 7458 #hash 7520 7538 nil true 7570 nil 8 'Resources\LagoonLogo.bmp' 7632 7648 nil 5 nil nil nil 27104 nil 8 4294902547 3746 nil nil nil 27248 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 27136 nil 27104 962 #text: 34 1 8 'Graphic' 27104 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 27024 34 2 8 1140855108 1 27536 nil 816 nil 5 nil nil nil 27536 nil 8 1682719600 3746 nil nil 41 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 27568 nil 27536 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Final Step:\par
\par
Deployment\par
\par
\par
\par
}
' 27536 962 #textLimit: 8 #(1073741823) 27536 962 #resetCharFormat 4080 27536 3 8 #() 1154 193 193 nil 27 170 192 4080 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 27056 8 'Heading' 27024 3 34 2 27536 27104 1154 193 193 nil 27 1186 1632 1 1968 1 1264 1 1280 121 170 192 34 2 25376 8 'executablePath2' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 24928 8 'Final step' 24896 1 34 7 27024 26384 26064 25376 25696 25008 26704 1154 193 193 nil 27 3458 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 28432 nil 816 nil 5 nil nil nil 28432 674 170 176 34 8 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28432 34 2 8 1140855110 1 28544 nil 816 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 28658 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 28658 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 28658 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28658 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28722 4097 28610 nil true 34 3 28658 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28658 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28658 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28722 4097 28658 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28544 nil 8 1682719600 3746 nil nil 43 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 193 28576 nil 28544 962 #contextMenu: 34 1 28624 28544 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click Next to continue.\par
\par
\par
\pard\qc\par
}
' 28544 962 #textLimit: 8 #(1073741823) 28544 962 #resetCharFormat 4080 28544 3 8 #() 1154 193 193 nil 27 1186 1632 419 1248 549 1264 681 1280 49 410 ##(Smalltalk.ImageView) 34 21 nil 28432 34 2 8 1140850944 1 29616 3666 nil false 7426 7458 #= 8 #() 7458 #hash 7520 7538 nil true 7570 nil 8 'Resources\LagoonSideBar.jpg' 7632 816 nil 5 nil nil nil 29616 nil 8 4294902547 3746 nil nil nil 29760 #scaleToFit 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 193 29648 nil 29616 962 #text: 34 1 8 'Lagoon Graphic' 29616 3 8 #() 1154 193 193 nil 27 1186 1632 1 1248 379 1264 1 1280 741 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28432 34 2 8 1140855110 1 30064 nil 816 nil 5 28610 nil true 34 10 28658 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 28722 4097 28658 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 28658 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 28658 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28658 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28722 4097 28610 nil true 34 3 28658 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28658 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28658 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28722 4097 28658 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 30064 nil 8 1682719600 3746 nil nil 43 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 193 30096 nil 30064 962 #contextMenu: 34 1 30128 30064 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
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
' 30064 962 #textLimit: 8 #(1073741823) 30064 962 #resetCharFormat 4080 30064 3 8 #() 1154 193 193 nil 27 1186 1632 419 1968 -47 1264 1 1280 489 410 ##(Smalltalk.TextEdit) 34 16 nil 28432 34 2 8 1140850816 262145 31088 nil 802 #whiteSmoke nil 5 nil nil nil 31088 nil 8 1759000288 3746 nil nil 35 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 193 31120 nil 31088 962 #setMarginWidths: 34 1 8 #(3 3) 31088 3 8 #() 1154 193 193 nil 27 1186 1632 421 1968 -49 13056 3 1280 41 170 192 34 2 31088 8 'executablePath1' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 28464 8 'Intro' 28432 3 34 4 29616 30064 31088 28544 1154 193 193 nil 27 3458 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 31664 nil nil nil 5 nil nil nil 31664 674 170 176 34 8 410 ##(Smalltalk.ContainerView) 34 15 nil 31664 34 2 8 1140850688 131073 31776 nil 816 nil 5 nil nil nil 31776 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 31776 34 2 8 1140850944 1 31856 3666 nil false 7426 7458 #= 8 #() 7458 #hash 7520 7538 nil true 7570 nil 8 'Resources\LagoonLogo.bmp' 7632 7648 nil 5 nil nil nil 31856 nil 8 4294902547 3746 nil nil nil 32000 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 31888 nil 31856 962 #text: 34 1 8 'Graphic' 31856 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 31776 34 2 8 1140855108 1 32288 nil 816 nil 5 nil nil nil 32288 nil 8 1682719600 3746 nil nil 41 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 32320 nil 32288 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 1:\par
\par
Choose an ImageStripper to perform the deployment process\par
\par
\par
\par
}
' 32288 962 #textLimit: 8 #(1073741823) 32288 962 #resetCharFormat 4080 32288 3 8 #() 1154 193 193 nil 27 170 192 4080 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 31808 8 'Heading' 31776 3 34 2 32288 31856 1154 193 193 nil 27 1186 1632 1 1968 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 31664 34 2 8 1140850944 1 32944 nil nil nil 5 nil nil nil 32944 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 193 32976 nil 32944 962 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 32944 3 8 #() 1154 193 193 nil 27 1186 1632 81 1248 249 1264 401 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 31664 34 2 8 1140850944 1 33264 nil nil nil 5 nil nil nil 33264 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 193 33296 nil 33264 962 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33264 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -107 1264 229 1280 149 410 ##(Smalltalk.ComboBox) 34 17 nil 31664 34 2 8 1144063491 1025 33584 4034 138 144 4080 nil 4112 816 nil 5 nil nil nil 33584 nil 8 1758616864 ##(Smalltalk.BasicListAbstract) 4144 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[174 0 0 0 204 0 0 0 241 1 0 0 169 1 0 0] 193 33616 8 '' 33584 3 8 #() 1154 193 193 nil 27 1186 1632 349 1968 -119 1264 409 1280 41 170 192 34 2 33584 8 'imageStripperClass' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 31696 8 'Step 1' 31664 1 34 4 31776 33264 32944 33584 1154 193 193 nil 27 3458 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 34128 nil nil nil 5 nil nil nil 34128 674 170 176 34 14 410 ##(Smalltalk.GroupBox) 34 14 nil 34128 34 2 8 1140850695 65 34240 nil 816 nil 5 nil nil nil 34240 nil 8 1759007584 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 193 34272 8 '' 34240 3 8 #() 1154 193 193 nil 27 1186 1632 1 1968 1 1264 327 1280 393 410 ##(Smalltalk.StaticText) 34 16 nil 34128 34 2 8 1140850944 1 34512 nil nil nil 5 nil nil nil 34512 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 193 34544 nil 34512 962 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 34512 3 8 #() 1154 193 193 nil 27 1186 1632 29 1968 -97 1264 161 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 34128 34 2 8 1140924451 1 34832 3666 nil nil 3712 true nil nil 5 nil nil nil 34832 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 193 34864 8 'Fold duplicate b&ytecode arrays' 34832 3 8 #() 1154 193 193 nil 27 1186 1632 71 1248 379 1264 511 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 34128 34 2 8 1140924451 1 35136 3666 nil nil 3712 false nil nil 5 nil nil nil 35136 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 193 35168 8 'Remove &Class Builder' 35136 3 8 #() 1154 193 193 nil 27 1186 1632 81 1248 369 1264 209 1280 41 410 ##(Smalltalk.ContainerView) 34 15 nil 34128 34 2 8 1140850688 131073 35440 nil 816 nil 5 nil nil nil 35440 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 35440 34 2 8 1140850944 1 35520 3666 nil false 7426 7458 #= 8 #() 7458 #hash 7520 7538 nil true 7570 nil 8 'Resources\LagoonLogo.bmp' 7632 7648 nil 5 nil nil nil 35520 nil 8 4294902547 3746 nil nil nil 35664 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 35552 nil 35520 962 #text: 34 1 8 'Graphic' 35520 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 35440 34 2 8 1140855108 1 35952 nil 816 nil 5 nil nil nil 35952 nil 8 1682719600 3746 nil nil 41 nil 8002 8 #[0 0 0 0 0 0 0 0 160 0 154 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 35984 nil 35952 962 #text: 34 1 8210 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 6:\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 35952 962 #textLimit: 8 #(1073741823) 35952 962 #resetCharFormat 4080 35952 3 8 #() 1154 193 193 nil 27 170 192 4080 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 35472 8 'Heading' 35440 3 34 2 35952 35520 1154 193 193 nil 27 1186 1632 1 1968 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 34128 34 2 8 1140924451 1 36608 3666 nil nil 3712 true nil nil 5 nil nil nil 36608 nil 8 1759007584 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 193 36640 8 'Fold duplicate s&trings' 36608 3 8 #() 1154 193 193 nil 27 1186 1632 71 1248 379 1264 451 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 34128 34 2 8 1140850944 1 36912 nil nil nil 5 nil nil nil 36912 nil 8 1759212608 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 193 36944 nil 36912 962 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 36912 3 8 #() 1154 193 193 nil 27 1186 1632 31 1968 -117 1264 391 1280 49 170 192 34 6 35136 8 'stripClassBuilder' 34832 8 'stripDuplicateBytecodes' 36608 8 'stripDuplicateStrings' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 34160 8 'Step 6' 34128 1 34 7 35440 34512 35136 36912 36608 34832 34240 1154 193 193 nil 27 28432 nil nil nil 170 192 34 2 28432 8 'Intro' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 193 3360 8 '' 3328 3 34 9 28432 31664 3488 9520 12640 20880 34128 17648 24896 1154 193 193 nil 27 170 192 34 2 3328 8 'Steps' 3090 1154 1 1 1154 1 1 nil nil nil nil 3 nil nil 1154 2049 881 1154 1151 881 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2006356512 nil nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3090 1154 1 1 1154 1151 881 193 416 962 #setWindowText: 34 1 8 'Lagoon Deployment Wizard' 416 1 34 2 3328 608 1154 193 193 nil 29 )!

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

