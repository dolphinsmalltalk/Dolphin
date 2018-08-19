"Filed out from Dolphin Smalltalk 7"!

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
!ApplicationDeploymentWizard categoriesForClass!Development!MVP-Presenters! !
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

deploy
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

	command == #deploy ifTrue: [
		query isEnabled: self canDeploy.
		^true].

	command == #showLog ifTrue: [
		query isEnabled: self hasExistingLog.
		^true].

	^super queryCommand: query
!

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

	EnvironmentBrowserShell show browseExecutableManfiestFile: logFileName value!

strip
	"Private - Strips the image according to the receiver's image stripper
	and deploys it to an executable file. The development system will exit 
	following this action"

	self class saveImageOnDeploy ifTrue: [Smalltalk developmentSystem saveImage].
	"Queue a deferred action to strip the image in such a way as to allow the receiver to be
	GC'd. In order to reduce the references from the deferred action we eschew the use of a
	block here - this is important to effective image stripping, as otherwise this wizard would
	end up in the affecting the outcome. Even with full block closures in D6 the use of a block
	would still end up creating a referenced to the deployment wizard class through the method
	reference."
	SessionManager inputState 
		queueDeferredAction: (MessageSend receiver: self value selector: #stripAndSaveWithProgress)!

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
!ApplicationDeploymentWizard categoriesFor: #accept!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #addToCommandRoute:!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #apply!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #browseForExecutableName!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #canDeploy!public!testing! !
!ApplicationDeploymentWizard categoriesFor: #createComponents!initializing!public! !
!ApplicationDeploymentWizard categoriesFor: #createSchematicWiring!initializing!public! !
!ApplicationDeploymentWizard categoriesFor: #defaultExtension!constants!private! !
!ApplicationDeploymentWizard categoriesFor: #deploy!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #exeFileTypes!constants!private! !
!ApplicationDeploymentWizard categoriesFor: #hasExistingLog!public!testing! !
!ApplicationDeploymentWizard categoriesFor: #hasLog!public!testing! !
!ApplicationDeploymentWizard categoriesFor: #help!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #model:!accessing!public! !
!ApplicationDeploymentWizard categoriesFor: #onExecutableNameChanged!event handling!private! !
!ApplicationDeploymentWizard categoriesFor: #onImageStripperClassChanged!event handling!private! !
!ApplicationDeploymentWizard categoriesFor: #onViewOpened!event handling!public! !
!ApplicationDeploymentWizard categoriesFor: #queryCommand:!commands!private! !
!ApplicationDeploymentWizard categoriesFor: #refreshContents!accessing!private! !
!ApplicationDeploymentWizard categoriesFor: #reset!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #sessionManagerOrShellChoices!accessing!private! !
!ApplicationDeploymentWizard categoriesFor: #showLog!commands!public! !
!ApplicationDeploymentWizard categoriesFor: #strip!commands!private! !
!ApplicationDeploymentWizard categoriesFor: #validateUserInterface!operations!public! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 786950 ##(Smalltalk.ThemeColor) #dialog nil 39 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 15 1 31 86 135 1] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 7 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 768 nil 8 1912725136 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 685 13 578 241 49 768 1010 #isEnabled: 8 #(false) 768 1010 #text: 34 1 8 '&Save Configuration' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedPreviousRight 11 1282 #fixedViewLeft 241 1282 #fixedParentTop 1 1282 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1360 nil 834 864 nil 7 nil nil nil 1360 nil 8 1912725136 898 #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 217 13 578 131 49 1360 1010 #isEnabled: 8 #(false) 1360 1010 #text: 34 1 8 '< &Back' 1360 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1312 131 1328 1 1344 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1792 nil 834 864 nil 7 nil nil nil 1792 nil 8 1912725136 898 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 955 13 578 139 49 1792 1010 #text: 34 1 8 'Cancel' 1792 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #fixedViewRight -137 1282 #fixedParentRight -11 1328 1 1344 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2176 nil 834 864 nil 7 nil nil nil 2176 nil 8 1912725136 898 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 357 13 578 131 49 2176 1010 #isEnabled: 8 #(false) 2176 1010 #text: 34 1 8 '&Next >' 2176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1296 11 1312 131 1328 1 1344 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2560 nil 834 864 nil 7 nil nil nil 2560 nil 8 1912725136 898 #deploy 8 '&Deploy' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 19 13 578 139 49 2560 1010 #isEnabled: 8 #(false) 2560 1010 #text: 34 1 8 '&Deploy' 2560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #fixedParentLeft 9 1312 139 1328 1 1344 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2960 nil 834 864 nil 7 nil nil nil 2960 nil 8 1912725136 898 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 545 13 578 131 49 2960 1010 #isEnabled: 8 #(false) 2960 1010 #text: 34 1 8 '&Reset' 2960 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 2144 -129 2160 -429 1328 1 1344 49 170 192 34 2 2560 8 'deploy' 590342 ##(Smalltalk.Rectangle) 578 11 13 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 723 578 1119 81 640 1010 #text: 34 1 8 'Buttons' 640 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 2560 1360 2176 2960 768 1792 1232 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3664 nil nil nil 7 nil nil nil 3664 655878 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 3824 nil nil nil 5 nil nil nil 3824 706 170 176 34 28 410 ##(Smalltalk.GroupBox) 34 14 nil 3824 34 2 8 1140850695 65 3936 nil 834 864 nil 5 nil nil nil 3936 nil 8 1912725136 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 291 578 1155 211 3936 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 65 2 0 0 250 0 0 0] 8 #() 1232 nil 27 1250 2944 1 2160 41 1328 291 1344 211 410 ##(Smalltalk.StaticText) 34 16 nil 3824 34 2 8 1140850944 1 4208 nil nil nil 5 nil nil nil 4208 nil 8 1912674480 852486 ##(Smalltalk.NullConverter) nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 141 578 389 81 4208 1010 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 4208 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 8 #() 1232 nil 27 1250 2944 31 1312 389 1328 141 1344 81 410 ##(Smalltalk.StaticText) 34 16 nil 3824 34 2 8 1140850944 1 4544 nil nil nil 5 nil nil nil 4544 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 511 578 1045 81 4544 1010 #text: 34 1 8 'The deployment process can write an HTML log file that describes the stripping actions performed and lists objects remaining in the image. This can be useful for debugging subsequent deployment problems.' 4544 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 255 0 0 0 25 2 0 0 39 1 0 0] 8 #() 1232 nil 27 1250 2944 31 2160 -39 1328 511 1344 81 410 ##(Smalltalk.CheckBox) 34 16 nil 3824 34 2 8 1140924451 1 4864 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) true nil nil 5 nil nil nil 4864 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 591 578 251 41 4864 1010 #text: 34 1 8 'Write &log file' 4864 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 155 0 0 0 59 1 0 0] 8 #() 1232 nil 27 1250 2944 61 1312 251 1328 591 1344 41 410 ##(Smalltalk.CheckBox) 34 16 nil 3824 34 2 8 1140924451 1 5248 4930 nil nil 4976 false nil nil 5 nil nil nil 5248 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 211 578 431 81 5248 1010 #text: 34 1 8 'Create single file, "To Go" distributable.' 5248 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1232 nil 27 1250 2944 31 1312 431 1328 211 1344 81 410 ##(Smalltalk.PushButton) 34 20 nil 3824 34 2 8 1140924416 1 5584 nil 834 864 nil 5 nil nil nil 5584 nil 8 1912725136 898 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 1025 151 578 49 41 5584 1010 #isEnabled: 8 #(false) 5584 1010 #text: 34 1 8 '...' 5584 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1232 nil 29 1250 2144 -47 2160 -41 1328 151 1344 41 410 ##(Smalltalk.PushButton) 34 20 nil 3824 34 2 8 1140924416 1 5968 nil 834 864 nil 5 nil nil nil 5968 nil 8 1912725136 898 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 441 661 578 139 45 5968 1010 #isEnabled: 8 #(false) 5968 1010 #text: 34 1 8 'S&how it' 5968 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1232 nil 29 1250 2944 441 1312 139 1328 661 1344 45 410 ##(Smalltalk.TextEdit) 34 16 nil 3824 34 2 8 1140916352 1025 6352 nil 834 864 nil 5 nil nil nil 6352 nil 8 1912718128 4290 nil nil 1 946 138 144 34 1 1010 #createAt:extent: 34 2 578 431 151 578 575 41 6352 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1232 nil 27 1250 2944 431 2160 -109 1328 151 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 3824 34 2 8 1140850944 1 6640 nil nil nil 5 nil nil nil 6640 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 321 578 975 71 6640 1010 #text: 34 1 8 'When deployed, an executable will contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 6640 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 246 1 0 0 195 0 0 0] 8 #() 1232 nil 27 1250 2944 31 2160 -109 1328 321 1344 71 410 ##(Smalltalk.ContainerView) 34 15 nil 3824 34 2 8 1140850688 131073 6960 nil 834 864 nil 5 nil nil nil 6960 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 6960 34 2 8 1140850944 1 7056 4930 nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 7170 #hash 8 #() 657478 3 ##(Smalltalk.OLEPicture) nil true 1703942 ##(Smalltalk.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 524806 ##(Smalltalk.IPicture) nil nil 578 321 327 578 8467 8627 721158 ##(Smalltalk.SystemColor) 31 nil 5 nil nil nil 7056 nil 8 4294902547 4290 nil nil nil 7264 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 7056 1010 #text: 34 1 8 'Graphic' 7056 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 6960 34 2 8 1140855108 1 7712 nil 834 864 nil 5 nil nil nil 7712 nil 8 1919957872 4290 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 7712 1010 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 2: \par
\f1\fs16\par
Choose an Executable File and RuntimeSessionManager\b0\par
\par
\par
\par
}
' 7712 1010 #textLimit: 8 #(1073741823) 7712 1010 #resetCharFormat 8 #() 7712 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 8112 3394 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 6960 1010 #text: 34 1 8 'Heading' 6960 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 7712 7056 1232 nil 27 1250 2944 1 2160 1 1328 1 1344 121 410 ##(Smalltalk.TextEdit) 34 16 nil 3824 34 2 8 1140850688 262145 8464 nil nil nil 5 nil nil nil 8464 nil 8 1912718128 4290 nil nil 1 946 138 144 34 2 1010 #createAt:extent: 34 2 578 441 591 578 565 41 8464 1010 #isEnabled: 8 #(false) 8464 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 39 1 0 0 246 1 0 0 59 1 0 0] 8 #() 1232 nil 27 1250 2944 441 2160 -109 1328 591 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 3824 34 2 8 1140850944 1 8768 nil nil nil 5 nil nil nil 8768 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 43 399 578 381 81 8768 1010 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 8768 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 199 0 0 0 211 0 0 0 239 0 0 0] 8 #() 1232 nil 27 1250 2944 43 1312 381 1328 399 1344 81 410 ##(Smalltalk.CheckBox) 34 16 nil 3824 34 2 8 1140924451 1 9088 4930 nil nil 4976 true nil nil 5 nil nil nil 9088 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 661 578 251 41 9088 1010 #text: 34 1 8 'Log &class references' 9088 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1232 nil 27 1250 2944 61 1312 251 1328 661 1344 41 410 ##(Smalltalk.ComboBox) 34 17 nil 3824 34 2 8 1144063491 1025 9424 590662 2 ##(Smalltalk.ListModel) 138 144 8112 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 834 864 nil 5 nil nil nil 9424 nil 8 1912552560 ##(Smalltalk.BasicListAbstract) 8112 401 946 138 144 34 1 1010 #createAt:extent: 34 2 578 441 411 578 565 43 9424 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 205 0 0 0 246 1 0 0 226 0 0 0] 8 #() 1232 nil 27 1250 2944 441 2160 -109 1328 411 1344 43 170 192 34 14 5248 8 'isToGo' 9088 8 'logReferencesToClasses' 9424 8 'runtimeSessionManagerClass' 6352 8 'executableName' 5968 8 'showLog' 8464 8 'logFileName' 4864 8 'writeLogFile' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 3824 1010 #text: 34 1 8 'Step 2' 3824 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 6960 4208 6352 5584 5248 6640 8768 9424 4544 4864 9088 8464 5968 3936 1232 nil 27 3794 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 10144 nil nil nil 5 nil nil nil 10144 706 170 176 34 12 410 ##(Smalltalk.ContainerView) 34 15 nil 10144 34 2 8 1140850688 131073 10256 nil 834 864 nil 5 nil nil nil 10256 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 10256 34 2 8 1140850944 1 10352 4930 nil false 7138 7170 #= 8 #() 7170 #hash 7232 7250 nil true 7296 8 'Resources\LagoonLogo.bmp' 7344 7378 nil nil 578 321 327 578 8467 8627 7442 31 nil 5 nil nil nil 10352 nil 8 4294902547 4290 nil nil nil 10496 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 10352 1010 #text: 34 1 8 'Graphic' 10352 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 10256 34 2 8 1140855108 1 10832 nil 834 864 nil 5 nil nil nil 10832 nil 8 1919957872 4290 nil nil 41 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 10832 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 3:\f1\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\par
\b0\par
\par
\par
}
' 10832 1010 #textLimit: 8 #(1073741823) 10832 1010 #resetCharFormat 8112 10832 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 8112 3394 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 10256 1010 #text: 34 1 8 'Heading' 10256 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 10832 10352 1232 nil 27 1250 2944 1 2160 1 1328 1 1344 121 410 ##(Smalltalk.CheckBox) 34 16 nil 10144 34 2 8 1140924451 1 11536 4930 nil nil 4976 true nil nil 5 nil nil nil 11536 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 59 619 578 329 49 11536 1010 #text: 34 1 8 'Strip redundant &packages' 11536 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 53 1 0 0 193 0 0 0 77 1 0 0] 8 #() 1232 nil 27 1250 2944 59 1312 329 1328 619 1344 49 410 ##(Smalltalk.StaticText) 34 16 nil 10144 34 2 8 1140850944 262145 11872 nil nil nil 5 nil nil nil 11872 nil 8 1912674480 4290 nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 361 389 578 647 41 11872 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1232 nil 27 1250 2944 361 2160 -107 1328 389 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 10144 34 2 8 1140850944 1 12144 nil nil nil 5 nil nil nil 12144 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 499 578 979 109 12144 1010 #text: 34 1 8 'The stripper is most efficient if it is first allowed to remove packages which it considers to be redundant. Selecting this option (recommended) will strip out any packages that are not pre-requisites of the root package above.' 12144 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -107 1328 499 1344 109 410 ##(Smalltalk.StaticText) 34 16 nil 10144 34 2 8 1140850944 1 12464 nil nil nil 5 nil nil nil 12464 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 171 578 975 191 12464 1010 #text: 34 1 8 'The ImageStripper must be associated with a root package so it can best determine the redundant objects in the image that can be removed. Note also that the image stripper configuration is saved in this package.

Currently the stripper is set to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 12464 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1232 nil 27 1250 2944 31 2160 -109 1328 171 1344 191 410 ##(Smalltalk.StaticText) 34 16 nil 10144 34 2 8 1140850944 1 12784 nil nil nil 5 nil nil nil 12784 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 389 578 201 41 12784 1010 #text: 34 1 8 'Root package:' 12784 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1232 nil 27 1250 2944 81 1312 201 1328 389 1344 41 170 192 34 4 11872 8 'rootPackage' 11536 8 'stripRedundantPackages' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 10144 1010 #text: 34 1 8 'Step 3' 10144 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 10256 12464 12784 11872 12144 11536 1232 nil 27 3794 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 13392 nil nil nil 5 nil nil nil 13392 706 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 nil 13392 34 2 8 1140924451 1 13504 4930 nil nil 4976 false nil nil 5 nil nil nil 13504 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 641 581 578 403 49 13504 1010 #text: 34 1 8 'Strip #shouldNot&Implement methods' 13504 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1232 nil 27 1250 1296 151 1312 403 1282 #fixedPreviousTop 1 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13392 34 2 8 1140924451 1 13856 4930 nil nil 4976 false nil nil 5 nil nil nil 13856 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 641 435 578 403 49 13856 1010 #text: 34 1 8 'Preserve &aspect set methods' 13856 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1232 nil 27 1250 1296 151 1312 403 13840 1 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13392 34 2 8 1140924451 1 14192 4930 nil nil 4976 true nil nil 5 nil nil nil 14192 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 217 578 421 49 14192 1010 #text: 34 1 8 'Strip redundant &classes' 14192 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 108 0 0 0 245 0 0 0 132 0 0 0] 8 #() 1232 nil 27 1250 2944 71 1312 421 1282 #fixedPreviousBottom 1 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13392 34 2 8 1140924451 1 14544 4930 nil nil 4976 false nil nil 5 nil nil nil 14544 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 581 578 421 49 14544 1010 #text: 34 1 8 'Strip #&deprecated methods' 14544 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 34 1 0 0 245 0 0 0 58 1 0 0] 8 #() 1232 nil 27 1250 2944 71 1312 421 14528 1 1344 49 410 ##(Smalltalk.ContainerView) 34 15 nil 13392 34 2 8 1140850688 131073 14880 nil 834 864 nil 5 nil nil nil 14880 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 14880 34 2 8 1140850944 1 14976 4930 nil false 7138 7170 #= 8 #() 7170 #hash 7232 7250 nil true 7296 8 'Resources\LagoonLogo.bmp' 7344 7378 nil nil 578 321 327 578 8467 8627 7442 31 nil 5 nil nil nil 14976 nil 8 4294902547 4290 nil nil nil 15120 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 14976 1010 #text: 34 1 8 'Graphic' 14976 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 14880 34 2 8 1140855108 1 15456 nil 834 864 nil 5 nil nil nil 15456 nil 8 1919957872 4290 nil nil 41 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 15456 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 4:\par
\f1\fs16\par
\f0 Configure how the ImageStripper removes unwanted classes and methods\b0\f1\par
\par
\par
\par
}
' 15456 1010 #textLimit: 8 #(1073741823) 15456 1010 #resetCharFormat 8112 15456 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 8112 3394 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 14880 1010 #text: 34 1 8 'Heading' 14880 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 15456 14976 1232 nil 27 1250 2944 1 2160 1 1328 1 1344 121 410 ##(Smalltalk.CheckBox) 34 16 nil 13392 34 2 8 1140924451 1 16160 4930 nil nil 4976 false nil nil 5 nil nil nil 16160 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 645 578 421 49 16160 1010 #text: 34 1 8 'Strip #&subclassResponsibility methods' 16160 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 66 1 0 0 245 0 0 0 90 1 0 0] 8 #() 1232 nil 27 1250 2944 71 1312 421 14528 17 1344 49 410 ##(Smalltalk.GroupBox) 34 14 nil 13392 34 2 8 1140850695 65 16496 nil 834 864 nil 5 nil nil nil 16496 nil 8 1912725136 946 138 144 34 1 1010 #createAt:extent: 34 2 578 -17 281 578 1151 229 16496 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1232 nil 27 1250 2944 -17 2160 19 1328 281 1344 229 410 ##(Smalltalk.StaticText) 34 16 nil 13392 34 2 8 1140850944 1 16768 nil nil nil 5 nil nil nil 16768 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 315 578 1019 121 16768 1010 #text: 34 1 8 'Given a set of classes that the ImageStripper believes should be preserved in the image it can then attempt to determine the methods that can never be called and these can then be removed. This step may inadvertently remove some methods that are only called by #perform:. Aspect setting methods are commonly called in this manner and you can opt to forcibly preserve these.' 16768 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -67 14528 51 1344 121 410 ##(Smalltalk.StaticText) 34 16 nil 13392 34 2 8 1140850944 1 17088 nil nil nil 5 nil nil nil 17088 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 533 578 1079 49 17088 1010 #text: 34 1 8 'Some methods which may not be marked as redundant can also be removed.' 17088 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -7 14528 51 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13392 34 2 8 1140924451 1 17408 4930 nil nil 4976 true nil nil 5 nil nil nil 17408 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 641 217 578 403 49 17408 1010 #text: 34 1 8 'Strip redundant &resources' 17408 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1232 nil 27 1250 1296 151 1312 403 13840 1 1344 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13392 34 2 8 1140924451 1 17744 4930 nil nil 4976 false nil nil 5 nil nil nil 17744 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 435 578 421 49 17744 1010 #text: 34 1 8 'Strip redundant &methods' 17744 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 217 0 0 0 245 0 0 0 241 0 0 0] 8 #() 1232 nil 27 1250 2944 71 1312 421 14528 1 1344 49 410 ##(Smalltalk.StaticText) 34 16 nil 13392 34 2 8 1140850944 1 18080 nil nil nil 5 nil nil nil 18080 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 1029 69 18080 1010 #text: 34 1 8 'The ImageStripper automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be stripped (recommended).' 18080 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -57 1328 149 1344 69 170 192 34 14 16160 8 'stripSubclassResponsibility' 17408 8 'stripRedundantResources' 14192 8 'stripRedundantClasses' 17744 8 'stripRedundantMethods' 14544 8 'stripDeprecatedMethods' 13504 8 'stripShouldNotImplement' 13856 8 'preserveAspectSetters' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 13392 1010 #text: 34 1 8 'Step 4' 13392 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 14880 18080 14192 17408 16768 17744 13856 17088 14544 13504 16160 16496 1232 nil 27 3794 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 18768 nil nil nil 5 nil nil nil 18768 706 170 176 34 12 410 ##(Smalltalk.ContainerView) 34 15 nil 18768 34 2 8 1140850688 131073 18880 nil 834 864 nil 5 nil nil nil 18880 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 18880 34 2 8 1140850944 1 18976 4930 nil false 7138 7170 #= 8 #() 7170 #hash 7232 7250 nil true 7296 8 'Resources\LagoonLogo.bmp' 7344 7378 nil nil 578 321 327 578 8467 8627 7442 31 nil 5 nil nil nil 18976 nil 8 4294902547 4290 nil nil nil 19120 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 18976 1010 #text: 34 1 8 'Graphic' 18976 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 18880 34 2 8 1140855108 1 19456 nil 834 864 nil 5 nil nil nil 19456 nil 8 1919957872 4290 nil nil 41 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 19456 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 7:\f1\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\b0\par
}
' 19456 1010 #textLimit: 8 #(1073741823) 19456 1010 #resetCharFormat 8112 19456 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 8112 3394 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 18880 1010 #text: 34 1 8 'Heading' 18880 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 19456 18976 1232 nil 27 1250 2944 1 2160 1 1328 1 1344 121 410 ##(Smalltalk.StatusBar) 34 18 nil 18768 34 2 8 1140850700 1 20160 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 20160 nil 8 1912526784 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 20160 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'preStripScriptErrors' 138 144 34 1 20352 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 20160 nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 31 571 578 1047 41 20160 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 8 #() 1232 nil 27 1250 2944 31 2160 -37 1328 571 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 18768 34 2 8 1140850944 1 20656 nil nil nil 5 nil nil nil 20656 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 1047 169 20656 1010 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the stripping process starts. You can do this using the pre-stripping script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 20656 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 25 2 0 0 158 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -39 1328 149 1344 169 410 ##(Smalltalk.ReferenceView) 34 14 nil 18768 34 2 8 1140850688 131073 20976 nil nil nil 5 nil nil nil 20976 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 31 321 578 1045 251 20976 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 25 2 0 0 29 1 0 0] 8112 1232 nil 27 1250 2944 31 2160 -39 1328 321 1344 251 410 ##(Smalltalk.PushButton) 34 20 nil 18768 34 2 8 1140924416 1 21232 nil 834 864 nil 5 nil nil nil 21232 nil 8 1912725136 898 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 881 661 578 211 51 21232 1010 #isEnabled: 8 #(false) 21232 1010 #text: 34 1 8 'Custom &Options' 21232 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1232 nil 29 1250 2944 881 1312 211 1328 661 1344 51 410 ##(Smalltalk.StaticText) 34 16 nil 18768 34 2 8 1140850944 1 21616 nil nil nil 5 nil nil nil 21616 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 651 578 791 71 21616 1010 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 21616 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1232 nil 27 1250 2944 31 1312 791 1328 651 1344 71 170 192 34 2 20976 8 'preStripScript' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 18768 1010 #text: 34 1 8 'Step 7' 18768 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 18880 20656 20976 20160 21616 21232 1232 nil 27 3794 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 22208 nil nil nil 5 nil nil nil 22208 706 170 176 34 18 410 ##(Smalltalk.StaticText) 34 16 nil 22208 34 2 8 1140850944 1 22320 nil nil nil 5 nil nil nil 22320 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 549 578 979 89 22320 1010 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 22320 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -107 1328 549 1344 89 410 ##(Smalltalk.CheckBox) 34 16 nil 22208 34 2 8 1140924451 1 22640 4930 nil nil 4976 false nil nil 5 nil nil nil 22640 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 459 578 369 41 22640 1010 #text: 34 1 8 'Strip class &GUIDs' 22640 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1232 nil 27 1250 2944 81 1312 369 1328 459 1344 41 410 ##(Smalltalk.ContainerView) 34 15 nil 22208 34 2 8 1140850688 131073 22976 nil 834 864 nil 5 nil nil nil 22976 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 22976 34 2 8 1140850944 1 23072 4930 nil false 7138 7170 #= 8 #() 7170 #hash 7232 7250 nil true 7296 8 'Resources\LagoonLogo.bmp' 7344 7378 nil nil 578 321 327 578 8467 8627 7442 31 nil 5 nil nil nil 23072 nil 8 4294902547 4290 nil nil nil 23216 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 23072 1010 #text: 34 1 8 'Graphic' 23072 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 22976 34 2 8 1140855108 1 23552 nil 834 864 nil 5 nil nil nil 23552 nil 8 1919957872 4290 nil nil 41 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 23552 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 5:\f1\fs16\par
\par
Decide what meta-level information is required at runtime\par
\b0\par
\par
\par
}
' 23552 1010 #textLimit: 8 #(1073741823) 23552 1010 #resetCharFormat 8112 23552 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 8112 3394 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 22976 1010 #text: 34 1 8 'Heading' 22976 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 23552 23072 1232 nil 27 1250 2944 1 2160 1 1328 1 1344 121 410 ##(Smalltalk.CheckBox) 34 16 nil 22208 34 2 8 1140924451 1 24256 4930 nil nil 4976 true nil nil 5 nil nil nil 24256 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 249 578 369 59 24256 1010 #text: 34 1 8 'Strip class meta-&information' 24256 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1232 nil 27 1250 2944 81 1312 369 1328 249 1344 59 410 ##(Smalltalk.StaticText) 34 16 nil 22208 34 2 8 1140850944 1 24592 nil nil nil 5 nil nil nil 24592 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 979 99 24592 1010 #text: 34 1 8 'Class category information is automatically stripped from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 24592 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -107 1328 149 1344 99 410 ##(Smalltalk.StaticText) 34 16 nil 22208 34 2 8 1140850944 1 24912 nil nil nil 5 nil nil nil 24912 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 321 578 979 69 24912 1010 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 24912 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -107 1328 321 1344 69 410 ##(Smalltalk.CheckBox) 34 16 nil 22208 34 2 8 1140924451 1 25232 4930 nil nil 4976 false nil nil 5 nil nil nil 25232 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 649 578 369 49 25232 1010 #text: 34 1 8 'Compile E&xternal Structures' 25232 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1232 nil 27 1250 2944 81 1312 369 1328 649 1344 49 410 ##(Smalltalk.GroupBox) 34 14 nil 22208 34 2 8 1140850695 65 25568 nil 834 864 nil 5 nil nil nil 25568 nil 8 1912725136 946 138 144 34 1 1010 #createAt:extent: 34 2 578 -17 521 578 1151 229 25568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1232 nil 27 1250 2944 -17 2160 19 1328 521 1344 229 410 ##(Smalltalk.CheckBox) 34 16 nil 22208 34 2 8 1140924451 1 25840 4930 nil nil 4976 false nil nil 5 nil nil nil 25840 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 389 578 369 69 25840 1010 #text: 34 1 8 'Retain instance &variable names' 25840 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1232 nil 27 1250 2944 81 1312 369 1328 389 1344 69 170 192 34 8 22640 8 'stripClassGuids' 25840 8 'retainInstVarNames' 25232 8 'compileExternalStructures' 24256 8 'stripClassInfo' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 22208 1010 #text: 34 1 8 'Step 5' 22208 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 22976 24592 24256 24912 25840 22640 22320 25232 25568 1232 nil 27 3794 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 26496 nil nil nil 5 nil nil nil 26496 706 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 26496 34 2 8 1140850955 262145 26608 nil nil nil 5 nil nil nil 26608 nil 8 1912674480 4290 nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 281 269 578 737 41 26608 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1232 nil 27 1250 2944 281 2160 -97 1328 269 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 26496 34 2 8 1140850944 1 26880 nil nil nil 5 nil nil nil 26880 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 641 578 979 59 26880 1010 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 26880 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -107 1328 641 1344 59 410 ##(Smalltalk.StaticText) 34 16 nil 26496 34 2 8 1140850944 1 27200 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 20272 nil 27200 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 529 578 949 81 27200 1010 #text: 34 1 8 'It is very important that, should the stripping operation fail for whatever reason, you do not save the partially stripped image.' 27200 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -137 1328 529 1344 81 410 ##(Smalltalk.StaticText) 34 16 nil 26496 34 2 8 1140850944 1 27568 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 20272 nil 27568 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 349 578 989 139 27568 1010 #text: 34 1 8 'Your development image will first be saved in its current state. 

The stripping process that follows may take several minutes depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that image stripping is complete.' 27568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -97 1328 349 1344 139 410 ##(Smalltalk.StaticText) 34 16 nil 26496 34 2 8 1140850944 1 27936 nil nil nil 5 nil nil nil 27936 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 161 578 989 81 27936 1010 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the image stripping options you have chosen. To do this click ''Deploy''.
' 27936 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -97 1328 161 1344 81 410 ##(Smalltalk.StaticText) 34 16 nil 26496 34 2 8 1140850944 1 28256 nil nil nil 5 nil nil nil 28256 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 269 578 189 49 28256 1010 #text: 34 1 8 'E&xecutable name:' 28256 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1232 nil 27 1250 2944 81 1312 189 1328 269 1344 49 410 ##(Smalltalk.ContainerView) 34 15 nil 26496 34 2 8 1140850688 131073 28576 nil 834 864 nil 5 nil nil nil 28576 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 28576 34 2 8 1140850944 1 28672 4930 nil false 7138 7170 #= 8 #() 7170 #hash 7232 7250 nil true 7296 8 'Resources\LagoonLogo.bmp' 7344 7378 nil nil 578 321 327 578 8467 8627 7442 31 nil 5 nil nil nil 28672 nil 8 4294902547 4290 nil nil nil 28816 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 28672 1010 #text: 34 1 8 'Graphic' 28672 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 28576 34 2 8 1140855108 1 29152 nil 834 864 nil 5 nil nil nil 29152 nil 8 1919957872 4290 nil nil 41 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 29152 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Final Step:\par
\f1\fs16\par
Deployment\b0\par
\par
\par
\par
}
' 29152 1010 #textLimit: 8 #(1073741823) 29152 1010 #resetCharFormat 8112 29152 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 8112 3394 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 28576 1010 #text: 34 1 8 'Heading' 28576 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 29152 28672 1232 nil 27 1250 2944 1 2160 1 1328 1 1344 121 170 192 34 2 26608 8 'executablePath2' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 26496 1010 #text: 34 1 8 'Final step' 26496 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 28576 27936 28256 26608 27200 27568 26880 1232 nil 27 3794 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 30128 nil 834 864 nil 7 nil nil nil 30128 706 170 176 34 8 410 ##(Smalltalk.TextEdit) 34 16 nil 30128 34 2 8 1140850816 262145 30256 nil 196934 1 ##(Smalltalk.RGB) 32238571 nil 7 nil nil nil 30256 nil 8 1912718128 4290 nil nil 35 946 138 144 34 1 1010 #createAt:extent: 34 2 578 421 491 578 645 41 30256 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1232 nil 27 1250 2944 421 2160 -49 14528 3 1344 41 410 ##(Smalltalk.RichTextEdit) 34 18 nil 30128 34 2 8 1140855110 1 30560 nil 834 864 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 898 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 30690 1 898 #bePlain 8 '&Plain' 1 1 nil nil nil 30690 1 898 #toggleBold 8 '&Bold' 1 1 nil nil nil 30690 1 898 #toggleItalic 8 '&Italic' 1 1 nil nil nil 30690 1 898 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 30754 4097 30642 nil true 34 3 30690 1 898 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 30690 1 898 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 30690 1 898 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 30754 4097 30690 1 898 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 30560 nil 8 1919957872 4290 nil nil 43 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 5 1010 #createAt:extent: 34 2 578 419 1 578 649 489 30560 1010 #contextMenu: 34 1 30656 30560 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}}
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
' 30560 1010 #textLimit: 8 #(1073741823) 30560 1010 #resetCharFormat 8112 30560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1232 nil 27 1250 2944 419 2160 -47 1328 1 1344 489 410 ##(Smalltalk.RichTextEdit) 34 18 nil 30128 34 2 8 1140855110 1 31648 nil 834 864 nil 7 30642 nil true 34 10 30690 1 898 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 30754 4097 30690 1 898 #bePlain 8 '&Plain' 1 1 nil nil nil 30690 1 898 #toggleBold 8 '&Bold' 1 1 nil nil nil 30690 1 898 #toggleItalic 8 '&Italic' 1 1 nil nil nil 30690 1 898 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 30754 4097 30642 nil true 34 3 30690 1 898 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 30690 1 898 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 30690 1 898 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 30754 4097 30690 1 898 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 31648 nil 8 1919957872 4290 nil nil 43 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 5 1010 #createAt:extent: 34 2 578 419 681 578 549 49 31648 1010 #contextMenu: 34 1 31728 31648 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click \b Next \b0 to continue.\par
\par
\par
\pard\qc\par
}
' 31648 1010 #textLimit: 8 #(1073741823) 31648 1010 #resetCharFormat 8112 31648 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1232 nil 27 1250 2944 419 1312 549 1328 681 1344 49 410 ##(Smalltalk.ImageView) 34 21 nil 30128 34 2 8 1140850944 1 32688 4930 nil false 7138 7170 #= 8 #() 7170 #hash 7232 7250 nil true 7296 8 'Resources\LagoonSideBar.jpg' 7344 7378 nil nil 578 381 761 578 10055 20109 834 864 nil 7 nil nil nil 32688 nil 8 4294902547 4290 nil nil nil 32832 #centered 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 379 741 32688 1010 #text: 34 1 8 'Lagoon Graphic' 32688 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1232 nil 27 1250 2944 1 1312 379 1328 1 1344 741 170 192 34 2 30256 8 'executablePath1' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 30128 1010 #text: 34 1 8 'Intro' 30128 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 32688 30560 30256 31648 1232 nil 27 3794 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 33456 nil nil nil 5 nil nil nil 33456 706 170 176 34 8 410 ##(Smalltalk.StaticText) 34 16 nil 33456 34 2 8 1140850944 1 33568 nil nil nil 5 nil nil nil 33568 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 229 578 979 149 33568 1010 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 33568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -107 1328 229 1344 149 410 ##(Smalltalk.ComboBox) 34 17 nil 33456 34 2 8 1144063491 1025 33888 9490 138 144 8112 nil 9552 834 864 nil 5 nil nil nil 33888 nil 8 1912552560 ##(Smalltalk.BasicListAbstract) 8112 401 946 138 144 34 1 1010 #createAt:extent: 34 2 578 349 409 578 647 43 33888 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1232 nil 27 1250 2944 349 2160 -119 1328 409 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 33456 34 2 8 1140850944 1 34192 nil nil nil 5 nil nil nil 34192 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 401 578 249 121 34192 1010 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 34192 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1232 nil 27 1250 2944 81 1312 249 1328 401 1344 121 410 ##(Smalltalk.ContainerView) 34 15 nil 33456 34 2 8 1140850688 131073 34512 nil 834 864 nil 5 nil nil nil 34512 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 34512 34 2 8 1140850944 1 34608 4930 nil false 7138 7170 #= 8 #() 7170 #hash 7232 7250 nil true 7296 8 'Resources\LagoonLogo.bmp' 7344 7378 nil nil 578 321 327 578 8467 8627 7442 31 nil 5 nil nil nil 34608 nil 8 4294902547 4290 nil nil nil 34752 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 34608 1010 #text: 34 1 8 'Graphic' 34608 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 34512 34 2 8 1140855108 1 35088 nil 834 864 nil 5 nil nil nil 35088 nil 8 1919957872 4290 nil nil 41 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 35088 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 1:\f1\fs16\par
\par
Choose an ImageStripper to perform the deployment process\b0\par
\par
\par
\par
}
' 35088 1010 #textLimit: 8 #(1073741823) 35088 1010 #resetCharFormat 8112 35088 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 8112 3394 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 34512 1010 #text: 34 1 8 'Heading' 34512 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 35088 34608 1232 nil 27 1250 2944 1 2160 1 1328 1 1344 121 170 192 34 2 33888 8 'imageStripperClass' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 33456 1010 #text: 34 1 8 'Step 1' 33456 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 34512 33568 34192 33888 1232 nil 27 3794 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3664 34 2 8 1140850688 131073 36064 nil nil nil 5 nil nil nil 36064 706 170 176 34 14 410 ##(Smalltalk.CheckBox) 34 16 nil 36064 34 2 8 1140924451 1 36176 4930 nil nil 4976 false nil nil 5 nil nil nil 36176 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 209 578 369 41 36176 1010 #text: 34 1 8 'Strip &Class Builder' 36176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1232 nil 27 1250 2944 81 1312 369 1328 209 1344 41 410 ##(Smalltalk.StaticText) 34 16 nil 36064 34 2 8 1140850944 1 36512 nil nil nil 5 nil nil nil 36512 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 161 578 989 49 36512 1010 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 36512 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1232 nil 27 1250 2944 29 2160 -97 1328 161 1344 49 410 ##(Smalltalk.StaticText) 34 16 nil 36064 34 2 8 1140850944 1 36832 nil nil nil 5 nil nil nil 36832 nil 8 1912674480 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 391 578 967 49 36832 1010 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 36832 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1232 nil 27 1250 2944 31 2160 -117 1328 391 1344 49 410 ##(Smalltalk.ContainerView) 34 15 nil 36064 34 2 8 1140850688 131073 37152 nil 834 864 nil 5 nil nil nil 37152 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 37152 34 2 8 1140850944 1 37248 4930 nil false 7138 7170 #= 8 #() 7170 #hash 7232 7250 nil true 7296 8 'Resources\LagoonLogo.bmp' 7344 7378 nil nil 578 321 327 578 8467 8627 7442 31 nil 5 nil nil nil 37248 nil 8 4294902547 4290 nil nil nil 37392 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 37248 1010 #text: 34 1 8 'Graphic' 37248 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 37152 34 2 8 1140855108 1 37728 nil 834 864 nil 5 nil nil nil 37728 nil 8 1919957872 4290 nil nil 41 nil 7826 8 #[0 0 0 0 0 0 0 0 176 0 22 4] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 37728 1010 #text: 34 1 8018 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 6:\f1\fs16\par
\par
Miscellaneous stripping options\b0\par
\par
\par
\par
}
' 37728 1010 #textLimit: 8 #(1073741823) 37728 1010 #resetCharFormat 8112 37728 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 8112 3394 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 37152 1010 #text: 34 1 8 'Heading' 37152 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 37728 37248 1232 nil 27 1250 2944 1 2160 1 1328 1 1344 121 410 ##(Smalltalk.CheckBox) 34 16 nil 36064 34 2 8 1140924451 1 38432 4930 nil nil 4976 true nil nil 5 nil nil nil 38432 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 511 578 379 41 38432 1010 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 38432 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1232 nil 27 1250 2944 71 1312 379 1328 511 1344 41 410 ##(Smalltalk.CheckBox) 34 16 nil 36064 34 2 8 1140924451 1 38768 4930 nil nil 4976 true nil nil 5 nil nil nil 38768 nil 8 1912725136 4290 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 451 578 379 49 38768 1010 #text: 34 1 8 'Fold duplicate s&trings' 38768 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1232 nil 27 1250 2944 71 1312 379 1328 451 1344 49 410 ##(Smalltalk.GroupBox) 34 14 nil 36064 34 2 8 1140850695 65 39104 nil 834 864 nil 5 nil nil nil 39104 nil 8 1912725136 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 327 578 1115 393 39104 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1232 nil 27 1250 2944 1 2160 1 1328 327 1344 393 170 192 34 6 38768 8 'stripDuplicateStrings' 36176 8 'stripClassBuilder' 38432 8 'stripDuplicateBytecodes' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 36064 1010 #text: 34 1 8 'Step 6' 36064 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 37152 36512 36176 36832 38768 38432 39104 1232 nil 27 30128 170 192 34 2 30128 8 'Intro' nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 1 578 1119 723 3664 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 30128 33456 3824 10144 13392 22208 36064 18768 26496 1232 nil 27 170 192 34 2 3664 8 'Steps' 3394 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2007257760 946 138 144 34 3 1010 #createAt:extent: 34 2 578 3839 21 578 1151 881 416 1010 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1010 #updateMenuBar 8112 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 190 9 0 0 194 1 0 0] 34 2 3664 640 1232 nil 27)!

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

	^SmalltalkSystemIcon showModal: self description: self displayString!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system.
	Un-register the system tools folder icon for the receiver.

		self uninitialize

	Note: This method is in the 'must strip' category so that it is removed in the early
	stages of image stripping. It is not required during stripping, because the system
	folders are cleared down anyway, and it may generate an error if required parts
	of the development system have already been removed.
	"

	Smalltalk developmentSystem unregisterTool: self! !
!ApplicationDeploymentWizard class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!ApplicationDeploymentWizard class categoriesFor: #defaultModel!models!public! !
!ApplicationDeploymentWizard class categoriesFor: #displayOn:!displaying!public! !
!ApplicationDeploymentWizard class categoriesFor: #icon!constants!public! !
!ApplicationDeploymentWizard class categoriesFor: #initialize!initializing!private! !
!ApplicationDeploymentWizard class categoriesFor: #publishedAspects!development!public! !
!ApplicationDeploymentWizard class categoriesFor: #resource_Default_view!public!resources-views! !
!ApplicationDeploymentWizard class categoriesFor: #saveImageOnDeploy!options!public! !
!ApplicationDeploymentWizard class categoriesFor: #saveImageOnDeploy:!options!public! !
!ApplicationDeploymentWizard class categoriesFor: #toolsFolderIcon!accessing!public! !
!ApplicationDeploymentWizard class categoriesFor: #uninitialize!development!initializing!private! !

