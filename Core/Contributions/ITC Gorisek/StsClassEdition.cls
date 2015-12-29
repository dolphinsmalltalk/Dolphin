"Filed out from Dolphin Smalltalk X6.2"!

StsEdition subclass: #StsClassEdition
	instanceVariableNames: 'name guid definition classDefinition methods classMethods comment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsClassEdition guid: (GUID fromString: '{914F381D-11D6-11D4-B091-000000000000}')!
StsClassEdition comment: ''!
!StsClassEdition categoriesForClass!Unclassified! !
!StsClassEdition methodsFor!

<= aClassDescription 
	^self name <= aClassDescription name!

basicExportAsSqueakFileOutOn: aStream packageName: packageName 
	self
		basicExportDefinitionAsSqueakFileOutOn: aStream packageName: packageName;
		basicExportMethodsAsSqueakFileOutOn: aStream packageName: nil!

basicExportAsVastDoItScriptOn: aStream packageName: packageName 
	aStream
		nextPutAll: '
System image defaultApplication: (controllers at: ';
		nextPutAll: packageName printString;
		nextPutAll: ').
'.
	self basicExportDefinitionForVastOn: aStream.
	aStream nextPutAll: '.
'.
	self basicExportMethodsAsVastDoItScriptOn: aStream packageName: packageName!

basicExportAsVWChangeSetOn: xmlWriter parcelName: parcelName 
	self
		basicExportDefinitionAsVWChangeSetOn: xmlWriter parcelName: parcelName;
		basicExportMethodsAsVWChangeSetOn: xmlWriter parcelName: parcelName!

basicExportAsXmlOn: writer 
	writer tag: 'class'
		do: 
			[writer
				tag: 'name' value: self name;
				tag: 'developer' value: self developer;
				tag: 'timestamp' value: self timestampValue;
				tag: 'superClass' value: self superClassSymbol;
				tag: 'definition' value: self definition;
				tag: 'classDefinition' value: self classDefinition;
				tag: 'comment' value: self comment.
			self guid notNil ifTrue: [writer tag: 'GUID' value: self guid asString].
			writer
				tag: 'instanceMethods' do: [self methods do: [:each | each basicExportAsXmlOn: writer]];
				tag: 'classMethods' do: [self classMethods do: [:each | each basicExportAsXmlOn: writer]]]!

basicExportDefinitionAsSmalltalkXChangeSetOn: aStream packageName: packageName 
	| superClassName |
	self putSmalltalkXDeveloperAndTimestampOn: aStream.
	superClassName := self superClassSymbol asString.
	aStream 
		nextPutAll: superClassName 
				, (self isVariableClass ifTrue: [' variableSubclass: #'] ifFalse: [' subclass: #']) , self className 
				, '
	instanceVariableNames: ''' , self instVarNamesString 
				, '''
	classVariableNames: ''' , self classVarNamesString 
				, '''
	poolDictionaries: ''''
	category: ''' , (self replaceBlanksWithDash: packageName) 
				, '''
!!
'.
	self classInstVarNames isEmpty 
		ifFalse: 
			[self putSmalltalkXDeveloperAndTimestampOn: aStream.
			aStream 
				nextPutAll: self className , ' class instanceVariableNames: ''' , self classInstVarNamesString 
						, '''
!!']!

basicExportDefinitionAsSqueakFileOutOn: aStream packageName: packageName 
	"Previous implementation was incorect for classes with #classInstVarNames."

	| superClassName |
	superClassName := self superClassSymbol asString.
	aStream 
		nextPutAll: superClassName 
				, (self isVariableClass ifTrue: [' variableSubclass: #'] ifFalse: [' subclass: #']) , self className 
				, '
	instanceVariableNames: ''' , self instVarNamesString 
				, '''
	classVariableNames: ''' , self classVarNamesString 
				, '''
	poolDictionaries: ''''
	category: ''' , (self convertToSqueakPackageName: packageName) 
				, ''''.
	self classInstVarNames isEmpty 
		ifFalse: 
			[aStream 
				nextPutAll: self className , ' class instanceVariableNames: ''' , self classInstVarNamesString 
						, ''''].
	aStream nextPutAll: '
!!
'!

basicExportDefinitionAsVWChangeSetOn: xmlWriter parcelName: parcelName 
	| superClassName |
	superClassName := self classNameForVisualWorks: self superClassSymbol asString.
	xmlWriter tag: 'class'
		do: 
			[xmlWriter
				tag: 'name' value: self className;
				tag: 'environment' value: 'Smalltalk';
				tag: 'super' value: superClassName;
				tag: 'private' value: 'false';
				tag: 'indexed-type' value: 'none';
				tag: 'inst-vars' value: self instVarNamesString;
				tag: 'class-inst-vars' value: self classInstVarNamesString;
				tag: 'imports' value: '';
				tag: 'category' value: parcelName].
	xmlWriter tag: 'do-it'
		value: 'Smalltalk defineClass: #' , self className , '
	superclass: #{' , superClassName 
				, '}
	indexedType: #none
	private: false
	instanceVariableNames: ' 
					, self instVarNamesString printString , '
	classInstanceVariableNames: ' 
				, self classInstVarNamesString printString , '
	imports: ''''
	category: ' 
				, parcelName printString.
	xmlWriter tag: 'component_definition_change'
		do: 
			[xmlWriter
				tag: 'name' value: parcelName;
				tag: 'type' value: 'parcel';
				tag: 'definitionName' value: (self fullClassNameForVisualWorks: self className);
				tag: 'definitionChange' value: 'added']!

basicExportDefinitionForVastOn: aStream 
	| superClassName |
	superClassName := self superClassSymbol asString.
	aStream 
		nextPutAll: superClassName 
				, (self isVariableClass ifTrue: [' variableSubclass: #'] ifFalse: [' subclass: #']) , self className 
				, '
	classInstanceVariableNames: ''' , self classInstVarNamesString 
				, '''
	instanceVariableNames: ''' , self instVarNamesString 
				, '''
	classVariableNames: ''' , self classVarNamesString 
				, '''
	poolDictionaries: '''''!

basicExportMethodsAsSmalltalkXChangeSetOn: aStream packageName: packageName 
	self methods 
		do: [:each | each basicExportAsSmalltalkXChangeSetOn: aStream packageName: packageName].
	self classMethods 
		do: [:each | each basicExportAsSmalltalkXChangeSetOn: aStream packageName: packageName]!

basicExportMethodsAsSqueakFileOutOn: aStream packageName: packageName 
	self methods do: [:each | each basicExportAsSqueakFileOutOn: aStream packageName: nil].
	self classMethods do: [:each | each basicExportAsSqueakFileOutOn: aStream packageName: nil]!

basicExportMethodsAsVastDoItScriptOn: aStream packageName: packageName 
	self methods do: [:each | each basicExportAsVastDoItScriptOn: aStream packageName: packageName].
	self classMethods 
		do: [:each | each basicExportAsVastDoItScriptOn: aStream packageName: packageName]!

basicExportMethodsAsVWChangeSetOn: xmlWriter parcelName: parcelName 
	self methods do: [:each | each basicExportAsVWChangeSetOn: xmlWriter parcelName: parcelName].
	self classMethods do: [:each | each basicExportAsVWChangeSetOn: xmlWriter parcelName: parcelName]!

basicLoad
	| superClass class result error wasError |
	wasError := false.
	self sourceControl markClassAsChanged: self realClass.
	((superClass := self superClassSymbol) notNil and: [(Smalltalk at: superClass ifAbsent: []) isNil]) 
		ifTrue: 
			[wasError := true.
			self 
				logError: 'Superclass ' , superClass asString , ' of class ' , name asString , ' does not exist'].
	error := ''.
	((class := self realClass) notNil and: [class definition = self definitionForCompilation]) 
		ifTrue: [result := true]
		ifFalse: 
			[[result := Compiler evaluate: self definitionForCompilation logged: true] on: Error
				do: 
					[:ex | 
					wasError := true.
					error := ex description]].
	(error = '' and: [result notNil]) 
		ifFalse: 
			[wasError := true.
			self logError: 'Definition of class ' , self name asString , ' does not compile ' , error].
	error := ''.
	result := nil.
	((class := self realClass) notNil and: [class class definition = classDefinition]) 
		ifTrue: [result := true]
		ifFalse: 
			[[result := Compiler evaluate: classDefinition logged: true] on: Error
				do: 
					[:ex | 
					wasError := true.
					error := ex description]].
	(error = '' and: [result notNil]) 
		ifFalse: 
			[wasError := true.
			self logError: 'Class definition of ' , self name asString , ' does not compile' , error].
	(class := self realClass) isNil 
		ifTrue: 
			[wasError := true.
			self logError: 'Class ' , self name asString , ' could not be loaded']
		ifFalse: 
			[wasError := wasError | (self load: class methodEditions: methods) 
						| (self load: class class methodEditions: classMethods).
			self guid isNil ifFalse: [class guid = self guid ifFalse: [class guid: self guid]].
			class comment = self comment ifFalse: [self comment: self comment].
			wasError ifFalse: [self sourceControl setLoadedClassIdentifiersFor: class to: self odbGetOID]].
	^wasError not!

browseEdition
	self sourceControl checkIfConnected 
		ifTrue: 
			[(StsClassEditionsBrowserShell create)
				setClassName: name;
				selectEdition: self;
				showShell]!

classDefinition
	^classDefinition isNil ifTrue: [''] ifFalse: [classDefinition]!

classDefinition: aString 
	classDefinition := aString!

classInstVarNames
	| tokens |
	tokens := self classDefinition subStrings: $'.
	tokens size >= 2 ifFalse: [^nil].
	^(((tokens at: 2) subStrings: $ ) select: [:each | each notEmpty]) asSortedCollection asArray!

classInstVarNamesString
	| str |
	str := ''.
	self classInstVarNames do: [:each | str := str , ' ' , each].
	^str trimBlanks!

classMethods
	^classMethods!

classMethods: anOrderedCollection 
	classMethods := anOrderedCollection!

className
	^name asString!

classVarNames
	| tokens |
	tokens := self definition subStrings: $'.
	tokens size >= 6 ifFalse: [^nil].
	^(((tokens at: 4) subStrings: $ ) select: [:each | each notEmpty]) asSortedCollection asArray!

classVarNamesString
	| str |
	str := ''.
	self classVarNames do: [:each | str := str , ' ' , each].
	^str trimBlanks!

comment
	^comment isNil ifTrue: [''] ifFalse: [comment]!

comment: aString 
	comment := aString!

compareDefinitionWith: classEdition on: changes 
	| definitionChanged |
	(self superClassSymbol = classEdition superClassSymbol and: 
			[self instVarNames = classEdition instVarNames and: 
					[self poolDictionaries = classEdition poolDictionaries 
						and: [self classVarNames = classEdition classVarNames]]]) 
		ifFalse: 
			[definitionChanged := true.
			changes add: ((StsChangedClassDefinitionNode new)
						description: 'definition changed';
						leftEdition: self;
						rightEdition: classEdition)].
	classEdition comment = self comment 
		ifFalse: 
			[changes add: ((StsChangedClassCommentNode new)
						description: 'comment changed';
						leftEdition: self;
						rightEdition: classEdition)].
	(classEdition classInstVarNames = self classInstVarNames or: [definitionChanged = true]) 
		ifFalse: 
			[changes add: ((StsChangedClassClassDefinitionNode new)
						description: 'definition changed';
						leftEdition: self;
						rightEdition: classEdition)]!

compareMethods: coll1 with: coll2 
	| changes allSelectors dict1 dict2 method1 method2 |
	changes := OrderedCollection new.
	allSelectors := Set new.
	dict1 := IdentityDictionary new.
	coll1 do: [:eachMethod | dict1 at: (allSelectors add: eachMethod selector) put: eachMethod].
	dict2 := IdentityDictionary new.
	coll2 do: [:eachMethod | dict2 at: (allSelectors add: eachMethod selector) put: eachMethod].
	allSelectors asSortedCollection do: 
			[:eachSelector | 
			method1 := dict1 at: eachSelector ifAbsent: [].
			method2 := dict2 at: eachSelector ifAbsent: [].
			method1 isNil 
				ifTrue: 
					[self assert: [method2 notNil].
					"method was removed"
					changes add: ((StsChangedMethodNode new)
								description: 'method removed';
								rightEdition: method2)]
				ifFalse: 
					[method2 isNil 
						ifTrue: 
							["method was added"
							changes add: ((StsChangedMethodNode new)
										description: 'method added';
										leftEdition: method1)]
						ifFalse: 
							[method1 = method2 
								ifFalse: 
									["method was changed"
									changes add: ((StsChangedMethodNode new)
												description: ((method1 isSimilarIgnoringCategoriesTo: method2) 
															ifTrue: ['method categories changed']
															ifFalse: ['method changed']);
												leftEdition: method1;
												rightEdition: method2)]]]].
	^changes!

compareWith: classEdition on: changes 
	classEdition odbResolve == self ifTrue: [^self].
	self compareDefinitionWith: classEdition on: changes.
	changes
		addAll: (self compareMethods: methods with: classEdition methods);
		addAll: (self compareMethods: classMethods with: classEdition classMethods)!

definition
	^definition isNil ifTrue: [''] ifFalse: [definition]!

definition: aString 
	definition := aString!

definitionForCompilation
	"Will answer class definition which is suitable for loading a class into the current image.
	At this point it will only check if a superclass is an indexed class and change its own definition
	into an indexed class so that it can be compiled."

	| superClass def rs ws token |
	def := self definition.
	(superClass := Smalltalk at: self superClassSymbol ifAbsent: []) isNil ifTrue: [^def].
	superClass isVariable ifFalse: [^def].
	rs := ReadStream on: def.
	ws := WriteStream on: String new.
	token := rs upTo: $ .
	ws
		nextPutAll: token;
		nextPut: $ .
	rs upTo: $:.
	ws nextPutAll: (superClass isBytes 
				ifTrue: ['variableByteSubclass:']
				ifFalse: ['variableSubclass:']).
	[rs atEnd] whileFalse: [ws nextPut: rs next].
	^ws contents!

displayOn: aStream 
	timestamp isNil 
		ifTrue: [aStream nextPutAll: '*scratch edition']
		ifFalse: 
			[aStream nextPut: $(.
			timestamp printOn: aStream.
			aStream nextPut: $)].
	developer isNil ifFalse: [aStream nextPutAll: ' by ' , developer]!

guid
	^guid!

guid: aGUID 
	guid := aGUID!

icon
	^self realClass notNil ifTrue: [self realClass icon] ifFalse: [Object icon]!

instVarNames
	| tokens |
	tokens := self definition subStrings: $'.
	tokens size >= 6 ifFalse: [^nil].
	^(((tokens at: 2) subStrings: $ ) select: [:each | each notEmpty]) asSortedCollection asArray!

instVarNamesString
	| str |
	str := ''.
	self instVarNames do: [:each | str := str , ' ' , each].
	^str trimBlanks!

isVariableClass
	^'* variableSubclass: *' match: self definition!

load
	^self loadIn: nil!

load: aClass methodEditions: methodEditions 
	"Load methodEditions for aClass.
	Answer <true> if there was a compile error in at least one method.
	Else answer <false>."

	| selectors selector methodDictionary packageManager package method result |
	result := false.
	packageManager := Package manager.
	methodDictionary := aClass methodDictionary.
	selectors := aClass selectors.
	methodEditions do: 
			[:eachEdition | 
			selector := eachEdition selector.
			(selectors includes: selector) 
				ifTrue: 
					[method := methodDictionary at: selector.
					(package := packageManager packageOfMethod: method) isNil 
						ifFalse: 
							[self logMethodOverride: method.
							package removeMethod: method].
					selectors remove: eachEdition selector].
			(aClass compile: eachEdition source categories: eachEdition categories) isNil 
				ifTrue: 
					["method compilation did not succeed, answer <true>"
					result := true]].
	selectors do: 
			[:each | 
			(packageManager packageOfMethod: (methodDictionary at: each)) isNil 
				ifTrue: [aClass removeSelector: each ifAbsent: []]].
	^result!

loadDefinition
	| superClass error result |
	result := true.
	self sourceControl markClassAsChanged: self realClass.
	Notification 
		signal: 'Loading in changed class definition for ' , self name asString , ' (' 
				, self timestamp printString , ') from repository'.
	((superClass := self superClassSymbol) notNil and: [(Smalltalk at: superClass ifAbsent: []) isNil]) 
		ifTrue: 
			[self 
				logError: 'Superclass ' , superClass asString , ' of class ' , name asString , ' does not exist'].
	Cursor wait showWhile: 
			[self sourceControl ignoreCompilerWhile: 
					[error := ''.
					[result := result and: [(Compiler evaluate: self definitionForCompilation logged: true) notNil]] 
						on: Error
						do: [:ex | error := ex description].
					(error isNil or: [error isEmpty]) 
						ifFalse: 
							[self logError: 'Definition of class ' , self name asString , ' does not compile ' , error.
							result := false].
					error := ''.
					[result := result and: [(Compiler evaluate: classDefinition logged: true) notNil]] on: Error
						do: [:ex | error := ex description].
					(error isNil or: [error isEmpty]) 
						ifFalse: 
							[self logError: 'Class definition of ' , self name asString , ' does not compile' , error.
							result := false].
					self realClass isNil 
						ifTrue: 
							[self logError: 'Class ' , self name asString , ' could not be loaded'.
							result := false]]].
	^result!

loadIn: aPackage 
	| result |
	Notification signal: 'Loading in class ' , self name asString , ' (' , self timestamp printString 
				, ') from repository'.
	Cursor wait showWhile: 
			[self sourceControl ignoreCompilerWhile: 
					[| class |
					result := self basicLoad.
					(class := self realClass) isNil 
						ifFalse: 
							[aPackage isNil 
								ifTrue: 
									[class owningPackage isNil 
										ifTrue: [class superclass isNil ifFalse: [class owningPackage: class superclass owningPackage]]]
								ifFalse: [class owningPackage: aPackage]]]].
	^result!

methods
	^methods!

methods: anOrderedCollection 
	methods := anOrderedCollection!

name
	^name!

name: aSymbol 
	name := aSymbol!

poolDictionaries
	| tokens |
	tokens := self definition subStrings: $'.
	tokens size >= 6 ifFalse: [^nil].
	^(((tokens at: 6) subStrings: $ ) select: [:each | each notEmpty]) asSortedCollection asArray!

realClass
	^Smalltalk at: name ifAbsent: []!

resolveProxies
	super resolveProxies.
	self classMethods do: [:each | each resolveProxies].
	self methods do: [:each | each resolveProxies]!

superClassExists
	| superClass |
	^(superClass := self superClassSymbol) isNil or: [(Smalltalk at: superClass ifAbsent: []) notNil]!

superClassRealClass
	| superClass |
	^(superClass := self superClassSymbol) isNil ifFalse: [Smalltalk at: superClass ifAbsent: []]!

superClassSymbol
	^((ReadStream on: definition) upTo: $ ) asSymbol! !
!StsClassEdition categoriesFor: #<=!public! !
!StsClassEdition categoriesFor: #basicExportAsSqueakFileOutOn:packageName:!public! !
!StsClassEdition categoriesFor: #basicExportAsVastDoItScriptOn:packageName:!public! !
!StsClassEdition categoriesFor: #basicExportAsVWChangeSetOn:parcelName:!public! !
!StsClassEdition categoriesFor: #basicExportAsXmlOn:!public! !
!StsClassEdition categoriesFor: #basicExportDefinitionAsSmalltalkXChangeSetOn:packageName:!public! !
!StsClassEdition categoriesFor: #basicExportDefinitionAsSqueakFileOutOn:packageName:!public! !
!StsClassEdition categoriesFor: #basicExportDefinitionAsVWChangeSetOn:parcelName:!public! !
!StsClassEdition categoriesFor: #basicExportDefinitionForVastOn:!public! !
!StsClassEdition categoriesFor: #basicExportMethodsAsSmalltalkXChangeSetOn:packageName:!public! !
!StsClassEdition categoriesFor: #basicExportMethodsAsSqueakFileOutOn:packageName:!public! !
!StsClassEdition categoriesFor: #basicExportMethodsAsVastDoItScriptOn:packageName:!public! !
!StsClassEdition categoriesFor: #basicExportMethodsAsVWChangeSetOn:parcelName:!public! !
!StsClassEdition categoriesFor: #basicLoad!private! !
!StsClassEdition categoriesFor: #browseEdition!public! !
!StsClassEdition categoriesFor: #classDefinition!public! !
!StsClassEdition categoriesFor: #classDefinition:!public! !
!StsClassEdition categoriesFor: #classInstVarNames!public! !
!StsClassEdition categoriesFor: #classInstVarNamesString!public! !
!StsClassEdition categoriesFor: #classMethods!public! !
!StsClassEdition categoriesFor: #classMethods:!public! !
!StsClassEdition categoriesFor: #className!public! !
!StsClassEdition categoriesFor: #classVarNames!public! !
!StsClassEdition categoriesFor: #classVarNamesString!public! !
!StsClassEdition categoriesFor: #comment!public! !
!StsClassEdition categoriesFor: #comment:!public! !
!StsClassEdition categoriesFor: #compareDefinitionWith:on:!public! !
!StsClassEdition categoriesFor: #compareMethods:with:!public! !
!StsClassEdition categoriesFor: #compareWith:on:!public! !
!StsClassEdition categoriesFor: #definition!public! !
!StsClassEdition categoriesFor: #definition:!public! !
!StsClassEdition categoriesFor: #definitionForCompilation!public! !
!StsClassEdition categoriesFor: #displayOn:!public! !
!StsClassEdition categoriesFor: #guid!public! !
!StsClassEdition categoriesFor: #guid:!public! !
!StsClassEdition categoriesFor: #icon!public! !
!StsClassEdition categoriesFor: #instVarNames!public! !
!StsClassEdition categoriesFor: #instVarNamesString!public! !
!StsClassEdition categoriesFor: #isVariableClass!public! !
!StsClassEdition categoriesFor: #load!public! !
!StsClassEdition categoriesFor: #load:methodEditions:!private! !
!StsClassEdition categoriesFor: #loadDefinition!public! !
!StsClassEdition categoriesFor: #loadIn:!public! !
!StsClassEdition categoriesFor: #methods!public! !
!StsClassEdition categoriesFor: #methods:!public! !
!StsClassEdition categoriesFor: #name!public! !
!StsClassEdition categoriesFor: #name:!public! !
!StsClassEdition categoriesFor: #poolDictionaries!public! !
!StsClassEdition categoriesFor: #realClass!public! !
!StsClassEdition categoriesFor: #resolveProxies!OmniBase!public! !
!StsClassEdition categoriesFor: #superClassExists!public! !
!StsClassEdition categoriesFor: #superClassRealClass!public! !
!StsClassEdition categoriesFor: #superClassSymbol!public! !

!StsClassEdition class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon! !
!StsClassEdition class categoriesFor: #icon!constants!public! !

