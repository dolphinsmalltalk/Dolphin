"Filed out from Dolphin Smalltalk X6.2"!

StsImportProxy subclass: #StsProjectProxy
	instanceVariableNames: 'packages previousVersionsData blessing versionComment'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsProjectProxy guid: (GUID fromString: '{58A0CB78-5A4B-46EC-B9E5-4309ED750F75}')!
StsProjectProxy comment: ''!
!StsProjectProxy categoriesForClass!Unclassified! !
!StsProjectProxy methodsFor!

basicImportFromDocument: document 
	| root |
	root := document topElement.
	(root elements isEmpty or: [root name ~= #project]) ifTrue: [^nil].
	packages := OrderedCollection new.
	root elements do: 
			[:each | 
			(self basicImportVersionDataFrom: each) 
				ifFalse: [each name == #package ifTrue: [self importPackage: each]]]!

basicImportHeaderFromDocument: document 
	| root |
	root := document topElement.
	(root elements isEmpty or: [root name ~= #projectHeader]) ifTrue: [^nil].
	packages := OrderedCollection new.
	root elements do: 
			[:each | 
			(self basicImportVersionDataFrom: each) 
				ifFalse: [each name == #packageHeader ifTrue: [self importPackageHeader: each]]]!

basicImportVersionDataFrom: aNode 
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
							[nodeName == #version 
								ifTrue: [self version: contentString]
								ifFalse: 
									[nodeName == #comment 
										ifTrue: [self comment: contentString]
										ifFalse: 
											[nodeName == #blessing 
												ifTrue: [self blessing: contentString asSymbol]
												ifFalse: 
													[nodeName == #versionComment 
														ifTrue: [self versionComment: contentString]
														ifFalse: 
															[nodeName == #previousVersion 
																ifTrue: [self previousVersionsData add: contentString]
																ifFalse: 
																	[nodeName == #previousVersionData 
																		ifTrue: [self previousVersionsData add: (self importPreviousVersionDataFrom: aNode)]
																		ifFalse: [^false]]]]]]]]].
	^true!

blessing
	^blessing!

blessing: aSymbolOrNil 
	(blessing isNil or: [self possibleBlessingLevels includes: aSymbolOrNil]) 
		ifFalse: [self error: 'Invalid blessing level'].
	blessing := aSymbolOrNil!

importPackage: anElement 
	| package |
	(package := StsXMLPackageProxy new basicImportFrom: anElement) isNil 
		ifFalse: [packages add: package]!

importPackageHeader: anElement 
	| package |
	(package := StsXMLPackageProxy new basicImportHeaderFrom: anElement) isNil 
		ifFalse: [packages add: package]!

importPreviousVersionDataFrom: xmlElement 
	| versionData nodeName contentString |
	versionData := LookupTable new.
	xmlElement elements do: 
			[:each | 
			contentString := each contentString.
			(nodeName := each name) == #name 
				ifTrue: [versionData at: #name put: contentString]
				ifFalse: 
					[nodeName == #developer 
						ifTrue: [versionData at: #developer put: contentString]
						ifFalse: 
							[nodeName == #version 
								ifTrue: [versionData at: #versionDescriptor put: contentString]
								ifFalse: 
									[nodeName == #timestamp 
										ifTrue: [versionData at: #timestamp put: (TimeStamp fromSeconds: contentString asNumber asInteger)]]]]].
	^versionData!

loadFrom: pathName 
	| doc file xmlText |
	file := FileStream read: pathName.
	[xmlText := file contents] ensure: [file close].
	(xmlText beginsWith: '<?xml') ifFalse: [xmlText := ZLibInterface decompress: xmlText].
	doc := XMLDOMParser parseDocumentFrom: (ReadStream on: xmlText).
	self basicImportFromDocument: doc!

packages
	^packages!

previousVersionsData
	previousVersionsData isNil ifTrue: [previousVersionsData := OrderedCollection new].
	^previousVersionsData!

projectVersion
	^version!

versionComment
	^versionComment!

versionComment: aStringOrNil 
	versionComment := aStringOrNil! !
!StsProjectProxy categoriesFor: #basicImportFromDocument:!private! !
!StsProjectProxy categoriesFor: #basicImportHeaderFromDocument:!private! !
!StsProjectProxy categoriesFor: #basicImportVersionDataFrom:!private! !
!StsProjectProxy categoriesFor: #blessing!accessing!public! !
!StsProjectProxy categoriesFor: #blessing:!accessing!public! !
!StsProjectProxy categoriesFor: #importPackage:!private! !
!StsProjectProxy categoriesFor: #importPackageHeader:!private! !
!StsProjectProxy categoriesFor: #importPreviousVersionDataFrom:!private! !
!StsProjectProxy categoriesFor: #loadFrom:!public! !
!StsProjectProxy categoriesFor: #packages!private! !
!StsProjectProxy categoriesFor: #previousVersionsData!public! !
!StsProjectProxy categoriesFor: #projectVersion!public! !
!StsProjectProxy categoriesFor: #versionComment!public! !
!StsProjectProxy categoriesFor: #versionComment:!public! !

