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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 39 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 984838 #{UI.BorderLayout} 1 1 nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 1048838 #{UI.FramingLayout} 170 176 34 12 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 768 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 768 nil 8 1825914224 1377606 4 #{UI.CommandDescription} #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 1310982 #{Core.MessageSequence} 34 3 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 357 13 578 131 49 768 978 #isEnabled: 8 #(false) 768 978 #text: 34 1 8 '&Next >' 768 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedPreviousRight 11 1250 #fixedViewLeft 131 1250 #fixedParentTop 1 1250 #fixedViewTop 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 1328 nil 848 nil 7 nil nil nil 1328 nil 8 1825914224 882 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 685 13 578 241 49 1328 978 #isEnabled: 8 #(false) 1328 978 #text: 34 1 8 '&Save Configuration' 1328 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1264 11 1280 241 1296 1 1312 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 1680 nil 848 nil 7 nil nil nil 1680 nil 8 1825914224 882 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 19 13 578 139 49 1680 978 #isEnabled: 8 #(false) 1680 978 #text: 34 1 8 '&Deploy' 1680 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #fixedParentLeft 9 1280 139 1296 1 1312 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 2048 nil 848 nil 7 nil nil nil 2048 nil 8 1825914224 882 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 545 13 578 131 49 2048 978 #isEnabled: 8 #(false) 2048 978 #text: 34 1 8 '&Reset' 2048 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #fixedViewRight -129 1250 #fixedParentRight -429 1296 1 1312 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 2432 nil 848 nil 7 nil nil nil 2432 nil 8 1825914224 882 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 217 13 578 131 49 2432 978 #isEnabled: 8 #(false) 2432 978 #text: 34 1 8 '< &Back' 2432 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 1250 #relativeParentWidth 852486 #{Core.Fraction} 15 75 1280 131 1296 1 1312 49 410 #{UI.PushButton} 34 20 nil 640 34 2 8 1140924416 1 2832 nil 848 nil 7 nil nil nil 2832 nil 8 1825914224 882 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 955 13 578 139 49 2832 978 #text: 34 1 8 'Cancel' 2832 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1200 nil 29 1218 2400 -137 2416 -11 1296 1 1312 49 170 192 34 2 1680 8 'deploy' 1180166 #{Graphics.Rectangle} 578 11 13 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 723 578 1119 81 640 978 #text: 34 1 8 'Buttons' 640 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 1680 2432 768 2048 1328 2832 1200 nil 27 nil nil 410 #{UI.WizardCardContainer} 34 15 nil 416 34 2 8 1140850688 393217 3456 nil nil nil 7 nil nil nil 3456 853318 1 #{UI.CardLayout} 138 144 34 9 1049094 #{Core.Association} 3 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 3616 nil nil nil 5 nil nil nil 3616 706 170 176 34 28 410 #{UI.StaticText} 34 16 nil 3616 34 2 8 1140850944 1 3728 nil nil nil 5 nil nil nil 3728 nil 8 1826118832 1049094 #{UI.NullConverter} nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 37 379 578 389 81 3728 978 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 3728 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 0 0 0 189 0 0 0 212 0 0 0 229 0 0 0] 8 #() 1200 nil 27 1218 2032 37 1280 389 1296 379 1312 81 410 #{UI.CheckBox} 34 16 nil 3616 34 2 8 1140924451 1 4048 918598 2 #{UI.ValueHolder} nil nil 1572870 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 4048 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 211 578 431 81 4048 978 #text: 34 1 8 'Create single file, "To Go" distributable.' 4048 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1200 nil 27 1218 2032 31 1280 431 1296 211 1312 81 410 #{UI.TextEdit} 34 16 nil 3616 34 2 8 1140916352 1025 4416 nil 848 nil 5 nil nil nil 4416 nil 8 1825906928 3810 nil nil 1 930 34 1 978 #createAt:extent: 34 2 578 447 151 578 559 41 4416 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1200 nil 27 1218 2032 447 2416 -109 1296 151 1312 41 410 #{UI.PushButton} 34 20 nil 3616 34 2 8 1140924416 1 4672 nil 848 nil 5 nil nil nil 4672 nil 8 1825914224 882 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 1025 151 578 49 41 4672 978 #isEnabled: 8 #(false) 4672 978 #text: 34 1 8 '...' 4672 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1200 nil 29 1218 2400 -47 2416 -41 1296 151 1312 41 410 #{UI.CheckBox} 34 16 nil 3616 34 2 8 1140924451 1 5024 4114 nil nil 4160 true nil nil 5 nil nil nil 5024 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 661 578 251 41 5024 978 #text: 34 1 8 'Log &class references' 5024 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1200 nil 27 1218 2032 61 1280 251 1296 661 1312 41 410 #{UI.ContainerView} 34 15 nil 3616 34 2 8 1140850688 131073 5344 nil 848 nil 5 nil nil nil 5344 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 5344 34 2 8 1140850944 1 5424 4114 nil false 1835526 #{Kernel.PluggableSearchPolicy} 786950 #{Core.Message} #= 8 #() 5538 #hash 8 #() 1508102 #{Graphics.Gdiplus.Bitmap} nil true 2753094 1 #{Graphics.Gdiplus.BitmapFromFileInitializer} 8 'Resources\LagoonLogo.bmp' 2031622 #{Kernel.ImageRelativeFileLocator} 834 #face3d nil 5 nil nil nil 5424 nil 8 4294902547 3810 nil nil nil 5632 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 5424 978 #text: 34 1 8 'Graphic' 5424 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 5344 34 2 8 1140855108 1 5968 nil 848 nil 5 nil nil nil 5968 nil 8 1374700400 3810 nil nil 41 nil 852230 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 5968 978 #text: 34 1 721158 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 2: \par
\fs16\par
Choose an Executable File and RuntimeSessionManager\cf0\b0\f1\par
\par
\par
\par
}
' 5968 978 #textLimit: 8 #(1073741823) 5968 978 #resetCharFormat 8 #() 5968 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6336 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 5344 978 #text: 34 1 8 'Heading' 5344 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 5968 5424 1200 nil 27 1218 2032 1 2416 1 1296 1 1312 121 410 #{UI.StaticText} 34 16 nil 3616 34 2 8 1140850944 1 6672 nil nil nil 5 nil nil nil 6672 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 491 578 1057 81 6672 978 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 6672 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 245 0 0 0 31 2 0 0 29 1 0 0] 8 #() 1200 nil 27 1218 2032 31 2416 -27 1296 491 1312 81 410 #{UI.CheckBox} 34 16 nil 3616 34 2 8 1140924451 1 6976 4114 nil nil 4160 true nil nil 5 nil nil nil 6976 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 597 578 251 41 6976 978 #text: 34 1 8 'Write &log file' 6976 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 2032 61 1280 251 1296 597 1312 41 410 #{UI.TextEdit} 34 16 nil 3616 34 2 8 1140850688 262145 7296 nil nil nil 5 nil nil nil 7296 nil 8 1825906928 3810 nil nil 1 930 34 2 978 #createAt:extent: 34 2 578 441 597 578 565 41 7296 978 #isEnabled: 8 #(false) 7296 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 2032 441 2416 -109 1296 597 1312 41 410 #{UI.ComboBox} 34 17 nil 3616 34 2 8 1144063491 1025 7584 787270 2 #{UI.ListModel} 138 144 6336 nil 1769478 #{Kernel.IdentitySearchPolicy} 848 nil 5 nil nil nil 7584 nil 8 1825523568 5538 #displayString 8 #() 8 #() 401 930 34 1 978 #createAt:extent: 34 2 578 441 393 578 565 43 7584 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 196 0 0 0 246 1 0 0 217 0 0 0] 8 #() 1200 nil 27 1218 2032 441 2416 -109 1296 393 1312 43 410 #{UI.PushButton} 34 20 nil 3616 34 2 8 1140924416 1 7952 nil 848 nil 5 nil nil nil 7952 nil 8 1825914224 882 #showLog 8 '&Browse Log' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 441 657 578 159 47 7952 978 #isEnabled: 8 #(false) 7952 978 #text: 34 1 8 '&Browse Log' 7952 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 72 1 0 0 43 1 0 0 95 1 0 0] 8 #() 1200 nil 29 1218 2032 441 1280 159 1296 657 1312 47 410 #{UI.StaticText} 34 16 nil 3616 34 2 8 1140850944 1 8304 nil nil nil 5 nil nil nil 8304 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 309 578 975 71 8304 978 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 8304 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 1200 nil 27 1218 2032 31 2416 -109 1296 309 1312 71 410 #{UI.StaticText} 34 16 nil 3616 34 2 8 1140850944 1 8608 nil nil nil 5 nil nil nil 8608 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 141 578 405 81 8608 978 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 8608 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 217 0 0 0 110 0 0 0] 8 #() 1200 nil 27 1218 2032 31 1280 405 1296 141 1312 81 410 #{UI.GroupBox} 34 14 nil 3616 34 2 8 1140850695 65 8912 nil 848 nil 5 nil nil nil 8912 nil 8 1825914224 930 34 1 978 #createAt:extent: 34 2 578 1 279 578 1155 201 8912 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 239 0 0 0] 8 #() 1200 nil 27 1218 2032 1 2416 41 1296 279 1312 201 170 192 34 14 7584 8 'runtimeSessionManagerClass' 6976 8 'writeLogFile' 7296 8 'logFileName' 4416 8 'executableName' 5024 8 'logReferencesToClasses' 4048 8 'isToGo' 7952 8 'showLog' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 3616 978 #text: 34 1 8 'Step 2' 3616 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 5344 8608 4416 4672 4048 8304 3728 7584 6672 6976 5024 7296 7952 8912 1200 nil 27 3586 5 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 9504 nil nil nil 5 nil nil nil 9504 706 170 176 34 12 410 #{UI.StaticText} 34 16 nil 9504 34 2 8 1140850944 262145 9616 nil nil nil 5 nil nil nil 9616 nil 8 1826118832 3810 nil nil nil 930 34 1 978 #createAt:extent: 34 2 578 361 389 578 647 41 9616 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1200 nil 27 1218 2032 361 2416 -107 1296 389 1312 41 410 #{UI.ContainerView} 34 15 nil 9504 34 2 8 1140850688 131073 9872 nil 848 nil 5 nil nil nil 9872 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 9872 34 2 8 1140850944 1 9952 4114 nil false 5506 5538 #= 8 #() 5538 #hash 5600 5618 nil true 5650 8 'Resources\LagoonLogo.bmp' 5712 5728 nil 5 nil nil nil 9952 nil 8 4294902547 3810 nil nil nil 10096 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 9952 978 #text: 34 1 8 'Graphic' 9952 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 9872 34 2 8 1140855108 1 10368 nil 848 nil 5 nil nil nil 10368 nil 8 1374700400 3810 nil nil 41 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 10368 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 3:\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\cf0\f1\par
\b0\par
\par
\par
}
' 10368 978 #textLimit: 8 #(1073741823) 10368 978 #resetCharFormat 6336 10368 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6336 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 9872 978 #text: 34 1 8 'Heading' 9872 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 10368 9952 1200 nil 27 1218 2032 1 2416 1 1296 1 1312 121 410 #{UI.CheckBox} 34 16 nil 9504 34 2 8 1140924451 1 11024 4114 nil nil 4160 true nil nil 5 nil nil nil 11024 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 59 599 578 329 59 11024 978 #text: 34 1 8 'Remove redundant &packages' 11024 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 72 1 0 0] 8 #() 1200 nil 27 1218 2032 59 1280 329 1296 599 1312 59 410 #{UI.StaticText} 34 16 nil 9504 34 2 8 1140850944 1 11344 nil nil nil 5 nil nil nil 11344 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 389 578 201 41 11344 978 #text: 34 1 8 'Root package:' 11344 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1200 nil 27 1218 2032 81 1280 201 1296 389 1312 41 410 #{UI.StaticText} 34 16 nil 9504 34 2 8 1140850944 1 11648 nil nil nil 5 nil nil nil 11648 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 499 578 979 109 11648 978 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 11648 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -107 1296 499 1312 109 410 #{UI.StaticText} 34 16 nil 9504 34 2 8 1140850944 1 11952 nil nil nil 5 nil nil nil 11952 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 171 578 975 191 11952 978 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 11952 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1200 nil 27 1218 2032 31 2416 -109 1296 171 1312 191 170 192 34 4 11024 8 'stripRedundantPackages' 9616 8 'rootPackage' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 9504 978 #text: 34 1 8 'Step 3' 9504 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 9872 11952 11344 9616 11648 11024 1200 nil 27 3586 7 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 12528 nil nil nil 5 nil nil nil 12528 706 170 176 34 24 410 #{UI.StaticText} 34 16 nil 12528 34 2 8 1140850944 1 12640 nil nil nil 5 nil nil nil 12640 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 533 578 1079 49 12640 978 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 12640 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -7 1250 #fixedPreviousBottom 51 1312 49 410 #{UI.CheckBox} 34 16 nil 12528 34 2 8 1140924451 1 12960 4114 nil nil 4160 false nil nil 5 nil nil nil 12960 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 581 578 441 49 12960 978 #text: 34 1 8 'Remove #&deprecated methods' 12960 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 1200 nil 27 1218 2032 61 1280 441 12944 1 1312 49 410 #{UI.CheckBox} 34 16 nil 12528 34 2 8 1140924451 1 13280 4114 nil nil 4160 false nil nil 5 nil nil nil 13280 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 581 578 423 49 13280 978 #text: 34 1 8 'Remove #shouldNot&Implement methods' 13280 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1200 nil 27 1218 1264 121 1280 423 1250 #fixedPreviousTop 1 1312 49 410 #{UI.StaticText} 34 16 nil 12528 34 2 8 1140850944 1 13616 nil nil nil 5 nil nil nil 13616 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 315 578 1055 121 13616 978 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 13616 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 29 2 0 0 217 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -31 12944 51 1312 121 410 #{UI.CheckBox} 34 16 nil 12528 34 2 8 1140924451 1 13920 4114 nil nil 4160 false nil nil 5 nil nil nil 13920 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 435 578 423 49 13920 978 #text: 34 1 8 'Preserve &aspect set methods' 13920 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1200 nil 27 1218 1264 121 1280 423 13600 1 1312 49 410 #{UI.CheckBox} 34 16 nil 12528 34 2 8 1140924451 1 14240 4114 nil nil 4160 true nil nil 5 nil nil nil 14240 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 217 578 441 49 14240 978 #text: 34 1 8 'Remove redundant &classes' 14240 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 1200 nil 27 1218 2032 61 1280 441 12944 1 1312 49 410 #{UI.GroupBox} 34 14 nil 12528 34 2 8 1140850695 65 14560 nil 848 nil 5 nil nil nil 14560 nil 8 1825914224 930 34 1 978 #createAt:extent: 34 2 578 -17 281 578 1151 229 14560 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1200 nil 27 1218 2032 -17 2416 19 1296 281 1312 229 410 #{UI.CheckBox} 34 16 nil 12528 34 2 8 1140924451 1 14800 4114 nil nil 4160 false nil nil 5 nil nil nil 14800 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 435 578 441 49 14800 978 #text: 34 1 8 'Remove redundant &methods' 14800 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 1200 nil 27 1218 2032 61 1280 441 12944 1 1312 49 410 #{UI.ContainerView} 34 15 nil 12528 34 2 8 1140850688 131073 15120 nil 848 nil 5 nil nil nil 15120 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 15120 34 2 8 1140850944 1 15200 4114 nil false 5506 5538 #= 8 #() 5538 #hash 5600 5618 nil true 5650 8 'Resources\LagoonLogo.bmp' 5712 5728 nil 5 nil nil nil 15200 nil 8 4294902547 3810 nil nil nil 15344 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 15200 978 #text: 34 1 8 'Graphic' 15200 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 15120 34 2 8 1140855108 1 15616 nil 848 nil 5 nil nil nil 15616 nil 8 1374700400 3810 nil nil 41 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 15616 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 4:\par
\fs16\par
Configure how the ImageStripper removes unwanted classes and methods\par
\cf0\b0\f1\par
\par
\par
}
' 15616 978 #textLimit: 8 #(1073741823) 15616 978 #resetCharFormat 6336 15616 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6336 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 15120 978 #text: 34 1 8 'Heading' 15120 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 15616 15200 1200 nil 27 1218 2032 1 2416 1 1296 1 1312 121 410 #{UI.CheckBox} 34 16 nil 12528 34 2 8 1140924451 1 16272 4114 nil nil 4160 true nil nil 5 nil nil nil 16272 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 621 217 578 423 49 16272 978 #text: 34 1 8 'Remove redundant &resources' 16272 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1200 nil 27 1218 1264 121 1280 423 13600 1 1312 49 410 #{UI.StaticText} 34 16 nil 12528 34 2 8 1140850944 1 16592 nil nil nil 5 nil nil nil 16592 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 1061 69 16592 978 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 16592 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 32 2 0 0 108 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -25 1296 149 1312 69 410 #{UI.CheckBox} 34 16 nil 12528 34 2 8 1140924451 1 16896 4114 nil nil 4160 false nil nil 5 nil nil nil 16896 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 61 645 578 441 49 16896 978 #text: 34 1 8 'Remove #&subclassResponsibility methods' 16896 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 1200 nil 27 1218 2032 61 1280 441 12944 17 1312 49 170 192 34 14 12960 8 'stripDeprecatedMethods' 16272 8 'stripRedundantResources' 14800 8 'stripRedundantMethods' 13920 8 'preserveAspectSetters' 14240 8 'stripRedundantClasses' 13280 8 'stripShouldNotImplement' 16896 8 'stripSubclassResponsibility' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 12528 978 #text: 34 1 8 'Step 4' 12528 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 15120 16592 14240 16272 13616 14800 13920 12640 12960 13280 16896 14560 1200 nil 27 3586 9 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 17568 nil nil nil 5 nil nil nil 17568 706 170 176 34 12 410 #{UI.PushButton} 34 20 nil 17568 34 2 8 1140924416 1 17680 nil 848 nil 5 nil nil nil 17680 nil 8 1825914224 882 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 930 34 3 978 #createAt:extent: 34 2 578 881 661 578 211 51 17680 978 #isEnabled: 8 #(false) 17680 978 #text: 34 1 8 'Custom &Options' 17680 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1200 nil 29 1218 2032 881 1280 211 1296 661 1312 51 410 #{UI.ReferenceView} 34 14 nil 17568 34 2 8 1140850688 131073 18032 nil nil nil 5 nil nil nil 18032 1376838 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 930 34 1 978 #createAt:extent: 34 2 578 31 345 578 1045 251 18032 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 172 0 0 0 25 2 0 0 41 1 0 0] 6336 1200 nil 27 1218 2032 31 2416 -39 1296 345 1312 251 410 #{UI.ContainerView} 34 15 nil 17568 34 2 8 1140850688 131073 18272 nil 848 nil 5 nil nil nil 18272 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 18272 34 2 8 1140850944 1 18352 4114 nil false 5506 5538 #= 8 #() 5538 #hash 5600 5618 nil true 5650 8 'Resources\LagoonLogo.bmp' 5712 5728 nil 5 nil nil nil 18352 nil 8 4294902547 3810 nil nil nil 18496 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 18352 978 #text: 34 1 8 'Graphic' 18352 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 18272 34 2 8 1140855108 1 18768 nil 848 nil 5 nil nil nil 18768 nil 8 1374700400 3810 nil nil 41 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 18768 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 7:\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\cf0\b0\f1\par
}
' 18768 978 #textLimit: 8 #(1073741823) 18768 978 #resetCharFormat 6336 18768 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6336 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 18272 978 #text: 34 1 8 'Heading' 18272 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 18768 18352 1200 nil 27 1218 2032 1 2416 1 1296 1 1312 121 410 #{UI.StatusBar} 34 21 nil 17568 34 2 8 1140850700 1 19424 nil nil nil 5 nil 498 nil true 655622 #{OS.LOGFONT} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 19424 nil 8 1825711872 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 19424 nil 7744 7744 nil 8 'preStripScriptErrors' nil nil nil 34 1 19632 1311814 1 #{UI.StatusBarNullItem} 8705 1 19424 nil nil 930 34 1 978 #createAt:extent: 34 2 578 31 595 578 1047 41 19424 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 41 1 0 0 26 2 0 0 61 1 0 0] 8 #() 1200 nil 29 1218 2032 31 2416 -37 12944 1 1312 41 410 #{UI.StaticText} 34 16 nil 17568 34 2 8 1140850944 1 19872 nil nil nil 5 nil nil nil 19872 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 651 578 791 71 19872 978 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 19872 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1200 nil 27 1218 2032 31 1280 791 1296 651 1312 71 410 #{UI.StaticText} 34 16 nil 17568 34 2 8 1140850944 1 20176 nil nil nil 5 nil nil nil 20176 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 1059 189 20176 978 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 20176 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 31 2 0 0 168 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -27 1296 149 1312 189 170 192 34 2 18032 8 'preStripScript' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 17568 978 #text: 34 1 8 'Step 7' 17568 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 18272 20176 18032 19424 19872 17680 1200 nil 27 3586 11 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 20736 nil nil nil 5 nil nil nil 20736 706 170 176 34 18 410 #{UI.StaticText} 34 16 nil 20736 34 2 8 1140850944 1 20848 nil nil nil 5 nil nil nil 20848 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 549 578 979 89 20848 978 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 20848 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -107 1296 549 1312 89 410 #{UI.CheckBox} 34 16 nil 20736 34 2 8 1140924451 1 21152 4114 nil nil 4160 false nil nil 5 nil nil nil 21152 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 459 578 369 41 21152 978 #text: 34 1 8 'Remove class &GUIDs' 21152 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1200 nil 27 1218 2032 81 1280 369 1296 459 1312 41 410 #{UI.StaticText} 34 16 nil 20736 34 2 8 1140850944 1 21472 nil nil nil 5 nil nil nil 21472 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 149 578 979 99 21472 978 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 21472 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -107 1296 149 1312 99 410 #{UI.GroupBox} 34 14 nil 20736 34 2 8 1140850695 65 21776 nil 848 nil 5 nil nil nil 21776 nil 8 1825914224 930 34 1 978 #createAt:extent: 34 2 578 -17 521 578 1151 229 21776 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1200 nil 27 1218 2032 -17 2416 19 1296 521 1312 229 410 #{UI.CheckBox} 34 16 nil 20736 34 2 8 1140924451 1 22016 4114 nil nil 4160 false nil nil 5 nil nil nil 22016 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 389 578 369 69 22016 978 #text: 34 1 8 'Retain instance &variable names' 22016 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1200 nil 27 1218 2032 81 1280 369 1296 389 1312 69 410 #{UI.ContainerView} 34 15 nil 20736 34 2 8 1140850688 131073 22336 nil 848 nil 5 nil nil nil 22336 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 22336 34 2 8 1140850944 1 22416 4114 nil false 5506 5538 #= 8 #() 5538 #hash 5600 5618 nil true 5650 8 'Resources\LagoonLogo.bmp' 5712 5728 nil 5 nil nil nil 22416 nil 8 4294902547 3810 nil nil nil 22560 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 22416 978 #text: 34 1 8 'Graphic' 22416 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 22336 34 2 8 1140855108 1 22832 nil 848 nil 5 nil nil nil 22832 nil 8 1374700400 3810 nil nil 41 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 22832 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 5:\fs16\par
\par
Decide what meta-level information is required at runtime\par
\cf0\b0\f1\par
\par
\par
}
' 22832 978 #textLimit: 8 #(1073741823) 22832 978 #resetCharFormat 6336 22832 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6336 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 22336 978 #text: 34 1 8 'Heading' 22336 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 22832 22416 1200 nil 27 1218 2032 1 2416 1 1296 1 1312 121 410 #{UI.CheckBox} 34 16 nil 20736 34 2 8 1140924451 1 23488 4114 nil nil 4160 true nil nil 5 nil nil nil 23488 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 249 578 369 59 23488 978 #text: 34 1 8 'Remove class meta-&information' 23488 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1200 nil 27 1218 2032 81 1280 369 1296 249 1312 59 410 #{UI.CheckBox} 34 16 nil 20736 34 2 8 1140924451 1 23808 4114 nil nil 4160 false nil nil 5 nil nil nil 23808 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 649 578 369 49 23808 978 #text: 34 1 8 'Compile E&xternal Structures' 23808 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1200 nil 27 1218 2032 81 1280 369 1296 649 1312 49 410 #{UI.StaticText} 34 16 nil 20736 34 2 8 1140850944 1 24128 nil nil nil 5 nil nil nil 24128 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 321 578 979 69 24128 978 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 24128 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -107 1296 321 1312 69 170 192 34 8 23808 8 'compileExternalStructures' 22016 8 'retainInstVarNames' 21152 8 'stripClassGuids' 23488 8 'stripClassInfo' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 20736 978 #text: 34 1 8 'Step 5' 20736 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 22336 21472 23488 24128 22016 21152 20848 23808 21776 1200 nil 27 3586 13 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 24736 nil nil nil 5 nil nil nil 24736 706 170 176 34 14 410 #{UI.StaticText} 34 16 nil 24736 34 2 8 1140850955 262145 24848 nil nil nil 5 nil nil nil 24848 nil 8 1826118832 3810 nil nil nil 930 34 1 978 #createAt:extent: 34 2 578 281 269 578 737 41 24848 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1200 nil 27 1218 2032 281 2416 -97 1296 269 1312 41 410 #{UI.StaticText} 34 16 nil 24736 34 2 8 1140850944 1 25104 nil nil nil 5 nil nil nil 25104 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 641 578 979 59 25104 978 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 25104 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -107 1296 641 1312 59 410 #{UI.StaticText} 34 16 nil 24736 34 2 8 1140850944 1 25408 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 578 193 193 nil 25408 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 529 578 949 81 25408 978 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 25408 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -137 1296 529 1312 81 410 #{UI.StaticText} 34 16 nil 24736 34 2 8 1140850944 1 25776 nil nil nil 5 nil nil nil 25776 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 161 578 989 81 25776 978 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 25776 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -97 1296 161 1312 81 410 #{UI.StaticText} 34 16 nil 24736 34 2 8 1140850944 1 26080 nil nil nil 5 nil nil nil 26080 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 269 578 189 49 26080 978 #text: 34 1 8 'E&xecutable name:' 26080 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1200 nil 27 1218 2032 81 1280 189 1296 269 1312 49 410 #{UI.ContainerView} 34 15 nil 24736 34 2 8 1140850688 131073 26384 nil 848 nil 5 nil nil nil 26384 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 26384 34 2 8 1140850944 1 26464 4114 nil false 5506 5538 #= 8 #() 5538 #hash 5600 5618 nil true 5650 8 'Resources\LagoonLogo.bmp' 5712 5728 nil 5 nil nil nil 26464 nil 8 4294902547 3810 nil nil nil 26608 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 26464 978 #text: 34 1 8 'Graphic' 26464 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 26384 34 2 8 1140855108 1 26880 nil 848 nil 5 nil nil nil 26880 nil 8 1374700400 3810 nil nil 41 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 26880 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Final Step:\par
\fs16\par
Deployment\par
\par
\cf0\b0\f1\par
\par
}
' 26880 978 #textLimit: 8 #(1073741823) 26880 978 #resetCharFormat 6336 26880 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6336 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 26384 978 #text: 34 1 8 'Heading' 26384 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 26880 26464 1200 nil 27 1218 2032 1 2416 1 1296 1 1312 121 410 #{UI.StaticText} 34 16 nil 24736 34 2 8 1140850944 1 27536 nil nil nil 5 nil nil nil 27536 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 349 578 989 139 27536 978 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 27536 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -97 1296 349 1312 139 170 192 34 2 24848 8 'executablePath2' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 24736 978 #text: 34 1 8 'Final step' 24736 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 26384 25776 26080 24848 25408 27536 25104 1200 nil 27 3586 15 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 28096 nil 848 nil 5 nil nil nil 28096 706 170 176 34 8 410 #{UI.TextEdit} 34 16 nil 28096 34 2 8 1140850816 262145 28208 nil 834 #whiteSmoke nil 5 nil nil nil 28208 nil 8 1825906928 3810 nil nil 35 930 34 1 978 #createAt:extent: 34 2 578 421 491 578 645 41 28208 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1200 nil 27 1218 2032 421 2416 -49 12944 3 1312 41 410 #{UI.RichTextEdit} 34 18 nil 28096 34 2 8 1140855110 1 28480 nil 848 nil 5 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 1 882 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 28594 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 28594 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 28594 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28594 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28658 4097 28546 nil true 34 3 28594 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28594 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28594 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28658 4097 28594 1 882 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28480 nil 8 1374700400 3810 nil nil 43 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 419 681 578 549 49 28480 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\f0\fs16 Otherwise click \b Next \b0 to continue\cf0\f1 .\par
\par
\par
\pard\qc\par
}
' 28480 978 #textLimit: 8 #(1073741823) 28480 978 #resetCharFormat 6336 28480 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1200 nil 27 1218 2032 419 1280 549 1296 681 1312 49 410 #{UI.RichTextEdit} 34 18 nil 28096 34 2 8 1140855110 1 29504 nil 848 nil 5 28546 nil true 34 10 28594 1 882 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 28658 4097 28594 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 28594 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 28594 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 28594 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 28658 4097 28546 nil true 34 3 28594 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 28594 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 28594 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 28658 4097 28594 1 882 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29504 nil 8 1374700400 3810 nil nil 43 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 419 1 578 649 489 29504 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Segoe UI;}}
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
' 29504 978 #textLimit: 8 #(1073741823) 29504 978 #resetCharFormat 6336 29504 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1200 nil 27 1218 2032 419 2416 -47 1296 1 1312 489 410 #{UI.ImageView} 34 21 nil 28096 34 2 8 1140850944 1 30480 4114 nil false 5506 5538 #= 8 #() 5538 #hash 5600 5618 nil true 5650 8 'Resources\LagoonSideBar.jpg' 5712 848 nil 5 nil nil nil 30480 nil 8 4294902547 3810 nil nil nil 30624 #centered 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 379 741 30480 978 #text: 34 1 8 'Lagoon Graphic' 30480 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1200 nil 27 1218 2032 1 1280 379 1296 1 1312 741 170 192 34 2 28208 8 'executablePath1' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 28096 978 #text: 34 1 8 'Intro' 28096 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 30480 29504 28208 28480 1200 nil 27 3586 17 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 31168 nil nil nil 7 nil nil nil 31168 706 170 176 34 8 410 #{UI.StaticText} 34 16 nil 31168 34 2 8 1140850944 1 31280 nil nil nil 7 nil nil nil 31280 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 401 578 249 121 31280 978 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 31280 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1200 nil 27 1218 2032 81 1280 249 1296 401 1312 121 410 #{UI.ContainerView} 34 15 nil 31168 34 2 8 1140850688 131073 31584 nil 848 nil 7 nil nil nil 31584 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 31584 34 2 8 1140850944 1 31664 4114 nil false 5506 5538 #= 8 #() 5538 #hash 5600 5618 nil true 5650 8 'Resources\LagoonLogo.bmp' 5712 5728 nil 7 nil nil nil 31664 nil 8 4294902547 3810 nil nil nil 31808 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 31664 978 #text: 34 1 8 'Graphic' 31664 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 31584 34 2 8 1140855108 1 32080 nil 848 nil 7 nil nil nil 32080 nil 8 1374700400 3810 nil nil 41 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 32080 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 1:\cf0\f1\fs16\par
\par
\cf1\f0 Choose an ImageStripper to perform the deployment process\cf0\b0\f1\par
\par
\par
\par
}
' 32080 978 #textLimit: 8 #(1073741823) 32080 978 #resetCharFormat 6336 32080 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6336 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 31584 978 #text: 34 1 8 'Heading' 31584 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 32080 31664 1200 nil 27 1218 2032 1 2416 1 1296 1 1312 121 410 #{UI.ComboBox} 34 17 nil 31168 34 2 8 1144063491 1025 32736 7650 138 144 6336 nil 7712 848 nil 7 nil nil nil 32736 nil 8 1825523568 7744 7776 401 930 34 1 978 #createAt:extent: 34 2 578 349 409 578 647 43 32736 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1200 nil 27 1218 2032 349 2416 -119 1296 409 1312 41 410 #{UI.StaticText} 34 16 nil 31168 34 2 8 1140850944 1 33008 nil nil nil 7 nil nil nil 33008 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 229 578 979 149 33008 978 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33008 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -107 1296 229 1312 149 170 192 34 2 32736 8 'imageStripperClass' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 31168 978 #text: 34 1 8 'Step 1' 31168 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 31584 33008 31280 32736 1200 nil 27 3586 19 410 #{UI.ContainerView} 34 15 nil 3456 34 2 8 1140850688 131073 33568 nil nil nil 5 nil nil nil 33568 706 170 176 34 14 410 #{UI.StaticText} 34 16 nil 33568 34 2 8 1140850944 1 33680 nil nil nil 5 nil nil nil 33680 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 29 161 578 989 49 33680 978 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 33680 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1200 nil 27 1218 2032 29 2416 -97 1296 161 1312 49 410 #{UI.CheckBox} 34 16 nil 33568 34 2 8 1140924451 1 33984 4114 nil nil 4160 true nil nil 5 nil nil nil 33984 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 71 511 578 379 41 33984 978 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 33984 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1200 nil 27 1218 2032 71 1280 379 1296 511 1312 41 410 #{UI.ContainerView} 34 15 nil 33568 34 2 8 1140850688 131073 34304 nil 848 nil 5 nil nil nil 34304 610 19 1 nil nil 410 #{UI.ImageView} 34 21 nil 34304 34 2 8 1140850944 1 34384 4114 nil false 5506 5538 #= 8 #() 5538 #hash 5600 5618 nil true 5650 8 'Resources\LagoonLogo.bmp' 5712 5728 nil 5 nil nil nil 34384 nil 8 4294902547 3810 nil nil nil 34528 #scale 1 nil nil 930 34 2 978 #createAt:extent: 34 2 578 1003 11 578 103 101 34384 978 #text: 34 1 8 'Graphic' 34384 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1200 nil 27 nil 410 #{UI.RichTextEdit} 34 18 nil 34304 34 2 8 1140855108 1 34800 nil 848 nil 5 nil nil nil 34800 nil 8 1374700400 3810 nil nil 41 nil 6066 8 #[0 0 0 0 0 0 0 0 80 1 162 5] 930 34 4 978 #createAt:extent: 34 2 578 31 11 578 955 101 34800 978 #text: 34 1 6242 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 6:\fs16\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 34800 978 #textLimit: 8 #(1073741823) 34800 978 #resetCharFormat 6336 34800 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1200 nil 27 170 192 6336 3202 578 31 11 578 11 11 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 121 34304 978 #text: 34 1 8 'Heading' 34304 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 34800 34384 1200 nil 27 1218 2032 1 2416 1 1296 1 1312 121 410 #{UI.CheckBox} 34 16 nil 33568 34 2 8 1140924451 1 35456 4114 nil nil 4160 true nil nil 5 nil nil nil 35456 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 71 451 578 379 49 35456 978 #text: 34 1 8 'Fold duplicate s&trings' 35456 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1200 nil 27 1218 2032 71 1280 379 1296 451 1312 49 410 #{UI.StaticText} 34 16 nil 33568 34 2 8 1140850944 1 35776 nil nil nil 5 nil nil nil 35776 nil 8 1826118832 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 31 391 578 967 49 35776 978 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 35776 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1200 nil 27 1218 2032 31 2416 -117 1296 391 1312 49 410 #{UI.GroupBox} 34 14 nil 33568 34 2 8 1140850695 65 36080 nil 848 nil 5 nil nil nil 36080 nil 8 1825914224 930 34 1 978 #createAt:extent: 34 2 578 1 327 578 1115 393 36080 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1200 nil 27 1218 2032 1 2416 1 1296 327 1312 393 410 #{UI.CheckBox} 34 16 nil 33568 34 2 8 1140924451 1 36320 4114 nil nil 4160 false nil nil 5 nil nil nil 36320 nil 8 1825914224 3810 nil nil nil 930 34 2 978 #createAt:extent: 34 2 578 81 209 578 369 41 36320 978 #text: 34 1 8 'Remove &Class Builder' 36320 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1200 nil 27 1218 2032 81 1280 369 1296 209 1312 41 170 192 34 6 35456 8 'stripDuplicateStrings' 36320 8 'stripClassBuilder' 33984 8 'stripDuplicateBytecodes' nil 930 34 2 978 #createAt:extent: 34 2 578 1 1 578 1115 719 33568 978 #text: 34 1 8 'Step 6' 33568 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 34304 33680 36320 35776 35456 33984 36080 1200 nil 27 31168 nil nil nil 170 192 34 2 28096 8 'Intro' nil 930 34 1 978 #createAt:extent: 34 2 578 1 1 578 1119 723 3456 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 28096 31168 3616 9504 12528 20736 33568 17568 24736 1200 nil 27 170 192 34 2 3456 8 'Steps' 3202 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 918278 #{Core.Semaphore} nil nil 1 false 8 2006612512 930 34 2 978 #createAt:extent: 34 2 578 6143 21 578 1151 881 416 978 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 62 14 0 0 194 1 0 0] 34 2 3456 640 1200 nil 27)!

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

