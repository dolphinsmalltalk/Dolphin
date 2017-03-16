"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #StsPackageEditionPrompter
	instanceVariableNames: 'packages editions result'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsPackageEditionPrompter guid: (GUID fromString: '{39805321-5f46-11d4-b175-0080c7b55770}')!
StsPackageEditionPrompter comment: ''!
!StsPackageEditionPrompter categoriesForClass!Unclassified! !
!StsPackageEditionPrompter methodsFor!

apply
	result := editions selectionOrNil!

createComponents
	super createComponents.
	packages := self add: ListPresenter new name: 'packages'.
	editions := self add: ListPresenter new name: 'editions'!

createSchematicWiring
	super createSchematicWiring.
	packages 
		when: #selectionChanged
		send: #onPackageSelected
		to: self!

onPackageSelected
	| packageName packageEditions |
	(packageName := packages selectionOrNil) isNil 
		ifTrue: [editions clear]
		ifFalse: 
			[Cursor wait showWhile: 
					[packageEditions := self sourceControl getPackageEditionsFor: packageName.
					editions
						list: packageEditions;
						selection: packageEditions first]]!

onViewOpened
	super onViewOpened.
	packages list: self sourceControl getAllPackageNames!

result
	^result!

setDefaultPackageName: aString 
	packages selection: (packages list detect: [:each | each = aString] ifNone: [^self])! !
!StsPackageEditionPrompter categoriesFor: #apply!public! !
!StsPackageEditionPrompter categoriesFor: #createComponents!public! !
!StsPackageEditionPrompter categoriesFor: #createSchematicWiring!public! !
!StsPackageEditionPrompter categoriesFor: #onPackageSelected!public! !
!StsPackageEditionPrompter categoriesFor: #onViewOpened!public! !
!StsPackageEditionPrompter categoriesFor: #result!public! !
!StsPackageEditionPrompter categoriesFor: #setDefaultPackageName:!public! !

!StsPackageEditionPrompter class methodsFor!

chooseWithDefault: aString 
	^(self create)
		setDefaultPackageName: aString;
		showModal;
		result!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26738689 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 560 0 0 0 7 0 0 0 560 852230 ##(Smalltalk.FramingLayout)  234 240 98 4 410 8 ##(Smalltalk.PushButton)  98 20 0 560 98 2 8 1140924416 1 704 0 482 512 0 7 0 0 0 704 0 8 4294904159 1180998 4 ##(Smalltalk.CommandDescription)  8 #ok 8 '&OK' 1 1 0 0 16 0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  991 11 1010 171 61 704 946 8 #isEnabled: 98 1 32 704 946 8 #text: 98 1 8 '&OK' 704 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 239 1 0 0 5 0 0 0 68 2 0 0 35 0 0 0] 98 0 1010 193 193 0 29 1181766 2 ##(Smalltalk.FramingConstraints)  1180678 ##(Smalltalk.FramingCalculation)  8 #fixedParentRight -383 1282 8 #fixedViewLeft 171 1282 8 #fixedParentTop 11 1282 8 #fixedViewTop 61 410 720 98 20 0 560 98 2 8 1140924416 1 1424 0 482 512 0 7 0 0 0 1424 0 8 4294904159 818 8 #cancel 8 '&Cancel' 1 1 0 0 32 0 0 0 882 202 208 98 2 946 976 98 2 1010 1191 11 1010 171 61 1424 946 1120 98 1 8 '&Cancel' 1424 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 83 2 0 0 5 0 0 0 168 2 0 0 35 0 0 0] 98 0 1232 0 29 1250 1296 -183 1328 171 1360 11 1392 61 234 256 98 0 0 882 202 208 98 1 946 976 98 2 1010 1 803 1010 1375 81 560 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 145 1 0 0 175 2 0 0 185 1 0 0] 98 2 704 1424 1232 0 27 0 0 410 576 98 15 0 416 98 2 8 1140850688 131073 1984 0 0 0 7 0 0 0 1984 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 8 ##(Smalltalk.ListView)  98 30 0 1984 98 2 8 1140953165 1025 2112 590662 2 ##(Smalltalk.ListModel)  202 208 1808 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  482 512 0 7 0 0 0 2112 0 8 4294904481 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 4 920646 5 ##(Smalltalk.ListViewColumn)  8 'Version descriptor' 281 8 #left 459270 ##(Smalltalk.Message)  8 #displayVersionDescriptor 98 0 8 ##(Smalltalk.SortedCollection)  0 0 2112 0 1 0 0 2402 8 'Timestamp' 241 2448 787814 3 ##(Smalltalk.BlockClosure)  0 459302 ##(Smalltalk.Context)  1 1 0 0 1180966 ##(Smalltalk.CompiledExpression)  2 9 170 8 'Dolphin List Presenter' 8 'BasicListAbstract' 8 'doIt' 98 2 8 '[:edition | edition timestamp printString]
' 98 1 202 8 ##(Smalltalk.PoolDictionary)  1808 8 #[252 1 0 1 1 8 0 17 230 32 228 32 158 159 106 100 105] 8 #timestamp 8 #printString 17 257 2304 2528 0 0 2112 0 1 0 0 2402 8 'Developer' 241 2448 2466 8 #developer 98 0 2528 0 0 2112 0 3 0 0 2402 8 'Blessing' 191 2448 2466 8 #blessingString 1808 2466 8 #<= 1808 0 0 2112 0 1 0 0 8 #report 1808 0 131169 0 0 882 202 208 98 2 946 976 98 2 1010 417 1 1010 959 803 2112 946 1120 98 1 8 'Version descriptor' 2112 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 0 0 0 0 175 2 0 0 145 1 0 0] 98 0 1232 0 27 852486 ##(Smalltalk.ScaledDecimal)  524806 ##(Smalltalk.Fraction)  15 11 3 410 2128 98 30 0 1984 98 2 8 1140953165 1025 3328 2194 202 208 1808 0 2256 482 512 0 7 0 0 0 3328 0 8 4294904481 2304 2578 0 2610 1 1 0 0 2642 3 9 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 98 2 8 '[:object | Package icon imageIndex]' 98 1 202 2800 1808 8 #[252 1 0 1 1 7 0 17 230 32 45 159 160 106 100 105] 721414 ##(Smalltalk.Association)  8 #Package 8 ##(Smalltalk.Package)  8 #icon 8 #imageIndex 17 257 0 2352 0 0 0 0 0 0 202 208 98 1 2402 8 'Package' 401 2448 2304 2528 0 0 3328 0 3 0 0 3040 1808 0 131169 0 0 882 202 208 98 2 946 976 98 2 1010 1 1 1010 409 803 3328 946 1120 98 1 8 'Package' 3328 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 0 0 0 145 1 0 0] 98 0 1232 0 27 3266 3298 7 11 3 32 234 256 98 4 2112 8 'editions' 3328 8 'packages' 0 882 202 208 98 1 946 976 98 2 1010 1 1 1010 1375 803 1984 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 175 2 0 0 145 1 0 0] 98 3 3328 410 8 ##(Smalltalk.Splitter)  98 12 0 1984 98 2 8 1140850688 1 4240 0 482 8 4278190080 0 7 0 0 0 4240 882 202 208 98 1 946 976 98 2 1010 409 1 1010 9 803 4240 1170 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 204 0 0 0 0 0 0 0 208 0 0 0 145 1 0 0] 98 0 1232 0 27 2112 1232 0 27 234 256 1808 0 0 0 0 0 17553 0 0 0 1010 1051 451 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572119 882 202 208 98 3 946 976 98 2 1010 3359 21 1010 1391 951 416 946 1120 98 1 8 'Select package edition' 416 946 8 #updateMenuBar 1808 416 1170 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 243 5 0 0 10 0 0 0 170 8 0 0 229 1 0 0] 98 2 1984 560 1232 0 27 )! !
!StsPackageEditionPrompter class categoriesFor: #chooseWithDefault:!public! !
!StsPackageEditionPrompter class categoriesFor: #resource_Default_view!public!resources-views! !

