"Filed out from Dolphin Smalltalk"!

UI.ValueDialog subclass: #'Tools.ApplicationDeploymentWizard'
	instanceVariableNames: 'imageStripperClass executableName executablePath1 executablePath2 rootPackage runtimeSessionManagerClass stripRedundantMethods stripDeprecatedMethods stripShouldNotImplement stripRedundantPackages stripRedundantClasses preserveAspectSetters stripDuplicateStrings stripDuplicateBytecodes stripClassInfo retainInstVarNames stripClassGuids stripClassBuilder unused stripRedundantResources compileExternalStructures writeLogFile preStripScriptWorkspace preStripScriptErrors logFileName logReferencesToClasses stepsView isToGo stripSubclassResponsibility'
	classVariableNames: 'SaveImageOnDeploy'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ApplicationDeploymentWizard guid: (Core.GUID fromString: '{87b4c6a1-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.ApplicationDeploymentWizard comment: 'ApplicationDeploymentWizard is a <dialogPresenter> used to edit the contents of an <ImageStripper> model.

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
!Tools.ApplicationDeploymentWizard categoriesForClass!MVP-Presenters! !
!Tools.ApplicationDeploymentWizard methodsFor!

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
	imageStripperClass choices: Smalltalk.ImageStripper withAllSubclasses.
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
	self value: (Smalltalk.ImageStripper new
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
!Tools.ApplicationDeploymentWizard categoriesForMethods!
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

!Tools.ApplicationDeploymentWizard class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators , #(#(#help 'F1'))!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^Smalltalk.ImageStripper new asValue!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Lagoon Deployment Wizard'!

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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 39 nil 852998 ##(Graphics.Font) nil true 721158 ##(OS.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 1048838 ##(UI.FramingLayout) 170 176 34 12 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 768 nil 8 1793798272 1377606 4 ##(UI.CommandDescription) #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 19 13 578 139 49 768 978 #isEnabled: 8 #(false) 768 978 #text: 34 1 8 '&Deploy' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 9 1250 #fixedViewLeft 139 1250 #fixedParentTop 1 1250 #fixedViewTop 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1328 nil 848 nil 7 nil nil nil 1328 nil 8 1793798272 882 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 217 13 578 131 49 1328 978 #isEnabled: 8 #(false) 1328 978 #text: 34 1 8 '< &Back' 1328 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #relativeParentWidth 852486 ##(Core.Fraction) 15 75 1280 131 1296 1 1312 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1728 nil 848 nil 7 nil nil nil 1728 nil 8 1793798272 882 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 685 13 578 241 49 1728 978 #isEnabled: 8 #(false) 1728 978 #text: 34 1 8 '&Save Configuration' 1728 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #fixedPreviousRight 11 1280 241 1296 1 1312 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2096 nil 848 nil 7 nil nil nil 2096 nil 8 1793798272 882 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 545 13 578 131 49 2096 978 #isEnabled: 8 #(false) 2096 978 #text: 34 1 8 '&Reset' 2096 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #fixedViewRight -129 1250 #fixedParentRight -429 1296 1 1312 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2480 nil 848 nil 7 nil nil nil 2480 nil 8 1793798272 882 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 955 13 578 139 49 2480 978 #text: 34 1 8 'Cancel' 2480 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 2448 -137 2464 -11 1296 1 1312 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2800 nil 848 nil 7 nil nil nil 2800 nil 8 1793798272 882 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 357 13 578 131 49 2800 978 #isEnabled: 8 #(false) 2800 978 #text: 34 1 8 '&Next >' 2800 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 2080 11 1280 131 1296 1 1312 49 170 192 34 2 768 8 'deploy' 1180166 ##(Graphics.Rectangle) 578 11 13 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 723 578 1119 81 640 978 #text: 34 1 8 'Buttons' 640 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 768 1328 2800 2096 1728 2480 1200 nil 27 nil nil 410 ##(UI.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3456 nil nil nil 7 nil nil nil 3456 853318 1 ##(UI.CardLayout) 138 144 34 9 1049094 ##(Core.Association) 3 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 3616 nil nil nil 5 nil nil nil 3616 706 170 176 34 28 410 ##(UI.StaticText) 34 16 nil 3616 34 2 8 1140850944 1 3728 nil nil nil 5 nil nil nil 3728 nil 8 1793837984 1049094 ##(UI.NullConverter) nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 37 379 578 389 81 3728 978 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 3728 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 0 0 0 189 0 0 0 212 0 0 0 229 0 0 0] 8 #() 1200 nil 27 1218 1264 37 1280 389 1296 379 1312 81 410 ##(UI.TextEdit) 34 16 nil 3616 34 2 8 1140850688 262145 4048 nil nil nil 5 nil nil nil 4048 nil 8 1793793792 3810 nil nil 1 930 34 2 978 #createAt:extent: 34 2 578 441 597 578 565 41 4048 978 #isEnabled: 8 #(false) 4048 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 1264 441 2464 -109 1296 597 1312 41 410 ##(UI.StaticText) 34 16 nil 3616 34 2 8 1140850944 1 4336 nil nil nil 5 nil nil nil 4336 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 491 578 1057 81 4336 978 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 4336 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 245 0 0 0 31 2 0 0 29 1 0 0] 8 #() 1200 nil 27 1218 1264 31 2464 -27 1296 491 1312 81 410 ##(UI.CheckBox) 34 16 nil 3616 34 2 8 1140924451 1 4640 918598 2 ##(UI.ValueHolder) nil nil 1572870 ##(Kernel.NeverSearchPolicy) true nil nil 5 nil nil nil 4640 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 597 578 251 41 4640 978 #text: 34 1 8 'Write &log file' 4640 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 1264 61 1280 251 1296 597 1312 41 410 ##(UI.GroupBox) 34 14 nil 3616 34 2 8 1140850695 65 5008 nil 848 nil 5 nil nil nil 5008 nil 8 1793798272 930 34 1 978 #createAt:extent: 34 2 578 1 279 578 1155 201 5008 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 239 0 0 0] 8 #() 1200 nil 27 1218 1264 1 2464 41 1296 279 1312 201 410 ##(UI.CheckBox) 34 16 nil 3616 34 2 8 1140924451 1 5248 4706 nil nil 4752 true nil nil 5 nil nil nil 5248 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 661 578 251 41 5248 978 #text: 34 1 8 'Log &class references' 5248 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1200 nil 27 1218 1264 61 1280 251 1296 661 1312 41 410 ##(UI.StaticText) 34 16 nil 3616 34 2 8 1140850944 1 5568 nil nil nil 5 nil nil nil 5568 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 141 578 405 81 5568 978 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 5568 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 217 0 0 0 110 0 0 0] 8 #() 1200 nil 27 1218 1264 31 1280 405 1296 141 1312 81 410 ##(UI.CheckBox) 34 16 nil 3616 34 2 8 1140924451 1 5872 4706 nil nil 4752 false nil nil 5 nil nil nil 5872 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 211 578 431 81 5872 978 #text: 34 1 8 'Create single file, "To Go" distributable.' 5872 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1200 nil 27 1218 1264 31 1280 431 1296 211 1312 81 410 ##(UI.ContainerView) 34 15 nil 3616 34 2 8 1140850688 131073 6192 nil 848 nil 5 nil nil nil 6192 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 6192 34 2 8 1140850944 1 6272 4706 nil false 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 6386 #hash 8 #() 919622 3 ##(OS.COM.Picture) nil true 2162694 ##(Kernel.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 983558 ##(OS.COM.IPicture) nil nil 578 321 327 578 8467 8627 834 #face3d nil 5 nil nil nil 6272 nil 8 4294902547 3810 nil nil nil 6480 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 6272 978 #text: 34 1 8 'Graphic' 6272 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 6192 34 2 8 1140855108 1 6896 nil 848 nil 5 nil nil nil 6896 nil 8 1687389664 3810 nil nil 41 nil 852230 ##(OS.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 6896 978 #text: 34 1 721158 ##(UI.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 2: \par
\fs16\par
Choose an Executable File and RuntimeSessionManager\cf0\b0\f1\par
\par
\par
\par
}
' 6896 978 #textLimit: 8 #(1073741823) 6896 978 #resetCharFormat 8 #() 6896 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 7264 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 6192 978 #text: 34 1 8 'Heading' 6192 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 6896 6272 1200 nil 27 1218 1264 1 2464 1 1296 1 1312 121 410 ##(UI.ComboBox) 34 17 nil 3616 34 2 8 1144063491 1025 7600 787270 2 ##(UI.ListModel) 138 144 7264 nil 1769478 ##(Kernel.IdentitySearchPolicy) 848 nil 5 nil nil nil 7600 nil 8 1793347792 ##(UI.BasicListAbstract) 8 #() 401 930 34 1 978 #createAt:extent: 34 2 578 441 393 578 565 43 7600 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 196 0 0 0 246 1 0 0 217 0 0 0] 8 #() 1200 nil 27 1218 1264 441 2464 -109 1296 393 1312 43 410 ##(UI.PushButton) 34 20 nil 3616 34 2 8 1140924416 1 7936 nil 848 nil 5 nil nil nil 7936 nil 8 1793798272 882 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 441 661 578 139 45 7936 978 #isEnabled: 8 #(false) 7936 978 #text: 34 1 8 'S&how it' 7936 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1200 nil 29 1218 1264 441 1280 139 1296 661 1312 45 410 ##(UI.StaticText) 34 16 nil 3616 34 2 8 1140850944 1 8288 nil nil nil 5 nil nil nil 8288 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 309 578 975 71 8288 978 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 8288 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 1200 nil 27 1218 1264 31 2464 -109 1296 309 1312 71 410 ##(UI.PushButton) 34 20 nil 3616 34 2 8 1140924416 1 8592 nil 848 nil 5 nil nil nil 8592 nil 8 1793798272 882 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 1025 151 578 49 41 8592 978 #isEnabled: 8 #(false) 8592 978 #text: 34 1 8 '...' 8592 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1200 nil 29 1218 2448 -47 2464 -41 1296 151 1312 41 410 ##(UI.TextEdit) 34 16 nil 3616 34 2 8 1140916352 1025 8944 nil 848 nil 5 nil nil nil 8944 nil 8 1793793792 3810 nil nil 1 930 34 1 978 #createAt:extent: 34 2 578 447 151 578 559 41 8944 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1200 nil 27 1218 1264 447 2464 -109 1296 151 1312 41 170 192 34 14 4640 8 'writeLogFile' 8944 8 'executableName' 5248 8 'logReferencesToClasses' 4048 8 'logFileName' 7600 8 'runtimeSessionManagerClass' 7936 8 'showLog' 5872 8 'isToGo' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 3616 978 #text: 34 1 8 'Step 2' 3616 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 6192 5568 8944 8592 5872 8288 3728 7600 4336 4640 5248 4048 7936 5008 1200 nil 27 3586 5 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 9552 nil nil nil 5 nil nil nil 9552 706 170 176 34 12 410 ##(UI.StaticText) 34 16 nil 9552 34 2 8 1140850944 1 9664 nil nil nil 5 nil nil nil 9664 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 499 578 979 109 9664 978 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 9664 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -107 1296 499 1312 109 410 ##(UI.CheckBox) 34 16 nil 9552 34 2 8 1140924451 1 9968 4706 nil nil 4752 true nil nil 5 nil nil nil 9968 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 59 599 578 329 49 9968 978 #text: 34 1 8 'Remove redundant &packages' 9968 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 8 #() 1200 nil 27 1218 1264 59 1280 329 1296 599 1312 49 410 ##(UI.StaticText) 34 16 nil 9552 34 2 8 1140850944 1 10288 nil nil nil 5 nil nil nil 10288 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 171 578 975 191 10288 978 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 10288 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1200 nil 27 1218 1264 31 2464 -109 1296 171 1312 191 410 ##(UI.ContainerView) 34 15 nil 9552 34 2 8 1140850688 131073 10592 nil 848 nil 5 nil nil nil 10592 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 10592 34 2 8 1140850944 1 10672 4706 nil false 6354 6386 #= 8 #() 6386 #hash 6448 6466 nil true 6512 8 'Resources\LagoonLogo.bmp' 6560 6594 nil nil 578 321 327 578 8467 8627 6656 nil 5 nil nil nil 10672 nil 8 4294902547 3810 nil nil nil 10816 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 10672 978 #text: 34 1 8 'Graphic' 10672 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 10592 34 2 8 1140855108 1 11120 nil 848 nil 5 nil nil nil 11120 nil 8 1687389664 3810 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 11120 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 3:\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\cf0\f1\par
\b0\par
\par
\par
}
' 11120 978 #textLimit: 8 #(1073741823) 11120 978 #resetCharFormat 7264 11120 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 7264 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 10592 978 #text: 34 1 8 'Heading' 10592 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 11120 10672 1200 nil 27 1218 1264 1 2464 1 1296 1 1312 121 410 ##(UI.StaticText) 34 16 nil 9552 34 2 8 1140850944 262145 11776 nil nil nil 5 nil nil nil 11776 nil 8 1793837984 3810 nil nil nil 930 34 1 978 #createAt:extent: 34 2 578 361 389 578 647 41 11776 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1200 nil 27 1218 1264 361 2464 -107 1296 389 1312 41 410 ##(UI.StaticText) 34 16 nil 9552 34 2 8 1140850944 1 12032 nil nil nil 5 nil nil nil 12032 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 389 578 201 41 12032 978 #text: 34 1 8 'Root package:' 12032 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1200 nil 27 1218 1264 81 1280 201 1296 389 1312 41 170 192 34 4 11776 8 'rootPackage' 9968 8 'stripRedundantPackages' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 9552 978 #text: 34 1 8 'Step 3' 9552 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 10592 10288 12032 11776 9664 9968 1200 nil 27 3586 7 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 12608 nil nil nil 5 nil nil nil 12608 706 170 176 34 24 410 ##(UI.StaticText) 34 16 nil 12608 34 2 8 1140850944 1 12720 nil nil nil 5 nil nil nil 12720 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 1061 69 12720 978 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 12720 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 32 2 0 0 108 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -25 1296 149 1312 69 410 ##(UI.StaticText) 34 16 nil 12608 34 2 8 1140850944 1 13024 nil nil nil 5 nil nil nil 13024 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 533 578 1079 49 13024 978 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 13024 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -7 1250 #fixedPreviousBottom 51 1312 49 410 ##(UI.CheckBox) 34 16 nil 12608 34 2 8 1140924451 1 13344 4706 nil nil 4752 true nil nil 5 nil nil nil 13344 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 217 578 441 49 13344 978 #text: 34 1 8 'Remove redundant &classes' 13344 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 1200 nil 27 1218 1264 61 1280 441 13328 1 1312 49 410 ##(UI.CheckBox) 34 16 nil 12608 34 2 8 1140924451 1 13664 4706 nil nil 4752 false nil nil 5 nil nil nil 13664 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 645 578 441 49 13664 978 #text: 34 1 8 'Remove #&subclassResponsibility methods' 13664 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 1200 nil 27 1218 1264 61 1280 441 13328 17 1312 49 410 ##(UI.StaticText) 34 16 nil 12608 34 2 8 1140850944 1 13984 nil nil nil 5 nil nil nil 13984 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 315 578 1055 121 13984 978 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 13984 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 29 2 0 0 217 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -31 13328 51 1312 121 410 ##(UI.CheckBox) 34 16 nil 12608 34 2 8 1140924451 1 14288 4706 nil nil 4752 false nil nil 5 nil nil nil 14288 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 435 578 423 49 14288 978 #text: 34 1 8 'Preserve &aspect set methods' 14288 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1200 nil 27 1218 2080 121 1280 423 1250 #fixedPreviousTop 1 1312 49 410 ##(UI.ContainerView) 34 15 nil 12608 34 2 8 1140850688 131073 14624 nil 848 nil 5 nil nil nil 14624 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 14624 34 2 8 1140850944 1 14704 4706 nil false 6354 6386 #= 8 #() 6386 #hash 6448 6466 nil true 6512 8 'Resources\LagoonLogo.bmp' 6560 6594 nil nil 578 321 327 578 8467 8627 6656 nil 5 nil nil nil 14704 nil 8 4294902547 3810 nil nil nil 14848 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 14704 978 #text: 34 1 8 'Graphic' 14704 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 14624 34 2 8 1140855108 1 15152 nil 848 nil 5 nil nil nil 15152 nil 8 1687389664 3810 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 15152 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 4:\par
\fs16\par
Configure how the ImageStripper removes unwanted classes and methods\par
\cf0\b0\f1\par
\par
\par
}
' 15152 978 #textLimit: 8 #(1073741823) 15152 978 #resetCharFormat 7264 15152 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 7264 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 14624 978 #text: 34 1 8 'Heading' 14624 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 15152 14704 1200 nil 27 1218 1264 1 2464 1 1296 1 1312 121 410 ##(UI.CheckBox) 34 16 nil 12608 34 2 8 1140924451 1 15808 4706 nil nil 4752 true nil nil 5 nil nil nil 15808 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 217 578 423 49 15808 978 #text: 34 1 8 'Remove redundant &resources' 15808 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1200 nil 27 1218 2080 121 1280 423 14608 1 1312 49 410 ##(UI.GroupBox) 34 14 nil 12608 34 2 8 1140850695 65 16128 nil 848 nil 5 nil nil nil 16128 nil 8 1793798272 930 34 1 978 #createAt:extent: 34 2 578 -17 281 578 1151 229 16128 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1200 nil 27 1218 1264 -17 2464 19 1296 281 1312 229 410 ##(UI.CheckBox) 34 16 nil 12608 34 2 8 1140924451 1 16368 4706 nil nil 4752 false nil nil 5 nil nil nil 16368 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 581 578 441 49 16368 978 #text: 34 1 8 'Remove #&deprecated methods' 16368 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 1200 nil 27 1218 1264 61 1280 441 13328 1 1312 49 410 ##(UI.CheckBox) 34 16 nil 12608 34 2 8 1140924451 1 16688 4706 nil nil 4752 false nil nil 5 nil nil nil 16688 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 581 578 423 49 16688 978 #text: 34 1 8 'Remove #shouldNot&Implement methods' 16688 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1200 nil 27 1218 2080 121 1280 423 14608 1 1312 49 410 ##(UI.CheckBox) 34 16 nil 12608 34 2 8 1140924451 1 17008 4706 nil nil 4752 false nil nil 5 nil nil nil 17008 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 435 578 441 49 17008 978 #text: 34 1 8 'Remove redundant &methods' 17008 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 1200 nil 27 1218 1264 61 1280 441 13328 1 1312 49 170 192 34 14 14288 8 'preserveAspectSetters' 16688 8 'stripShouldNotImplement' 16368 8 'stripDeprecatedMethods' 13664 8 'stripSubclassResponsibility' 13344 8 'stripRedundantClasses' 15808 8 'stripRedundantResources' 17008 8 'stripRedundantMethods' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 12608 978 #text: 34 1 8 'Step 4' 12608 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 14624 12720 13344 15808 13984 17008 14288 13024 16368 16688 13664 16128 1200 nil 27 3586 9 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 17680 nil nil nil 5 nil nil nil 17680 706 170 176 34 12 410 ##(UI.StatusBar) 34 21 nil 17680 34 2 8 1140850700 1 17792 nil nil nil 5 nil 498 nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 17792 nil 8 1793329168 170 192 34 2 1050438 1 ##(UI.StatusBarItem) 8193 -1 17792 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'preStripScriptErrors' nil nil nil 138 144 34 1 18000 1311814 1 ##(UI.StatusBarNullItem) 8705 1 17792 nil nil 930 34 1 978 #createAt:extent: 34 2 578 31 595 578 1047 41 17792 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 41 1 0 0 26 2 0 0 61 1 0 0] 8 #() 1200 nil 29 1218 1264 31 2464 -37 13328 1 1312 41 410 ##(UI.ContainerView) 34 15 nil 17680 34 2 8 1140850688 131073 18256 nil 848 nil 5 nil nil nil 18256 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 18256 34 2 8 1140850944 1 18336 4706 nil false 6354 6386 #= 8 #() 6386 #hash 6448 6466 nil true 6512 8 'Resources\LagoonLogo.bmp' 6560 6594 nil nil 578 321 327 578 8467 8627 6656 nil 5 nil nil nil 18336 nil 8 4294902547 3810 nil nil nil 18480 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 18336 978 #text: 34 1 8 'Graphic' 18336 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 18256 34 2 8 1140855108 1 18784 nil 848 nil 5 nil nil nil 18784 nil 8 1687389664 3810 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 18784 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 7:\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\cf0\b0\f1\par
}
' 18784 978 #textLimit: 8 #(1073741823) 18784 978 #resetCharFormat 7264 18784 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 7264 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 18256 978 #text: 34 1 8 'Heading' 18256 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 18784 18336 1200 nil 27 1218 1264 1 2464 1 1296 1 1312 121 410 ##(UI.StaticText) 34 16 nil 17680 34 2 8 1140850944 1 19440 nil nil nil 5 nil nil nil 19440 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 651 578 791 71 19440 978 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 19440 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1200 nil 27 1218 1264 31 1280 791 1296 651 1312 71 410 ##(UI.ReferenceView) 34 14 nil 17680 34 2 8 1140850688 131073 19744 nil nil nil 5 nil nil nil 19744 1376838 1 ##(UI.ResourceIdentifier) ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 930 34 1 978 #createAt:extent: 34 2 578 31 345 578 1045 251 19744 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 172 0 0 0 25 2 0 0 41 1 0 0] 7264 1200 nil 27 1218 1264 31 2464 -39 1296 345 1312 251 410 ##(UI.StaticText) 34 16 nil 17680 34 2 8 1140850944 1 19984 nil nil nil 5 nil nil nil 19984 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 1059 189 19984 978 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 19984 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 31 2 0 0 168 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -27 1296 149 1312 189 410 ##(UI.PushButton) 34 20 nil 17680 34 2 8 1140924416 1 20288 nil 848 nil 5 nil nil nil 20288 nil 8 1793798272 882 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 881 661 578 211 51 20288 978 #isEnabled: 8 #(false) 20288 978 #text: 34 1 8 'Custom &Options' 20288 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1200 nil 29 1218 1264 881 1280 211 1296 661 1312 51 170 192 34 2 19744 8 'preStripScript' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 17680 978 #text: 34 1 8 'Step 7' 17680 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 18256 19984 19744 17792 19440 20288 1200 nil 27 3586 11 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 20896 nil nil nil 5 nil nil nil 20896 706 170 176 34 18 410 ##(UI.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 21008 4706 nil nil 4752 false nil nil 5 nil nil nil 21008 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 649 578 369 49 21008 978 #text: 34 1 8 'Compile E&xternal Structures' 21008 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1200 nil 27 1218 1264 81 1280 369 1296 649 1312 49 410 ##(UI.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 21328 nil nil nil 5 nil nil nil 21328 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 979 99 21328 978 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 21328 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -107 1296 149 1312 99 410 ##(UI.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 21632 4706 nil nil 4752 false nil nil 5 nil nil nil 21632 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 389 578 369 69 21632 978 #text: 34 1 8 'Retain instance &variable names' 21632 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1200 nil 27 1218 1264 81 1280 369 1296 389 1312 69 410 ##(UI.GroupBox) 34 14 nil 20896 34 2 8 1140850695 65 21952 nil 848 nil 5 nil nil nil 21952 nil 8 1793798272 930 34 1 978 #createAt:extent: 34 2 578 -17 521 578 1151 229 21952 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1200 nil 27 1218 1264 -17 2464 19 1296 521 1312 229 410 ##(UI.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 22192 nil nil nil 5 nil nil nil 22192 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 321 578 979 69 22192 978 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 22192 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -107 1296 321 1312 69 410 ##(UI.ContainerView) 34 15 nil 20896 34 2 8 1140850688 131073 22496 nil 848 nil 5 nil nil nil 22496 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 22496 34 2 8 1140850944 1 22576 4706 nil false 6354 6386 #= 8 #() 6386 #hash 6448 6466 nil true 6512 8 'Resources\LagoonLogo.bmp' 6560 6594 nil nil 578 321 327 578 8467 8627 6656 nil 5 nil nil nil 22576 nil 8 4294902547 3810 nil nil nil 22720 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 22576 978 #text: 34 1 8 'Graphic' 22576 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 22496 34 2 8 1140855108 1 23024 nil 848 nil 5 nil nil nil 23024 nil 8 1687389664 3810 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 23024 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 5:\fs16\par
\par
Decide what meta-level information is required at runtime\par
\cf0\b0\f1\par
\par
\par
}
' 23024 978 #textLimit: 8 #(1073741823) 23024 978 #resetCharFormat 7264 23024 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 7264 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 22496 978 #text: 34 1 8 'Heading' 22496 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 23024 22576 1200 nil 27 1218 1264 1 2464 1 1296 1 1312 121 410 ##(UI.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 23680 4706 nil nil 4752 true nil nil 5 nil nil nil 23680 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 249 578 369 59 23680 978 #text: 34 1 8 'Remove class meta-&information' 23680 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1200 nil 27 1218 1264 81 1280 369 1296 249 1312 59 410 ##(UI.CheckBox) 34 16 nil 20896 34 2 8 1140924451 1 24000 4706 nil nil 4752 false nil nil 5 nil nil nil 24000 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 459 578 369 41 24000 978 #text: 34 1 8 'Remove class &GUIDs' 24000 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1200 nil 27 1218 1264 81 1280 369 1296 459 1312 41 410 ##(UI.StaticText) 34 16 nil 20896 34 2 8 1140850944 1 24320 nil nil nil 5 nil nil nil 24320 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 549 578 979 89 24320 978 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 24320 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -107 1296 549 1312 89 170 192 34 8 23680 8 'stripClassInfo' 24000 8 'stripClassGuids' 21632 8 'retainInstVarNames' 21008 8 'compileExternalStructures' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 20896 978 #text: 34 1 8 'Step 5' 20896 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 22496 21328 23680 22192 21632 24000 24320 21008 21952 1200 nil 27 3586 13 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 24928 nil nil nil 5 nil nil nil 24928 706 170 176 34 14 410 ##(UI.StaticText) 34 16 nil 24928 34 2 8 1140850944 1 25040 nil nil nil 5 nil nil nil 25040 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 269 578 189 49 25040 978 #text: 34 1 8 'E&xecutable name:' 25040 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1200 nil 27 1218 1264 81 1280 189 1296 269 1312 49 410 ##(UI.StaticText) 34 16 nil 24928 34 2 8 1140850944 1 25344 nil nil nil 5 nil nil nil 25344 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 161 578 989 81 25344 978 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 25344 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -97 1296 161 1312 81 410 ##(UI.StaticText) 34 16 nil 24928 34 2 8 1140850944 1 25648 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 nil 25648 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 529 578 949 81 25648 978 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 25648 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -137 1296 529 1312 81 410 ##(UI.StaticText) 34 16 nil 24928 34 2 8 1140850944 1 26016 nil nil nil 5 nil nil nil 26016 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 641 578 979 59 26016 978 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 26016 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -107 1296 641 1312 59 410 ##(UI.ContainerView) 34 15 nil 24928 34 2 8 1140850688 131073 26320 nil 848 nil 5 nil nil nil 26320 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 26320 34 2 8 1140850944 1 26400 4706 nil false 6354 6386 #= 8 #() 6386 #hash 6448 6466 nil true 6512 8 'Resources\LagoonLogo.bmp' 6560 6594 nil nil 578 321 327 578 8467 8627 6656 nil 5 nil nil nil 26400 nil 8 4294902547 3810 nil nil nil 26544 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 26400 978 #text: 34 1 8 'Graphic' 26400 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 26320 34 2 8 1140855108 1 26848 nil 848 nil 5 nil nil nil 26848 nil 8 1687389664 3810 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 26848 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Final Step:\par
\fs16\par
Deployment\par
\par
\cf0\b0\f1\par
\par
}
' 26848 978 #textLimit: 8 #(1073741823) 26848 978 #resetCharFormat 7264 26848 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 7264 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 26320 978 #text: 34 1 8 'Heading' 26320 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 26848 26400 1200 nil 27 1218 1264 1 2464 1 1296 1 1312 121 410 ##(UI.StaticText) 34 16 nil 24928 34 2 8 1140850944 1 27504 nil nil nil 5 nil nil nil 27504 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 349 578 989 139 27504 978 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 27504 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -97 1296 349 1312 139 410 ##(UI.StaticText) 34 16 nil 24928 34 2 8 1140850955 262145 27808 nil nil nil 5 nil nil nil 27808 nil 8 1793837984 3810 nil nil nil 930 34 1 978 #createAt:extent: 34 2 578 281 269 578 737 41 27808 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1200 nil 27 1218 1264 281 2464 -97 1296 269 1312 41 170 192 34 2 27808 8 'executablePath2' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 24928 978 #text: 34 1 8 'Final step' 24928 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 26320 25344 25040 27808 25648 27504 26016 1200 nil 27 3586 15 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 28320 nil 848 nil 7 nil nil nil 28320 706 170 176 34 8 410 ##(UI.ImageView) 34 21 nil 28320 34 2 8 1140850944 1 28432 4706 nil false 6354 6386 #= 8 #() 6386 #hash 6448 6466 nil true 6512 8 'Resources\LagoonSideBar.jpg' 6560 6594 nil nil 578 381 761 578 10055 20109 848 nil 7 nil nil nil 28432 nil 8 4294902547 3810 nil nil nil 28576 #centered 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 379 741 28432 978 #text: 34 1 8 'Lagoon Graphic' 28432 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1200 nil 27 1218 1264 1 1280 379 1296 1 1312 741 410 ##(UI.RichTextEdit) 34 18 nil 28320 34 2 8 1140855110 1 28896 nil 848 nil 7 461638 4 ##(UI.Menu) nil true 34 10 1180742 2 ##(UI.CommandMenuItem) 1 882 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 29010 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29010 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29010 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29010 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29074 4097 28962 nil true 34 3 29010 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29010 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29010 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29074 4097 29010 1 882 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28896 nil 8 1687389664 3810 nil nil 43 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 5 978 #createAt:extent: 34 2 578 419 681 578 549 49 28896 978 #contextMenu: 34 1 28976 28896 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\f0\fs16 Otherwise click \b Next \b0 to continue\cf0\f1 .\par
\par
\par
\pard\qc\par
}
' 28896 978 #textLimit: 8 #(1073741823) 28896 978 #resetCharFormat 7264 28896 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1200 nil 27 1218 1264 419 1280 549 1296 681 1312 49 410 ##(UI.TextEdit) 34 16 nil 28320 34 2 8 1140850816 262145 29952 nil 834 #whiteSmoke nil 7 nil nil nil 29952 nil 8 1793793792 3810 nil nil 35 930 34 1 978 #createAt:extent: 34 2 578 421 491 578 645 41 29952 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1200 nil 27 1218 1264 421 2464 -49 13328 3 1312 41 410 ##(UI.RichTextEdit) 34 18 nil 28320 34 2 8 1140855110 1 30224 nil 848 nil 7 28962 nil true 34 10 29010 1 882 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 29074 4097 29010 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29010 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29010 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29010 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29074 4097 28962 nil true 34 3 29010 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29010 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29010 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29074 4097 29010 1 882 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 30224 nil 8 1687389664 3810 nil nil 43 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 5 978 #createAt:extent: 34 2 578 419 1 578 649 489 30224 978 #contextMenu: 34 1 30288 30224 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\f0\fs16\par
\cf1\f1\fs24 Welcome to the Dolphin Lagoon Application Deployment Wizard\cf0\f0\fs16\par
\par
\cf1\f1 This wizard helps you configure an ImageStripper that can be used to strip unnecessary objects from your Dolphin image and to deploy it to an executable (EXE) file. \par
\par
\par
\par
\par
If the ImageStripper attached to this wizard has already been configured then you may immediately deploy this image to the executable file below by clicking the \cf0\b Deploy \b0 button.\f0\par
\par
}
' 30224 978 #textLimit: 8 #(1073741823) 30224 978 #resetCharFormat 7264 30224 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1200 nil 27 1218 1264 419 2464 -47 1296 1 1312 489 170 192 34 2 29952 8 'executablePath1' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 28320 978 #text: 34 1 8 'Intro' 28320 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 28432 30224 29952 28896 1200 nil 27 3586 17 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 31488 nil nil nil 5 nil nil nil 31488 706 170 176 34 8 410 ##(UI.StaticText) 34 16 nil 31488 34 2 8 1140850944 1 31600 nil nil nil 5 nil nil nil 31600 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 401 578 249 121 31600 978 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 31600 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1200 nil 27 1218 1264 81 1280 249 1296 401 1312 121 410 ##(UI.ContainerView) 34 15 nil 31488 34 2 8 1140850688 131073 31904 nil 848 nil 5 nil nil nil 31904 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 31904 34 2 8 1140850944 1 31984 4706 nil false 6354 6386 #= 8 #() 6386 #hash 6448 6466 nil true 6512 8 'Resources\LagoonLogo.bmp' 6560 6594 nil nil 578 321 327 578 8467 8627 6656 nil 5 nil nil nil 31984 nil 8 4294902547 3810 nil nil nil 32128 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 31984 978 #text: 34 1 8 'Graphic' 31984 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 31904 34 2 8 1140855108 1 32432 nil 848 nil 5 nil nil nil 32432 nil 8 1687389664 3810 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 32432 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 1:\cf0\f1\fs16\par
\par
\cf1\f0 Choose an ImageStripper to perform the deployment process\cf0\b0\f1\par
\par
\par
\par
}
' 32432 978 #textLimit: 8 #(1073741823) 32432 978 #resetCharFormat 7264 32432 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 7264 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 31904 978 #text: 34 1 8 'Heading' 31904 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 32432 31984 1200 nil 27 1218 1264 1 2464 1 1296 1 1312 121 410 ##(UI.ComboBox) 34 17 nil 31488 34 2 8 1144063491 1025 33088 7666 138 144 7264 nil 7728 848 nil 5 nil nil nil 33088 nil 8 1793347792 ##(UI.BasicListAbstract) 7760 401 930 34 1 978 #createAt:extent: 34 2 578 349 409 578 647 43 33088 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1200 nil 27 1218 1264 349 2464 -119 1296 409 1312 41 410 ##(UI.StaticText) 34 16 nil 31488 34 2 8 1140850944 1 33360 nil nil nil 5 nil nil nil 33360 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 229 578 979 149 33360 978 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33360 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -107 1296 229 1312 149 170 192 34 2 33088 8 'imageStripperClass' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 31488 978 #text: 34 1 8 'Step 1' 31488 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 31904 33360 31600 33088 1200 nil 27 3586 19 410 ##(UI.ContainerView) 34 15 nil 3456 34 2 8 1140850688 131073 33920 nil nil nil 5 nil nil nil 33920 706 170 176 34 14 410 ##(UI.StaticText) 34 16 nil 33920 34 2 8 1140850944 1 34032 nil nil nil 5 nil nil nil 34032 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 161 578 989 49 34032 978 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 34032 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1200 nil 27 1218 1264 29 2464 -97 1296 161 1312 49 410 ##(UI.ContainerView) 34 15 nil 33920 34 2 8 1140850688 131073 34336 nil 848 nil 5 nil nil nil 34336 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 34336 34 2 8 1140850944 1 34416 4706 nil false 6354 6386 #= 8 #() 6386 #hash 6448 6466 nil true 6512 8 'Resources\LagoonLogo.bmp' 6560 6594 nil nil 578 321 327 578 8467 8627 6656 nil 5 nil nil nil 34416 nil 8 4294902547 3810 nil nil nil 34560 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 34416 978 #text: 34 1 8 'Graphic' 34416 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 34336 34 2 8 1140855108 1 34864 nil 848 nil 5 nil nil nil 34864 nil 8 1687389664 3810 nil nil 41 nil 6994 8 #[0 0 0 0 0 0 0 0 240 1 228 4] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 34864 978 #text: 34 1 7170 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 6:\fs16\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 34864 978 #textLimit: 8 #(1073741823) 34864 978 #resetCharFormat 7264 34864 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 7264 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 34336 978 #text: 34 1 8 'Heading' 34336 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 34864 34416 1200 nil 27 1218 1264 1 2464 1 1296 1 1312 121 410 ##(UI.GroupBox) 34 14 nil 33920 34 2 8 1140850695 65 35520 nil 848 nil 5 nil nil nil 35520 nil 8 1793798272 930 34 1 978 #createAt:extent: 34 2 578 1 327 578 1115 393 35520 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1200 nil 27 1218 1264 1 2464 1 1296 327 1312 393 410 ##(UI.CheckBox) 34 16 nil 33920 34 2 8 1140924451 1 35760 4706 nil nil 4752 true nil nil 5 nil nil nil 35760 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 71 511 578 379 41 35760 978 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 35760 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1200 nil 27 1218 1264 71 1280 379 1296 511 1312 41 410 ##(UI.CheckBox) 34 16 nil 33920 34 2 8 1140924451 1 36080 4706 nil nil 4752 true nil nil 5 nil nil nil 36080 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 71 451 578 379 49 36080 978 #text: 34 1 8 'Fold duplicate s&trings' 36080 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1200 nil 27 1218 1264 71 1280 379 1296 451 1312 49 410 ##(UI.StaticText) 34 16 nil 33920 34 2 8 1140850944 1 36400 nil nil nil 5 nil nil nil 36400 nil 8 1793837984 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 391 578 967 49 36400 978 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 36400 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1200 nil 27 1218 1264 31 2464 -117 1296 391 1312 49 410 ##(UI.CheckBox) 34 16 nil 33920 34 2 8 1140924451 1 36704 4706 nil nil 4752 false nil nil 5 nil nil nil 36704 nil 8 1793798272 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 209 578 369 41 36704 978 #text: 34 1 8 'Remove &Class Builder' 36704 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1200 nil 27 1218 1264 81 1280 369 1296 209 1312 41 170 192 34 6 35760 8 'stripDuplicateBytecodes' 36080 8 'stripDuplicateStrings' 36704 8 'stripClassBuilder' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 33920 978 #text: 34 1 8 'Step 6' 33920 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 34336 34032 36704 36400 36080 35760 35520 1200 nil 27 28320 nil nil nil 170 192 34 2 28320 8 'Intro' nil 930 34 1 978 #createAt:extent: 34 2 578 1 1 578 1119 723 3456 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 28320 31488 3616 9552 12608 20896 33920 17680 24928 1200 nil 27 170 192 34 2 3456 8 'Steps' 3202 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 false 8 2007594560 930 34 2 978 #createAt:extent: 34 2 578 12287 21 578 1151 881 416 978 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 62 26 0 0 194 1 0 0] 34 2 3456 640 1200 nil 27 )!

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
!Tools.ApplicationDeploymentWizard class categoriesForMethods!
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

