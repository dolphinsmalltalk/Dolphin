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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 608 nil nil nil 7 nil nil nil 608 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 736 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 736 nil 8 1795707744 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 193 768 8 '&Save Configuration' 736 962 #isEnabled: 8 #(false) 736 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 11 1218 #fixedViewLeft 241 1218 #fixedParentTop 1 1218 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1296 nil 816 nil 7 nil nil nil 1296 nil 8 1795707744 850 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 193 1328 8 '&Reset' 1296 962 #isEnabled: 8 #(false) 1296 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedViewRight -129 1218 #fixedParentRight -429 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 1664 nil 816 nil 7 nil nil nil 1664 nil 8 1795707744 850 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 193 1696 8 '&Deploy' 1664 962 #isEnabled: 8 #(false) 1664 3 8 #() 1154 193 193 nil 29 1186 1218 #fixedParentLeft 9 1248 139 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2016 nil 816 nil 7 nil nil nil 2016 nil 8 1795707744 850 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 193 2048 8 'Cancel' 2016 3 8 #() 1154 193 193 nil 29 1186 1632 -137 1648 -11 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2320 nil 816 nil 7 nil nil nil 2320 nil 8 1795707744 850 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 193 2352 8 '< &Back' 2320 962 #isEnabled: 8 #(false) 2320 3 8 #() 1154 193 193 nil 29 1186 1218 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1248 131 1264 1 1280 49 410 ##(Smalltalk.PushButton) 34 20 nil 608 34 2 8 1140924416 1 2704 nil 816 nil 7 nil nil nil 2704 nil 8 1795707744 850 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 193 2736 8 '&Next >' 2704 962 #isEnabled: 8 #(false) 2704 3 8 #() 1154 193 193 nil 29 1186 1232 11 1248 131 1264 1 1280 49 170 192 34 2 1664 8 'deploy' 590342 ##(Smalltalk.Rectangle) 1154 11 13 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 193 640 8 'Buttons' 608 3 34 6 1664 2320 2704 1296 736 2016 1154 193 193 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3328 nil nil nil 7 nil nil nil 3328 656710 1 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 3488 nil nil nil 5 nil nil nil 3488 674 170 176 34 28 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 3600 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) true nil nil 5 nil nil nil 3600 nil 8 1795707744 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 70 1 0 0 155 0 0 0 90 1 0 0] 193 3632 8 'Log &class references' 3600 3 8 #() 1154 193 193 nil 27 1186 2000 61 1248 251 1264 653 1280 41 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 3968 nil 816 nil 5 nil nil nil 3968 nil 8 1795707744 850 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 193 4000 8 '...' 3968 962 #isEnabled: 8 #(false) 3968 3 8 #() 1154 193 193 nil 29 1186 1632 -47 1648 -41 1264 151 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 4304 nil nil nil 5 nil nil nil 4304 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 241 0 0 0 24 2 0 0 30 1 0 0] 193 4336 nil 4304 962 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 4304 3 8 #() 1154 193 193 nil 27 1186 2000 33 1648 -41 1264 483 1280 91 410 ##(Smalltalk.GroupBox) 34 14 nil 3488 34 2 8 1140850695 65 4624 nil 816 nil 5 nil nil nil 4624 nil 8 1795707744 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[1 0 0 0 133 0 0 0 44 2 0 0 233 0 0 0] 193 4656 8 '' 4624 3 8 #() 1154 193 193 nil 27 1186 2000 3 1648 -1 1264 267 1280 201 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 4896 nil nil nil 5 nil nil nil 4896 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 193 4928 nil 4896 962 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 4896 3 8 #() 1154 193 193 nil 27 1186 2000 31 1248 389 1264 141 1280 81 410 ##(Smalltalk.ComboBox) 34 17 nil 3488 34 2 8 1144063491 1025 5216 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 816 nil 5 nil nil nil 5216 nil 8 1795317024 ##(Smalltalk.BasicListAbstract) 8 #() 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 0 0 0 192 0 0 0 247 1 0 0 157 1 0 0] 193 5248 8 '' 5216 3 8 #() 1154 193 193 nil 27 1186 2000 495 1648 -107 1264 385 1280 47 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140850688 262145 5600 nil nil nil 5 nil nil nil 5600 nil 8 1795700448 3746 nil nil 1 898 138 144 34 3 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 193 5632 nil 5600 962 #isEnabled: 8 #(false) 5600 962 #setMarginWidths: 34 1 8 #(3 3) 5600 3 8 #() 1154 193 193 nil 27 1186 2000 441 1648 -109 1264 597 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 5952 3666 nil nil 3712 true nil nil 5 nil nil nil 5952 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 193 5984 8 'Write &log file' 5952 3 8 #() 1154 193 193 nil 27 1186 2000 61 1248 251 1264 597 1280 41 410 ##(Smalltalk.ContainerView) 34 15 nil 3488 34 2 8 1140850688 131073 6256 nil 816 nil 5 nil nil nil 6256 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 6256 34 2 8 1140850944 1 6336 3666 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 6450 #hash 8 #() 787206 ##(Smalltalk.GdiplusImage) nil true 2032390 ##(Smalltalk.GdiplusImageFromFileInitializer) nil 8 'Resources\LagoonLogo.bmp' 1703942 ##(Smalltalk.InstallRelativeFileLocator) 802 #face3d nil 5 nil nil nil 6336 nil 8 4294902547 3746 nil nil nil 6544 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 6368 nil 6336 962 #text: 34 1 8 'Graphic' 6336 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 6256 34 2 8 1140855108 1 6896 nil 816 nil 5 nil nil nil 6896 nil 8 1503347568 3746 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 6928 nil 6896 962 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 2: \par
\par
Choose an Executable File and RuntimeSessionManager\par
\par
\par
\par
}
' 6896 962 #textLimit: 8 #(1073741823) 6896 962 #resetCharFormat 5328 6896 3 8 #() 1154 193 193 nil 27 170 192 5328 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 6288 8 'Heading' 6256 3 34 2 6896 6336 1154 193 193 nil 27 1186 2000 1 1648 1 1264 1 1280 121 410 ##(Smalltalk.TextEdit) 34 16 nil 3488 34 2 8 1140916352 1025 7584 nil 816 nil 5 nil nil nil 7584 nil 8 1795700448 3746 nil nil 1 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 193 7616 nil 7584 962 #setMarginWidths: 34 1 8 #(3 3) 7584 3 8 #() 1154 193 193 nil 27 1186 2000 431 1648 -109 1264 151 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 7904 nil nil nil 5 nil nil nil 7904 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[21 0 0 0 187 0 0 0 238 0 0 0 219 0 0 0] 193 7936 nil 7904 962 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 7904 3 8 #() 1154 193 193 nil 27 1186 2000 43 1248 435 1264 375 1280 65 410 ##(Smalltalk.CheckBox) 34 16 nil 3488 34 2 8 1140924451 1 8224 3666 nil nil 3712 false nil nil 517 nil nil nil 8224 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 108 0 0 0 231 0 0 0 133 0 0 0] 193 8256 8 'Create single file, "To Go" distributable.' 8224 3 8 #() 1154 193 193 nil 27 1186 2000 33 1248 431 1264 217 1280 51 410 ##(Smalltalk.StaticText) 34 16 nil 3488 34 2 8 1140850944 1 8528 nil nil nil 5 nil nil nil 8528 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 148 0 0 0 23 2 0 0 183 0 0 0] 193 8560 nil 8528 962 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 8528 3 8 #() 1154 193 193 nil 27 1186 2000 33 1648 -43 1264 297 1280 71 410 ##(Smalltalk.PushButton) 34 20 nil 3488 34 2 8 1140924416 1 8848 nil 816 nil 5 nil nil nil 8848 nil 8 1795707744 850 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[220 0 0 0 70 1 0 0 33 1 0 0 92 1 0 0] 193 8880 8 'S&how it' 8848 962 #isEnabled: 8 #(false) 8848 3 8 #() 1154 193 193 nil 29 1186 2000 441 1248 139 1264 653 1280 45 170 192 34 14 7584 8 'executableName' 5216 8 'runtimeSessionManagerClass' 8224 8 'isToGo' 5600 8 'logFileName' 3600 8 'logReferencesToClasses' 5952 8 'writeLogFile' 8848 8 'showLog' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 3520 8 'Step 2' 3488 1 34 14 6256 4896 7584 3968 8224 8528 7904 5216 4304 5952 3600 5600 8848 4624 1154 193 193 nil 27 3458 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 9520 nil nil nil 5 nil nil nil 9520 674 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 9632 nil nil nil 5 nil nil nil 9632 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 193 9664 nil 9632 962 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 9632 3 8 #() 1154 193 193 nil 27 1186 2000 31 1648 -109 1264 171 1280 191 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 9952 nil nil nil 5 nil nil nil 9952 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 193 9984 nil 9952 962 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 9952 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -107 1264 499 1280 109 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 262145 10272 nil nil nil 5 nil nil nil 10272 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 193 10304 nil 10272 962 #text: 34 1 8 '' 10272 3 8 #() 1154 193 193 nil 27 1186 2000 361 1648 -107 1264 389 1280 41 410 ##(Smalltalk.CheckBox) 34 16 nil 9520 34 2 8 1140924451 1 10592 3666 nil nil 3712 true nil nil 5 nil nil nil 10592 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 193 10624 8 'Remove redundant &packages' 10592 3 8 #() 1154 193 193 nil 27 1186 2000 59 1248 329 1264 599 1280 49 410 ##(Smalltalk.ContainerView) 34 15 nil 9520 34 2 8 1140850688 131073 10896 nil 816 nil 5 nil nil nil 10896 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 10896 34 2 8 1140850944 1 10976 3666 nil false 6418 6450 #= 8 #() 6450 #hash 6512 6530 nil true 6562 nil 8 'Resources\LagoonLogo.bmp' 6624 6640 nil 5 nil nil nil 10976 nil 8 4294902547 3746 nil nil nil 11120 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 11008 nil 10976 962 #text: 34 1 8 'Graphic' 10976 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 10896 34 2 8 1140855108 1 11408 nil 816 nil 5 nil nil nil 11408 nil 8 1503347568 3746 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 11440 nil 11408 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 3:\par
\par
Configure how the ImageStripper removes unwanted packages\par
\par
\par
\par
}
' 11408 962 #textLimit: 8 #(1073741823) 11408 962 #resetCharFormat 5328 11408 3 8 #() 1154 193 193 nil 27 170 192 5328 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 10928 8 'Heading' 10896 3 34 2 11408 10976 1154 193 193 nil 27 1186 2000 1 1648 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 9520 34 2 8 1140850944 1 12064 nil nil nil 5 nil nil nil 12064 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 193 12096 nil 12064 962 #text: 34 1 8 'Root package:' 12064 3 8 #() 1154 193 193 nil 27 1186 2000 81 1248 201 1264 389 1280 41 170 192 34 4 10272 8 'rootPackage' 10592 8 'stripRedundantPackages' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 9552 8 'Step 3' 9520 1 34 6 10896 9632 12064 10272 9952 10592 1154 193 193 nil 27 3458 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 12640 nil nil nil 5 nil nil nil 12640 674 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 12752 3666 nil nil 3712 false nil nil 5 nil nil nil 12752 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 36 1 0 0 9 2 0 0 60 1 0 0] 193 12784 8 'Remove #shouldNot&Implement methods' 12752 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 1218 #fixedPreviousTop 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13072 3666 nil nil 3712 false nil nil 5 nil nil nil 13072 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 36 1 0 0 250 0 0 0 60 1 0 0] 193 13104 8 'Remove #&deprecated methods' 13072 3 8 #() 1154 193 193 nil 27 1186 2000 61 1248 441 1218 #fixedPreviousBottom 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 13392 nil nil nil 5 nil nil nil 13392 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 12 1 0 0 41 2 0 0 36 1 0 0] 193 13424 nil 13392 962 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 13392 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -7 13376 49 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 13712 3666 nil nil 3712 false nil nil 5 nil nil nil 13712 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 220 0 0 0 9 2 0 0 244 0 0 0] 193 13744 8 'Preserve &aspect set methods' 13712 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 13056 1 1280 49 410 ##(Smalltalk.GroupBox) 34 14 nil 12640 34 2 8 1140850695 65 14016 nil 816 nil 5 nil nil nil 14016 nil 8 1795707744 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 193 14048 8 '' 14016 3 8 #() 1154 193 193 nil 27 1186 2000 -17 1648 19 1264 281 1280 229 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14288 3666 nil nil 3712 false nil nil 5 nil nil nil 14288 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 193 14320 8 'Remove #&subclassResponsibility methods' 14288 3 8 #() 1154 193 193 nil 27 1186 2000 61 1248 441 13376 13 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 14592 nil nil nil 5 nil nil nil 14592 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 193 14624 nil 14592 962 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 14592 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -67 13376 51 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 14912 3666 nil nil 3712 true nil nil 5 nil nil nil 14912 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 193 14944 8 'Remove redundant &classes' 14912 3 8 #() 1154 193 193 nil 27 1186 2000 61 1248 441 13376 1 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 12640 34 2 8 1140850944 1 15216 nil nil nil 5 nil nil nil 15216 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 193 15248 nil 15216 962 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 15216 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -57 1264 149 1280 69 410 ##(Smalltalk.ContainerView) 34 15 nil 12640 34 2 8 1140850688 131073 15536 nil 816 nil 5 nil nil nil 15536 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 15536 34 2 8 1140850944 1 15616 3666 nil false 6418 6450 #= 8 #() 6450 #hash 6512 6530 nil true 6562 nil 8 'Resources\LagoonLogo.bmp' 6624 6640 nil 5 nil nil nil 15616 nil 8 4294902547 3746 nil nil nil 15760 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 15648 nil 15616 962 #text: 34 1 8 'Graphic' 15616 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 15536 34 2 8 1140855108 1 16048 nil 816 nil 5 nil nil nil 16048 nil 8 1503347568 3746 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 16080 nil 16048 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 4:\par
\par
Configure how the ImageStripper removes unwanted classes and methods\par
\par
\par
\par
}
' 16048 962 #textLimit: 8 #(1073741823) 16048 962 #resetCharFormat 5328 16048 3 8 #() 1154 193 193 nil 27 170 192 5328 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 15568 8 'Heading' 15536 3 34 2 16048 15616 1154 193 193 nil 27 1186 2000 1 1648 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 16704 3666 nil nil 3712 true nil nil 5 nil nil nil 16704 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 193 16736 8 'Remove redundant &resources' 16704 3 8 #() 1154 193 193 nil 27 1186 1232 121 1248 423 13056 1 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 12640 34 2 8 1140924451 1 17008 3666 nil nil 3712 false nil nil 5 nil nil nil 17008 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[30 0 0 0 220 0 0 0 250 0 0 0 244 0 0 0] 193 17040 8 'Remove redundant &methods' 17008 3 8 #() 1154 193 193 nil 27 1186 2000 61 1248 441 13376 7 1280 49 170 192 34 14 13072 8 'stripDeprecatedMethods' 14912 8 'stripRedundantClasses' 14288 8 'stripSubclassResponsibility' 12752 8 'stripShouldNotImplement' 17008 8 'stripRedundantMethods' 16704 8 'stripRedundantResources' 13712 8 'preserveAspectSetters' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 12672 8 'Step 4' 12640 1 34 12 15536 15216 14912 16704 14592 17008 13712 13392 13072 12752 14288 14016 1154 193 193 nil 27 3458 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 17648 nil nil nil 5 nil nil nil 17648 674 170 176 34 12 410 ##(Smalltalk.StatusBar) 34 21 nil 17648 34 2 8 1140850700 1 17760 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 17760 nil 8 1795505344 170 192 34 2 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 17760 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'preStripScriptErrors' nil nil nil 138 144 34 1 17936 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 17760 nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 193 17792 8 '' 17760 3 8 #() 1154 193 193 nil 29 1186 2000 31 1648 -37 1264 571 1280 41 410 ##(Smalltalk.ContainerView) 34 15 nil 17648 34 2 8 1140850688 131073 18224 nil 816 nil 5 nil nil nil 18224 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 18224 34 2 8 1140850944 1 18304 3666 nil false 6418 6450 #= 8 #() 6450 #hash 6512 6530 nil true 6562 nil 8 'Resources\LagoonLogo.bmp' 6624 6640 nil 5 nil nil nil 18304 nil 8 4294902547 3746 nil nil nil 18448 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 18336 nil 18304 962 #text: 34 1 8 'Graphic' 18304 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 18224 34 2 8 1140855108 1 18736 nil 816 nil 5 nil nil nil 18736 nil 8 1503347568 3746 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 18768 nil 18736 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 7:\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\par
}
' 18736 962 #textLimit: 8 #(1073741823) 18736 962 #resetCharFormat 5328 18736 3 8 #() 1154 193 193 nil 27 170 192 5328 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 18256 8 'Heading' 18224 3 34 2 18736 18304 1154 193 193 nil 27 1186 2000 1 1648 1 1264 1 1280 121 410 ##(Smalltalk.PushButton) 34 20 nil 17648 34 2 8 1140924416 1 19392 nil 816 nil 5 nil nil nil 19392 nil 8 1795707744 850 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[184 1 0 0 69 1 0 0 33 2 0 0 94 1 0 0] 193 19424 8 'Custom &Options' 19392 962 #isEnabled: 8 #(false) 19392 3 8 #() 1154 193 193 nil 29 1186 2000 881 1248 211 1264 651 1280 51 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 19728 nil nil nil 5 nil nil nil 19728 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 66 0 0 0 24 2 0 0 156 0 0 0] 193 19760 nil 19728 962 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 19728 3 8 #() 1154 193 193 nil 27 1186 2000 33 1648 -41 1264 133 1280 181 410 ##(Smalltalk.ReferenceView) 34 14 nil 17648 34 2 8 1140850688 131073 20048 nil nil nil 5 nil nil nil 20048 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[16 0 0 0 163 0 0 0 24 2 0 0 27 1 0 0] 193 20080 8 '' 20048 3 5328 1154 193 193 nil 27 1186 2000 33 1648 -41 1264 327 1280 241 410 ##(Smalltalk.StaticText) 34 16 nil 17648 34 2 8 1140850944 1 20320 nil nil nil 5 nil nil nil 20320 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 65 1 0 0 154 1 0 0 100 1 0 0] 193 20352 nil 20320 962 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 20320 3 8 #() 1154 193 193 nil 27 1186 2000 31 1248 791 1264 643 1280 71 170 192 34 2 20048 8 'preStripScript' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 17680 8 'Step 7' 17648 1 34 6 18224 19728 20048 17760 20320 19392 1154 193 193 nil 27 3458 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 20880 nil nil nil 5 nil nil nil 20880 674 170 176 34 18 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 20992 nil nil nil 5 nil nil nil 20992 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 193 21024 nil 20992 962 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 20992 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -107 1264 549 1280 89 410 ##(Smalltalk.ContainerView) 34 15 nil 20880 34 2 8 1140850688 131073 21312 nil 816 nil 5 nil nil nil 21312 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 21312 34 2 8 1140850944 1 21392 3666 nil false 6418 6450 #= 8 #() 6450 #hash 6512 6530 nil true 6562 nil 8 'Resources\LagoonLogo.bmp' 6624 6640 nil 5 nil nil nil 21392 nil 8 4294902547 3746 nil nil nil 21536 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 21424 nil 21392 962 #text: 34 1 8 'Graphic' 21392 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 21312 34 2 8 1140855108 1 21824 nil 816 nil 5 nil nil nil 21824 nil 8 1503347568 3746 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 21856 nil 21824 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 5:\par
\par
Decide what meta-level information is required at runtime\par
\par
\par
\par
}
' 21824 962 #textLimit: 8 #(1073741823) 21824 962 #resetCharFormat 5328 21824 3 8 #() 1154 193 193 nil 27 170 192 5328 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 21344 8 'Heading' 21312 3 34 2 21824 21392 1154 193 193 nil 27 1186 2000 1 1648 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 22480 3666 nil nil 3712 false nil nil 5 nil nil nil 22480 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 193 22512 8 'Retain instance &variable names' 22480 3 8 #() 1154 193 193 nil 27 1186 2000 81 1248 369 1264 389 1280 69 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 22784 3666 nil nil 3712 false nil nil 5 nil nil nil 22784 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 62 1 0 0 224 0 0 0 86 1 0 0] 193 22816 8 'Compile E&xternal Structures' 22784 3 8 #() 1154 193 193 nil 27 1186 2000 81 1248 369 1264 637 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 23088 3666 nil nil 3712 true nil nil 5 nil nil nil 23088 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 193 23120 8 'Remove class meta-&information' 23088 3 8 #() 1154 193 193 nil 27 1186 2000 81 1248 369 1264 249 1280 59 410 ##(Smalltalk.CheckBox) 34 16 nil 20880 34 2 8 1140924451 1 23392 3666 nil nil 3712 false nil nil 5 nil nil nil 23392 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 193 23424 8 'Remove class &GUIDs' 23392 3 8 #() 1154 193 193 nil 27 1186 2000 81 1248 369 1264 459 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 23696 nil nil nil 5 nil nil nil 23696 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 193 23728 nil 23696 962 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 23696 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -107 1264 149 1280 99 410 ##(Smalltalk.GroupBox) 34 14 nil 20880 34 2 8 1140850695 65 24016 nil 816 nil 5 nil nil nil 24016 nil 8 1795707744 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 193 24048 8 '' 24016 3 8 #() 1154 193 193 nil 27 1186 2000 -17 1648 19 1264 521 1280 229 410 ##(Smalltalk.StaticText) 34 16 nil 20880 34 2 8 1140850944 1 24288 nil nil nil 5 nil nil nil 24288 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 193 24320 nil 24288 962 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 24288 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -107 1264 321 1280 69 170 192 34 8 23088 8 'stripClassInfo' 23392 8 'stripClassGuids' 22480 8 'retainInstVarNames' 22784 8 'compileExternalStructures' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 20912 8 'Step 5' 20880 1 34 9 21312 23696 23088 24288 22480 23392 20992 22784 24016 1154 193 193 nil 27 3458 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 24896 nil nil nil 5 nil nil nil 24896 674 170 176 34 14 410 ##(Smalltalk.ContainerView) 34 15 nil 24896 34 2 8 1140850688 131073 25008 nil 816 nil 5 nil nil nil 25008 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 25008 34 2 8 1140850944 1 25088 3666 nil false 6418 6450 #= 8 #() 6450 #hash 6512 6530 nil true 6562 nil 8 'Resources\LagoonLogo.bmp' 6624 6640 nil 5 nil nil nil 25088 nil 8 4294902547 3746 nil nil nil 25232 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 25120 nil 25088 962 #text: 34 1 8 'Graphic' 25088 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 25008 34 2 8 1140855108 1 25520 nil 816 nil 5 nil nil nil 25520 nil 8 1503347568 3746 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 25552 nil 25520 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Final Step:\par
\par
Deployment\par
\par
\par
\par
}
' 25520 962 #textLimit: 8 #(1073741823) 25520 962 #resetCharFormat 5328 25520 3 8 #() 1154 193 193 nil 27 170 192 5328 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 25040 8 'Heading' 25008 3 34 2 25520 25088 1154 193 193 nil 27 1186 2000 1 1648 1 1264 1 1280 121 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850955 262145 26176 nil nil nil 5 nil nil nil 26176 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 193 26208 nil 26176 962 #text: 34 1 8 '' 26176 3 8 #() 1154 193 193 nil 27 1186 2000 281 1648 -97 1264 269 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 26496 nil nil nil 5 nil nil nil 26496 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 193 26528 nil 26496 962 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 26496 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -107 1264 641 1280 59 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 26816 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 26816 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 193 26848 nil 26816 962 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 26816 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -137 1264 529 1280 81 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 27184 nil nil nil 5 nil nil nil 27184 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 193 27216 nil 27184 962 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 27184 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -97 1264 161 1280 81 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 27504 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 0 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 27504 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 193 27536 nil 27504 962 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 27504 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -97 1264 349 1280 139 410 ##(Smalltalk.StaticText) 34 16 nil 24896 34 2 8 1140850944 1 27872 nil nil nil 5 nil nil nil 27872 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 193 27904 nil 27872 962 #text: 34 1 8 'E&xecutable name:' 27872 3 8 #() 1154 193 193 nil 27 1186 2000 81 1248 189 1264 269 1280 49 170 192 34 2 26176 8 'executablePath2' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 24928 8 'Final step' 24896 1 34 7 25008 27184 27872 26176 26816 27504 26496 1154 193 193 nil 27 3458 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 28432 nil 816 nil 7 nil nil nil 28432 674 170 176 34 8 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28432 34 2 8 1140855110 1 28544 nil 816 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 28658 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 28658 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 28658 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28658 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28722 4097 28610 nil true 34 3 28658 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28658 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28658 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28722 4097 28658 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28544 nil 8 1503347568 3746 nil nil 43 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 193 28576 nil 28544 962 #contextMenu: 34 1 28624 28544 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
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
' 28544 962 #textLimit: 8 #(1073741823) 28544 962 #resetCharFormat 5328 28544 3 8 #() 1154 193 193 nil 27 1186 2000 419 1648 -47 1264 1 1280 489 410 ##(Smalltalk.TextEdit) 34 16 nil 28432 34 2 8 1140850816 262145 29616 nil 802 #whiteSmoke nil 7 nil nil nil 29616 nil 8 1795700448 3746 nil nil 35 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 193 29648 nil 29616 962 #setMarginWidths: 34 1 8 #(3 3) 29616 3 8 #() 1154 193 193 nil 27 1186 2000 421 1648 -49 13376 3 1280 41 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28432 34 2 8 1140855110 1 29952 nil 816 nil 7 28610 nil true 34 10 28658 1 850 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 28722 4097 28658 1 850 #bePlain 8 '&Plain' 1 1 nil nil nil 28658 1 850 #toggleBold 8 '&Bold' 1 1 nil nil nil 28658 1 850 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28658 1 850 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28722 4097 28610 nil true 34 3 28658 1 850 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28658 1 850 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28658 1 850 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28722 4097 28658 1 850 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29952 nil 8 1503347568 3746 nil nil 43 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 5 962 #createWindow: 34 1 1010 1042 8 #[209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 193 29984 nil 29952 962 #contextMenu: 34 1 30016 29952 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click Next to continue.\par
\par
\par
\pard\qc\par
}
' 29952 962 #textLimit: 8 #(1073741823) 29952 962 #resetCharFormat 5328 29952 3 8 #() 1154 193 193 nil 27 1186 2000 419 1248 549 1264 681 1280 49 410 ##(Smalltalk.ImageView) 34 21 nil 28432 34 2 8 1140850944 1 30976 3666 nil false 6418 6450 #= 8 #() 6450 #hash 6512 6530 nil true 6562 nil 8 'Resources\LagoonSideBar.jpg' 6624 816 nil 7 nil nil nil 30976 nil 8 4294902547 3746 nil nil nil 31120 #scaleToFit 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 193 31008 nil 30976 962 #text: 34 1 8 'Lagoon Graphic' 30976 3 8 #() 1154 193 193 nil 27 1186 2000 1 1248 379 1264 1 1280 741 170 192 34 2 29616 8 'executablePath1' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 28464 8 'Intro' 28432 3 34 4 30976 28544 29616 29952 1154 193 193 nil 27 3458 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 31664 nil nil nil 5 nil nil nil 31664 674 170 176 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 31664 34 2 8 1140850944 1 31776 nil nil nil 5 nil nil nil 31776 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 193 31808 nil 31776 962 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 31776 3 8 #() 1154 193 193 nil 27 1186 2000 81 1248 249 1264 401 1280 121 410 ##(Smalltalk.ContainerView) 34 15 nil 31664 34 2 8 1140850688 131073 32096 nil 816 nil 5 nil nil nil 32096 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 32096 34 2 8 1140850944 1 32176 3666 nil false 6418 6450 #= 8 #() 6450 #hash 6512 6530 nil true 6562 nil 8 'Resources\LagoonLogo.bmp' 6624 6640 nil 5 nil nil nil 32176 nil 8 4294902547 3746 nil nil nil 32320 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 32208 nil 32176 962 #text: 34 1 8 'Graphic' 32176 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 32096 34 2 8 1140855108 1 32608 nil 816 nil 5 nil nil nil 32608 nil 8 1503347568 3746 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 32640 nil 32608 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 1:\par
\par
Choose an ImageStripper to perform the deployment process\par
\par
\par
\par
}
' 32608 962 #textLimit: 8 #(1073741823) 32608 962 #resetCharFormat 5328 32608 3 8 #() 1154 193 193 nil 27 170 192 5328 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 32128 8 'Heading' 32096 3 34 2 32608 32176 1154 193 193 nil 27 1186 2000 1 1648 1 1264 1 1280 121 410 ##(Smalltalk.ComboBox) 34 17 nil 31664 34 2 8 1144063491 1025 33264 5282 138 144 5328 nil 5360 816 nil 5 nil nil nil 33264 nil 8 1795317024 ##(Smalltalk.BasicListAbstract) 5392 401 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[174 0 0 0 204 0 0 0 241 1 0 0 169 1 0 0] 193 33296 8 '' 33264 3 8 #() 1154 193 193 nil 27 1186 2000 349 1648 -119 1264 409 1280 41 410 ##(Smalltalk.StaticText) 34 16 nil 31664 34 2 8 1140850944 1 33568 nil nil nil 5 nil nil nil 33568 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 193 33600 nil 33568 962 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33568 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -107 1264 229 1280 149 170 192 34 2 33264 8 'imageStripperClass' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 31696 8 'Step 1' 31664 1 34 4 32096 33568 31776 33264 1154 193 193 nil 27 3458 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3328 34 2 8 1140850688 131073 34128 nil nil nil 5 nil nil nil 34128 674 170 176 34 14 410 ##(Smalltalk.GroupBox) 34 14 nil 34128 34 2 8 1140850695 65 34240 nil 816 nil 5 nil nil nil 34240 nil 8 1795707744 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 193 34272 8 '' 34240 3 8 #() 1154 193 193 nil 27 1186 2000 1 1648 1 1264 327 1280 393 410 ##(Smalltalk.CheckBox) 34 16 nil 34128 34 2 8 1140924451 1 34512 3666 nil nil 3712 true nil nil 5 nil nil nil 34512 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 193 34544 8 'Fold duplicate b&ytecode arrays' 34512 3 8 #() 1154 193 193 nil 27 1186 2000 71 1248 379 1264 511 1280 41 410 ##(Smalltalk.ContainerView) 34 15 nil 34128 34 2 8 1140850688 131073 34816 nil 816 nil 5 nil nil nil 34816 578 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 34816 34 2 8 1140850944 1 34896 3666 nil false 6418 6450 #= 8 #() 6450 #hash 6512 6530 nil true 6562 nil 8 'Resources\LagoonLogo.bmp' 6624 6640 nil 5 nil nil nil 34896 nil 8 4294902547 3746 nil nil nil 35040 #scale 1 nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 34928 nil 34896 962 #text: 34 1 8 'Graphic' 34896 3 8 #() 1154 193 193 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 34816 34 2 8 1140855108 1 35328 nil 816 nil 5 nil nil nil 35328 nil 8 1503347568 3746 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 160 0 210 4] 898 138 144 34 4 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 35360 nil 35328 962 #text: 34 1 7202 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 6:\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 35328 962 #textLimit: 8 #(1073741823) 35328 962 #resetCharFormat 5328 35328 3 8 #() 1154 193 193 nil 27 170 192 5328 3090 1154 31 11 1154 11 11 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 34848 8 'Heading' 34816 3 34 2 35328 34896 1154 193 193 nil 27 1186 2000 1 1648 1 1264 1 1280 121 410 ##(Smalltalk.CheckBox) 34 16 nil 34128 34 2 8 1140924451 1 35984 3666 nil nil 3712 true nil nil 5 nil nil nil 35984 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 193 36016 8 'Fold duplicate s&trings' 35984 3 8 #() 1154 193 193 nil 27 1186 2000 71 1248 379 1264 451 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 34128 34 2 8 1140850944 1 36288 nil nil nil 5 nil nil nil 36288 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 193 36320 nil 36288 962 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 36288 3 8 #() 1154 193 193 nil 27 1186 2000 31 1648 -117 1264 391 1280 49 410 ##(Smalltalk.StaticText) 34 16 nil 34128 34 2 8 1140850944 1 36608 nil nil nil 5 nil nil nil 36608 nil 8 1795912768 3746 nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 1010 1042 8 #[14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 193 36640 nil 36608 962 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 36608 3 8 #() 1154 193 193 nil 27 1186 2000 29 1648 -97 1264 161 1280 49 410 ##(Smalltalk.CheckBox) 34 16 nil 34128 34 2 8 1140924451 1 36928 3666 nil nil 3712 false nil nil 5 nil nil nil 36928 nil 8 1795707744 3746 nil nil nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 193 36960 8 'Remove &Class Builder' 36928 3 8 #() 1154 193 193 nil 27 1186 2000 81 1248 369 1264 209 1280 41 170 192 34 6 36928 8 'stripClassBuilder' 35984 8 'stripDuplicateStrings' 34512 8 'stripDuplicateBytecodes' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 34160 8 'Step 6' 34128 1 34 7 34816 36608 36928 36288 35984 34512 34240 1154 193 193 nil 27 28432 nil nil nil 170 192 34 2 28432 8 'Intro' nil 898 138 144 34 1 962 #createWindow: 34 1 1010 1042 8 #[0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 193 3360 8 '' 3328 3 34 9 28432 31664 3488 9520 12640 20880 34128 17648 24896 1154 193 193 nil 27 170 192 34 2 3328 8 'Steps' nil nil nil nil nil 3 nil nil 1154 2049 881 1154 1151 881 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2001703808 nil nil nil nil 898 138 144 34 2 962 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 3090 1154 7679 21 1154 8829 901 193 416 962 #setWindowText: 34 1 8 'Lagoon Deployment Wizard' 416 1 34 2 3328 608 1154 193 193 nil 29 )!

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

