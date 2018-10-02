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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 5 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 15 1 31 86 135 1] 328198 ##(Smalltalk.Point) 193 193 nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140916224 393217 640 nil nil nil 5 nil nil nil 640 852230 ##(Smalltalk.FramingLayout) 170 176 34 12 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 768 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 768 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #previousCard 8 '< &Back' 1 1 nil nil false nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 217 13 578 131 49 768 1010 #isEnabled: 8 #(false) 768 1010 #text: 34 1 8 '< &Back' 768 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 108 0 0 0 6 0 0 0 173 0 0 0 30 0 0 0] 8 #() 578 193 193 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #relativeParentWidth 524806 ##(Smalltalk.Fraction) 15 75 1282 #fixedViewLeft 131 1282 #fixedParentTop 1 1282 #fixedViewTop 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1392 nil 848 nil 5 nil nil nil 1392 nil 8 1915188384 898 #deploy 8 '&Deploy' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 19 13 578 139 49 1392 1010 #isEnabled: 8 #(false) 1392 1010 #text: 34 1 8 '&Deploy' 1392 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 0 6 0 0 0 78 0 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #fixedParentLeft 9 1344 139 1360 1 1376 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 1776 nil 848 nil 5 nil nil nil 1776 nil 8 1915188384 898 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 955 13 578 139 49 1776 1010 #text: 34 1 8 'Cancel' 1776 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 221 1 0 0 6 0 0 0 34 2 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #fixedViewRight -137 1282 #fixedParentRight -11 1360 1 1376 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2144 nil 848 nil 5 nil nil nil 2144 nil 8 1915188384 898 #ok 8 '&Save Configuration' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 685 13 578 241 49 2144 1010 #isEnabled: 8 #(false) 2144 1010 #text: 34 1 8 '&Save Configuration' 2144 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 86 1 0 0 6 0 0 0 206 1 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 1282 #fixedPreviousRight 11 1344 241 1360 1 1376 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2528 nil 848 nil 5 nil nil nil 2528 nil 8 1915188384 898 #nextCard 8 '&Next >' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 357 13 578 131 49 2528 1010 #isEnabled: 8 #(false) 2528 1010 #text: 34 1 8 '&Next >' 2528 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 178 0 0 0 6 0 0 0 243 0 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 2512 11 1344 131 1360 1 1376 49 410 ##(Smalltalk.PushButton) 34 20 nil 640 34 2 8 1140924416 1 2896 nil 848 nil 5 nil nil nil 2896 nil 8 1915188384 898 #reset 8 '&Reset' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 545 13 578 131 49 2896 1010 #isEnabled: 8 #(false) 2896 1010 #text: 34 1 8 '&Reset' 2896 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 1 0 0 6 0 0 0 81 1 0 0 30 0 0 0] 8 #() 1232 nil 29 1250 2112 -129 2128 -429 1360 1 1376 49 170 192 34 2 1392 8 'deploy' 590342 ##(Smalltalk.Rectangle) 578 11 13 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 723 578 1119 81 640 1010 #text: 34 1 8 'Buttons' 640 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 105 1 0 0 47 2 0 0 145 1 0 0] 34 6 1392 768 2528 2896 2144 1776 1232 nil 27 nil nil 410 ##(Smalltalk.WizardCardContainer) 34 15 nil 416 34 2 8 1140850688 393217 3584 nil nil nil 5 nil nil nil 3584 655878 ##(Smalltalk.CardLayout) 138 144 34 9 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 3744 nil nil nil 5 nil nil nil 3744 706 170 176 34 28 410 ##(Smalltalk.ContainerView) 34 15 nil 3744 34 2 8 1140850688 131073 3856 nil 848 nil 5 nil nil nil 3856 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 3856 34 2 8 1140850944 1 3936 721990 2 ##(Smalltalk.ValueHolder) nil false 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 4066 #hash 8 #() 657478 3 ##(Smalltalk.OLEPicture) nil true 1703942 ##(Smalltalk.InstallRelativeFileLocator) 8 'Resources\LagoonLogo.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 524806 ##(Smalltalk.IPicture) nil nil 578 321 327 578 8467 8627 721158 ##(Smalltalk.SystemColor) 31 nil 5 nil nil nil 3936 nil 8 4294902547 852486 ##(Smalltalk.NullConverter) nil nil nil 4160 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 3936 1010 #text: 34 1 8 'Graphic' 3936 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 3856 34 2 8 1140855108 1 4624 nil 848 nil 5 nil nil nil 4624 nil 8 1804752336 4386 nil nil 41 nil 655622 ##(Smalltalk.EDITSTREAM) 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 4624 1010 #text: 34 1 524550 ##(Smalltalk.RichText) 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 2: \par
\f1\fs16\par
Choose an Executable File and RuntimeSessionManager\b0\par
\par
\par
\par
}
' 4624 1010 #textLimit: 8 #(1073741823) 4624 1010 #resetCharFormat 8 #() 4624 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 5008 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 3856 1010 #text: 34 1 8 'Heading' 3856 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 4624 3936 1232 nil 27 1250 1760 1 2128 1 1360 1 1376 121 410 ##(Smalltalk.CheckBox) 34 16 nil 3744 34 2 8 1140924451 1 5360 4002 nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 5360 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 211 578 431 81 5360 1010 #text: 34 1 8 'Create single file, "To Go" distributable.' 5360 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 105 0 0 0 230 0 0 0 145 0 0 0] 8 #() 1232 nil 27 1250 1760 31 1344 431 1360 211 1376 81 410 ##(Smalltalk.CheckBox) 34 16 nil 3744 34 2 8 1140924451 1 5728 4002 nil nil 5456 true nil nil 5 nil nil nil 5728 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 661 578 251 41 5728 1010 #text: 34 1 8 'Log &class references' 5728 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 74 1 0 0 155 0 0 0 94 1 0 0] 8 #() 1232 nil 27 1250 1760 61 1344 251 1360 661 1376 41 410 ##(Smalltalk.StaticText) 34 16 nil 3744 34 2 8 1140850944 1 6064 nil nil nil 5 nil nil nil 6064 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 321 578 975 71 6064 1010 #text: 34 1 8 'When deployed, an executable will contain no development classes and a runtime session manager will be installed instead of the existing development session manager.' 6064 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 246 1 0 0 195 0 0 0] 8 #() 1232 nil 27 1250 1760 31 2128 -109 1360 321 1376 71 410 ##(Smalltalk.CheckBox) 34 16 nil 3744 34 2 8 1140924451 1 6384 4002 nil nil 5456 true nil nil 5 nil nil nil 6384 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 61 591 578 251 41 6384 1010 #text: 34 1 8 'Write &log file' 6384 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 30 0 0 0 39 1 0 0 155 0 0 0 59 1 0 0] 8 #() 1232 nil 27 1250 1760 61 1344 251 1360 591 1376 41 410 ##(Smalltalk.StaticText) 34 16 nil 3744 34 2 8 1140850944 1 6720 nil nil nil 5 nil nil nil 6720 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 511 578 1045 81 6720 1010 #text: 34 1 8 'The deployment process can write an HTML log file that describes the stripping actions performed and lists objects remaining in the image. This can be useful for debugging subsequent deployment problems.' 6720 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 255 0 0 0 25 2 0 0 39 1 0 0] 8 #() 1232 nil 27 1250 1760 31 2128 -39 1360 511 1376 81 410 ##(Smalltalk.PushButton) 34 20 nil 3744 34 2 8 1140924416 1 7040 nil 848 nil 5 nil nil nil 7040 nil 8 1915188384 898 #browseForExecutableName 8 '...' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 1025 151 578 49 41 7040 1010 #isEnabled: 8 #(false) 7040 1010 #text: 34 1 8 '...' 7040 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 2 0 0 75 0 0 0 24 2 0 0 95 0 0 0] 8 #() 1232 nil 29 1250 2112 -47 2128 -41 1360 151 1376 41 410 ##(Smalltalk.StaticText) 34 16 nil 3744 34 2 8 1140850944 1 7408 nil nil nil 5 nil nil nil 7408 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 43 399 578 381 81 7408 1010 #text: 34 1 8 'Choose the main Shell class or, alternatively, a subclass of &RuntimeSessionManager to install.' 7408 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 21 0 0 0 199 0 0 0 211 0 0 0 239 0 0 0] 8 #() 1232 nil 27 1250 1760 43 1344 381 1360 399 1376 81 410 ##(Smalltalk.GroupBox) 34 14 nil 3744 34 2 8 1140850695 65 7728 nil 848 nil 5 nil nil nil 7728 nil 8 1915188384 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 291 578 1155 211 7728 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 0 0 0 65 2 0 0 250 0 0 0] 8 #() 1232 nil 27 1250 1760 1 2128 41 1360 291 1376 211 410 ##(Smalltalk.StaticText) 34 16 nil 3744 34 2 8 1140850944 1 7984 nil nil nil 5 nil nil nil 7984 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 141 578 389 81 7984 1010 #text: 34 1 8 'What is the name of the e&xecutable file to which this image will be deployed?
' 7984 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 70 0 0 0 209 0 0 0 110 0 0 0] 8 #() 1232 nil 27 1250 1760 31 1344 389 1360 141 1376 81 410 ##(Smalltalk.PushButton) 34 20 nil 3744 34 2 8 1140924416 1 8304 nil 848 nil 5 nil nil nil 8304 nil 8 1915188384 898 #showLog 8 'S&how it' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 441 661 578 139 45 8304 1010 #isEnabled: 8 #(false) 8304 1010 #text: 34 1 8 'S&how it' 8304 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 74 1 0 0 33 1 0 0 96 1 0 0] 8 #() 1232 nil 29 1250 1760 441 1344 139 1360 661 1376 45 410 ##(Smalltalk.TextEdit) 34 16 nil 3744 34 2 8 1140916352 1025 8672 nil 848 nil 5 nil nil nil 8672 nil 8 1915280032 4386 nil nil 1 946 138 144 34 1 1010 #createAt:extent: 34 2 578 431 151 578 575 41 8672 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 215 0 0 0 75 0 0 0 246 1 0 0 95 0 0 0] 8 #() 1232 nil 27 1250 1760 431 2128 -109 1360 151 1376 41 410 ##(Smalltalk.TextEdit) 34 16 nil 3744 34 2 8 1140850688 262145 8944 nil nil nil 5 nil nil nil 8944 nil 8 1915280032 4386 nil nil 1 946 138 144 34 2 1010 #createAt:extent: 34 2 578 441 591 578 565 41 8944 1010 #isEnabled: 8 #(false) 8944 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 39 1 0 0 246 1 0 0 59 1 0 0] 8 #() 1232 nil 27 1250 1760 441 2128 -109 1360 591 1376 41 410 ##(Smalltalk.ComboBox) 34 17 nil 3744 34 2 8 1144063491 1025 9248 590662 2 ##(Smalltalk.ListModel) 138 144 5008 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 848 nil 5 nil nil nil 9248 nil 8 1915002384 ##(Smalltalk.BasicListAbstract) 5008 401 946 138 144 34 1 1010 #createAt:extent: 34 2 578 441 411 578 565 43 9248 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 220 0 0 0 205 0 0 0 246 1 0 0 226 0 0 0] 8 #() 1232 nil 27 1250 1760 441 2128 -109 1360 411 1376 43 170 192 34 14 8672 8 'executableName' 5360 8 'isToGo' 6384 8 'writeLogFile' 8304 8 'showLog' 8944 8 'logFileName' 5728 8 'logReferencesToClasses' 9248 8 'runtimeSessionManagerClass' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 3744 1010 #text: 34 1 8 'Step 2' 3744 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 14 3856 7984 8672 7040 5360 6064 7408 9248 6720 6384 5728 8944 8304 7728 1232 nil 27 3714 5 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 9952 nil nil nil 5 nil nil nil 9952 706 170 176 34 12 410 ##(Smalltalk.CheckBox) 34 16 nil 9952 34 2 8 1140924451 1 10064 4002 nil nil 5456 true nil nil 5 nil nil nil 10064 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 59 619 578 329 49 10064 1010 #text: 34 1 8 'Strip redundant &packages' 10064 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 29 0 0 0 53 1 0 0 193 0 0 0 77 1 0 0] 8 #() 1232 nil 27 1250 1760 59 1344 329 1360 619 1376 49 410 ##(Smalltalk.StaticText) 34 16 nil 9952 34 2 8 1140850944 262145 10400 nil nil nil 5 nil nil nil 10400 nil 8 1915124368 4386 nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 361 389 578 647 41 10400 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 180 0 0 0 194 0 0 0 247 1 0 0 214 0 0 0] 8 #() 1232 nil 27 1250 1760 361 2128 -107 1360 389 1376 41 410 ##(Smalltalk.StaticText) 34 16 nil 9952 34 2 8 1140850944 1 10672 nil nil nil 5 nil nil nil 10672 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 389 578 201 41 10672 1010 #text: 34 1 8 'Root package:' 10672 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 140 0 0 0 214 0 0 0] 8 #() 1232 nil 27 1250 1760 81 1344 201 1360 389 1376 41 410 ##(Smalltalk.StaticText) 34 16 nil 9952 34 2 8 1140850944 1 10992 nil nil nil 5 nil nil nil 10992 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 499 578 979 109 10992 1010 #text: 34 1 8 'The stripper is most efficient if it is first allowed to remove packages which it considers to be redundant. Selecting this option (recommended) will strip out any packages that are not pre-requisites of the root package above.' 10992 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 249 0 0 0 247 1 0 0 47 1 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -107 1360 499 1376 109 410 ##(Smalltalk.StaticText) 34 16 nil 9952 34 2 8 1140850944 1 11312 nil nil nil 5 nil nil nil 11312 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 171 578 975 191 11312 1010 #text: 34 1 8 'The ImageStripper must be associated with a root package so it can best determine the redundant objects in the image that can be removed. Note also that the image stripper configuration is saved in this package.

Currently the stripper is set to use the following root package. To choose a different root package you should re-launch the wizard from the Package (or System) browser with the appropriate package selected.' 11312 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 85 0 0 0 246 1 0 0 180 0 0 0] 8 #() 1232 nil 27 1250 1760 31 2128 -109 1360 171 1376 191 410 ##(Smalltalk.ContainerView) 34 15 nil 9952 34 2 8 1140850688 131073 11632 nil 848 nil 5 nil nil nil 11632 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 11632 34 2 8 1140850944 1 11712 4002 nil false 4034 4066 #= 8 #() 4066 #hash 4128 4146 nil true 4192 8 'Resources\LagoonLogo.bmp' 4240 4274 nil nil 578 321 327 578 8467 8627 4352 nil 5 nil nil nil 11712 nil 8 4294902547 4386 nil nil nil 11856 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 11712 1010 #text: 34 1 8 'Graphic' 11712 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 11632 34 2 8 1140855108 1 12176 nil 848 nil 5 nil nil nil 12176 nil 8 1804752336 4386 nil nil 41 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 12176 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 3:\f1\fs16\par
\par
Configure how the ImageStripper removes unwanted packages\par
\b0\par
\par
\par
}
' 12176 1010 #textLimit: 8 #(1073741823) 12176 1010 #resetCharFormat 5008 12176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 5008 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 11632 1010 #text: 34 1 8 'Heading' 11632 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 12176 11712 1232 nil 27 1250 1760 1 2128 1 1360 1 1376 121 170 192 34 4 10400 8 'rootPackage' 10064 8 'stripRedundantPackages' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 9952 1010 #text: 34 1 8 'Step 3' 9952 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 11632 11312 10672 10400 10992 10064 1232 nil 27 3714 7 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 13152 nil nil nil 5 nil nil nil 13152 706 170 176 34 24 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 13264 4002 nil nil 5456 true nil nil 5 nil nil nil 13264 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 641 217 578 403 49 13264 1010 #text: 34 1 8 'Strip redundant &resources' 13264 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 108 0 0 0 9 2 0 0 132 0 0 0] 8 #() 1232 nil 27 1250 2512 151 1344 403 1282 #fixedPreviousTop 1 1376 49 410 ##(Smalltalk.StaticText) 34 16 nil 13152 34 2 8 1140850944 1 13616 nil nil nil 5 nil nil nil 13616 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 315 578 1019 121 13616 1010 #text: 34 1 8 'Given a set of classes that the ImageStripper believes should be preserved in the image it can then attempt to determine the methods that can never be called and these can then be removed. This step may inadvertently remove some methods that are only called by #perform:. Aspect setting methods are commonly called in this manner and you can opt to forcibly preserve these.' 13616 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 157 0 0 0 11 2 0 0 217 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -67 1282 #fixedPreviousBottom 51 1376 121 410 ##(Smalltalk.StaticText) 34 16 nil 13152 34 2 8 1140850944 1 13952 nil nil nil 5 nil nil nil 13952 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 1029 69 13952 1010 #text: 34 1 8 'The ImageStripper automatically removes some classes, such as those used only for development. You can also ask for other redundant classes and resources to be stripped (recommended).' 13952 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 16 2 0 0 108 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -57 1360 149 1376 69 410 ##(Smalltalk.StaticText) 34 16 nil 13152 34 2 8 1140850944 1 14272 nil nil nil 5 nil nil nil 14272 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 533 578 1079 49 14272 1010 #text: 34 1 8 'Some methods which may not be marked as redundant can also be removed.' 14272 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 10 1 0 0 41 2 0 0 34 1 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -7 13936 51 1376 49 410 ##(Smalltalk.GroupBox) 34 14 nil 13152 34 2 8 1140850695 65 14592 nil 848 nil 5 nil nil nil 14592 nil 8 1915188384 946 138 144 34 1 1010 #createAt:extent: 34 2 578 -17 281 578 1151 229 14592 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 140 0 0 0 54 2 0 0 254 0 0 0] 8 #() 1232 nil 27 1250 1760 -17 2128 19 1360 281 1376 229 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 14848 4002 nil nil 5456 true nil nil 5 nil nil nil 14848 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 217 578 421 49 14848 1010 #text: 34 1 8 'Strip redundant &classes' 14848 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 108 0 0 0 245 0 0 0 132 0 0 0] 8 #() 1232 nil 27 1250 1760 71 1344 421 13936 1 1376 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 15184 4002 nil nil 5456 false nil nil 5 nil nil nil 15184 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 641 435 578 403 49 15184 1010 #text: 34 1 8 'Preserve &aspect set methods' 15184 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 217 0 0 0 9 2 0 0 241 0 0 0] 8 #() 1232 nil 27 1250 2512 151 1344 403 13600 1 1376 49 410 ##(Smalltalk.ContainerView) 34 15 nil 13152 34 2 8 1140850688 131073 15520 nil 848 nil 5 nil nil nil 15520 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 15520 34 2 8 1140850944 1 15600 4002 nil false 4034 4066 #= 8 #() 4066 #hash 4128 4146 nil true 4192 8 'Resources\LagoonLogo.bmp' 4240 4274 nil nil 578 321 327 578 8467 8627 4352 nil 5 nil nil nil 15600 nil 8 4294902547 4386 nil nil nil 15744 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 15600 1010 #text: 34 1 8 'Graphic' 15600 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 15520 34 2 8 1140855108 1 16064 nil 848 nil 5 nil nil nil 16064 nil 8 1804752336 4386 nil nil 41 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 16064 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 4:\par
\f1\fs16\par
\f0 Configure how the ImageStripper removes unwanted classes and methods\b0\f1\par
\par
\par
\par
}
' 16064 1010 #textLimit: 8 #(1073741823) 16064 1010 #resetCharFormat 5008 16064 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 5008 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 15520 1010 #text: 34 1 8 'Heading' 15520 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 16064 15600 1232 nil 27 1250 1760 1 2128 1 1360 1 1376 121 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 16752 4002 nil nil 5456 false nil nil 5 nil nil nil 16752 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 641 581 578 403 49 16752 1010 #text: 34 1 8 'Strip #shouldNot&Implement methods' 16752 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 34 1 0 0 9 2 0 0 58 1 0 0] 8 #() 1232 nil 27 1250 2512 151 1344 403 13600 1 1376 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 17088 4002 nil nil 5456 false nil nil 5 nil nil nil 17088 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 435 578 421 49 17088 1010 #text: 34 1 8 'Strip redundant &methods' 17088 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 217 0 0 0 245 0 0 0 241 0 0 0] 8 #() 1232 nil 27 1250 1760 71 1344 421 13936 1 1376 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 17424 4002 nil nil 5456 false nil nil 5 nil nil nil 17424 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 581 578 421 49 17424 1010 #text: 34 1 8 'Strip #&deprecated methods' 17424 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 34 1 0 0 245 0 0 0 58 1 0 0] 8 #() 1232 nil 27 1250 1760 71 1344 421 13936 1 1376 49 410 ##(Smalltalk.CheckBox) 34 16 nil 13152 34 2 8 1140924451 1 17760 4002 nil nil 5456 false nil nil 5 nil nil nil 17760 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 645 578 421 49 17760 1010 #text: 34 1 8 'Strip #&subclassResponsibility methods' 17760 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 66 1 0 0 245 0 0 0 90 1 0 0] 8 #() 1232 nil 27 1250 1760 71 1344 421 13936 17 1376 49 170 192 34 14 17424 8 'stripDeprecatedMethods' 17760 8 'stripSubclassResponsibility' 14848 8 'stripRedundantClasses' 13264 8 'stripRedundantResources' 16752 8 'stripShouldNotImplement' 15184 8 'preserveAspectSetters' 17088 8 'stripRedundantMethods' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 13152 1010 #text: 34 1 8 'Step 4' 13152 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 12 15520 13952 14848 13264 13616 17088 15184 14272 17424 16752 17760 14592 1232 nil 27 3714 9 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 18464 nil nil nil 5 nil nil nil 18464 706 170 176 34 12 410 ##(Smalltalk.StaticText) 34 16 nil 18464 34 2 8 1140850944 1 18576 nil nil nil 5 nil nil nil 18576 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 1047 169 18576 1010 #text: 34 1 8 'In some situations you may wish to specify actions that take place before the stripping process starts. You can do this using the pre-stripping script below. This script is also helpful when setting up custom ImageStrippers that have configuration options that are not catered for directly by this wizard.

Note: In the workspace below, the evaluation context, "self" is the ImageStripper. 
Use Accept to test compile your changes.' 18576 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 25 2 0 0 158 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -39 1360 149 1376 169 410 ##(Smalltalk.ContainerView) 34 15 nil 18464 34 2 8 1140850688 131073 18896 nil 848 nil 5 nil nil nil 18896 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 18896 34 2 8 1140850944 1 18976 4002 nil false 4034 4066 #= 8 #() 4066 #hash 4128 4146 nil true 4192 8 'Resources\LagoonLogo.bmp' 4240 4274 nil nil 578 321 327 578 8467 8627 4352 nil 5 nil nil nil 18976 nil 8 4294902547 4386 nil nil nil 19120 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 18976 1010 #text: 34 1 8 'Graphic' 18976 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 18896 34 2 8 1140855108 1 19440 nil 848 nil 5 nil nil nil 19440 nil 8 1804752336 4386 nil nil 41 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 19440 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 7:\f1\fs16\par
\par
Configure any additional actions using a Pre-Strip Script and Custom options\par
\b0\par
}
' 19440 1010 #textLimit: 8 #(1073741823) 19440 1010 #resetCharFormat 5008 19440 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 5008 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 18896 1010 #text: 34 1 8 'Heading' 18896 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 19440 18976 1232 nil 27 1250 1760 1 2128 1 1360 1 1376 121 410 ##(Smalltalk.StatusBar) 34 18 nil 18464 34 2 8 1140850700 1 20128 nil nil nil 5 nil 498 nil true 530 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 199 4 0 134 87 1 0 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 578 193 193 nil 20128 nil 8 1914952576 170 192 34 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 20128 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'preStripScriptErrors' 138 144 34 1 20320 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 20128 nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 31 571 578 1047 41 20128 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 29 1 0 0 26 2 0 0 49 1 0 0] 8 #() 1232 nil 27 1250 1760 31 2128 -37 1360 571 1376 41 410 ##(Smalltalk.ReferenceView) 34 14 nil 18464 34 2 8 1140850688 131073 20624 nil nil nil 5 nil nil nil 20624 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 31 321 578 1045 251 20624 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 160 0 0 0 25 2 0 0 29 1 0 0] 5008 1232 nil 27 1250 1760 31 2128 -39 1360 321 1376 251 410 ##(Smalltalk.PushButton) 34 20 nil 18464 34 2 8 1140924416 1 20880 nil 848 nil 5 nil nil nil 20880 nil 8 1915188384 898 #editCustomOptions 8 'Custom &Options' 1 1 nil nil false nil nil nil 946 138 144 34 3 1010 #createAt:extent: 34 2 578 881 661 578 211 51 20880 1010 #isEnabled: 8 #(false) 20880 1010 #text: 34 1 8 'Custom &Options' 20880 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 184 1 0 0 74 1 0 0 33 2 0 0 99 1 0 0] 8 #() 1232 nil 29 1250 1760 881 1344 211 1360 661 1376 51 410 ##(Smalltalk.StaticText) 34 16 nil 18464 34 2 8 1140850944 1 21248 nil nil nil 5 nil nil nil 21248 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 651 578 791 71 21248 1010 #text: 34 1 8 'Some ImageStrippers allow custom configuration in addition to that available in this wizard. Click here to edit these custom options:' 21248 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 69 1 0 0 154 1 0 0 104 1 0 0] 8 #() 1232 nil 27 1250 1760 31 1344 791 1360 651 1376 71 170 192 34 2 20624 8 'preStripScript' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 18464 1010 #text: 34 1 8 'Step 7' 18464 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 6 18896 18576 20624 20128 21248 20880 1232 nil 27 3714 11 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 21840 nil nil nil 5 nil nil nil 21840 706 170 176 34 18 410 ##(Smalltalk.StaticText) 34 16 nil 21840 34 2 8 1140850944 1 21952 nil nil nil 5 nil nil nil 21952 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 549 578 979 89 21952 1010 #text: 34 1 8 'The ExternalStructure templates (defined by their #defineFields methods) can be removed by compiling the structure definitions. This saves space but means that published aspects are not available at runtime.' 21952 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 18 1 0 0 247 1 0 0 62 1 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -107 1360 549 1376 89 410 ##(Smalltalk.CheckBox) 34 16 nil 21840 34 2 8 1140924451 1 22272 4002 nil nil 5456 false nil nil 5 nil nil nil 22272 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 389 578 369 69 22272 1010 #text: 34 1 8 'Retain instance &variable names' 22272 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 194 0 0 0 224 0 0 0 228 0 0 0] 8 #() 1232 nil 27 1250 1760 81 1344 369 1360 389 1376 69 410 ##(Smalltalk.ContainerView) 34 15 nil 21840 34 2 8 1140850688 131073 22608 nil 848 nil 5 nil nil nil 22608 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 22608 34 2 8 1140850944 1 22688 4002 nil false 4034 4066 #= 8 #() 4066 #hash 4128 4146 nil true 4192 8 'Resources\LagoonLogo.bmp' 4240 4274 nil nil 578 321 327 578 8467 8627 4352 nil 5 nil nil nil 22688 nil 8 4294902547 4386 nil nil nil 22832 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 22688 1010 #text: 34 1 8 'Graphic' 22688 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 22608 34 2 8 1140855108 1 23152 nil 848 nil 5 nil nil nil 23152 nil 8 1804752336 4386 nil nil 41 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 23152 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 5:\f1\fs16\par
\par
Decide what meta-level information is required at runtime\par
\b0\par
\par
\par
}
' 23152 1010 #textLimit: 8 #(1073741823) 23152 1010 #resetCharFormat 5008 23152 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 5008 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 22608 1010 #text: 34 1 8 'Heading' 22608 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 23152 22688 1232 nil 27 1250 1760 1 2128 1 1360 1 1376 121 410 ##(Smalltalk.CheckBox) 34 16 nil 21840 34 2 8 1140924451 1 23840 4002 nil nil 5456 false nil nil 5 nil nil nil 23840 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 459 578 369 41 23840 1010 #text: 34 1 8 'Strip class &GUIDs' 23840 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 229 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1232 nil 27 1250 1760 81 1344 369 1360 459 1376 41 410 ##(Smalltalk.CheckBox) 34 16 nil 21840 34 2 8 1140924451 1 24176 4002 nil nil 5456 false nil nil 5 nil nil nil 24176 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 649 578 369 49 24176 1010 #text: 34 1 8 'Compile E&xternal Structures' 24176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 68 1 0 0 224 0 0 0 92 1 0 0] 8 #() 1232 nil 27 1250 1760 81 1344 369 1360 649 1376 49 410 ##(Smalltalk.CheckBox) 34 16 nil 21840 34 2 8 1140924451 1 24512 4002 nil nil 5456 true nil nil 5 nil nil nil 24512 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 249 578 369 59 24512 1010 #text: 34 1 8 'Strip class meta-&information' 24512 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 124 0 0 0 224 0 0 0 153 0 0 0] 8 #() 1232 nil 27 1250 1760 81 1344 369 1360 249 1376 59 410 ##(Smalltalk.GroupBox) 34 14 nil 21840 34 2 8 1140850695 65 24848 nil 848 nil 5 nil nil nil 24848 nil 8 1915188384 946 138 144 34 1 1010 #createAt:extent: 34 2 578 -17 521 578 1151 229 24848 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 247 255 255 255 4 1 0 0 54 2 0 0 118 1 0 0] 8 #() 1232 nil 27 1250 1760 -17 2128 19 1360 521 1376 229 410 ##(Smalltalk.StaticText) 34 16 nil 21840 34 2 8 1140850944 1 25104 nil nil nil 5 nil nil nil 25104 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 149 578 979 99 25104 1010 #text: 34 1 8 'Class category information is automatically stripped from the image. You can also choose to remove some other meta information that is not normally required by a runtime application. You can also choose which items of meta-information are removed.' 25104 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 74 0 0 0 247 1 0 0 123 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -107 1360 149 1376 99 410 ##(Smalltalk.StaticText) 34 16 nil 21840 34 2 8 1140850944 1 25424 nil nil nil 5 nil nil nil 25424 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 321 578 979 69 25424 1010 #text: 34 1 8 'You can choose which items of meta-information are removed. In general, you should retain the recommended default settings.' 25424 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 160 0 0 0 247 1 0 0 194 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -107 1360 321 1376 69 170 192 34 8 24176 8 'compileExternalStructures' 24512 8 'stripClassInfo' 23840 8 'stripClassGuids' 22272 8 'retainInstVarNames' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 21840 1010 #text: 34 1 8 'Step 5' 21840 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 9 22608 25104 24512 25424 22272 23840 21952 24176 24848 1232 nil 27 3714 13 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 26064 nil nil nil 5 nil nil nil 26064 706 170 176 34 14 410 ##(Smalltalk.StaticText) 34 16 nil 26064 34 2 8 1140850944 1 26176 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 188 2 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 5 0 34 59 0 0 0 0 15 1 31 86 135 1] 20240 nil 26176 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 529 578 949 81 26176 1010 #text: 34 1 8 'It is very important that, should the stripping operation fail for whatever reason, you do not save the partially stripped image.' 26176 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 8 1 0 0 232 1 0 0 48 1 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -137 1360 529 1376 81 410 ##(Smalltalk.StaticText) 34 16 nil 26064 34 2 8 1140850944 1 26544 nil nil nil 5 nil nil nil 26544 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 161 578 989 81 26544 1010 #text: 34 1 8 'You can choose to deploy this image to an executable now according to the image stripping options you have chosen. To do this click ''Deploy''.
' 26544 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 120 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -97 1360 161 1376 81 410 ##(Smalltalk.ContainerView) 34 15 nil 26064 34 2 8 1140850688 131073 26864 nil 848 nil 5 nil nil nil 26864 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 26864 34 2 8 1140850944 1 26944 4002 nil false 4034 4066 #= 8 #() 4066 #hash 4128 4146 nil true 4192 8 'Resources\LagoonLogo.bmp' 4240 4274 nil nil 578 321 327 578 8467 8627 4352 nil 5 nil nil nil 26944 nil 8 4294902547 4386 nil nil nil 27088 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 26944 1010 #text: 34 1 8 'Graphic' 26944 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 26864 34 2 8 1140855108 1 27408 nil 848 nil 5 nil nil nil 27408 nil 8 1804752336 4386 nil nil 41 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 27408 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Final Step:\par
\f1\fs16\par
Deployment\b0\par
\par
\par
\par
}
' 27408 1010 #textLimit: 8 #(1073741823) 27408 1010 #resetCharFormat 5008 27408 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 5008 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 26864 1010 #text: 34 1 8 'Heading' 26864 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 27408 26944 1232 nil 27 1250 1760 1 2128 1 1360 1 1376 121 410 ##(Smalltalk.StaticText) 34 16 nil 26064 34 2 8 1140850944 1 28096 nil nil nil 5 nil nil nil 28096 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 641 578 979 59 28096 1010 #text: 34 1 8 'Alternatively you can save your current ImageStripper configuration for later deployment by clicking ''Save Configuration'' now.' 28096 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 64 1 0 0 247 1 0 0 93 1 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -107 1360 641 1376 59 410 ##(Smalltalk.StaticText) 34 16 nil 26064 34 2 8 1140850955 262145 28416 nil nil nil 5 nil nil nil 28416 nil 8 1915124368 4386 nil nil nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 281 269 578 737 41 28416 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 140 0 0 0 134 0 0 0 252 1 0 0 154 0 0 0] 8 #() 1232 nil 27 1250 1760 281 2128 -97 1360 269 1376 41 410 ##(Smalltalk.StaticText) 34 16 nil 26064 34 2 8 1140850944 1 28688 nil nil nil 5 nil 498 nil true 530 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 83 32 83 97 110 115 32 83 101 114 105 102 0 204 53 87 1 6 0 34 59 0 0 0 0 15 1 31 86 135 1] 20240 nil 28688 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 349 578 989 139 28688 1010 #text: 34 1 8 'Your development image will first be saved in its current state. 

The stripping process that follows may take several minutes depending on the options selected. At the end of the process there will be a short pause before a prompt confirms that image stripping is complete.' 28688 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 174 0 0 0 252 1 0 0 243 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -97 1360 349 1376 139 410 ##(Smalltalk.StaticText) 34 16 nil 26064 34 2 8 1140850944 1 29056 nil nil nil 5 nil nil nil 29056 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 269 578 189 49 29056 1010 #text: 34 1 8 'E&xecutable name:' 29056 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 134 0 0 0 134 0 0 0 158 0 0 0] 8 #() 1232 nil 27 1250 1760 81 1344 189 1360 269 1376 49 170 192 34 2 28416 8 'executablePath2' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 26064 1010 #text: 34 1 8 'Final step' 26064 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 26864 26544 29056 28416 26176 28688 28096 1232 nil 27 3714 15 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 29648 nil 848 nil 5 nil nil nil 29648 706 170 176 34 8 410 ##(Smalltalk.RichTextEdit) 34 18 nil 29648 34 2 8 1140855110 1 29760 nil 848 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 898 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 29874 1 898 #bePlain 8 '&Plain' 1 1 nil nil nil 29874 1 898 #toggleBold 8 '&Bold' 1 1 nil nil nil 29874 1 898 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29874 1 898 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29938 4097 29826 nil true 34 3 29874 1 898 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29874 1 898 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29874 1 898 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29938 4097 29874 1 898 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 29760 nil 8 1804752336 4386 nil nil 43 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 5 1010 #createAt:extent: 34 2 578 419 1 578 649 489 29760 1010 #contextMenu: 34 1 29840 29760 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}{\f1\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}}
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
' 29760 1010 #textLimit: 8 #(1073741823) 29760 1010 #resetCharFormat 5008 29760 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 0 0 0 0 21 2 0 0 244 0 0 0] 8 #() 1232 nil 27 1250 1760 419 2128 -47 1360 1 1376 489 410 ##(Smalltalk.TextEdit) 34 16 nil 29648 34 2 8 1140850816 262145 30832 nil 196934 1 ##(Smalltalk.RGB) 32238571 nil 5 nil nil nil 30832 nil 8 1915280032 4386 nil nil 35 946 138 144 34 1 1010 #createAt:extent: 34 2 578 421 491 578 645 41 30832 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 210 0 0 0 245 0 0 0 20 2 0 0 9 1 0 0] 8 #() 1232 nil 27 1250 1760 421 2128 -49 13936 3 1376 41 410 ##(Smalltalk.RichTextEdit) 34 18 nil 29648 34 2 8 1140855110 1 31136 nil 848 nil 5 29826 nil true 34 10 29874 1 898 #chooseSelectionFont 8 '&Font...' 1 1 nil nil nil 29938 4097 29874 1 898 #bePlain 8 '&Plain' 1 1 nil nil nil 29874 1 898 #toggleBold 8 '&Bold' 1 1 nil nil nil 29874 1 898 #toggleItalic 8 '&Italic' 1 1 nil nil nil 29874 1 898 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 29938 4097 29826 nil true 34 3 29874 1 898 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 29874 1 898 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 29874 1 898 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 29938 4097 29874 1 898 #chooseSelectionColor 8 '&Colour...' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 31136 nil 8 1804752336 4386 nil nil 43 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 5 1010 #createAt:extent: 34 2 578 419 681 578 549 49 31136 1010 #contextMenu: 34 1 31200 31136 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\f0\fs16 Otherwise click \b Next \b0 to continue.\par
\par
\par
\pard\qc\par
}
' 31136 1010 #textLimit: 8 #(1073741823) 31136 1010 #resetCharFormat 5008 31136 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 209 0 0 0 84 1 0 0 227 1 0 0 108 1 0 0] 8 #() 1232 nil 27 1250 1760 419 1344 549 1360 681 1376 49 410 ##(Smalltalk.ImageView) 34 21 nil 29648 34 2 8 1140850944 1 32160 4002 nil false 4034 4066 #= 8 #() 4066 #hash 4128 4146 nil true 4192 8 'Resources\LagoonSideBar.jpg' 4240 4274 nil nil 578 381 761 578 10055 20109 848 nil 5 nil nil nil 32160 nil 8 4294902547 4386 nil nil nil 32304 #centered 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 379 741 32160 1010 #text: 34 1 8 'Lagoon Graphic' 32160 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 189 0 0 0 114 1 0 0] 8 #() 1232 nil 27 1250 1760 1 1344 379 1360 1 1376 741 170 192 34 2 30832 8 'executablePath1' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 29648 1010 #text: 34 1 8 'Intro' 29648 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 32160 29760 30832 31136 1232 nil 27 3714 17 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 32912 nil nil nil 5 nil nil nil 32912 706 170 176 34 8 410 ##(Smalltalk.ContainerView) 34 15 nil 32912 34 2 8 1140850688 131073 33024 nil 848 nil 5 nil nil nil 33024 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 33024 34 2 8 1140850944 1 33104 4002 nil false 4034 4066 #= 8 #() 4066 #hash 4128 4146 nil true 4192 8 'Resources\LagoonLogo.bmp' 4240 4274 nil nil 578 321 327 578 8467 8627 4352 nil 5 nil nil nil 33104 nil 8 4294902547 4386 nil nil nil 33248 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 33104 1010 #text: 34 1 8 'Graphic' 33104 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 33024 34 2 8 1140855108 1 33568 nil 848 nil 5 nil nil nil 33568 nil 8 1804752336 4386 nil nil 41 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 33568 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 1:\f1\fs16\par
\par
Choose an ImageStripper to perform the deployment process\b0\par
\par
\par
\par
}
' 33568 1010 #textLimit: 8 #(1073741823) 33568 1010 #resetCharFormat 5008 33568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 5008 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 33024 1010 #text: 34 1 8 'Heading' 33024 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 33568 33104 1232 nil 27 1250 1760 1 2128 1 1360 1 1376 121 410 ##(Smalltalk.StaticText) 34 16 nil 32912 34 2 8 1140850944 1 34256 nil nil nil 5 nil nil nil 34256 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 401 578 249 121 34256 1010 #text: 34 1 8 'Choose a the class of &ImageStripper to install.' 34256 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 200 0 0 0 164 0 0 0 4 1 0 0] 8 #() 1232 nil 27 1250 1760 81 1344 249 1360 401 1376 121 410 ##(Smalltalk.ComboBox) 34 17 nil 32912 34 2 8 1144063491 1025 34576 9314 138 144 5008 nil 9376 848 nil 5 nil nil nil 34576 nil 8 1915002384 ##(Smalltalk.BasicListAbstract) 5008 401 946 138 144 34 1 1010 #createAt:extent: 34 2 578 349 409 578 647 43 34576 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 174 0 0 0 204 0 0 0 241 1 0 0 225 0 0 0] 8 #() 1232 nil 27 1250 1760 349 2128 -119 1360 409 1376 41 410 ##(Smalltalk.StaticText) 34 16 nil 32912 34 2 8 1140850944 1 34864 nil nil nil 5 nil nil nil 34864 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 229 578 979 149 34864 1010 #text: 34 1 8 'The ImageStripper determines how your image will be stripped of unnecessary objects. Under most circumstances the standard ImageStripper class is sufficient, but it is possible to write your own customized stripper if required.' 34864 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 114 0 0 0 247 1 0 0 188 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -107 1360 229 1376 149 170 192 34 2 34576 8 'imageStripperClass' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 32912 1010 #text: 34 1 8 'Step 1' 32912 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 4 33024 34864 34256 34576 1232 nil 27 3714 19 410 ##(Smalltalk.ContainerView) 34 15 nil 3584 34 2 8 1140850688 131073 35456 nil nil nil 5 nil nil nil 35456 706 170 176 34 14 410 ##(Smalltalk.ContainerView) 34 15 nil 35456 34 2 8 1140850688 131073 35568 nil 848 nil 5 nil nil nil 35568 610 19 1 nil nil 410 ##(Smalltalk.ImageView) 34 21 nil 35568 34 2 8 1140850944 1 35648 4002 nil false 4034 4066 #= 8 #() 4066 #hash 4128 4146 nil true 4192 8 'Resources\LagoonLogo.bmp' 4240 4274 nil nil 578 321 327 578 8467 8627 4352 nil 5 nil nil nil 35648 nil 8 4294902547 4386 nil nil nil 35792 #scale 1 nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1003 11 578 103 101 35648 1010 #text: 34 1 8 'Graphic' 35648 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 245 1 0 0 5 0 0 0 40 2 0 0 55 0 0 0] 8 #() 1232 nil 27 nil 410 ##(Smalltalk.RichTextEdit) 34 18 nil 35568 34 2 8 1140855108 1 36112 nil 848 nil 5 nil nil nil 36112 nil 8 1804752336 4386 nil nil 41 nil 4722 8 #[0 0 0 0 0 0 0 0 160 0 248 3] 946 138 144 34 4 1010 #createAt:extent: 34 2 578 31 11 578 955 101 36112 1010 #text: 34 1 4914 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fswiss\fprq2\fcharset0 Microsoft Sans Serif;}{\f1\fnil\fcharset0 Microsoft Sans Serif;}}
\viewkind4\uc1\pard\b\f0\fs20 Step 6:\f1\fs16\par
\par
Miscellaneous stripping options\b0\par
\par
\par
\par
}
' 36112 1010 #textLimit: 8 #(1073741823) 36112 1010 #resetCharFormat 5008 36112 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 5 0 0 0 236 1 0 0 55 0 0 0] 8 #() 1232 nil 27 170 192 5008 3314 578 31 11 578 11 11 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 121 35568 1010 #text: 34 1 8 'Heading' 35568 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 60 0 0 0] 34 2 36112 35648 1232 nil 27 1250 1760 1 2128 1 1360 1 1376 121 410 ##(Smalltalk.GroupBox) 34 14 nil 35456 34 2 8 1140850695 65 36800 nil 848 nil 5 nil nil nil 36800 nil 8 1915188384 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 327 578 1115 393 36800 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 45 2 0 0 103 1 0 0] 8 #() 1232 nil 27 1250 1760 1 2128 1 1360 327 1376 393 410 ##(Smalltalk.CheckBox) 34 16 nil 35456 34 2 8 1140924451 1 37056 4002 nil nil 5456 true nil nil 5 nil nil nil 37056 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 451 578 379 49 37056 1010 #text: 34 1 8 'Fold duplicate s&trings' 37056 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 225 0 0 0 224 0 0 0 249 0 0 0] 8 #() 1232 nil 27 1250 1760 71 1344 379 1360 451 1376 49 410 ##(Smalltalk.StaticText) 34 16 nil 35456 34 2 8 1140850944 1 37392 nil nil nil 5 nil nil nil 37392 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 29 161 578 989 49 37392 1010 #text: 34 1 8 'If you don''t need to create new classes at runtime the ClassBuilder can be removed.' 37392 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 0 0 0 80 0 0 0 252 1 0 0 104 0 0 0] 8 #() 1232 nil 27 1250 1760 29 2128 -97 1360 161 1376 49 410 ##(Smalltalk.CheckBox) 34 16 nil 35456 34 2 8 1140924451 1 37712 4002 nil nil 5456 true nil nil 5 nil nil nil 37712 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 71 511 578 379 41 37712 1010 #text: 34 1 8 'Fold duplicate b&ytecode arrays' 37712 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 35 0 0 0 255 0 0 0 224 0 0 0 19 1 0 0] 8 #() 1232 nil 27 1250 1760 71 1344 379 1360 511 1376 41 410 ##(Smalltalk.CheckBox) 34 16 nil 35456 34 2 8 1140924451 1 38048 4002 nil nil 5456 false nil nil 5 nil nil nil 38048 nil 8 1915188384 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 81 209 578 369 41 38048 1010 #text: 34 1 8 'Strip &Class Builder' 38048 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 40 0 0 0 104 0 0 0 224 0 0 0 124 0 0 0] 8 #() 1232 nil 27 1250 1760 81 1344 369 1360 209 1376 41 410 ##(Smalltalk.StaticText) 34 16 nil 35456 34 2 8 1140850944 1 38384 nil nil nil 5 nil nil nil 38384 nil 8 1915124368 4386 nil nil nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 31 391 578 967 49 38384 1010 #text: 34 1 8 'Duplicate instances of some read-only objects can be folded to a single objects.' 38384 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 15 0 0 0 195 0 0 0 242 1 0 0 219 0 0 0] 8 #() 1232 nil 27 1250 1760 31 2128 -117 1360 391 1376 49 170 192 34 6 37712 8 'stripDuplicateBytecodes' 37056 8 'stripDuplicateStrings' 38048 8 'stripClassBuilder' nil 946 138 144 34 2 1010 #createAt:extent: 34 2 578 1 1 578 1115 719 35456 1010 #text: 34 1 8 'Step 6' 35456 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 45 2 0 0 103 1 0 0] 34 7 35568 37392 38048 38384 37056 37712 36800 1232 nil 27 29648 170 192 34 2 29648 8 'Intro' nil 946 138 144 34 1 1010 #createAt:extent: 34 2 578 1 1 578 1119 723 3584 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 47 2 0 0 105 1 0 0] 34 9 29648 32912 3744 9952 13152 21840 35456 18464 26064 1232 nil 27 170 192 34 2 3584 8 'Steps' 3314 578 1 1 578 1 1 nil nil nil nil 3 nil nil 578 2049 881 578 1151 881 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 false 8 2011052416 946 138 144 34 3 1010 #createAt:extent: 34 2 578 105 105 578 1151 881 416 1010 #text: 34 1 8 'Lagoon Deployment Wizard' 416 1010 #updateMenuBar 5008 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 52 0 0 0 52 0 0 0 115 2 0 0 236 1 0 0] 34 2 3584 640 1232 nil 27 )!

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

