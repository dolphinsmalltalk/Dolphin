"Filed out from Dolphin Smalltalk 7"!

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
	self value: (ImageStripper new
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
!Tools.ApplicationDeploymentWizard categoriesFor: #accept!commands!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #addToCommandRoute:!commands!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #apply!commands!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #browseForExecutableName!commands!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #canDeploy!public!testing! !
!Tools.ApplicationDeploymentWizard categoriesFor: #createComponents!initializing!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #defaultExtension!constants!private! !
!Tools.ApplicationDeploymentWizard categoriesFor: #deployApplication!commands!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #exeFileTypes!constants!private! !
!Tools.ApplicationDeploymentWizard categoriesFor: #hasExistingLog!public!testing! !
!Tools.ApplicationDeploymentWizard categoriesFor: #hasLog!public!testing! !
!Tools.ApplicationDeploymentWizard categoriesFor: #help!commands!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #model:!accessing!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #onExecutableNameChanged!event handling!private! !
!Tools.ApplicationDeploymentWizard categoriesFor: #onImageStripperClassChanged!event handling!private! !
!Tools.ApplicationDeploymentWizard categoriesFor: #onViewOpened!event handling!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #queryCommand:!commands!private! !
!Tools.ApplicationDeploymentWizard categoriesFor: #refreshContents!accessing!private! !
!Tools.ApplicationDeploymentWizard categoriesFor: #reset!commands!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #sessionManagerOrShellChoices!accessing!private! !
!Tools.ApplicationDeploymentWizard categoriesFor: #showLog!commands!public! !
!Tools.ApplicationDeploymentWizard categoriesFor: #strip!commands!private! !
!Tools.ApplicationDeploymentWizard categoriesFor: #validateUserInterface!operations!public! !

!Tools.ApplicationDeploymentWizard class methodsFor!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators , #(#(#help 'F1'))!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ImageStripper new asValue!

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 37 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 15 1 31 86 135 1] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 1048838 ##(UI.FramingLayout) 170 176 34 12 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 768 nil 8 1801347024 1377606 4 ##(UI.CommandDescription) #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 357 13 578 131 49 768 994 #isEnabled: 8 #(false) 768 994 #text: 34 1 8 '&Next >' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedPreviousRight 11 1266 #fixedViewLeft 131 1266 #fixedParentTop 1 1266 #fixedViewTop 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1344 nil 848 nil 7 nil nil nil 1344 nil 8 1801347024 882 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 19 13 578 139 49 1344 994 #isEnabled: 8 #(false) 1344 994 #text: 34 1 8 '&Deploy' 1344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedParentLeft 9 1296 139 1312 1 1328 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1728 nil 848 nil 7 nil nil nil 1728 nil 8 1801347024 882 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 545 13 578 131 49 1728 994 #isEnabled: 8 #(false) 1728 994 #text: 34 1 8 '&Reset' 1728 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedViewRight -129 1266 #fixedParentRight -429 1312 1 1328 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2128 nil 848 nil 7 nil nil nil 2128 nil 8 1801347024 882 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 685 13 578 241 49 2128 994 #isEnabled: 8 #(false) 2128 994 #text: 34 1 8 '&Save Configuration' 2128 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1280 11 1296 241 1312 1 1328 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2496 nil 848 nil 7 nil nil nil 2496 nil 8 1801347024 882 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 217 13 578 131 49 2496 994 #isEnabled: 8 #(false) 2496 994 #text: 34 1 8 '< &Back' 2496 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #relativeParentWidth 852486 ##(Core.Fraction) 15 75 1296 131 1312 1 1328 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2912 nil 848 nil 7 nil nil nil 2912 nil 8 1801347024 882 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 955 13 578 139 49 2912 994 #text: 34 1 8 'Cancel' 2912 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 2096 -137 2112 -11 1312 1 1328 49 170 192 34 2 1344 8 'deploy' 1180166 ##(Graphics.Rectangle) 578 11 13 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 723 578 1119 81 640 994 #text: 34 1 8 'Buttons' 640 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 1344 2496 768 1728 2128 2912 1216 nil 27 nil nil 410 ##(UI.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3568 nil nil nil 7 nil nil nil 3568 853318 1 ##(UI.CardLayout) 138 144 34 9 1049094 ##(Core.Association) 3 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 3728 nil nil nil 5 nil nil nil 3728 706 170 176 34 28 410 ##(UI.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 3840 nil nil nil 5 nil nil nil 3840 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 309 578 975 71 3840 994 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 3840 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 1216 nil 27 1234 1712 31 2112 -109 1312 309 1328 71 410 ##(UI.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 4176 nil nil nil 5 nil nil nil 4176 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 43 387 578 381 81 4176 994 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 4176 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 193 0 0 0 211 0 0 0 233 0 0 0] 8 #() 1216 nil 27 1234 1712 43 1296 381 1312 387 1328 81 410 ##(UI.ComboBox) 34 17 nil 3728 34 2 8 1144063491 1025 4496 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) 848 nil 5 nil nil nil 4496 nil 8 1801138208 ##(UI.BasicListAbstract) 8 #() 401 930 138 144 34 1 994 #createAt:extent: 34 2 578 441 399 578 565 43 4496 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 199 0 0 0 246 1 0 0 220 0 0 0] 8 #() 1216 nil 27 1234 1712 441 2112 -109 1312 399 1328 43 410 ##(UI.TextEdit) 34 16 nil 3728 34 2 8 1140916352 1025 4864 nil 848 nil 5 nil nil nil 4864 nil 8 1801338832 3922 nil nil 1 930 138 144 34 1 994 #createAt:extent: 34 2 578 431 151 578 575 41 4864 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1216 nil 27 1234 1712 431 2112 -109 1312 151 1328 41 410 ##(UI.TextEdit) 34 16 nil 3728 34 2 8 1140850688 262145 5136 nil nil nil 5 nil nil nil 5136 nil 8 1801338832 3922 nil nil 1 930 138 144 34 2 994 #createAt:extent: 34 2 578 441 597 578 565 41 5136 994 #isEnabled: 8 #(false) 5136 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 1712 441 2112 -109 1312 597 1328 41 410 ##(UI.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 5440 nil nil nil 5 nil nil nil 5440 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 141 578 389 81 5440 994 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 5440 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 8 #() 1216 nil 27 1234 1712 31 1296 389 1312 141 1328 81 410 ##(UI.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 5760 nil 848 nil 5 nil nil nil 5760 nil 8 1801347024 882 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 441 661 578 139 45 5760 994 #isEnabled: 8 #(false) 5760 994 #text: 34 1 8 'S&how it' 5760 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1216 nil 29 1234 1712 441 1296 139 1312 661 1328 45 410 ##(UI.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 6128 nil 848 nil 5 nil nil nil 6128 nil 8 1801347024 882 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 1025 151 578 49 41 6128 994 #isEnabled: 8 #(false) 6128 994 #text: 34 1 8 '...' 6128 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1216 nil 29 1234 2096 -47 2112 -41 1312 151 1328 41 410 ##(UI.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 6496 nil nil nil 5 nil nil nil 6496 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 499 578 1045 81 6496 994 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 6496 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 249 0 0 0 25 2 0 0 33 1 0 0] 8 #() 1216 nil 27 1234 1712 31 2112 -39 1312 499 1328 81 410 ##(UI.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 6816 918598 2 ##(UI.ValueHolder) nil nil 1572870 ##(Kernel.NeverSearchPolicy) true nil nil 5 nil nil nil 6816 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 661 578 251 41 6816 994 #text: 34 1 8 'Log &class references' 6816 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1216 nil 27 1234 1712 61 1296 251 1312 661 1328 41 410 ##(UI.GroupBox) 34 14 nil 3728 34 2 8 1140850695 65 7200 nil 848 nil 5 nil nil nil 7200 nil 8 1801347024 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 279 578 1155 211 7200 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 244 0 0 0] 8 #() 1216 nil 27 1234 1712 1 2112 41 1312 279 1328 211 410 ##(UI.ContainerView) 34 15 nil 3728 34 2 8 1140850688 131073 7456 nil 848 nil 5 nil nil nil 7456 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 7456 34 2 8 1140850944 1 7536 6882 nil false 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 7650 #hash 8 #() 1312838 3 ##(Smalltalk.OLEPicture) nil true 2162694 ##(Kernel.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 1180166 ##(Smalltalk.IPicture) nil nil 578 321 327 578 8467 8627 834 #face3d nil 5 nil nil nil 7536 nil 8 4294902547 3922 nil nil nil 7744 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 7536 994 #text: 34 1 8 'Graphic' 7536 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 7456 34 2 8 1140855108 1 8176 nil 848 nil 5 nil nil nil 8176 nil 8 2029664608 3922 nil nil 41 nil 852230 ##(OS.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 8176 994 #text: 34 1 721158 ##(UI.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 2: \par
\f1\fs16\par
Choose an Executable File and RuntimeSessionManager\b0\par
\par
\par
\par
}
' 8176 994 #textLimit: 8 #(1073741823) 8176 994 #resetCharFormat 4608 8176 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4608 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 7456 994 #text: 34 1 8 'Heading' 7456 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 8176 7536 1216 nil 27 1234 1712 1 2112 1 1312 1 1328 121 410 ##(UI.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 8896 6882 nil nil 6928 true nil nil 5 nil nil nil 8896 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 597 578 251 41 8896 994 #text: 34 1 8 'Write &log file' 8896 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 1712 61 1296 251 1312 597 1328 41 410 ##(UI.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 9232 6882 nil nil 6928 false nil nil 5 nil nil nil 9232 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 211 578 431 81 9232 994 #text: 34 1 8 'Create single file, "To Go" distributable.' 9232 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1216 nil 27 1234 1712 31 1296 431 1312 211 1328 81 170 192 34 14 9232 8 'isToGo' 4496 8 'runtimeSessionManagerClass' 6816 8 'logReferencesToClasses' 5760 8 'showLog' 5136 8 'logFileName' 8896 8 'writeLogFile' 4864 8 'executableName' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 3728 994 #text: 34 1 8 'Step 2' 3728 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 7456 5440 4864 6128 9232 3840 4176 4496 6496 8896 6816 5136 5760 7200 1216 nil 27 3698 5 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 9936 nil nil nil 5 nil nil nil 9936 706 170 176 34 12 410 ##(UI.StaticText) 34 16 nil 9936 34 2 8 1140850944 1 10048 nil nil nil 5 nil nil nil 10048 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 499 578 979 109 10048 994 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10048 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -107 1312 499 1328 109 410 ##(UI.CheckBox) 34 16 nil 9936 34 2 8 1140924451 1 10368 6882 nil nil 6928 true nil nil 5 nil nil nil 10368 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 59 599 578 329 49 10368 994 #text: 34 1 8 'Remove redundant &packages' 10368 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 8 #() 1216 nil 27 1234 1712 59 1296 329 1312 599 1328 49 410 ##(UI.StaticText) 34 16 nil 9936 34 2 8 1140850944 1 10704 nil nil nil 5 nil nil nil 10704 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 389 578 201 41 10704 994 #text: 34 1 8 'Root package:' 10704 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1216 nil 27 1234 1712 81 1296 201 1312 389 1328 41 410 ##(UI.StaticText) 34 16 nil 9936 34 2 8 1140850944 1 11024 nil nil nil 5 nil nil nil 11024 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 171 578 975 191 11024 994 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 11024 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1216 nil 27 1234 1712 31 2112 -109 1312 171 1328 191 410 ##(UI.StaticText) 34 16 nil 9936 34 2 8 1140850944 262145 11344 nil nil nil 5 nil nil nil 11344 nil 8 1801195232 3922 nil nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 361 389 578 647 41 11344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1216 nil 27 1234 1712 361 2112 -107 1312 389 1328 41 410 ##(UI.ContainerView) 34 15 nil 9936 34 2 8 1140850688 131073 11616 nil 848 nil 5 nil nil nil 11616 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 11616 34 2 8 1140850944 1 11696 6882 nil false 7618 7650 #= 8 #() 7650 #hash 7712 7730 nil true 7776 8 'Resources\LagoonLogo.bmp' 7824 7858 nil nil 578 321 327 578 8467 8627 7920 nil 5 nil nil nil 11696 nil 8 4294902547 3922 nil nil nil 11840 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 11696 994 #text: 34 1 8 'Graphic' 11696 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 11616 34 2 8 1140855108 1 12160 nil 848 nil 5 nil nil nil 12160 nil 8 2029664608 3922 nil nil 41 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 12160 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 3:\f1\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\par
\b0\par
\par
\par
}
' 12160 994 #textLimit: 8 #(1073741823) 12160 994 #resetCharFormat 4608 12160 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4608 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 11616 994 #text: 34 1 8 'Heading' 11616 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 12160 11696 1216 nil 27 1234 1712 1 2112 1 1312 1 1328 121 170 192 34 4 11344 8 'rootPackage' 10368 8 'stripRedundantPackages' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 9936 994 #text: 34 1 8 'Step 3' 9936 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 11616 11024 10704 11344 10048 10368 1216 nil 27 3698 7 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 13136 nil nil nil 5 nil nil nil 13136 706 170 176 34 24 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 13248 6882 nil nil 6928 false nil nil 5 nil nil nil 13248 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 435 578 423 49 13248 994 #text: 34 1 8 'Preserve &aspect set methods' 13248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1216 nil 27 1234 1280 121 1296 423 1266 #fixedPreviousTop 1 1328 49 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 13600 6882 nil nil 6928 true nil nil 5 nil nil nil 13600 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 217 578 441 49 13600 994 #text: 34 1 8 'Remove redundant &classes' 13600 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 1216 nil 27 1234 1712 61 1296 441 1266 #fixedPreviousBottom 1 1328 49 410 ##(UI.StaticText) 34 16 nil 13136 34 2 8 1140850944 1 13952 nil nil nil 5 nil nil nil 13952 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 315 578 1019 121 13952 994 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 13952 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -67 13936 51 1328 121 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 14272 6882 nil nil 6928 false nil nil 5 nil nil nil 14272 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 581 578 423 49 14272 994 #text: 34 1 8 'Remove #shouldNot&Implement methods' 14272 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1216 nil 27 1234 1280 121 1296 423 13584 1 1328 49 410 ##(UI.StaticText) 34 16 nil 13136 34 2 8 1140850944 1 14608 nil nil nil 5 nil nil nil 14608 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 533 578 1079 49 14608 994 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 14608 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -7 13936 51 1328 49 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 14928 6882 nil nil 6928 false nil nil 5 nil nil nil 14928 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 645 578 441 49 14928 994 #text: 34 1 8 'Remove #&subclassResponsibility methods' 14928 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 1216 nil 27 1234 1712 61 1296 441 13936 17 1328 49 410 ##(UI.ContainerView) 34 15 nil 13136 34 2 8 1140850688 131073 15264 nil 848 nil 5 nil nil nil 15264 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 15264 34 2 8 1140850944 1 15344 6882 nil false 7618 7650 #= 8 #() 7650 #hash 7712 7730 nil true 7776 8 'Resources\LagoonLogo.bmp' 7824 7858 nil nil 578 321 327 578 8467 8627 7920 nil 5 nil nil nil 15344 nil 8 4294902547 3922 nil nil nil 15488 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 15344 994 #text: 34 1 8 'Graphic' 15344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 15264 34 2 8 1140855108 1 15808 nil 848 nil 5 nil nil nil 15808 nil 8 2029664608 3922 nil nil 41 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 15808 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 4:\par
\f1\fs16\par
\f0 Configure how the ImageStripper removes unwanted classes and methods\b0\f1\par
\par
\par
\par
}
' 15808 994 #textLimit: 8 #(1073741823) 15808 994 #resetCharFormat 4608 15808 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4608 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 15264 994 #text: 34 1 8 'Heading' 15264 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 15808 15344 1216 nil 27 1234 1712 1 2112 1 1312 1 1328 121 410 ##(UI.GroupBox) 34 14 nil 13136 34 2 8 1140850695 65 16496 nil 848 nil 5 nil nil nil 16496 nil 8 1801347024 930 138 144 34 1 994 #createAt:extent: 34 2 578 -17 281 578 1151 229 16496 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1216 nil 27 1234 1712 -17 2112 19 1312 281 1328 229 410 ##(UI.StaticText) 34 16 nil 13136 34 2 8 1140850944 1 16752 nil nil nil 5 nil nil nil 16752 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 1029 69 16752 994 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 16752 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -57 1312 149 1328 69 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 17072 6882 nil nil 6928 false nil nil 5 nil nil nil 17072 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 581 578 441 49 17072 994 #text: 34 1 8 'Remove #&deprecated methods' 17072 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 1216 nil 27 1234 1712 61 1296 441 13936 1 1328 49 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 17408 6882 nil nil 6928 true nil nil 5 nil nil nil 17408 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 217 578 423 49 17408 994 #text: 34 1 8 'Remove redundant &resources' 17408 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1216 nil 27 1234 1280 121 1296 423 13584 1 1328 49 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 17744 6882 nil nil 6928 false nil nil 5 nil nil nil 17744 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 435 578 441 49 17744 994 #text: 34 1 8 'Remove redundant &methods' 17744 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 1216 nil 27 1234 1712 61 1296 441 13936 1 1328 49 170 192 34 14 17072 8 'stripDeprecatedMethods' 17408 8 'stripRedundantResources' 14928 8 'stripSubclassResponsibility' 13248 8 'preserveAspectSetters' 17744 8 'stripRedundantMethods' 14272 8 'stripShouldNotImplement' 13600 8 'stripRedundantClasses' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 13136 994 #text: 34 1 8 'Step 4' 13136 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 15264 16752 13600 17408 13952 17744 13248 14608 17072 14272 14928 16496 1216 nil 27 3698 9 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 18448 nil nil nil 5 nil nil nil 18448 706 170 176 34 12 410 ##(UI.StaticText) 34 16 nil 18448 34 2 8 1140850944 1 18560 nil nil nil 5 nil nil nil 18560 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 1047 169 18560 994 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 18560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 25 2 0 0 158 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -39 1312 149 1328 169 410 ##(UI.StatusBar) 34 18 nil 18448 34 2 8 1140850700 1 18880 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 18880 nil 8 1801004784 170 192 34 2 1050374 ##(UI.StatusBarItem) 1 -1 18880 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'preStripScriptErrors' 138 144 34 1 19072 1311750 ##(UI.StatusBarNullItem) 513 1 18880 nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 31 571 578 1047 41 18880 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 8 #() 1216 nil 27 1234 1712 31 2112 -37 1312 571 1328 41 410 ##(UI.ReferenceView) 34 14 nil 18448 34 2 8 1140850688 131073 19344 nil nil nil 5 nil nil nil 19344 1376838 1 ##(UI.ResourceIdentifier) ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 31 321 578 1045 251 19344 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 25 2 0 0 29 1 0 0] 4608 1216 nil 27 1234 1712 31 2112 -39 1312 321 1328 251 410 ##(UI.PushButton) 34 20 nil 18448 34 2 8 1140924416 1 19600 nil 848 nil 5 nil nil nil 19600 nil 8 1801347024 882 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 881 661 578 211 51 19600 994 #isEnabled: 8 #(false) 19600 994 #text: 34 1 8 'Custom &Options' 19600 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1216 nil 29 1234 1712 881 1296 211 1312 661 1328 51 410 ##(UI.StaticText) 34 16 nil 18448 34 2 8 1140850944 1 19968 nil nil nil 5 nil nil nil 19968 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 651 578 791 71 19968 994 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 19968 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1216 nil 27 1234 1712 31 1296 791 1312 651 1328 71 410 ##(UI.ContainerView) 34 15 nil 18448 34 2 8 1140850688 131073 20288 nil 848 nil 5 nil nil nil 20288 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 20288 34 2 8 1140850944 1 20368 6882 nil false 7618 7650 #= 8 #() 7650 #hash 7712 7730 nil true 7776 8 'Resources\LagoonLogo.bmp' 7824 7858 nil nil 578 321 327 578 8467 8627 7920 nil 5 nil nil nil 20368 nil 8 4294902547 3922 nil nil nil 20512 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 20368 994 #text: 34 1 8 'Graphic' 20368 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 20288 34 2 8 1140855108 1 20832 nil 848 nil 5 nil nil nil 20832 nil 8 2029664608 3922 nil nil 41 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 20832 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 7:\f1\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\b0\par
}
' 20832 994 #textLimit: 8 #(1073741823) 20832 994 #resetCharFormat 4608 20832 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4608 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 20288 994 #text: 34 1 8 'Heading' 20288 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 20832 20368 1216 nil 27 1234 1712 1 2112 1 1312 1 1328 121 170 192 34 2 19344 8 'preStripScript' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 18448 994 #text: 34 1 8 'Step 7' 18448 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 20288 18560 19344 18880 19968 19600 1216 nil 27 3698 11 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 21792 nil nil nil 5 nil nil nil 21792 706 170 176 34 18 410 ##(UI.CheckBox) 34 16 nil 21792 34 2 8 1140924451 1 21904 6882 nil nil 6928 false nil nil 5 nil nil nil 21904 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 459 578 369 41 21904 994 #text: 34 1 8 'Remove class &GUIDs' 21904 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1216 nil 27 1234 1712 81 1296 369 1312 459 1328 41 410 ##(UI.CheckBox) 34 16 nil 21792 34 2 8 1140924451 1 22240 6882 nil nil 6928 false nil nil 5 nil nil nil 22240 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 389 578 369 69 22240 994 #text: 34 1 8 'Retain instance &variable names' 22240 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1216 nil 27 1234 1712 81 1296 369 1312 389 1328 69 410 ##(UI.CheckBox) 34 16 nil 21792 34 2 8 1140924451 1 22576 6882 nil nil 6928 true nil nil 5 nil nil nil 22576 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 249 578 369 59 22576 994 #text: 34 1 8 'Remove class meta-&information' 22576 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1216 nil 27 1234 1712 81 1296 369 1312 249 1328 59 410 ##(UI.GroupBox) 34 14 nil 21792 34 2 8 1140850695 65 22912 nil 848 nil 5 nil nil nil 22912 nil 8 1801347024 930 138 144 34 1 994 #createAt:extent: 34 2 578 -17 521 578 1151 229 22912 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1216 nil 27 1234 1712 -17 2112 19 1312 521 1328 229 410 ##(UI.ContainerView) 34 15 nil 21792 34 2 8 1140850688 131073 23168 nil 848 nil 5 nil nil nil 23168 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 23168 34 2 8 1140850944 1 23248 6882 nil false 7618 7650 #= 8 #() 7650 #hash 7712 7730 nil true 7776 8 'Resources\LagoonLogo.bmp' 7824 7858 nil nil 578 321 327 578 8467 8627 7920 nil 5 nil nil nil 23248 nil 8 4294902547 3922 nil nil nil 23392 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 23248 994 #text: 34 1 8 'Graphic' 23248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 23168 34 2 8 1140855108 1 23712 nil 848 nil 5 nil nil nil 23712 nil 8 2029664608 3922 nil nil 41 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 23712 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 5:\f1\fs16\par
\par
Decide what meta-level information is required at runtime\par
\b0\par
\par
\par
}
' 23712 994 #textLimit: 8 #(1073741823) 23712 994 #resetCharFormat 4608 23712 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4608 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 23168 994 #text: 34 1 8 'Heading' 23168 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 23712 23248 1216 nil 27 1234 1712 1 2112 1 1312 1 1328 121 410 ##(UI.CheckBox) 34 16 nil 21792 34 2 8 1140924451 1 24400 6882 nil nil 6928 false nil nil 5 nil nil nil 24400 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 649 578 369 49 24400 994 #text: 34 1 8 'Compile E&xternal Structures' 24400 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1216 nil 27 1234 1712 81 1296 369 1312 649 1328 49 410 ##(UI.StaticText) 34 16 nil 21792 34 2 8 1140850944 1 24736 nil nil nil 5 nil nil nil 24736 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 979 99 24736 994 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 24736 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -107 1312 149 1328 99 410 ##(UI.StaticText) 34 16 nil 21792 34 2 8 1140850944 1 25056 nil nil nil 5 nil nil nil 25056 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 549 578 979 89 25056 994 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 25056 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -107 1312 549 1328 89 410 ##(UI.StaticText) 34 16 nil 21792 34 2 8 1140850944 1 25376 nil nil nil 5 nil nil nil 25376 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 321 578 979 69 25376 994 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 25376 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -107 1312 321 1328 69 170 192 34 8 21904 8 'stripClassGuids' 22240 8 'retainInstVarNames' 22576 8 'stripClassInfo' 24400 8 'compileExternalStructures' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 21792 994 #text: 34 1 8 'Step 5' 21792 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 23168 24736 22576 25376 22240 21904 25056 24400 22912 1216 nil 27 3698 13 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 26016 nil nil nil 5 nil nil nil 26016 706 170 176 34 14 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 26128 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 18992 nil 26128 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 529 578 949 81 26128 994 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 26128 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -137 1312 529 1328 81 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 26496 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 18992 nil 26496 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 349 578 989 139 26496 994 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 26496 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -97 1312 349 1328 139 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850955 262145 26864 nil nil nil 5 nil nil nil 26864 nil 8 1801195232 3922 nil nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 281 269 578 737 41 26864 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1216 nil 27 1234 1712 281 2112 -97 1312 269 1328 41 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 27136 nil nil nil 5 nil nil nil 27136 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 641 578 979 59 27136 994 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 27136 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -107 1312 641 1328 59 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 27456 nil nil nil 5 nil nil nil 27456 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 269 578 189 49 27456 994 #text: 34 1 8 'E&xecutable name:' 27456 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1216 nil 27 1234 1712 81 1296 189 1312 269 1328 49 410 ##(UI.ContainerView) 34 15 nil 26016 34 2 8 1140850688 131073 27776 nil 848 nil 5 nil nil nil 27776 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 27776 34 2 8 1140850944 1 27856 6882 nil false 7618 7650 #= 8 #() 7650 #hash 7712 7730 nil true 7776 8 'Resources\LagoonLogo.bmp' 7824 7858 nil nil 578 321 327 578 8467 8627 7920 nil 5 nil nil nil 27856 nil 8 4294902547 3922 nil nil nil 28000 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 27856 994 #text: 34 1 8 'Graphic' 27856 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 27776 34 2 8 1140855108 1 28320 nil 848 nil 5 nil nil nil 28320 nil 8 2029664608 3922 nil nil 41 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 28320 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Final Step:\par
\f1\fs16\par
Deployment\b0\par
\par
\par
\par
}
' 28320 994 #textLimit: 8 #(1073741823) 28320 994 #resetCharFormat 4608 28320 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4608 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 27776 994 #text: 34 1 8 'Heading' 27776 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 28320 27856 1216 nil 27 1234 1712 1 2112 1 1312 1 1328 121 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 29008 nil nil nil 5 nil nil nil 29008 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 161 578 989 81 29008 994 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 29008 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -97 1312 161 1328 81 170 192 34 2 26864 8 'executablePath2' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 26016 994 #text: 34 1 8 'Final step' 26016 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 27776 29008 27456 26864 26128 26496 27136 1216 nil 27 3698 15 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 29600 nil 848 nil 7 nil nil nil 29600 706 170 176 34 8 410 ##(UI.RichTextEdit) 34 18 nil 29600 34 2 8 1140855110 1 29712 nil 848 nil 7 461638 4 ##(UI.Menu) nil true 34 10 1180742 2 ##(UI.CommandMenuItem) 1 882 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 29826 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29826 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29826 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29826 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29890 4097 29778 nil true 34 3 29826 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29826 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29826 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29890 4097 29826 1 882 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29712 nil 8 2029664608 3922 nil nil 43 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 5 994 #createAt:extent: 34 2 578 419 1 578 649 489 29712 994 #contextMenu: 34 1 29792 29712 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}}
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
' 29712 994 #textLimit: 8 #(1073741823) 29712 994 #resetCharFormat 4608 29712 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1216 nil 27 1234 1712 419 2112 -47 1312 1 1328 489 410 ##(UI.ImageView) 34 21 nil 29600 34 2 8 1140850944 1 30784 6882 nil false 7618 7650 #= 8 #() 7650 #hash 7712 7730 nil true 7776 8 'Resources\LagoonSideBar.jpg' 7824 7858 nil nil 578 381 761 578 10055 20109 848 nil 7 nil nil nil 30784 nil 8 4294902547 3922 nil nil nil 30928 #centered 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 379 741 30784 994 #text: 34 1 8 'Lagoon Graphic' 30784 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1216 nil 27 1234 1712 1 1296 379 1312 1 1328 741 410 ##(UI.TextEdit) 34 16 nil 29600 34 2 8 1140850816 262145 31264 nil 834 #whiteSmoke nil 7 nil nil nil 31264 nil 8 1801338832 3922 nil nil 35 930 138 144 34 1 994 #createAt:extent: 34 2 578 421 491 578 645 41 31264 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1216 nil 27 1234 1712 421 2112 -49 13936 3 1328 41 410 ##(UI.RichTextEdit) 34 18 nil 29600 34 2 8 1140855110 1 31552 nil 848 nil 7 29778 nil true 34 10 29826 1 882 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 29890 4097 29826 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29826 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29826 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29826 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29890 4097 29778 nil true 34 3 29826 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29826 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29826 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29890 4097 29826 1 882 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 31552 nil 8 2029664608 3922 nil nil 43 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 5 994 #createAt:extent: 34 2 578 419 681 578 549 49 31552 994 #contextMenu: 34 1 31616 31552 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click \b Next \b0 to continue.\par
\par
\par
\pard\qc\par
}
' 31552 994 #textLimit: 8 #(1073741823) 31552 994 #resetCharFormat 4608 31552 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1216 nil 27 1234 1712 419 1296 549 1312 681 1328 49 170 192 34 2 31264 8 'executablePath1' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 29600 994 #text: 34 1 8 'Intro' 29600 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 30784 29712 31264 31552 1216 nil 27 3698 17 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 32848 nil nil nil 5 nil nil nil 32848 706 170 176 34 8 410 ##(UI.StaticText) 34 16 nil 32848 34 2 8 1140850944 1 32960 nil nil nil 5 nil nil nil 32960 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 229 578 979 149 32960 994 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 32960 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -107 1312 229 1328 149 410 ##(UI.ContainerView) 34 15 nil 32848 34 2 8 1140850688 131073 33280 nil 848 nil 5 nil nil nil 33280 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 33280 34 2 8 1140850944 1 33360 6882 nil false 7618 7650 #= 8 #() 7650 #hash 7712 7730 nil true 7776 8 'Resources\LagoonLogo.bmp' 7824 7858 nil nil 578 321 327 578 8467 8627 7920 nil 5 nil nil nil 33360 nil 8 4294902547 3922 nil nil nil 33504 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 33360 994 #text: 34 1 8 'Graphic' 33360 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 33280 34 2 8 1140855108 1 33824 nil 848 nil 5 nil nil nil 33824 nil 8 2029664608 3922 nil nil 41 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 33824 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 1:\f1\fs16\par
\par
Choose an ImageStripper to perform the deployment process\b0\par
\par
\par
\par
}
' 33824 994 #textLimit: 8 #(1073741823) 33824 994 #resetCharFormat 4608 33824 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4608 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 33280 994 #text: 34 1 8 'Heading' 33280 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 33824 33360 1216 nil 27 1234 1712 1 2112 1 1312 1 1328 121 410 ##(UI.StaticText) 34 16 nil 32848 34 2 8 1140850944 1 34512 nil nil nil 5 nil nil nil 34512 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 401 578 249 121 34512 994 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 34512 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1216 nil 27 1234 1712 81 1296 249 1312 401 1328 121 410 ##(UI.ComboBox) 34 17 nil 32848 34 2 8 1144063491 1025 34832 4562 138 144 4608 nil 4640 848 nil 5 nil nil nil 34832 nil 8 1801138208 ##(UI.BasicListAbstract) 4672 401 930 138 144 34 1 994 #createAt:extent: 34 2 578 349 409 578 647 43 34832 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1216 nil 27 1234 1712 349 2112 -119 1312 409 1328 41 170 192 34 2 34832 8 'imageStripperClass' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 32848 994 #text: 34 1 8 'Step 1' 32848 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 33280 32960 34512 34832 1216 nil 27 3698 19 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 35392 nil nil nil 5 nil nil nil 35392 706 170 176 34 14 410 ##(UI.StaticText) 34 16 nil 35392 34 2 8 1140850944 1 35504 nil nil nil 5 nil nil nil 35504 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 391 578 967 49 35504 994 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 35504 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1216 nil 27 1234 1712 31 2112 -117 1312 391 1328 49 410 ##(UI.CheckBox) 34 16 nil 35392 34 2 8 1140924451 1 35824 6882 nil nil 6928 true nil nil 5 nil nil nil 35824 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 71 451 578 379 49 35824 994 #text: 34 1 8 'Fold duplicate s&trings' 35824 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1216 nil 27 1234 1712 71 1296 379 1312 451 1328 49 410 ##(UI.CheckBox) 34 16 nil 35392 34 2 8 1140924451 1 36160 6882 nil nil 6928 false nil nil 5 nil nil nil 36160 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 209 578 369 41 36160 994 #text: 34 1 8 'Remove &Class Builder' 36160 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1216 nil 27 1234 1712 81 1296 369 1312 209 1328 41 410 ##(UI.ContainerView) 34 15 nil 35392 34 2 8 1140850688 131073 36496 nil 848 nil 5 nil nil nil 36496 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 36496 34 2 8 1140850944 1 36576 6882 nil false 7618 7650 #= 8 #() 7650 #hash 7712 7730 nil true 7776 8 'Resources\LagoonLogo.bmp' 7824 7858 nil nil 578 321 327 578 8467 8627 7920 nil 5 nil nil nil 36576 nil 8 4294902547 3922 nil nil nil 36720 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 36576 994 #text: 34 1 8 'Graphic' 36576 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 36496 34 2 8 1140855108 1 37040 nil 848 nil 5 nil nil nil 37040 nil 8 2029664608 3922 nil nil 41 nil 8274 8 #[0 0 0 0 0 0 0 0 176 0 120 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 37040 994 #text: 34 1 8466 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 6:\f1\fs16\par
\par
Miscellaneous stripping options\b0\par
\par
\par
\par
}
' 37040 994 #textLimit: 8 #(1073741823) 37040 994 #resetCharFormat 4608 37040 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 4608 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 36496 994 #text: 34 1 8 'Heading' 36496 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 37040 36576 1216 nil 27 1234 1712 1 2112 1 1312 1 1328 121 410 ##(UI.GroupBox) 34 14 nil 35392 34 2 8 1140850695 65 37728 nil 848 nil 5 nil nil nil 37728 nil 8 1801347024 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 327 578 1115 393 37728 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1216 nil 27 1234 1712 1 2112 1 1312 327 1328 393 410 ##(UI.CheckBox) 34 16 nil 35392 34 2 8 1140924451 1 37984 6882 nil nil 6928 true nil nil 5 nil nil nil 37984 nil 8 1801347024 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 71 511 578 379 41 37984 994 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 37984 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1216 nil 27 1234 1712 71 1296 379 1312 511 1328 41 410 ##(UI.StaticText) 34 16 nil 35392 34 2 8 1140850944 1 38320 nil nil nil 5 nil nil nil 38320 nil 8 1801195232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 161 578 989 49 38320 994 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 38320 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1216 nil 27 1234 1712 29 2112 -97 1312 161 1328 49 170 192 34 6 36160 8 'stripClassBuilder' 37984 8 'stripDuplicateBytecodes' 35824 8 'stripDuplicateStrings' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 35392 994 #text: 34 1 8 'Step 6' 35392 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 36496 38320 36160 35504 35824 37984 37728 1216 nil 27 29600 nil nil nil 170 192 34 2 29600 8 'Intro' nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 1 578 1119 723 3568 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 29600 32848 3728 9936 13136 21792 35392 18448 26016 1216 nil 27 170 192 34 2 3568 8 'Steps' 3298 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 false 8 1996777232 930 138 144 34 2 994 #createAt:extent: 34 2 578 6143 21 578 1151 881 416 994 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 62 14 0 0 194 1 0 0] 34 2 3568 640 1216 nil 27 )!

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
!Tools.ApplicationDeploymentWizard class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #defaultModel!models!public! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #displayOn:!displaying!public! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #icon!constants!public! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #initialize!initializing!private! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #publishedAspects!development!public! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #saveImageOnDeploy!options!public! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #saveImageOnDeploy:!options!public! !
!Tools.ApplicationDeploymentWizard class categoriesFor: #toolsFolderIcon!accessing!public! !

