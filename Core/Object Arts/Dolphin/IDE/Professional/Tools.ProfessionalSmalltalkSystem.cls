"Filed out from Dolphin Smalltalk"!

Tools.CommunityEditionSmalltalkSystem
	subclass: #'Tools.ProfessionalSmalltalkSystem'
	instanceVariableNames: 'systemBrowserClass ideaSpaceClass packagedResourceIdentifierDialogClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.ProfessionalSmalltalkSystem guid: (Core.GUID fromString: '{ff97cec8-db85-4932-b9c0-163380844b27}')!

Tools.ProfessionalSmalltalkSystem comment: ''!

!Tools.ProfessionalSmalltalkSystem categoriesForClass!MVP-Models! !

!Tools.ProfessionalSmalltalkSystem methodsFor!

browseDeployedPackage: aPackage
	self browseDeploymentLog: aPackage imageStripper logFileName!

browseDeploymentLog: aString
	self browseSystemModel: (self
				systemModelFromDeploymentLog: (FileLocator imageRelative localFileSpecFor: aString))!

browseEnvironment: aBrowserEnvironment
	"Open an Environment Browser Shell on all classes and methods included in the specified <BrowserEnvironment>."

	^EnvironmentBrowserShell onEnvironment: aBrowserEnvironment!

browseSources
	"Open a browser on the sources for the entire system,"

	SourceBrowser show!

browseSystemModel: aSystemModel
	"Open an Environment Browser Shell on all classes and methods included in the specified <systemModel>."

	^EnvironmentBrowserShell showOn: aSystemModel!

browseSystemOnMethod: aCompiledMethod 
	"Open a new system browser on aCompiledMethod."

	^self browseMethod: aCompiledMethod with: self systemBrowserClass!

browseSystemPackages: aCollection 
	^(self systemBrowserClass show)
		packages: aCollection;
		yourself!

buildIdeaSpaceDropdownMenu: aMenu
	aMenu
		clear;
		addCommand: #newIdeaSpace description: '&New IdeaSpace';
		addCommand: #openIdeaSpace description: '&Open IdeaSpace from Template…';
		addSeparator;
		addCommand: #saveIdeaSpace description: '&Save IdeaSpace Template';
		addCommand: #saveIdeaSpaceAs description: 'Save IdeaSpace &Template As…';
		addCommand: #revertIdeaSpace description: '&Revert IdeaSpace to Template';
		addSeparator;
		addCommand: #addToNewIdeaSpace description: '&Add to New IdeaSpace';
		addCommand: #dragToolToIdeaSpace description: '&Drag to Existing IdeaSpace';
		addSeparator;
		addCommand: #breakoutCurrentCard description: '&Breakout Tool to Desktop'!

classBrowserClasses
	^Set
		with: self hierarchyBrowserClass
		with: self systemBrowserClass
		with: EnvironmentBrowserShell!

classChooserClass
	classChooserClass isNil ifTrue: [classChooserClass := ChoosePackagedClassDialog].
	^classChooserClass!

disassembleMethod: aCompiledCode
	^(Disassembler method: aCompiledCode) fullDisassembly!

ideaSpaceClass
	"Answer the class of IdeaSpace (a <SmalltalkToolShell>)
	to be used by default in the development environment."

	ideaSpaceClass isNil ifTrue: [ideaSpaceClass := #{IdeaSpaceShell} value].
	^ideaSpaceClass!

ideaSpaceClass: toolClass 
	"Set the class of IdeaSpace (a <SmalltalkToolShell>)
	to be used by default in the development environment."

	ideaSpaceClass := toolClass!

newIdeaSpace
	<menuPopulator: #buildIdeaSpaceDropdownMenu:>
	^self ideaSpaceClass show!

openDeploymentLog: aString
	| dom |
	dom := MSXML newDocument.
	dom loadURL: 'file://' , aString.
	^dom!

packagedResourceIdentifierDialogClass
	packagedResourceIdentifierDialogClass isNil
		ifTrue: [packagedResourceIdentifierDialogClass := PackagedResourceIdentifierDialog].
	^packagedResourceIdentifierDialogClass!

packagedResourceIdentifierDialogClass: anObject
	packagedResourceIdentifierDialogClass := anObject!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: ((Aspect
					choice: #defaultBrowserClass
					from: {self hierarchyBrowserClass. self systemBrowserClass}
					type: ClassBrowserAbstract class)
					icon: ClassBrowserAbstract icon;
					yourself);
		yourself!

recompileDiffs: aCompiledMethod
	(#{Smalltalk.DiffBrowser} value show: 'Vertical view')
		caption: aCompiledMethod printString;
		compare: aCompiledMethod disassembly
			id: 'Current'
			and: (Compiler
					compile: aCompiledMethod getSource
					in: aCompiledMethod methodClass
					environment: aCompiledMethod environment) disassembly
			id: 'Recompiled'!

systemBrowserClass
	"Answer the class of System Browser (a <SmalltalkToolShell>)
	to be used by default in the development environment."

	systemBrowserClass isNil 
		ifTrue: [systemBrowserClass := #{SystemBrowserShell} value].
	^systemBrowserClass!

systemBrowserClass: toolClass
	"Set the class of System Browser (a <SmalltalkToolShell>)
	to be used by default in the development environment."

	systemBrowserClass := toolClass!

systemModelFromDeploymentLog: aString
	^self browserEnvFromDom: (self openDeploymentLog: aString)! !

!Tools.ProfessionalSmalltalkSystem categoriesForMethods!
browseDeployedPackage:!helpers!public! !
browseDeploymentLog:!helpers!public! !
browseEnvironment:!browsing!public! !
browseSources!commands-actions!public! !
browseSystemModel:!browsing!public! !
browseSystemOnMethod:!browsing!public! !
browseSystemPackages:!browsing!public! !
buildIdeaSpaceDropdownMenu:!commands-menus!private! !
classBrowserClasses!accessing!public! !
classChooserClass!options!public! !
disassembleMethod:!public! !
ideaSpaceClass!accessing!public! !
ideaSpaceClass:!accessing!public! !
newIdeaSpace!commands-actions!public! !
openDeploymentLog:!helpers!private! !
packagedResourceIdentifierDialogClass!options!public! !
packagedResourceIdentifierDialogClass:!accessing!public! !
publishedAspects!constants!public! !
recompileDiffs:!public! !
systemBrowserClass!accessing!public! !
systemBrowserClass:!accessing!public! !
systemModelFromDeploymentLog:!helpers!private! !
!

!Tools.ProfessionalSmalltalkSystem class methodsFor!

initialize
	"Private - Initialize the receiver on load (take over as the development system model)."

	self installCurrent!

installCurrent
	"Private - Take over as the development system model."

	self current become: (self basicNew initializeFrom: self current)!

publishedAspectsOfInstances
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	| aspects |
	aspects := super publishedAspectsOfInstances.
	#(#packagedResourceIdentifierDialogClass #ideaSpaceClass #systemBrowserClass) do: 
			[:each |
			aspects add: ((Aspect name: each type: Presenter class)
						icon: SmalltalkToolShell icon;
						yourself)].
	^aspects!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self uninstallCurrent!

uninstallCurrent
	(Current notNil and: [Current class == self]) 
		ifTrue: 
			[(self superclass basicNew)
				initializeFrom: Current;
				become: Current]! !

!Tools.ProfessionalSmalltalkSystem class categoriesForMethods!
initialize!initializing!private! !
installCurrent!initializing!private! !
publishedAspectsOfInstances!public! !
uninitialize!class hierarchy-removing!private! !
uninstallCurrent!class hierarchy-removing!private! !
!

