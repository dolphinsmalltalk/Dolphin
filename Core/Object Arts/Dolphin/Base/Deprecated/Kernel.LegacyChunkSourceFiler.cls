"Filed out from Dolphin Smalltalk"!

Kernel.AbstractChunkSourceFiler subclass: #'Kernel.LegacyChunkSourceFiler'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.LegacyChunkSourceFiler guid: (Core.GUID fromString: '{b8df6074-f92e-4dfc-9bed-bc94bc5c3d2d}')!
Kernel.LegacyChunkSourceFiler comment: '`LegacyChunkSourceFiler` is a `SourceFiler` that files out packages in Dolphin 7 compatible format , where possible, so that these are loadable in Dolphin 7.1. An instance of this filer will be used for saving any package (or component of a package) with paxVersion < 2.1.

It is not possible to file out packages that contain namespaced program objects that are not bindable by unqualified name from Smalltalk. In other words the program objects in the package must be defined in Smalltalk, or one of the namespaces imported into Smalltalk (directly or indirectly). If an attempt is made to file out a package (or packaged class) that is not compatible, then a `SourceFormatNotSupportedError` detailing the first offending program object detected.  To workaround this for namespaced classes an alias variable can be added to the Smalltalk namespace. By convention such alias variables are packaged into a sidecar package with the same name as the original package with the suffix ''(Old Names)''.

Bear in mind that filing out a package/class in D7 format does not guarantee that it will actually be loadable in Dolphin 7.1, as it may have dependencies on new Dolphin 8 objects that are not present in Dolphin 7.1. There may also be behavioural changes that cause it to function differently, and of course the way to detect this is by defining a good set of unit tests.'!
!Kernel.LegacyChunkSourceFiler categoriesForClass!Unclassified! !
!Kernel.LegacyChunkSourceFiler methodsFor!

collateClass: aClass1 against: aClass2
	^aClass1 name <==> aClass2 name!

emitClassName: aClass
	stream nextPutAll: ((Smalltalk oldNames lookup: aClass) ifNil: [self getShortName: aClass])!

emitClassPoolOfClass: aClass
	"Private - Emit initialization expressions for each of the literal constants in the class pool of aClass."

	| literalConstants |
	literalConstants := aClass classPool associations
				select: [:each | each isImmutable and: [each value isLiteral]].
	literalConstants asSortedCollection
		do: [:each | self emitDeclarationForClass: aClass variable: each]!

emitDeclarationForClass: aClass variable: anAssociation
	| value |
	stream
		nextPutAll: aClass name;
		nextPutAll: (anAssociation isImmutable
					ifTrue: [' addClassConstant: ']
					ifFalse: [' addClassVariable: ']);
		print: anAssociation key;
		nextPutAll: ' value: '.
	value := anAssociation value.
	self
		nextChunkPut: (value isInteger ifTrue: [value printStringRadix: 16] ifFalse: [value storeString]).
	stream cr!

emitLiteral: anObject
	anObject isBehavior
		ifTrue: 
			[stream nextPutAll: '##(Smalltalk.'.
			self emitClassName: anObject.
			stream nextPut: $)]
		ifFalse: [anObject literalPrintOn: stream]!

emitPackageBinaryVariables: aPackage
	"Private - Emit the definitions for variables of the specified <Package> that are not aliases and which refer to non-source objects onto the receiver's stream."

	self
		emitComment: 'Binary Globals';
		cr.
	"Note that it is assumed that the variable names have already been validated as suitable for legacy format (i.e. all are defined in Smalltalk)."
	aPackage binaryVariableNames asSortedCollection do: 
			[:each |
			self
				emitBinaryVariableDefinition: each;
				cr]!

emitPackageClassNames: aPackage
	self
		emitPaxVariableNames: (aPackage classNames reject: [:each | each value inheritsFrom: SharedPool])
		accessor: #classNames!

emitPackageManualPrerequisites: aPackage
	"Private - File out the names of any manually configured pre-requisite packages of the <Package> argument onto the receiver's stream."

	| prereqs |
	prereqs := aPackage manualPrerequisites.
	prereqs isEmpty ifTrue: [^self].
	stream
		nextPutAll: 'package ';
		nextPutAll: #setManualPrerequisites:;
		nextPutAll: ' #('.
	prereqs do: 
			[:s |
			stream
				crtab;
				print: s].
	stream
		nextPutAll: ').';
		cr;
		cr!

emitPackageMethodNames: aPackage
	| names |
	names := aPackage methodNames.
	names isEmpty ifTrue: [^self].
	names := names collect: 
					[:each |
					| class name |
					class := each className value.
					name := (Smalltalk oldNames lookup: class) ifNil: [class shortName].
					(BindingReference isQualifiedName: name)
						ifTrue: 
							[^SourceFormatNotSupportedError
								signal: 'Extended classes must be bindable by unqualified name from Smalltalk.'
								with: each].
					(((name includes: $\x20) ifTrue: [name] ifFalse: [name asSymbol]) -> each selector) printString].
	stream
		nextPutAll: 'package ';
		display: #methodNames;
		cr.
	(names asSortedCollection: SortedCollection caseSensitiveSortBlock) do: 
			[:eachName |
			stream
				tab;
				nextPutAll: 'add: ';
				nextPutAll: eachName;
				nextPut: $;;
				cr].
	stream
		tab;
		nextPutAll: 'yourself.';
		cr;
		cr!

emitPackageNameSet: aCollectionOfBindingReferences initializer: aSymbol
	stream
		nextPutAll: 'package ';
		nextPutAll: aSymbol;
		nextPutAll: ' (';
		print: Set;
		space;
		nextPutAll: #new;
		cr.
	self
		emitPaxNames: (aCollectionOfBindingReferences collect: 
					[:each |
					| name |
					name := self getShortName: each.
					name asSymbol]).
	^stream
		nextPutAll: ').';
		cr;
		cr!

emitPackagePrerequisiteNames: aPackage
	| basePath prereqs oldNames aliasedByOldNames |
	stream
		nextPutAll: 'package ';
		nextPutAll: #setPrerequisites:;
		nextPutAll: ' #(';
		cr.
	basePath := aPackage path.
	"Replace the (Old Names) packages, that contain aliases from new namespaced class names back into Smalltalk, with the name of the underlying package.
	This should give us a legacy package file on disk that is identical to the 7.1 fileout of the same package in most cases."
	prereqs := aPackage prerequisites.
	oldNames := prereqs select: [:each | each name endsWith: '(Old Names)'].
	aliasedByOldNames := Set new.
	oldNames do: 
			[:each |
			aliasedByOldNames add: (each manager
						packageNamed: (each name copyFrom: 1 to: each name size - ##('(Old Names)' size + 1))
						ifNone: [])].
	prereqs := (prereqs difference: oldNames) union: aliasedByOldNames.
	(prereqs asSortedCollection: [:a :b | a name <==> b name < 0]) do: 
			[:each |
			stream
				tab;
				print: (File removeExtension: (File relativePathOf: each packageFileName to: basePath))]
		separatedBy: [stream cr].
	stream
		nextPutAll: ').';
		cr;
		cr!

emitPackageUntracedVariables: aPackage
	| untraced |
	untraced := aPackage untracedVariables.
	untraced isEmpty ifTrue: [^self].
	self emitPackageNameSet: untraced initializer: #untracedGlobals:!

emitPackageVariableNames: aPackage
	self emitPaxVariableNames: aPackage variableNames asArray
				, (aPackage classNames select: [:each | each value inheritsFrom: SharedPool]) asArray
		accessor: #globalNames!

emitPackageVariableNameSubsets: aPackage
	self emitPackageNameSet: aPackage binaryVariableNames initializer: #binaryGlobalNames:.
	self emitPackageNameSet: aPackage aliasVariableNames initializer: #globalAliases:!

emitPackageVariableReference: aBindingReference
	stream nextPutAll: aBindingReference unqualifiedName!

emitPaxNames: aCollectionOfSymbols
	(aCollectionOfSymbols asSortedCollection: SortedCollection caseSensitiveSortBlock) do: 
			[:each |
			stream
				tab;
				nextPutAll: 'add: ';
				print: each;
				nextPut: $;;
				cr].
	stream
		tab;
		nextPutAll: 'yourself'!

emitPaxVariableNames: aCollectionOfBindingReferences accessor: aSymbol
	aCollectionOfBindingReferences isEmpty ifTrue: [^self].
	stream
		nextPutAll: 'package ';
		display: aSymbol;
		cr.
	self emitPaxNames: (aCollectionOfBindingReferences
				collect: [:each | (self getSmalltalkVariableName: each) asSymbol]).
	stream
		nextPut: $.;
		cr;
		cr!

environment
	^Smalltalk
!

environment: aNamespace
	aNamespace == Smalltalk ifFalse: [self error: '<1p> can only be used for compiling code in the Smalltalk namespace' << self class]
!

fileOutAttributesOfClass: aClass
	"File-out any attributes of the aClass (e.g. the comment, GUID, etc) not included in the basic
	aClass definition, onto the source stream."

	self emitGUIDOfClass: aClass.
	self emitSpecialBehaviorAttributesOfClass: aClass.
	self emitClassPoolOfClass: aClass.
	self emitCommentOfClass: aClass.
	self emitCategoriesOfClass: aClass!

fileOutBasicDefinitionOfClass: aClass
	"Print a definition of the <Class>, aClass, onto the receiver's stream."

	| superclass |
	superclass := aClass superclass.
	(BindingReference isQualifiedName: superclass shortName)
		ifTrue: 
			[^SourceFormatNotSupportedError
				signal: 'The superclass <1p> is not bindable by unqualified name from Smalltalk.' << superclass
				with: aClass].
	self printBasicDefinitionOfClass: aClass.
	stream
		nextPut: $!!;
		cr!

fileOutClass: aClass ofPackage: aPackage
	(aClass inheritsFrom: SharedPool)
		ifTrue: [self fileOutPoolDictionary: (self makePoolConstsFromSharedPool: aClass)]
		ifFalse: [super fileOutClass: aClass ofPackage: aPackage]!

fileOutPackageMethods: aPackage
	"Private - File out the loose methods owned by the specified package to the receiver's stream."

	self
		emitComment: 'Loose Methods';
		cr.
	self fileOutMethods: aPackage methods!

fileOutPackageSourceVariables: aPackage
	"Private - File out the text representation of the specified packages 'source' object variables onto the receiver's stream. This is used in the single-file .PAC format."

	| names |
	"It is assumed that the variables have already been validated to check that they are all defined in Smalltalk."
	names := aPackage sourceVariableNames collect: [:each | each unqualifiedName -> each value].
	aPackage classNames do: 
			[:each |
			| class |
			"D7 does not have SharedPools, so we must convert back to a PoolConstantsDictionary"
			class := each value.
			(class inheritsFrom: SharedPool)
				ifTrue: 
					[| constsPool |
					constsPool := self makePoolConstsFromSharedPool: class.
					names add: constsPool name -> constsPool]].
	names isEmpty ifTrue: [^self].
	self
		emitComment: 'Source Globals';
		cr.
	names asSortedCollection do: 
			[:var |
			var value fileOutOn: self.
			self cr]!

fileOutPackageVariableAliases: aPackage
	"Private - File out the text representation of the specified package's alias variables onto the receiver's stream."

	| names |
	self
		emitComment: 'Global Aliases';
		cr.
	names := aPackage aliasVariableNames.
	names asSortedCollection do: 
			[:var |
			| name target |
			"Anything we define in a legacy format package must in the Smalltalk namespace."
			stream
				nextPutAll: (self getSmalltalkVariableName: var);
				nextPutAll: ' := '.
			target := var value.
			name := target unaliasedName.
			(BindingReference isQualifiedName: name)
				ifTrue: 
					[SourceFormatNotSupportedError
						signal: 'Alias targets must be bindable by unqualified name from Smalltalk'
						with: target].
			stream
				nextPutAll: name;
				nextPut: $!!;
				cr;
				cr].
	self cr!

fileOutPoolDictionary: aPoolDictionary
	"Private - Append a definition of the <PoolDictionary> (or <PoolConstantsDictionary>, aPoolDictionary, to the <puttableStream>, aWriteStream. The definition should be sufficient to recreate a copy of the dictionary."

	"PoolConstantsDictionary is no longer used in D8, and any loaded from older packages will be automatically upgraded to SharedPool classes at package load time. This method is used to save out a temporary instance created to maintain a compatible package definition."

	| poolName |
	poolName := aPoolDictionary name.
	stream
		display: Smalltalk;
		nextPutAll: ' at: ';
		print: poolName;
		nextPutAll: ' put: (';
		nextPutAll: aPoolDictionary class name;
		nextPutAll: ' named: ';
		print: poolName.
	self emitChunk: ')'.
	aPoolDictionary associations asSortedCollection do: 
			[:a |
			| value |
			stream
				nextPutAll: poolName;
				nextPutAll: ' at: ';
				print: a key;
				nextPutAll: ' put: '.
			value := a value.
			value isLiteral
				ifTrue: 
					[self emitChunk: (value isInteger ifTrue: [value printStringRadix: 16] ifFalse: [value printString])]
				ifFalse: 
					[stream
						nextPut: $(;
						print: Object;
						space;
						display: #fromBinaryStoreBytes:;
						space;
						cr.
					value binaryStoreBytes base64StoreOn: stream.
					self emitChunk: ')']].
	self emitChunk: poolName , ' shrink'!

getShortName: aProgramObject
	| name |
	name := aProgramObject shortName.
	^(BindingReference isQualifiedName: name)
		ifTrue: [SourceFormatNotSupportedError signalWith: aProgramObject]
		ifFalse: [name]!

getSmalltalkVariableName: aBindingReference
	aBindingReference environment == Smalltalk
		ifFalse: 
			[SourceFormatNotSupportedError signal: '<1s> can only be defined in Smalltalk.'
						<< ((aBindingReference value class isMeta
								and: [aBindingReference value fullName = aBindingReference pathString])
									ifTrue: ['Classes']
									ifFalse: ['Variables'])
				with: aBindingReference].
	^aBindingReference unqualifiedName!

makePoolConstsFromSharedPool: aSharedPoolClass
	| name constsPool |
	name := aSharedPoolClass unqualifiedName.
	constsPool := Smalltalk.PoolConstantsDictionary named: name.
	aSharedPoolClass bindingsDo: [:binding | constsPool add: binding].
	^constsPool!

packageClassesInFileoutOrder: aPackage
	^aPackage classesInHierarchyOrder reject: [:each | each inheritsFrom: SharedPool]!

printBasicDefinitionOfClass: aClass
	| superclass |
	superclass := aClass superclass.
	stream
		nextPutAll: ((Smalltalk oldNames lookup: superclass) ifNil: [superclass shortName]);
		space;
		nextPutAll: aClass kindOfSubclass;
		space;
		print: (aClass environment == aClass baseEnvironment
					ifTrue: [aClass unqualifiedName]
					ifFalse: 
						["Not supported by the format, but we print the qualified name here anyway as this method is used to print the class definition for display in browsers. The file out error is detected elsewhere."
						aClass fullName asSymbol]);
		crtab;
		nextPutAll: 'instanceVariableNames: ';
		print: aClass instanceVariableString;
		crtab;
		nextPutAll: 'classVariableNames: ';
		print: aClass classVariableString;
		crtab;
		nextPutAll: 'poolDictionaries: ';
		print: aClass sharedVariableString;
		crtab;
		nextPutAll: 'classInstanceVariableNames: ';
		print: aClass class instanceVariableString! !
!Kernel.LegacyChunkSourceFiler categoriesForMethods!
collateClass:against:!private!source filing! !
emitClassName:!private!source filing-file out! !
emitClassPoolOfClass:!private!source filing-file out! !
emitDeclarationForClass:variable:!private!source filing-file out! !
emitLiteral:!private!source filing! !
emitPackageBinaryVariables:!private!source filing! !
emitPackageClassNames:!accessing!private!source filing-pax! !
emitPackageManualPrerequisites:!private!source filing-pax! !
emitPackageMethodNames:!private!source filing-pax! !
emitPackageNameSet:initializer:!private!source filing-pax! !
emitPackagePrerequisiteNames:!private! !
emitPackageUntracedVariables:!private!source filing-pax! !
emitPackageVariableNames:!private!source filing-pax! !
emitPackageVariableNameSubsets:!private!source filing-pax! !
emitPackageVariableReference:!accessing!private!source filing! !
emitPaxNames:!private!source filing-pax! !
emitPaxVariableNames:accessor:!private!source filing-pax! !
environment!accessing!public! !
environment:!accessing!public! !
fileOutAttributesOfClass:!public!source filing! !
fileOutBasicDefinitionOfClass:!public!source filing-file out! !
fileOutClass:ofPackage:!public!source filing! !
fileOutPackageMethods:!private!source filing! !
fileOutPackageSourceVariables:!private! !
fileOutPackageVariableAliases:!private!source filing! !
fileOutPoolDictionary:!private!source filing! !
getShortName:!helpers!private! !
getSmalltalkVariableName:!helpers!private! !
makePoolConstsFromSharedPool:!helpers!private! !
packageClassesInFileoutOrder:!helpers!private! !
printBasicDefinitionOfClass:!public!source filing-file out! !
!

!Kernel.LegacyChunkSourceFiler class methodsFor!

fileOutExtensionForClass: aClass
	^(aClass inheritsFrom: SharedPool) ifTrue: ['st'] ifFalse: ['cls']! !
!Kernel.LegacyChunkSourceFiler class categoriesForMethods!
fileOutExtensionForClass:!enquiries!public! !
!

