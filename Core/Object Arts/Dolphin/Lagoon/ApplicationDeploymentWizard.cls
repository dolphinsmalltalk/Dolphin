"Filed out from Dolphin Smalltalk X6.2"!

ValueDialog subclass: #ApplicationDeploymentWizard
	instanceVariableNames: 'imageStripperClass executableName executablePath1 executablePath2 rootPackage runtimeSessionManagerClass stripRedundantMethods stripDeprecatedMethods stripShouldNotImplement stripRedundantPackages stripRedundantClasses preserveAspectSetters stripDuplicateStrings stripDuplicateBytecodes stripClassInfo retainInstVarNames stripClassGuids stripClassBuilder stripEmptyMethodDictionaries stripRedundantResources compileExternalStructures writeLogFile preStripScriptWorkspace preStripScriptErrors logFileName logReferencesToClasses stepsView isToGo stripSubclassResponsibility'
	classVariableNames: 'SaveImageOnDeploy'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ApplicationDeploymentWizard guid: (GUID fromString: '{87B4C6A1-026E-11D3-9FD7-00A0CC3E4A32}')!
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
	(filename isEmpty and: [rootPackage value notNil]) ifTrue: [
		"Suggest a sensible default name"
		defaultExtension := self value exeFileExtension.
		filename := File change: rootPackage value packageFileName extension: defaultExtension].

	filename := (FileSaveDialog on: filename)
		fileTypes: (self exeFileTypes copyWith: FileDialog allFilesType);
		defaultExtension: defaultExtension;
		caption: 'Choose target';
		showModal.
	filename notNil ifTrue: [ executableName value: filename].!

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
	stripEmptyMethodDictionaries := self add: BooleanPresenter new name: 'stripEmptyMethodDictionaries'.
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
	stripEmptyMethodDictionaries model: (aspectBuffer aspectValue: #stripEmptyMethodDictionaries).
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
	stripEmptyMethodDictionaries view isEnabled: stripInfo.

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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 721158 ##(Smalltalk.SystemColor)  31 0 39 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 15 1 31 86 135 1] 328198 ##(Smalltalk.Point)  193 193 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140916224 393217 656 0 482 31 0 7 0 0 0 656 852230 ##(Smalltalk.FramingLayout)  234 240 98 12 410 8 ##(Smalltalk.PushButton)  98 20 0 656 98 2 8 1140924416 1 816 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 816 0 8 4294904055 1180998 4 ##(Smalltalk.CommandDescription)  8 #reset 8 '&Reset' 1 1 0 0 32 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 594 545 13 594 131 49 816 1090 8 #isEnabled: 98 1 32 816 1090 8 #text: 98 1 8 '&Reset' 816 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 98 0 594 193 193 0 29 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedViewRight -129 1410 8 #fixedParentRight -429 1410 8 #fixedParentTop 1 1410 8 #fixedViewTop 49 410 832 98 20 0 656 98 2 8 1140924416 1 1552 0 898 928 0 7 0 0 0 1552 0 8 4294904055 962 8 #cancel 8 'Cancel' 1 1 0 0 32 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 955 13 594 139 49 1552 1090 1248 98 1 8 'Cancel' 1552 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 98 0 1360 0 29 1378 1424 -137 1456 -11 1488 1 1520 49 410 832 98 20 0 656 98 2 8 1140924416 1 1920 0 898 928 0 7 0 0 0 1920 0 8 4294904055 962 8 #nextCard 8 '&Next >' 1 1 0 0 32 0 0 0 1026 202 208 98 3 1090 1120 98 2 594 357 13 594 131 49 1920 1090 1200 98 1 32 1920 1090 1248 98 1 8 '&Next >' 1920 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 98 0 1360 0 29 1378 1410 8 #fixedPreviousRight 11 1410 8 #fixedViewLeft 131 1488 1 1520 49 410 832 98 20 0 656 98 2 8 1140924416 1 2384 0 898 928 0 7 0 0 0 2384 0 8 4294904055 962 8 #deploy 8 '&Deploy' 1 1 0 0 32 0 0 0 1026 202 208 98 3 1090 1120 98 2 594 19 13 594 139 49 2384 1090 1200 98 1 32 2384 1090 1248 98 1 8 '&Deploy' 2384 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 98 0 1360 0 29 1378 1410 8 #fixedParentLeft 9 2352 139 1488 1 1520 49 410 832 98 20 0 656 98 2 8 1140924416 1 2816 0 898 928 0 7 0 0 0 2816 0 8 4294904055 962 8 #previousCard 8 '< &Back' 1 1 0 0 32 0 0 0 1026 202 208 98 3 1090 1120 98 2 594 217 13 594 131 49 2816 1090 1200 98 1 32 2816 1090 1248 98 1 8 '< &Back' 2816 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 98 0 1360 0 29 1378 1410 8 #relativeParentWidth 524806 ##(Smalltalk.Fraction)  15 75 2352 131 1488 1 1520 49 410 832 98 20 0 656 98 2 8 1140924416 1 3280 0 898 928 0 7 0 0 0 3280 0 8 4294904055 962 8 #ok 8 '&Save Configuration' 1 1 0 0 32 0 0 0 1026 202 208 98 3 1090 1120 98 2 594 685 13 594 241 49 3280 1090 1200 98 1 32 3280 1090 1248 98 1 8 '&Save Configuration' 3280 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 98 0 1360 0 29 1378 2320 11 2352 241 1488 1 1520 49 234 256 98 2 2384 8 'deploy' 590342 ##(Smalltalk.Rectangle)  594 11 13 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 725 594 1119 81 656 1090 1248 98 1 8 'Buttons' 656 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 106 1 0 0 47 2 0 0 146 1 0 0] 98 6 2384 2816 1920 816 3280 1552 1360 0 27 0 0 410 8 ##(Smalltalk.WizardCardContainer)  98 15 0 416 98 2 8 1140850688 393217 4000 0 482 31 0 7 0 0 0 4000 655878 ##(Smalltalk.CardLayout)  202 208 98 9 721414 ##(Smalltalk.Association)  3 410 672 98 15 0 4000 98 2 8 1140850688 131073 4192 0 482 31 0 5 0 0 0 4192 754 234 240 98 28 410 8 ##(Smalltalk.StaticText)  98 16 0 4192 98 2 8 1140850944 1 4320 0 0 0 5 0 0 0 4320 0 8 4294903215 852486 ##(Smalltalk.NullConverter)  0 0 0 1026 202 208 98 2 1090 1120 98 2 594 31 321 594 975 71 4320 1090 1248 98 1 8 'When deployed, an executable will contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 4320 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 246 1 0 0 195 0 0 0] 98 0 1360 0 27 1378 2784 31 1456 -109 1488 321 1520 71 410 8 ##(Smalltalk.GroupBox)  98 14 0 4192 98 2 8 1140850695 65 4672 0 898 928 0 5 0 0 0 4672 0 8 4294904055 1026 202 208 98 1 1090 1120 98 2 594 1 291 594 1155 211 4672 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 65 2 0 0 250 0 0 0] 98 0 1360 0 27 1378 2784 1 1456 41 1488 291 1520 211 410 4336 98 16 0 4192 98 2 8 1140850944 1 4960 0 0 0 5 0 0 0 4960 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 43 399 594 381 81 4960 1090 1248 98 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 4960 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 199 0 0 0 211 0 0 0 239 0 0 0] 98 0 1360 0 27 1378 2784 43 2352 381 1488 399 1520 81 410 8 ##(Smalltalk.TextEdit)  98 16 0 4192 98 2 8 1140916352 1025 5280 0 898 928 0 5 0 0 0 5280 0 8 4294903191 4418 0 0 1 1026 202 208 98 3 1090 1120 98 2 594 431 151 594 575 41 5280 1090 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 5280 1090 8 #isTextModified: 98 1 32 5280 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 98 0 1360 0 27 1378 2784 431 1456 -109 1488 151 1520 41 410 832 98 20 0 4192 98 2 8 1140924416 1 5712 0 898 928 0 5 0 0 0 5712 0 8 4294904055 962 8 #showLog 8 'S&how it' 1 1 0 0 32 0 0 0 1026 202 208 98 3 1090 1120 98 2 594 441 661 594 139 45 5712 1090 1200 98 1 32 5712 1090 1248 98 1 8 'S&how it' 5712 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 98 0 1360 0 29 1378 2784 441 2352 139 1488 661 1520 45 410 8 ##(Smalltalk.CheckBox)  98 16 0 4192 98 2 8 1140924451 1 6112 721990 2 ##(Smalltalk.ValueHolder)  0 0 1114118 ##(Smalltalk.NeverSearchPolicy)  16 898 928 0 5 0 0 0 6112 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 61 591 594 251 41 6112 1090 1248 98 1 8 'Write &log file' 6112 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 155 0 0 0 59 1 0 0] 98 0 1360 0 27 1378 2784 61 2352 251 1488 591 1520 41 410 832 98 20 0 4192 98 2 8 1140924416 1 6528 0 898 928 0 5 0 0 0 6528 0 8 4294904055 962 8 #browseForExecutableName 8 '...' 1 1 0 0 32 0 0 0 1026 202 208 98 3 1090 1120 98 2 594 1025 151 594 49 41 6528 1090 1200 98 1 32 6528 1090 1248 98 1 8 '...' 6528 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 98 0 1360 0 29 1378 1424 -47 1456 -41 1488 151 1520 41 410 5296 98 16 0 4192 98 2 8 1140850688 262145 6928 0 898 928 0 5 0 0 0 6928 0 8 4294903191 4418 0 0 1 1026 202 208 98 4 1090 1120 98 2 594 441 591 594 565 41 6928 1090 1200 98 1 32 6928 1090 5536 98 1 5570 3 1 3 6928 1090 5616 98 1 32 6928 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 39 1 0 0 246 1 0 0 59 1 0 0] 98 0 1360 0 27 1378 2784 441 1456 -109 1488 591 1520 41 410 6128 98 16 0 4192 98 2 8 1140924451 1 7328 6194 0 0 6240 32 898 928 0 5 0 0 0 7328 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 31 211 594 431 81 7328 1090 1248 98 1 8 'Create single file, "To Go" distributable.' 7328 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 98 0 1360 0 27 1378 2784 31 2352 431 1488 211 1520 81 410 6128 98 16 0 4192 98 2 8 1140924451 1 7680 6194 0 0 6240 16 898 928 0 5 0 0 0 7680 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 61 661 594 251 41 7680 1090 1248 98 1 8 'Log &class references' 7680 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 98 0 1360 0 27 1378 2784 61 2352 251 1488 661 1520 41 410 672 98 15 0 4192 98 2 8 1140850688 131073 8032 0 898 928 0 5 0 0 0 8032 626 19 1 0 0 410 8 ##(Smalltalk.ImageView)  98 21 0 8032 98 2 8 1140850944 1 8128 6194 0 32 1376774 ##(Smalltalk.PluggableSearchPolicy)  459270 ##(Smalltalk.Message)  8 #= 98 0 8258 8 #hash 98 0 657478 3 ##(Smalltalk.OLEPicture)  0 16 1703942 ##(Smalltalk.InstallRelativeFileLocator)  8 'Resources\LagoonLogo.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 524806 ##(Smalltalk.IPicture)  0 0 594 321 327 594 8467 8627 482 31 0 5 0 0 0 8128 0 8 4294902547 4418 0 0 0 8384 8 #scale 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1003 11 594 103 101 8128 1090 1248 98 1 8 'Graphic' 8128 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 98 0 1360 0 27 0 410 8 ##(Smalltalk.RichTextEdit)  98 18 0 8032 98 2 8 1140855108 1 8832 0 898 928 0 5 0 0 0 8832 0 8 1831043579 4418 0 0 41 0 655622 ##(Smalltalk.EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 5 1090 1120 98 2 594 31 11 594 955 101 8832 1090 1248 98 1 524550 ##(Smalltalk.RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 2: 
\par \f1\fs16 
\par Choose an Executable File and RuntimeSessionManager\b0 
\par 
\par 
\par 
\par }
' 8832 1090 5536 98 1 5570 3 1 3 8832 1090 5616 98 1 32 8832 1090 8 #resetCharFormat 98 0 8832 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 98 0 1360 0 27 234 256 9312 3730 594 31 11 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 121 8032 1090 1248 98 1 8 'Heading' 8032 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 98 2 8832 8128 1360 0 27 1378 2784 1 1456 1 1488 1 1520 121 410 8 ##(Smalltalk.ComboBox)  98 17 0 4192 98 2 8 1144063491 1025 9664 590662 2 ##(Smalltalk.ListModel)  202 208 9312 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  898 928 0 5 0 0 0 9664 0 8 4294903929 8 ##(Smalltalk.BasicListAbstract)  9312 401 1026 202 208 98 1 1090 1120 98 2 594 441 411 594 565 43 9664 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 205 0 0 0 246 1 0 0 226 0 0 0] 98 0 1360 0 27 1378 2784 441 1456 -109 1488 411 1520 43 410 4336 98 16 0 4192 98 2 8 1140850944 1 10048 0 0 0 5 0 0 0 10048 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 31 141 594 389 81 10048 1090 1248 98 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 10048 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 98 0 1360 0 27 1378 2784 31 2352 389 1488 141 1520 81 410 4336 98 16 0 4192 98 2 8 1140850944 1 10368 0 0 0 5 0 0 0 10368 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 31 511 594 1045 81 10368 1090 1248 98 1 8 'The deployment process can write an HTML log file that describes the stripping actions performed and lists objects remaining in the image. This can be useful for debugging subsequent deployment problems.' 10368 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 255 0 0 0 25 2 0 0 39 1 0 0] 98 0 1360 0 27 1378 2784 31 1456 -39 1488 511 1520 81 234 256 98 14 6928 8 'logFileName' 5712 8 'showLog' 7328 8 'isToGo' 9664 8 'runtimeSessionManagerClass' 5280 8 'executableName' 7680 8 'logReferencesToClasses' 6112 8 'writeLogFile' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 4192 1090 1248 98 1 8 'Step 2' 4192 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 14 8032 10048 5280 6528 7328 4320 4960 9664 10368 6112 7680 6928 5712 4672 1360 0 27 4162 5 410 672 98 15 0 4000 98 2 8 1140850688 131073 11056 0 482 31 0 5 0 0 0 11056 754 234 240 98 12 410 4336 98 16 0 11056 98 2 8 1140850944 1025 11184 0 0 0 5 0 0 0 11184 0 8 4294903215 4418 0 0 0 1026 202 208 98 1 1090 1120 98 2 594 361 389 594 663 41 11184 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 255 1 0 0 214 0 0 0] 98 0 1360 0 27 1378 2784 361 1456 -107 1488 389 1520 41 410 4336 98 16 0 11056 98 2 8 1140850944 1 11456 0 0 0 5 0 0 0 11456 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 31 171 594 991 191 11456 1090 1248 98 1 8 'The ImageStripper must be associated with a root package so it can best determine the redundant objects in the image that can be removed. Note also that the image stripper configuration is saved in this package.

Currently the stripper is set to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 11456 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 254 1 0 0 180 0 0 0] 98 0 1360 0 27 1378 2784 31 1456 -109 1488 171 1520 191 410 4336 98 16 0 11056 98 2 8 1140850944 1 11776 0 0 0 5 0 0 0 11776 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 499 594 995 109 11776 1090 1248 98 1 8 'The stripper is most efficient if it is first allowed to remove packages which it considers to be redundant. Selecting this option (recommended) will strip out any packages that are not pre-requisites of the root package above.' 11776 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 255 1 0 0 47 1 0 0] 98 0 1360 0 27 1378 2784 29 1456 -107 1488 499 1520 109 410 4336 98 16 0 11056 98 2 8 1140850944 1 12096 0 0 0 5 0 0 0 12096 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 81 389 594 201 41 12096 1090 1248 98 1 8 'Root package:' 12096 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 98 0 1360 0 27 1378 2784 81 2352 201 1488 389 1520 41 410 672 98 15 0 11056 98 2 8 1140850688 131073 12416 0 898 928 0 5 0 0 0 12416 626 19 1 0 0 410 8144 98 21 0 12416 98 2 8 1140850944 1 12512 6194 0 32 8226 8258 8288 98 0 8258 8336 8352 8370 0 16 8416 8 'Resources\LagoonLogo.bmp' 8464 8498 0 0 594 321 327 594 8467 8627 482 31 0 5 0 0 0 12512 0 8 4294902547 4418 0 0 0 12656 8608 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1019 11 594 103 101 12512 1090 1248 98 1 8 'Graphic' 12512 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 1 0 0 5 0 0 0 48 2 0 0 55 0 0 0] 98 0 1360 0 27 0 410 8848 98 18 0 12416 98 2 8 1140855108 1 12992 0 898 928 0 5 0 0 0 12992 0 8 1831043579 4418 0 0 41 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 5 1090 1120 98 2 594 31 11 594 971 101 12992 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 3:\f1\fs16 
\par 
\par Configure how the ImageStripper removes unwanted packages
\par \b0 
\par 
\par 
\par }
' 12992 1090 5536 98 1 5570 3 1 3 12992 1090 5616 98 1 32 12992 1090 9296 9312 12992 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 244 1 0 0 55 0 0 0] 98 0 1360 0 27 234 256 9312 3730 594 31 11 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1131 121 12416 1090 1248 98 1 8 'Heading' 12416 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 53 2 0 0 60 0 0 0] 98 2 12992 12512 1360 0 27 1378 2784 1 1456 1 1488 1 1520 121 410 6128 98 16 0 11056 98 2 8 1140924451 1 13744 6194 0 0 6240 16 898 928 0 5 0 0 0 13744 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 59 619 594 329 49 13744 1090 1248 98 1 8 'Strip redundant &packages' 13744 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 53 1 0 0 193 0 0 0 77 1 0 0] 98 0 1360 0 27 1378 2784 59 2352 329 1488 619 1520 49 234 256 98 4 13744 8 'stripRedundantPackages' 11184 8 'rootPackage' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 11056 1090 1248 98 1 8 'Step 3' 11056 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 6 12416 11456 12096 11184 11776 13744 1360 0 27 4162 7 410 672 98 15 0 4000 98 2 8 1140850688 131073 14384 0 482 31 0 5 0 0 0 14384 754 234 240 98 24 410 6128 98 16 0 14384 98 2 8 1140924451 1 14512 6194 0 0 6240 16 898 928 0 5 0 0 0 14512 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 71 217 594 421 49 14512 1090 1248 98 1 8 'Strip redundant &classes' 14512 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 108 0 0 0 245 0 0 0 132 0 0 0] 98 0 1360 0 27 1378 2784 71 2352 421 1410 8 #fixedPreviousBottom 1 1520 49 410 4336 98 16 0 14384 98 2 8 1140850944 1 14896 0 0 0 5 0 0 0 14896 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 533 594 1095 49 14896 1090 1248 98 1 8 'Some methods which may not be marked as redundant can also be removed.' 14896 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 49 2 0 0 34 1 0 0] 98 0 1360 0 27 1378 2784 29 1456 -7 14864 51 1520 49 410 672 98 15 0 14384 98 2 8 1140850688 131073 15216 0 898 928 0 5 0 0 0 15216 626 19 1 0 0 410 8144 98 21 0 15216 98 2 8 1140850944 1 15312 6194 0 32 8226 8258 8288 98 0 8258 8336 8352 8370 0 16 8416 8 'Resources\LagoonLogo.bmp' 8464 8498 0 0 594 321 327 594 8467 8627 482 31 0 5 0 0 0 15312 0 8 4294902547 4418 0 0 0 15456 8608 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1019 11 594 103 101 15312 1090 1248 98 1 8 'Graphic' 15312 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 1 0 0 5 0 0 0 48 2 0 0 55 0 0 0] 98 0 1360 0 27 0 410 8848 98 18 0 15216 98 2 8 1140855108 1 15792 0 898 928 0 5 0 0 0 15792 0 8 1831043579 4418 0 0 41 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 5 1090 1120 98 2 594 31 11 594 971 101 15792 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 4:
\par \f1\fs16 
\par \f0 Configure how the ImageStripper removes unwanted classes and methods\b0\f1 
\par 
\par 
\par 
\par }
' 15792 1090 5536 98 1 5570 3 1 3 15792 1090 5616 98 1 32 15792 1090 9296 9312 15792 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 244 1 0 0 55 0 0 0] 98 0 1360 0 27 234 256 9312 3730 594 31 11 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1131 121 15216 1090 1248 98 1 8 'Heading' 15216 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 53 2 0 0 60 0 0 0] 98 2 15792 15312 1360 0 27 1378 2784 1 1456 1 1488 1 1520 121 410 6128 98 16 0 14384 98 2 8 1140924451 1 16544 6194 0 0 6240 32 898 928 0 5 0 0 0 16544 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 641 435 594 403 49 16544 1090 1248 98 1 8 'Preserve &aspect set methods' 16544 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 98 0 1360 0 27 1378 2320 151 2352 403 1410 8 #fixedPreviousTop 1 1520 49 410 6128 98 16 0 14384 98 2 8 1140924451 1 16928 6194 0 0 6240 32 898 928 0 5 0 0 0 16928 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 71 581 594 421 49 16928 1090 1248 98 1 8 'Strip #&deprecated methods' 16928 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 34 1 0 0 245 0 0 0 58 1 0 0] 98 0 1360 0 27 1378 2784 71 2352 421 14864 1 1520 49 410 4336 98 16 0 14384 98 2 8 1140850944 1 17280 0 0 0 5 0 0 0 17280 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 315 594 1035 121 17280 1090 1248 98 1 8 'Given a set of classes that the ImageStripper believes should be preserved in the image it can then attempt to determine the methods that can never be called and these can then be removed. This step may inadvertently remove some methods that are only called by #perform:. Aspect setting methods are commonly called in this manner and you can opt to forcibly preserve these.' 17280 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 19 2 0 0 217 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -67 14864 51 1520 121 410 6128 98 16 0 14384 98 2 8 1140924451 1 17600 6194 0 0 6240 32 898 928 0 5 0 0 0 17600 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 71 435 594 421 49 17600 1090 1248 98 1 8 'Strip redundant &methods' 17600 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 217 0 0 0 245 0 0 0 241 0 0 0] 98 0 1360 0 27 1378 2784 71 2352 421 14864 1 1520 49 410 6128 98 16 0 14384 98 2 8 1140924451 1 17952 6194 0 0 6240 32 898 928 0 5 0 0 0 17952 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 641 581 594 403 49 17952 1090 1248 98 1 8 'Strip #shouldNot&Implement methods' 17952 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 98 0 1360 0 27 1378 2320 151 2352 403 16896 1 1520 49 410 6128 98 16 0 14384 98 2 8 1140924451 1 18304 6194 0 0 6240 16 898 928 0 5 0 0 0 18304 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 641 217 594 403 49 18304 1090 1248 98 1 8 'Strip redundant &resources' 18304 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 98 0 1360 0 27 1378 2320 151 2352 403 16896 1 1520 49 410 6128 98 16 0 14384 98 2 8 1140924451 1 18656 6194 0 0 6240 32 898 928 0 5 0 0 0 18656 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 71 645 594 421 49 18656 1090 1248 98 1 8 'Strip #&subclassResponsibility methods' 18656 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 66 1 0 0 245 0 0 0 90 1 0 0] 98 0 1360 0 27 1378 2784 71 2352 421 14864 17 1520 49 410 4688 98 14 0 14384 98 2 8 1140850695 65 19008 0 898 928 0 5 0 0 0 19008 0 8 4294904055 1026 202 208 98 1 1090 1120 98 2 594 -17 281 594 1167 229 19008 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 62 2 0 0 254 0 0 0] 98 0 1360 0 27 1378 2784 -17 1456 19 1488 281 1520 229 410 4336 98 16 0 14384 98 2 8 1140850944 1 19280 0 0 0 5 0 0 0 19280 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 149 594 1045 69 19280 1090 1248 98 1 8 'The ImageStripper automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be stripped (recommended).' 19280 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 24 2 0 0 108 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -57 1488 149 1520 69 234 256 98 14 16928 8 'stripDeprecatedMethods' 17600 8 'stripRedundantMethods' 17952 8 'stripShouldNotImplement' 14512 8 'stripRedundantClasses' 18656 8 'stripSubclassResponsibility' 16544 8 'preserveAspectSetters' 18304 8 'stripRedundantResources' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 14384 1090 1248 98 1 8 'Step 4' 14384 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 12 15216 19280 14512 18304 17280 17600 16544 14896 16928 17952 18656 19008 1360 0 27 4162 9 410 672 98 15 0 4000 98 2 8 1140850688 131073 19968 0 482 31 0 5 0 0 0 19968 754 234 240 98 12 410 832 98 20 0 19968 98 2 8 1140924416 1 20096 0 898 928 0 5 0 0 0 20096 0 8 4294904055 962 8 #editCustomOptions 8 'Custom &Options' 1 1 0 0 32 0 0 0 1026 202 208 98 3 1090 1120 98 2 594 881 661 594 211 51 20096 1090 1200 98 1 32 20096 1090 1248 98 1 8 'Custom &Options' 20096 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 98 0 1360 0 29 1378 2784 881 2352 211 1488 661 1520 51 410 4336 98 16 0 19968 98 2 8 1140850944 1 20496 0 0 0 5 0 0 0 20496 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 31 651 594 791 71 20496 1090 1248 98 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 20496 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 98 0 1360 0 27 1378 2784 31 2352 791 1488 651 1520 71 410 672 98 15 0 19968 98 2 8 1140850688 131073 20816 0 898 928 0 5 0 0 0 20816 626 19 1 0 0 410 8144 98 21 0 20816 98 2 8 1140850944 1 20912 6194 0 32 8226 8258 8288 98 0 8258 8336 8352 8370 0 16 8416 8 'Resources\LagoonLogo.bmp' 8464 8498 0 0 594 321 327 594 8467 8627 482 31 0 5 0 0 0 20912 0 8 4294902547 4418 0 0 0 21056 8608 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1019 11 594 103 101 20912 1090 1248 98 1 8 'Graphic' 20912 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 1 0 0 5 0 0 0 48 2 0 0 55 0 0 0] 98 0 1360 0 27 0 410 8848 98 18 0 20816 98 2 8 1140855108 1 21392 0 898 928 0 5 0 0 0 21392 0 8 1831043579 4418 0 0 41 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 5 1090 1120 98 2 594 31 11 594 971 101 21392 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 7:\f1\fs16 
\par 
\par Configure any additional actions using a Pre-Strip Script and Custom options
\par \b0 
\par }
' 21392 1090 5536 98 1 5570 3 1 3 21392 1090 5616 98 1 32 21392 1090 9296 9312 21392 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 244 1 0 0 55 0 0 0] 98 0 1360 0 27 234 256 9312 3730 594 31 11 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1131 121 20816 1090 1248 98 1 8 'Heading' 20816 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 53 2 0 0 60 0 0 0] 98 2 21392 20912 1360 0 27 1378 2784 1 1456 1 1488 1 1520 121 410 4336 98 16 0 19968 98 2 8 1140850944 1 22144 0 0 0 5 0 0 0 22144 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 149 594 1063 169 22144 1090 1248 98 1 8 'In some situations you may wish to specify actions that take place before the stripping process starts. You can do this using the pre-stripping script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 22144 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 33 2 0 0 158 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -39 1488 149 1520 169 410 8 ##(Smalltalk.StatusBar)  98 18 0 19968 98 2 8 1140850700 1 22464 0 482 31 0 5 0 514 0 16 546 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 594 193 193 0 22464 0 8 4294903665 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 22464 0 9856 8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  8 'preStripScriptErrors' 202 208 98 1 22688 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 22464 0 0 1026 202 208 98 1 1090 1120 98 2 594 31 571 594 1063 41 22464 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 34 2 0 0 49 1 0 0] 98 0 1360 0 27 1378 2784 31 1456 -37 1488 571 1520 41 410 8 ##(Smalltalk.ReferenceView)  98 14 0 19968 98 2 8 1140850688 131073 23008 0 0 0 5 0 0 0 23008 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.SmalltalkWorkspace)  8 #resource_Default_view 0 1026 202 208 98 1 1090 1120 98 2 594 31 321 594 1061 251 23008 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 33 2 0 0 29 1 0 0] 9312 1360 0 27 1378 2784 31 1456 -39 1488 321 1520 251 234 256 98 2 23008 8 'preStripScript' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 19968 1090 1248 98 1 8 'Step 7' 19968 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 6 20816 22144 23008 22464 20496 20096 1360 0 27 4162 11 410 672 98 15 0 4000 98 2 8 1140850688 131073 23584 0 482 31 0 5 0 0 0 23584 754 234 240 98 18 410 6128 98 16 0 23584 98 2 8 1140924451 1 23712 6194 0 0 6240 32 898 928 0 5 0 0 0 23712 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 81 649 594 369 49 23712 1090 1248 98 1 8 'Compile E&xternal Structures' 23712 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 98 0 1360 0 27 1378 2784 81 2352 369 1488 649 1520 49 410 4336 98 16 0 23584 98 2 8 1140850944 1 24064 0 0 0 5 0 0 0 24064 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 549 594 995 89 24064 1090 1248 98 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 24064 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 255 1 0 0 62 1 0 0] 98 0 1360 0 27 1378 2784 29 1456 -107 1488 549 1520 89 410 6128 98 16 0 23584 98 2 8 1140924451 1 24384 6194 0 0 6240 32 898 928 0 5 0 0 0 24384 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 81 459 594 369 41 24384 1090 1248 98 1 8 'Strip class &GUIDs' 24384 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 98 0 1360 0 27 1378 2784 81 2352 369 1488 459 1520 41 410 6128 98 16 0 23584 98 2 8 1140924451 1 24736 6194 0 0 6240 32 898 928 0 5 0 0 0 24736 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 81 389 594 369 69 24736 1090 1248 98 1 8 'Retain instance &variable names' 24736 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 98 0 1360 0 27 1378 2784 81 2352 369 1488 389 1520 69 410 4336 98 16 0 23584 98 2 8 1140850944 1 25088 0 0 0 5 0 0 0 25088 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 149 594 995 99 25088 1090 1248 98 1 8 'Class category information is automatically stripped from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 25088 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 255 1 0 0 123 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -107 1488 149 1520 99 410 4688 98 14 0 23584 98 2 8 1140850695 65 25408 0 898 928 0 5 0 0 0 25408 0 8 4294904055 1026 202 208 98 1 1090 1120 98 2 594 -17 521 594 1167 229 25408 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 62 2 0 0 118 1 0 0] 98 0 1360 0 27 1378 2784 -17 1456 19 1488 521 1520 229 410 6128 98 16 0 23584 98 2 8 1140924451 1 25680 6194 0 0 6240 16 898 928 0 5 0 0 0 25680 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 81 249 594 369 59 25680 1090 1248 98 1 8 'Strip class meta-&information' 25680 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 98 0 1360 0 27 1378 2784 81 2352 369 1488 249 1520 59 410 4336 98 16 0 23584 98 2 8 1140850944 1 26032 0 0 0 5 0 0 0 26032 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 321 594 995 69 26032 1090 1248 98 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 26032 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 255 1 0 0 194 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -107 1488 321 1520 69 410 672 98 15 0 23584 98 2 8 1140850688 131073 26352 0 898 928 0 5 0 0 0 26352 626 19 1 0 0 410 8144 98 21 0 26352 98 2 8 1140850944 1 26448 6194 0 32 8226 8258 8288 98 0 8258 8336 8352 8370 0 16 8416 8 'Resources\LagoonLogo.bmp' 8464 8498 0 0 594 321 327 594 8467 8627 482 31 0 5 0 0 0 26448 0 8 4294902547 4418 0 0 0 26592 8608 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1019 11 594 103 101 26448 1090 1248 98 1 8 'Graphic' 26448 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 1 0 0 5 0 0 0 48 2 0 0 55 0 0 0] 98 0 1360 0 27 0 410 8848 98 18 0 26352 98 2 8 1140855108 1 26928 0 898 928 0 5 0 0 0 26928 0 8 1831043579 4418 0 0 41 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 5 1090 1120 98 2 594 31 11 594 971 101 26928 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 5:\f1\fs16 
\par 
\par Decide what meta-level information is required at runtime
\par \b0 
\par 
\par 
\par }
' 26928 1090 5536 98 1 5570 3 1 3 26928 1090 5616 98 1 32 26928 1090 9296 9312 26928 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 244 1 0 0 55 0 0 0] 98 0 1360 0 27 234 256 9312 3730 594 31 11 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1131 121 26352 1090 1248 98 1 8 'Heading' 26352 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 53 2 0 0 60 0 0 0] 98 2 26928 26448 1360 0 27 1378 2784 1 1456 1 1488 1 1520 121 234 256 98 8 23712 8 'compileExternalStructures' 25680 8 'stripClassInfo' 24736 8 'retainInstVarNames' 24384 8 'stripClassGuids' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 23584 1090 1248 98 1 8 'Step 5' 23584 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 9 26352 25088 25680 26032 24736 24384 24064 23712 25408 1360 0 27 4162 13 410 672 98 15 0 4000 98 2 8 1140850688 131073 28000 0 482 31 0 5 0 0 0 28000 754 234 240 98 14 410 672 98 15 0 28000 98 2 8 1140850688 131073 28128 0 898 928 0 5 0 0 0 28128 626 19 1 0 0 410 8144 98 21 0 28128 98 2 8 1140850944 1 28224 6194 0 32 8226 8258 8288 98 0 8258 8336 8352 8370 0 16 8416 8 'Resources\LagoonLogo.bmp' 8464 8498 0 0 594 321 327 594 8467 8627 482 31 0 5 0 0 0 28224 0 8 4294902547 4418 0 0 0 28368 8608 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1019 11 594 103 101 28224 1090 1248 98 1 8 'Graphic' 28224 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 1 0 0 5 0 0 0 48 2 0 0 55 0 0 0] 98 0 1360 0 27 0 410 8848 98 18 0 28128 98 2 8 1140855108 1 28704 0 898 928 0 5 0 0 0 28704 0 8 1831043579 4418 0 0 41 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 5 1090 1120 98 2 594 31 11 594 971 101 28704 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Final Step:
\par \f1\fs16 
\par Deployment\b0 
\par 
\par 
\par 
\par }
' 28704 1090 5536 98 1 5570 3 1 3 28704 1090 5616 98 1 32 28704 1090 9296 9312 28704 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 244 1 0 0 55 0 0 0] 98 0 1360 0 27 234 256 9312 3730 594 31 11 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1131 121 28128 1090 1248 98 1 8 'Heading' 28128 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 53 2 0 0 60 0 0 0] 98 2 28704 28224 1360 0 27 1378 2784 1 1456 1 1488 1 1520 121 410 4336 98 16 0 28000 98 2 8 1140850944 1 29456 0 0 0 5 0 0 0 29456 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 81 269 594 189 49 29456 1090 1248 98 1 8 'E&xecutable name:' 29456 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 98 0 1360 0 27 1378 2784 81 2352 189 1488 269 1520 49 410 4336 98 16 0 28000 98 2 8 1140850944 1 29776 0 0 0 5 0 514 0 16 546 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 22608 0 29776 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 349 594 1005 139 29776 1090 1248 98 1 8 'Your development image will first be saved in its current state. 

The stripping process that follows may take several minutes depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that image stripping is complete.' 29776 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 4 2 0 0 243 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -97 1488 349 1520 139 410 4336 98 16 0 28000 98 2 8 1140850955 262145 30144 0 0 0 5 0 0 0 30144 0 8 4294903215 4418 0 0 0 1026 202 208 98 1 1090 1120 98 2 594 281 269 594 753 41 30144 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 4 2 0 0 154 0 0 0] 98 0 1360 0 27 1378 2784 281 1456 -97 1488 269 1520 41 410 4336 98 16 0 28000 98 2 8 1140850944 1 30416 0 0 0 5 0 0 0 30416 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 161 594 1005 81 30416 1090 1248 98 1 8 'You can choose to deploy this image to an executable now according to the image stripping options you have chosen. To do this click ''Deploy''.
' 30416 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 4 2 0 0 120 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -97 1488 161 1520 81 410 4336 98 16 0 28000 98 2 8 1140850944 1 30736 0 0 0 5 0 514 0 16 546 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 22608 0 30736 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 529 594 965 81 30736 1090 1248 98 1 8 'It is very important that, should the stripping operation fail for whatever reason, you do not save the partially stripped image.' 30736 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 240 1 0 0 48 1 0 0] 98 0 1360 0 27 1378 2784 29 1456 -137 1488 529 1520 81 410 4336 98 16 0 28000 98 2 8 1140850944 1 31104 0 0 0 5 0 0 0 31104 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 641 594 995 59 31104 1090 1248 98 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 31104 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 255 1 0 0 93 1 0 0] 98 0 1360 0 27 1378 2784 29 1456 -107 1488 641 1520 59 234 256 98 2 30144 8 'executablePath2' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 28000 1090 1248 98 1 8 'Final step' 28000 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 7 28128 30416 29456 30144 30736 29776 31104 1360 0 27 4162 15 410 672 98 15 0 4000 98 2 8 1140850688 131073 31696 0 898 928 0 7 0 0 0 31696 754 234 240 98 8 410 8144 98 21 0 31696 98 2 8 1140850944 1 31824 6194 0 32 8226 8258 8288 98 0 8258 8336 8352 8370 0 16 8416 8 'Resources\LagoonSideBar.jpg' 8464 8498 0 0 594 381 761 594 10055 20109 898 928 0 7 0 0 0 31824 0 8 4294902547 4418 0 0 0 31968 8 #centered 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 379 741 31824 1090 1248 98 1 8 'Lagoon Graphic' 31824 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 98 0 1360 0 27 1378 2784 1 2352 379 1488 1 1520 741 410 8848 98 18 0 31696 98 2 8 1140855110 1 32336 0 898 928 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 962 8 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 32466 1 962 8 #bePlain 8 '&Plain' 1 1 0 0 0 32466 1 962 8 #toggleBold 8 '&Bold' 1 1 0 0 0 32466 1 962 8 #toggleItalic 8 '&Italic' 1 1 0 0 0 32466 1 962 8 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 32546 4097 32418 0 16 98 3 32466 1 962 8 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 32466 1 962 8 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 32466 1 962 8 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 32546 4097 32466 1 962 8 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 32336 0 8 1831043579 4418 0 0 43 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 6 1090 1120 98 2 594 419 681 594 549 49 32336 1090 8 #contextMenu: 98 1 32432 32336 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click \b Next \b0 to continue.
\par 
\par 
\par \pard\qc 
\par }
' 32336 1090 5536 98 1 5570 3 1 3 32336 1090 5616 98 1 32 32336 1090 9296 9312 32336 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 98 0 1360 0 27 1378 2784 419 2352 549 1488 681 1520 49 410 5296 98 16 0 31696 98 2 8 1140850816 262145 33632 0 196934 1 ##(Smalltalk.RGB)  32238571 0 7 0 0 0 33632 0 8 4294903191 4418 0 0 35 1026 202 208 98 3 1090 1120 98 2 594 421 491 594 645 41 33632 1090 5536 98 1 5570 3 1 3 33632 1090 5616 98 1 32 33632 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 98 0 1360 0 27 1378 2784 421 1456 -49 14864 3 1520 41 410 8848 98 18 0 31696 98 2 8 1140855110 1 34016 0 898 928 0 7 32418 0 16 98 10 32466 1 962 32512 8 '&Font...' 1 1 0 0 0 32546 4097 32466 1 962 32608 8 '&Plain' 1 1 0 0 0 32466 1 962 32672 8 '&Bold' 1 1 0 0 0 32466 1 962 32736 8 '&Italic' 1 1 0 0 0 32466 1 962 32800 8 '&Underlined' 1 1 0 0 0 32546 4097 32418 0 16 98 3 32466 1 962 32912 8 '&Left' 1 1 0 0 0 32466 1 962 32976 8 '&Centre' 1 1 0 0 0 32466 1 962 33040 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 32546 4097 32466 1 962 33136 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 34016 0 8 1831043579 4418 0 0 43 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 6 1090 1120 98 2 594 419 1 594 649 489 34016 1090 33376 98 1 34096 34016 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 
\par \f1\fs24 Welcome to the Dolphin Lagoon Application Deployment Wizard\f0\fs16 
\par 
\par This wizard helps you configure an ImageStripper that can be used to strip unnecessary objects from your Dolphin image and to deploy it to an executable (EXE) file. 
\par 
\par 
\par 
\par 
\par If the ImageStripper attached to this wizard has already been configured then you may immediately deploy this image to the executable file below by clicking the \b Deploy \b0 button.
\par 
\par }
' 34016 1090 5536 98 1 5570 3 1 3 34016 1090 5616 98 1 32 34016 1090 9296 9312 34016 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 98 0 1360 0 27 1378 2784 419 1456 -47 1488 1 1520 489 234 256 98 2 33632 8 'executablePath1' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 31696 1090 1248 98 1 8 'Intro' 31696 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 4 31824 34016 33632 32336 1360 0 27 4162 17 410 672 98 15 0 4000 98 2 8 1140850688 131073 35376 0 482 31 0 5 0 0 0 35376 754 234 240 98 8 410 4336 98 16 0 35376 98 2 8 1140850944 1 35504 0 0 0 5 0 0 0 35504 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 81 401 594 249 121 35504 1090 1248 98 1 8 'Choose a the class of &ImageStripper to install.' 35504 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 98 0 1360 0 27 1378 2784 81 2352 249 1488 401 1520 121 410 9680 98 17 0 35376 98 2 8 1144063491 1025 35824 9746 202 208 9312 0 9808 898 928 0 5 0 0 0 35824 0 8 4294903929 9856 9312 401 1026 202 208 98 1 1090 1120 98 2 594 349 409 594 647 43 35824 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 98 0 1360 0 27 1378 2784 349 1456 -119 1488 409 1520 41 410 672 98 15 0 35376 98 2 8 1140850688 131073 36128 0 898 928 0 5 0 0 0 36128 626 19 1 0 0 410 8144 98 21 0 36128 98 2 8 1140850944 1 36224 6194 0 32 8226 8258 8288 98 0 8258 8336 8352 8370 0 16 8416 8 'Resources\LagoonLogo.bmp' 8464 8498 0 0 594 321 327 594 8467 8627 482 31 0 5 0 0 0 36224 0 8 4294902547 4418 0 0 0 36368 8608 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1003 11 594 103 101 36224 1090 1248 98 1 8 'Graphic' 36224 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 98 0 1360 0 27 0 410 8848 98 18 0 36128 98 2 8 1140855108 1 36704 0 898 928 0 5 0 0 0 36704 0 8 1831043579 4418 0 0 41 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 5 1090 1120 98 2 594 31 11 594 955 101 36704 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 1:\f1\fs16 
\par 
\par Choose an ImageStripper to perform the deployment process\b0 
\par 
\par 
\par 
\par }
' 36704 1090 5536 98 1 5570 3 1 3 36704 1090 5616 98 1 32 36704 1090 9296 9312 36704 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 98 0 1360 0 27 234 256 9312 3730 594 31 11 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 121 36128 1090 1248 98 1 8 'Heading' 36128 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 98 2 36704 36224 1360 0 27 1378 2784 1 1456 1 1488 1 1520 121 410 4336 98 16 0 35376 98 2 8 1140850944 1 37456 0 0 0 5 0 0 0 37456 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 229 594 979 149 37456 1090 1248 98 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 37456 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -107 1488 229 1520 149 234 256 98 2 35824 8 'imageStripperClass' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 35376 1090 1248 98 1 8 'Step 1' 35376 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 4 36128 37456 35504 35824 1360 0 27 4162 19 410 672 98 15 0 4000 98 2 8 1140850688 131073 38048 0 482 31 0 5 0 0 0 38048 754 234 240 98 18 410 6128 98 16 0 38048 98 2 8 1140924451 1 38176 6194 0 0 6240 32 898 928 0 5 0 0 0 38176 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 69 369 594 379 41 38176 1090 1248 98 1 8 'Strip empty &Method Dictionaries' 38176 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 0 0 0 184 0 0 0 223 0 0 0 204 0 0 0] 98 0 1360 0 27 1378 2784 69 2352 379 1488 369 1520 41 410 6128 98 16 0 38048 98 2 8 1140924451 1 38528 6194 0 0 6240 32 898 928 0 5 0 0 0 38528 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 81 209 594 369 41 38528 1090 1248 98 1 8 'Strip &Class Builder' 38528 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 98 0 1360 0 27 1378 2784 81 2352 369 1488 209 1520 41 410 4688 98 14 0 38048 98 2 8 1140850695 65 38880 0 898 928 0 5 0 0 0 38880 0 8 4294904055 1026 202 208 98 1 1090 1120 98 2 594 -17 441 594 1167 309 38880 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 220 0 0 0 62 2 0 0 118 1 0 0] 98 0 1360 0 27 1378 2784 -17 1456 19 1488 441 1520 309 410 4336 98 16 0 38048 98 2 8 1140850944 1 39152 0 0 0 5 0 0 0 39152 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 489 594 983 49 39152 1090 1248 98 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 39152 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 244 0 0 0 249 1 0 0 12 1 0 0] 98 0 1360 0 27 1378 2784 29 1456 -119 1488 489 1520 49 410 4336 98 16 0 38048 98 2 8 1140850944 1 39472 0 0 0 5 0 0 0 39472 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 161 594 1005 49 39472 1090 1248 98 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 39472 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 4 2 0 0 104 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -97 1488 161 1520 49 410 672 98 15 0 38048 98 2 8 1140850688 131073 39792 0 898 928 0 5 0 0 0 39792 626 19 1 0 0 410 8144 98 21 0 39792 98 2 8 1140850944 1 39888 6194 0 32 8226 8258 8288 98 0 8258 8336 8352 8370 0 16 8416 8 'Resources\LagoonLogo.bmp' 8464 8498 0 0 594 321 327 594 8467 8627 482 31 0 5 0 0 0 39888 0 8 4294902547 4418 0 0 0 40032 8608 1 0 0 1026 202 208 98 2 1090 1120 98 2 594 1019 11 594 103 101 39888 1090 1248 98 1 8 'Graphic' 39888 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 253 1 0 0 5 0 0 0 48 2 0 0 55 0 0 0] 98 0 1360 0 27 0 410 8848 98 18 0 39792 98 2 8 1140855108 1 40368 0 898 928 0 5 0 0 0 40368 0 8 1831043579 4418 0 0 41 0 8962 8 #[0 0 0 0 0 0 0 0 176 0 181 1] 1026 202 208 98 5 1090 1120 98 2 594 31 11 594 971 101 40368 1090 1248 98 1 9154 8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 6:\f1\fs16 
\par 
\par Miscellaneous stripping options\b0 
\par 
\par 
\par 
\par }
' 40368 1090 5536 98 1 5570 3 1 3 40368 1090 5616 98 1 32 40368 1090 9296 9312 40368 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 244 1 0 0 55 0 0 0] 98 0 1360 0 27 234 256 9312 3730 594 31 11 594 11 11 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1131 121 39792 1090 1248 98 1 8 'Heading' 39792 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 53 2 0 0 60 0 0 0] 98 2 40368 39888 1360 0 27 1378 2784 1 1456 1 1488 1 1520 121 410 6128 98 16 0 38048 98 2 8 1140924451 1 41120 6194 0 0 6240 16 898 928 0 5 0 0 0 41120 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 69 561 594 379 49 41120 1090 1248 98 1 8 'Fold duplicate s&trings' 41120 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 0 0 0 24 1 0 0 223 0 0 0 48 1 0 0] 98 0 1360 0 27 1378 2784 69 2352 379 1488 561 1520 49 410 4336 98 16 0 38048 98 2 8 1140850944 1 41472 0 0 0 5 0 0 0 41472 0 8 4294903215 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 29 289 594 995 59 41472 1090 1248 98 1 8 'If you don''t need to create new methods at runtime then instances of MethodDictionary that are empty can be removed.' 41472 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 144 0 0 0 255 1 0 0 173 0 0 0] 98 0 1360 0 27 1378 2784 29 1456 -107 1488 289 1520 59 410 6128 98 16 0 38048 98 2 8 1140924451 1 41792 6194 0 0 6240 16 898 928 0 5 0 0 0 41792 0 8 4294904055 4418 0 0 0 1026 202 208 98 2 1090 1120 98 2 594 69 629 594 379 41 41792 1090 1248 98 1 8 'Fold duplicate b&ytecode arrays' 41792 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 0 0 0 58 1 0 0 223 0 0 0 78 1 0 0] 98 0 1360 0 27 1378 2784 69 2352 379 1488 629 1520 41 234 256 98 8 38528 8 'stripClassBuilder' 41120 8 'stripDuplicateStrings' 41792 8 'stripDuplicateBytecodes' 38176 8 'stripEmptyMethodDictionaries' 0 1026 202 208 98 2 1090 1120 98 2 594 1 1 594 1115 721 38048 1090 1248 98 1 8 'Step 6' 38048 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 104 1 0 0] 98 9 39792 39472 38528 41472 38176 39152 41120 41792 38880 1360 0 27 31696 234 256 98 2 31696 8 'Intro' 0 1026 202 208 98 1 1090 1120 98 2 594 1 1 594 1119 725 4000 1298 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 106 1 0 0] 98 9 31696 35376 4192 11056 14384 23584 38048 19968 28000 1360 0 27 234 256 98 2 4000 8 'Steps' 3730 594 1 1 594 1 1 0 0 0 0 3 0 0 594 2049 881 594 1151 881 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 32 8 1987932644 1026 202 208 98 3 1090 1120 98 2 594 3359 21 594 1151 881 416 1090 1248 98 1 8 'Lagoon Deployment Wizard' 416 1090 8 #updateMenuBar 9312 416 1298 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 206 8 0 0 194 1 0 0] 98 2 4000 656 1360 0 27 )!

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

