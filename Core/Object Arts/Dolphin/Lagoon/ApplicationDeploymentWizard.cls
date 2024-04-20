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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 608 nil nil nil 7 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 736 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 736 nil 8 1797935936 1180998 4 ##(Smalltalk.CommandDescription) #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 193 768 8 '&Next >' 736 962 #isEnabled: 8 #(false) 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 11 1218 #fixedViewLeft 131 1218 #fixedParentTop 1 1218 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1296 nil 816 nil 7 nil nil nil 1296 nil 8 1797935936 850 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 193 1328 8 '< &Back' 1296 962 #isEnabled: 8 #(false) 1296 3 8 #() 1154 193 193 nil 29 1186 1218 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1248 131 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1680 nil 816 nil 7 nil nil nil 1680 nil 8 1797935936 850 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 193 1712 8 '&Reset' 1680 962 #isEnabled: 8 #(false) 1680 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedViewRight -129 1218 #fixedParentRight -429 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2048 nil 816 nil 7 nil nil nil 2048 nil 8 1797935936 850 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 193 2080 8 '&Deploy' 2048 962 #isEnabled: 8 #(false) 2048 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedParentLeft 9 1248 139 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2400 nil 816 nil 7 nil nil nil 2400 nil 8 1797935936 850 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 193 2432 8 '&Save Configuration' 2400 962 #isEnabled: 8 #(false) 2400 3 8 #() 1154 193 193 nil 29 1186 1232 11 1248 241 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2736 nil 816 nil 7 nil nil nil 2736 nil 8 1797935936 850 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 193 2768 8 'Cancel' 2736 3 8 #() 1154 193 193 nil 29 1186 2016 -137 2032 -11 1264 1 1280 49 170 192 34 2 2048 8 'deploy' 590342 ##(Smalltalk.Rectangle) 1154 11 13 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 193 640 8 'Buttons' 608 3 34 6 2048 1296 736 1680 2400 2736 1154 193 193 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3328 nil nil nil 7 nil nil nil 3328 656710 1 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 3488 nil nil nil 5 nil nil nil 3488 674 170 176 34 28 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 3600 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) true nil nil 5 nil nil nil 3600 nil 8 1797935936 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 70 1 0 0 155 0 0 0 90 1 0 0] 193 3632 8 'Log &class references' 3600 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 251 1264 653 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 3968 nil nil nil 5 nil nil nil 3968 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 148 0 0 0 23 2 0 0 183 0 0 0] 193 4000 nil 3968 962 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 3968 3 8 #() 1154 193 193 nil 27 1186 2384 33 2032 -43 1264 297 1280 71 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 4288 nil nil nil 5 nil nil nil 4288 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 241 0 0 0 24 2 0 0 30 1 0 0] 193 4320 nil 4288 962 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 4288 3 8 #() 1154 193 193 nil 27 1186 2384 33 2032 -41 1264 483 1280 91 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 4608 nil nil nil 5 nil nil nil 4608 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 193 4640 nil 4608 962 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 4608 3 8 #() 1154 193 193 nil 27 1186 2384 31 1248 389 1264 141 1280 81 410 ##(Smalltalk.ContainerView) 34 15 nil 3488 34 2 8 1140850688 131073 4928 nil 816 nil 5 nil nil nil 4928 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 4928 34 2 8 1140850944 1 5008 3666 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 5122 #hash 8 #() 787206 ##(Smalltalk.GdiplusImage) nil true 2032390 ##(Smalltalk.GdiplusImageFromFileInitializer) nil 8 'Resources\LagoonLogo.bmp' 1703942 ##(Smalltalk.InstallRelativeFileLocator) 802 #face3d nil 5 nil nil nil 5008 nil 8 4294902547 3746 nil nil nil 5216 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 5040 nil 5008 962 #text: 34 1 8 'Graphic' 5008 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 4928 34 2 8 1140855108 1 5568 nil 816 nil 5 nil nil nil 5568 nil 8 2074821488 3746 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 5600 nil 5568 962 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 2: \par
\par
Choose an Executable File and RuntimeSessionManager\par
\par
\par
\par
}
' 5568 962 #textLimit: 8 #(1073741823) 5568 962 #resetCharFormat 8 #() 5568 3 8 #() 1154 193 193 nil 27 170 192 5968 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 4960 8 'Heading' 4928 3 34 2 5568 5008 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 6272 nil 816 nil 5 nil nil nil 6272 nil 8 1797935936 850 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 193 6304 8 '...' 6272 962 #isEnabled: 8 #(false) 6272 3 8 #() 1154 193 193 nil 29 1186 2016 -47 2032 -41 1264 151 1280 41 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140916352 1025 6608 nil 816 nil 5 nil nil nil 6608 nil 8 1797928640 3746 nil nil 1 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 193 6640 nil 6608 962 #setMarginWidths: 34 1 8 #(3 3) 6608 3 8 #() 1154 193 193 nil 27 1186 2384 431 2032 -109 1264 151 1280 41 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 6928 nil 816 nil 5 nil nil nil 6928 nil 8 1797935936 850 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 70 1 0 0 33 1 0 0 92 1 0 0] 193 6960 8 'S&how it' 6928 962 #isEnabled: 8 #(false) 6928 3 8 #() 1154 193 193 nil 29 1186 2384 441 1248 139 1264 653 1280 45 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 7264 nil nil nil 5 nil nil nil 7264 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[21 0 0 0 187 0 0 0 238 0 0 0 219 0 0 0] 193 7296 nil 7264 962 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 7264 3 8 #() 1154 193 193 nil 27 1186 2384 43 1248 435 1264 375 1280 65 410 ##(Smalltalk.GroupBox) 34 14 nil 3488 34 2 8 1140850695 65 7584 nil 816 nil 5 nil nil nil 7584 nil 8 1797935936 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[1 0 0 0 133 0 0 0 44 2 0 0 233 0 0 0] 193 7616 8 '' 7584 3 8 #() 1154 193 193 nil 27 1186 2384 3 2032 -1 1264 267 1280 201 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140850688 262145 7856 nil nil nil 5 nil nil nil 7856 nil 8 1797928640 3746 nil nil 1 898 138 144 34 3 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 193 7888 nil 7856 962 #isEnabled: 8 #(false) 7856 962 #setMarginWidths: 34 1 8 #(3 3) 7856 3 8 #() 1154 193 193 nil 27 1186 2384 441 2032 -109 1264 597 1280 41 410 ##(Smalltalk.ComboBox) 34 17 nil 3488 34 2 8 1144063491 1025 8208 590662 2 ##(Smalltalk.ListModel) 138 144 5968 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 816 nil 5 nil nil nil 8208 nil 8 1797545264 ##(Smalltalk.BasicListAbstract) 8 #() 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 0 0 0 192 0 0 0 247 1 0 0 158 1 0 0] 193 8240 8 '' 8208 3 8 #() 1154 193 193 nil 27 1186 2384 495 2032 -107 1264 385 1280 47 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 8576 3666 nil nil 3712 true nil nil 5 nil nil nil 8576 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 193 8608 8 'Write &log file' 8576 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 251 1264 597 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 8880 3666 nil nil 3712 false nil nil 517 nil nil nil 8880 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 108 0 0 0 231 0 0 0 133 0 0 0] 193 8912 8 'Create single file, "To Go" distributable.' 8880 3 8 #() 1154 193 193 nil 27 1186 2384 33 1248 431 1264 217 1280 51 170 192 34 14 3600 8 'logReferencesToClasses' 8576 8 'writeLogFile' 8880 8 'isToGo' 7856 8 'logFileName' 6928 8 'showLog' 6608 8 'executableName' 8208 8 'runtimeSessionManagerClass' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 3520 8 'Step 2' 3488 1 34 14 4928 4608 6608 6272 8880 3968 7264 8208 4288 8576 3600 7856 6928 7584 1154 193 193 nil 27 3458 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 9520 nil nil nil 5 nil nil nil 9520 674 170 176 34 12 410 ##(Smalltalk.CheckBox) 34 16 nil 9520 34 2 8 1140924451 1 9632 3666 nil nil 3712 true nil nil 5 nil nil nil 9632 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 193 9664 8 'Remove redundant &packages' 9632 3 8 #() 1154 193 193 nil 27 1186 2384 59 1248 329 1264 599 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 262145 9936 nil nil nil 5 nil nil nil 9936 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 193 9968 nil 9936 962 #text: 34 1 8 '' 9936 3 8 #() 1154 193 193 nil 27 1186 2384 361 2032 -107 1264 389 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 10256 nil nil nil 5 nil nil nil 10256 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 193 10288 nil 10256 962 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10256 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 499 1280 109 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 10576 nil nil nil 5 nil nil nil 10576 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 193 10608 nil 10576 962 #text: 34 1 8 'Root package:' 10576 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 201 1264 389 1280 41 410 ##(Smalltalk.ContainerView) 34 15 nil 9520 34 2 8 1140850688 131073 10896 nil 816 nil 5 nil nil nil 10896 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 10896 34 2 8 1140850944 1 10976 3666 nil false 5090 5122 #= 8 #() 5122 #hash 5184 5202 nil true 5234 nil 8 'Resources\LagoonLogo.bmp' 5296 5312 nil 5 nil nil nil 10976 nil 8 4294902547 3746 nil nil nil 11120 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 11008 nil 10976 962 #text: 34 1 8 'Graphic' 10976 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 10896 34 2 8 1140855108 1 11408 nil 816 nil 5 nil nil nil 11408 nil 8 2074821488 3746 nil nil 41 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 11440 nil 11408 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 3:\par
\par
Configure how the ImageStripper removes unwanted packages\par
\par
\par
\par
}
' 11408 962 #textLimit: 8 #(1073741823) 11408 962 #resetCharFormat 5968 11408 3 8 #() 1154 193 193 nil 27 170 192 5968 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 10928 8 'Heading' 10896 3 34 2 11408 10976 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 12064 nil nil nil 5 nil nil nil 12064 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 193 12096 nil 12064 962 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 12064 3 8 #() 1154 193 193 nil 27 1186 2384 31 2032 -109 1264 171 1280 191 170 192 34 4 9936 8 'rootPackage' 9632 8 'stripRedundantPackages' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 9552 8 'Step 3' 9520 1 34 6 10896 12064 10576 9936 10256 9632 1154 193 193 nil 27 3458 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 12640 nil nil nil 5 nil nil nil 12640 674 170 176 34 24 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 12752 nil nil nil 5 nil nil nil 12752 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 193 12784 nil 12752 962 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 12752 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -57 1264 149 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13072 3666 nil nil 3712 false nil nil 5 nil nil nil 13072 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 36 1 0 0 250 0 0 0 60 1 0 0] 193 13104 8 'Remove #&deprecated methods' 13072 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 441 1218 #fixedPreviousBottom 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13392 3666 nil nil 3712 false nil nil 5 nil nil nil 13392 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 220 0 0 0 250 0 0 0 244 0 0 0] 193 13424 8 'Remove redundant &methods' 13392 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 441 13376 7 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13696 3666 nil nil 3712 true nil nil 5 nil nil nil 13696 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 193 13728 8 'Remove redundant &classes' 13696 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 441 13376 1 1280 49 410 ##(Smalltalk.ContainerView) 34 15 nil 12640 34 2 8 1140850688 131073 14000 nil 816 nil 5 nil nil nil 14000 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 14000 34 2 8 1140850944 1 14080 3666 nil false 5090 5122 #= 8 #() 5122 #hash 5184 5202 nil true 5234 nil 8 'Resources\LagoonLogo.bmp' 5296 5312 nil 5 nil nil nil 14080 nil 8 4294902547 3746 nil nil nil 14224 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 14112 nil 14080 962 #text: 34 1 8 'Graphic' 14080 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 14000 34 2 8 1140855108 1 14512 nil 816 nil 5 nil nil nil 14512 nil 8 2074821488 3746 nil nil 41 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 14544 nil 14512 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 4:\par
\par
Configure how the ImageStripper removes unwanted classes and methods\par
\par
\par
\par
}
' 14512 962 #textLimit: 8 #(1073741823) 14512 962 #resetCharFormat 5968 14512 3 8 #() 1154 193 193 nil 27 170 192 5968 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 14032 8 'Heading' 14000 3 34 2 14512 14080 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 15168 3666 nil nil 3712 false nil nil 5 nil nil nil 15168 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 36 1 0 0 9 2 0 0 60 1 0 0] 193 15200 8 'Remove #shouldNot&Implement methods' 15168 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 1218 #fixedPreviousTop 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 15488 nil nil nil 5 nil nil nil 15488 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 193 15520 nil 15488 962 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 15488 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -67 13376 51 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 15808 3666 nil nil 3712 true nil nil 5 nil nil nil 15808 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 193 15840 8 'Remove redundant &resources' 15808 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 15472 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 16112 3666 nil nil 3712 false nil nil 5 nil nil nil 16112 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 220 0 0 0 9 2 0 0 244 0 0 0] 193 16144 8 'Preserve &aspect set methods' 16112 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 15472 1 1280 49 410 ##(Smalltalk.GroupBox) 34 14 nil 12640 34 2 8 1140850695 65 16416 nil 816 nil 5 nil nil nil 16416 nil 8 1797935936 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 193 16448 8 '' 16416 3 8 #() 1154 193 193 nil 27 1186 2384 -17 2032 19 1264 281 1280 229 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 16688 nil nil nil 5 nil nil nil 16688 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 12 1 0 0 41 2 0 0 36 1 0 0] 193 16720 nil 16688 962 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 16688 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -7 13376 49 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 17008 3666 nil nil 3712 false nil nil 5 nil nil nil 17008 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 193 17040 8 'Remove #&subclassResponsibility methods' 17008 3 8 #() 1154 193 193 nil 27 1186 2384 61 1248 441 13376 13 1280 49 170 192 34 14 15168 8 'stripShouldNotImplement' 15808 8 'stripRedundantResources' 17008 8 'stripSubclassResponsibility' 13072 8 'stripDeprecatedMethods' 13392 8 'stripRedundantMethods' 13696 8 'stripRedundantClasses' 16112 8 'preserveAspectSetters' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 12672 8 'Step 4' 12640 1 34 12 14000 12752 13696 15808 15488 13392 16112 16688 13072 15168 17008 16416 1154 193 193 nil 27 3458 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 17648 nil nil nil 5 nil nil nil 17648 674 170 176 34 12 410 ##(Smalltalk.ContainerView) 34 15 nil 17648 34 2 8 1140850688 131073 17760 nil 816 nil 5 nil nil nil 17760 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 17760 34 2 8 1140850944 1 17840 3666 nil false 5090 5122 #= 8 #() 5122 #hash 5184 5202 nil true 5234 nil 8 'Resources\LagoonLogo.bmp' 5296 5312 nil 5 nil nil nil 17840 nil 8 4294902547 3746 nil nil nil 17984 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 17872 nil 17840 962 #text: 34 1 8 'Graphic' 17840 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 17760 34 2 8 1140855108 1 18272 nil 816 nil 5 nil nil nil 18272 nil 8 2074821488 3746 nil nil 41 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 18304 nil 18272 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 7:\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\par
}
' 18272 962 #textLimit: 8 #(1073741823) 18272 962 #resetCharFormat 5968 18272 3 8 #() 1154 193 193 nil 27 170 192 5968 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 17792 8 'Heading' 17760 3 34 2 18272 17840 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.PushButton) 34 20 nil 17648 34 2 8 1140924416 1 18928 nil 816 nil 5 nil nil nil 18928 nil 8 1797935936 850 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[184 1 0 0 69 1 0 0 33 2 0 0 94 1 0 0] 193 18960 8 'Custom &Options' 18928 962 #isEnabled: 8 #(false) 18928 3 8 #() 1154 193 193 nil 29 1186 2384 881 1248 211 1264 651 1280 51 410 ##(Smalltalk.ReferenceView) 34 14 nil 17648 34 2 8 1140850688 131073 19264 nil nil nil 5 nil nil nil 19264 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 163 0 0 0 24 2 0 0 27 1 0 0] 193 19296 8 '' 19264 3 5968 1154 193 193 nil 27 1186 2384 33 2032 -41 1264 327 1280 241 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 19536 nil nil nil 5 nil nil nil 19536 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 65 1 0 0 154 1 0 0 100 1 0 0] 193 19568 nil 19536 962 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 19536 3 8 #() 1154 193 193 nil 27 1186 2384 31 1248 791 1264 643 1280 71 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 19856 nil nil nil 5 nil nil nil 19856 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 66 0 0 0 24 2 0 0 156 0 0 0] 193 19888 nil 19856 962 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 19856 3 8 #() 1154 193 193 nil 27 1186 2384 33 2032 -41 1264 133 1280 181 410 ##(Smalltalk.StatusBar) 34 18 nil 17648 34 2 8 1140850700 1 20176 nil nil nil 5 nil 498 nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 193 nil nil 20176 nil 8 1797733600 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 20176 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'preStripScriptErrors' 138 144 34 1 20368 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 20176 nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 193 20208 8 '' 20176 3 8 #() 1154 193 193 nil 27 1186 2384 31 2032 -37 1264 571 1280 41 170 192 34 2 19264 8 'preStripScript' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 17680 8 'Step 7' 17648 1 34 6 17760 19856 19264 20176 19536 18928 1154 193 193 nil 27 3458 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 20896 nil nil nil 5 nil nil nil 20896 674 170 176 34 18 410 ##(Smalltalk.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 21008 3666 nil nil 3712 true nil nil 5 nil nil nil 21008 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 193 21040 8 'Remove class meta-&information' 21008 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 249 1280 59 410 ##(Smalltalk.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 21312 3666 nil nil 3712 false nil nil 5 nil nil nil 21312 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 62 1 0 0 224 0 0 0 86 1 0 0] 193 21344 8 'Compile E&xternal Structures' 21312 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 637 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 21616 nil nil nil 5 nil nil nil 21616 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 193 21648 nil 21616 962 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 21616 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 321 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 21936 3666 nil nil 3712 false nil nil 5 nil nil nil 21936 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 193 21968 8 'Retain instance &variable names' 21936 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 389 1280 69 410 ##(Smalltalk.GroupBox) 34 14 nil 20896 34 2 8 1140850695 65 22240 nil 816 nil 5 nil nil nil 22240 nil 8 1797935936 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 193 22272 8 '' 22240 3 8 #() 1154 193 193 nil 27 1186 2384 -17 2032 19 1264 521 1280 229 410 ##(Smalltalk.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 22512 nil nil nil 5 nil nil nil 22512 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 193 22544 nil 22512 962 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 22512 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 549 1280 89 410 ##(Smalltalk.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 22832 nil nil nil 5 nil nil nil 22832 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 193 22864 nil 22832 962 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 22832 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 149 1280 99 410 ##(Smalltalk.ContainerView) 34 15 nil 20896 34 2 8 1140850688 131073 23152 nil 816 nil 5 nil nil nil 23152 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 23152 34 2 8 1140850944 1 23232 3666 nil false 5090 5122 #= 8 #() 5122 #hash 5184 5202 nil true 5234 nil 8 'Resources\LagoonLogo.bmp' 5296 5312 nil 5 nil nil nil 23232 nil 8 4294902547 3746 nil nil nil 23376 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 23264 nil 23232 962 #text: 34 1 8 'Graphic' 23232 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 23152 34 2 8 1140855108 1 23664 nil 816 nil 5 nil nil nil 23664 nil 8 2074821488 3746 nil nil 41 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 23696 nil 23664 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 5:\par
\par
Decide what meta-level information is required at runtime\par
\par
\par
\par
}
' 23664 962 #textLimit: 8 #(1073741823) 23664 962 #resetCharFormat 5968 23664 3 8 #() 1154 193 193 nil 27 170 192 5968 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 23184 8 'Heading' 23152 3 34 2 23664 23232 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 24320 3666 nil nil 3712 false nil nil 5 nil nil nil 24320 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 193 24352 8 'Remove class &GUIDs' 24320 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 459 1280 41 170 192 34 8 21008 8 'stripClassInfo' 21936 8 'retainInstVarNames' 21312 8 'compileExternalStructures' 24320 8 'stripClassGuids' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 20928 8 'Step 5' 20896 1 34 9 23152 22832 21008 21616 21936 24320 22512 21312 22240 1154 193 193 nil 27 3458 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 24912 nil nil nil 5 nil nil nil 24912 674 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 25024 nil nil nil 5 nil nil nil 25024 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 193 25056 nil 25024 962 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 25024 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 641 1280 59 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 25344 nil nil nil 5 nil nil nil 25344 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 193 25376 nil 25344 962 #text: 34 1 8 'E&xecutable name:' 25344 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 189 1264 269 1280 49 410 ##(Smalltalk.ContainerView) 34 15 nil 24912 34 2 8 1140850688 131073 25664 nil 816 nil 5 nil nil nil 25664 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 25664 34 2 8 1140850944 1 25744 3666 nil false 5090 5122 #= 8 #() 5122 #hash 5184 5202 nil true 5234 nil 8 'Resources\LagoonLogo.bmp' 5296 5312 nil 5 nil nil nil 25744 nil 8 4294902547 3746 nil nil nil 25888 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 25776 nil 25744 962 #text: 34 1 8 'Graphic' 25744 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 25664 34 2 8 1140855108 1 26176 nil 816 nil 5 nil nil nil 26176 nil 8 2074821488 3746 nil nil 41 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 26208 nil 26176 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Final Step:\par
\par
Deployment\par
\par
\par
\par
}
' 26176 962 #textLimit: 8 #(1073741823) 26176 962 #resetCharFormat 5968 26176 3 8 #() 1154 193 193 nil 27 170 192 5968 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 25696 8 'Heading' 25664 3 34 2 26176 25744 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850955 262145 26832 nil nil nil 5 nil nil nil 26832 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 193 26864 nil 26832 962 #text: 34 1 8 '' 26832 3 8 #() 1154 193 193 nil 27 1186 2384 281 2032 -97 1264 269 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 27152 nil nil nil 5 nil 498 nil true 20258 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 193 nil nil 27152 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 193 27184 nil 27152 962 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 27152 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -97 1264 349 1280 139 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 27520 nil nil nil 5 nil 498 nil true 20258 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 193 nil nil 27520 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 193 27552 nil 27520 962 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 27520 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -137 1264 529 1280 81 410 ##(Smalltalk.StaticText) 34 16 nil 24912 34 2 8 1140850944 1 27888 nil nil nil 5 nil nil nil 27888 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 193 27920 nil 27888 962 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 27888 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -97 1264 161 1280 81 170 192 34 2 26832 8 'executablePath2' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 24944 8 'Final step' 24912 1 34 7 25664 27888 25344 26832 27520 27152 25024 1154 193 193 nil 27 3458 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 28448 nil 816 nil 7 nil nil nil 28448 674 170 176 34 8 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28448 34 2 8 1140855110 1 28560 nil 816 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 28674 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 28674 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 28674 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28674 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28738 4097 28626 nil true 34 3 28674 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28674 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28674 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28738 4097 28674 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28560 nil 8 2074821488 3746 nil nil 43 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 193 28592 nil 28560 962 #contextMenu: 34 1 28640 28560 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
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
' 28560 962 #textLimit: 8 #(1073741823) 28560 962 #resetCharFormat 5968 28560 3 8 #() 1154 193 193 nil 27 1186 2384 419 2032 -47 1264 1 1280 489 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28448 34 2 8 1140855110 1 29632 nil 816 nil 7 28626 nil true 34 10 28674 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 28738 4097 28674 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 28674 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 28674 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28674 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28738 4097 28626 nil true 34 3 28674 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28674 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28674 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28738 4097 28674 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29632 nil 8 2074821488 3746 nil nil 43 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 193 29664 nil 29632 962 #contextMenu: 34 1 29696 29632 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click Next to continue.\par
\par
\par
\pard\qc\par
}
' 29632 962 #textLimit: 8 #(1073741823) 29632 962 #resetCharFormat 5968 29632 3 8 #() 1154 193 193 nil 27 1186 2384 419 1248 549 1264 681 1280 49 410 ##(Smalltalk.ImageView) 34 21 nil 28448 34 2 8 1140850944 1 30656 3666 nil false 5090 5122 #= 8 #() 5122 #hash 5184 5202 nil true 5234 nil 8 'Resources\LagoonSideBar.jpg' 5296 816 nil 7 nil nil nil 30656 nil 8 4294902547 3746 nil nil nil 30800 #scaleToFit 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 193 30688 nil 30656 962 #text: 34 1 8 'Lagoon Graphic' 30656 3 8 #() 1154 193 193 nil 27 1186 2384 1 1248 379 1264 1 1280 741 410 ##(Smalltalk.TextEdit) 34 16 nil 28448 34 2 8 1140850816 262145 31104 nil 802 #whiteSmoke nil 7 nil nil nil 31104 nil 8 1797928640 3746 nil nil 35 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 193 31136 nil 31104 962 #setMarginWidths: 34 1 8 #(3 3) 31104 3 8 #() 1154 193 193 nil 27 1186 2384 421 2032 -49 13376 3 1280 41 170 192 34 2 31104 8 'executablePath1' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 28480 8 'Intro' 28448 3 34 4 30656 28560 31104 29632 1154 193 193 nil 27 3458 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 31680 nil nil nil 5 nil nil nil 31680 674 170 176 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 31680 34 2 8 1144063491 1025 31792 8274 138 144 5968 nil 8336 816 nil 5 nil nil nil 31792 nil 8 1797545264 ##(Smalltalk.BasicListAbstract) 8368 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[174 0 0 0 204 0 0 0 241 1 0 0 170 1 0 0] 193 31824 8 '' 31792 3 8 #() 1154 193 193 nil 27 1186 2384 349 2032 -119 1264 409 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 31680 34 2 8 1140850944 1 32096 nil nil nil 5 nil nil nil 32096 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 193 32128 nil 32096 962 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 32096 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 249 1264 401 1280 121 410 ##(Smalltalk.ContainerView) 34 15 nil 31680 34 2 8 1140850688 131073 32416 nil 816 nil 5 nil nil nil 32416 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 32416 34 2 8 1140850944 1 32496 3666 nil false 5090 5122 #= 8 #() 5122 #hash 5184 5202 nil true 5234 nil 8 'Resources\LagoonLogo.bmp' 5296 5312 nil 5 nil nil nil 32496 nil 8 4294902547 3746 nil nil nil 32640 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 32528 nil 32496 962 #text: 34 1 8 'Graphic' 32496 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 32416 34 2 8 1140855108 1 32928 nil 816 nil 5 nil nil nil 32928 nil 8 2074821488 3746 nil nil 41 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 32960 nil 32928 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 1:\par
\par
Choose an ImageStripper to perform the deployment process\par
\par
\par
\par
}
' 32928 962 #textLimit: 8 #(1073741823) 32928 962 #resetCharFormat 5968 32928 3 8 #() 1154 193 193 nil 27 170 192 5968 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 32448 8 'Heading' 32416 3 34 2 32928 32496 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 31680 34 2 8 1140850944 1 33584 nil nil nil 5 nil nil nil 33584 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 193 33616 nil 33584 962 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33584 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -107 1264 229 1280 149 170 192 34 2 31792 8 'imageStripperClass' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 31712 8 'Step 1' 31680 1 34 4 32416 33584 32096 31792 1154 193 193 nil 27 3458 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 34144 nil nil nil 5 nil nil nil 34144 674 170 176 34 14 410 ##(Smalltalk.CheckBox) 34 16 nil 34144 34 2 8 1140924451 1 34256 3666 nil nil 3712 false nil nil 5 nil nil nil 34256 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 193 34288 8 'Remove &Class Builder' 34256 3 8 #() 1154 193 193 nil 27 1186 2384 81 1248 369 1264 209 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 34144 34 2 8 1140850944 1 34560 nil nil nil 5 nil nil nil 34560 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 193 34592 nil 34560 962 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 34560 3 8 #() 1154 193 193 nil 27 1186 2384 29 2032 -97 1264 161 1280 49 410 ##(Smalltalk.ContainerView) 34 15 nil 34144 34 2 8 1140850688 131073 34880 nil 816 nil 5 nil nil nil 34880 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 34880 34 2 8 1140850944 1 34960 3666 nil false 5090 5122 #= 8 #() 5122 #hash 5184 5202 nil true 5234 nil 8 'Resources\LagoonLogo.bmp' 5296 5312 nil 5 nil nil nil 34960 nil 8 4294902547 3746 nil nil nil 35104 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 34992 nil 34960 962 #text: 34 1 8 'Graphic' 34960 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 34880 34 2 8 1140855108 1 35392 nil 816 nil 5 nil nil nil 35392 nil 8 2074821488 3746 nil nil 41 nil 5666 8 #[0 0 0 0 0 0 0 0 176 0 9 5] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 35424 nil 35392 962 #text: 34 1 5874 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 6:\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 35392 962 #textLimit: 8 #(1073741823) 35392 962 #resetCharFormat 5968 35392 3 8 #() 1154 193 193 nil 27 170 192 5968 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 34912 8 'Heading' 34880 3 34 2 35392 34960 1154 193 193 nil 27 1186 2384 1 2032 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 34144 34 2 8 1140924451 1 36048 3666 nil nil 3712 true nil nil 5 nil nil nil 36048 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 193 36080 8 'Fold duplicate b&ytecode arrays' 36048 3 8 #() 1154 193 193 nil 27 1186 2384 71 1248 379 1264 511 1280 41 410 ##(Smalltalk.GroupBox) 34 14 nil 34144 34 2 8 1140850695 65 36352 nil 816 nil 5 nil nil nil 36352 nil 8 1797935936 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 193 36384 8 '' 36352 3 8 #() 1154 193 193 nil 27 1186 2384 1 2032 1 1264 327 1280 393 410 ##(Smalltalk.CheckBox) 34 16 nil 34144 34 2 8 1140924451 1 36624 3666 nil nil 3712 true nil nil 5 nil nil nil 36624 nil 8 1797935936 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 193 36656 8 'Fold duplicate s&trings' 36624 3 8 #() 1154 193 193 nil 27 1186 2384 71 1248 379 1264 451 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 34144 34 2 8 1140850944 1 36928 nil nil nil 5 nil nil nil 36928 nil 8 1798140960 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 193 36960 nil 36928 962 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 36928 3 8 #() 1154 193 193 nil 27 1186 2384 31 2032 -117 1264 391 1280 49 170 192 34 6 34256 8 'stripClassBuilder' 36048 8 'stripDuplicateBytecodes' 36624 8 'stripDuplicateStrings' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 34176 8 'Step 6' 34144 1 34 7 34880 34560 34256 36928 36624 36048 36352 1154 193 193 nil 27 28448 nil nil nil 170 192 34 2 28448 8 'Intro' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 193 3360 8 '' 3328 3 34 9 28448 31680 3488 9520 12640 20896 34144 17648 24912 1154 193 193 nil 27 170 192 34 2 3328 8 'Steps' 3090 1154 1 1 1154 1 1 nil nil nil nil 3 nil nil 1154 2049 881 1154 1151 881 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2005044496 898 138 144 34 2 962 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1042 8 #[255 9 0 0 10 0 0 0 62 12 0 0 194 1 0 0] 193 416 962 #setWindowText: 34 1 8 'Lagoon Deployment Wizard' 416 1 34 2 3328 608 1154 193 193 nil 27 )!

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

