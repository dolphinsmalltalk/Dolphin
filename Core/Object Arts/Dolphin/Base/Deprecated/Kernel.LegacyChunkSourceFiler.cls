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
!Kernel.LegacyChunkSourceFiler methodsFor!

collateClass: aClass1 against: aClass2
	^aClass1 name <==> aClass2 name!

emitBinaryVariableDefinition: aBindingReference
	"File out the text representation of the non-<sourceObject> which is the target of the
	<BindingReference> argument onto the receiver's source stream."

	| value binaryStream |
	value := aBindingReference value.
	self emitPackageVariableReference: aBindingReference.
	stream
		nextPutAll: ' := ';
		print: Object;
		space;
		display: #fromBinaryStoreBytes:;
		space;
		cr.
	binaryStream := ByteArray writeStream: 256.
	STBOutFiler new
		stream: binaryStream;
		version: 4;
		initialize;
		nextPut: value.
	binaryStream contents base64StoreOn: stream.
	stream
		nextPut: $!!;
		cr!

emitClassName: aClass
	stream nextPutAll: ((Smalltalk oldNames lookup: aClass) ifNil: [self getShortName: aClass])!

emitClassPoolOfClass: aClass
	"Private - Emit initialization expressions for each of the literal constants in the class pool of aClass."

	aClass classConstants sort do: [:each | self emitDeclarationForClass: aClass variable: each]!

emitDeclarationForClass: aClass variable: anAssociation
	| value |
	stream
		cr;
		nextPutAll: aClass name;
		nextPutAll: (anAssociation isImmutable
					ifTrue: [' addClassConstant: ']
					ifFalse: [' addClassVariable: ']);
		print: anAssociation key;
		nextPutAll: ' value: '.
	value := anAssociation value.
	self
		nextChunkPut: (value isInteger ifTrue: [value printStringRadix: 16] ifFalse: [value storeString])!

emitFileOutHeader
	"Note the typo. This needs to be fixed in Dolphin 7.1"

	self
		emitComment: 'Filed out from Dolphin Smalltalk';
		cr!

emitPackageBinaryVariables: aPackage
	"Private - Emit the definitions for variables of the specified <Package> that are not aliases and which refer to non-source objects onto the receiver's stream."

	self
		emitComment: 'Binary Globals';
		cr.
	"Note that it is assumed that the variable names have already been validated as suitable for legacy format (i.e. all are defined in Smalltalk)."
	aPackage binaryVariableNames asSortedArray do: 
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
	(names asSortedArray: SortedCollection caseSensitiveSortBlock) do: 
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
	| basePath prereqs new old downgrades pkgmgr legacyPaths |
	stream
		nextPutAll: 'package ';
		nextPutAll: #setPrerequisites:;
		nextPutAll: ' #(';
		cr.
	"Replace the (Old Names) packages, that contain aliases from new namespaced class names back into Smalltalk, with the name of the underlying package.
	This should give us a legacy package file on disk that is identical to the 7.1 fileout of the same package in most cases."
	prereqs := aPackage prerequisites.
	new := prereqs select: [:each | each name endsWith: '(Old Names)'].
	old := Set new.
	pkgmgr := Package manager.
	new do: 
			[:each |
			old
				add: (pkgmgr packageNamed: (each name copyFrom: 1 to: each name size - ##('(Old Names)' size + 1))
						ifNone: nil)].
	downgrades := self equivalentLegacyPrerequisites.
	prereqs do: 
			[:each |
			| name |
			name := each name.
			(downgrades lookup: name)
				ifNotNil: 
					[:downgrade |
					new add: each.
					old add: (pkgmgr packageNamed: downgrade)]].
	prereqs := (prereqs difference: new) union: old.
	basePath := aPackage path.
	legacyPaths := self legacyPackagePaths.
	(prereqs asSortedArray: [:a :b | a name <==> b name < 0]) do: 
			[:each |
			| filename |
			filename := File fullPathOf: ((legacyPaths lookup: each name) ifNil: [each packagePathname])
						relativeTo: SessionManager current imageBase.
			stream
				tab;
				print: (File removeExtension: (File relativePathOf: filename to: basePath))]
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
	(aCollectionOfSymbols asSortedArray: SortedCollection caseSensitiveSortBlock) do: 
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

emitResourceMethod: aResourceIdentifier literals: aLiteralArray
	| printer |
	self emitResourceMethodHeader: aResourceIdentifier.
	stream
		tab;
		nextPut: $^;
		nextPutAll: '#('.
	"Pretend it is a version 4 stream to give D7 a fighting chance of loading it - it will fail if D8 specific objects have been added, e.g. BindingReferences.
	On the whole, if forwards compatibility must be maintained it is better not to attempt to edit view resources in D8 that must be loaded in D7, although more of the D8 changes could be back-ported (e.g. the ImageInitializer hierarchy) if there is an incentive."
	printer := LegacySTLPrinter on: stream.
	aLiteralArray first literalPrintOn: printer.
	stream nextPutAll: ' 4 '.
	3 to: aLiteralArray size
		do: 
			[:i |
			(aLiteralArray at: i) literalPrintOn: printer.
			stream space].
	stream nextPut: $)!

environment
	^Smalltalk
!

environment: aNamespace
	aNamespace == Smalltalk ifFalse: [Warning signal: '<1p> can only be used for code in the Smalltalk namespace' << self class]
!

equivalentLegacyPrerequisites
	"Private - Some packages have been split into multiple packages in Dolphin 8. If a legacy package is dependent on one of those new packages that is part of the original package, we want to file out a pre-requisite that is the original package. This will maintain the correct pre-reqs when roundtripping back to D7 so that the package remains loadable (unless it has been modified to add dependencies only in Dolphin 8). The pre-reqs should generally be at least sufficient for Dolphin 8 too, since typically the original package has the new package that contains part of it as one of its own pre-requisites."

	^##(LookupTable withAll: {'Dolphin GDI Graphics' -> 'Dolphin MVP Base'.
				'Common Controls Library' -> 'Dolphin MVP Base'.
				'Dolphin Check Buttons' -> 'Dolphin MVP Base'.
				'Dolphin Push Buttons' -> 'Dolphin MVP Base'.
				'Dolphin Splitter Control' -> 'Dolphin MVP Base'})!

fileOutAttributesOfClass: aClass
	"File-out any attributes of the aClass (e.g. the comment, GUID, etc) not included in the basic
	aClass definition, onto the source stream."

	aClass guid
		ifNotNil: 
			[self
				cr;
				emitGUIDOfClass: aClass].
	aClass hasSpecialBehavior
		ifTrue: 
			[self
				cr;
				emitSpecialBehaviorAttributesOfClass: aClass].
	self emitClassPoolOfClass: aClass.
	aClass comment
		ifNotNil: 
			[self
				cr;
				emitCommentOfClass: aClass].
	self
		cr;
		emitCategoriesOfClass: aClass!

fileOutBasicDefinitionOfClass: aClass
	"Print a definition of the <Class>, aClass, onto the receiver's stream."

	self printBasicDefinitionOfClass: aClass.
	stream nextPut: $!!!

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
	names asSortedArray do: 
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
	names asSortedArray do: 
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
	aPoolDictionary associations sort do: 
			[:a |
			| value |
			stream
				nextPutAll: poolName;
				nextPutAll: ' at: ';
				print: a key;
				nextPutAll: ' put: '.
			value := a value.
			value isSelfEvaluating
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

legacyPackagePaths
	"Private - Some packages have been moved to new folders in Dolphin 8."

	^##(LookupTable
		withAll: {'Dolphin Message Box' -> 'Core\Object Arts\Dolphin\Base\Dolphin Message Box'})!

makePoolConstsFromSharedPool: aSharedPoolClass
	| name constsPool |
	name := aSharedPoolClass unqualifiedName.
	constsPool := Smalltalk.PoolConstantsDictionary named: name.
	aSharedPoolClass bindingsDo: [:binding | constsPool add: binding].
	^constsPool!

packageClassesInFileoutOrder: aPackage
	^aPackage classesInHierarchyOrder reject: [:each | each inheritsFrom: SharedPool]!

printBasicDefinitionOfClass: aClass
	"We may not be able to file out the class in legacy format if it's superclass requires a qualified name - if not, an error will be raised here when we try to resolve the short name. It is usually possible to workaround this problem by adding an alias for the superclass into the Smalltalk namespace. The alias variable should be added to an 'Old Names' package."

	aClass superclass
		ifNil: [stream print: nil]
		ifNotNil: [:superclass | stream nextPutAll: (self shortNameForClass: superclass)].
	stream
		space;
		nextPutAll: aClass kindOfSubclass;
		space;
		print: (aClass isInBaseEnvironment
					ifTrue: [aClass unqualifiedName]
					ifFalse: 
						["Not supported by the format, but we print the qualified name here anyway as this method is used to print the class definition for display in browsers. The file out error is detected elsewhere."
						aClass fullName asSymbol]);
		crtab.
	self printVariables: aClass instanceVariableNames string: 'instanceVariableNames:'.
	stream
		crtab;
		nextPutAll: 'classVariableNames: ';
		print: aClass classVariableString;
		crtab.
	self printVariables: aClass sharedPoolNames asSortedArray string: 'poolDictionaries:'.
	stream crtab.
	self printVariables: aClass classInstanceVariableNames string: 'classInstanceVariableNames:'!

sharedPoolNames: aClass
	^aClass imports collect: 
			[:each |
			(each valueOrNil ifNotNil: [:sharedPoolClass | Smalltalk oldNames lookup: sharedPoolClass])
				ifNil: [each unqualifiedName]]!

shortNameForClass: aClass
	^(Smalltalk oldNames lookup: aClass) ifNil: [self getShortName: aClass]!

specialBehaviorAttributes
	^#(#(#isIndirection) #(#isNullTerminated) #(#isNonInstantiable #isAbstract) #(#isMourner))! !
!Kernel.LegacyChunkSourceFiler categoriesForMethods!
collateClass:against:!private!source filing! !
emitBinaryVariableDefinition:!public!source filing-file out! !
emitClassName:!private!source filing-file out! !
emitClassPoolOfClass:!private!source filing-file out! !
emitDeclarationForClass:variable:!private!source filing-file out! !
emitFileOutHeader!private!source filing! !
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
emitResourceMethod:literals:!private!source filing! !
environment!accessing!public! !
environment:!accessing!public! !
equivalentLegacyPrerequisites!constants!private! !
fileOutAttributesOfClass:!public!source filing! !
fileOutBasicDefinitionOfClass:!public!source filing-file out! !
fileOutClass:ofPackage:!public!source filing! !
fileOutPackageMethods:!private!source filing! !
fileOutPackageSourceVariables:!private! !
fileOutPackageVariableAliases:!private!source filing! !
fileOutPoolDictionary:!private!source filing! !
getShortName:!helpers!private! !
getSmalltalkVariableName:!helpers!private! !
legacyPackagePaths!constants!private! !
makePoolConstsFromSharedPool:!helpers!private! !
packageClassesInFileoutOrder:!helpers!private! !
printBasicDefinitionOfClass:!public!source filing-file out! !
sharedPoolNames:!public!source filing-file out! !
shortNameForClass:!public!source filing-file out! !
specialBehaviorAttributes!constants!public! !
!

!Kernel.LegacyChunkSourceFiler class methodsFor!

fileOutExtensionForClass: aClass
	^(aClass inheritsFrom: SharedPool) ifTrue: ['st'] ifFalse: ['cls']! !
!Kernel.LegacyChunkSourceFiler class categoriesForMethods!
fileOutExtensionForClass:!enquiries!public! !
!

