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

	EnvironmentBrowserShell
		showOn: (SmalltalkSystem current systemModelFromDeploymentLog: logFileName value)!

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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 39 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 1048838 #{UI.FramingLayout} 170 176 34 12 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 768 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 768 nil 8 1815097472 1377606 4 #{UI.CommandDescription} #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 685 13 578 241 49 768 978 #isEnabled: 8 #(false) 768 978 #text: 34 1 8 '&Save Configuration' 768 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedPreviousRight 11 1250 #fixedViewLeft 241 1250 #fixedParentTop 1 1250 #fixedViewTop 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 1328 nil 848 nil 7 nil nil nil 1328 nil 8 1815097472 882 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 19 13 578 139 49 1328 978 #isEnabled: 8 #(false) 1328 978 #text: 34 1 8 '&Deploy' 1328 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #fixedParentLeft 9 1280 139 1296 1 1312 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 1696 nil 848 nil 7 nil nil nil 1696 nil 8 1815097472 882 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 357 13 578 131 49 1696 978 #isEnabled: 8 #(false) 1696 978 #text: 34 1 8 '&Next >' 1696 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1264 11 1280 131 1296 1 1312 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 2048 nil 848 nil 7 nil nil nil 2048 nil 8 1815097472 882 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 955 13 578 139 49 2048 978 #text: 34 1 8 'Cancel' 2048 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #fixedViewRight -137 1250 #fixedParentRight -11 1296 1 1312 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 2400 nil 848 nil 7 nil nil nil 2400 nil 8 1815097472 882 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 545 13 578 131 49 2400 978 #isEnabled: 8 #(false) 2400 978 #text: 34 1 8 '&Reset' 2400 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 2368 -129 2384 -429 1296 1 1312 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 2752 nil 848 nil 7 nil nil nil 2752 nil 8 1815097472 882 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 217 13 578 131 49 2752 978 #isEnabled: 8 #(false) 2752 978 #text: 34 1 8 '< &Back' 2752 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #relativeParentWidth 852486 #{Core.Fraction} 15 75 1280 131 1296 1 1312 49 170 192 34 2 1328 8 'deploy' 1180166 #{Graphics.Rectangle} 578 11 13 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 723 578 1119 81 640 978 #text: 34 1 8 'Buttons' 640 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 1328 2752 1696 2400 768 2048 1200 nil 27 nil nil 410 #{UI.WizardCardContainer} 34 15 nil 416 34 2 8 1140850688 393217 3456 nil nil nil 7 nil nil nil 3456 853318 1 #{UI.CardLayout} 138 144 34 9 1049094 #{Core.Association} 3 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 3616 nil nil nil 5 nil nil nil 3616 706 170 176 34 28 410 #{UI.TextEdit} 34 16 nil 3616 34 2 8 1140850688 262145 3728 nil nil nil 5 nil nil nil 3728 nil 8 1815092992 1049094 #{UI.NullConverter} nil nil 1 930 34 2 978 #createAt:extent: 34 2 578 441 597 578 565 41 3728 978 #isEnabled: 8 #(false) 3728 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 1680 441 2384 -109 1296 597 1312 41 410 #{UI.StaticText} 34 16 nil 3616 34 2 8 1140850944 1 4032 nil nil nil 5 nil nil nil 4032 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 37 379 578 389 81 4032 978 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 4032 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 0 0 0 189 0 0 0 212 0 0 0 229 0 0 0] 8 #() 1200 nil 27 1218 1680 37 1280 389 1296 379 1312 81 410 #{UI.PushButton} 34 20 nil 3616 34 2 8 1140924416 1 4336 nil 848 nil 5 nil nil nil 4336 nil 8 1815097472 882 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 441 661 578 139 45 4336 978 #isEnabled: 8 #(false) 4336 978 #text: 34 1 8 'S&how it' 4336 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1200 nil 29 1218 1680 441 1280 139 1296 661 1312 45 410 #{UI.GroupBox} 34 14 nil 3616 34 2 8 1140850695 65 4688 nil 848 nil 5 nil nil nil 4688 nil 8 1815097472 930 34 1 978 #createAt:extent: 34 2 578 1 279 578 1155 201 4688 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 239 0 0 0] 8 #() 1200 nil 27 1218 1680 1 2384 41 1296 279 1312 201 410 #{UI.StaticText} 34 16 nil 3616 34 2 8 1140850944 1 4928 nil nil nil 5 nil nil nil 4928 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 309 578 975 71 4928 978 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 4928 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 1200 nil 27 1218 1680 31 2384 -109 1296 309 1312 71 410 #{UI.StaticText} 34 16 nil 3616 34 2 8 1140850944 1 5232 nil nil nil 5 nil nil nil 5232 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 491 578 1057 81 5232 978 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 5232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 245 0 0 0 31 2 0 0 29 1 0 0] 8 #() 1200 nil 27 1218 1680 31 2384 -27 1296 491 1312 81 410 #{UI.ContainerView} 34 15 nil 3616 34 2 8 1140850688 131073 5536 nil 848 nil 5 nil nil nil 5536 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 5536 34 2 8 1140850944 1 5616 918598 2 #{UI.ValueHolder} nil false 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 5746 #hash 8 #() 1508102 #{Graphics.Gdiplus.Bitmap} nil true 2753286 #{Graphics.Gdiplus.BitmapFromFileInitializer} nil 8 'Resources\LagoonLogo.bmp' 2031622 #{Kernel.ImageRelativeFileLocator} 834 #face3d nil 5 nil nil nil 5616 nil 8 4294902547 3810 nil nil nil 5840 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 5616 978 #text: 34 1 8 'Graphic' 5616 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 5536 34 2 8 1140855108 1 6176 nil 848 nil 5 nil nil nil 6176 nil 8 1348699616 3810 nil nil 41 nil 852230 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 6176 978 #text: 34 1 721158 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 2: \par
\fs16\par
Choose an Executable File and RuntimeSessionManager\cf0\b0\f1\par
\par
\par
\par
}
' 6176 978 #textLimit: 8 #(1073741823) 6176 978 #resetCharFormat 8 #() 6176 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6544 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 5536 978 #text: 34 1 8 'Heading' 5536 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 6176 5616 1200 nil 27 1218 1680 1 2384 1 1296 1 1312 121 410 #{UI.CheckBox} 34 16 nil 3616 34 2 8 1140924451 1 6880 5682 nil nil 1572870 #{Kernel.NeverSearchPolicy} true nil nil 5 nil nil nil 6880 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 597 578 251 41 6880 978 #text: 34 1 8 'Write &log file' 6880 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 1680 61 1280 251 1296 597 1312 41 410 #{UI.TextEdit} 34 16 nil 3616 34 2 8 1140916352 1025 7232 nil 848 nil 5 nil nil nil 7232 nil 8 1815092992 3810 nil nil 1 930 34 1 978 #createAt:extent: 34 2 578 447 151 578 559 41 7232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1200 nil 27 1218 1680 447 2384 -109 1296 151 1312 41 410 #{UI.CheckBox} 34 16 nil 3616 34 2 8 1140924451 1 7488 5682 nil nil 6976 true nil nil 5 nil nil nil 7488 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 661 578 251 41 7488 978 #text: 34 1 8 'Log &class references' 7488 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1200 nil 27 1218 1680 61 1280 251 1296 661 1312 41 410 #{UI.CheckBox} 34 16 nil 3616 34 2 8 1140924451 1 7808 5682 nil nil 6976 false nil nil 5 nil nil nil 7808 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 211 578 431 81 7808 978 #text: 34 1 8 'Create single file, "To Go" distributable.' 7808 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1200 nil 27 1218 1680 31 1280 431 1296 211 1312 81 410 #{UI.ComboBox} 34 17 nil 3616 34 2 8 1144063491 1025 8128 787270 2 #{UI.ListModel} 138 144 6544 nil 1769478 #{Kernel.IdentitySearchPolicy} 848 nil 5 nil nil nil 8128 nil 8 1814646992 5746 #displayString 6544 8 #() 401 930 34 1 978 #createAt:extent: 34 2 578 441 393 578 565 43 8128 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 196 0 0 0 246 1 0 0 217 0 0 0] 8 #() 1200 nil 27 1218 1680 441 2384 -109 1296 393 1312 43 410 #{UI.PushButton} 34 20 nil 3616 34 2 8 1140924416 1 8480 nil 848 nil 5 nil nil nil 8480 nil 8 1815097472 882 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 1025 151 578 49 41 8480 978 #isEnabled: 8 #(false) 8480 978 #text: 34 1 8 '...' 8480 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1200 nil 29 1218 2368 -47 2384 -41 1296 151 1312 41 410 #{UI.StaticText} 34 16 nil 3616 34 2 8 1140850944 1 8832 nil nil nil 5 nil nil nil 8832 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 141 578 405 81 8832 978 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 8832 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 217 0 0 0 110 0 0 0] 8 #() 1200 nil 27 1218 1680 31 1280 405 1296 141 1312 81 170 192 34 14 7808 8 'isToGo' 7488 8 'logReferencesToClasses' 7232 8 'executableName' 8128 8 'runtimeSessionManagerClass' 4336 8 'showLog' 3728 8 'logFileName' 6880 8 'writeLogFile' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 3616 978 #text: 34 1 8 'Step 2' 3616 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 5536 8832 7232 8480 7808 4928 4032 8128 5232 6880 7488 3728 4336 4688 1200 nil 27 3586 5 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 9488 nil nil nil 5 nil nil nil 9488 706 170 176 34 12 410 #{UI.StaticText} 34 16 nil 9488 34 2 8 1140850944 1 9600 nil nil nil 5 nil nil nil 9600 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 171 578 975 191 9600 978 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 9600 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1200 nil 27 1218 1680 31 2384 -109 1296 171 1312 191 410 #{UI.StaticText} 34 16 nil 9488 34 2 8 1140850944 262145 9904 nil nil nil 5 nil nil nil 9904 nil 8 1815137184 3810 nil nil nil 930 34 1 978 #createAt:extent: 34 2 578 361 389 578 647 41 9904 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1200 nil 27 1218 1680 361 2384 -107 1296 389 1312 41 410 #{UI.StaticText} 34 16 nil 9488 34 2 8 1140850944 1 10160 nil nil nil 5 nil nil nil 10160 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 389 578 201 41 10160 978 #text: 34 1 8 'Root package:' 10160 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1200 nil 27 1218 1680 81 1280 201 1296 389 1312 41 410 #{UI.StaticText} 34 16 nil 9488 34 2 8 1140850944 1 10464 nil nil nil 5 nil nil nil 10464 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 499 578 979 109 10464 978 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10464 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -107 1296 499 1312 109 410 #{UI.CheckBox} 34 16 nil 9488 34 2 8 1140924451 1 10768 5682 nil nil 6976 true nil nil 5 nil nil nil 10768 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 59 599 578 329 49 10768 978 #text: 34 1 8 'Remove redundant &packages' 10768 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 8 #() 1200 nil 27 1218 1680 59 1280 329 1296 599 1312 49 410 #{UI.ContainerView} 34 15 nil 9488 34 2 8 1140850688 131073 11088 nil 848 nil 5 nil nil nil 11088 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 11088 34 2 8 1140850944 1 11168 5682 nil false 5714 5746 #= 8 #() 5746 #hash 5808 5826 nil true 5858 nil 8 'Resources\LagoonLogo.bmp' 5920 5936 nil 5 nil nil nil 11168 nil 8 4294902547 3810 nil nil nil 11312 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 11168 978 #text: 34 1 8 'Graphic' 11168 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 11088 34 2 8 1140855108 1 11584 nil 848 nil 5 nil nil nil 11584 nil 8 1348699616 3810 nil nil 41 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 11584 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 3:\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\cf0\f1\par
\b0\par
\par
\par
}
' 11584 978 #textLimit: 8 #(1073741823) 11584 978 #resetCharFormat 6544 11584 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6544 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 11088 978 #text: 34 1 8 'Heading' 11088 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 11584 11168 1200 nil 27 1218 1680 1 2384 1 1296 1 1312 121 170 192 34 4 10768 8 'stripRedundantPackages' 9904 8 'rootPackage' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 9488 978 #text: 34 1 8 'Step 3' 9488 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 11088 9600 10160 9904 10464 10768 1200 nil 27 3586 7 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 12512 nil nil nil 5 nil nil nil 12512 706 170 176 34 24 410 #{UI.GroupBox} 34 14 nil 12512 34 2 8 1140850695 65 12624 nil 848 nil 5 nil nil nil 12624 nil 8 1815097472 930 34 1 978 #createAt:extent: 34 2 578 -17 281 578 1151 229 12624 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1200 nil 27 1218 1680 -17 2384 19 1296 281 1312 229 410 #{UI.CheckBox} 34 16 nil 12512 34 2 8 1140924451 1 12864 5682 nil nil 6976 false nil nil 5 nil nil nil 12864 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 435 578 423 49 12864 978 #text: 34 1 8 'Preserve &aspect set methods' 12864 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1200 nil 27 1218 1264 121 1280 423 1250 #fixedPreviousTop 1 1312 49 410 #{UI.StaticText} 34 16 nil 12512 34 2 8 1140850944 1 13200 nil nil nil 5 nil nil nil 13200 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 533 578 1079 49 13200 978 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 13200 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -7 1250 #fixedPreviousBottom 51 1312 49 410 #{UI.CheckBox} 34 16 nil 12512 34 2 8 1140924451 1 13520 5682 nil nil 6976 false nil nil 5 nil nil nil 13520 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 581 578 423 49 13520 978 #text: 34 1 8 'Remove #shouldNot&Implement methods' 13520 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1200 nil 27 1218 1264 121 1280 423 13184 1 1312 49 410 #{UI.ContainerView} 34 15 nil 12512 34 2 8 1140850688 131073 13840 nil 848 nil 5 nil nil nil 13840 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 13840 34 2 8 1140850944 1 13920 5682 nil false 5714 5746 #= 8 #() 5746 #hash 5808 5826 nil true 5858 nil 8 'Resources\LagoonLogo.bmp' 5920 5936 nil 5 nil nil nil 13920 nil 8 4294902547 3810 nil nil nil 14064 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 13920 978 #text: 34 1 8 'Graphic' 13920 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 13840 34 2 8 1140855108 1 14336 nil 848 nil 5 nil nil nil 14336 nil 8 1348699616 3810 nil nil 41 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 14336 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 4:\par
\fs16\par
Configure how the ImageStripper removes unwanted classes and methods\par
\cf0\b0\f1\par
\par
\par
}
' 14336 978 #textLimit: 8 #(1073741823) 14336 978 #resetCharFormat 6544 14336 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6544 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 13840 978 #text: 34 1 8 'Heading' 13840 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 14336 13920 1200 nil 27 1218 1680 1 2384 1 1296 1 1312 121 410 #{UI.StaticText} 34 16 nil 12512 34 2 8 1140850944 1 14992 nil nil nil 5 nil nil nil 14992 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 315 578 1055 121 14992 978 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 14992 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 29 2 0 0 217 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -31 13504 51 1312 121 410 #{UI.StaticText} 34 16 nil 12512 34 2 8 1140850944 1 15296 nil nil nil 5 nil nil nil 15296 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 1061 69 15296 978 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 15296 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 32 2 0 0 108 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -25 1296 149 1312 69 410 #{UI.CheckBox} 34 16 nil 12512 34 2 8 1140924451 1 15600 5682 nil nil 6976 false nil nil 5 nil nil nil 15600 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 581 578 441 49 15600 978 #text: 34 1 8 'Remove #&deprecated methods' 15600 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 1200 nil 27 1218 1680 61 1280 441 13504 1 1312 49 410 #{UI.CheckBox} 34 16 nil 12512 34 2 8 1140924451 1 15920 5682 nil nil 6976 false nil nil 5 nil nil nil 15920 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 645 578 441 49 15920 978 #text: 34 1 8 'Remove #&subclassResponsibility methods' 15920 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 1200 nil 27 1218 1680 61 1280 441 13504 17 1312 49 410 #{UI.CheckBox} 34 16 nil 12512 34 2 8 1140924451 1 16240 5682 nil nil 6976 true nil nil 5 nil nil nil 16240 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 217 578 423 49 16240 978 #text: 34 1 8 'Remove redundant &resources' 16240 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1200 nil 27 1218 1264 121 1280 423 13184 1 1312 49 410 #{UI.CheckBox} 34 16 nil 12512 34 2 8 1140924451 1 16560 5682 nil nil 6976 true nil nil 5 nil nil nil 16560 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 217 578 441 49 16560 978 #text: 34 1 8 'Remove redundant &classes' 16560 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 1200 nil 27 1218 1680 61 1280 441 13504 1 1312 49 410 #{UI.CheckBox} 34 16 nil 12512 34 2 8 1140924451 1 16880 5682 nil nil 6976 false nil nil 5 nil nil nil 16880 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 435 578 441 49 16880 978 #text: 34 1 8 'Remove redundant &methods' 16880 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 1200 nil 27 1218 1680 61 1280 441 13504 1 1312 49 170 192 34 14 15600 8 'stripDeprecatedMethods' 12864 8 'preserveAspectSetters' 16560 8 'stripRedundantClasses' 16240 8 'stripRedundantResources' 16880 8 'stripRedundantMethods' 15920 8 'stripSubclassResponsibility' 13520 8 'stripShouldNotImplement' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 12512 978 #text: 34 1 8 'Step 4' 12512 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 13840 15296 16560 16240 14992 16880 12864 13200 15600 13520 15920 12624 1200 nil 27 3586 9 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 17552 nil nil nil 5 nil nil nil 17552 706 170 176 34 12 410 #{UI.StatusBar} 34 21 nil 17552 34 2 8 1140850700 1 17664 nil nil nil 5 nil 498 nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 17664 nil 8 1814628368 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 17664 nil 8288 8288 nil 8 'preStripScriptErrors' nil nil nil 34 1 17872 1311814 1 #{UI.StatusBarNullItem} 8705 1 17664 nil nil 930 34 1 978 #createAt:extent: 34 2 578 31 595 578 1047 41 17664 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 41 1 0 0 26 2 0 0 61 1 0 0] 8 #() 1200 nil 29 1218 1680 31 2384 -37 13504 1 1312 41 410 #{UI.ContainerView} 34 15 nil 17552 34 2 8 1140850688 131073 18112 nil 848 nil 5 nil nil nil 18112 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 18112 34 2 8 1140850944 1 18192 5682 nil false 5714 5746 #= 8 #() 5746 #hash 5808 5826 nil true 5858 nil 8 'Resources\LagoonLogo.bmp' 5920 5936 nil 5 nil nil nil 18192 nil 8 4294902547 3810 nil nil nil 18336 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 18192 978 #text: 34 1 8 'Graphic' 18192 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 18112 34 2 8 1140855108 1 18608 nil 848 nil 5 nil nil nil 18608 nil 8 1348699616 3810 nil nil 41 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 18608 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 7:\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\cf0\b0\f1\par
}
' 18608 978 #textLimit: 8 #(1073741823) 18608 978 #resetCharFormat 6544 18608 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6544 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 18112 978 #text: 34 1 8 'Heading' 18112 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 18608 18192 1200 nil 27 1218 1680 1 2384 1 1296 1 1312 121 410 #{UI.StaticText} 34 16 nil 17552 34 2 8 1140850944 1 19264 nil nil nil 5 nil nil nil 19264 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 651 578 791 71 19264 978 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 19264 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1200 nil 27 1218 1680 31 1280 791 1296 651 1312 71 410 #{UI.ReferenceView} 34 14 nil 17552 34 2 8 1140850688 131073 19568 nil nil nil 5 nil nil nil 19568 1376838 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 930 34 1 978 #createAt:extent: 34 2 578 31 345 578 1045 251 19568 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 172 0 0 0 25 2 0 0 41 1 0 0] 6544 1200 nil 27 1218 1680 31 2384 -39 1296 345 1312 251 410 #{UI.PushButton} 34 20 nil 17552 34 2 8 1140924416 1 19808 nil 848 nil 5 nil nil nil 19808 nil 8 1815097472 882 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 881 661 578 211 51 19808 978 #isEnabled: 8 #(false) 19808 978 #text: 34 1 8 'Custom &Options' 19808 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1200 nil 29 1218 1680 881 1280 211 1296 661 1312 51 410 #{UI.StaticText} 34 16 nil 17552 34 2 8 1140850944 1 20160 nil nil nil 5 nil nil nil 20160 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 1059 189 20160 978 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 20160 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 31 2 0 0 168 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -27 1296 149 1312 189 170 192 34 2 19568 8 'preStripScript' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 17552 978 #text: 34 1 8 'Step 7' 17552 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 18112 20160 19568 17664 19264 19808 1200 nil 27 3586 11 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 20720 nil nil nil 5 nil nil nil 20720 706 170 176 34 18 410 #{UI.CheckBox} 34 16 nil 20720 34 2 8 1140924451 1 20832 5682 nil nil 6976 false nil nil 5 nil nil nil 20832 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 649 578 369 49 20832 978 #text: 34 1 8 'Compile E&xternal Structures' 20832 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1200 nil 27 1218 1680 81 1280 369 1296 649 1312 49 410 #{UI.StaticText} 34 16 nil 20720 34 2 8 1140850944 1 21152 nil nil nil 5 nil nil nil 21152 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 549 578 979 89 21152 978 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 21152 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -107 1296 549 1312 89 410 #{UI.StaticText} 34 16 nil 20720 34 2 8 1140850944 1 21456 nil nil nil 5 nil nil nil 21456 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 979 99 21456 978 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 21456 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -107 1296 149 1312 99 410 #{UI.CheckBox} 34 16 nil 20720 34 2 8 1140924451 1 21760 5682 nil nil 6976 false nil nil 5 nil nil nil 21760 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 389 578 369 69 21760 978 #text: 34 1 8 'Retain instance &variable names' 21760 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1200 nil 27 1218 1680 81 1280 369 1296 389 1312 69 410 #{UI.GroupBox} 34 14 nil 20720 34 2 8 1140850695 65 22080 nil 848 nil 5 nil nil nil 22080 nil 8 1815097472 930 34 1 978 #createAt:extent: 34 2 578 -17 521 578 1151 229 22080 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1200 nil 27 1218 1680 -17 2384 19 1296 521 1312 229 410 #{UI.CheckBox} 34 16 nil 20720 34 2 8 1140924451 1 22320 5682 nil nil 6976 false nil nil 5 nil nil nil 22320 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 459 578 369 41 22320 978 #text: 34 1 8 'Remove class &GUIDs' 22320 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1200 nil 27 1218 1680 81 1280 369 1296 459 1312 41 410 #{UI.ContainerView} 34 15 nil 20720 34 2 8 1140850688 131073 22640 nil 848 nil 5 nil nil nil 22640 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 22640 34 2 8 1140850944 1 22720 5682 nil false 5714 5746 #= 8 #() 5746 #hash 5808 5826 nil true 5858 nil 8 'Resources\LagoonLogo.bmp' 5920 5936 nil 5 nil nil nil 22720 nil 8 4294902547 3810 nil nil nil 22864 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 22720 978 #text: 34 1 8 'Graphic' 22720 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 22640 34 2 8 1140855108 1 23136 nil 848 nil 5 nil nil nil 23136 nil 8 1348699616 3810 nil nil 41 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 23136 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 5:\fs16\par
\par
Decide what meta-level information is required at runtime\par
\cf0\b0\f1\par
\par
\par
}
' 23136 978 #textLimit: 8 #(1073741823) 23136 978 #resetCharFormat 6544 23136 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6544 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 22640 978 #text: 34 1 8 'Heading' 22640 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 23136 22720 1200 nil 27 1218 1680 1 2384 1 1296 1 1312 121 410 #{UI.StaticText} 34 16 nil 20720 34 2 8 1140850944 1 23792 nil nil nil 5 nil nil nil 23792 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 321 578 979 69 23792 978 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 23792 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -107 1296 321 1312 69 410 #{UI.CheckBox} 34 16 nil 20720 34 2 8 1140924451 1 24096 5682 nil nil 6976 true nil nil 5 nil nil nil 24096 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 249 578 369 59 24096 978 #text: 34 1 8 'Remove class meta-&information' 24096 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1200 nil 27 1218 1680 81 1280 369 1296 249 1312 59 170 192 34 8 20832 8 'compileExternalStructures' 22320 8 'stripClassGuids' 21760 8 'retainInstVarNames' 24096 8 'stripClassInfo' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 20720 978 #text: 34 1 8 'Step 5' 20720 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 22640 21456 24096 23792 21760 22320 21152 20832 22080 1200 nil 27 3586 13 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 24720 nil nil nil 5 nil nil nil 24720 706 170 176 34 14 410 #{UI.StaticText} 34 16 nil 24720 34 2 8 1140850944 1 24832 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 nil 24832 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 529 578 949 81 24832 978 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 24832 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -137 1296 529 1312 81 410 #{UI.StaticText} 34 16 nil 24720 34 2 8 1140850944 1 25200 nil nil nil 5 nil nil nil 25200 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 161 578 989 81 25200 978 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 25200 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -97 1296 161 1312 81 410 #{UI.StaticText} 34 16 nil 24720 34 2 8 1140850955 262145 25504 nil nil nil 5 nil nil nil 25504 nil 8 1815137184 3810 nil nil nil 930 34 1 978 #createAt:extent: 34 2 578 281 269 578 737 41 25504 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1200 nil 27 1218 1680 281 2384 -97 1296 269 1312 41 410 #{UI.ContainerView} 34 15 nil 24720 34 2 8 1140850688 131073 25760 nil 848 nil 5 nil nil nil 25760 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 25760 34 2 8 1140850944 1 25840 5682 nil false 5714 5746 #= 8 #() 5746 #hash 5808 5826 nil true 5858 nil 8 'Resources\LagoonLogo.bmp' 5920 5936 nil 5 nil nil nil 25840 nil 8 4294902547 3810 nil nil nil 25984 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 25840 978 #text: 34 1 8 'Graphic' 25840 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 25760 34 2 8 1140855108 1 26256 nil 848 nil 5 nil nil nil 26256 nil 8 1348699616 3810 nil nil 41 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 26256 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Final Step:\par
\fs16\par
Deployment\par
\par
\cf0\b0\f1\par
\par
}
' 26256 978 #textLimit: 8 #(1073741823) 26256 978 #resetCharFormat 6544 26256 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6544 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 25760 978 #text: 34 1 8 'Heading' 25760 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 26256 25840 1200 nil 27 1218 1680 1 2384 1 1296 1 1312 121 410 #{UI.StaticText} 34 16 nil 24720 34 2 8 1140850944 1 26912 nil nil nil 5 nil nil nil 26912 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 349 578 989 139 26912 978 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 26912 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -97 1296 349 1312 139 410 #{UI.StaticText} 34 16 nil 24720 34 2 8 1140850944 1 27216 nil nil nil 5 nil nil nil 27216 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 641 578 979 59 27216 978 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 27216 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -107 1296 641 1312 59 410 #{UI.StaticText} 34 16 nil 24720 34 2 8 1140850944 1 27520 nil nil nil 5 nil nil nil 27520 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 269 578 189 49 27520 978 #text: 34 1 8 'E&xecutable name:' 27520 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1200 nil 27 1218 1680 81 1280 189 1296 269 1312 49 170 192 34 2 25504 8 'executablePath2' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 24720 978 #text: 34 1 8 'Final step' 24720 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 25760 25200 27520 25504 24832 26912 27216 1200 nil 27 3586 15 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 28080 nil 848 nil 7 nil nil nil 28080 706 170 176 34 8 410 #{UI.TextEdit} 34 16 nil 28080 34 2 8 1140850816 262145 28192 nil 834 #whiteSmoke nil 7 nil nil nil 28192 nil 8 1815092992 3810 nil nil 35 930 34 1 978 #createAt:extent: 34 2 578 421 491 578 645 41 28192 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1200 nil 27 1218 1680 421 2384 -49 13504 3 1312 41 410 #{UI.RichTextEdit} 34 18 nil 28080 34 2 8 1140855110 1 28464 nil 848 nil 7 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 1 882 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 28578 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 28578 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 28578 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28578 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28642 4097 28530 nil true 34 3 28578 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28578 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28578 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28642 4097 28578 1 882 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28464 nil 8 1348699616 3810 nil nil 43 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 5 978 #createAt:extent: 34 2 578 419 681 578 549 49 28464 978 #contextMenu: 34 1 28544 28464 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\f0\fs16 Otherwise click \b Next \b0 to continue\cf0\f1 .\par
\par
\par
\pard\qc\par
}
' 28464 978 #textLimit: 8 #(1073741823) 28464 978 #resetCharFormat 6544 28464 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1200 nil 27 1218 1680 419 1280 549 1296 681 1312 49 410 #{UI.RichTextEdit} 34 18 nil 28080 34 2 8 1140855110 1 29520 nil 848 nil 7 28530 nil true 34 10 28578 1 882 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 28642 4097 28578 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 28578 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 28578 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28578 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28642 4097 28530 nil true 34 3 28578 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28578 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28578 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28642 4097 28578 1 882 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29520 nil 8 1348699616 3810 nil nil 43 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 5 978 #createAt:extent: 34 2 578 419 1 578 649 489 29520 978 #contextMenu: 34 1 29584 29520 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Segoe UI;}}
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
' 29520 978 #textLimit: 8 #(1073741823) 29520 978 #resetCharFormat 6544 29520 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1200 nil 27 1218 1680 419 2384 -47 1296 1 1312 489 410 #{UI.ImageView} 34 21 nil 28080 34 2 8 1140850944 1 30528 5682 nil false 5714 5746 #= 8 #() 5746 #hash 5808 5826 nil true 5858 nil 8 'Resources\LagoonSideBar.jpg' 5920 848 nil 7 nil nil nil 30528 nil 8 4294902547 3810 nil nil nil 30672 #centered 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 379 741 30528 978 #text: 34 1 8 'Lagoon Graphic' 30528 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1200 nil 27 1218 1680 1 1280 379 1296 1 1312 741 170 192 34 2 28192 8 'executablePath1' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 28080 978 #text: 34 1 8 'Intro' 28080 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 30528 29520 28192 28464 1200 nil 27 3586 17 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 31216 nil nil nil 5 nil nil nil 31216 706 170 176 34 8 410 #{UI.ComboBox} 34 17 nil 31216 34 2 8 1144063491 1025 31328 8194 138 144 6544 nil 8256 848 nil 5 nil nil nil 31328 nil 8 1814646992 8288 8304 401 930 34 1 978 #createAt:extent: 34 2 578 349 409 578 647 43 31328 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1200 nil 27 1218 1680 349 2384 -119 1296 409 1312 41 410 #{UI.StaticText} 34 16 nil 31216 34 2 8 1140850944 1 31600 nil nil nil 5 nil nil nil 31600 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 401 578 249 121 31600 978 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 31600 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1200 nil 27 1218 1680 81 1280 249 1296 401 1312 121 410 #{UI.ContainerView} 34 15 nil 31216 34 2 8 1140850688 131073 31904 nil 848 nil 5 nil nil nil 31904 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 31904 34 2 8 1140850944 1 31984 5682 nil false 5714 5746 #= 8 #() 5746 #hash 5808 5826 nil true 5858 nil 8 'Resources\LagoonLogo.bmp' 5920 5936 nil 5 nil nil nil 31984 nil 8 4294902547 3810 nil nil nil 32128 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 31984 978 #text: 34 1 8 'Graphic' 31984 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 31904 34 2 8 1140855108 1 32400 nil 848 nil 5 nil nil nil 32400 nil 8 1348699616 3810 nil nil 41 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 32400 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 1:\cf0\f1\fs16\par
\par
\cf1\f0 Choose an ImageStripper to perform the deployment process\cf0\b0\f1\par
\par
\par
\par
}
' 32400 978 #textLimit: 8 #(1073741823) 32400 978 #resetCharFormat 6544 32400 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6544 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 31904 978 #text: 34 1 8 'Heading' 31904 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 32400 31984 1200 nil 27 1218 1680 1 2384 1 1296 1 1312 121 410 #{UI.StaticText} 34 16 nil 31216 34 2 8 1140850944 1 33056 nil nil nil 5 nil nil nil 33056 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 229 578 979 149 33056 978 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33056 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -107 1296 229 1312 149 170 192 34 2 31328 8 'imageStripperClass' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 31216 978 #text: 34 1 8 'Step 1' 31216 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 31904 33056 31600 31328 1200 nil 27 3586 19 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 33616 nil nil nil 5 nil nil nil 33616 706 170 176 34 14 410 #{UI.CheckBox} 34 16 nil 33616 34 2 8 1140924451 1 33728 5682 nil nil 6976 true nil nil 5 nil nil nil 33728 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 71 451 578 379 49 33728 978 #text: 34 1 8 'Fold duplicate s&trings' 33728 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1200 nil 27 1218 1680 71 1280 379 1296 451 1312 49 410 #{UI.StaticText} 34 16 nil 33616 34 2 8 1140850944 1 34048 nil nil nil 5 nil nil nil 34048 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 161 578 989 49 34048 978 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 34048 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1200 nil 27 1218 1680 29 2384 -97 1296 161 1312 49 410 #{UI.GroupBox} 34 14 nil 33616 34 2 8 1140850695 65 34352 nil 848 nil 5 nil nil nil 34352 nil 8 1815097472 930 34 1 978 #createAt:extent: 34 2 578 1 327 578 1115 393 34352 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1200 nil 27 1218 1680 1 2384 1 1296 327 1312 393 410 #{UI.CheckBox} 34 16 nil 33616 34 2 8 1140924451 1 34592 5682 nil nil 6976 false nil nil 5 nil nil nil 34592 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 209 578 369 41 34592 978 #text: 34 1 8 'Remove &Class Builder' 34592 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1200 nil 27 1218 1680 81 1280 369 1296 209 1312 41 410 #{UI.StaticText} 34 16 nil 33616 34 2 8 1140850944 1 34912 nil nil nil 5 nil nil nil 34912 nil 8 1815137184 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 391 578 967 49 34912 978 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 34912 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1200 nil 27 1218 1680 31 2384 -117 1296 391 1312 49 410 #{UI.CheckBox} 34 16 nil 33616 34 2 8 1140924451 1 35216 5682 nil nil 6976 true nil nil 5 nil nil nil 35216 nil 8 1815097472 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 71 511 578 379 41 35216 978 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 35216 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1200 nil 27 1218 1680 71 1280 379 1296 511 1312 41 410 #{UI.ContainerView} 34 15 nil 33616 34 2 8 1140850688 131073 35536 nil 848 nil 5 nil nil nil 35536 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 35536 34 2 8 1140850944 1 35616 5682 nil false 5714 5746 #= 8 #() 5746 #hash 5808 5826 nil true 5858 nil 8 'Resources\LagoonLogo.bmp' 5920 5936 nil 5 nil nil nil 35616 nil 8 4294902547 3810 nil nil nil 35760 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 35616 978 #text: 34 1 8 'Graphic' 35616 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 35536 34 2 8 1140855108 1 36032 nil 848 nil 5 nil nil nil 36032 nil 8 1348699616 3810 nil nil 41 nil 6274 8 #[0 0 0 0 0 0 0 0 160 0 112 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 36032 978 #text: 34 1 6450 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 6:\fs16\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 36032 978 #textLimit: 8 #(1073741823) 36032 978 #resetCharFormat 6544 36032 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6544 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 35536 978 #text: 34 1 8 'Heading' 35536 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 36032 35616 1200 nil 27 1218 1680 1 2384 1 1296 1 1312 121 170 192 34 6 35216 8 'stripDuplicateBytecodes' 33728 8 'stripDuplicateStrings' 34592 8 'stripClassBuilder' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 33616 978 #text: 34 1 8 'Step 6' 33616 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 35536 34048 34592 34912 33728 35216 34352 1200 nil 27 28080 nil nil nil 170 192 34 2 28080 8 'Intro' nil 930 34 1 978 #createAt:extent: 34 2 578 1 1 578 1119 723 3456 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 28080 31216 3616 9488 12512 20720 33616 17552 24720 1200 nil 27 170 192 34 2 3456 8 'Steps' 3202 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 918278 #{Core.Semaphore} nil nil 1 false 8 2004646672 930 34 2 978 #createAt:extent: 34 2 578 12287 21 578 1151 881 416 978 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 62 26 0 0 194 1 0 0] 34 2 3456 640 1200 nil 27)!

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

