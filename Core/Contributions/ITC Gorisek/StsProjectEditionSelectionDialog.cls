"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #StsProjectEditionSelectionDialog
	instanceVariableNames: 'projectsPresenter projectEditionsPresenter packageEditionsPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsProjectEditionSelectionDialog guid: (GUID fromString: '{993cda8d-7165-4405-8e2c-15f29e796704}')!
StsProjectEditionSelectionDialog comment: ''!
!StsProjectEditionSelectionDialog categoriesForClass!Unclassified! !
!StsProjectEditionSelectionDialog methodsFor!

createComponents
	super createComponents.
	projectsPresenter := self 
				add: ListPresenter new
				name: 'projects'
				helpId: 10982.
	projectsPresenter model searchPolicy: SearchPolicy equality.
	projectEditionsPresenter := self 
				add: ListPresenter new
				name: 'projectEditions'
				helpId: 10983.
	packageEditionsPresenter := self 
				add: ListPresenter new
				name: 'packageEditions'
				helpId: 10984.
	packageEditionsPresenter model searchPolicy: SearchPolicy equality!

createSchematicWiring
	super createSchematicWiring.
	projectsPresenter 
		when: #selectionChanged
		send: #onProjectSelected
		to: self.
	projectEditionsPresenter 
		when: #selectionChanged
		send: #onProjectEditionSelected
		to: self!

onProjectEditionSelected
	projectEditionsPresenter selectionOrNil isNil 
		ifFalse: [packageEditionsPresenter list: projectEditionsPresenter selectionOrNil packageEditions]
		ifTrue: [packageEditionsPresenter clear]!

onProjectSelected
	self refreshProjectEditionsList.
	projectsPresenter selectionOrNil notNil 
		ifTrue: [projectEditionsPresenter selection: projectEditionsPresenter list first]!

onViewOpened
	super onViewOpened.
	self refreshProjectsList!

queryCommand: query 
	query commandSymbol == #selectProjectEdition 
		ifTrue: 
			[query isEnabled: projectEditionsPresenter hasSingleSelection.
			^true].
	^super queryCommand: query!

refreshProjectEditionsList
	projectsPresenter selectionOrNil isNil 
		ifTrue: [projectEditionsPresenter clear]
		ifFalse: 
			[| selection |
			selection := projectEditionsPresenter selectionOrNil.
			projectEditionsPresenter 
				list: (self sourceControl getProjectEditionsFor: projectsPresenter selectionOrNil).
			selection isNil 
				ifFalse: 
					[projectEditionsPresenter selection: (projectEditionsPresenter list 
								detect: [:each | selection versionIdString = each versionIdString]
								ifNone: [projectEditionsPresenter list first])]]!

refreshProjectsList
	| selectedProject projects |
	selectedProject := projectsPresenter selectionOrNil.
	projectsPresenter list: (projects := self sourceControl getAllProjectNames).
	selectedProject notNil 
		ifTrue: 
			[projectsPresenter selection: (projects detect: [:each | each = selectedProject] ifNone: [^self])]!

selectProjectEdition
	self
		model: projectEditionsPresenter selectionOrNil;
		ok! !
!StsProjectEditionSelectionDialog categoriesFor: #createComponents!initializing!private! !
!StsProjectEditionSelectionDialog categoriesFor: #createSchematicWiring!initializing!private! !
!StsProjectEditionSelectionDialog categoriesFor: #onProjectEditionSelected!event handling!private! !
!StsProjectEditionSelectionDialog categoriesFor: #onProjectSelected!event handling!private! !
!StsProjectEditionSelectionDialog categoriesFor: #onViewOpened!event handling!private! !
!StsProjectEditionSelectionDialog categoriesFor: #queryCommand:!private! !
!StsProjectEditionSelectionDialog categoriesFor: #refreshProjectEditionsList!private! !
!StsProjectEditionSelectionDialog categoriesFor: #refreshProjectsList!private! !
!StsProjectEditionSelectionDialog categoriesFor: #selectProjectEdition!public! !

!StsProjectEditionSelectionDialog class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.PushButton)  98 20 0 416 98 2 8 1140924416 1 560 0 0 0 7 0 0 0 560 0 8 4294904159 1180998 4 ##(Smalltalk.CommandDescription)  8 #selectProjectEdition 8 '&Select project edtion' 1 1 0 0 16 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 507 850 437 51 560 786 8 #isEnabled: 98 1 32 560 786 8 #text: 98 1 8 '&Select project edtion' 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 253 0 0 0 218 0 0 0 22 1 0 0] 98 0 850 193 193 0 29 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 1088 0 482 8 4278190080 0 7 0 0 0 1088 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 1088 98 2 8 1140920397 1025 1264 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 8 4278190080 0 23 0 0 0 1264 0 8 4294904481 459270 ##(Smalltalk.Message)  8 #asString 98 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  4 1 1552 8 'doIt' 8 '[:x | StsProjectEdition projectIcon imageIndex]' 8 #[32 105 29 159 160 106] 8 ##(Smalltalk.StsProjectEdition)  8 #projectIcon 8 #imageIndex 1568 7 257 0 1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn)  8 'Projects in Repository' 153 8 #left 1490 8 #displayString 98 0 1490 8 #<= 1872 0 0 1264 0 3 0 0 8 #report 1392 0 2145 0 0 722 202 208 98 2 786 816 98 2 850 1 1 850 161 507 1264 786 960 98 1 8 'Projects in Repository' 1264 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 80 0 0 0 253 0 0 0] 98 0 1072 0 27 3 410 1104 98 15 0 1088 98 2 8 1140850688 131073 2144 0 482 1184 0 7 0 0 0 2144 1202 234 240 98 4 410 1280 98 30 0 2144 98 2 8 1140953421 1025 2272 1346 202 208 1392 0 1424 482 8 4278190080 0 7 0 0 0 2272 0 8 4294904481 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1728 0 0 0 0 0 0 202 208 98 3 1778 8 'Project Editions' 337 1824 1490 8 #versionDescriptor 98 0 0 0 0 2272 0 1 0 0 1778 8 'Timestamp' 501 1824 1554 0 0 1586 3 1 1552 8 'doIt' 8 '[:edition | edition timestamp displayString]' 8 #[31 105 226 0 159 106] 8 #timestamp 1856 2592 7 257 0 0 0 0 2272 0 1 0 0 1778 8 'Developer' 187 1824 1490 8 #developer 2544 0 0 0 2272 0 3 0 0 1920 1392 0 131169 850 129 129 0 722 202 208 98 2 786 816 98 2 850 1 1 850 267 249 2272 786 960 98 1 8 'Project Editions' 2272 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 133 0 0 0 124 0 0 0] 98 0 1072 0 27 3 410 1280 98 30 0 2144 98 2 8 1140953409 1025 2976 1346 202 208 1392 0 1424 482 2384 0 7 0 0 0 2976 0 8 4294904481 2416 0 1728 0 0 0 0 0 0 202 208 98 5 1778 8 '' 45 1824 0 0 0 0 2976 1554 0 0 1586 4 1 1552 8 'doIt' 8 '[:x | (StsProjectBrowserShell statusIconForPackageEdition: x) imageIndex]' 8 #[32 105 29 17 177 160 106] 8 ##(Smalltalk.StsProjectBrowserShell)  8 #statusIconForPackageEdition: 1696 3168 7 257 0 1 0 0 1778 8 'Packages in Load Order' 375 1824 1554 0 459302 ##(Smalltalk.Context)  1 1 0 0 1586 1 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:each | each displayName ]' 98 1 202 8 ##(Smalltalk.PoolDictionary)  1392 8 #[252 1 0 1 1 7 0 17 230 32 228 32 158 106 100 105] 8 #displayName 17 257 0 0 0 0 2976 2432 1 0 0 1778 8 'Edition' 281 1824 1490 2528 98 0 0 0 0 2976 0 1 0 0 1778 8 'Timestamp' 501 1824 1554 0 3330 1 1 0 0 1586 2 9 1488 8 'doIt' 98 2 8 '[:edition | edition timestamp printString]' 98 1 202 3472 1392 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] 2672 8 #printString 17 257 1490 2672 3568 0 0 0 2976 0 1 0 0 1778 8 'Developer' 267 1824 1490 2736 3568 0 0 0 2976 0 3 0 0 1920 1392 0 131173 850 129 129 0 722 202 208 98 1 786 816 98 2 850 1 259 850 267 249 2976 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 129 0 0 0 133 0 0 0 253 0 0 0] 98 0 1072 0 27 3 16 234 256 98 4 2272 8 'projectEditions' 2976 8 'packageEditions' 0 722 202 208 98 1 786 816 98 2 850 171 1 850 267 507 2144 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 85 0 0 0 0 0 0 0 218 0 0 0 253 0 0 0] 98 3 2272 410 8 ##(Smalltalk.Splitter)  98 12 0 2144 98 2 8 1140850688 1 4240 0 482 1184 0 519 0 0 0 4240 722 202 208 98 1 786 816 98 2 850 1 249 850 267 11 4240 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 124 0 0 0 133 0 0 0 129 0 0 0] 98 0 1072 0 27 2976 1072 0 27 524806 ##(Smalltalk.Fraction)  609737 369623 32 234 256 98 2 1264 8 'projects' 0 722 202 208 98 1 786 816 98 2 850 1 1 850 437 507 1088 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 218 0 0 0 253 0 0 0] 98 3 1264 410 4256 98 12 0 1088 98 2 8 1140850688 1 4736 0 482 1184 0 519 0 0 0 4736 722 202 208 98 1 786 816 98 2 850 161 1 850 11 507 4736 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 0 0 0 0 85 0 0 0 253 0 0 0] 98 0 1072 0 27 2144 1072 0 27 234 256 1392 0 0 0 0 0 46483 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 32 8 2010572119 722 202 208 98 3 786 816 98 2 850 3359 21 850 453 625 416 786 960 98 1 8 'Project Editions Selection' 416 786 8 #updateMenuBar 1392 416 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 243 5 0 0 10 0 0 0 213 6 0 0 66 1 0 0] 98 2 1088 560 1072 0 27 )! !
!StsProjectEditionSelectionDialog class categoriesFor: #resource_Default_view!public!resources-views! !

