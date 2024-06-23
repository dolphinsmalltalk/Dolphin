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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 1798 #{UI.BorderLayout} 1 1 nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140916224 393217 272 nil nil nil 5 nil nil nil 272 262 #{UI.FramingLayout} 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.LookupTable} 50 12 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 416 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 416 nil nil 1350 4 #{UI.CommandDescription} #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 262 #{Core.MessageSequence} 50 3 774 #{Core.MessageSend} #createAt:extent: 50 2 210 19 13 210 139 49 416 610 #isEnabled: 8 #(false) 416 610 #text: 50 1 8 '&Deploy' 416 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 210 193 193 nil 29 2118 2 #{UI.FramingConstraints} 1030 #{UI.FramingCalculation} #fixedParentLeft 9 882 #fixedViewLeft 139 882 #fixedParentTop 1 882 #fixedViewTop 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 960 nil 496 nil 5 nil nil nil 960 nil nil 514 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 217 13 210 131 49 960 610 #isEnabled: 8 #(false) 960 610 #text: 50 1 8 '< &Back' 960 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 832 nil 29 850 882 #relativeParentWidth 518 #{Core.Fraction} 15 75 912 131 928 1 944 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 1344 nil 496 nil 5 nil nil nil 1344 nil nil 514 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 357 13 210 131 49 1344 610 #isEnabled: 8 #(false) 1344 610 #text: 50 1 8 '&Next >' 1344 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 832 nil 29 850 882 #fixedPreviousRight 11 912 131 928 1 944 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 1696 nil 496 nil 5 nil nil nil 1696 nil nil 514 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 545 13 210 131 49 1696 610 #isEnabled: 8 #(false) 1696 610 #text: 50 1 8 '&Reset' 1696 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 832 nil 29 850 882 #fixedViewRight -129 882 #fixedParentRight -429 928 1 944 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 2064 nil 496 nil 5 nil nil nil 2064 nil nil 514 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 685 13 210 241 49 2064 610 #isEnabled: 8 #(false) 2064 610 #text: 50 1 8 '&Save Configuration' 2064 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 832 nil 29 850 1680 11 912 241 928 1 944 49 18 #{UI.PushButton} 50 20 nil 272 50 2 8 1140924416 1 2400 nil 496 nil 5 nil nil nil 2400 nil nil 514 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 955 13 210 139 49 2400 610 #text: 50 1 8 'Cancel' 2400 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 832 nil 29 850 2032 -137 2048 -11 928 1 944 49 370 #{Core.IdentityDictionary} 50 2 416 8 'deploy' 518 #{Graphics.Rectangle} 210 11 13 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 723 210 1119 81 272 610 #text: 50 1 8 'Buttons' 272 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 50 6 416 960 1344 1696 2064 2400 832 nil 27 nil nil 18 #{UI.WizardCardContainer} 50 15 nil 32 50 2 8 1140850688 393217 3008 nil nil nil 5 nil nil nil 3008 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 9 518 #{Core.Association} 3 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 3168 nil nil nil 5 nil nil nil 3168 338 370 #{Core.LookupTable} 50 28 18 #{UI.ContainerView} 50 15 nil 3168 50 2 8 1140850688 131073 3280 nil 496 nil 5 nil nil nil 3280 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 3280 50 2 8 1140850944 1 3360 1094 2 #{UI.ValueHolder} nil false 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 3490 #hash 8 #() 774 #{Graphics.Gdiplus.Bitmap} nil true 582 1 #{Graphics.Gdiplus.BitmapFromFileInitializer} 8 'Resources\LagoonLogo.bmp' 6 #{Kernel.ImageRelativeFileLocator} 482 #face3d nil 5 nil nil nil 3360 nil nil 518 #{UI.NullConverter} nil nil nil 3584 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 3360 610 #text: 50 1 8 'Graphic' 3360 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 3280 50 2 8 1140855108 1 3920 nil 496 nil 5 nil nil nil 3920 nil nil 3698 nil nil 41 #focusLost nil nil nil nil 262 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 3920 610 #text: 50 1 262 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 2: \par
\fs16\par
Choose an Executable File and RuntimeSessionManager\cf0\b0\f1\par
\par
\par
\par
}
' 3920 610 #textLimit: 8 #(1073741823) 3920 610 #resetCharFormat 8 #() 3920 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 550 #{Core.IdentityDictionary} 0 2754 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 3280 610 #text: 50 1 8 'Heading' 3280 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 3920 3360 832 nil 27 850 896 1 2048 1 928 1 944 121 18 #{UI.StaticText} 50 16 nil 3168 50 2 8 1140850944 1 4624 nil nil nil 5 nil nil nil 4624 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 141 210 405 81 4624 610 #text: 50 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 4624 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 217 0 0 0 110 0 0 0] 8 #() 832 nil 27 850 896 31 912 405 928 141 944 81 18 #{UI.TextEdit} 50 20 nil 3168 50 2 8 1140916352 1025 4912 nil 496 nil 5 nil nil nil 4912 nil nil 3698 nil nil 1 #focusLost nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 447 151 210 559 41 4912 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 223 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 832 nil 45 850 896 447 2048 -109 928 151 944 41 18 #{UI.PushButton} 50 20 nil 3168 50 2 8 1140924416 1 5152 nil 496 nil 5 nil nil nil 5152 nil nil 514 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 1025 151 210 49 41 5152 610 #isEnabled: 8 #(false) 5152 610 #text: 50 1 8 '...' 5152 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 832 nil 29 850 2032 -47 2048 -41 928 151 944 41 18 #{UI.CheckBox} 50 16 nil 3168 50 2 8 1140924451 1 5488 3426 nil nil 6 #{Kernel.NeverSearchPolicy} false nil nil 5 nil nil nil 5488 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 211 210 431 81 5488 610 #text: 50 1 8 'Create single file, "To Go" distributable.' 5488 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 832 nil 27 850 896 31 912 431 928 211 944 81 18 #{UI.GroupBox} 50 14 nil 3168 50 2 8 1140850695 65 5824 nil 496 nil 5 nil nil nil 5824 nil nil 562 50 1 610 #createAt:extent: 50 2 210 1 279 210 1155 201 5824 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 239 0 0 0] 8 #() 832 nil 27 850 896 1 2048 41 928 279 944 201 18 #{UI.StaticText} 50 16 nil 3168 50 2 8 1140850944 1 6048 nil nil nil 5 nil nil nil 6048 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 309 210 975 71 6048 610 #text: 50 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 6048 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 832 nil 27 850 896 31 2048 -109 928 309 944 71 18 #{UI.StaticText} 50 16 nil 3168 50 2 8 1140850944 1 6336 nil nil nil 5 nil nil nil 6336 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 37 379 210 389 81 6336 610 #text: 50 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 6336 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 18 0 0 0 189 0 0 0 212 0 0 0 229 0 0 0] 8 #() 832 nil 27 850 896 37 912 389 928 379 944 81 18 #{UI.ComboBox} 50 17 nil 3168 50 2 8 1144063491 1025 6624 838 2 #{UI.ListModel} 3106 0 nil 6 #{Kernel.IdentitySearchPolicy} 496 nil 5 nil nil nil 6624 nil nil 3490 #displayString 8 #() 8 #() 401 562 50 1 610 #createAt:extent: 50 2 210 441 393 210 565 43 6624 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 196 0 0 0 246 1 0 0 217 0 0 0] 8 #() 832 nil 27 850 896 441 2048 -109 928 393 944 43 18 #{UI.StaticText} 50 16 nil 3168 50 2 8 1140850944 1 6976 nil nil nil 5 nil nil nil 6976 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 491 210 1057 81 6976 610 #text: 50 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 6976 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 245 0 0 0 31 2 0 0 29 1 0 0] 8 #() 832 nil 27 850 896 31 2048 -27 928 491 944 81 18 #{UI.CheckBox} 50 16 nil 3168 50 2 8 1140924451 1 7264 3426 nil nil 5584 true nil nil 5 nil nil nil 7264 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 597 210 251 41 7264 610 #text: 50 1 8 'Write &log file' 7264 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 832 nil 27 850 896 61 912 251 928 597 944 41 18 #{UI.TextEdit} 50 20 nil 3168 50 2 8 1140850688 262145 7568 nil nil nil 5 nil nil nil 7568 nil nil 3698 nil nil 1 #focusLost nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 441 597 210 565 41 7568 610 #isEnabled: 8 #(false) 7568 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 832 nil 45 850 896 441 2048 -109 928 597 944 41 18 #{UI.PushButton} 50 20 nil 3168 50 2 8 1140924416 1 7840 nil 496 nil 5 nil nil nil 7840 nil nil 514 #showLog 8 '&Browse Log' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 441 657 210 159 47 7840 610 #isEnabled: 8 #(false) 7840 610 #text: 50 1 8 '&Browse Log' 7840 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 72 1 0 0 43 1 0 0 95 1 0 0] 8 #() 832 nil 29 850 896 441 912 159 928 657 944 47 18 #{UI.CheckBox} 50 16 nil 3168 50 2 8 1140924451 1 8176 3426 nil nil 5584 true nil nil 5 nil nil nil 8176 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 661 210 251 41 8176 610 #text: 50 1 8 'Log &class references' 8176 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 832 nil 27 850 896 61 912 251 928 661 944 41 370 4336 50 14 4912 8 'executableName' 5488 8 'isToGo' 7568 8 'logFileName' 8176 8 'logReferencesToClasses' 6624 8 'runtimeSessionManagerClass' 7840 8 'showLog' 7264 8 'writeLogFile' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 3168 610 #text: 50 1 8 'Step 2' 3168 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 14 3280 4624 4912 5152 5488 6048 6336 6624 6976 7264 8176 7568 7840 5824 832 nil 27 3138 5 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 8832 nil nil nil 5 nil nil nil 8832 338 370 #{Core.LookupTable} 50 12 18 #{UI.ContainerView} 50 15 nil 8832 50 2 8 1140850688 131073 8944 nil 496 nil 5 nil nil nil 8944 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 8944 50 2 8 1140850944 1 9024 3426 nil false 3458 3490 #= 8 #() 3490 #hash 3552 3570 nil true 3602 8 'Resources\LagoonLogo.bmp' 3664 3680 nil 5 nil nil nil 9024 nil nil 3698 nil nil nil 9168 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 9024 610 #text: 50 1 8 'Graphic' 9024 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 8944 50 2 8 1140855108 1 9424 nil 496 nil 5 nil nil nil 9424 nil nil 3698 nil nil 41 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 9424 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 3:\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\cf0\f1\par
\b0\par
\par
\par
}
' 9424 610 #textLimit: 8 #(1073741823) 9424 610 #resetCharFormat 4272 9424 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 4338 0 2754 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 8944 610 #text: 50 1 8 'Heading' 8944 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 9424 9024 832 nil 27 850 896 1 2048 1 928 1 944 121 18 #{UI.StaticText} 50 16 nil 8832 50 2 8 1140850944 1 10064 nil nil nil 5 nil nil nil 10064 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 171 210 975 191 10064 610 #text: 50 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 10064 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 832 nil 27 850 896 31 2048 -109 928 171 944 191 18 #{UI.StaticText} 50 16 nil 8832 50 2 8 1140850944 1 10352 nil nil nil 5 nil nil nil 10352 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 389 210 201 41 10352 610 #text: 50 1 8 'Root package:' 10352 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 832 nil 27 850 896 81 912 201 928 389 944 41 18 #{UI.StaticText} 50 16 nil 8832 50 2 8 1140850944 262145 10640 nil nil nil 5 nil nil nil 10640 nil nil 3698 nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 361 389 210 647 41 10640 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 832 nil 27 850 896 361 2048 -107 928 389 944 41 18 #{UI.StaticText} 50 16 nil 8832 50 2 8 1140850944 1 10880 nil nil nil 5 nil nil nil 10880 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 499 210 979 109 10880 610 #text: 50 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10880 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 832 nil 27 850 896 29 2048 -107 928 499 944 109 18 #{UI.CheckBox} 50 16 nil 8832 50 2 8 1140924451 1 11168 3426 nil nil 5584 true nil nil 5 nil nil nil 11168 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 59 599 210 329 59 11168 610 #text: 50 1 8 'Remove redundant &packages' 11168 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 72 1 0 0] 8 #() 832 nil 27 850 896 59 912 329 928 599 944 59 370 4336 50 4 10640 8 'rootPackage' 11168 8 'stripRedundantPackages' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 8832 610 #text: 50 1 8 'Step 3' 8832 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 6 8944 10064 10352 10640 10880 11168 832 nil 27 3138 7 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 11744 nil nil nil 5 nil nil nil 11744 338 370 #{Core.LookupTable} 50 24 18 #{UI.ContainerView} 50 15 nil 11744 50 2 8 1140850688 131073 11856 nil 496 nil 5 nil nil nil 11856 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 11856 50 2 8 1140850944 1 11936 3426 nil false 3458 3490 #= 8 #() 3490 #hash 3552 3570 nil true 3602 8 'Resources\LagoonLogo.bmp' 3664 3680 nil 5 nil nil nil 11936 nil nil 3698 nil nil nil 12080 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 11936 610 #text: 50 1 8 'Graphic' 11936 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 11856 50 2 8 1140855108 1 12336 nil 496 nil 5 nil nil nil 12336 nil nil 3698 nil nil 41 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 12336 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 4:\par
\fs16\par
Configure how the ImageStripper removes unwanted classes and methods\par
\cf0\b0\f1\par
\par
\par
}
' 12336 610 #textLimit: 8 #(1073741823) 12336 610 #resetCharFormat 4272 12336 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 4338 0 2754 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 11856 610 #text: 50 1 8 'Heading' 11856 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 12336 11936 832 nil 27 850 896 1 2048 1 928 1 944 121 18 #{UI.StaticText} 50 16 nil 11744 50 2 8 1140850944 1 12976 nil nil nil 5 nil nil nil 12976 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 149 210 1061 69 12976 610 #text: 50 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 12976 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 32 2 0 0 108 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -25 928 149 944 69 18 #{UI.CheckBox} 50 16 nil 11744 50 2 8 1140924451 1 13264 3426 nil nil 5584 true nil nil 5 nil nil nil 13264 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 217 210 441 49 13264 610 #text: 50 1 8 'Remove redundant &classes' 13264 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 832 nil 27 850 896 61 912 441 882 #fixedPreviousBottom 1 944 49 18 #{UI.CheckBox} 50 16 nil 11744 50 2 8 1140924451 1 13584 3426 nil nil 5584 true nil nil 5 nil nil nil 13584 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 621 217 210 423 49 13584 610 #text: 50 1 8 'Remove redundant &resources' 13584 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 832 nil 27 850 1680 121 912 423 882 #fixedPreviousTop 1 944 49 18 #{UI.GroupBox} 50 14 nil 11744 50 2 8 1140850695 65 13904 nil 496 nil 5 nil nil nil 13904 nil nil 562 50 1 610 #createAt:extent: 50 2 210 -17 281 210 1151 229 13904 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 832 nil 27 850 896 -17 2048 19 928 281 944 229 18 #{UI.StaticText} 50 16 nil 11744 50 2 8 1140850944 1 14128 nil nil nil 5 nil nil nil 14128 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 315 210 1055 121 14128 610 #text: 50 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 14128 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 29 2 0 0 217 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -31 13568 51 944 121 18 #{UI.CheckBox} 50 16 nil 11744 50 2 8 1140924451 1 14416 3426 nil nil 5584 false nil nil 5 nil nil nil 14416 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 435 210 441 49 14416 610 #text: 50 1 8 'Remove redundant &methods' 14416 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 832 nil 27 850 896 61 912 441 13568 1 944 49 18 #{UI.CheckBox} 50 16 nil 11744 50 2 8 1140924451 1 14720 3426 nil nil 5584 false nil nil 5 nil nil nil 14720 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 621 435 210 423 49 14720 610 #text: 50 1 8 'Preserve &aspect set methods' 14720 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 832 nil 27 850 1680 121 912 423 13888 1 944 49 18 #{UI.StaticText} 50 16 nil 11744 50 2 8 1140850944 1 15024 nil nil nil 5 nil nil nil 15024 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 533 210 1079 49 15024 610 #text: 50 1 8 'Some methods which may not be identified as redundant can also be removed.' 15024 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 832 nil 27 850 896 29 2048 -7 13568 51 944 49 18 #{UI.CheckBox} 50 16 nil 11744 50 2 8 1140924451 1 15312 3426 nil nil 5584 false nil nil 5 nil nil nil 15312 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 581 210 441 49 15312 610 #text: 50 1 8 'Remove #&deprecated methods' 15312 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 832 nil 27 850 896 61 912 441 13568 1 944 49 18 #{UI.CheckBox} 50 16 nil 11744 50 2 8 1140924451 1 15616 3426 nil nil 5584 false nil nil 5 nil nil nil 15616 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 621 581 210 423 49 15616 610 #text: 50 1 8 'Remove #shouldNot&Implement methods' 15616 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 832 nil 27 850 1680 121 912 423 13888 1 944 49 18 #{UI.CheckBox} 50 16 nil 11744 50 2 8 1140924451 1 15920 3426 nil nil 5584 false nil nil 5 nil nil nil 15920 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 61 645 210 441 49 15920 610 #text: 50 1 8 'Remove #&subclassResponsibility methods' 15920 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 832 nil 27 850 896 61 912 441 13568 17 944 49 370 4336 50 14 14720 8 'preserveAspectSetters' 15312 8 'stripDeprecatedMethods' 13264 8 'stripRedundantClasses' 14416 8 'stripRedundantMethods' 13584 8 'stripRedundantResources' 15616 8 'stripShouldNotImplement' 15920 8 'stripSubclassResponsibility' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 11744 610 #text: 50 1 8 'Step 4' 11744 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 12 11856 12976 13264 13584 14128 14416 14720 15024 15312 15616 15920 13904 832 nil 27 3138 9 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 16576 nil nil nil 5 nil nil nil 16576 338 370 #{Core.LookupTable} 50 12 18 #{UI.ContainerView} 50 15 nil 16576 50 2 8 1140850688 131073 16688 nil 496 nil 5 nil nil nil 16688 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 16688 50 2 8 1140850944 1 16768 3426 nil false 3458 3490 #= 8 #() 3490 #hash 3552 3570 nil true 3602 8 'Resources\LagoonLogo.bmp' 3664 3680 nil 5 nil nil nil 16768 nil nil 3698 nil nil nil 16912 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 16768 610 #text: 50 1 8 'Graphic' 16768 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 16688 50 2 8 1140855108 1 17168 nil 496 nil 5 nil nil nil 17168 nil nil 3698 nil nil 41 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 17168 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 7:\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\cf0\b0\f1\par
}
' 17168 610 #textLimit: 8 #(1073741823) 17168 610 #resetCharFormat 4272 17168 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 4338 0 2754 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 16688 610 #text: 50 1 8 'Heading' 16688 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 17168 16768 832 nil 27 850 896 1 2048 1 928 1 944 121 18 #{UI.StaticText} 50 16 nil 16576 50 2 8 1140850944 1 17808 nil nil nil 5 nil nil nil 17808 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 149 210 1059 189 17808 610 #text: 50 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 17808 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 31 2 0 0 168 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -27 928 149 944 189 18 #{UI.ReferenceView} 50 14 nil 16576 50 2 8 1140850688 131073 18096 nil nil nil 5 nil nil nil 18096 582 1 #{UI.ResourceIdentifier} #{Tools.SmalltalkWorkspace} #resource_Default_view nil 562 50 1 610 #createAt:extent: 50 2 210 31 345 210 1045 251 18096 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 172 0 0 0 25 2 0 0 41 1 0 0] 4272 832 nil 27 850 896 31 2048 -39 928 345 944 251 18 #{UI.StatusBar} 50 21 nil 16576 50 2 8 1140850700 1 18336 nil nil nil 5 nil 130 nil true 162 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 210 193 193 nil 18336 nil nil 370 4336 50 2 1862 1 #{UI.StatusBarItem} 8193 -1 18336 nil 6768 6768 nil 8 'preStripScriptErrors' nil nil nil 50 1 18512 1094 1 #{UI.StatusBarNullItem} 8705 1 18336 nil nil 562 50 1 610 #createAt:extent: 50 2 210 31 595 210 1047 41 18336 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 41 1 0 0 26 2 0 0 61 1 0 0] 8 #() 832 nil 29 850 896 31 2048 -37 13568 1 944 41 18 #{UI.StaticText} 50 16 nil 16576 50 2 8 1140850944 1 18752 nil nil nil 5 nil nil nil 18752 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 651 210 791 71 18752 610 #text: 50 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 18752 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 832 nil 27 850 896 31 912 791 928 651 944 71 18 #{UI.PushButton} 50 20 nil 16576 50 2 8 1140924416 1 19040 nil 496 nil 5 nil nil nil 19040 nil nil 514 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 562 50 3 610 #createAt:extent: 50 2 210 881 661 210 211 51 19040 610 #isEnabled: 8 #(false) 19040 610 #text: 50 1 8 'Custom &Options' 19040 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 832 nil 29 850 896 881 912 211 928 661 944 51 370 4336 50 2 18096 8 'preStripScript' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 16576 610 #text: 50 1 8 'Step 7' 16576 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 6 16688 17808 18096 18336 18752 19040 832 nil 27 3138 11 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 19632 nil nil nil 5 nil nil nil 19632 338 370 #{Core.LookupTable} 50 18 18 #{UI.ContainerView} 50 15 nil 19632 50 2 8 1140850688 131073 19744 nil 496 nil 5 nil nil nil 19744 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 19744 50 2 8 1140850944 1 19824 3426 nil false 3458 3490 #= 8 #() 3490 #hash 3552 3570 nil true 3602 8 'Resources\LagoonLogo.bmp' 3664 3680 nil 5 nil nil nil 19824 nil nil 3698 nil nil nil 19968 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 19824 610 #text: 50 1 8 'Graphic' 19824 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 19744 50 2 8 1140855108 1 20224 nil 496 nil 5 nil nil nil 20224 nil nil 3698 nil nil 41 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 20224 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 5:\fs16\par
\par
Decide what meta-level information is required at runtime\par
\cf0\b0\f1\par
\par
\par
}
' 20224 610 #textLimit: 8 #(1073741823) 20224 610 #resetCharFormat 4272 20224 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 4338 0 2754 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 19744 610 #text: 50 1 8 'Heading' 19744 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 20224 19824 832 nil 27 850 896 1 2048 1 928 1 944 121 18 #{UI.StaticText} 50 16 nil 19632 50 2 8 1140850944 1 20864 nil nil nil 5 nil nil nil 20864 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 149 210 979 99 20864 610 #text: 50 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 20864 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -107 928 149 944 99 18 #{UI.CheckBox} 50 16 nil 19632 50 2 8 1140924451 1 21152 3426 nil nil 5584 true nil nil 5 nil nil nil 21152 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 249 210 369 59 21152 610 #text: 50 1 8 'Remove class meta-&information' 21152 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 832 nil 27 850 896 81 912 369 928 249 944 59 18 #{UI.StaticText} 50 16 nil 19632 50 2 8 1140850944 1 21456 nil nil nil 5 nil nil nil 21456 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 321 210 979 69 21456 610 #text: 50 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 21456 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -107 928 321 944 69 18 #{UI.CheckBox} 50 16 nil 19632 50 2 8 1140924451 1 21744 3426 nil nil 5584 false nil nil 5 nil nil nil 21744 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 389 210 369 69 21744 610 #text: 50 1 8 'Retain instance &variable names' 21744 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 832 nil 27 850 896 81 912 369 928 389 944 69 18 #{UI.CheckBox} 50 16 nil 19632 50 2 8 1140924451 1 22048 3426 nil nil 5584 false nil nil 5 nil nil nil 22048 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 459 210 369 41 22048 610 #text: 50 1 8 'Remove class &GUIDs' 22048 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 832 nil 27 850 896 81 912 369 928 459 944 41 18 #{UI.GroupBox} 50 14 nil 19632 50 2 8 1140850695 65 22352 nil 496 nil 5 nil nil nil 22352 nil nil 562 50 1 610 #createAt:extent: 50 2 210 -17 521 210 1151 229 22352 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 832 nil 27 850 896 -17 2048 19 928 521 944 229 18 #{UI.StaticText} 50 16 nil 19632 50 2 8 1140850944 1 22576 nil nil nil 5 nil nil nil 22576 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 549 210 979 89 22576 610 #text: 50 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 22576 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 832 nil 27 850 896 29 2048 -107 928 549 944 89 18 #{UI.CheckBox} 50 16 nil 19632 50 2 8 1140924451 1 22864 3426 nil nil 5584 false nil nil 5 nil nil nil 22864 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 649 210 369 49 22864 610 #text: 50 1 8 'Compile E&xternal Structures' 22864 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 832 nil 27 850 896 81 912 369 928 649 944 49 370 4336 50 8 22864 8 'compileExternalStructures' 21744 8 'retainInstVarNames' 22048 8 'stripClassGuids' 21152 8 'stripClassInfo' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 19632 610 #text: 50 1 8 'Step 5' 19632 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 9 19744 20864 21152 21456 21744 22048 22576 22864 22352 832 nil 27 3138 13 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 23472 nil nil nil 5 nil nil nil 23472 338 370 #{Core.LookupTable} 50 14 18 #{UI.ContainerView} 50 15 nil 23472 50 2 8 1140850688 131073 23584 nil 496 nil 5 nil nil nil 23584 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 23584 50 2 8 1140850944 1 23664 3426 nil false 3458 3490 #= 8 #() 3490 #hash 3552 3570 nil true 3602 8 'Resources\LagoonLogo.bmp' 3664 3680 nil 5 nil nil nil 23664 nil nil 3698 nil nil nil 23808 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 23664 610 #text: 50 1 8 'Graphic' 23664 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 23584 50 2 8 1140855108 1 24064 nil 496 nil 5 nil nil nil 24064 nil nil 3698 nil nil 41 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 24064 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Final Step:\par
\fs16\par
Deployment\par
\par
\cf0\b0\f1\par
\par
}
' 24064 610 #textLimit: 8 #(1073741823) 24064 610 #resetCharFormat 4272 24064 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 4338 0 2754 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 23584 610 #text: 50 1 8 'Heading' 23584 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 24064 23664 832 nil 27 850 896 1 2048 1 928 1 944 121 18 #{UI.StaticText} 50 16 nil 23472 50 2 8 1140850944 1 24704 nil nil nil 5 nil nil nil 24704 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 161 210 989 81 24704 610 #text: 50 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 24704 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -97 928 161 944 81 18 #{UI.StaticText} 50 16 nil 23472 50 2 8 1140850944 1 24992 nil nil nil 5 nil nil nil 24992 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 269 210 189 49 24992 610 #text: 50 1 8 'E&xecutable name:' 24992 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 832 nil 27 850 896 81 912 189 928 269 944 49 18 #{UI.StaticText} 50 16 nil 23472 50 2 8 1140850955 262145 25280 nil nil nil 5 nil nil nil 25280 nil nil 3698 nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 281 269 210 737 41 25280 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 832 nil 27 850 896 281 2048 -97 928 269 944 41 18 #{UI.StaticText} 50 16 nil 23472 50 2 8 1140850944 1 25520 nil nil nil 5 nil nil nil 25520 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 349 210 989 139 25520 610 #text: 50 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 25520 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -97 928 349 944 139 18 #{UI.StaticText} 50 16 nil 23472 50 2 8 1140850944 1 25808 nil nil nil 5 nil 130 nil true 162 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 210 193 193 nil 25808 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 529 210 949 81 25808 610 #text: 50 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 25808 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 832 nil 27 850 896 29 2048 -137 928 529 944 81 18 #{UI.StaticText} 50 16 nil 23472 50 2 8 1140850944 1 26160 nil nil nil 5 nil nil nil 26160 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 641 210 979 59 26160 610 #text: 50 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 26160 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 832 nil 27 850 896 29 2048 -107 928 641 944 59 370 4336 50 2 25280 8 'executablePath2' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 23472 610 #text: 50 1 8 'Final step' 23472 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 7 23584 24704 24992 25280 25808 25520 26160 832 nil 27 3138 15 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 26704 nil 496 nil 5 nil nil nil 26704 338 370 #{Core.LookupTable} 50 8 18 #{UI.ImageView} 50 21 nil 26704 50 2 8 1140850944 1 26816 3426 nil false 3458 3490 #= 8 #() 3490 #hash 3552 3570 nil true 3602 8 'Resources\LagoonSideBar.jpg' 3664 496 nil 5 nil nil nil 26816 nil nil 3698 nil nil nil 26960 #centered 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 379 741 26816 610 #text: 50 1 8 'Lagoon Graphic' 26816 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 832 nil 27 850 896 1 912 379 928 1 944 741 18 #{UI.RichTextEdit} 50 22 nil 26704 50 2 8 1140855110 1 27232 nil 496 nil 5 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 514 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 27346 1 514 #bePlain 8 '&Plain' 1 1 nil nil nil 27346 1 514 #toggleBold 8 '&Bold' 1 1 nil nil nil 27346 1 514 #toggleItalic 8 '&Italic' 1 1 nil nil nil 27346 1 514 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 27410 4097 27298 nil true 50 3 27346 1 514 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 27346 1 514 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 27346 1 514 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 27410 4097 27346 1 514 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 27232 nil nil 3698 nil nil 43 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 419 1 210 649 489 27232 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Segoe UI;}}
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
' 27232 610 #textLimit: 8 #(1073741823) 27232 610 #resetCharFormat 4272 27232 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 832 nil 45 850 896 419 2048 -47 928 1 944 489 18 #{UI.TextEdit} 50 20 nil 26704 50 2 8 1140850816 262145 28240 nil 482 #whiteSmoke nil 5 nil nil nil 28240 nil nil 3698 nil nil 35 #focusLost nil nil nil 562 50 1 610 #createAt:extent: 50 2 210 421 491 210 645 41 28240 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 832 nil 45 850 896 421 2048 -49 13568 3 944 41 18 #{UI.RichTextEdit} 50 22 nil 26704 50 2 8 1140855110 1 28496 nil 496 nil 5 27298 nil true 50 10 27346 1 514 #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 27410 4097 27346 1 514 #bePlain 8 '&Plain' 1 1 nil nil nil 27346 1 514 #toggleBold 8 '&Bold' 1 1 nil nil nil 27346 1 514 #toggleItalic 8 '&Italic' 1 1 nil nil nil 27346 1 514 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 27410 4097 27298 nil true 50 3 27346 1 514 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 27346 1 514 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 27346 1 514 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 27410 4097 27346 1 514 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 28496 nil nil 3698 nil nil 43 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 419 681 210 549 49 28496 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\f0\fs16 Otherwise click \b Next \b0 to continue\cf0\f1 .\par
\par
\par
\pard\qc\par
}
' 28496 610 #textLimit: 8 #(1073741823) 28496 610 #resetCharFormat 4272 28496 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 832 nil 45 850 896 419 912 549 928 681 944 49 370 4336 50 2 28240 8 'executablePath1' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 26704 610 #text: 50 1 8 'Intro' 26704 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 4 26816 27232 28240 28496 832 nil 27 3138 17 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 29712 nil nil nil 5 nil nil nil 29712 338 370 #{Core.LookupTable} 50 8 18 #{UI.ContainerView} 50 15 nil 29712 50 2 8 1140850688 131073 29824 nil 496 nil 5 nil nil nil 29824 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 29824 50 2 8 1140850944 1 29904 3426 nil false 3458 3490 #= 8 #() 3490 #hash 3552 3570 nil true 3602 8 'Resources\LagoonLogo.bmp' 3664 3680 nil 5 nil nil nil 29904 nil nil 3698 nil nil nil 30048 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 29904 610 #text: 50 1 8 'Graphic' 29904 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 29824 50 2 8 1140855108 1 30304 nil 496 nil 5 nil nil nil 30304 nil nil 3698 nil nil 41 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 30304 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 1:\cf0\f1\fs16\par
\par
\cf1\f0 Choose an ImageStripper to perform the deployment process\cf0\b0\f1\par
\par
\par
\par
}
' 30304 610 #textLimit: 8 #(1073741823) 30304 610 #resetCharFormat 4272 30304 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 4338 0 2754 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 29824 610 #text: 50 1 8 'Heading' 29824 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 30304 29904 832 nil 27 850 896 1 2048 1 928 1 944 121 18 #{UI.StaticText} 50 16 nil 29712 50 2 8 1140850944 1 30944 nil nil nil 5 nil nil nil 30944 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 229 210 979 149 30944 610 #text: 50 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 30944 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -107 928 229 944 149 18 #{UI.StaticText} 50 16 nil 29712 50 2 8 1140850944 1 31232 nil nil nil 5 nil nil nil 31232 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 401 210 249 121 31232 610 #text: 50 1 8 'Choose a the class of &ImageStripper to install.' 31232 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 832 nil 27 850 896 81 912 249 928 401 944 121 18 #{UI.ComboBox} 50 17 nil 29712 50 2 8 1144063491 1025 31520 6690 3106 0 nil 6752 496 nil 5 nil nil nil 31520 nil nil 6768 6800 401 562 50 1 610 #createAt:extent: 50 2 210 349 409 210 647 43 31520 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 832 nil 27 850 896 349 2048 -119 928 409 944 41 370 4336 50 2 31520 8 'imageStripperClass' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 29712 610 #text: 50 1 8 'Step 1' 29712 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 4 29824 30944 31232 31520 832 nil 27 3138 19 18 #{UI.ContainerView} 50 15 nil 3008 50 2 8 1140850688 131073 32032 nil nil nil 5 nil nil nil 32032 338 370 #{Core.LookupTable} 50 14 18 #{UI.ContainerView} 50 15 nil 32032 50 2 8 1140850688 131073 32144 nil 496 nil 5 nil nil nil 32144 242 19 1 nil nil 18 #{UI.ImageView} 50 21 nil 32144 50 2 8 1140850944 1 32224 3426 nil false 3458 3490 #= 8 #() 3490 #hash 3552 3570 nil true 3602 8 'Resources\LagoonLogo.bmp' 3664 3680 nil 5 nil nil nil 32224 nil nil 3698 nil nil nil 32368 #scale 1 nil nil 562 50 2 610 #createAt:extent: 50 2 210 1003 11 210 103 101 32224 610 #text: 50 1 8 'Graphic' 32224 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 832 nil 27 nil 18 #{UI.RichTextEdit} 50 22 nil 32144 50 2 8 1140855108 1 32624 nil 496 nil 5 nil nil nil 32624 nil nil 3698 nil nil 41 #focusLost nil nil nil nil 4002 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 562 50 4 610 #createAt:extent: 50 2 210 31 11 210 955 101 32624 610 #text: 50 1 4178 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Segoe UI;}}
{\colortbl ;\red0\green0\blue0;}
\viewkind4\uc1\pard\cf1\b\f0\fs20 Step 6:\fs16\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 32624 610 #textLimit: 8 #(1073741823) 32624 610 #resetCharFormat 4272 32624 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 832 nil 45 4338 0 2754 210 31 11 210 11 11 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 121 32144 610 #text: 50 1 8 'Heading' 32144 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 50 2 32624 32224 832 nil 27 850 896 1 2048 1 928 1 944 121 18 #{UI.StaticText} 50 16 nil 32032 50 2 8 1140850944 1 33264 nil nil nil 5 nil nil nil 33264 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 29 161 210 989 49 33264 610 #text: 50 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 33264 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 832 nil 27 850 896 29 2048 -97 928 161 944 49 18 #{UI.CheckBox} 50 16 nil 32032 50 2 8 1140924451 1 33552 3426 nil nil 5584 false nil nil 5 nil nil nil 33552 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 81 209 210 369 41 33552 610 #text: 50 1 8 'Remove &Class Builder' 33552 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 832 nil 27 850 896 81 912 369 928 209 944 41 18 #{UI.GroupBox} 50 14 nil 32032 50 2 8 1140850695 65 33856 nil 496 nil 5 nil nil nil 33856 nil nil 562 50 1 610 #createAt:extent: 50 2 210 1 327 210 1115 393 33856 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 832 nil 27 850 896 1 2048 1 928 327 944 393 18 #{UI.StaticText} 50 16 nil 32032 50 2 8 1140850944 1 34080 nil nil nil 5 nil nil nil 34080 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 31 391 210 967 49 34080 610 #text: 50 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 34080 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 832 nil 27 850 896 31 2048 -117 928 391 944 49 18 #{UI.CheckBox} 50 16 nil 32032 50 2 8 1140924451 1 34368 3426 nil nil 5584 true nil nil 5 nil nil nil 34368 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 71 451 210 379 49 34368 610 #text: 50 1 8 'Fold duplicate s&trings' 34368 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 832 nil 27 850 896 71 912 379 928 451 944 49 18 #{UI.CheckBox} 50 16 nil 32032 50 2 8 1140924451 1 34672 3426 nil nil 5584 true nil nil 5 nil nil nil 34672 nil nil 3698 nil nil nil 562 50 2 610 #createAt:extent: 50 2 210 71 511 210 379 41 34672 610 #text: 50 1 8 'Fold duplicate b&ytecode arrays' 34672 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 832 nil 27 850 896 71 912 379 928 511 944 41 370 4336 50 6 33552 8 'stripClassBuilder' 34672 8 'stripDuplicateBytecodes' 34368 8 'stripDuplicateStrings' nil 562 50 2 610 #createAt:extent: 50 2 210 1 1 210 1115 719 32032 610 #text: 50 1 8 'Step 6' 32032 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 50 7 32144 33264 33552 34080 34368 34672 33856 832 nil 27 26704 nil nil nil 370 4336 50 2 26704 8 'Intro' nil 562 50 1 610 #createAt:extent: 50 2 210 1 1 210 1119 723 3008 770 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 50 9 26704 29712 3168 8832 11744 19632 32032 16576 23472 832 nil 27 370 4336 50 2 3008 8 'Steps' 2754 210 1 1 210 1 1 nil nil nil nil 1 nil nil 210 2049 881 210 1151 881 1 nil nil 774 #{Core.Semaphore} nil nil 1 false nil 562 50 2 610 #createAt:extent: 50 2 210 6143 21 210 1151 881 32 610 #text: 50 1 8 'Lagoon Deployment Wizard' 32 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 62 14 0 0 194 1 0 0] 50 2 3008 272 832 nil 27)!

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

