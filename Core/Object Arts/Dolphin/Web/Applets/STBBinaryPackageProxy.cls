"Filed out from Dolphin Smalltalk 7"!

STBProxy subclass: #STBBinaryPackageProxy
	instanceVariableNames: 'name classes spare methodDictionaries methods resources'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STBBinaryPackageProxy guid: (GUID fromString: '{ec343a10-1955-44c5-a4b9-f328afa05fcc}')!
STBBinaryPackageProxy comment: 'An STBBinaryPackageProxy is used to represent a BinaryPackage when it is filed onto an STB stream. The proxy must ensure that all classes in the package are replaced by STBImportedClassProxiys to ensure that the associated code is also filed out (remember that STBClassProxys just file out a reference to a class not the entire class and its code). 

Another responsibility of the STBBinaryPackageProxy is to ensure that any potential forward class references are dealt with (to avoid a circularity when filing back in). We do this in a similar way to that employed by source packages, i.e. we file out ALL the class "definitions" first, then followed by the method definitions for each class. This is achieved by stubbing the method dictionaries to be empty in each class whilst also arranging for them to be saved in our methiodDictionaries instance variable. During fixup the true method dictionaries are restored.'!
!STBBinaryPackageProxy categoriesForClass!System-Binary storage! !
!STBBinaryPackageProxy methodsFor!

methodDictionarySource: aMethodDictionary keep: aBoolean 
	"Either keep or lose the source in aMethodDictionary according to aBoolean."

	aBoolean ifTrue: [^aMethodDictionary do: [:each | each sourceDescriptor: each getSource]].
	aMethodDictionary do: [:each | each sourceDescriptor: nil]!

setBinaryPackage: aBinaryPackage keepSource: keepSourceBoolean 
	name := aBinaryPackage name.
	classes := aBinaryPackage classes.
	methodDictionaries := IdentityDictionary new.

	"The method dictionaries for each class will have stubbed to be empty during the fileout. Here
	we save the true method dictionary contents for later restoration"
	classes do: 
			[:each | 
			| methodDict classMethodDict |
			methodDict := each methodDictionary copy.
			self methodDictionarySource: methodDict keep: keepSourceBoolean.
			classMethodDict := each class methodDictionary copy.
			self methodDictionarySource: classMethodDict keep: keepSourceBoolean.
			methodDictionaries at: each put: (Array with: methodDict with: classMethodDict)].
	methods := aBinaryPackage methods copy.
	self methodDictionarySource: methods keep: keepSourceBoolean.
	resources := aBinaryPackage resources!

stbFixup: inFiler at: anInteger
	"Answer the object that this one represents."

	self oneWayBecome: self value.

!

value
	| binaryPackage |
	binaryPackage := BinaryPackage basicNew.
	binaryPackage name: name.
	binaryPackage classes: classes.
	binaryPackage methods: methods.
	binaryPackage resources: resources.

	"Restore the method dictionaries that were stubbed out during the save"
	methodDictionaries keysAndValuesDo: 
			[:eachClass :eachMethodDictPair | 
			eachClass methodDictionary: eachMethodDictPair first.
			eachClass class methodDictionary: eachMethodDictPair second.
			eachClass class methodDictionary do: [:cm | cm methodClass: eachClass class]].
	^binaryPackage! !
!STBBinaryPackageProxy categoriesFor: #methodDictionarySource:keep:!private! !
!STBBinaryPackageProxy categoriesFor: #setBinaryPackage:keepSource:!private! !
!STBBinaryPackageProxy categoriesFor: #stbFixup:at:!converting!public! !
!STBBinaryPackageProxy categoriesFor: #value!private! !

!STBBinaryPackageProxy class methodsFor!

forBinaryPackage: aBinaryPackage keepSource: aBoolean 
	^self basicNew setBinaryPackage: aBinaryPackage keepSource: aBoolean
! !
!STBBinaryPackageProxy class categoriesFor: #forBinaryPackage:keepSource:!public! !

