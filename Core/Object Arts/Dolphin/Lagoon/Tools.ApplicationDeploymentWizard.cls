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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140916224 393217 240 nil nil nil 5 nil nil nil 240 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 12 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 384 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 384 nil nil 1350 4 #{UI.CommandDescription} #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 193 416 8 '&Deploy' 384 578 #isEnabled: 8 #(false) 384 3 8 #() 518 #{Graphics.Point} 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 9 834 #fixedViewLeft 139 834 #fixedParentTop 1 834 #fixedViewTop 49 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 912 nil 464 nil 5 nil nil nil 912 nil nil 482 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 193 944 8 '< &Back' 912 578 #isEnabled: 8 #(false) 912 3 8 #() 770 193 193 nil 29 802 834 #relativeParentWidth 518 #{Core.Fraction} 15 75 864 131 880 1 896 49 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 1264 nil 464 nil 5 nil nil nil 1264 nil nil 482 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 193 1296 8 '&Next >' 1264 578 #isEnabled: 8 #(false) 1264 3 8 #() 770 193 193 nil 29 802 834 #fixedPreviousRight 11 864 131 880 1 896 49 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 1584 nil 464 nil 5 nil nil nil 1584 nil nil 482 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 193 1616 8 '&Reset' 1584 578 #isEnabled: 8 #(false) 1584 3 8 #() 770 193 193 nil 29 802 834 #fixedViewRight -129 834 #fixedParentRight -429 880 1 896 49 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 1920 nil 464 nil 5 nil nil nil 1920 nil nil 482 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 193 1952 8 '&Save Configuration' 1920 578 #isEnabled: 8 #(false) 1920 3 8 #() 770 193 193 nil 29 802 1568 11 864 241 880 1 896 49 18 #{UI.PushButton} 50 20 nil 240 50 2 8 1140924416 1 2224 nil 464 nil 5 nil nil nil 2224 nil nil 482 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 193 2256 8 'Cancel' 2224 3 8 #() 770 193 193 nil 29 802 1888 -137 1904 -11 880 1 896 49 338 #{Core.IdentityDictionary} 50 2 384 8 'deploy' 518 #{Graphics.Rectangle} 770 11 13 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 193 272 8 'Buttons' 240 3 50 6 384 912 1264 1584 1920 2224 770 193 193 nil 27 nil nil 18 #{UI.WizardCardContainer} 50 15 nil 32 50 2 8 1140850688 393217 2768 nil nil nil 5 nil nil nil 2768 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 9 518 #{Core.Association} 3 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 2928 nil nil nil 5 nil nil nil 2928 306 338 #{Core.LookupTable} 50 28 18 #{UI.ContainerView} 50 15 nil 2928 50 2 8 1140850688 131073 3040 nil 464 nil 5 nil nil nil 3040 210 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 3040 50 2 8 1140850944 1 3120 1094 2 #{UI.ValueHolder} nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 3250 #hash 8 #() 774 #{Graphics.Gdiplus.Image} nil true 582 1 #{Graphics.Gdiplus.ImageFromFileInitializer} 8 'Resources\LagoonLogo.bmp' 6 #{Kernel.InstallRelativeFileLocator} 450 #face3d nil 5 nil nil nil 3120 nil nil 518 #{UI.NullConverter} nil nil nil 3344 #scale 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 3152 nil 3120 578 #text: 50 1 8 'Graphic' 3120 3 8 #() 770 193 193 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 3040 50 2 8 1140855108 1 3680 nil 464 nil 5 nil nil nil 3680 nil nil 3458 nil nil 41 #focusLost nil nil nil nil 262 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 4 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 3712 nil 3680 578 #text: 50 1 262 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 2: \par
\fs16\par
Choose an Executable File and RuntimeSessionManager\cf0\b0\f1\par
\par
\par
\par
}
' 3680 578 #textLimit: 8 #(1073741823) 3680 578 #resetCharFormat 8 #() 3680 3 8 #() 770 193 193 nil 45 550 #{Core.IdentityDictionary} 0 2546 770 31 11 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 3072 8 'Heading' 3040 3 50 2 3680 3120 770 193 193 nil 27 802 848 1 1904 1 880 1 896 121 18 #{UI.StaticText} 50 16 nil 2928 50 2 8 1140850944 1 4352 nil nil nil 5 nil nil nil 4352 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 70 0 0 0 217 0 0 0 110 0 0 0] 193 4384 nil 4352 578 #text: 50 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 4352 3 8 #() 770 193 193 nil 27 802 848 31 864 405 880 141 896 81 18 #{UI.TextEdit} 50 20 nil 2928 50 2 8 1140916352 1025 4640 nil 464 nil 5 nil nil nil 4640 nil nil 3458 nil nil 1 #focusLost nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[223 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 193 4672 nil 4640 3 8 #() 770 193 193 nil 45 802 848 447 1904 -109 880 151 896 41 18 #{UI.PushButton} 50 20 nil 2928 50 2 8 1140924416 1 4880 nil 464 nil 5 nil nil nil 4880 nil nil 482 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 193 4912 8 '...' 4880 578 #isEnabled: 8 #(false) 4880 3 8 #() 770 193 193 nil 29 802 1888 -47 1904 -41 880 151 896 41 18 #{UI.CheckBox} 50 16 nil 2928 50 2 8 1140924451 1 5184 3186 nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 5184 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 105 0 0 0 235 0 0 0 145 0 0 0] 193 5216 8 'Create single file, "To Go" distributable' 5184 3 8 #() 770 193 193 nil 27 802 848 31 864 441 880 211 896 81 18 #{UI.GroupBox} 50 14 nil 2928 50 2 8 1140850695 65 5488 nil 464 nil 5 nil nil nil 5488 nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 139 0 0 0 65 2 0 0 239 0 0 0] 193 5520 8 '' 5488 3 8 #() 770 193 193 nil 27 802 848 1 1904 41 880 279 896 201 18 #{UI.StaticText} 50 16 nil 2928 50 2 8 1140850944 1 5728 nil nil nil 5 nil nil nil 5728 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 155 0 0 0 246 1 0 0 190 0 0 0] 193 5760 nil 5728 578 #text: 50 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 5728 3 8 #() 770 193 193 nil 27 802 848 31 1904 -109 880 311 896 71 18 #{UI.StaticText} 50 16 nil 2928 50 2 8 1140850944 1 6016 nil nil nil 5 nil nil nil 6016 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[18 0 0 0 189 0 0 0 212 0 0 0 229 0 0 0] 193 6048 nil 6016 578 #text: 50 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 6016 3 8 #() 770 193 193 nil 27 802 848 37 864 389 880 379 896 81 18 #{UI.ComboBox} 50 17 nil 2928 50 2 8 1144063491 1025 6304 838 2 #{UI.ListModel} 2866 0 nil 6 #{Kernel.IdentitySearchPolicy} 464 nil 5 nil nil nil 6304 nil nil 3250 #displayString 8 #() 8 #() 401 530 50 1 578 #createWindow: 50 1 626 658 8 #[220 0 0 0 196 0 0 0 246 1 0 0 155 1 0 0] 193 6336 8 '' 6304 3 8 #() 770 193 193 nil 27 802 848 441 1904 -109 880 393 896 43 18 #{UI.StaticText} 50 16 nil 2928 50 2 8 1140850944 1 6672 nil nil nil 5 nil nil nil 6672 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 245 0 0 0 31 2 0 0 29 1 0 0] 193 6704 nil 6672 578 #text: 50 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 6672 3 8 #() 770 193 193 nil 27 802 848 31 1904 -27 880 491 896 81 18 #{UI.CheckBox} 50 16 nil 2928 50 2 8 1140924451 1 6960 3186 nil nil 5280 true nil nil 5 nil nil nil 6960 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 193 6992 8 'Write &log file' 6960 3 8 #() 770 193 193 nil 27 802 848 61 864 251 880 597 896 41 18 #{UI.TextEdit} 50 20 nil 2928 50 2 8 1140850688 262145 7232 nil nil nil 5 nil nil nil 7232 nil nil 3458 nil nil 1 #focusLost nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 193 7264 nil 7232 578 #isEnabled: 8 #(false) 7232 3 8 #() 770 193 193 nil 45 802 848 441 1904 -109 880 597 896 41 18 #{UI.PushButton} 50 20 nil 2928 50 2 8 1140924416 1 7504 nil 464 nil 5 nil nil nil 7504 nil nil 482 #showLog 8 '&Browse Log' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[220 0 0 0 72 1 0 0 43 1 0 0 95 1 0 0] 193 7536 8 '&Browse Log' 7504 578 #isEnabled: 8 #(false) 7504 3 8 #() 770 193 193 nil 29 802 848 441 864 159 880 657 896 47 18 #{UI.CheckBox} 50 16 nil 2928 50 2 8 1140924451 1 7808 3186 nil nil 5280 true nil nil 5 nil nil nil 7808 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 193 7840 8 'Log &class references' 7808 3 8 #() 770 193 193 nil 27 802 848 61 864 251 880 661 896 41 338 4096 50 14 4640 8 'executableName' 5184 8 'isToGo' 7232 8 'logFileName' 7808 8 'logReferencesToClasses' 6304 8 'runtimeSessionManagerClass' 7504 8 'showLog' 6960 8 'writeLogFile' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 2960 8 'Step 2' 2928 1 50 14 3040 4352 4640 4880 5184 5728 6016 6304 6672 6960 7808 7232 7504 5488 770 193 193 nil 27 2898 5 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 8400 nil nil nil 5 nil nil nil 8400 306 338 #{Core.LookupTable} 50 12 18 #{UI.ContainerView} 50 15 nil 8400 50 2 8 1140850688 131073 8512 nil 464 nil 5 nil nil nil 8512 210 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 8512 50 2 8 1140850944 1 8592 3186 nil false 3218 3250 #= 8 #() 3250 #hash 3312 3330 nil true 3362 8 'Resources\LagoonLogo.bmp' 3424 3440 nil 5 nil nil nil 8592 nil nil 3458 nil nil nil 8736 #scale 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 8624 nil 8592 578 #text: 50 1 8 'Graphic' 8592 3 8 #() 770 193 193 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 8512 50 2 8 1140855108 1 8992 nil 464 nil 5 nil nil nil 8992 nil nil 3458 nil nil 41 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 4 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 9024 nil 8992 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 3:\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\cf0\f1\par
\b0\par
\par
\par
}
' 8992 578 #textLimit: 8 #(1073741823) 8992 578 #resetCharFormat 4048 8992 3 8 #() 770 193 193 nil 45 4098 0 2546 770 31 11 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 8544 8 'Heading' 8512 3 50 2 8992 8592 770 193 193 nil 27 802 848 1 1904 1 880 1 896 121 18 #{UI.StaticText} 50 16 nil 8400 50 2 8 1140850944 1 9600 nil nil nil 5 nil nil nil 9600 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 193 9632 nil 9600 578 #text: 50 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 9600 3 8 #() 770 193 193 nil 27 802 848 31 1904 -109 880 171 896 191 18 #{UI.StaticText} 50 16 nil 8400 50 2 8 1140850944 1 9888 nil nil nil 5 nil nil nil 9888 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 193 9920 nil 9888 578 #text: 50 1 8 'Root package:' 9888 3 8 #() 770 193 193 nil 27 802 848 81 864 201 880 389 896 41 18 #{UI.StaticText} 50 16 nil 8400 50 2 8 1140850944 262145 10176 nil nil nil 5 nil nil nil 10176 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 193 10208 nil 10176 3 8 #() 770 193 193 nil 27 802 848 361 1904 -107 880 389 896 41 18 #{UI.StaticText} 50 16 nil 8400 50 2 8 1140850944 1 10416 nil nil nil 5 nil nil nil 10416 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 193 10448 nil 10416 578 #text: 50 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10416 3 8 #() 770 193 193 nil 27 802 848 29 1904 -107 880 499 896 109 18 #{UI.CheckBox} 50 16 nil 8400 50 2 8 1140924451 1 10704 3186 nil nil 5280 true nil nil 5 nil nil nil 10704 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[29 0 0 0 43 1 0 0 193 0 0 0 72 1 0 0] 193 10736 8 'Remove redundant &packages' 10704 3 8 #() 770 193 193 nil 27 802 848 59 864 329 880 599 896 59 338 4096 50 4 10176 8 'rootPackage' 10704 8 'stripRedundantPackages' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 8432 8 'Step 3' 8400 1 50 6 8512 9600 9888 10176 10416 10704 770 193 193 nil 27 2898 7 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 11216 nil nil nil 5 nil nil nil 11216 306 338 #{Core.LookupTable} 50 24 18 #{UI.ContainerView} 50 15 nil 11216 50 2 8 1140850688 131073 11328 nil 464 nil 5 nil nil nil 11328 210 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 11328 50 2 8 1140850944 1 11408 3186 nil false 3218 3250 #= 8 #() 3250 #hash 3312 3330 nil true 3362 8 'Resources\LagoonLogo.bmp' 3424 3440 nil 5 nil nil nil 11408 nil nil 3458 nil nil nil 11552 #scale 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 11440 nil 11408 578 #text: 50 1 8 'Graphic' 11408 3 8 #() 770 193 193 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 11328 50 2 8 1140855108 1 11808 nil 464 nil 5 nil nil nil 11808 nil nil 3458 nil nil 41 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 4 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 11840 nil 11808 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 4:\par
\fs16\par
Configure how the ImageStripper removes unwanted classes and methods\par
\cf0\b0\f1\par
\par
\par
}
' 11808 578 #textLimit: 8 #(1073741823) 11808 578 #resetCharFormat 4048 11808 3 8 #() 770 193 193 nil 45 4098 0 2546 770 31 11 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 11360 8 'Heading' 11328 3 50 2 11808 11408 770 193 193 nil 27 802 848 1 1904 1 880 1 896 121 18 #{UI.StaticText} 50 16 nil 11216 50 2 8 1140850944 1 12416 nil nil nil 5 nil nil nil 12416 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 74 0 0 0 32 2 0 0 108 0 0 0] 193 12448 nil 12416 578 #text: 50 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 12416 3 8 #() 770 193 193 nil 27 802 848 29 1904 -25 880 149 896 69 18 #{UI.CheckBox} 50 16 nil 11216 50 2 8 1140924451 1 12704 3186 nil nil 5280 true nil nil 5 nil nil nil 12704 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 193 12736 8 'Remove redundant &classes' 12704 3 8 #() 770 193 193 nil 27 802 848 61 864 441 834 #fixedPreviousBottom 1 896 49 18 #{UI.CheckBox} 50 16 nil 11216 50 2 8 1140924451 1 12992 3186 nil nil 5280 true nil nil 5 nil nil nil 12992 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 193 13024 8 'Remove redundant &resources' 12992 3 8 #() 770 193 193 nil 27 802 1568 121 864 423 834 #fixedPreviousTop 1 896 49 18 #{UI.GroupBox} 50 14 nil 11216 50 2 8 1140850695 65 13280 nil 464 nil 5 nil nil nil 13280 nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 193 13312 8 '' 13280 3 8 #() 770 193 193 nil 27 802 848 -17 1904 19 880 281 896 229 18 #{UI.StaticText} 50 16 nil 11216 50 2 8 1140850944 1 13520 nil nil nil 5 nil nil nil 13520 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 157 0 0 0 29 2 0 0 217 0 0 0] 193 13552 nil 13520 578 #text: 50 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 13520 3 8 #() 770 193 193 nil 27 802 848 29 1904 -31 12976 51 896 121 18 #{UI.CheckBox} 50 16 nil 11216 50 2 8 1140924451 1 13808 3186 nil nil 5280 false nil nil 5 nil nil nil 13808 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 193 13840 8 'Remove redundant &methods' 13808 3 8 #() 770 193 193 nil 27 802 848 61 864 441 12976 1 896 49 18 #{UI.CheckBox} 50 16 nil 11216 50 2 8 1140924451 1 14080 3186 nil nil 5280 false nil nil 5 nil nil nil 14080 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 193 14112 8 'Preserve &aspect set methods' 14080 3 8 #() 770 193 193 nil 27 802 1568 121 864 423 13264 1 896 49 18 #{UI.StaticText} 50 16 nil 11216 50 2 8 1140850944 1 14352 nil nil nil 5 nil nil nil 14352 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 193 14384 nil 14352 578 #text: 50 1 8 'Some methods which may not be identified as redundant can also be removed.' 14352 3 8 #() 770 193 193 nil 27 802 848 29 1904 -7 12976 51 896 49 18 #{UI.CheckBox} 50 16 nil 11216 50 2 8 1140924451 1 14640 3186 nil nil 5280 false nil nil 5 nil nil nil 14640 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 193 14672 8 'Remove #&deprecated methods' 14640 3 8 #() 770 193 193 nil 27 802 848 61 864 441 12976 1 896 49 18 #{UI.CheckBox} 50 16 nil 11216 50 2 8 1140924451 1 14912 3186 nil nil 5280 false nil nil 5 nil nil nil 14912 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 193 14944 8 'Remove #shouldNot&Implement methods' 14912 3 8 #() 770 193 193 nil 27 802 1568 121 864 423 13264 1 896 49 18 #{UI.CheckBox} 50 16 nil 11216 50 2 8 1140924451 1 15184 3186 nil nil 5280 false nil nil 5 nil nil nil 15184 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 193 15216 8 'Remove #&subclassResponsibility methods' 15184 3 8 #() 770 193 193 nil 27 802 848 61 864 441 12976 17 896 49 338 4096 50 14 14080 8 'preserveAspectSetters' 14640 8 'stripDeprecatedMethods' 12704 8 'stripRedundantClasses' 13808 8 'stripRedundantMethods' 12992 8 'stripRedundantResources' 14912 8 'stripShouldNotImplement' 15184 8 'stripSubclassResponsibility' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 11248 8 'Step 4' 11216 1 50 12 11328 12416 12704 12992 13520 13808 14080 14352 14640 14912 15184 13280 770 193 193 nil 27 2898 9 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 15776 nil nil nil 5 nil nil nil 15776 306 338 #{Core.LookupTable} 50 12 18 #{UI.ContainerView} 50 15 nil 15776 50 2 8 1140850688 131073 15888 nil 464 nil 5 nil nil nil 15888 210 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 15888 50 2 8 1140850944 1 15968 3186 nil false 3218 3250 #= 8 #() 3250 #hash 3312 3330 nil true 3362 8 'Resources\LagoonLogo.bmp' 3424 3440 nil 5 nil nil nil 15968 nil nil 3458 nil nil nil 16112 #scale 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 16000 nil 15968 578 #text: 50 1 8 'Graphic' 15968 3 8 #() 770 193 193 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 15888 50 2 8 1140855108 1 16368 nil 464 nil 5 nil nil nil 16368 nil nil 3458 nil nil 41 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 4 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 16400 nil 16368 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 7:\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\cf0\b0\f1\par
}
' 16368 578 #textLimit: 8 #(1073741823) 16368 578 #resetCharFormat 4048 16368 3 8 #() 770 193 193 nil 45 4098 0 2546 770 31 11 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 15920 8 'Heading' 15888 3 50 2 16368 15968 770 193 193 nil 27 802 848 1 1904 1 880 1 896 121 18 #{UI.StaticText} 50 16 nil 15776 50 2 8 1140850944 1 16976 nil nil nil 5 nil nil nil 16976 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 74 0 0 0 31 2 0 0 168 0 0 0] 193 17008 nil 16976 578 #text: 50 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 16976 3 8 #() 770 193 193 nil 27 802 848 29 1904 -27 880 149 896 189 18 #{UI.ReferenceView} 50 14 nil 15776 50 2 8 1140850688 131073 17264 nil nil nil 5 nil nil nil 17264 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 172 0 0 0 25 2 0 0 41 1 0 0] 193 17296 8 '' 17264 3 4048 770 193 193 nil 27 802 848 31 1904 -39 880 345 896 251 18 #{UI.StatusBar} 50 21 nil 15776 50 2 8 1140850700 1 17520 nil nil nil 5 nil 130 nil true 162 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 17520 nil nil 338 4096 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 17520 nil 6448 6448 nil 8 'preStripScriptErrors' nil nil nil 50 1 17680 1094 1 #{UI.StatusBarNullItem} 8705 1 17520 nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 41 1 0 0 26 2 0 0 61 1 0 0] 193 17552 8 '' 17520 3 8 #() 770 193 193 nil 29 802 848 31 1904 -37 12976 1 896 41 18 #{UI.StaticText} 50 16 nil 15776 50 2 8 1140850944 1 17936 nil nil nil 5 nil nil nil 17936 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 64 1 0 0 154 1 0 0 99 1 0 0] 193 17968 nil 17936 578 #text: 50 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 17936 3 8 #() 770 193 193 nil 27 802 848 31 864 791 880 641 896 71 18 #{UI.PushButton} 50 20 nil 15776 50 2 8 1140924416 1 18224 nil 464 nil 5 nil nil nil 18224 nil nil 482 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[184 1 0 0 69 1 0 0 33 2 0 0 94 1 0 0] 193 18256 8 'Custom &Options' 18224 578 #isEnabled: 8 #(false) 18224 3 8 #() 770 193 193 nil 29 802 848 881 864 211 880 651 896 51 338 4096 50 2 17264 8 'preStripScript' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 15808 8 'Step 7' 15776 1 50 6 15888 16976 17264 17520 17936 18224 770 193 193 nil 27 2898 11 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 18752 nil nil nil 5 nil nil nil 18752 306 338 #{Core.LookupTable} 50 18 18 #{UI.ContainerView} 50 15 nil 18752 50 2 8 1140850688 131073 18864 nil 464 nil 5 nil nil nil 18864 210 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 18864 50 2 8 1140850944 1 18944 3186 nil false 3218 3250 #= 8 #() 3250 #hash 3312 3330 nil true 3362 8 'Resources\LagoonLogo.bmp' 3424 3440 nil 5 nil nil nil 18944 nil nil 3458 nil nil nil 19088 #scale 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 18976 nil 18944 578 #text: 50 1 8 'Graphic' 18944 3 8 #() 770 193 193 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 18864 50 2 8 1140855108 1 19344 nil 464 nil 5 nil nil nil 19344 nil nil 3458 nil nil 41 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 4 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 19376 nil 19344 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 5:\fs16\par
\par
Decide what meta-level information is required at runtime\par
\cf0\b0\f1\par
\par
\par
}
' 19344 578 #textLimit: 8 #(1073741823) 19344 578 #resetCharFormat 4048 19344 3 8 #() 770 193 193 nil 45 4098 0 2546 770 31 11 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 18896 8 'Heading' 18864 3 50 2 19344 18944 770 193 193 nil 27 802 848 1 1904 1 880 1 896 121 18 #{UI.StaticText} 50 16 nil 18752 50 2 8 1140850944 1 19952 nil nil nil 5 nil nil nil 19952 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 193 19984 nil 19952 578 #text: 50 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 19952 3 8 #() 770 193 193 nil 27 802 848 29 1904 -107 880 149 896 99 18 #{UI.CheckBox} 50 16 nil 18752 50 2 8 1140924451 1 20240 3186 nil nil 5280 true nil nil 5 nil nil nil 20240 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 193 20272 8 'Remove class meta-&information' 20240 3 8 #() 770 193 193 nil 27 802 848 81 864 369 880 249 896 59 18 #{UI.StaticText} 50 16 nil 18752 50 2 8 1140850944 1 20512 nil nil nil 5 nil nil nil 20512 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 193 20544 nil 20512 578 #text: 50 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 20512 3 8 #() 770 193 193 nil 27 802 848 29 1904 -107 880 321 896 69 18 #{UI.CheckBox} 50 16 nil 18752 50 2 8 1140924451 1 20800 3186 nil nil 5280 false nil nil 5 nil nil nil 20800 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 193 20832 8 'Retain instance &variable names' 20800 3 8 #() 770 193 193 nil 27 802 848 81 864 369 880 389 896 69 18 #{UI.CheckBox} 50 16 nil 18752 50 2 8 1140924451 1 21072 3186 nil nil 5280 false nil nil 5 nil nil nil 21072 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 193 21104 8 'Remove class &GUIDs' 21072 3 8 #() 770 193 193 nil 27 802 848 81 864 369 880 459 896 41 18 #{UI.GroupBox} 50 14 nil 18752 50 2 8 1140850695 65 21344 nil 464 nil 5 nil nil nil 21344 nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 193 21376 8 '' 21344 3 8 #() 770 193 193 nil 27 802 848 -17 1904 19 880 521 896 229 18 #{UI.StaticText} 50 16 nil 18752 50 2 8 1140850944 1 21584 nil nil nil 5 nil nil nil 21584 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 193 21616 nil 21584 578 #text: 50 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 21584 3 8 #() 770 193 193 nil 27 802 848 29 1904 -107 880 549 896 89 18 #{UI.CheckBox} 50 16 nil 18752 50 2 8 1140924451 1 21872 3186 nil nil 5280 false nil nil 5 nil nil nil 21872 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 193 21904 8 'Compile E&xternal Structures' 21872 3 8 #() 770 193 193 nil 27 802 848 81 864 369 880 649 896 49 338 4096 50 8 21872 8 'compileExternalStructures' 20800 8 'retainInstVarNames' 21072 8 'stripClassGuids' 20240 8 'stripClassInfo' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 18784 8 'Step 5' 18752 1 50 9 18864 19952 20240 20512 20800 21072 21584 21872 21344 770 193 193 nil 27 2898 13 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 22416 nil nil nil 5 nil nil nil 22416 306 338 #{Core.LookupTable} 50 14 18 #{UI.ContainerView} 50 15 nil 22416 50 2 8 1140850688 131073 22528 nil 464 nil 5 nil nil nil 22528 210 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 22528 50 2 8 1140850944 1 22608 3186 nil false 3218 3250 #= 8 #() 3250 #hash 3312 3330 nil true 3362 8 'Resources\LagoonLogo.bmp' 3424 3440 nil 5 nil nil nil 22608 nil nil 3458 nil nil nil 22752 #scale 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 22640 nil 22608 578 #text: 50 1 8 'Graphic' 22608 3 8 #() 770 193 193 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 22528 50 2 8 1140855108 1 23008 nil 464 nil 5 nil nil nil 23008 nil nil 3458 nil nil 41 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 4 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 23040 nil 23008 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Final Step:\par
\fs16\par
Deployment\par
\par
\cf0\b0\f1\par
\par
}
' 23008 578 #textLimit: 8 #(1073741823) 23008 578 #resetCharFormat 4048 23008 3 8 #() 770 193 193 nil 45 4098 0 2546 770 31 11 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 22560 8 'Heading' 22528 3 50 2 23008 22608 770 193 193 nil 27 802 848 1 1904 1 880 1 896 121 18 #{UI.StaticText} 50 16 nil 22416 50 2 8 1140850944 1 23616 nil nil nil 5 nil nil nil 23616 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 193 23648 nil 23616 578 #text: 50 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 23616 3 8 #() 770 193 193 nil 27 802 848 29 1904 -97 880 161 896 81 18 #{UI.StaticText} 50 16 nil 22416 50 2 8 1140850944 1 23904 nil nil nil 5 nil nil nil 23904 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 193 23936 nil 23904 578 #text: 50 1 8 'E&xecutable name:' 23904 3 8 #() 770 193 193 nil 27 802 848 81 864 189 880 269 896 49 18 #{UI.StaticText} 50 16 nil 22416 50 2 8 1140850955 262145 24192 nil nil nil 5 nil nil nil 24192 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 193 24224 nil 24192 3 8 #() 770 193 193 nil 27 802 848 281 1904 -97 880 269 896 41 18 #{UI.StaticText} 50 16 nil 22416 50 2 8 1140850944 1 24432 nil nil nil 5 nil nil nil 24432 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 193 24464 nil 24432 578 #text: 50 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 24432 3 8 #() 770 193 193 nil 27 802 848 29 1904 -97 880 349 896 139 18 #{UI.StaticText} 50 16 nil 22416 50 2 8 1140850944 1 24720 nil nil nil 5 nil 130 nil true 162 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 24720 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 193 24752 nil 24720 578 #text: 50 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 24720 3 8 #() 770 193 193 nil 27 802 848 29 1904 -137 880 529 896 81 18 #{UI.StaticText} 50 16 nil 22416 50 2 8 1140850944 1 25056 nil nil nil 5 nil nil nil 25056 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 193 25088 nil 25056 578 #text: 50 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 25056 3 8 #() 770 193 193 nil 27 802 848 29 1904 -107 880 641 896 59 338 4096 50 2 24192 8 'executablePath2' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 22448 8 'Final step' 22416 1 50 7 22528 23616 23904 24192 24720 24432 25056 770 193 193 nil 27 2898 15 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 25568 nil 464 nil 5 nil nil nil 25568 306 338 #{Core.LookupTable} 50 8 18 #{UI.ImageView} 50 21 nil 25568 50 2 8 1140850944 1 25680 3186 nil false 3218 3250 #= 8 #() 3250 #hash 3312 3330 nil true 3362 8 'Resources\LagoonSideBar.jpg' 3424 464 nil 5 nil nil nil 25680 nil nil 3458 nil nil nil 25824 #scaleToFit 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 193 25712 nil 25680 578 #text: 50 1 8 'Lagoon Graphic' 25680 3 8 #() 770 193 193 nil 27 802 848 1 864 379 880 1 896 741 18 #{UI.RichTextEdit} 50 22 nil 25568 50 2 8 1140855110 1 26096 nil 464 nil 5 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 482 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 26210 1 482 #bePlain 8 '&Plain' 1 1 nil nil nil 26210 1 482 #toggleBold 8 '&Bold' 1 1 nil nil nil 26210 1 482 #toggleItalic 8 '&Italic' 1 1 nil nil nil 26210 1 482 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 26274 4097 26162 nil true 50 3 26210 1 482 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 26210 1 482 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 26210 1 482 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 26274 4097 26210 1 482 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 26096 nil nil 3458 nil nil 43 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 5 578 #createWindow: 50 1 626 658 8 #[209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 193 26128 nil 26096 578 #contextMenu: 50 1 26176 26096 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Segoe UI;}}
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
' 26096 578 #textLimit: 8 #(1073741823) 26096 578 #resetCharFormat 4048 26096 3 8 #() 770 193 193 nil 45 802 848 419 1904 -47 880 1 896 489 18 #{UI.TextEdit} 50 20 nil 25568 50 2 8 1140850816 262145 27136 nil 450 #whiteSmoke nil 5 nil nil nil 27136 nil nil 3458 nil nil 35 #focusLost nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 193 27168 nil 27136 3 8 #() 770 193 193 nil 45 802 848 421 1904 -49 12976 3 896 41 18 #{UI.RichTextEdit} 50 22 nil 25568 50 2 8 1140855110 1 27392 nil 464 nil 5 26162 nil true 50 10 26210 1 482 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 26274 4097 26210 1 482 #bePlain 8 '&Plain' 1 1 nil nil nil 26210 1 482 #toggleBold 8 '&Bold' 1 1 nil nil nil 26210 1 482 #toggleItalic 8 '&Italic' 1 1 nil nil nil 26210 1 482 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 26274 4097 26162 nil true 50 3 26210 1 482 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 26210 1 482 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 26210 1 482 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 26274 4097 26210 1 482 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 27392 nil nil 3458 nil nil 43 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 5 578 #createWindow: 50 1 626 658 8 #[209 0 0 0 78 1 0 0 227 1 0 0 102 1 0 0] 193 27424 nil 27392 578 #contextMenu: 50 1 27456 27392 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\f0\fs16 Otherwise click \b Next \b0 to continue\cf0\f1 .\par
\par
\par
\pard\qc\par
}
' 27392 578 #textLimit: 8 #(1073741823) 27392 578 #resetCharFormat 4048 27392 3 8 #() 770 193 193 nil 45 802 848 419 864 549 880 669 896 49 338 4096 50 2 27136 8 'executablePath1' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 25600 8 'Intro' 25568 3 50 4 25680 26096 27136 27392 770 193 193 nil 27 2898 17 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 28608 nil nil nil 5 nil nil nil 28608 306 338 #{Core.LookupTable} 50 8 18 #{UI.ContainerView} 50 15 nil 28608 50 2 8 1140850688 131073 28720 nil 464 nil 5 nil nil nil 28720 210 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 28720 50 2 8 1140850944 1 28800 3186 nil false 3218 3250 #= 8 #() 3250 #hash 3312 3330 nil true 3362 8 'Resources\LagoonLogo.bmp' 3424 3440 nil 5 nil nil nil 28800 nil nil 3458 nil nil nil 28944 #scale 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 28832 nil 28800 578 #text: 50 1 8 'Graphic' 28800 3 8 #() 770 193 193 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 28720 50 2 8 1140855108 1 29200 nil 464 nil 5 nil nil nil 29200 nil nil 3458 nil nil 41 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 4 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 29232 nil 29200 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 1:\cf0\f1\fs16\par
\par
\cf1\f0 Choose an ImageStripper to perform the deployment process\cf0\b0\f1\par
\par
\par
\par
}
' 29200 578 #textLimit: 8 #(1073741823) 29200 578 #resetCharFormat 4048 29200 3 8 #() 770 193 193 nil 45 4098 0 2546 770 31 11 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 28752 8 'Heading' 28720 3 50 2 29200 28800 770 193 193 nil 27 802 848 1 1904 1 880 1 896 121 18 #{UI.StaticText} 50 16 nil 28608 50 2 8 1140850944 1 29808 nil nil nil 5 nil nil nil 29808 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 193 29840 nil 29808 578 #text: 50 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 29808 3 8 #() 770 193 193 nil 27 802 848 29 1904 -107 880 229 896 149 18 #{UI.StaticText} 50 16 nil 28608 50 2 8 1140850944 1 30096 nil nil nil 5 nil nil nil 30096 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 193 30128 nil 30096 578 #text: 50 1 8 'Choose a the class of &ImageStripper to install.' 30096 3 8 #() 770 193 193 nil 27 802 848 81 864 249 880 401 896 121 18 #{UI.ComboBox} 50 17 nil 28608 50 2 8 1144063491 1025 30384 6370 2866 0 nil 6432 464 nil 5 nil nil nil 30384 nil nil 6448 6480 401 530 50 1 578 #createWindow: 50 1 626 658 8 #[174 0 0 0 204 0 0 0 241 1 0 0 166 1 0 0] 193 30416 8 '' 30384 3 8 #() 770 193 193 nil 27 802 848 349 1904 -119 880 409 896 41 338 4096 50 2 30384 8 'imageStripperClass' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 28640 8 'Step 1' 28608 1 50 4 28720 29808 30096 30384 770 193 193 nil 27 2898 19 18 #{UI.ContainerView} 50 15 nil 2768 50 2 8 1140850688 131073 30880 nil nil nil 5 nil nil nil 30880 306 338 #{Core.LookupTable} 50 14 18 #{UI.ContainerView} 50 15 nil 30880 50 2 8 1140850688 131073 30992 nil 464 nil 5 nil nil nil 30992 210 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 30992 50 2 8 1140850944 1 31072 3186 nil false 3218 3250 #= 8 #() 3250 #hash 3312 3330 nil true 3362 8 'Resources\LagoonLogo.bmp' 3424 3440 nil 5 nil nil nil 31072 nil nil 3458 nil nil nil 31216 #scale 1 nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 193 31104 nil 31072 578 #text: 50 1 8 'Graphic' 31072 3 8 #() 770 193 193 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 30992 50 2 8 1140855108 1 31472 nil 464 nil 5 nil nil nil 31472 nil nil 3458 nil nil 41 #focusLost nil nil nil nil 3762 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 530 50 4 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 193 31504 nil 31472 578 #text: 50 1 3954 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 6:\fs16\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 31472 578 #textLimit: 8 #(1073741823) 31472 578 #resetCharFormat 4048 31472 3 8 #() 770 193 193 nil 45 4098 0 2546 770 31 11 770 11 11 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 193 31024 8 'Heading' 30992 3 50 2 31472 31072 770 193 193 nil 27 802 848 1 1904 1 880 1 896 121 18 #{UI.StaticText} 50 16 nil 30880 50 2 8 1140850944 1 32080 nil nil nil 5 nil nil nil 32080 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 193 32112 nil 32080 578 #text: 50 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 32080 3 8 #() 770 193 193 nil 27 802 848 29 1904 -97 880 161 896 49 18 #{UI.CheckBox} 50 16 nil 30880 50 2 8 1140924451 1 32368 3186 nil nil 5280 false nil nil 5 nil nil nil 32368 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 193 32400 8 'Remove &Class Builder' 32368 3 8 #() 770 193 193 nil 27 802 848 81 864 369 880 209 896 41 18 #{UI.GroupBox} 50 14 nil 30880 50 2 8 1140850695 65 32640 nil 464 nil 5 nil nil nil 32640 nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 193 32672 8 '' 32640 3 8 #() 770 193 193 nil 27 802 848 1 1904 1 880 327 896 393 18 #{UI.StaticText} 50 16 nil 30880 50 2 8 1140850944 1 32880 nil nil nil 5 nil nil nil 32880 nil nil 3458 nil nil nil 530 50 2 578 #createWindow: 50 1 626 658 8 #[15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 193 32912 nil 32880 578 #text: 50 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 32880 3 8 #() 770 193 193 nil 27 802 848 31 1904 -117 880 391 896 49 18 #{UI.CheckBox} 50 16 nil 30880 50 2 8 1140924451 1 33168 3186 nil nil 5280 true nil nil 5 nil nil nil 33168 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 193 33200 8 'Fold duplicate s&trings' 33168 3 8 #() 770 193 193 nil 27 802 848 71 864 379 880 451 896 49 18 #{UI.CheckBox} 50 16 nil 30880 50 2 8 1140924451 1 33440 3186 nil nil 5280 true nil nil 5 nil nil nil 33440 nil nil 3458 nil nil nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 193 33472 8 'Fold duplicate b&ytecode arrays' 33440 3 8 #() 770 193 193 nil 27 802 848 71 864 379 880 511 896 41 338 4096 50 6 32368 8 'stripClassBuilder' 33440 8 'stripDuplicateBytecodes' 33168 8 'stripDuplicateStrings' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 193 30912 8 'Step 6' 30880 1 50 7 30992 32080 32368 32880 33168 33440 32640 770 193 193 nil 27 25568 nil nil nil 338 4096 50 2 25568 8 'Intro' nil 530 50 1 578 #createWindow: 50 1 626 658 8 #[0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 193 2800 8 '' 2768 3 50 9 25568 28608 2928 8400 11216 18752 30880 15776 22416 770 193 193 nil 27 338 4096 50 2 2768 8 'Steps' 2546 770 1 1 770 1 1 nil nil nil nil 1 nil nil 770 2049 881 770 1151 881 1 nil 193 774 #{Core.Semaphore} nil nil 1 false nil nil nil nil nil 530 50 2 578 #createWindow: 50 1 518 #{UI.CreateDialog} 2546 770 7679 21 770 8829 901 193 32 578 #setWindowText: 50 1 8 'Lagoon Deployment Wizard' 32 1 50 2 2768 240 770 193 193 nil 29)!

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

