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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 37 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 768 nil 8 1882927232 1180998 4 ##(Smalltalk.CommandDescription) #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 955 13 578 139 49 768 994 #text: 34 1 8 'Cancel' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedViewRight -137 1234 #fixedParentRight -11 1234 #fixedParentTop 1 1234 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1312 nil 848 nil 7 nil nil nil 1312 nil 8 1882927232 882 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 685 13 578 241 49 1312 994 #isEnabled: 8 #(false) 1312 994 #text: 34 1 8 '&Save Configuration' 1312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 1184 nil 29 1202 1234 #fixedPreviousRight 11 1234 #fixedViewLeft 241 1280 1 1296 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1712 nil 848 nil 7 nil nil nil 1712 nil 8 1882927232 882 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 545 13 578 131 49 1712 994 #isEnabled: 8 #(false) 1712 994 #text: 34 1 8 '&Reset' 1712 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1184 nil 29 1202 1248 -129 1264 -429 1280 1 1296 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2080 nil 848 nil 7 nil nil nil 2080 nil 8 1882927232 882 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 217 13 578 131 49 2080 994 #isEnabled: 8 #(false) 2080 994 #text: 34 1 8 '< &Back' 2080 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1184 nil 29 1202 1234 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1696 131 1280 1 1296 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2496 nil 848 nil 7 nil nil nil 2496 nil 8 1882927232 882 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 357 13 578 131 49 2496 994 #isEnabled: 8 #(false) 2496 994 #text: 34 1 8 '&Next >' 2496 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 1184 nil 29 1202 1680 11 1696 131 1280 1 1296 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2864 nil 848 nil 7 nil nil nil 2864 nil 8 1882927232 882 #deployApplication 8 '&Deploy' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 19 13 578 139 49 2864 994 #isEnabled: 8 #(false) 2864 994 #text: 34 1 8 '&Deploy' 2864 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1184 nil 29 1202 1234 #fixedParentLeft 9 1696 139 1280 1 1296 49 170 192 34 2 2864 8 'deploy' 590342 ##(Smalltalk.Rectangle) 578 11 13 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 723 578 1119 81 640 994 #text: 34 1 8 'Buttons' 640 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 2864 2080 2496 1712 1312 768 1184 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3568 nil nil nil 7 nil nil nil 3568 656710 1 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 3728 nil nil nil 5 nil nil nil 3728 706 170 176 34 28 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 3840 nil nil nil 5 nil nil nil 3840 nil 8 1882966944 852486 ##(Smalltalk.NullConverter) nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 309 578 975 71 3840 994 #text: 34 1 8 'When deployed, an executable will usually contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 3840 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 154 0 0 0 246 1 0 0 189 0 0 0] 8 #() 1184 nil 27 1202 3232 31 1264 -109 1280 309 1296 71 410 ##(Smalltalk.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 4176 nil 848 nil 5 nil nil nil 4176 nil 8 1882927232 882 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 441 661 578 139 45 4176 994 #isEnabled: 8 #(false) 4176 994 #text: 34 1 8 'S&how it' 4176 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1184 nil 29 1202 3232 441 1696 139 1280 661 1296 45 410 ##(Smalltalk.TextEdit) 34 16 nil 3728 34 2 8 1140850688 262145 4544 nil nil nil 5 nil nil nil 4544 nil 8 1882922752 3922 nil nil 1 930 138 144 34 3 994 #createAt:extent: 34 2 578 441 597 578 565 41 4544 994 #isEnabled: 8 #(false) 4544 994 #setMarginWidths: 34 1 8 #(3 3) 4544 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 42 1 0 0 246 1 0 0 62 1 0 0] 8 #() 1184 nil 27 1202 3232 441 1264 -109 1280 597 1296 41 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 4896 nil nil nil 5 nil nil nil 4896 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 499 578 1045 81 4896 994 #text: 34 1 8 'The deployment process can write an XML log file that describes the deployment actions performed and includes a manifest of the classes and methods remaining in the image. The manifest can be used to browse the contents of the application and may be useful for debugging deployment problems.' 4896 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 249 0 0 0 25 2 0 0 33 1 0 0] 8 #() 1184 nil 27 1202 3232 31 1264 -39 1280 499 1296 81 410 ##(Smalltalk.PushButton) 34 20 nil 3728 34 2 8 1140924416 1 5216 nil 848 nil 5 nil nil nil 5216 nil 8 1882927232 882 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 1025 151 578 49 41 5216 994 #isEnabled: 8 #(false) 5216 994 #text: 34 1 8 '...' 5216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1184 nil 29 1202 1248 -47 1264 -41 1280 151 1296 41 410 ##(Smalltalk.ComboBox) 34 17 nil 3728 34 2 8 1144063491 1025 5584 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 848 nil 5 nil nil nil 5584 nil 8 1882476752 ##(Smalltalk.BasicListAbstract) 8 #() 401 930 138 144 34 1 994 #createAt:extent: 34 2 578 441 399 578 565 43 5584 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 199 0 0 0 246 1 0 0 220 0 0 0] 8 #() 1184 nil 27 1202 3232 441 1264 -109 1280 399 1296 43 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 5952 nil nil nil 5 nil nil nil 5952 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 141 578 389 81 5952 994 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 5952 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 8 #() 1184 nil 27 1202 3232 31 1696 389 1280 141 1296 81 410 ##(Smalltalk.GroupBox) 34 14 nil 3728 34 2 8 1140850695 65 6272 nil 848 nil 5 nil nil nil 6272 nil 8 1882927232 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 279 578 1155 211 6272 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 139 0 0 0 65 2 0 0 244 0 0 0] 8 #() 1184 nil 27 1202 3232 1 1264 41 1280 279 1296 211 410 ##(Smalltalk.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 6528 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) true nil nil 5 nil nil nil 6528 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 597 578 251 41 6528 994 #text: 34 1 8 'Write &log file' 6528 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 42 1 0 0 155 0 0 0 62 1 0 0] 8 #() 1184 nil 27 1202 3232 61 1696 251 1280 597 1296 41 410 ##(Smalltalk.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 6912 6594 nil nil 6640 false nil nil 5 nil nil nil 6912 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 211 578 431 81 6912 994 #text: 34 1 8 'Create single file, "To Go" distributable.' 6912 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1184 nil 27 1202 3232 31 1696 431 1280 211 1296 81 410 ##(Smalltalk.TextEdit) 34 16 nil 3728 34 2 8 1140916352 1025 7248 nil 848 nil 5 nil nil nil 7248 nil 8 1882922752 3922 nil nil 1 930 138 144 34 2 994 #createAt:extent: 34 2 578 431 151 578 575 41 7248 994 #setMarginWidths: 34 1 8 #(3 3) 7248 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1184 nil 27 1202 3232 431 1264 -109 1280 151 1296 41 410 ##(Smalltalk.StaticText) 34 16 nil 3728 34 2 8 1140850944 1 7568 nil nil nil 5 nil nil nil 7568 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 43 387 578 381 81 7568 994 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 7568 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 193 0 0 0 211 0 0 0 233 0 0 0] 8 #() 1184 nil 27 1202 3232 43 1696 381 1280 387 1296 81 410 ##(Smalltalk.CheckBox) 34 16 nil 3728 34 2 8 1140924451 1 7888 6594 nil nil 6640 true nil nil 5 nil nil nil 7888 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 661 578 251 41 7888 994 #text: 34 1 8 'Log &class references' 7888 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1184 nil 27 1202 3232 61 1696 251 1280 661 1296 41 410 ##(Smalltalk.ContainerView) 34 15 nil 3728 34 2 8 1140850688 131073 8224 nil 848 nil 5 nil nil nil 8224 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 8224 34 2 8 1140850944 1 8304 6594 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 8418 #hash 8 #() 657478 3 ##(Smalltalk.OLEPicture) nil true 1703942 ##(Smalltalk.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 524806 ##(Smalltalk.IPicture) nil nil 578 321 327 578 8467 8627 834 #face3d nil 5 nil nil nil 8304 nil 8 4294902547 3922 nil nil nil 8512 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 8304 994 #text: 34 1 8 'Graphic' 8304 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1184 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 8224 34 2 8 1140855108 1 8944 nil 848 nil 5 nil nil nil 8944 nil 8 1520731616 3922 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 8944 994 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 2: \par
\par
Choose an Executable File and RuntimeSessionManager\par
\par
\par
\par
}
' 8944 994 #textLimit: 8 #(1073741823) 8944 994 #resetCharFormat 5696 8944 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1184 nil 27 170 192 5696 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 8224 994 #text: 34 1 8 'Heading' 8224 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 8944 8304 1184 nil 27 1202 3232 1 1264 1 1280 1 1296 121 170 192 34 14 5584 8 'runtimeSessionManagerClass' 4176 8 'showLog' 4544 8 'logFileName' 6912 8 'isToGo' 7888 8 'logReferencesToClasses' 7248 8 'executableName' 6528 8 'writeLogFile' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 3728 994 #text: 34 1 8 'Step 2' 3728 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 8224 5952 7248 5216 6912 3840 7568 5584 4896 6528 7888 4544 4176 6272 1184 nil 27 3698 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 10032 nil nil nil 5 nil nil nil 10032 706 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 10032 34 2 8 1140850944 1 10144 nil nil nil 5 nil nil nil 10144 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 499 578 979 109 10144 994 #text: 34 1 8 'The code removal process is most effective if begun by removing redundant packages. Selecting this option (recommended) will uninstall any packages that are not pre-requisites of the root package above.' 10144 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -107 1280 499 1296 109 410 ##(Smalltalk.CheckBox) 34 16 nil 10032 34 2 8 1140924451 1 10464 6594 nil nil 6640 true nil nil 5 nil nil nil 10464 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 59 599 578 329 49 10464 994 #text: 34 1 8 'Remove redundant &packages' 10464 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 43 1 0 0 193 0 0 0 67 1 0 0] 8 #() 1184 nil 27 1202 3232 59 1696 329 1280 599 1296 49 410 ##(Smalltalk.StaticText) 34 16 nil 10032 34 2 8 1140850944 1 10800 nil nil nil 5 nil nil nil 10800 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 171 578 975 191 10800 994 #text: 34 1 8 'Deployment is based on a root package in order to best determine the redundant objects in the image that can be removed. Note also that the deployment configuration will be saved in the root package.

Currently the deployment is configured to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 10800 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1184 nil 27 1202 3232 31 1264 -109 1280 171 1296 191 410 ##(Smalltalk.StaticText) 34 16 nil 10032 34 2 8 1140850944 262145 11120 nil nil nil 5 nil nil nil 11120 nil 8 1882966944 3922 nil nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 361 389 578 647 41 11120 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1184 nil 27 1202 3232 361 1264 -107 1280 389 1296 41 410 ##(Smalltalk.ContainerView) 34 15 nil 10032 34 2 8 1140850688 131073 11392 nil 848 nil 5 nil nil nil 11392 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 11392 34 2 8 1140850944 1 11472 6594 nil false 8386 8418 #= 8 #() 8418 #hash 8480 8498 nil true 8544 8 'Resources\LagoonLogo.bmp' 8592 8626 nil nil 578 321 327 578 8467 8627 8688 nil 5 nil nil nil 11472 nil 8 4294902547 3922 nil nil nil 11616 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 11472 994 #text: 34 1 8 'Graphic' 11472 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1184 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 11392 34 2 8 1140855108 1 11936 nil 848 nil 5 nil nil nil 11936 nil 8 1520731616 3922 nil nil 41 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 11936 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 3:\par
\par
Configure how the ImageStripper removes unwanted packages\par
\par
\par
\par
}
' 11936 994 #textLimit: 8 #(1073741823) 11936 994 #resetCharFormat 5696 11936 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1184 nil 27 170 192 5696 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 11392 994 #text: 34 1 8 'Heading' 11392 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 11936 11472 1184 nil 27 1202 3232 1 1264 1 1280 1 1296 121 410 ##(Smalltalk.StaticText) 34 16 nil 10032 34 2 8 1140850944 1 12624 nil nil nil 5 nil nil nil 12624 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 389 578 201 41 12624 994 #text: 34 1 8 'Root package:' 12624 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1184 nil 27 1202 3232 81 1696 201 1280 389 1296 41 170 192 34 4 11120 8 'rootPackage' 10464 8 'stripRedundantPackages' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 10032 994 #text: 34 1 8 'Step 3' 10032 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 11392 10800 12624 11120 10144 10464 1184 nil 27 3698 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 13232 nil nil nil 5 nil nil nil 13232 706 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 nil 13232 34 2 8 1140924451 1 13344 6594 nil nil 6640 true nil nil 5 nil nil nil 13344 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 217 578 441 49 13344 994 #text: 34 1 8 'Remove redundant &classes' 13344 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 108 0 0 0 250 0 0 0 132 0 0 0] 8 #() 1184 nil 27 1202 3232 61 1696 441 1234 #fixedPreviousBottom 1 1296 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13232 34 2 8 1140924451 1 13696 6594 nil nil 6640 false nil nil 5 nil nil nil 13696 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 581 578 441 49 13696 994 #text: 34 1 8 'Remove #&deprecated methods' 13696 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 34 1 0 0 250 0 0 0 58 1 0 0] 8 #() 1184 nil 27 1202 3232 61 1696 441 13680 1 1296 49 410 ##(Smalltalk.StaticText) 34 16 nil 13232 34 2 8 1140850944 1 14032 nil nil nil 5 nil nil nil 14032 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 1029 69 14032 994 #text: 34 1 8 'The deployment process automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be removed (recommended).' 14032 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -57 1280 149 1296 69 410 ##(Smalltalk.StaticText) 34 16 nil 13232 34 2 8 1140850944 1 14352 nil nil nil 5 nil nil nil 14352 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 315 578 1019 121 14352 994 #text: 34 1 8 'Given a set of of classes that have been determined to be required in the application, it is then possible to determine the methods that can should never be called so that these can be removed. This step may inadvertently remove some methods that are only called reflectively, i.e. by #perform:. Aspect setting methods are commonly invoked in this manner and you can opt to forcibly preserve these.' 14352 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -67 13680 51 1296 121 410 ##(Smalltalk.StaticText) 34 16 nil 13232 34 2 8 1140850944 1 14672 nil nil nil 5 nil nil nil 14672 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 533 578 1079 49 14672 994 #text: 34 1 8 'Some methods which may not be identified as redundant can also be removed.' 14672 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -7 13680 51 1296 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13232 34 2 8 1140924451 1 14992 6594 nil nil 6640 false nil nil 5 nil nil nil 14992 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 645 578 441 49 14992 994 #text: 34 1 8 'Remove #&subclassResponsibility methods' 14992 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 66 1 0 0 250 0 0 0 90 1 0 0] 8 #() 1184 nil 27 1202 3232 61 1696 441 13680 17 1296 49 410 ##(Smalltalk.ContainerView) 34 15 nil 13232 34 2 8 1140850688 131073 15328 nil 848 nil 5 nil nil nil 15328 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 15328 34 2 8 1140850944 1 15408 6594 nil false 8386 8418 #= 8 #() 8418 #hash 8480 8498 nil true 8544 8 'Resources\LagoonLogo.bmp' 8592 8626 nil nil 578 321 327 578 8467 8627 8688 nil 5 nil nil nil 15408 nil 8 4294902547 3922 nil nil nil 15552 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 15408 994 #text: 34 1 8 'Graphic' 15408 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1184 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 15328 34 2 8 1140855108 1 15872 nil 848 nil 5 nil nil nil 15872 nil 8 1520731616 3922 nil nil 41 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 15872 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 4:\par
\par
Configure how the ImageStripper removes unwanted classes and methods\par
\par
\par
\par
}
' 15872 994 #textLimit: 8 #(1073741823) 15872 994 #resetCharFormat 5696 15872 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1184 nil 27 170 192 5696 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 15328 994 #text: 34 1 8 'Heading' 15328 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 15872 15408 1184 nil 27 1202 3232 1 1264 1 1280 1 1296 121 410 ##(Smalltalk.CheckBox) 34 16 nil 13232 34 2 8 1140924451 1 16560 6594 nil nil 6640 false nil nil 5 nil nil nil 16560 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 581 578 423 49 16560 994 #text: 34 1 8 'Remove #shouldNot&Implement methods' 16560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1184 nil 27 1202 1680 121 1696 423 1234 #fixedPreviousTop 1 1296 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13232 34 2 8 1140924451 1 16912 6594 nil nil 6640 false nil nil 5 nil nil nil 16912 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 435 578 423 49 16912 994 #text: 34 1 8 'Preserve &aspect set methods' 16912 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1184 nil 27 1202 1680 121 1696 423 16896 1 1296 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13232 34 2 8 1140924451 1 17248 6594 nil nil 6640 true nil nil 5 nil nil nil 17248 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 621 217 578 423 49 17248 994 #text: 34 1 8 'Remove redundant &resources' 17248 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 54 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1184 nil 27 1202 1680 121 1696 423 16896 1 1296 49 410 ##(Smalltalk.GroupBox) 34 14 nil 13232 34 2 8 1140850695 65 17584 nil 848 nil 5 nil nil nil 17584 nil 8 1882927232 930 138 144 34 1 994 #createAt:extent: 34 2 578 -17 281 578 1151 229 17584 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1184 nil 27 1202 3232 -17 1264 19 1280 281 1296 229 410 ##(Smalltalk.CheckBox) 34 16 nil 13232 34 2 8 1140924451 1 17840 6594 nil nil 6640 false nil nil 5 nil nil nil 17840 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 61 435 578 441 49 17840 994 #text: 34 1 8 'Remove redundant &methods' 17840 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 217 0 0 0 250 0 0 0 241 0 0 0] 8 #() 1184 nil 27 1202 3232 61 1696 441 13680 1 1296 49 170 192 34 14 13696 8 'stripDeprecatedMethods' 17840 8 'stripRedundantMethods' 13344 8 'stripRedundantClasses' 16912 8 'preserveAspectSetters' 17248 8 'stripRedundantResources' 16560 8 'stripShouldNotImplement' 14992 8 'stripSubclassResponsibility' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 13232 994 #text: 34 1 8 'Step 4' 13232 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 15328 14032 13344 17248 14352 17840 16912 14672 13696 16560 14992 17584 1184 nil 27 3698 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 18544 nil nil nil 5 nil nil nil 18544 706 170 176 34 12 410 ##(Smalltalk.ContainerView) 34 15 nil 18544 34 2 8 1140850688 131073 18656 nil 848 nil 5 nil nil nil 18656 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 18656 34 2 8 1140850944 1 18736 6594 nil false 8386 8418 #= 8 #() 8418 #hash 8480 8498 nil true 8544 8 'Resources\LagoonLogo.bmp' 8592 8626 nil nil 578 321 327 578 8467 8627 8688 nil 5 nil nil nil 18736 nil 8 4294902547 3922 nil nil nil 18880 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 18736 994 #text: 34 1 8 'Graphic' 18736 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1184 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 18656 34 2 8 1140855108 1 19200 nil 848 nil 5 nil nil nil 19200 nil 8 1520731616 3922 nil nil 41 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 19200 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 7:\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\par
}
' 19200 994 #textLimit: 8 #(1073741823) 19200 994 #resetCharFormat 5696 19200 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1184 nil 27 170 192 5696 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 18656 994 #text: 34 1 8 'Heading' 18656 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 19200 18736 1184 nil 27 1202 3232 1 1264 1 1280 1 1296 121 410 ##(Smalltalk.ReferenceView) 34 14 nil 18544 34 2 8 1140850688 131073 19888 nil nil nil 5 nil nil nil 19888 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 33 327 578 1041 241 19888 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 163 0 0 0 24 2 0 0 27 1 0 0] 5696 1184 nil 27 1202 3232 33 1264 -41 1280 327 1296 241 410 ##(Smalltalk.StaticText) 34 16 nil 18544 34 2 8 1140850944 1 20144 nil nil nil 5 nil nil nil 20144 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 651 578 791 71 20144 994 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 20144 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1184 nil 27 1202 3232 31 1696 791 1280 651 1296 71 410 ##(Smalltalk.PushButton) 34 20 nil 18544 34 2 8 1140924416 1 20464 nil 848 nil 5 nil nil nil 20464 nil 8 1882927232 882 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 930 138 144 34 3 994 #createAt:extent: 34 2 578 881 661 578 211 51 20464 994 #isEnabled: 8 #(false) 20464 994 #text: 34 1 8 'Custom &Options' 20464 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1184 nil 29 1202 3232 881 1696 211 1280 661 1296 51 410 ##(Smalltalk.StatusBar) 34 18 nil 18544 34 2 8 1140850700 1 20832 nil nil nil 5 nil 498 nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 20832 nil 8 1882458128 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 20832 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'preStripScriptErrors' 138 144 34 1 21040 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 20832 nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 31 571 578 1047 41 20832 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 8 #() 1184 nil 27 1202 3232 31 1264 -37 1280 571 1296 41 410 ##(Smalltalk.StaticText) 34 16 nil 18544 34 2 8 1140850944 1 21312 nil nil nil 5 nil nil nil 21312 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 33 133 578 1041 181 21312 994 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the deployment process starts. You can do this using the pre-deployment script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 21312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 66 0 0 0 24 2 0 0 156 0 0 0] 8 #() 1184 nil 27 1202 3232 33 1264 -41 1280 133 1296 181 170 192 34 2 19888 8 'preStripScript' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 18544 994 #text: 34 1 8 'Step 7' 18544 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 18656 21312 19888 20832 20144 20464 1184 nil 27 3698 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 21904 nil nil nil 5 nil nil nil 21904 706 170 176 34 18 410 ##(Smalltalk.GroupBox) 34 14 nil 21904 34 2 8 1140850695 65 22016 nil 848 nil 5 nil nil nil 22016 nil 8 1882927232 930 138 144 34 1 994 #createAt:extent: 34 2 578 -17 521 578 1151 229 22016 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1184 nil 27 1202 3232 -17 1264 19 1280 521 1296 229 410 ##(Smalltalk.CheckBox) 34 16 nil 21904 34 2 8 1140924451 1 22272 6594 nil nil 6640 false nil nil 5 nil nil nil 22272 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 389 578 369 69 22272 994 #text: 34 1 8 'Retain instance &variable names' 22272 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1184 nil 27 1202 3232 81 1696 369 1280 389 1296 69 410 ##(Smalltalk.CheckBox) 34 16 nil 21904 34 2 8 1140924451 1 22608 6594 nil nil 6640 true nil nil 5 nil nil nil 22608 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 249 578 369 59 22608 994 #text: 34 1 8 'Remove class meta-&information' 22608 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1184 nil 27 1202 3232 81 1696 369 1280 249 1296 59 410 ##(Smalltalk.StaticText) 34 16 nil 21904 34 2 8 1140850944 1 22944 nil nil nil 5 nil nil nil 22944 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 549 578 979 89 22944 994 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 22944 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -107 1280 549 1296 89 410 ##(Smalltalk.StaticText) 34 16 nil 21904 34 2 8 1140850944 1 23264 nil nil nil 5 nil nil nil 23264 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 149 578 979 99 23264 994 #text: 34 1 8 'Class category information is automatically removed from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 23264 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -107 1280 149 1296 99 410 ##(Smalltalk.CheckBox) 34 16 nil 21904 34 2 8 1140924451 1 23584 6594 nil nil 6640 false nil nil 5 nil nil nil 23584 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 649 578 369 49 23584 994 #text: 34 1 8 'Compile E&xternal Structures' 23584 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1184 nil 27 1202 3232 81 1696 369 1280 649 1296 49 410 ##(Smalltalk.ContainerView) 34 15 nil 21904 34 2 8 1140850688 131073 23920 nil 848 nil 5 nil nil nil 23920 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 23920 34 2 8 1140850944 1 24000 6594 nil false 8386 8418 #= 8 #() 8418 #hash 8480 8498 nil true 8544 8 'Resources\LagoonLogo.bmp' 8592 8626 nil nil 578 321 327 578 8467 8627 8688 nil 5 nil nil nil 24000 nil 8 4294902547 3922 nil nil nil 24144 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 24000 994 #text: 34 1 8 'Graphic' 24000 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1184 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 23920 34 2 8 1140855108 1 24464 nil 848 nil 5 nil nil nil 24464 nil 8 1520731616 3922 nil nil 41 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 24464 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 5:\par
\par
Decide what meta-level information is required at runtime\par
\par
\par
\par
}
' 24464 994 #textLimit: 8 #(1073741823) 24464 994 #resetCharFormat 5696 24464 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1184 nil 27 170 192 5696 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 23920 994 #text: 34 1 8 'Heading' 23920 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 24464 24000 1184 nil 27 1202 3232 1 1264 1 1280 1 1296 121 410 ##(Smalltalk.CheckBox) 34 16 nil 21904 34 2 8 1140924451 1 25152 6594 nil nil 6640 false nil nil 5 nil nil nil 25152 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 459 578 369 41 25152 994 #text: 34 1 8 'Remove class &GUIDs' 25152 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1184 nil 27 1202 3232 81 1696 369 1280 459 1296 41 410 ##(Smalltalk.StaticText) 34 16 nil 21904 34 2 8 1140850944 1 25488 nil nil nil 5 nil nil nil 25488 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 321 578 979 69 25488 994 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 25488 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -107 1280 321 1296 69 170 192 34 8 23584 8 'compileExternalStructures' 22608 8 'stripClassInfo' 22272 8 'retainInstVarNames' 25152 8 'stripClassGuids' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 21904 994 #text: 34 1 8 'Step 5' 21904 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 23920 23264 22608 25488 22272 25152 22944 23584 22016 1184 nil 27 3698 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 26128 nil nil nil 5 nil nil nil 26128 706 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 26128 34 2 8 1140850944 1 26240 nil nil nil 5 nil 498 nil true 20914 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 20960 nil 26240 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 349 578 989 139 26240 994 #text: 34 1 8 'Your development image will first be saved in its current state. 

The deployment process that follows may take a minute or two depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that deployment is complete.' 26240 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -97 1280 349 1296 139 410 ##(Smalltalk.ContainerView) 34 15 nil 26128 34 2 8 1140850688 131073 26608 nil 848 nil 5 nil nil nil 26608 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 26608 34 2 8 1140850944 1 26688 6594 nil false 8386 8418 #= 8 #() 8418 #hash 8480 8498 nil true 8544 8 'Resources\LagoonLogo.bmp' 8592 8626 nil nil 578 321 327 578 8467 8627 8688 nil 5 nil nil nil 26688 nil 8 4294902547 3922 nil nil nil 26832 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 26688 994 #text: 34 1 8 'Graphic' 26688 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1184 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 26608 34 2 8 1140855108 1 27152 nil 848 nil 5 nil nil nil 27152 nil 8 1520731616 3922 nil nil 41 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 27152 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Final Step:\par
\par
Deployment\par
\par
\par
\par
}
' 27152 994 #textLimit: 8 #(1073741823) 27152 994 #resetCharFormat 5696 27152 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1184 nil 27 170 192 5696 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 26608 994 #text: 34 1 8 'Heading' 26608 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 27152 26688 1184 nil 27 1202 3232 1 1264 1 1280 1 1296 121 410 ##(Smalltalk.StaticText) 34 16 nil 26128 34 2 8 1140850955 262145 27840 nil nil nil 5 nil nil nil 27840 nil 8 1882966944 3922 nil nil nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 281 269 578 737 41 27840 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1184 nil 27 1202 3232 281 1264 -97 1280 269 1296 41 410 ##(Smalltalk.StaticText) 34 16 nil 26128 34 2 8 1140850944 1 28112 nil nil nil 5 nil nil nil 28112 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 161 578 989 81 28112 994 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the deployment options you have chosen. To do this click ''Deploy''.
' 28112 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -97 1280 161 1296 81 410 ##(Smalltalk.StaticText) 34 16 nil 26128 34 2 8 1140850944 1 28432 nil nil nil 5 nil nil nil 28432 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 269 578 189 49 28432 994 #text: 34 1 8 'E&xecutable name:' 28432 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1184 nil 27 1202 3232 81 1696 189 1280 269 1296 49 410 ##(Smalltalk.StaticText) 34 16 nil 26128 34 2 8 1140850944 1 28752 nil nil nil 5 nil 498 nil true 20914 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 20960 nil 28752 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 529 578 949 81 28752 994 #text: 34 1 8 'It is very important that, should the deployment operation fail for whatever reason, you do not save the partially stripped image. If it does fail, you can find diagnostic information in the normal Dolphin error log and/or the deployment log.' 28752 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -137 1280 529 1296 81 410 ##(Smalltalk.StaticText) 34 16 nil 26128 34 2 8 1140850944 1 29120 nil nil nil 5 nil nil nil 29120 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 641 578 979 59 29120 994 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 29120 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -107 1280 641 1296 59 170 192 34 2 27840 8 'executablePath2' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 26128 994 #text: 34 1 8 'Final step' 26128 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 26608 28112 28432 27840 28752 26240 29120 1184 nil 27 3698 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 29712 nil 848 nil 7 nil nil nil 29712 706 170 176 34 8 410 ##(Smalltalk.RichTextEdit) 34 18 nil 29712 34 2 8 1140855110 1 29824 nil 848 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 882 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 29938 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29938 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29938 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29938 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 30002 4097 29890 nil true 34 3 29938 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29938 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29938 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 30002 4097 29938 1 882 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29824 nil 8 1520731616 3922 nil nil 43 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 5 994 #createAt:extent: 34 2 578 419 1 578 649 489 29824 994 #contextMenu: 34 1 29904 29824 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
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
' 29824 994 #textLimit: 8 #(1073741823) 29824 994 #resetCharFormat 5696 29824 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1184 nil 27 1202 3232 419 1264 -47 1280 1 1296 489 410 ##(Smalltalk.ImageView) 34 21 nil 29712 34 2 8 1140850944 1 30896 6594 nil false 8386 8418 #= 8 #() 8418 #hash 8480 8498 nil true 8544 8 'Resources\LagoonSideBar.jpg' 8592 8626 nil nil 578 381 761 578 10055 20109 848 nil 7 nil nil nil 30896 nil 8 4294902547 3922 nil nil nil 31040 #centered 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 379 741 30896 994 #text: 34 1 8 'Lagoon Graphic' 30896 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1184 nil 27 1202 3232 1 1696 379 1280 1 1296 741 410 ##(Smalltalk.RichTextEdit) 34 18 nil 29712 34 2 8 1140855110 1 31376 nil 848 nil 7 29890 nil true 34 10 29938 1 882 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 30002 4097 29938 1 882 #bePlain 8 '&Plain' 1 1 nil nil nil 29938 1 882 #toggleBold 8 '&Bold' 1 1 nil nil nil 29938 1 882 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29938 1 882 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 30002 4097 29890 nil true 34 3 29938 1 882 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29938 1 882 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29938 1 882 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 30002 4097 29938 1 882 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 31376 nil 8 1520731616 3922 nil nil 43 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 5 994 #createAt:extent: 34 2 578 419 681 578 549 49 31376 994 #contextMenu: 34 1 31440 31376 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click Next to continue.\par
\par
\par
\pard\qc\par
}
' 31376 994 #textLimit: 8 #(1073741823) 31376 994 #resetCharFormat 5696 31376 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1184 nil 27 1202 3232 419 1696 549 1280 681 1296 49 410 ##(Smalltalk.TextEdit) 34 16 nil 29712 34 2 8 1140850816 262145 32400 nil 834 #whiteSmoke nil 7 nil nil nil 32400 nil 8 1882922752 3922 nil nil 35 930 138 144 34 2 994 #createAt:extent: 34 2 578 421 491 578 645 41 32400 994 #setMarginWidths: 34 1 8 #(3 3) 32400 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1184 nil 27 1202 3232 421 1264 -49 13680 3 1296 41 170 192 34 2 32400 8 'executablePath1' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 29712 994 #text: 34 1 8 'Intro' 29712 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 30896 29824 32400 31376 1184 nil 27 3698 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 33008 nil nil nil 5 nil nil nil 33008 706 170 176 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 33008 34 2 8 1144063491 1025 33120 5650 138 144 5696 nil 5728 848 nil 5 nil nil nil 33120 nil 8 1882476752 ##(Smalltalk.BasicListAbstract) 5760 401 930 138 144 34 1 994 #createAt:extent: 34 2 578 349 409 578 647 43 33120 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1184 nil 27 1202 3232 349 1264 -119 1280 409 1296 41 410 ##(Smalltalk.StaticText) 34 16 nil 33008 34 2 8 1140850944 1 33408 nil nil nil 5 nil nil nil 33408 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 229 578 979 149 33408 994 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33408 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -107 1280 229 1296 149 410 ##(Smalltalk.StaticText) 34 16 nil 33008 34 2 8 1140850944 1 33728 nil nil nil 5 nil nil nil 33728 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 401 578 249 121 33728 994 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 33728 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1184 nil 27 1202 3232 81 1696 249 1280 401 1296 121 410 ##(Smalltalk.ContainerView) 34 15 nil 33008 34 2 8 1140850688 131073 34048 nil 848 nil 5 nil nil nil 34048 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 34048 34 2 8 1140850944 1 34128 6594 nil false 8386 8418 #= 8 #() 8418 #hash 8480 8498 nil true 8544 8 'Resources\LagoonLogo.bmp' 8592 8626 nil nil 578 321 327 578 8467 8627 8688 nil 5 nil nil nil 34128 nil 8 4294902547 3922 nil nil nil 34272 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 34128 994 #text: 34 1 8 'Graphic' 34128 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1184 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 34048 34 2 8 1140855108 1 34592 nil 848 nil 5 nil nil nil 34592 nil 8 1520731616 3922 nil nil 41 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 34592 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 1:\par
\par
Choose an ImageStripper to perform the deployment process\par
\par
\par
\par
}
' 34592 994 #textLimit: 8 #(1073741823) 34592 994 #resetCharFormat 5696 34592 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1184 nil 27 170 192 5696 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 34048 994 #text: 34 1 8 'Heading' 34048 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 34592 34128 1184 nil 27 1202 3232 1 1264 1 1280 1 1296 121 170 192 34 2 33120 8 'imageStripperClass' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 33008 994 #text: 34 1 8 'Step 1' 33008 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 34048 33408 33728 33120 1184 nil 27 3698 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 35552 nil nil nil 5 nil nil nil 35552 706 170 176 34 14 410 ##(Smalltalk.CheckBox) 34 16 nil 35552 34 2 8 1140924451 1 35664 6594 nil nil 6640 true nil nil 5 nil nil nil 35664 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 71 511 578 379 41 35664 994 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 35664 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1184 nil 27 1202 3232 71 1696 379 1280 511 1296 41 410 ##(Smalltalk.GroupBox) 34 14 nil 35552 34 2 8 1140850695 65 36000 nil 848 nil 5 nil nil nil 36000 nil 8 1882927232 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 327 578 1115 393 36000 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1184 nil 27 1202 3232 1 1264 1 1280 327 1296 393 410 ##(Smalltalk.CheckBox) 34 16 nil 35552 34 2 8 1140924451 1 36256 6594 nil nil 6640 true nil nil 5 nil nil nil 36256 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 71 451 578 379 49 36256 994 #text: 34 1 8 'Fold duplicate s&trings' 36256 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1184 nil 27 1202 3232 71 1696 379 1280 451 1296 49 410 ##(Smalltalk.StaticText) 34 16 nil 35552 34 2 8 1140850944 1 36592 nil nil nil 5 nil nil nil 36592 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 31 391 578 967 49 36592 994 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 36592 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1184 nil 27 1202 3232 31 1264 -117 1280 391 1296 49 410 ##(Smalltalk.StaticText) 34 16 nil 35552 34 2 8 1140850944 1 36912 nil nil nil 5 nil nil nil 36912 nil 8 1882966944 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 29 161 578 989 49 36912 994 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 36912 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1184 nil 27 1202 3232 29 1264 -97 1280 161 1296 49 410 ##(Smalltalk.ContainerView) 34 15 nil 35552 34 2 8 1140850688 131073 37232 nil 848 nil 5 nil nil nil 37232 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 37232 34 2 8 1140850944 1 37312 6594 nil false 8386 8418 #= 8 #() 8418 #hash 8480 8498 nil true 8544 8 'Resources\LagoonLogo.bmp' 8592 8626 nil nil 578 321 327 578 8467 8627 8688 nil 5 nil nil nil 37312 nil 8 4294902547 3922 nil nil nil 37456 #scale 1 nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1003 11 578 103 101 37312 994 #text: 34 1 8 'Graphic' 37312 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1184 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 37232 34 2 8 1140855108 1 37776 nil 848 nil 5 nil nil nil 37776 nil 8 1520731616 3922 nil nil 41 nil 9042 8 #[0 0 0 0 0 0 0 0 176 0 176 4] 930 138 144 34 4 994 #createAt:extent: 34 2 578 31 11 578 955 101 37776 994 #text: 34 1 9234 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Segoe UI;}}
\viewkind4\uc1\pard\f0\fs16 Step 6:\par
\par
Miscellaneous stripping options\par
\par
\par
\par
}
' 37776 994 #textLimit: 8 #(1073741823) 37776 994 #resetCharFormat 5696 37776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1184 nil 27 170 192 5696 3298 578 31 11 578 11 11 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 121 37232 994 #text: 34 1 8 'Heading' 37232 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 37776 37312 1184 nil 27 1202 3232 1 1264 1 1280 1 1296 121 410 ##(Smalltalk.CheckBox) 34 16 nil 35552 34 2 8 1140924451 1 38464 6594 nil nil 6640 false nil nil 5 nil nil nil 38464 nil 8 1882927232 3922 nil nil nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 81 209 578 369 41 38464 994 #text: 34 1 8 'Remove &Class Builder' 38464 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1184 nil 27 1202 3232 81 1696 369 1280 209 1296 41 170 192 34 6 38464 8 'stripClassBuilder' 36256 8 'stripDuplicateStrings' 35664 8 'stripDuplicateBytecodes' nil 930 138 144 34 2 994 #createAt:extent: 34 2 578 1 1 578 1115 719 35552 994 #text: 34 1 8 'Step 6' 35552 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 37232 36912 38464 36592 36256 35664 36000 1184 nil 27 29712 nil nil nil 170 192 34 2 29712 8 'Intro' nil 930 138 144 34 1 994 #createAt:extent: 34 2 578 1 1 578 1119 723 3568 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 29712 33008 3728 10032 13232 21904 35552 18544 26128 1184 nil 27 170 192 34 2 3568 8 'Steps' 3298 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2011199040 930 138 144 34 2 994 #createAt:extent: 34 2 578 12287 21 578 1151 881 416 994 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 62 26 0 0 194 1 0 0] 34 2 3568 640 1184 nil 27 )!

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

