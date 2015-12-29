"Filed out from Dolphin Smalltalk X6"!

Object subclass: #StsDevelopmentEnvironmentExtensions
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsDevelopmentEnvironmentExtensions guid: (GUID fromString: '{098E1506-DBC8-4FF2-9DFD-14169D585507}')!
StsDevelopmentEnvironmentExtensions comment: ''!
!StsDevelopmentEnvironmentExtensions categoriesForClass!Kernel-Objects! !
!StsDevelopmentEnvironmentExtensions class methodsFor!

onClassBrowserOpened: aClassBrowserShell 
	| classesPresenter methodsView methodsBrowser |
	methodsBrowser := aClassBrowserShell presenterNamed: 'methodBrowser' ifNone: [].
	methodsBrowser isNil 
		ifFalse: 
			[methodsBrowser 
				when: #methodSelected
				send: #onStsMethodChanged
				to: methodsBrowser].
	"methodsView := aClassBrowserShell view viewNamed: 'methods' ifNone: [].
	methodsView isNil 
		ifFalse: 
			[methodsView := methodsView class == ListBox ifTrue: [methodsView] ifFalse: [methodsView referee].
			(methodsView contextMenu)
				addSeparator;
				addCommandDescription: (ClosedCommandDescription 
							command: #browseMethodEditions
							description: 'Browse &Editions'
							queryBlock: 
								[:query | 
								query isEnabled: (StsManager current isConnected 
											and: [(aClassBrowserShell presenterNamed: 'methodBrowser' ifNone: []) hasMethodSelected])]
							receiver: (aClassBrowserShell presenterNamed: 'methodBrowser' ifNone: []));
				addCommandDescription: (ClosedCommandDescription 
							command: #browseAvailableMethods
							description: 'Available...'
							queryBlock: [:query | query isEnabled: StsManager current isConnected]
							receiver: aClassBrowserShell)]."
	"classesPresenter := aClassBrowserShell presenterNamed: 'classes' ifNone: [].
	classesPresenter isNil 
		ifFalse: 
			[(classesPresenter stsClassesContextMenu)
				addSeparator;
				addCommandDescription: (ClosedCommandDescription 
							command: #browseClassEditions
							description: 'Browse &Editions'
							queryBlock: 
								[:query | 
								query isEnabled: (StsManager current isConnected and: [aClassBrowserShell hasClassSelected])]
							receiver: aClassBrowserShell);
				addCommandDescription: (ClosedCommandDescription 
							command: #compareClass
							description: 'Compare with...'
							queryBlock: 
								[:query | 
								query isEnabled: (StsManager current isConnected and: [aClassBrowserShell hasClassSelected])]
							receiver: aClassBrowserShell)]"!

onMethodBrowserOpened: aMethodBrowserShell 
	| browser view |
	browser := aMethodBrowserShell presenterNamed: 'browser' ifNone: [^self].
	view := browser view viewNamed: 'methods' ifNone: [].
	view isNil 
		ifFalse: 
			[(view view contextMenu)
				addSeparator;
				addCommandDescription: (ClosedCommandDescription 
							command: #browseMethodEditions
							description: 'Browse &Editions'
							queryBlock: 
								[:query | 
								query isEnabled: (StsManager current isConnected 
											and: [(aMethodBrowserShell presenterNamed: 'browser' ifNone: []) hasMethodSelected])]
							receiver: browser).
			browser 
				when: #methodChanged
				send: #onStsMethodChanged
				to: browser]!

onPackageBrowserOpened: aPackageBrowserShell
	"((aPackageBrowserShell presenterNamed: 'classes' ifNone: []) view contextMenu)
		addSeparator;
		addCommandDescription: (ClosedCommandDescription 
					command: #browseClassEditions
					description: 'Browse &Editions'
					queryBlock: 
						[:query | 
						query 
							isEnabled: (aPackageBrowserShell presenterNamed: 'classes' ifNone: []) selectionOrNil 
									notNil]
					receiver: aPackageBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #compareClass
					description: 'Compare with...'
					queryBlock: 
						[:query | 
						query 
							isEnabled: (aPackageBrowserShell presenterNamed: 'classes' ifNone: []) selectionOrNil 
									notNil]
					receiver: aPackageBrowserShell).
	((aPackageBrowserShell presenterNamed: 'methods' ifNone: []) view contextMenu)
		addSeparator;
		addCommandDescription: (ClosedCommandDescription 
					command: #browseLooseMethodEditions
					description: 'Browse &Editions'
					queryBlock: 
						[:query | 
						query 
							isEnabled: (aPackageBrowserShell presenterNamed: 'methods' ifNone: []) selectionOrNil 
									notNil]
					receiver: aPackageBrowserShell)."
	(aPackageBrowserShell presenterNamed: 'methods' ifNone: []) 
		when: #selectionChanged
		send: #onStsMethodSelected
		to: aPackageBrowserShell.
	(aPackageBrowserShell view viewNamed: 'ownedCards') 
		when: #currentCardChanged
		send: #onStsCardChanged
		to: aPackageBrowserShell.
	"((aPackageBrowserShell presenterNamed: 'packages' ifNone: []) packagesPresenter view 
		contextMenu)
		addSeparator;
		addCommandDescription: (ClosedCommandDescription 
					command: #loadPackageFromRepository
					description: '&Load...'
					queryBlock: [:query | query isEnabled: true]
					receiver: aPackageBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #importPackageFromFile
					description: '&Import...'
					queryBlock: [:query | query isEnabled: true]
					receiver: aPackageBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #versionPackage
					description: 'Version...'
					queryBlock: [:query | query isEnabled: true]
					receiver: aPackageBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #browsePackageEditions
					description: 'Browse Available &Editions'
					queryBlock: [:query | query isEnabled: true]
					receiver: aPackageBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #compareWithAnotherEdition
					description: 'Compare with...'
					queryBlock: [:query | query isEnabled: true]
					receiver: aPackageBrowserShell)"!

onSystemBrowserOpened: aSystemBrowserShell 
	| classesPresenter |
	"classesPresenter := aSystemBrowserShell presenterNamed: 'classes' ifNone: [].
	((classesPresenter presenterNamed: 'packages' ifNone: []) packagesPresenter view 
		contextMenu)
		addSeparator;
		addCommandDescription: (ClosedCommandDescription 
					command: #loadPackageFromRepository
					description: '&Load...'
					queryBlock: [:query | query isEnabled: true]
					receiver: aSystemBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #importPackageFromFile
					description: '&Import...'
					queryBlock: [:query | query isEnabled: true]
					receiver: aSystemBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #versionPackage
					description: 'Version...'
					queryBlock: [:query | query isEnabled: true]
					receiver: aSystemBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #browsePackageEditions
					description: 'Browse Available &Editions'
					queryBlock: [:query | query isEnabled: true]
					receiver: aSystemBrowserShell);
		addCommandDescription: (ClosedCommandDescription 
					command: #compareWithAnotherEdition
					description: 'Compare with...'
					queryBlock: [:query | query isEnabled: true]
					receiver: aSystemBrowserShell)"! !
!StsDevelopmentEnvironmentExtensions class categoriesFor: #onClassBrowserOpened:!private! !
!StsDevelopmentEnvironmentExtensions class categoriesFor: #onMethodBrowserOpened:!private! !
!StsDevelopmentEnvironmentExtensions class categoriesFor: #onPackageBrowserOpened:!private! !
!StsDevelopmentEnvironmentExtensions class categoriesFor: #onSystemBrowserOpened:!private! !

