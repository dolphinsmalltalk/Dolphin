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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #dialog nil 37 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 15 1 31 86 135 1] 918022 ##(Graphics.Point) 193 193 nil 416 984838 ##(UI.BorderLayout) 1 1 nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 1048838 ##(UI.FramingLayout) 170 176 34 12 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 768 nil 8 1801347024 1377606 4 ##(UI.CommandDescription) #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 3 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 578 217 13 578 131 49 768 994 #isEnabled: 8 #(false) 768 994 #text: 34 1 8 '< &Back' 768 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #relativeParentWidth 852486 ##(Core.Fraction) 15 75 1266 #fixedViewLeft 131 1266 #fixedParentTop 1 1266 #fixedViewTop 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1376 nil 848 nil 7 nil nil nil 1376 nil 8 1801347024 882 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 19 13 578 139 49 1376 994 #isEnabled: 8 #(false) 1376 994 #text: 34 1 8 '&Deploy' 1376 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedParentLeft 9 1328 139 1344 1 1360 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1760 nil 848 nil 7 nil nil nil 1760 nil 8 1801347024 882 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 545 13 578 131 49 1760 994 #isEnabled: 8 #(false) 1760 994 #text: 34 1 8 '&Reset' 1760 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedViewRight -129 1266 #fixedParentRight -429 1344 1 1360 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2160 nil 848 nil 7 nil nil nil 2160 nil 8 1801347024 882 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 685 13 578 241 49 2160 994 #isEnabled: 8 #(false) 2160 994 #text: 34 1 8 '&Save Configuration' 2160 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 1266 #fixedPreviousRight 11 1328 241 1344 1 1360 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2544 nil 848 nil 7 nil nil nil 2544 nil 8 1801347024 882 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 955 13 578 139 49 2544 994 #text: 34 1 8 'Cancel' 2544 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 2128 -137 2144 -11 1344 1 1360 49 410 ##(UI.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2880 nil 848 nil 7 nil nil nil 2880 nil 8 1801347024 882 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 357 13 578 131 49 2880 994 #isEnabled: 8 #(false) 2880 994 #text: 34 1 8 '&Next >' 2880 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 1216 nil 29 1234 2528 11 1328 131 1344 1 1360 49 170 192 34 2 1376 8 'deploy' 1180166 ##(Graphics.Rectangle) 578 11 13 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 723 578 1119 81 640 994 #text: 34 1 8 'Buttons' 640 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 1376 768 2880 1760 2160 2544 1216 nil 27 nil nil 410 ##(UI.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3568 nil nil nil 7 nil nil nil 3568 853318 1 ##(UI.CardLayout) 138 144 34 9 1049094 ##(Core.Association) 3 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 3728 nil nil nil 5 nil nil nil 3728 706 170 176 34 28 410 ##(UI.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 3840 918598 2 ##(UI.ValueHolder) nil nil 1572870 ##(Kernel.NeverSearchPolicy) false nil nil 5 nil nil nil 3840 nil 8 1801347024 1049094 ##(UI.NullConverter) nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 211 578 431 81 3840 994 #text: 34 1 8 'Create single file, "To Go" distributable.' 3840 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1216 nil 27 1234 1744 31 1328 431 1344 211 1360 81 410 ##(UI.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 4240 nil nil nil 5 nil nil nil 4240 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 499 578 1045 81 4240 994 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 4240 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 249 0 0 0 25 2 0 0 33 1 0 0] 8 #() 1216 nil 27 1234 1744 31 2144 -39 1344 499 1360 81 410 ##(UI.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 4560 3906 nil nil 3952 true nil nil 5 nil nil nil 4560 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 661 578 251 41 4560 994 #text: 34 1 8 'Log &class references' 4560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1216 nil 27 1234 1744 61 1328 251 1344 661 1360 41 410 ##(UI.ContainerView) 34 15 nil 3728 34 2 8 1140850688 131073 4896 nil 848 nil 5 nil nil nil 4896 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 4896 34 2 8 1140850944 1 4976 3906 nil false 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 5090 #hash 8 #() 919622 3 ##(OS.COM.Picture) nil true 2162694 ##(Kernel.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 983558 ##(OS.COM.IPicture) nil nil 578 321 327 578 8467 8627 834 #face3d nil 5 nil nil nil 4976 nil 8 4294902547 3986 nil nil nil 5184 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 4976 994 #text: 34 1 8 'Graphic' 4976 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 4896 34 2 8 1140855108 1 5616 nil 848 nil 5 nil nil nil 5616 nil 8 1446852960 3986 nil nil 41 nil 852230 ##(OS.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 5616 994 #text: 34 1 721158 ##(UI.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 2: \par
\f1\fs16\par
Choose an Executable File and RuntimeSessionManager\b0\par
\par
\par
\par
}
' 5616 994 #textLimit: 8 #(1073741823) 5616 994 #resetCharFormat 8 #() 5616 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 6000 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 4896 994 #text: 34 1 8 'Heading' 4896 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 5616 4976 1216 nil 27 1234 1744 1 2144 1 1344 1 1360 121 410 ##(UI.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 6352 3906 nil nil 3952 true nil nil 5 nil nil nil 6352 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 597 578 251 41 6352 994 #text: 34 1 8 'Write &log file' 6352 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 1744 61 1328 251 1344 597 1360 41 410 ##(UI.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 6688 nil nil nil 5 nil nil nil 6688 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 43 387 578 381 81 6688 994 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 6688 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 193 0 0 0 211 0 0 0 233 0 0 0] 8 #() 1216 nil 27 1234 1744 43 1328 381 1344 387 1360 81 410 ##(UI.TextEdit) 34 16 nil 3728 34 2 8 1140916352 1025 7008 nil 848 nil 5 nil nil nil 7008 nil 8 1801338832 3986 nil nil 1 930 138 144 34 1 994 #createAt:extent: 34 2 578 431 151 578 575 41 7008 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1216 nil 27 1234 1744 431 2144 -109 1344 151 1360 41 410 ##(UI.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 7280 nil 848 nil 5 nil nil nil 7280 nil 8 1801347024 882 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 1025 151 578 49 41 7280 994 #isEnabled: 8 #(false) 7280 994 #text: 34 1 8 '...' 7280 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1216 nil 29 1234 2128 -47 2144 -41 1344 151 1360 41 410 ##(UI.ComboBox) 34 17 nil 3728 34 2 8 1144063491 1025 7648 787270 2 ##(UI.ListModel) 138 144 6000 nil 1769478 ##(Kernel.IdentitySearchPolicy) 848 nil 5 nil nil nil 7648 nil 8 1801138208 ##(UI.BasicListAbstract) 8 #() 401 930 138 144 34 1 994 #createAt:extent: 34 2 578 441 399 578 565 43 7648 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 199 0 0 0 246 1 0 0 220 0 0 0] 8 #() 1216 nil 27 1234 1744 441 2144 -109 1344 399 1360 43 410 ##(UI.TextEdit) 34 16 nil 3728 34 2 8 1140850688 262145 8000 nil nil nil 5 nil nil nil 8000 nil 8 1801338832 3986 nil nil 1 930 138 144 34 2 994 #createAt:extent: 34 2 578 441 597 578 565 41 8000 994 #isEnabled: 8 #(false) 8000 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 1744 441 2144 -109 1344 597 1360 41 410 ##(UI.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 8304 nil nil nil 5 nil nil nil 8304 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 141 578 389 81 8304 994 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 8304 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 8 #() 1216 nil 27 1234 1744 31 1328 389 1344 141 1360 81 410 ##(UI.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 8624 nil 848 nil 5 nil nil nil 8624 nil 8 1801347024 882 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 441 661 578 139 45 8624 994 #isEnabled: 8 #(false) 8624 994 #text: 34 1 8 'S&how it' 8624 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1216 nil 29 1234 1744 441 1328 139 1344 661 1360 45 410 ##(UI.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 8992 nil nil nil 5 nil nil nil 8992 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 309 578 975 71 8992 994 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 8992 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 1216 nil 27 1234 1744 31 2144 -109 1344 309 1360 71 410 ##(UI.GroupBox) 34 14 nil 3728 34 2 8 1140850695 65 9312 nil 848 nil 5 nil nil nil 9312 nil 8 1801347024 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 279 578 1155 211 9312 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 244 0 0 0] 8 #() 1216 nil 27 1234 1744 1 2144 41 1344 279 1360 211 170 192 34 14 7008 8 'executableName' 3840 8 'isToGo' 8000 8 'logFileName' 8624 8 'showLog' 7648 8 'runtimeSessionManagerClass' 6352 8 'writeLogFile' 4560 8 'logReferencesToClasses' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 3728 994 #text: 34 1 8 'Step 2' 3728 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 4896 8304 7008 7280 3840 8992 6688 7648 4240 6352 4560 8000 8624 9312 1216 nil 27 3698 5 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 9936 nil nil nil 5 nil nil nil 9936 706 170 176 34 12 410 ##(UI.StaticText) 34 16 nil 9936 34 2 8 1140850944 1 10048 nil nil nil 5 nil nil nil 10048 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 389 578 201 41 10048 994 #text: 34 1 8 'Root package:' 10048 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1216 nil 27 1234 1744 81 1328 201 1344 389 1360 41 410 ##(UI.StaticText) 34 16 nil 9936 34 2 8 1140850944 1 10368 nil nil nil 5 nil nil nil 10368 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 499 578 979 109 10368 994 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10368 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -107 1344 499 1360 109 410 ##(UI.StaticText) 34 16 nil 9936 34 2 8 1140850944 1 10688 nil nil nil 5 nil nil nil 10688 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 171 578 975 191 10688 994 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 10688 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1216 nil 27 1234 1744 31 2144 -109 1344 171 1360 191 410 ##(UI.StaticText) 34 16 nil 9936 34 2 8 1140850944 262145 11008 nil nil nil 5 nil nil nil 11008 nil 8 1801195232 3986 nil nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 361 389 578 647 41 11008 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1216 nil 27 1234 1744 361 2144 -107 1344 389 1360 41 410 ##(UI.CheckBox) 34 16 nil 9936 34 2 8 1140924451 1 11280 3906 nil nil 3952 true nil nil 5 nil nil nil 11280 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 59 599 578 329 49 11280 994 #text: 34 1 8 'Remove redundant &packages' 11280 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 8 #() 1216 nil 27 1234 1744 59 1328 329 1344 599 1360 49 410 ##(UI.ContainerView) 34 15 nil 9936 34 2 8 1140850688 131073 11616 nil 848 nil 5 nil nil nil 11616 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 11616 34 2 8 1140850944 1 11696 3906 nil false 5058 5090 #= 8 #() 5090 #hash 5152 5170 nil true 5216 8 'Resources\LagoonLogo.bmp' 5264 5298 nil nil 578 321 327 578 8467 8627 5360 nil 5 nil nil nil 11696 nil 8 4294902547 3986 nil nil nil 11840 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 11696 994 #text: 34 1 8 'Graphic' 11696 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 11616 34 2 8 1140855108 1 12160 nil 848 nil 5 nil nil nil 12160 nil 8 1446852960 3986 nil nil 41 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 12160 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 3:\f1\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\par
\b0\par
\par
\par
}
' 12160 994 #textLimit: 8 #(1073741823) 12160 994 #resetCharFormat 6000 12160 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 6000 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 11616 994 #text: 34 1 8 'Heading' 11616 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 12160 11696 1216 nil 27 1234 1744 1 2144 1 1344 1 1360 121 170 192 34 4 11280 8 'stripRedundantPackages' 11008 8 'rootPackage' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 9936 994 #text: 34 1 8 'Step 3' 9936 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 11616 10688 10048 11008 10368 11280 1216 nil 27 3698 7 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 13136 nil nil nil 5 nil nil nil 13136 706 170 176 34 24 410 ##(UI.StaticText) 34 16 nil 13136 34 2 8 1140850944 1 13248 nil nil nil 5 nil nil nil 13248 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 533 578 1079 49 13248 994 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 13248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -7 1266 #fixedPreviousBottom 51 1360 49 410 ##(UI.StaticText) 34 16 nil 13136 34 2 8 1140850944 1 13584 nil nil nil 5 nil nil nil 13584 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 315 578 1019 121 13584 994 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 13584 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -67 13568 51 1360 121 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 13904 3906 nil nil 3952 false nil nil 5 nil nil nil 13904 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 581 578 423 49 13904 994 #text: 34 1 8 'Remove #shouldNot&Implement methods' 13904 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1216 nil 27 1234 2528 121 1328 423 1266 #fixedPreviousTop 1 1360 49 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 14256 3906 nil nil 3952 false nil nil 5 nil nil nil 14256 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 581 578 441 49 14256 994 #text: 34 1 8 'Remove #&deprecated methods' 14256 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 1216 nil 27 1234 1744 61 1328 441 13568 1 1360 49 410 ##(UI.StaticText) 34 16 nil 13136 34 2 8 1140850944 1 14592 nil nil nil 5 nil nil nil 14592 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 1029 69 14592 994 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 14592 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -57 1344 149 1360 69 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 14912 3906 nil nil 3952 false nil nil 5 nil nil nil 14912 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 435 578 423 49 14912 994 #text: 34 1 8 'Preserve &aspect set methods' 14912 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1216 nil 27 1234 2528 121 1328 423 14240 1 1360 49 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 15248 3906 nil nil 3952 true nil nil 5 nil nil nil 15248 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 217 578 441 49 15248 994 #text: 34 1 8 'Remove redundant &classes' 15248 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 1216 nil 27 1234 1744 61 1328 441 13568 1 1360 49 410 ##(UI.GroupBox) 34 14 nil 13136 34 2 8 1140850695 65 15584 nil 848 nil 5 nil nil nil 15584 nil 8 1801347024 930 138 144 34 1 994 #createAt:extent: 34 2 578 -17 281 578 1151 229 15584 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1216 nil 27 1234 1744 -17 2144 19 1344 281 1360 229 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 15840 3906 nil nil 3952 true nil nil 5 nil nil nil 15840 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 217 578 423 49 15840 994 #text: 34 1 8 'Remove redundant &resources' 15840 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1216 nil 27 1234 2528 121 1328 423 14240 1 1360 49 410 ##(UI.ContainerView) 34 15 nil 13136 34 2 8 1140850688 131073 16176 nil 848 nil 5 nil nil nil 16176 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 16176 34 2 8 1140850944 1 16256 3906 nil false 5058 5090 #= 8 #() 5090 #hash 5152 5170 nil true 5216 8 'Resources\LagoonLogo.bmp' 5264 5298 nil nil 578 321 327 578 8467 8627 5360 nil 5 nil nil nil 16256 nil 8 4294902547 3986 nil nil nil 16400 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 16256 994 #text: 34 1 8 'Graphic' 16256 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 16176 34 2 8 1140855108 1 16720 nil 848 nil 5 nil nil nil 16720 nil 8 1446852960 3986 nil nil 41 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 16720 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 4:\par
\f1\fs16\par
\f0 Configure how the ImageStripper removes unwanted classes and methods\b0\f1\par
\par
\par
\par
}
' 16720 994 #textLimit: 8 #(1073741823) 16720 994 #resetCharFormat 6000 16720 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 6000 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 16176 994 #text: 34 1 8 'Heading' 16176 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 16720 16256 1216 nil 27 1234 1744 1 2144 1 1344 1 1360 121 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 17408 3906 nil nil 3952 false nil nil 5 nil nil nil 17408 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 435 578 441 49 17408 994 #text: 34 1 8 'Remove redundant &methods' 17408 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 1216 nil 27 1234 1744 61 1328 441 13568 1 1360 49 410 ##(UI.CheckBox) 34 16 nil 13136 34 2 8 1140924451 1 17744 3906 nil nil 3952 false nil nil 5 nil nil nil 17744 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 645 578 441 49 17744 994 #text: 34 1 8 'Remove #&subclassResponsibility methods' 17744 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 1216 nil 27 1234 1744 61 1328 441 13568 17 1360 49 170 192 34 14 14912 8 'preserveAspectSetters' 15248 8 'stripRedundantClasses' 13904 8 'stripShouldNotImplement' 17408 8 'stripRedundantMethods' 14256 8 'stripDeprecatedMethods' 15840 8 'stripRedundantResources' 17744 8 'stripSubclassResponsibility' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 13136 994 #text: 34 1 8 'Step 4' 13136 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 16176 14592 15248 15840 13584 17408 14912 13248 14256 13904 17744 15584 1216 nil 27 3698 9 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 18448 nil nil nil 5 nil nil nil 18448 706 170 176 34 12 410 ##(UI.StaticText) 34 16 nil 18448 34 2 8 1140850944 1 18560 nil nil nil 5 nil nil nil 18560 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 1047 169 18560 994 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 18560 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 25 2 0 0 158 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -39 1344 149 1360 169 410 ##(UI.StaticText) 34 16 nil 18448 34 2 8 1140850944 1 18880 nil nil nil 5 nil nil nil 18880 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 651 578 791 71 18880 994 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 18880 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1216 nil 27 1234 1744 31 1328 791 1344 651 1360 71 410 ##(UI.PushButton) 34 20 nil 18448 34 2 8 1140924416 1 19200 nil 848 nil 5 nil nil nil 19200 nil 8 1801347024 882 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 881 661 578 211 51 19200 994 #isEnabled: 8 #(false) 19200 994 #text: 34 1 8 'Custom &Options' 19200 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1216 nil 29 1234 1744 881 1328 211 1344 661 1360 51 410 ##(UI.StatusBar) 34 18 nil 18448 34 2 8 1140850700 1 19568 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 19568 nil 8 1801004784 170 192 34 2 1050374 ##(UI.StatusBarItem) 1 -1 19568 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'preStripScriptErrors' 138 144 34 1 19760 1311750 ##(UI.StatusBarNullItem) 513 1 19568 nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 31 571 578 1047 41 19568 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 8 #() 1216 nil 27 1234 1744 31 2144 -37 1344 571 1360 41 410 ##(UI.ReferenceView) 34 14 nil 18448 34 2 8 1140850688 131073 20032 nil nil nil 5 nil nil nil 20032 1376838 1 ##(UI.ResourceIdentifier) ##(Tools.SmalltalkWorkspace) #resource_Default_view nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 31 321 578 1045 251 20032 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 25 2 0 0 29 1 0 0] 6000 1216 nil 27 1234 1744 31 2144 -39 1344 321 1360 251 410 ##(UI.ContainerView) 34 15 nil 18448 34 2 8 1140850688 131073 20288 nil 848 nil 5 nil nil nil 20288 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 20288 34 2 8 1140850944 1 20368 3906 nil false 5058 5090 #= 8 #() 5090 #hash 5152 5170 nil true 5216 8 'Resources\LagoonLogo.bmp' 5264 5298 nil nil 578 321 327 578 8467 8627 5360 nil 5 nil nil nil 20368 nil 8 4294902547 3986 nil nil nil 20512 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 20368 994 #text: 34 1 8 'Graphic' 20368 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 20288 34 2 8 1140855108 1 20832 nil 848 nil 5 nil nil nil 20832 nil 8 1446852960 3986 nil nil 41 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 20832 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 7:\f1\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\b0\par
}
' 20832 994 #textLimit: 8 #(1073741823) 20832 994 #resetCharFormat 6000 20832 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 6000 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 20288 994 #text: 34 1 8 'Heading' 20288 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 20832 20368 1216 nil 27 1234 1744 1 2144 1 1344 1 1360 121 170 192 34 2 20032 8 'preStripScript' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 18448 994 #text: 34 1 8 'Step 7' 18448 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 20288 18560 20032 19568 18880 19200 1216 nil 27 3698 11 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 21792 nil nil nil 5 nil nil nil 21792 706 170 176 34 18 410 ##(UI.CheckBox) 34 16 nil 21792 34 2 8 1140924451 1 21904 3906 nil nil 3952 false nil nil 5 nil nil nil 21904 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 649 578 369 49 21904 994 #text: 34 1 8 'Compile E&xternal Structures' 21904 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1216 nil 27 1234 1744 81 1328 369 1344 649 1360 49 410 ##(UI.ContainerView) 34 15 nil 21792 34 2 8 1140850688 131073 22240 nil 848 nil 5 nil nil nil 22240 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 22240 34 2 8 1140850944 1 22320 3906 nil false 5058 5090 #= 8 #() 5090 #hash 5152 5170 nil true 5216 8 'Resources\LagoonLogo.bmp' 5264 5298 nil nil 578 321 327 578 8467 8627 5360 nil 5 nil nil nil 22320 nil 8 4294902547 3986 nil nil nil 22464 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 22320 994 #text: 34 1 8 'Graphic' 22320 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 22240 34 2 8 1140855108 1 22784 nil 848 nil 5 nil nil nil 22784 nil 8 1446852960 3986 nil nil 41 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 22784 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 5:\f1\fs16\par
\par
Decide what meta-level information is required at runtime\par
\b0\par
\par
\par
}
' 22784 994 #textLimit: 8 #(1073741823) 22784 994 #resetCharFormat 6000 22784 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 6000 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 22240 994 #text: 34 1 8 'Heading' 22240 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 22784 22320 1216 nil 27 1234 1744 1 2144 1 1344 1 1360 121 410 ##(UI.CheckBox) 34 16 nil 21792 34 2 8 1140924451 1 23472 3906 nil nil 3952 false nil nil 5 nil nil nil 23472 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 459 578 369 41 23472 994 #text: 34 1 8 'Remove class &GUIDs' 23472 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1216 nil 27 1234 1744 81 1328 369 1344 459 1360 41 410 ##(UI.CheckBox) 34 16 nil 21792 34 2 8 1140924451 1 23808 3906 nil nil 3952 false nil nil 5 nil nil nil 23808 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 389 578 369 69 23808 994 #text: 34 1 8 'Retain instance &variable names' 23808 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1216 nil 27 1234 1744 81 1328 369 1344 389 1360 69 410 ##(UI.StaticText) 34 16 nil 21792 34 2 8 1140850944 1 24144 nil nil nil 5 nil nil nil 24144 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 549 578 979 89 24144 994 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 24144 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -107 1344 549 1360 89 410 ##(UI.GroupBox) 34 14 nil 21792 34 2 8 1140850695 65 24464 nil 848 nil 5 nil nil nil 24464 nil 8 1801347024 930 138 144 34 1 994 #createAt:extent: 34 2 578 -17 521 578 1151 229 24464 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1216 nil 27 1234 1744 -17 2144 19 1344 521 1360 229 410 ##(UI.CheckBox) 34 16 nil 21792 34 2 8 1140924451 1 24720 3906 nil nil 3952 true nil nil 5 nil nil nil 24720 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 249 578 369 59 24720 994 #text: 34 1 8 'Remove class meta-&information' 24720 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1216 nil 27 1234 1744 81 1328 369 1344 249 1360 59 410 ##(UI.StaticText) 34 16 nil 21792 34 2 8 1140850944 1 25056 nil nil nil 5 nil nil nil 25056 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 979 99 25056 994 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 25056 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -107 1344 149 1360 99 410 ##(UI.StaticText) 34 16 nil 21792 34 2 8 1140850944 1 25376 nil nil nil 5 nil nil nil 25376 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 321 578 979 69 25376 994 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 25376 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -107 1344 321 1360 69 170 192 34 8 23472 8 'stripClassGuids' 24720 8 'stripClassInfo' 23808 8 'retainInstVarNames' 21904 8 'compileExternalStructures' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 21792 994 #text: 34 1 8 'Step 5' 21792 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 22240 25056 24720 25376 23808 23472 24144 21904 24464 1216 nil 27 3698 13 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 26016 nil nil nil 5 nil nil nil 26016 706 170 176 34 14 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 26128 nil nil nil 5 nil nil nil 26128 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 269 578 189 49 26128 994 #text: 34 1 8 'E&xecutable name:' 26128 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1216 nil 27 1234 1744 81 1328 189 1344 269 1360 49 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 26448 nil nil nil 5 nil nil nil 26448 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 641 578 979 59 26448 994 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 26448 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -107 1344 641 1360 59 410 ##(UI.ContainerView) 34 15 nil 26016 34 2 8 1140850688 131073 26768 nil 848 nil 5 nil nil nil 26768 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 26768 34 2 8 1140850944 1 26848 3906 nil false 5058 5090 #= 8 #() 5090 #hash 5152 5170 nil true 5216 8 'Resources\LagoonLogo.bmp' 5264 5298 nil nil 578 321 327 578 8467 8627 5360 nil 5 nil nil nil 26848 nil 8 4294902547 3986 nil nil nil 26992 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 26848 994 #text: 34 1 8 'Graphic' 26848 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 26768 34 2 8 1140855108 1 27312 nil 848 nil 5 nil nil nil 27312 nil 8 1446852960 3986 nil nil 41 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 27312 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Final Step:\par
\f1\fs16\par
Deployment\b0\par
\par
\par
\par
}
' 27312 994 #textLimit: 8 #(1073741823) 27312 994 #resetCharFormat 6000 27312 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 6000 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 26768 994 #text: 34 1 8 'Heading' 26768 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 27312 26848 1216 nil 27 1234 1744 1 2144 1 1344 1 1360 121 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 28000 nil nil nil 5 nil nil nil 28000 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 161 578 989 81 28000 994 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 28000 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -97 1344 161 1360 81 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 28320 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 19680 nil 28320 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 529 578 949 81 28320 994 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 28320 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -137 1344 529 1360 81 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850944 1 28688 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 19680 nil 28688 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 349 578 989 139 28688 994 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 28688 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -97 1344 349 1360 139 410 ##(UI.StaticText) 34 16 nil 26016 34 2 8 1140850955 262145 29056 nil nil nil 5 nil nil nil 29056 nil 8 1801195232 3986 nil nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 281 269 578 737 41 29056 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1216 nil 27 1234 1744 281 2144 -97 1344 269 1360 41 170 192 34 2 29056 8 'executablePath2' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 26016 994 #text: 34 1 8 'Final step' 26016 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 26768 28000 26128 29056 28320 28688 26448 1216 nil 27 3698 15 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 29600 nil 848 nil 7 nil nil nil 29600 706 170 176 34 8 410 ##(UI.RichTextEdit) 34 18 nil 29600 34 2 8 1140855110 1 29712 nil 848 nil 7 461638 4 ##(UI.Menu) nil true 34 10 1180742 2 ##(UI.CommandMenuItem) 1 882 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 29826 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29826 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29826 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29826 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29890 4097 29778 nil true 34 3 29826 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29826 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29826 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29890 4097 29826 1 882 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29712 nil 8 1446852960 3986 nil nil 43 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 5 994 #createAt:extent: 34 2 578 419 1 578 649 489 29712 994 #contextMenu: 34 1 29792 29712 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}}
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
' 29712 994 #textLimit: 8 #(1073741823) 29712 994 #resetCharFormat 6000 29712 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1216 nil 27 1234 1744 419 2144 -47 1344 1 1360 489 410 ##(UI.ImageView) 34 21 nil 29600 34 2 8 1140850944 1 30784 3906 nil false 5058 5090 #= 8 #() 5090 #hash 5152 5170 nil true 5216 8 'Resources\LagoonSideBar.jpg' 5264 5298 nil nil 578 381 761 578 10055 20109 848 nil 7 nil nil nil 30784 nil 8 4294902547 3986 nil nil nil 30928 #centered 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 379 741 30784 994 #text: 34 1 8 'Lagoon Graphic' 30784 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1216 nil 27 1234 1744 1 1328 379 1344 1 1360 741 410 ##(UI.RichTextEdit) 34 18 nil 29600 34 2 8 1140855110 1 31264 nil 848 nil 7 29778 nil true 34 10 29826 1 882 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 29890 4097 29826 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29826 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29826 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29826 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29890 4097 29778 nil true 34 3 29826 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29826 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29826 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29890 4097 29826 1 882 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 31264 nil 8 1446852960 3986 nil nil 43 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 5 994 #createAt:extent: 34 2 578 419 681 578 549 49 31264 994 #contextMenu: 34 1 31328 31264 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click \b Next \b0 to continue.\par
\par
\par
\pard\qc\par
}
' 31264 994 #textLimit: 8 #(1073741823) 31264 994 #resetCharFormat 6000 31264 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1216 nil 27 1234 1744 419 1328 549 1344 681 1360 49 410 ##(UI.TextEdit) 34 16 nil 29600 34 2 8 1140850816 262145 32288 nil 834 #whiteSmoke nil 7 nil nil nil 32288 nil 8 1801338832 3986 nil nil 35 930 138 144 34 1 994 #createAt:extent: 34 2 578 421 491 578 645 41 32288 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1216 nil 27 1234 1744 421 2144 -49 13568 3 1360 41 170 192 34 2 32288 8 'executablePath1' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 29600 994 #text: 34 1 8 'Intro' 29600 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 30784 29712 32288 31264 1216 nil 27 3698 17 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 32848 nil nil nil 5 nil nil nil 32848 706 170 176 34 8 410 ##(UI.StaticText) 34 16 nil 32848 34 2 8 1140850944 1 32960 nil nil nil 5 nil nil nil 32960 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 229 578 979 149 32960 994 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 32960 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -107 1344 229 1360 149 410 ##(UI.ContainerView) 34 15 nil 32848 34 2 8 1140850688 131073 33280 nil 848 nil 5 nil nil nil 33280 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 33280 34 2 8 1140850944 1 33360 3906 nil false 5058 5090 #= 8 #() 5090 #hash 5152 5170 nil true 5216 8 'Resources\LagoonLogo.bmp' 5264 5298 nil nil 578 321 327 578 8467 8627 5360 nil 5 nil nil nil 33360 nil 8 4294902547 3986 nil nil nil 33504 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 33360 994 #text: 34 1 8 'Graphic' 33360 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 33280 34 2 8 1140855108 1 33824 nil 848 nil 5 nil nil nil 33824 nil 8 1446852960 3986 nil nil 41 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 33824 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 1:\f1\fs16\par
\par
Choose an ImageStripper to perform the deployment process\b0\par
\par
\par
\par
}
' 33824 994 #textLimit: 8 #(1073741823) 33824 994 #resetCharFormat 6000 33824 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 6000 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 33280 994 #text: 34 1 8 'Heading' 33280 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 33824 33360 1216 nil 27 1234 1744 1 2144 1 1344 1 1360 121 410 ##(UI.ComboBox) 34 17 nil 32848 34 2 8 1144063491 1025 34512 7714 138 144 6000 nil 7776 848 nil 5 nil nil nil 34512 nil 8 1801138208 ##(UI.BasicListAbstract) 7808 401 930 138 144 34 1 994 #createAt:extent: 34 2 578 349 409 578 647 43 34512 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1216 nil 27 1234 1744 349 2144 -119 1344 409 1360 41 410 ##(UI.StaticText) 34 16 nil 32848 34 2 8 1140850944 1 34800 nil nil nil 5 nil nil nil 34800 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 401 578 249 121 34800 994 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 34800 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1216 nil 27 1234 1744 81 1328 249 1344 401 1360 121 170 192 34 2 34512 8 'imageStripperClass' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 32848 994 #text: 34 1 8 'Step 1' 32848 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 33280 32960 34800 34512 1216 nil 27 3698 19 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 35392 nil nil nil 5 nil nil nil 35392 706 170 176 34 14 410 ##(UI.CheckBox) 34 16 nil 35392 34 2 8 1140924451 1 35504 3906 nil nil 3952 true nil nil 5 nil nil nil 35504 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 71 511 578 379 41 35504 994 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 35504 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1216 nil 27 1234 1744 71 1328 379 1344 511 1360 41 410 ##(UI.GroupBox) 34 14 nil 35392 34 2 8 1140850695 65 35840 nil 848 nil 5 nil nil nil 35840 nil 8 1801347024 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 327 578 1115 393 35840 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1216 nil 27 1234 1744 1 2144 1 1344 327 1360 393 410 ##(UI.ContainerView) 34 15 nil 35392 34 2 8 1140850688 131073 36096 nil 848 nil 5 nil nil nil 36096 610 19 1 nil nil 410 ##(UI.ImageView) 34 21 nil 36096 34 2 8 1140850944 1 36176 3906 nil false 5058 5090 #= 8 #() 5090 #hash 5152 5170 nil true 5216 8 'Resources\LagoonLogo.bmp' 5264 5298 nil nil 578 321 327 578 8467 8627 5360 nil 5 nil nil nil 36176 nil 8 4294902547 3986 nil nil nil 36320 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 36176 994 #text: 34 1 8 'Graphic' 36176 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1216 nil 27 nil 410 ##(UI.RichTextEdit) 34 18 nil 36096 34 2 8 1140855108 1 36640 nil 848 nil 5 nil nil nil 36640 nil 8 1446852960 3986 nil nil 41 nil 5714 8 #[0 0 0 0 0 0 0 0 176 0 54 7] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 36640 994 #text: 34 1 5906 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 6:\f1\fs16\par
\par
Miscellaneous stripping options\b0\par
\par
\par
\par
}
' 36640 994 #textLimit: 8 #(1073741823) 36640 994 #resetCharFormat 6000 36640 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1216 nil 27 170 192 6000 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 36096 994 #text: 34 1 8 'Heading' 36096 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 36640 36176 1216 nil 27 1234 1744 1 2144 1 1344 1 1360 121 410 ##(UI.CheckBox) 34 16 nil 35392 34 2 8 1140924451 1 37328 3906 nil nil 3952 true nil nil 5 nil nil nil 37328 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 71 451 578 379 49 37328 994 #text: 34 1 8 'Fold duplicate s&trings' 37328 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1216 nil 27 1234 1744 71 1328 379 1344 451 1360 49 410 ##(UI.StaticText) 34 16 nil 35392 34 2 8 1140850944 1 37664 nil nil nil 5 nil nil nil 37664 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 161 578 989 49 37664 994 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 37664 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1216 nil 27 1234 1744 29 2144 -97 1344 161 1360 49 410 ##(UI.CheckBox) 34 16 nil 35392 34 2 8 1140924451 1 37984 3906 nil nil 3952 false nil nil 5 nil nil nil 37984 nil 8 1801347024 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 209 578 369 41 37984 994 #text: 34 1 8 'Remove &Class Builder' 37984 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1216 nil 27 1234 1744 81 1328 369 1344 209 1360 41 410 ##(UI.StaticText) 34 16 nil 35392 34 2 8 1140850944 1 38320 nil nil nil 5 nil nil nil 38320 nil 8 1801195232 3986 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 391 578 967 49 38320 994 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 38320 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1216 nil 27 1234 1744 31 2144 -117 1344 391 1360 49 170 192 34 6 37984 8 'stripClassBuilder' 35504 8 'stripDuplicateBytecodes' 37328 8 'stripDuplicateStrings' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 35392 994 #text: 34 1 8 'Step 6' 35392 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 36096 37664 37984 38320 37328 35504 35840 1216 nil 27 29600 nil nil nil 170 192 34 2 29600 8 'Intro' nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 1 578 1119 723 3568 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 29600 32848 3728 9936 13136 21792 35392 18448 26016 1216 nil 27 170 192 34 2 3568 8 'Steps' 3298 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 918278 ##(Core.Semaphore) nil nil 1 false 8 1996777232 930 138 144 34 2 994 #createAt:extent: 34 2 578 6143 21 578 1151 881 416 994 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 62 14 0 0 194 1 0 0] 34 2 3568 640 1216 nil 27 )!

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

