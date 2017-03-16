"Filed out from Dolphin Smalltalk 7"!

EMailObject subclass: #EMailAttachment
	instanceVariableNames: 'subAttachments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMailAttachment guid: (GUID fromString: '{d2fbd6e5-86f0-40e6-a683-386293baa48b}')!
EMailAttachment comment: ''!
!EMailAttachment categoriesForClass!Unclassified! !
!EMailAttachment methodsFor!

addFile: aFilename 
	| fileStream |
	self setHeaderForFile: aFilename.
	fileStream := FileStream read: aFilename type: #binary.
	fileStream isFileStream ifFalse: [^self error: 'Error opening file: ' , aFilename].
	[content := self encode: fileStream contents] ensure: [fileStream close]!

addFromStream: aStream filename: aFilename 
	self setHeaderForFile: aFilename.
	content := self encode: aStream contents!

encode: aString 
	^(contentEncoding isKindOf: Array) 
		ifTrue: [EmailMIMEEncoder encodeFrom: aString withEncoding: contentEncoding first]
		ifFalse: [EmailMIMEEncoder encodeFrom: aString withEncoding: contentEncoding]!

getContent
	contentEncoding isNil ifTrue: [^content].
	^EmailMIMEDecoder decodeFrom: content withEncoding: contentEncoding first!

getFilename
	| idx |
	contentDisposition isNil 
		ifFalse: 
			[contentDisposition do: 
					[:each | 
					(each beginsWith: 'filename=') 
						ifTrue: 
							[idx := each indexOf: $=.
							(each at: idx + 1) = $" 
								ifTrue: [^each copyFrom: idx + 2 to: each size - 1]
								ifFalse: [^each copyFrom: idx + 1 to: each size]]]].
	contentType isNil 
		ifFalse: 
			[contentType do: 
					[:each | 
					(each beginsWith: 'name=') 
						ifTrue: 
							[idx := each indexOf: $=.
							(each at: idx + 1) = $" 
								ifTrue: [^each copyFrom: idx + 2 to: each size - 1]
								ifFalse: [^each copyFrom: idx + 1 to: each size]]]].
	^nil!

isMessagePart
	contentDisposition isNil 
		ifFalse: [contentDisposition do: [:each | (each beginsWith: 'filename=') ifTrue: [^false]]].
	^true!

isMultipart

	^(boundary = nil) not!

postProcess
	| parts |

	contentType isNil ifTrue: [ ^self ].
	boundary isNil ifTrue: [ ^self ].
	parts := content splitString: boundary.
	subAttachments := EMailAttachment createFrom: (parts copyFrom: 2 to: parts size -1)
		!

setHeaderForFile: aFilename 
	| simpleFilename anArray1 anArray2 fileEnding index |
	simpleFilename := (index := aFilename reverse indexOf: $\) > 0 
				ifTrue: [aFilename copyFrom: aFilename size - index + 2 to: aFilename size]
				ifFalse: [aFilename].
	anArray1 := simpleFilename itcSubStrings: $..
	anArray1 size >= 2 ifTrue: [fileEnding := anArray1 last].
	anArray1 := Array new: 2.
	anArray2 := Array new: 2.
	anArray1
		at: 1 put: (EmailMIMETypes default getType: fileEnding);
		at: 2 put: 'name="' , simpleFilename , '"'.
	anArray2
		at: 1 put: 'attachment';
		at: 2 put: 'filename="' , simpleFilename , '"'.
	contentType := anArray1.
	contentEncoding := Array new: 1.
	contentEncoding at: 1 put: (EmailMIMETypes default getEncoding: fileEnding).
	contentDisposition := anArray2!

subAttachments

	^subAttachments!

toString
	| stream |

	stream := WriteStream on: String new.
	self addMultipleStrings: contentType withStart: 'Content-type: ' on: stream withSeparator: '; '.
	self addMultipleStrings: contentEncoding withStart: 'Content-transfer-encoding: ' on: stream withSeparator: '; '.
	self addMultipleStrings: contentDisposition withStart: 'Content-Disposition: ' on: stream withSeparator: '; '.
	contentType isNil ifFalse: [ stream cr ].
	stream
		nextPutAll: content;
		cr.
	^stream contents! !
!EMailAttachment categoriesFor: #addFile:!public! !
!EMailAttachment categoriesFor: #addFromStream:filename:!public! !
!EMailAttachment categoriesFor: #encode:!public! !
!EMailAttachment categoriesFor: #getContent!public! !
!EMailAttachment categoriesFor: #getFilename!public! !
!EMailAttachment categoriesFor: #isMessagePart!public! !
!EMailAttachment categoriesFor: #isMultipart!public! !
!EMailAttachment categoriesFor: #postProcess!public! !
!EMailAttachment categoriesFor: #setHeaderForFile:!public! !
!EMailAttachment categoriesFor: #subAttachments!public! !
!EMailAttachment categoriesFor: #toString!public! !

!EMailAttachment class methodsFor!

createFrom: anArray 
	| coll anAttachment |
	coll := OrderedCollection new.
	anArray do: 
			[:each | 
			each size > 3 
				ifTrue: 
					[anAttachment := super createFrom: (each copyFrom: 1 to: each size - 4).
					anAttachment postProcess.
					anAttachment isMultipart 
						ifTrue: [coll addAll: anAttachment subAttachments]
						ifFalse: [coll add: anAttachment]]].
	^coll! !
!EMailAttachment class categoriesFor: #createFrom:!public! !

