"Filed out from Dolphin Smalltalk 7"!

StsEdition subclass: #StsPackageEdition
	instanceVariableNames: 'name versionDescriptor comment methods classes resources globals prerequisiteNames scripts aboutBlock previousEdition imageStripperBytes versionComment pathName manualPrerequisites blessing'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsPackageEdition guid: (GUID fromString: '{914f381e-11d6-11d4-b091-000000000000}')!
StsPackageEdition comment: ''!
!StsPackageEdition categoriesForClass!Unclassified! !
!StsPackageEdition methodsFor!

= aStsPackageEdition 
	^(aStsPackageEdition isIdenticalTo: self) or: 
			[aStsPackageEdition class == self class and: 
					[aStsPackageEdition packageVersion = self packageVersion and: 
							[aStsPackageEdition timestamp = self timestamp 
								and: [aStsPackageEdition developer = self developer and: [aStsPackageEdition name = self name]]]]]!

aboutBlock
	^aboutBlock!

aboutBlock: aBlock 
	aboutBlock := aBlock!

basicExportAsSmalltalkXChangeSetOn: aStream packageName: packageName 
	"Export package edition as Smalltalk/X change set which defines a package, classes and loose methods."

	"first define classes"

	self orderedClasses 
		do: [:each | each basicExportDefinitionAsSmalltalkXChangeSetOn: aStream packageName: packageName].
	"and compile methods"
	self orderedClasses 
		do: [:each | each basicExportMethodsAsSmalltalkXChangeSetOn: aStream packageName: packageName].
	self methods 
		do: [:each | each basicExportAsSmalltalkXChangeSetOn: aStream packageName: packageName]!

basicExportAsSqueakChangeSetOn: aStream packageName: packageName 
	"Export package edition as Squeak change set which defines a package, classes and loose methods."

	"first define classes"

	self orderedClasses 
		do: [:each | each basicExportDefinitionAsSqueakFileOutOn: aStream packageName: packageName].
	"and compile methods"
	self orderedClasses 
		do: [:each | each basicExportMethodsAsSqueakFileOutOn: aStream packageName: packageName].
	self methods do: [:each | each basicExportAsSqueakFileOutOn: aStream packageName: packageName]!

basicExportAsVWChangeSetOn: writer parcelName: parcelName 
	"Export package edition as VW change set which defines a parcel, classes and method."

	"first define parcel"

	writer tag: 'component-created'
		do: 
			[writer
				tag: 'name' value: parcelName;
				tag: 'type' value: 'parcel'].
	writer tag: 'do-it' value: 'CodeComponent
	create: #parcel
	named: ''' , parcelName , '''
'.
	"then define classes"
	self orderedClasses 
		do: [:each | each basicExportDefinitionAsVWChangeSetOn: writer parcelName: parcelName].
	"and compile methods"
	self orderedClasses 
		do: [:each | each basicExportMethodsAsVWChangeSetOn: writer parcelName: parcelName].
	self methods do: [:each | each basicExportAsVWChangeSetOn: writer parcelName: parcelName]!

basicExportAsXmlOn: writer 
	writer 
		tag: 'package'
		attributes: (OrderedCollection with: (Association key: 'version' value: self exporterVersion))
		do: 
			[self basicExportHeaderFieldsAsXmlOn: writer.
			self classes do: [:each | each basicExportAsXmlOn: writer].
			self methods do: [:each | each basicExportLooseMethodAsXmlOn: writer].
			self
				exportResourcesAsXmlOn: writer;
				exportGlobalsAsXmlOn: writer;
				exportScriptsAsXmlOn: writer.
			self imageStripperBytes isNil 
				ifFalse: [writer tag: 'imageStripperBytes' cData: self imageStripperBytes asString]]!

basicExportHeaderAsXmlOn: writer 
	writer 
		tag: 'packageHeader'
		attributes: (OrderedCollection with: (Association key: 'version' value: self exporterVersion))
		do: [self basicExportHeaderFieldsAsXmlOn: writer]!

basicExportHeaderFieldsAsXmlOn: writer 
	writer
		tag: 'name' value: self name;
		tag: 'developer' value: self developer;
		tag: 'timestamp' value: self timestampValue;
		tag: 'pathName' value: (self pathName ifNil: ['']);
		tag: 'comment' value: (self comment ifNil: ['']);
		tag: 'blessing' value: (self blessing ifNil: ['']) asString;
		tag: 'versionDescriptor' value: self versionDescriptor;
		tag: 'versionComment' value: (self versionComment ifNil: ['']).
	self prerequisiteNames do: [:each | writer tag: 'prerequisite' value: each].
	self manualPrerequisites do: [:each | writer tag: 'manualPrerequisite' value: each]!

basicLoad
	| package progressDialog progressCounter newPackageCreated |
	progressCounter := Array with: 1 with: self classes size + self resources size + 3.
	progressDialog := ProgressDialog operation: 
					[:progress | 
					progress caption: 'Loading package ' , self name , ' ' , self versionDescriptor.
					SessionManager current 
						logComment: '[STS] Begin loading package from repository: ' , self name , ' ' , versionDescriptor 
								, ' repository path: ' , self sourceControl databaseConnection dirName.
					self sourceControl ignoreCompilerWhile: 
							[(newPackageCreated := (package := Package manager packageNamed: self name ifNone: []) isNil) 
								ifTrue: [package := Package manager newPackage: self name , '.pac'].
							Notification 
								signal: 'Loading in package ' , self name , ' ' , self versionDescriptor , ' from repository'.
							progress value: 100 * (progressCounter first / progressCounter last).
							self scriptNames do: [:each | package scriptAt: each put: (self script: each)].
							package
								comment: self comment;
								aboutBlock: self aboutBlock;
								packageVersion: self versionDescriptor;
								imageStripperBytes: self imageStripperBytes.
							self pathName isNil 
								ifFalse: [package packagePathname = self pathName ifFalse: [package packagePathname: self pathName]].
							progressCounter at: 1 put: progressCounter first + 1.
							progress value: 100 * (progressCounter first / progressCounter last).
							package fileInScript: #preinstall.
							self
								declareGlobalsIn: package;
								compileClassDefinitionsIn: package;
								loadGlobals;
								compileClassesProgressDialog: progress progressCounter: progressCounter;
								compileLooseMethodsIn: package;
								loadResourcesIn: package
									progress: progress
									progressCounter: progressCounter.
							newPackageCreated ifFalse: [self removeOldClassesFrom: package].
							package
								initializeGlobals;
								manualPrerequisites: self manualPrerequisites;
								isChanged: false.
							"TO DO: set to false only if package was loaded without errors."
							self sourceControl setLoadedPackageIdentifiersFor: self to: self identifiers.
							SessionManager current 
								logComment: '[STS] Package version loaded from repository: ' , self name , ' ' , versionDescriptor 
										, ' repository path: ' , self sourceControl databaseConnection dirName.
							package fileInScript: #postinstall]].
	progressDialog
		caption: 'Please wait';
		showModal!

blessing
	^blessing!

blessing: aSymbolOrNil 
	(blessing isNil or: [self possibleBlessingLevels includes: aSymbolOrNil]) 
		ifFalse: [self error: 'Invalid blessing level'].
	blessing := aSymbolOrNil!

checkPrerequisites
	| loadedPackage missingNames str |
	((loadedPackage := Package manager packageNamed: name ifNone: []) notNil 
		and: [loadedPackage isChanged]) 
			ifTrue: 
				[(MessageBox 
					confirm: 'Currently loaded package edition has been changed.
If you continue these changes will be lost.

Are you sure you want to continue?'
					caption: 'Loading package ' , name) ifFalse: [^false]].
	^(missingNames := prerequisiteNames 
				select: [:each | (Package manager includesPackageNamed: each) not]) isEmpty 
		ifTrue: [true]
		ifFalse: 
			[str := 'The following prerequisite packages should be loaded before:

   - ' , missingNames first.
			2 to: missingNames size do: [:i | str := str , '
   - ' , (missingNames at: i)].
			MessageBox confirm: str , '

Are you sure you want to continue?'
				caption: 'Loading package ' , name]!

classes
	^classes!

classes: anArray 
	classes := anArray!

comment
	^comment!

comment: aString 
	comment := aString!

compareClassesFrom: packageEdition on: changes 
	| allClassNames dict1 dict2 class1 class2 |
	allClassNames := Set new.
	dict1 := LookupTable new.
	self classes do: [:each | dict1 at: (allClassNames add: each name) put: each].
	dict2 := LookupTable new.
	packageEdition classes do: [:each | dict2 at: (allClassNames add: each name) put: each].
	allClassNames asSortedCollection do: 
			[:eachName | 
			class1 := dict1 at: eachName ifAbsent: [].
			class2 := dict2 at: eachName ifAbsent: [].
			class1 isNil 
				ifTrue: 
					["class was removed from package in this edition"
					changes add: ((StsChangedClassNode new)
								description: 'class removed';
								rightEdition: class2)]
				ifFalse: 
					[class2 isNil 
						ifTrue: 
							["class was added to package in this edition"
							changes add: ((StsChangedClassNode new)
										description: 'class added';
										leftEdition: class1)]
						ifFalse: [class1 compareWith: class2 on: changes]]]!

compareGlobals: obj1 with: obj2 on: changes 
	(obj1 symmetricDifference: obj2) isEmpty 
		ifFalse: 
			[changes add: ((StsChangeNode new)
						elementDescription: 'Package globals';
						description: 'changed';
						leftSource: obj1 displayString;
						rightSource: obj2 displayString)]!

compareImageStrippers: obj1 with: obj2 on: changes 
	| is1 is2 aspects col node clsImageStripper |
	obj1 = obj2 ifTrue: [^nil].
	clsImageStripper := Smalltalk at: #ImageStripper ifAbsent: [^nil].
	node := StsChangeNode new elementDescription: 'ImageStripper'.
	obj1 isNil ifTrue: [^changes add: (node leftSource: 'value is nil')].
	obj2 isNil ifTrue: [^changes add: (node rightSource: 'value is nil')].
	is1 := clsImageStripper fromBinaryStoreBytes: obj1.
	is2 := clsImageStripper fromBinaryStoreBytes: obj2.
	aspects := clsImageStripper publishedAspectsOfInstances keys asSortedCollection.
	aspects remove: #yourself.
	col := OrderedCollection new.
	aspects 
		do: [:e | ([(is1 perform: e) = (is2 perform: e)] on: Error do: [:err | true]) ifFalse: [col add: e]].
	node
		description: 'changed';
		leftSource: col displayString;
		rightSource: col displayString.
	changes add: node!

compareLoadedClassesFrom: aPackage on: changes 
	| allClassNames dict1 dict2 class1 class2 manager transaction |
	manager := StsManager current.
	allClassNames := Set new.
	dict1 := LookupTable new.
	dict2 := LookupTable new.
	aPackage classes do: [:each | dict1 at: (allClassNames add: each name) put: each].
	self classes do: [:each | dict2 at: (allClassNames add: each name) put: each].
	ProgressDialog showModalWhile: 
			[:progress | 
			| index |
			index := 0.
			progress 
				caption: ('Comparing loaded <1d> with <2d>' expandMacrosWith: aPackage with: self versionDescriptor).
			allClassNames asSortedCollection do: 
					[:eachName | 
					index := index + 1.
					progress value: index * 100 // allClassNames size.
					transaction := manager databaseConnection newLongReadOnlyTransaction.
					(class1 := dict1 at: eachName ifAbsent: []) notNil 
						ifTrue: [class1 := manager findOrCreateClassEditionFor: class1 in: transaction].
					(class2 := dict2 at: eachName ifAbsent: []) notNil 
						ifTrue: [class2 := transaction objectAt: class2 odbGetOID].
					class1 isNil 
						ifTrue: 
							["class was removed from package in this edition"
							changes add: ((StsChangedClassNode new)
										description: 'class removed';
										rightEdition: class2)]
						ifFalse: 
							[class2 isNil 
								ifTrue: 
									["class was added to package in this edition"
									changes add: ((StsChangedClassNode new)
												description: 'class added';
												leftEdition: class1)]
								ifFalse: [class1 compareWith: class2 on: changes]]]]!

compareMethods: methods1 with: methods2 on: changes 
	| method1 method2 |
	((Set new)
		addAll: (methods1 collect: [:each | each name]);
		addAll: (methods2 collect: [:each | each name]);
		asSortedCollection) do: 
				[:eachName | 
				method1 := methods1 detect: [:each | each name = eachName] ifNone: [].
				method2 := methods2 detect: [:each | each name = eachName] ifNone: [].
				method1 isNil 
					ifTrue: 
						[self assert: [method2 notNil].
						"method was removed from package in this edition"
						changes add: ((StsChangedLooseMethodNode new)
									description: 'loose method removed';
									rightEdition: method2)]
					ifFalse: 
						[method2 isNil 
							ifTrue: 
								["method was added to package in this edition"
								changes add: ((StsChangedLooseMethodNode new)
											description: 'loose method added';
											leftEdition: method1)]
							ifFalse: 
								[method1 = method2 
									ifFalse: 
										["method was changed"
										changes add: ((StsChangedLooseMethodNode new)
													description: ((method1 isSimilarIgnoringCategoriesTo: method2) 
																ifTrue: ['loose method categories changed']
																ifFalse: ['loose method changed']);
													leftEdition: method1;
													rightEdition: method2)]]]]!

comparePrerequisites: names1 with: names2 
	| set1 set2 |
	set1 := Set new.
	set2 := Set new.
	names1 isNil ifFalse: [set1 addAll: names1].
	names2 isNil ifFalse: [set2 addAll: names2].
	set1 do: [:eachName | set2 remove: eachName ifAbsent: [^false]].
	^set2 isEmpty!

compareResources: resources1 with: resources2 on: changes 
	| resource1 resource2 |
	((Set new)
		addAll: (resources1 collect: [:each | each className , '>>' , each name]);
		addAll: (resources2 collect: [:each | each className , '>>' , each name]);
		asSortedCollection) do: 
				[:eachName | 
				resource1 := resources1 detect: [:each | (each className , '>>' , each name) = eachName] ifNone: [].
				resource2 := resources2 detect: [:each | (each className , '>>' , each name) = eachName] ifNone: [].
				resource1 isNil 
					ifTrue: 
						[self assert: [resource2 notNil].
						"resource1 was removed from package in this edition"
						changes add: ((StsChangedResourceNode new)
									elementDescription: resource2 className , '>>' , resource2 name;
									description: 'resource removed';
									rightEdition: resource2)]
					ifFalse: 
						[resource2 isNil 
							ifTrue: 
								["resource was added to package in this edition"
								changes add: ((StsChangedResourceNode new)
											elementDescription: resource1 className , '>>' , resource1 name;
											description: 'resource added';
											leftEdition: resource1)]
							ifFalse: 
								[resource1 resource = resource2 resource 
									ifFalse: 
										["resource1 was changed"
										changes add: ((StsChangedResourceNode new)
													elementDescription: resource1 className , '>>' , resource1 name;
													description: 'resource changed';
													leftEdition: resource1;
													rightEdition: resource2)]]]]!

compareScripts: scripts1 from: packageName1 with: scripts2 from: packageName2 on: changes 
	| script1 script2 |
	((Set new)
		addAll: (scripts1 keys collect: [:each | each]);
		addAll: (scripts2 keys collect: [:each | each]);
		asSortedCollection) do: 
				[:aSymbolKey | 
				script1 := scripts1 at: aSymbolKey ifAbsent: [].
				script2 := scripts2 at: aSymbolKey ifAbsent: [].
				(script1 isNil and: [script2 isNil]) 
					ifFalse: 
						[script1 isNil 
							ifTrue: 
								["script1 was removed from package in this edition"
								changes add: ((StsChangeNode new)
											elementDescription: aSymbolKey printString;
											description: 'script removed';
											rightEdition: packageName2;
											rightSource: script2)]
							ifFalse: 
								[script2 isNil 
									ifTrue: 
										["script was added to package in this edition"
										changes add: ((StsChangeNode new)
													elementDescription: aSymbolKey printString;
													description: 'script added';
													leftEdition: packageName1;
													leftSource: script1)]
									ifFalse: 
										[script1 = script2 
											ifFalse: 
												["script1 has changed"
												changes add: ((StsChangeNode new)
															elementDescription: aSymbolKey printString;
															description: 'script changed';
															leftSource: script1;
															leftEdition: packageName1;
															rightSource: script2;
															rightEdition: packageName2)]]]]]!

compareWith: packageEdition on: changes 
	"Compare self with packageEdition.
	Add change objects to the collection of changes."

	| lastChangeTimestamp |
	self comment = packageEdition comment 
		ifFalse: 
			[changes add: ((StsChangedPackageCommentNode new)
						description: 'comment changed';
						leftEdition: self;
						rightEdition: packageEdition)].
	self versionComment = packageEdition versionComment 
		ifFalse: 
			[changes add: ((StsChangedPackageVersionCommentNode new)
						description: 'version comment changed';
						leftEdition: self;
						rightEdition: packageEdition)].
	self blessing = packageEdition blessing 
		ifFalse: 
			[changes add: ((StsChangedBlessingNode new)
						description: 'blessing changed';
						leftEdition: self;
						rightEdition: packageEdition)].
	(self comparePrerequisites: self manualPrerequisites with: packageEdition manualPrerequisites) 
		ifFalse: 
			[changes add: ((StsChangedManualPrerequisitesNode new)
						description: 'manual prerequisites changed';
						leftEdition: self;
						rightEdition: packageEdition)]
		ifTrue: 
			[(self comparePrerequisites: self prerequisiteNames with: packageEdition prerequisiteNames) 
				ifFalse: 
					[changes add: ((StsChangedPrerequisitesNode new)
								description: 'package prerequisites changed';
								leftEdition: self;
								rightEdition: packageEdition)]].
	self
		compareClassesFrom: packageEdition on: changes;
		compareMethods: self methods
			with: packageEdition methods
			on: changes;
		compareResources: self resources
			with: packageEdition resources
			on: changes;
		compareGlobals: self globals keys
			with: packageEdition globals keys
			on: changes;
		compareImageStrippers: self imageStripperBytes
			with: packageEdition imageStripperBytes
			on: changes;
		compareScripts: self scripts
			from: self name , ' ' , self versionDescriptor
			with: packageEdition scripts
			from: packageEdition name , ' ' , packageEdition versionDescriptor
			on: changes.
	lastChangeTimestamp := self timestamp max: packageEdition timestamp.
	changes do: [:each | each changeTimestamp: lastChangeTimestamp]!

compareWithLoadedPackage: aPackage on: changes 
	| loadedMethods transaction manager loadedScripts changeTimestamp |
	self comment = aPackage comment 
		ifFalse: 
			[changes add: ((StsChangedPackageCommentNode new)
						description: 'comment changed';
						leftEdition: aPackage;
						rightEdition: self)].
	(self comparePrerequisites: self manualPrerequisites with: aPackage manualPrerequisites) 
		ifFalse: 
			[changes add: ((StsChangedManualPrerequisitesNode new)
						description: 'manual prerequisites changed';
						leftEdition: aPackage;
						rightEdition: self)]
		ifTrue: 
			[(self comparePrerequisites: self prerequisiteNames with: aPackage prerequisiteNames) 
				ifFalse: 
					[changes add: ((StsChangedPrerequisitesNode new)
								description: 'package prerequisites changed';
								leftEdition: aPackage;
								rightEdition: self)]].
	self compareLoadedClassesFrom: aPackage on: changes.
	manager := StsManager current.
	transaction := manager databaseConnection newLongReadOnlyTransaction.
	loadedMethods := aPackage methods collect: 
					[:each | 
					manager 
						findOrCreateMethodEditionFor: each
						methodDictionary: (manager getMethodDictionaryFor: each methodClass in: transaction)
						in: transaction].
	"wod - fix left/right order for globals and imageStrippers"
	self
		compareMethods: loadedMethods
			with: self methods
			on: changes;
		compareGlobals: aPackage globalNames
			with: self globalNames
			on: changes;
		compareImageStrippers: aPackage imageStripperBytes
			with: self imageStripperBytes
			on: changes.
	loadedScripts := (LookupTable new)
				at: #preinstall put: (aPackage scriptAt: #preinstall);
				at: #postinstall put: (aPackage scriptAt: #postinstall);
				at: #preuninstall put: (aPackage scriptAt: #preuninstall);
				at: #postuninstall put: (aPackage scriptAt: #postuninstall);
				yourself.
	self 
		compareScripts: loadedScripts
		from: '*' , aPackage name
		with: self scripts
		from: self name , ' ' , self versionDescriptor
		on: changes.
	changeTimestamp := (TimeStamp date: Date today time: (Time fromSeconds: Time now asSeconds)) 
				max: self timestamp.
	changes do: [:each | each changeTimestamp: changeTimestamp]!

compileClassDefinitionsIn: aPackage 
	| class |
	self orderedClasses do: 
			[:each | 
			((class := each realClass) isNil or: [class owningPackage == aPackage]) 
				ifFalse: 
					[self logWarning: 'Class ' , each name asString , ' has been moved to package ' , aPackage name.
					class owningPackage isNil ifFalse: [class owningPackage removeClass: class]].
			(class notNil and: [class definition = each definition]) 
				ifFalse: 
					[[Compiler evaluate: each definitionForCompilation logged: true] on: Error
						do: 
							[:ex | 
							self 
								logWarning: 'Class ' , each name asString , ' definition can not be compiled due to an error (' 
										, ex printString , ')']].
			(class := each realClass) notNil 
				ifTrue: 
					[class class definition = each classDefinition 
						ifFalse: 
							[[Compiler evaluate: each definition logged: true] on: Error
								do: 
									[:ex | 
									self 
										logWarning: 'Class ' , each name asString , ' definition can not be compiled due to an error (' 
												, ex printString , ')']].
					each guid isNil ifFalse: [class guid = each guid ifFalse: [class guid: each guid]].
					class comment = each comment ifFalse: [class comment: each comment].
					class owningPackage == aPackage ifFalse: [aPackage addClass: class]]]!

compileClassesProgressDialog: progress progressCounter: progressCounter 
	self classes do: 
			[:each | 
			progressCounter at: 1 put: progressCounter first + 1.
			progress value: 100 * (progressCounter first / progressCounter last).
			each realClass isNil 
				ifTrue: [self logError: 'Class ' , each name asString , ' could not be loaded']
				ifFalse: [each basicLoad]]!

compileLooseMethodsIn: aPackage 
	| packageManager class compiledMethod oldMethods selector classIsChanged classPackage packageIsChanged methodOverrideOnClass methodOverrideOnPackage |
	packageManager := Package manager.
	oldMethods := aPackage methods.
	self methods do: 
			[:each | 
			selector := each selector.
			(class := each methodClass) isNil 
				ifTrue: 
					[self logError: 'Could not compile method ' , each classSymbol asString , '>>' , selector asString 
								, ' due to non-existing class']
				ifFalse: 
					[compiledMethod := oldMethods 
								detect: [:eachMethod | eachMethod methodClass == class and: [eachMethod selector == selector]]
								ifNone: [].
					compiledMethod isNil 
						ifTrue: 
							[(compiledMethod := class methodDictionary at: selector ifAbsent: []) notNil 
								ifTrue: 
									[self logMethodOverride: compiledMethod.
									methodOverrideOnClass := compiledMethod methodClass.
									methodOverrideOnPackage := compiledMethod owningPackage]]
						ifFalse: [oldMethods remove: compiledMethod].
					classIsChanged := class instanceClass isChanged 
								or: [compiledMethod notNil and: [compiledMethod owningPackage ~~ aPackage]].
					packageIsChanged := (classPackage := packageManager packageOfClass: class instanceClass) isNil 
								ifFalse: [classPackage isChanged].
					(compiledMethod := class 
								compile: each source
								categories: each categories
								package: aPackage) notNil 
						ifTrue: 
							[packageManager addMethod: compiledMethod to: aPackage.
							classIsChanged = true ifFalse: [class instanceClass isChanged: false].
							(classPackage notNil and: [packageIsChanged ~= true and: [class instanceClass isChanged not]]) 
								ifTrue: [classPackage isChanged: false].
							methodOverrideOnClass isNil 
								ifFalse: 
									[methodOverrideOnPackage == methodOverrideOnClass owningPackage 
										ifTrue: [methodOverrideOnClass isChanged: true]
										ifFalse: [methodOverrideOnPackage isChanged: true]]]]].
	oldMethods do: [:each | each methodClass removeSelector: each selector]!

declareGlobalsIn: aPackage 
	self globalNames do: 
			[:globalName | 
			Smalltalk at: globalName put: nil.
			aPackage addGlobalNamed: globalName]!

displayName
	" Answer the name to display for the receiver in the various STS tools"

	"NOTE: Originally this method used to answer the package name with eith * or *+ appended to
	it. Frankly I always found this rather confusing so I have (temporarily at least) changed
	this to just answer the package name. Whether the package is loaded in the image and/or
	changed can be discerned from the icons in the tools. If the icon is the standard Package
	one,then the package or edition is loaded in the image. If the icon is followed by a star
	then the loaded package has changes wating to be committed.

	self isLoadedAndNotChanged ifTrue: [^'* ' , name].
	self isLoadedOrChangedAfterLoad ifTrue: [^'*+ ' , name].
	"

	^name!

displayOn: aStream 
	aStream
		nextPutAll: name;
		space;
		nextPutAll: versionDescriptor!

displayVersionDescriptor
	"See comment for #displayName.

	self isLoadedAndNotChanged ifTrue: [^'* ' , versionDescriptor].
	self isLoadedOrChangedAfterLoad ifTrue: [^'*+ ' , versionDescriptor].
	"

	^versionDescriptor!

exportAsXmlOn: stream 
	| writer |
	stream nextPutAll: '<?xml version="1.0"?>
'.
	writer := StsXmlWriter on: stream.
	self basicExportAsXmlOn: writer!

exporterVersion
	^'1.1'!

exportGlobalsAsXmlOn: writer 
	self globals keysAndValuesDo: 
			[:eachKey :eachValue | 
			writer tag: 'global'
				do: 
					[writer
						tag: 'name' value: eachKey;
						tag: 'value' cData: eachValue bytes asString]]!

exportResourcesAsXmlOn: writer 
	self resources do: 
			[:each | 
			writer tag: 'resource'
				do: 
					[writer
						tag: 'name' value: each name;
						tag: 'className' value: each className;
						tag: 'developer' value: each developer;
						tag: 'timestamp' value: each timestampValue;
						tag: 'data' cData: (each resource isNil ifFalse: [each resource binaryStoreBytes])]]!

exportScriptsAsXmlOn: writer 
	self scripts keysAndValuesDo: 
			[:eachKey :eachValue | 
			writer tag: 'script'
				do: 
					[writer
						tag: 'name' value: eachKey;
						tag: 'value' value: eachValue]]!

globalNames
	^globals keys!

globals
	^globals!

icon
	^self isLoaded ifTrue: [Package icon] ifFalse: [super icon]!

identifiers
	^Array 
		with: versionDescriptor
		with: timestamp
		with: developer
		with: false!

imageStripperBytes
	^imageStripperBytes odbResolve!

imageStripperBytes: aByteArray 
	imageStripperBytes := aByteArray!

initialize
	methods := OrderedCollection new.
	scripts := IdentityDictionary new.
	globals := IdentityDictionary new!

isBaseImagePackage
	"Answer true if the receiver is a basic component of Dolphin."

	" Not a terribly sophisticated in implementation - if the package reside under Object
	Arts\Dolphin then it is a system package"

	^self pathName beginsWith: 'Object Arts\Dolphin\' ignoreCase: true!

isLatestEdition
	| latestEdition |
	latestEdition := self sourceControl getLatestPackageEditionFor: self name.
	^latestEdition = self!

isLoaded
	| loadedIdentifiers |
	loadedIdentifiers := self sourceControl getLoadedPackageIdentifiersFor: self.
	^loadedIdentifiers notNil and: [(self identifiers first: 3) = (loadedIdentifiers first: 3)]!

isLoadedAndChangedAfterLoad
	| loadedIdentifiers |
	loadedIdentifiers := self sourceControl getLoadedPackageIdentifiersFor: self.
	^loadedIdentifiers notNil and: 
			[(self identifiers copyFrom: 1 to: 3) = (loadedIdentifiers copyFrom: 1 to: 3) 
				& (loadedIdentifiers at: 4)]!

isLoadedAndNotChanged
	^self identifiers = (self sourceControl getLoadedPackageIdentifiersFor: self)!

isLoadedOrChangedAfterLoad
	"Answer <true> if this package edition is the one which is loaded inside the image.
	Answer <true> regardless of any additional changes done inside the image after loading this edition.
	This method is used to determine the parent ie. previous edition of the package upon creating a new version from the code in the image."

	| loadedIdentifiers |
	loadedIdentifiers := self sourceControl getLoadedPackageIdentifiersFor: self.
	^loadedIdentifiers notNil 
		and: [(self identifiers copyFrom: 1 to: 3) = (loadedIdentifiers copyFrom: 1 to: 3)]!

isSameNamedPackageLoaded
	| loadedPackage |
	loadedPackage := Package manager packageNamed: self name ifNone: [].
	^loadedPackage notNil!

isSameNamedPackageLoadedAndChanged
	| loadedPackage |
	loadedPackage := Package manager packageNamed: self name ifNone: [].
	^loadedPackage notNil and: [loadedPackage isChanged]!

load
	self checkPrerequisites 
		ifTrue: 
			[Package manager beNotProcessingEvents.
			[self basicLoad] ensure: 
					[(Package manager)
						beProcessingEvents;
						loadedChanged]]!

loadGlobals
	self globals 
		keysAndValuesDo: [:globalName :globalValue | Smalltalk at: globalName put: globalValue odbResolve odbResolve]!

loadResourcesIn: aPackage progress: progress progressCounter: progressCounter 
	| resourceIdentifier owningClass selector |
	self resources do: 
			[:each | 
			progressCounter at: 1 put: progressCounter first + 1.
			progress value: 100 * (progressCounter first / progressCounter last).
			(owningClass := each owningClass) notNil 
				ifFalse: 
					[self logError: 'Owning class ' , each className asString , ' of resource ' , each name 
								, ' does not exist']
				ifTrue: 
					[selector := ('resource_' 
								, (each name collect: [:eachChar | eachChar = $  ifTrue: [$_] ifFalse: [eachChar]])) asSymbol.
					(owningClass class methodDictionary includesKey: selector) 
						ifTrue: [resourceIdentifier := ResourceIdentifier class: owningClass selector: selector]
						ifFalse: 
							[self logWarning: 'Resource ' , owningClass name asString , '.' , each name 
										, ' is not defined as class method. Loading resource from bytes.'.
							resourceIdentifier := ResourceIdentifier class: owningClass name: each name.
							resourceIdentifier assign: each resource odbResolve].
					aPackage addResourceIdentifier: resourceIdentifier]]!

manualPrerequisites
	^manualPrerequisites isNil ifTrue: [#()] ifFalse: [manualPrerequisites]!

manualPrerequisites: anObject 
	manualPrerequisites := anObject!

methods
	^methods!

name
	^name!

name: aString 
	name := aString!

orderedClasses
	| existingClasses orderedClasses classesToOrder remainingClasses |
	existingClasses := ((Smalltalk allClasses reject: [:each | each owningPackage name = name]) 
				collect: [:each | each name]) asSet.
	"wod changed - add #nil to the existingClasses so that proxy hierarchies will be correctly ordered."
	existingClasses add: #nil.
	classesToOrder := self classes.
	remainingClasses := OrderedCollection new.
	orderedClasses := OrderedCollection new.
	
	[classesToOrder do: 
			[:each | 
			(existingClasses includes: each superClassSymbol) 
				ifTrue: 
					[orderedClasses add: each.
					existingClasses add: each name]
				ifFalse: [remainingClasses add: each]].
	remainingClasses isEmpty or: [classesToOrder size = remainingClasses size]] 
			whileFalse: 
				[classesToOrder := remainingClasses.
				remainingClasses := OrderedCollection new].
	^orderedClasses
		addAll: remainingClasses;
		yourself!

packageVersion
	^versionDescriptor!

packageVersion: aString 
	MessageBox errorMsg: 'Package version in repository can not be changed'!

pathName
	^pathName!

pathName: path 
	pathName := path!

prerequisiteNames
	^prerequisiteNames!

prerequisiteNames: aCollection 
	prerequisiteNames := aCollection!

previousEdition
	^previousEdition!

previousEdition: aPackageEdition 
	previousEdition := aPackageEdition!

printOn: aStream 
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	super printOn: aStream.
	aStream
		nextPut: $(;
		display: self;
		nextPut: $)!

removeOldClassesFrom: package 
	package classes do: 
			[:eachClass | 
			self classes detect: [:eachClassEdition | eachClassEdition realClass == eachClass]
				ifNone: 
					[self logWarning: 'Class ' , eachClass printString , ' removed from package ' , self name 
								, ' and is now uncommitted (without a package).'.
					Package manager addClass: eachClass to: nil]]!

resolveProxies
	super resolveProxies.
	self classes do: [:each | each resolveProxies].
	self methods do: [:each | each resolveProxies].
	self resources do: [:each | each resolveProxies].
	self previousEdition ifNotNil: [:value | value resolveProxies]!

resources
	^resources!

resources: anOrderedCollection 
	resources := anOrderedCollection!

script: scriptSymbol 
	^scripts at: scriptSymbol ifAbsent: ['']!

script: scriptSymbol put: aString 
	scripts at: scriptSymbol put: aString!

scriptNames
	^#(#preinstall #postinstall #preuninstall #postuninstall)!

scripts
	^scripts!

statusIcon
	self isSameNamedPackageLoadedAndChanged ifTrue: [^Package changedIcon].
	^self isLatestEdition 
		ifTrue: [self class statusNormalIcon]
		ifFalse: [self class statusNewerEditionExistsIcon]!

versionComment
	"Answer the value of the receiver's ''versionComment'' instance variable."

	^versionComment isNil ifTrue: [''] ifFalse: [versionComment]!

versionComment: anObject 
	"Set the value of the receiver's ''versionComment'' instance variable to the argument, anObject."

	versionComment := anObject!

versionDescriptor
	^versionDescriptor!

versionDescriptor: aString 
	versionDescriptor := aString! !
!StsPackageEdition categoriesFor: #=!public! !
!StsPackageEdition categoriesFor: #aboutBlock!public! !
!StsPackageEdition categoriesFor: #aboutBlock:!public! !
!StsPackageEdition categoriesFor: #basicExportAsSmalltalkXChangeSetOn:packageName:!public! !
!StsPackageEdition categoriesFor: #basicExportAsSqueakChangeSetOn:packageName:!public! !
!StsPackageEdition categoriesFor: #basicExportAsVWChangeSetOn:parcelName:!public! !
!StsPackageEdition categoriesFor: #basicExportAsXmlOn:!public! !
!StsPackageEdition categoriesFor: #basicExportHeaderAsXmlOn:!public! !
!StsPackageEdition categoriesFor: #basicExportHeaderFieldsAsXmlOn:!private! !
!StsPackageEdition categoriesFor: #basicLoad!compiling!operations!public! !
!StsPackageEdition categoriesFor: #blessing!accessing!public! !
!StsPackageEdition categoriesFor: #blessing:!accessing!public! !
!StsPackageEdition categoriesFor: #checkPrerequisites!private! !
!StsPackageEdition categoriesFor: #classes!public! !
!StsPackageEdition categoriesFor: #classes:!accessing!public! !
!StsPackageEdition categoriesFor: #comment!accessing!public! !
!StsPackageEdition categoriesFor: #comment:!accessing!public! !
!StsPackageEdition categoriesFor: #compareClassesFrom:on:!comparing!private! !
!StsPackageEdition categoriesFor: #compareGlobals:with:on:!comparing!private! !
!StsPackageEdition categoriesFor: #compareImageStrippers:with:on:!comparing!private! !
!StsPackageEdition categoriesFor: #compareLoadedClassesFrom:on:!comparing!private! !
!StsPackageEdition categoriesFor: #compareMethods:with:on:!comparing!private! !
!StsPackageEdition categoriesFor: #comparePrerequisites:with:!comparing!private! !
!StsPackageEdition categoriesFor: #compareResources:with:on:!comparing!private! !
!StsPackageEdition categoriesFor: #compareScripts:from:with:from:on:!comparing!private! !
!StsPackageEdition categoriesFor: #compareWith:on:!comparing!public! !
!StsPackageEdition categoriesFor: #compareWithLoadedPackage:on:!comparing!public! !
!StsPackageEdition categoriesFor: #compileClassDefinitionsIn:!compiling!operations!private! !
!StsPackageEdition categoriesFor: #compileClassesProgressDialog:progressCounter:!compiling!operations!private! !
!StsPackageEdition categoriesFor: #compileLooseMethodsIn:!compiling!operations!private! !
!StsPackageEdition categoriesFor: #declareGlobalsIn:!compiling!operations!private! !
!StsPackageEdition categoriesFor: #displayName!displaying!public! !
!StsPackageEdition categoriesFor: #displayOn:!displaying!public! !
!StsPackageEdition categoriesFor: #displayVersionDescriptor!displaying!public! !
!StsPackageEdition categoriesFor: #exportAsXmlOn:!exporting!public! !
!StsPackageEdition categoriesFor: #exporterVersion!exporting!private! !
!StsPackageEdition categoriesFor: #exportGlobalsAsXmlOn:!exporting!private! !
!StsPackageEdition categoriesFor: #exportResourcesAsXmlOn:!exporting!private! !
!StsPackageEdition categoriesFor: #exportScriptsAsXmlOn:!exporting!private! !
!StsPackageEdition categoriesFor: #globalNames!accessing!public! !
!StsPackageEdition categoriesFor: #globals!accessing!public! !
!StsPackageEdition categoriesFor: #icon!accessing!public! !
!StsPackageEdition categoriesFor: #identifiers!accessing!private! !
!StsPackageEdition categoriesFor: #imageStripperBytes!accessing!public! !
!StsPackageEdition categoriesFor: #imageStripperBytes:!accessing!public! !
!StsPackageEdition categoriesFor: #initialize!initializing!private! !
!StsPackageEdition categoriesFor: #isBaseImagePackage!public!testing! !
!StsPackageEdition categoriesFor: #isLatestEdition!public! !
!StsPackageEdition categoriesFor: #isLoaded!public!testing! !
!StsPackageEdition categoriesFor: #isLoadedAndChangedAfterLoad!public!testing! !
!StsPackageEdition categoriesFor: #isLoadedAndNotChanged!public!testing! !
!StsPackageEdition categoriesFor: #isLoadedOrChangedAfterLoad!public!testing! !
!StsPackageEdition categoriesFor: #isSameNamedPackageLoaded!public!testing! !
!StsPackageEdition categoriesFor: #isSameNamedPackageLoadedAndChanged!public!testing! !
!StsPackageEdition categoriesFor: #load!operations!public! !
!StsPackageEdition categoriesFor: #loadGlobals!operations!private! !
!StsPackageEdition categoriesFor: #loadResourcesIn:progress:progressCounter:!compiling!operations!private! !
!StsPackageEdition categoriesFor: #manualPrerequisites!accessing!public! !
!StsPackageEdition categoriesFor: #manualPrerequisites:!accessing!public! !
!StsPackageEdition categoriesFor: #methods!accessing!public! !
!StsPackageEdition categoriesFor: #name!accessing!public! !
!StsPackageEdition categoriesFor: #name:!accessing!public! !
!StsPackageEdition categoriesFor: #orderedClasses!accessing!public! !
!StsPackageEdition categoriesFor: #packageVersion!accessing!public! !
!StsPackageEdition categoriesFor: #packageVersion:!accessing!public! !
!StsPackageEdition categoriesFor: #pathName!accessing!public! !
!StsPackageEdition categoriesFor: #pathName:!accessing!public! !
!StsPackageEdition categoriesFor: #prerequisiteNames!accessing!public! !
!StsPackageEdition categoriesFor: #prerequisiteNames:!accessing!public! !
!StsPackageEdition categoriesFor: #previousEdition!accessing!public! !
!StsPackageEdition categoriesFor: #previousEdition:!accessing!public! !
!StsPackageEdition categoriesFor: #printOn:!displaying!printing!public! !
!StsPackageEdition categoriesFor: #removeOldClassesFrom:!operations!private! !
!StsPackageEdition categoriesFor: #resolveProxies!OmniBase!public! !
!StsPackageEdition categoriesFor: #resources!accessing!public! !
!StsPackageEdition categoriesFor: #resources:!accessing!public! !
!StsPackageEdition categoriesFor: #script:!accessing!public! !
!StsPackageEdition categoriesFor: #script:put:!accessing!public! !
!StsPackageEdition categoriesFor: #scriptNames!accessing!private! !
!StsPackageEdition categoriesFor: #scripts!accessing!public! !
!StsPackageEdition categoriesFor: #statusIcon!accessing!public! !
!StsPackageEdition categoriesFor: #versionComment!accessing!public! !
!StsPackageEdition categoriesFor: #versionComment:!accessing!public! !
!StsPackageEdition categoriesFor: #versionDescriptor!accessing!public! !
!StsPackageEdition categoriesFor: #versionDescriptor:!accessing!public! !

!StsPackageEdition class methodsFor!

displayName
	^'Package'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

publishedAspectsOfInstances
	^(super publishedAspectsOfInstances)
		add: (Aspect string: #packageVersion);
		add: (Aspect name: #aboutBlock);
		yourself!

statusNewerEditionExistsIcon
	^Icon fromId: 'TIME.ICO'!

statusNormalIcon
	^Icon blank! !
!StsPackageEdition class categoriesFor: #displayName!public! !
!StsPackageEdition class categoriesFor: #icon!constants!public! !
!StsPackageEdition class categoriesFor: #publishedAspectsOfInstances!public! !
!StsPackageEdition class categoriesFor: #statusNewerEditionExistsIcon!private! !
!StsPackageEdition class categoriesFor: #statusNormalIcon!private! !

