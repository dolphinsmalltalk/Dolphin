"Filed out from Dolphin Smalltalk"!

UI.ValueDialog
	subclass: #'Tools.ApplicationDeploymentWizard'
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

	<commandQuery: #canDeploy>
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

	<acceleratorKey: 'F1'>
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
	"Browse the application content as read from the deployment log file written by a previous invocation of the receiver."

	<commandQuery: #hasExistingLog>
	SmalltalkSystem current browseDeploymentLog: logFileName value!

strip
	"Private - Strips the image according to the receiver's image stripper
	and deploys it to an executable file. The development system will exit 
	following this action"

	self class saveImageOnDeploy ifTrue: [Smalltalk developmentSystem saveImage].
	self value deploy!

validateUserInterface
	"Set the state of the receiver accordingly. This method is sent at judicious times
	in an attempt to ensure that the receiver's state is up to date. "

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
accept!commands-actions!public! !
addToCommandRoute:!commands-routing!public! !
apply!commands-actions!public! !
browseForExecutableName!commands-actions!public! !
canDeploy!public!testing! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultExtension!constants!private! !
deployApplication!commands-actions!public! !
exeFileTypes!constants!private! !
hasExistingLog!public!testing! !
hasLog!public!testing! !
help!commands-actions!public! !
model:!accessing!public! !
onExecutableNameChanged!event handling!private! !
onImageStripperClassChanged!event handling!private! !
onViewOpened!event handling!public! !
refreshContents!accessing!private! !
reset!commands-actions!public! !
sessionManagerOrShellChoices!accessing!private! !
showLog!commands-actions!public! !
strip!commands-actions!private! !
validateUserInterface!operations!public! !
!

!Tools.ApplicationDeploymentWizard class methodsFor!

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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 7 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140916224 393217 272 nil nil nil 7 nil nil nil 272 262 #{UI.FramingLayout} 550 #{Core.LookupTable} 6 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 400 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 400 nil 8 1853182784 1350 4 #{UI.CommandDescription} #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 210 217 13 210 131 49 400 610 #isEnabled: 8 #(false) 400 610 #text: 50 1 8 '< &Back' 400 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 210 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #relativeParentWidth 518 #{Core.Fraction} 15 75 882 #fixedViewLeft 131 882 #fixedParentTop 1 882 #fixedViewTop 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 992 nil 480 nil 7 nil nil nil 992 nil 8 1853182784 514 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 685 13 210 241 49 992 610 #isEnabled: 8 #(false) 992 610 #text: 50 1 8 '&Save Configuration' 992 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 832 nil 29 850 882 #fixedPreviousRight 11 944 241 960 1 976 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 1360 nil 480 nil 7 nil nil nil 1360 nil 8 1853182784 514 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 545 13 210 131 49 1360 610 #isEnabled: 8 #(false) 1360 610 #text: 50 1 8 '&Reset' 1360 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 832 nil 29 850 882 #fixedViewRight -129 882 #fixedParentRight -429 960 1 976 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 1744 nil 480 nil 7 nil nil nil 1744 nil 8 1853182784 514 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 19 13 210 139 49 1744 610 #isEnabled: 8 #(false) 1744 610 #text: 50 1 8 '&Deploy' 1744 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 832 nil 29 850 882 #fixedParentLeft 9 944 139 960 1 976 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 2112 nil 480 nil 7 nil nil nil 2112 nil 8 1853182784 514 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 357 13 210 131 49 2112 610 #isEnabled: 8 #(false) 2112 610 #text: 50 1 8 '&Next >' 2112 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 832 nil 29 850 1344 11 944 131 960 1 976 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 2464 nil 480 nil 7 nil nil nil 2464 nil 8 1853182784 514 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 955 13 210 139 49 2464 610 #text: 50 1 8 'Cancel' 2464 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 832 nil 29 850 1712 -137 1728 -11 960 1 976 49 550 #{Core.IdentityDictionary} 1 1744 8 'deploy' 518 #{Graphics.Rectangle} 210 11 13 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 723 210 1119 81 272 610 #text: 50 1 8 'Buttons' 272 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 50 6 1744 400 2112 1360 992 2464 832 nil 27 nil nil 18 #{UI.WizardCardContainer} 50 15 nil 32 50 2 8 1140850688 393217 3088 nil nil nil 7 nil nil nil 3088 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 9 518 #{Core.Association} 3 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 3248 nil nil nil 5 nil nil nil 3248 338 370 14 18 #{UI.CheckBox} 50 16 nil 3248 50 2 8 1140924451 1 3344 1094 2 #{UI.ValueHolder} nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 3344 nil 8 1853182784 518 #{UI.NullConverter} nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 211 210 431 81 3344 610 #text: 50 1 8 'Create single file, "To Go" distributable.' 3344 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 832 nil 27 850 2096 31 944 431 960 211 976 81 18 #{UI.CheckBox} 50 16 nil 3248 50 2 8 1140924451 1 3728 3410 nil nil 3456 true nil nil 5 nil nil nil 3728 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 661 210 251 41 3728 610 #text: 50 1 8 'Log &class references' 3728 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 832 nil 27 850 2096 61 944 251 960 661 976 41 18 #{UI.CheckBox} 50 16 nil 3248 50 2 8 1140924451 1 4048 3410 nil nil 3456 true nil nil 5 nil nil nil 4048 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 597 210 251 41 4048 610 #text: 50 1 8 'Write &log file' 4048 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 832 nil 27 850 2096 61 944 251 960 597 976 41 18 #{UI.ComboBox} 50 17 nil 3248 50 2 8 1144063491 1025 4368 838 2 #{UI.ListModel} 3186 0 nil 6 #{Kernel.IdentitySearchPolicy} 480 nil 5 nil nil nil 4368 nil 8 1852792128 518 #{Core.Message} #displayString 8 #() 8 #() 401 562 50 1 610 #createAt:extent: 50 2 210 441 393 210 565 43 4368 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 196 0 0 0 246 1 0 0 217 0 0 0] 8 #() 832 nil 27 850 2096 441 1728 -109 960 393 976 43 18 #{UI.ContainerView} 50 15 nil 3248 50 2 8 1140850688 131073 4752 nil 480 nil 5 nil nil nil 4752 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 4752 50 2 8 1140850944 1 4832 3410 nil false 518 #{Kernel.PluggableSearchPolicy} 4530 #= 8 #() 4530 #hash 8 #() 774 #{Graphics.Gdiplus.Bitmap} nil true 582 1 #{Graphics.Gdiplus.BitmapFromFileInitializer} 8 'Resources\LagoonLogo.bmp' 6 #{Kernel.ImageRelativeFileLocator} 466 #face3d nil 5 nil nil nil 4832 nil 8 4294902547 3490 nil nil nil 5024 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 4832 610 #text: 50 1 8 'Graphic' 4832 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 4752 50 2 8 1140855108 1 5360 nil 480 nil 5 nil nil nil 5360 nil 8 1345799024 3490 nil nil 41 #focusLost nil nil nil nil 262 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 5360 610 #text: 50 1 262 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 2: \par
\fs16\par
Choose an Executable File and RuntimeSessionManager\cf0\b0\f1\par
\par
\par
\par
}
' 5360 610 #textLimit: 8 #(1073741823) 5360 610 #resetCharFormat 8 #() 5360 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 2786 0 2834 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 4752 610 #text: 50 1 8 'Heading' 4752 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 5360 4832 832 nil 27 850 2096 1 1728 1 960 1 976 121 18 #{UI.GroupBox} 50 14 nil 3248 50 2 8 1140850695 65 6064 nil 480 nil 5 nil nil nil 6064 nil 8 1853182784 562 50 1 610 #createAt:extent: 50 2 210 1 279 210 1155 201 6064 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 239 0 0 0] 8 #() 832 nil 27 850 2096 1 1728 41 960 279 976 201 18 #{UI.PushButton} 50 20 nil 3248 50 2 8 1140924416 1 6304 nil 480 nil 5 nil nil nil 6304 nil 8 1853182784 514 #showLog 8 '&Browse Log' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 441 657 210 159 47 6304 610 #isEnabled: 8 #(false) 6304 610 #text: 50 1 8 '&Browse Log' 6304 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 72 1 0 0 43 1 0 0 95 1 0 0] 8 #() 832 nil 29 850 2096 441 944 159 960 657 976 47 18 #{UI.PushButton} 50 20 nil 3248 50 2 8 1140924416 1 6656 nil 480 nil 5 nil nil nil 6656 nil 8 1853182784 514 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 1025 151 210 49 41 6656 610 #isEnabled: 8 #(false) 6656 610 #text: 50 1 8 '...' 6656 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 832 nil 29 850 1712 -47 1728 -41 960 151 976 41 18 #{UI.StaticText} 50 16 nil 3248 50 2 8 1140850944 1 7008 nil nil nil 5 nil nil nil 7008 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 309 210 975 71 7008 610 #text: 50 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 7008 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 832 nil 27 850 2096 31 1728 -109 960 309 976 71 18 #{UI.StaticText} 50 16 nil 3248 50 2 8 1140850944 1 7312 nil nil nil 5 nil nil nil 7312 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 141 210 405 81 7312 610 #text: 50 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 7312 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 217 0 0 0 110 0 0 0] 8 #() 832 nil 27 850 2096 31 944 405 960 141 976 81 18 #{UI.StaticText} 50 16 nil 3248 50 2 8 1140850944 1 7616 nil nil nil 5 nil nil nil 7616 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 37 379 210 389 81 7616 610 #text: 50 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 7616 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 0 0 0 189 0 0 0 212 0 0 0 229 0 0 0] 8 #() 832 nil 27 850 2096 37 944 389 960 379 976 81 18 #{UI.StaticText} 50 16 nil 3248 50 2 8 1140850944 1 7920 nil nil nil 5 nil nil nil 7920 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 491 210 1057 81 7920 610 #text: 50 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 7920 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 245 0 0 0 31 2 0 0 29 1 0 0] 8 #() 832 nil 27 850 2096 31 1728 -27 960 491 976 81 18 #{UI.TextEdit} 50 20 nil 3248 50 2 8 1140850688 262145 8224 nil nil nil 5 nil nil nil 8224 nil 8 1853175488 3490 nil nil 1 #focusLost nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 441 597 210 565 41 8224 610 #isEnabled: 8 #(false) 8224 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 832 nil 45 850 2096 441 1728 -109 960 597 976 41 18 #{UI.TextEdit} 50 20 nil 3248 50 2 8 1140916352 1025 8512 nil 480 nil 5 nil nil nil 8512 nil 8 1853175488 3490 nil nil 1 #focusLost nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 447 151 210 559 41 8512 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 832 nil 45 850 2096 447 1728 -109 960 151 976 41 2786 7 3344 8 'isToGo' 3728 8 'logReferencesToClasses' 4048 8 'writeLogFile' 4368 8 'runtimeSessionManagerClass' 6304 8 'showLog' 8224 8 'logFileName' 8512 8 'executableName' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 3248 610 #text: 50 1 8 'Step 2' 3248 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 14 4752 7312 8512 6656 3344 7008 7616 4368 7920 4048 3728 8224 6304 6064 832 nil 27 3218 5 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 9104 nil nil nil 5 nil nil nil 9104 338 370 6 18 #{UI.CheckBox} 50 16 nil 9104 50 2 8 1140924451 1 9200 3410 nil nil 3456 true nil nil 5 nil nil nil 9200 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 59 599 210 329 59 9200 610 #text: 50 1 8 'Remove redundant &packages' 9200 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 72 1 0 0] 8 #() 832 nil 27 850 2096 59 944 329 960 599 976 59 18 #{UI.ContainerView} 50 15 nil 9104 50 2 8 1140850688 131073 9520 nil 480 nil 5 nil nil nil 9520 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 9520 50 2 8 1140850944 1 9600 3410 nil false 4914 4530 #= 8 #() 4530 #hash 4992 5010 nil true 5042 8 'Resources\LagoonLogo.bmp' 5104 5120 nil 5 nil nil nil 9600 nil 8 4294902547 3490 nil nil nil 9744 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 9600 610 #text: 50 1 8 'Graphic' 9600 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 9520 50 2 8 1140855108 1 10016 nil 480 nil 5 nil nil nil 10016 nil 8 1345799024 3490 nil nil 41 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 10016 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 3:\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\cf0\f1\par
\b0\par
\par
\par
}
' 10016 610 #textLimit: 8 #(1073741823) 10016 610 #resetCharFormat 5728 10016 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 2786 0 2834 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 9520 610 #text: 50 1 8 'Heading' 9520 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 10016 9600 832 nil 27 850 2096 1 1728 1 960 1 976 121 18 #{UI.StaticText} 50 16 nil 9104 50 2 8 1140850944 1 10672 nil nil nil 5 nil nil nil 10672 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 171 210 975 191 10672 610 #text: 50 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 10672 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 832 nil 27 850 2096 31 1728 -109 960 171 976 191 18 #{UI.StaticText} 50 16 nil 9104 50 2 8 1140850944 1 10976 nil nil nil 5 nil nil nil 10976 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 499 210 979 109 10976 610 #text: 50 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10976 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 832 nil 27 850 2096 29 1728 -107 960 499 976 109 18 #{UI.StaticText} 50 16 nil 9104 50 2 8 1140850944 262145 11280 nil nil nil 5 nil nil nil 11280 nil 8 1853387904 3490 nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 361 389 210 647 41 11280 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 832 nil 27 850 2096 361 1728 -107 960 389 976 41 18 #{UI.StaticText} 50 16 nil 9104 50 2 8 1140850944 1 11536 nil nil nil 5 nil nil nil 11536 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 389 210 201 41 11536 610 #text: 50 1 8 'Root package:' 11536 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 832 nil 27 850 2096 81 944 201 960 389 976 41 2786 2 9200 8 'stripRedundantPackages' 11280 8 'rootPackage' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 9104 610 #text: 50 1 8 'Step 3' 9104 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 6 9520 10672 11536 11280 10976 9200 832 nil 27 3218 7 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 12096 nil nil nil 5 nil nil nil 12096 338 370 12 18 #{UI.CheckBox} 50 16 nil 12096 50 2 8 1140924451 1 12192 3410 nil nil 3456 false nil nil 5 nil nil nil 12192 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 621 435 210 423 49 12192 610 #text: 50 1 8 'Preserve &aspect set methods' 12192 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 832 nil 27 850 1344 121 944 423 882 #fixedPreviousTop 1 976 49 18 #{UI.CheckBox} 50 16 nil 12096 50 2 8 1140924451 1 12528 3410 nil nil 3456 false nil nil 5 nil nil nil 12528 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 621 581 210 423 49 12528 610 #text: 50 1 8 'Remove #shouldNot&Implement methods' 12528 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 832 nil 27 850 1344 121 944 423 12512 1 976 49 18 #{UI.CheckBox} 50 16 nil 12096 50 2 8 1140924451 1 12848 3410 nil nil 3456 true nil nil 5 nil nil nil 12848 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 217 210 441 49 12848 610 #text: 50 1 8 'Remove redundant &classes' 12848 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 832 nil 27 850 2096 61 944 441 882 #fixedPreviousBottom 1 976 49 18 #{UI.CheckBox} 50 16 nil 12096 50 2 8 1140924451 1 13184 3410 nil nil 3456 false nil nil 5 nil nil nil 13184 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 581 210 441 49 13184 610 #text: 50 1 8 'Remove #&deprecated methods' 13184 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 832 nil 27 850 2096 61 944 441 13168 1 976 49 18 #{UI.CheckBox} 50 16 nil 12096 50 2 8 1140924451 1 13504 3410 nil nil 3456 false nil nil 5 nil nil nil 13504 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 645 210 441 49 13504 610 #text: 50 1 8 'Remove #&subclassResponsibility methods' 13504 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 832 nil 27 850 2096 61 944 441 13168 17 976 49 18 #{UI.CheckBox} 50 16 nil 12096 50 2 8 1140924451 1 13824 3410 nil nil 3456 true nil nil 5 nil nil nil 13824 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 621 217 210 423 49 13824 610 #text: 50 1 8 'Remove redundant &resources' 13824 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 832 nil 27 850 1344 121 944 423 12512 1 976 49 18 #{UI.CheckBox} 50 16 nil 12096 50 2 8 1140924451 1 14144 3410 nil nil 3456 false nil nil 5 nil nil nil 14144 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 435 210 441 49 14144 610 #text: 50 1 8 'Remove redundant &methods' 14144 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 832 nil 27 850 2096 61 944 441 13168 1 976 49 18 #{UI.ContainerView} 50 15 nil 12096 50 2 8 1140850688 131073 14464 nil 480 nil 5 nil nil nil 14464 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 14464 50 2 8 1140850944 1 14544 3410 nil false 4914 4530 #= 8 #() 4530 #hash 4992 5010 nil true 5042 8 'Resources\LagoonLogo.bmp' 5104 5120 nil 5 nil nil nil 14544 nil 8 4294902547 3490 nil nil nil 14688 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 14544 610 #text: 50 1 8 'Graphic' 14544 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 14464 50 2 8 1140855108 1 14960 nil 480 nil 5 nil nil nil 14960 nil 8 1345799024 3490 nil nil 41 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 14960 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 4:\par
\fs16\par
Configure how the ImageStripper removes unwanted classes and methods\par
\cf0\b0\f1\par
\par
\par
}
' 14960 610 #textLimit: 8 #(1073741823) 14960 610 #resetCharFormat 5728 14960 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 2786 0 2834 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 14464 610 #text: 50 1 8 'Heading' 14464 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 14960 14544 832 nil 27 850 2096 1 1728 1 960 1 976 121 18 #{UI.GroupBox} 50 14 nil 12096 50 2 8 1140850695 65 15616 nil 480 nil 5 nil nil nil 15616 nil 8 1853182784 562 50 1 610 #createAt:extent: 50 2 210 -17 281 210 1151 229 15616 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 832 nil 27 850 2096 -17 1728 19 960 281 976 229 18 #{UI.StaticText} 50 16 nil 12096 50 2 8 1140850944 1 15856 nil nil nil 5 nil nil nil 15856 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 149 210 1061 69 15856 610 #text: 50 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 15856 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 32 2 0 0 108 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -25 960 149 976 69 18 #{UI.StaticText} 50 16 nil 12096 50 2 8 1140850944 1 16160 nil nil nil 5 nil nil nil 16160 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 315 210 1055 121 16160 610 #text: 50 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 16160 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 29 2 0 0 217 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -31 13168 51 976 121 18 #{UI.StaticText} 50 16 nil 12096 50 2 8 1140850944 1 16464 nil nil nil 5 nil nil nil 16464 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 533 210 1079 49 16464 610 #text: 50 1 8 'Some methods which may not be identified as redundant can also be removed.' 16464 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 832 nil 27 850 2096 29 1728 -7 13168 51 976 49 2786 7 12192 8 'preserveAspectSetters' 12528 8 'stripShouldNotImplement' 12848 8 'stripRedundantClasses' 13184 8 'stripDeprecatedMethods' 13504 8 'stripSubclassResponsibility' 13824 8 'stripRedundantResources' 14144 8 'stripRedundantMethods' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 12096 610 #text: 50 1 8 'Step 4' 12096 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 12 14464 15856 12848 13824 16160 14144 12192 16464 13184 12528 13504 15616 832 nil 27 3218 9 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 17104 nil nil nil 5 nil nil nil 17104 338 370 6 18 #{UI.ContainerView} 50 15 nil 17104 50 2 8 1140850688 131073 17200 nil 480 nil 5 nil nil nil 17200 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 17200 50 2 8 1140850944 1 17280 3410 nil false 4914 4530 #= 8 #() 4530 #hash 4992 5010 nil true 5042 8 'Resources\LagoonLogo.bmp' 5104 5120 nil 5 nil nil nil 17280 nil 8 4294902547 3490 nil nil nil 17424 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 17280 610 #text: 50 1 8 'Graphic' 17280 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 17200 50 2 8 1140855108 1 17696 nil 480 nil 5 nil nil nil 17696 nil 8 1345799024 3490 nil nil 41 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 17696 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 7:\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\cf0\b0\f1\par
}
' 17696 610 #textLimit: 8 #(1073741823) 17696 610 #resetCharFormat 5728 17696 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 2786 0 2834 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 17200 610 #text: 50 1 8 'Heading' 17200 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 17696 17280 832 nil 27 850 2096 1 1728 1 960 1 976 121 18 #{UI.PushButton} 50 20 nil 17104 50 2 8 1140924416 1 18352 nil 480 nil 5 nil nil nil 18352 nil 8 1853182784 514 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 881 661 210 211 51 18352 610 #isEnabled: 8 #(false) 18352 610 #text: 50 1 8 'Custom &Options' 18352 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 832 nil 29 850 2096 881 944 211 960 661 976 51 18 #{UI.ReferenceView} 50 14 nil 17104 50 2 8 1140850688 131073 18704 nil nil nil 5 nil nil nil 18704 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 562 50 1 610 #createAt:extent: 50 2 210 31 345 210 1045 251 18704 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 172 0 0 0 25 2 0 0 41 1 0 0] 5728 832 nil 27 850 2096 31 1728 -39 960 345 976 251 18 #{UI.StaticText} 50 16 nil 17104 50 2 8 1140850944 1 18944 nil nil nil 5 nil nil nil 18944 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 651 210 791 71 18944 610 #text: 50 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 18944 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 832 nil 27 850 2096 31 944 791 960 651 976 71 18 #{UI.StaticText} 50 16 nil 17104 50 2 8 1140850944 1 19248 nil nil nil 5 nil nil nil 19248 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 149 210 1059 189 19248 610 #text: 50 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 19248 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 31 2 0 0 168 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -27 960 149 976 189 18 #{UI.StatusBar} 50 21 nil 17104 50 2 8 1140850700 1 19552 nil nil nil 5 nil 130 nil true 262 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 210 193 193 nil 19552 nil 8 1852980448 2786 1 1862 1 #{UI.StatusBarItem} 8193 -1 19552 nil 4544 4544 nil 8 'preStripScriptErrors' nil nil nil 50 1 19744 1094 1 #{UI.StatusBarNullItem} 8705 1 19552 nil nil 562 50 1 610 #createAt:extent: 50 2 210 31 595 210 1047 41 19552 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 41 1 0 0 26 2 0 0 61 1 0 0] 8 #() 832 nil 29 850 2096 31 1728 -37 13168 1 976 41 2786 1 18704 8 'preStripScript' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 17104 610 #text: 50 1 8 'Step 7' 17104 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 6 17200 19248 18704 19552 18944 18352 832 nil 27 3218 11 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 20224 nil nil nil 5 nil nil nil 20224 338 370 9 18 #{UI.CheckBox} 50 16 nil 20224 50 2 8 1140924451 1 20320 3410 nil nil 3456 false nil nil 5 nil nil nil 20320 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 459 210 369 41 20320 610 #text: 50 1 8 'Remove class &GUIDs' 20320 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 832 nil 27 850 2096 81 944 369 960 459 976 41 18 #{UI.CheckBox} 50 16 nil 20224 50 2 8 1140924451 1 20640 3410 nil nil 3456 false nil nil 5 nil nil nil 20640 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 649 210 369 49 20640 610 #text: 50 1 8 'Compile E&xternal Structures' 20640 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 832 nil 27 850 2096 81 944 369 960 649 976 49 18 #{UI.CheckBox} 50 16 nil 20224 50 2 8 1140924451 1 20960 3410 nil nil 3456 false nil nil 5 nil nil nil 20960 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 389 210 369 69 20960 610 #text: 50 1 8 'Retain instance &variable names' 20960 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 832 nil 27 850 2096 81 944 369 960 389 976 69 18 #{UI.CheckBox} 50 16 nil 20224 50 2 8 1140924451 1 21280 3410 nil nil 3456 true nil nil 5 nil nil nil 21280 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 249 210 369 59 21280 610 #text: 50 1 8 'Remove class meta-&information' 21280 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 832 nil 27 850 2096 81 944 369 960 249 976 59 18 #{UI.ContainerView} 50 15 nil 20224 50 2 8 1140850688 131073 21600 nil 480 nil 5 nil nil nil 21600 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 21600 50 2 8 1140850944 1 21680 3410 nil false 4914 4530 #= 8 #() 4530 #hash 4992 5010 nil true 5042 8 'Resources\LagoonLogo.bmp' 5104 5120 nil 5 nil nil nil 21680 nil 8 4294902547 3490 nil nil nil 21824 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 21680 610 #text: 50 1 8 'Graphic' 21680 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 21600 50 2 8 1140855108 1 22096 nil 480 nil 5 nil nil nil 22096 nil 8 1345799024 3490 nil nil 41 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 22096 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 5:\fs16\par
\par
Decide what meta-level information is required at runtime\par
\cf0\b0\f1\par
\par
\par
}
' 22096 610 #textLimit: 8 #(1073741823) 22096 610 #resetCharFormat 5728 22096 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 2786 0 2834 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 21600 610 #text: 50 1 8 'Heading' 21600 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 22096 21680 832 nil 27 850 2096 1 1728 1 960 1 976 121 18 #{UI.GroupBox} 50 14 nil 20224 50 2 8 1140850695 65 22752 nil 480 nil 5 nil nil nil 22752 nil 8 1853182784 562 50 1 610 #createAt:extent: 50 2 210 -17 521 210 1151 229 22752 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 832 nil 27 850 2096 -17 1728 19 960 521 976 229 18 #{UI.StaticText} 50 16 nil 20224 50 2 8 1140850944 1 22992 nil nil nil 5 nil nil nil 22992 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 149 210 979 99 22992 610 #text: 50 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 22992 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -107 960 149 976 99 18 #{UI.StaticText} 50 16 nil 20224 50 2 8 1140850944 1 23296 nil nil nil 5 nil nil nil 23296 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 321 210 979 69 23296 610 #text: 50 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 23296 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -107 960 321 976 69 18 #{UI.StaticText} 50 16 nil 20224 50 2 8 1140850944 1 23600 nil nil nil 5 nil nil nil 23600 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 549 210 979 89 23600 610 #text: 50 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 23600 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 832 nil 27 850 2096 29 1728 -107 960 549 976 89 2786 4 20320 8 'stripClassGuids' 20640 8 'compileExternalStructures' 20960 8 'retainInstVarNames' 21280 8 'stripClassInfo' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 20224 610 #text: 50 1 8 'Step 5' 20224 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 9 21600 22992 21280 23296 20960 20320 23600 20640 22752 832 nil 27 3218 13 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 24192 nil nil nil 5 nil nil nil 24192 338 370 7 18 #{UI.ContainerView} 50 15 nil 24192 50 2 8 1140850688 131073 24288 nil 480 nil 5 nil nil nil 24288 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 24288 50 2 8 1140850944 1 24368 3410 nil false 4914 4530 #= 8 #() 4530 #hash 4992 5010 nil true 5042 8 'Resources\LagoonLogo.bmp' 5104 5120 nil 5 nil nil nil 24368 nil 8 4294902547 3490 nil nil nil 24512 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 24368 610 #text: 50 1 8 'Graphic' 24368 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 24288 50 2 8 1140855108 1 24784 nil 480 nil 5 nil nil nil 24784 nil 8 1345799024 3490 nil nil 41 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 24784 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Final Step:\par
\fs16\par
Deployment\par
\par
\cf0\b0\f1\par
\par
}
' 24784 610 #textLimit: 8 #(1073741823) 24784 610 #resetCharFormat 5728 24784 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 2786 0 2834 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 24288 610 #text: 50 1 8 'Heading' 24288 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 24784 24368 832 nil 27 850 2096 1 1728 1 960 1 976 121 18 #{UI.StaticText} 50 16 nil 24192 50 2 8 1140850944 1 25440 nil nil nil 5 nil nil nil 25440 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 349 210 989 139 25440 610 #text: 50 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 25440 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -97 960 349 976 139 18 #{UI.StaticText} 50 16 nil 24192 50 2 8 1140850944 1 25744 nil nil nil 5 nil nil nil 25744 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 641 210 979 59 25744 610 #text: 50 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 25744 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 832 nil 27 850 2096 29 1728 -107 960 641 976 59 18 #{UI.StaticText} 50 16 nil 24192 50 2 8 1140850944 1 26048 nil nil nil 5 nil 130 nil true 162 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 210 193 193 nil 26048 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 529 210 949 81 26048 610 #text: 50 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 26048 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 832 nil 27 850 2096 29 1728 -137 960 529 976 81 18 #{UI.StaticText} 50 16 nil 24192 50 2 8 1140850944 1 26416 nil nil nil 5 nil nil nil 26416 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 269 210 189 49 26416 610 #text: 50 1 8 'E&xecutable name:' 26416 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 832 nil 27 850 2096 81 944 189 960 269 976 49 18 #{UI.StaticText} 50 16 nil 24192 50 2 8 1140850944 1 26720 nil nil nil 5 nil nil nil 26720 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 161 210 989 81 26720 610 #text: 50 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 26720 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -97 960 161 976 81 18 #{UI.StaticText} 50 16 nil 24192 50 2 8 1140850955 262145 27024 nil nil nil 5 nil nil nil 27024 nil 8 1853387904 3490 nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 281 269 210 737 41 27024 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 832 nil 27 850 2096 281 1728 -97 960 269 976 41 2786 1 27024 8 'executablePath2' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 24192 610 #text: 50 1 8 'Final step' 24192 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 7 24288 26720 26416 27024 26048 25440 25744 832 nil 27 3218 15 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 27520 nil 480 nil 5 nil nil nil 27520 338 370 4 18 #{UI.RichTextEdit} 50 22 nil 27520 50 2 8 1140855110 1 27616 nil 480 nil 5 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 514 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 27730 1 514 #bePlain 8 '&Plain' 1 1 nil nil nil 27730 1 514 #toggleBold 8 '&Bold' 1 1 nil nil nil 27730 1 514 #toggleItalic 8 '&Italic' 1 1 nil nil nil 27730 1 514 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 27794 4097 27682 nil true 50 3 27730 1 514 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 27730 1 514 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 27730 1 514 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 27794 4097 27730 1 514 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 27616 nil 8 1345799024 3490 nil nil 43 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 419 681 210 549 49 27616 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\f0\fs16 Otherwise click \b Next \b0 to continue\cf0\f1 .\par
\par
\par
\pard\qc\par
}
' 27616 610 #textLimit: 8 #(1073741823) 27616 610 #resetCharFormat 5728 27616 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 832 nil 45 850 2096 419 944 549 960 681 976 49 18 #{UI.RichTextEdit} 50 22 nil 27520 50 2 8 1140855110 1 28640 nil 480 nil 5 27682 nil true 50 10 27730 1 514 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 27794 4097 27730 1 514 #bePlain 8 '&Plain' 1 1 nil nil nil 27730 1 514 #toggleBold 8 '&Bold' 1 1 nil nil nil 27730 1 514 #toggleItalic 8 '&Italic' 1 1 nil nil nil 27730 1 514 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 27794 4097 27682 nil true 50 3 27730 1 514 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 27730 1 514 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 27730 1 514 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 27794 4097 27730 1 514 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28640 nil 8 1345799024 3490 nil nil 43 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 419 1 210 649 489 28640 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Segoe UI;}}
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
' 28640 610 #textLimit: 8 #(1073741823) 28640 610 #resetCharFormat 5728 28640 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 832 nil 45 850 2096 419 1728 -47 960 1 976 489 18 #{UI.TextEdit} 50 20 nil 27520 50 2 8 1140850816 262145 29616 nil 466 #whiteSmoke nil 5 nil nil nil 29616 nil 8 1853175488 3490 nil nil 35 #focusLost nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 421 491 210 645 41 29616 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 832 nil 45 850 2096 421 1728 -49 13168 3 976 41 18 #{UI.ImageView} 50 21 nil 27520 50 2 8 1140850944 1 29888 3410 nil false 4914 4530 #= 8 #() 4530 #hash 4992 5010 nil true 5042 8 'Resources\LagoonSideBar.jpg' 5104 480 nil 5 nil nil nil 29888 nil 8 4294902547 3490 nil nil nil 30032 #centered 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 379 741 29888 610 #text: 50 1 8 'Lagoon Graphic' 29888 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 832 nil 27 850 2096 1 944 379 960 1 976 741 2786 1 29616 8 'executablePath1' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 27520 610 #text: 50 1 8 'Intro' 27520 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 4 29888 28640 29616 27616 832 nil 27 3218 17 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 30560 nil nil nil 7 nil nil nil 30560 338 370 4 18 #{UI.ComboBox} 50 17 nil 30560 50 2 8 1144063491 1025 30656 4434 3186 0 nil 4496 480 nil 7 nil nil nil 30656 nil 8 1852792128 4544 4576 401 562 50 1 610 #createAt:extent: 50 2 210 349 409 210 647 43 30656 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 832 nil 27 850 2096 349 1728 -119 960 409 976 41 18 #{UI.ContainerView} 50 15 nil 30560 50 2 8 1140850688 131073 30928 nil 480 nil 7 nil nil nil 30928 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 30928 50 2 8 1140850944 1 31008 3410 nil false 4914 4530 #= 8 #() 4530 #hash 4992 5010 nil true 5042 8 'Resources\LagoonLogo.bmp' 5104 5120 nil 7 nil nil nil 31008 nil 8 4294902547 3490 nil nil nil 31152 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 31008 610 #text: 50 1 8 'Graphic' 31008 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 30928 50 2 8 1140855108 1 31424 nil 480 nil 7 nil nil nil 31424 nil 8 1345799024 3490 nil nil 41 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 31424 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 1:\cf0\f1\fs16\par
\par
\cf1\f0 Choose an ImageStripper to perform the deployment process\cf0\b0\f1\par
\par
\par
\par
}
' 31424 610 #textLimit: 8 #(1073741823) 31424 610 #resetCharFormat 5728 31424 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 2786 0 2834 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 30928 610 #text: 50 1 8 'Heading' 30928 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 31424 31008 832 nil 27 850 2096 1 1728 1 960 1 976 121 18 #{UI.StaticText} 50 16 nil 30560 50 2 8 1140850944 1 32080 nil nil nil 7 nil nil nil 32080 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 229 210 979 149 32080 610 #text: 50 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 32080 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -107 960 229 976 149 18 #{UI.StaticText} 50 16 nil 30560 50 2 8 1140850944 1 32384 nil nil nil 7 nil nil nil 32384 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 401 210 249 121 32384 610 #text: 50 1 8 'Choose a the class of &ImageStripper to install.' 32384 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 832 nil 27 850 2096 81 944 249 960 401 976 121 2786 1 30656 8 'imageStripperClass' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 30560 610 #text: 50 1 8 'Step 1' 30560 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 4 30928 32080 32384 30656 832 nil 27 3218 19 18 #{UI.ContainerView} 50 15 nil 3088 50 2 8 1140850688 131073 32928 nil nil nil 5 nil nil nil 32928 338 370 7 18 #{UI.CheckBox} 50 16 nil 32928 50 2 8 1140924451 1 33024 3410 nil nil 3456 false nil nil 5 nil nil nil 33024 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 209 210 369 41 33024 610 #text: 50 1 8 'Remove &Class Builder' 33024 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 832 nil 27 850 2096 81 944 369 960 209 976 41 18 #{UI.CheckBox} 50 16 nil 32928 50 2 8 1140924451 1 33344 3410 nil nil 3456 true nil nil 5 nil nil nil 33344 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 71 451 210 379 49 33344 610 #text: 50 1 8 'Fold duplicate s&trings' 33344 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 832 nil 27 850 2096 71 944 379 960 451 976 49 18 #{UI.CheckBox} 50 16 nil 32928 50 2 8 1140924451 1 33664 3410 nil nil 3456 true nil nil 5 nil nil nil 33664 nil 8 1853182784 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 71 511 210 379 41 33664 610 #text: 50 1 8 'Fold duplicate b&ytecode arrays' 33664 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 832 nil 27 850 2096 71 944 379 960 511 976 41 18 #{UI.ContainerView} 50 15 nil 32928 50 2 8 1140850688 131073 33984 nil 480 nil 5 nil nil nil 33984 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 33984 50 2 8 1140850944 1 34064 3410 nil false 4914 4530 #= 8 #() 4530 #hash 4992 5010 nil true 5042 8 'Resources\LagoonLogo.bmp' 5104 5120 nil 5 nil nil nil 34064 nil 8 4294902547 3490 nil nil nil 34208 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 34064 610 #text: 50 1 8 'Graphic' 34064 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 33984 50 2 8 1140855108 1 34480 nil 480 nil 5 nil nil nil 34480 nil 8 1345799024 3490 nil nil 41 #focusLost nil nil nil nil 5458 8 #[0 0 0 0 0 0 0 0 160 0 243 5] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 34480 610 #text: 50 1 5634 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 6:\fs16\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 34480 610 #textLimit: 8 #(1073741823) 34480 610 #resetCharFormat 5728 34480 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 2786 0 2834 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 33984 610 #text: 50 1 8 'Heading' 33984 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 34480 34064 832 nil 27 850 2096 1 1728 1 960 1 976 121 18 #{UI.GroupBox} 50 14 nil 32928 50 2 8 1140850695 65 35136 nil 480 nil 5 nil nil nil 35136 nil 8 1853182784 562 50 1 610 #createAt:extent: 50 2 210 1 327 210 1115 393 35136 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 832 nil 27 850 2096 1 1728 1 960 327 976 393 18 #{UI.StaticText} 50 16 nil 32928 50 2 8 1140850944 1 35376 nil nil nil 5 nil nil nil 35376 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 161 210 989 49 35376 610 #text: 50 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 35376 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 832 nil 27 850 2096 29 1728 -97 960 161 976 49 18 #{UI.StaticText} 50 16 nil 32928 50 2 8 1140850944 1 35680 nil nil nil 5 nil nil nil 35680 nil 8 1853387904 3490 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 391 210 967 49 35680 610 #text: 50 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 35680 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 832 nil 27 850 2096 31 1728 -117 960 391 976 49 2786 3 33024 8 'stripClassBuilder' 33344 8 'stripDuplicateStrings' 33664 8 'stripDuplicateBytecodes' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 32928 610 #text: 50 1 8 'Step 6' 32928 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 7 33984 35376 33024 35680 33344 33664 35136 832 nil 27 30560 nil nil nil 2786 1 27520 8 'Intro' nil 562 50 1 610 #createAt:extent: 50 2 210 1 1 210 1119 723 3088 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 50 9 27520 30560 3248 9104 12096 20224 32928 17104 24192 832 nil 27 2786 1 3088 8 'Steps' 2834 210 1 1 210 1 1 nil nil nil nil 3 nil nil 210 2049 881 210 1151 881 1 nil nil 774 #{Core.Semaphore} nil nil 1 false 8 2011790800 562 50 2 610 #createAt:extent: 50 2 210 6143 21 210 1151 881 32 610 #text: 50 1 8 'Lagoon Deployment Wizard' 32 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 62 14 0 0 194 1 0 0] 50 2 3088 272 832 nil 27)!

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

