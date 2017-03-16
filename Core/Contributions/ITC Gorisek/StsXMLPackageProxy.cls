"Filed out from Dolphin Smalltalk 7"!

StsPackageProxy subclass: #StsXMLPackageProxy
	instanceVariableNames: 'exporterVersion'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsXMLPackageProxy guid: (GUID fromString: '{11b0375d-a3f1-4404-a1fe-59e83d198be9}')!
StsXMLPackageProxy comment: ''!
!StsXMLPackageProxy categoriesForClass!Unclassified! !
!StsXMLPackageProxy methodsFor!

basicImportFrom: rootElement 
	| nodeName prerequisiteSet contentString |
	classes := OrderedCollection new.
	looseMethods := OrderedCollection new.
	resources := OrderedCollection new.
	prerequisiteSet := IdentitySet new.
	(exporterVersion := rootElement attributeAt: 'version' ifAbsent: []) isNil 
		ifFalse: [exporterVersion := exporterVersion asNumber].
	rootElement elements do: 
			[:each | 
			nodeName := each name.
			contentString := each contentString.
			(self basicImportHeaderFieldsFrom: each) 
				ifFalse: 
					[nodeName == #manualPrerequisite 
						ifTrue: 
							[manualPrerequisites isNil ifTrue: [manualPrerequisites := OrderedCollection new].
							manualPrerequisites add: contentString]
						ifFalse: 
							[nodeName == #prerequisite 
								ifTrue: [prerequisiteSet add: contentString]
								ifFalse: 
									[nodeName == #class 
										ifTrue: [self importClass: each]
										ifFalse: 
											[nodeName == #looseMethod 
												ifTrue: [self importLooseMethod: each]
												ifFalse: 
													[nodeName == #resource 
														ifTrue: [self importResource: each]
														ifFalse: 
															[nodeName == #global 
																ifTrue: [self importGlobal: each]
																ifFalse: 
																	[nodeName == #script 
																		ifTrue: [self importScript: each]
																		ifFalse: 
																			[nodeName == #imageStripperBytes 
																				ifTrue: [self imageStripperBytes: (self stringToByteArray: contentString)]]]]]]]]]].
	self prerequisiteNames: prerequisiteSet!

basicImportHeaderFieldsFrom: aNode 
	| nodeName contentString |
	contentString := aNode contentString.
	(nodeName := aNode name) == #name 
		ifTrue: [self name: contentString]
		ifFalse: 
			[nodeName == #developer 
				ifTrue: [self developer: contentString]
				ifFalse: 
					[nodeName == #timestamp 
						ifTrue: [self timestamp: (TimeStamp fromSeconds: contentString asNumber asInteger)]
						ifFalse: 
							[nodeName == #pathName 
								ifTrue: [self packagePathname: contentString]
								ifFalse: 
									[nodeName == #comment 
										ifTrue: [self comment: contentString]
										ifFalse: 
											[nodeName == #versionDescriptor 
												ifTrue: [self version: contentString]
												ifFalse: 
													[nodeName == #blessing 
														ifTrue: [self blessing: contentString asSymbol]
														ifFalse: [nodeName == #versionComment ifTrue: [self versionComment: contentString] ifFalse: [^false]]]]]]]].
	^true!

basicImportHeaderFrom: rootElement 
	| nodeName prerequisiteSet contentString |
	classes := OrderedCollection new.
	looseMethods := OrderedCollection new.
	resources := OrderedCollection new.
	prerequisiteSet := IdentitySet new.
	(exporterVersion := rootElement attributeAt: 'version' ifAbsent: []) isNil 
		ifFalse: [exporterVersion := exporterVersion asNumber].
	rootElement elements do: 
			[:each | 
			contentString := each contentString.
			nodeName := each name.
			(self basicImportHeaderFieldsFrom: each) 
				ifFalse: 
					[nodeName == #manualPrerequisite 
						ifTrue: 
							[manualPrerequisites isNil ifTrue: [manualPrerequisites := OrderedCollection new].
							manualPrerequisites add: contentString]
						ifFalse: [nodeName == #prerequisite ifTrue: [prerequisiteSet add: contentString]]]].
	self prerequisiteNames: prerequisiteSet!

globalFromName: aSymbol 
	^globals at: aSymbol!

importClass: anElement 
	| nodeName classProxy |
	anElement elements do: 
			[:each | 
			nodeName := each name.
			nodeName == #name 
				ifTrue: [classProxy := self findOrCreateClassNamed: each contentString asSymbol]
				ifFalse: 
					[classProxy isNil 
						ifFalse: 
							[nodeName == #developer 
								ifTrue: [classProxy developer: each contentString]
								ifFalse: 
									[nodeName == #timestamp 
										ifTrue: [classProxy timestamp: (TimeStamp fromSeconds: each contentString asNumber asInteger)]
										ifFalse: 
											[nodeName == #definition 
												ifTrue: [classProxy definition: each contentString]
												ifFalse: 
													[nodeName == #comment 
														ifTrue: [classProxy comment: each contentString]
														ifFalse: 
															[nodeName == #guid 
																ifTrue: [classProxy guid: each contentString]
																ifFalse: 
																	[nodeName == #instanceMethods 
																		ifTrue: [self importMethods: each classProxy: classProxy]
																		ifFalse: 
																			[nodeName == #classMethods ifTrue: [self importMethods: each classProxy: classProxy metaClass]]]]]]]]]]!

importGlobal: aXmlElement 
	| nodeName globalName globalValue |
	aXmlElement elements do: 
			[:each | 
			nodeName := each name.
			nodeName == #name 
				ifTrue: [globalName := each contentString]
				ifFalse: [nodeName == #value ifTrue: [globalValue := self stringToByteArray: each contentString]]].
	globalName isNil 
		ifFalse: [self global: globalName asSymbol put: (StsStbProxy new bytes: globalValue)]!

importLooseMethod: aXmlElement 
	| nodeName method className classProxy developerString timestampString categoriesString sourceString methodPrivate |
	methodPrivate := false.
	aXmlElement elements do: 
			[:each | 
			nodeName := each name.
			nodeName == #class 
				ifTrue: [className := each contentString]
				ifFalse: 
					[nodeName == #developer 
						ifTrue: [developerString := each contentString]
						ifFalse: 
							[nodeName == #timestamp 
								ifTrue: [timestampString := each contentString]
								ifFalse: 
									[nodeName == #categories 
										ifTrue: [categoriesString := each contentString]
										ifFalse: 
											[nodeName == #source 
												ifTrue: [sourceString := each contentString]
												ifFalse: [nodeName == #isPrivate ifTrue: [methodPrivate := each contentString asLowercase = 'true']]]]]]].
	className isNil 
		ifFalse: 
			[classProxy := StsClassProxy new name: className.
			method := StsCompiledMethodProxy new methodClass: classProxy.
			method isPrivate: methodPrivate.
			developerString isNil ifFalse: [method developer: developerString].
			timestampString isNil 
				ifFalse: [method timestamp: (TimeStamp fromSeconds: timestampString asNumber asInteger)].
			categoriesString isNil ifFalse: [method categoriesString: categoriesString].
			sourceString isNil ifFalse: [method methodSource: sourceString].
			method selector isNil 
				ifFalse: 
					[looseMethods add: method.
					classProxy methodDictionary at: method selector put: method]]!

importMethod: aXmlElement classProxy: classProxy 
	| nodeName method |
	method := StsCompiledMethodProxy new methodClass: classProxy.
	aXmlElement elements do: 
			[:each | 
			nodeName := each name.
			nodeName == #developer 
				ifTrue: [method developer: each contentString]
				ifFalse: 
					[nodeName == #timestamp 
						ifTrue: [method timestamp: (TimeStamp fromSeconds: each contentString asNumber asInteger)]
						ifFalse: 
							[nodeName == #categories 
								ifTrue: [method categoriesString: each contentString]
								ifFalse: 
									[nodeName == #isPrivate 
										ifTrue: [method isPrivate: each contentString asLowercase = 'true']
										ifFalse: [nodeName == #source ifTrue: [method methodSource: each contentString]]]]]].
	method selector isNil ifFalse: [classProxy methodDictionary at: method selector put: method]!

importMethods: aXmlElement classProxy: classProxy 
	| nodeName |
	aXmlElement elements do: 
			[:each | 
			nodeName := each name.
			nodeName == #method ifTrue: [self importMethod: each classProxy: classProxy]]!

importResource: aXmlElement 
	| nodeName resource |
	resource := StsDolphinResourceProxy new.
	aXmlElement elements do: 
			[:each | 
			nodeName := each name.
			nodeName == #name 
				ifTrue: [resource name: each contentString]
				ifFalse: 
					[nodeName == #className 
						ifTrue: [resource owningClass: (StsClassProxy new name: each contentString)]
						ifFalse: 
							[nodeName == #developer 
								ifTrue: [resource developer: each contentString]
								ifFalse: 
									[nodeName == #timestamp 
										ifTrue: [resource timestamp: (TimeStamp fromSeconds: each contentString asNumber asInteger)]
										ifFalse: 
											[nodeName == #data 
												ifTrue: [resource resource: (self resourceFromByteArray: (self stringToByteArray: each contentString))]]]]]].
	self addResource: resource!

importScript: aXmlElement 
	| nodeName scriptName scriptValue |
	aXmlElement elements do: 
			[:each | 
			nodeName := each name.
			nodeName == #name 
				ifTrue: [scriptName := each contentString]
				ifFalse: [nodeName == #value ifTrue: [scriptValue := each contentString]]].
	scriptName isNil ifFalse: [self scriptAt: scriptName asSymbol put: scriptValue]!

loadFrom: pathName 
	| file xmlText doc |
	file := FileStream read: pathName.
	[xmlText := file contents] ensure: [file close].
	(xmlText beginsWith: '<?xml') ifFalse: [xmlText := ZLibInterface decompress: xmlText].
	doc := XMLDOMParser parseDocumentFrom: (ReadStream on: xmlText).
	self basicImportFrom: doc topElement!

resourceFromByteArray: aByteArray 
	| result |
	aByteArray isNil ifTrue: [^nil].
	(exporterVersion isNil or: [exporterVersion < 1.1]) 
		ifTrue: 
			[result := Resource inSTBByteArray.
			result accessor byteArray: aByteArray]
		ifFalse: [result := Object fromBinaryStoreBytes: aByteArray].
	^result!

stringToByteArray: aString 
	aString isNil ifTrue: [^nil].
	exporterVersion isNil ifTrue: [^aString asByteArray].
	^(StsBase64EncoderDecoder decode: aString) asByteArray! !
!StsXMLPackageProxy categoriesFor: #basicImportFrom:!private! !
!StsXMLPackageProxy categoriesFor: #basicImportHeaderFieldsFrom:!private! !
!StsXMLPackageProxy categoriesFor: #basicImportHeaderFrom:!private! !
!StsXMLPackageProxy categoriesFor: #globalFromName:!public! !
!StsXMLPackageProxy categoriesFor: #importClass:!private! !
!StsXMLPackageProxy categoriesFor: #importGlobal:!private! !
!StsXMLPackageProxy categoriesFor: #importLooseMethod:!private! !
!StsXMLPackageProxy categoriesFor: #importMethod:classProxy:!private! !
!StsXMLPackageProxy categoriesFor: #importMethods:classProxy:!private! !
!StsXMLPackageProxy categoriesFor: #importResource:!private! !
!StsXMLPackageProxy categoriesFor: #importScript:!private! !
!StsXMLPackageProxy categoriesFor: #loadFrom:!public! !
!StsXMLPackageProxy categoriesFor: #resourceFromByteArray:!private! !
!StsXMLPackageProxy categoriesFor: #stringToByteArray:!private! !

