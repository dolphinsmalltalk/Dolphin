"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StsXmlWriter
	instanceVariableNames: 'stream ident'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsXmlWriter guid: (GUID fromString: '{77b1fad1-6b16-4380-a3a3-bc4c2bffb772}')!
StsXmlWriter comment: ''!
!StsXmlWriter categoriesForClass!Kernel-Objects! !
!StsXmlWriter methodsFor!

putValue: aString 
	aString isNil ifTrue: [^self].
	aString do: 
			[:ch | 
			ch = $& 
				ifTrue: [stream nextPutAll: '&amp;']
				ifFalse: 
					[ch = $< 
						ifTrue: [stream nextPutAll: '&lt;']
						ifFalse: 
							[ch = $> 
								ifTrue: [stream nextPutAll: '&gt;']
								ifFalse: [ch = $" ifTrue: [stream nextPutAll: '&quot;'] ifFalse: [stream nextPut: ch]]]]]!

stream: aStream 
	stream := aStream.
	ident := 0!

tag: tagName 
	self tag: tagName attributes: nil!

tag: tagName attributes: attributes 
	stream cr.
	ident timesRepeat: [stream tab].
	stream
		nextPut: $<;
		nextPutAll: tagName.
	attributes isNil 
		ifFalse: 
			[attributes do: 
					[:each | 
					stream
						nextPut: $ ;
						nextPutAll: each key;
						nextPutAll: '="';
						nextPutAll: each value;
						nextPutAll: '"']].
	stream nextPut: $>!

tag: tagName attributes: attributes do: aBlock 
	self tag: tagName attributes: attributes.
	ident := ident + 1.
	aBlock value.
	ident := ident - 1.
	self untag: tagName!

tag: tagName attributes: attributes value: value 
	self
		tag: tagName attributes: attributes;
		putValue: value;
		untag: tagName!

tag: tagName cData: cdata 
	self tag: tagName.
	stream
		nextPutAll: '<!![CDATA[';
		nextPutAll: (StsBase64EncoderDecoder encode: cdata);
		nextPutAll: ']]>'.
	self untag: tagName!

tag: tagName do: aBlock 
	self 
		tag: tagName
		attributes: nil
		do: aBlock!

tag: tagName value: value 
	self 
		tag: tagName
		attributes: nil
		value: value!

untag: tagName 
	stream
		nextPut: $<;
		nextPut: $/;
		nextPutAll: tagName;
		nextPut: $>! !
!StsXmlWriter categoriesFor: #putValue:!accessing!public! !
!StsXmlWriter categoriesFor: #stream:!accessing!public! !
!StsXmlWriter categoriesFor: #tag:!accessing!public! !
!StsXmlWriter categoriesFor: #tag:attributes:!accessing!public! !
!StsXmlWriter categoriesFor: #tag:attributes:do:!accessing!public! !
!StsXmlWriter categoriesFor: #tag:attributes:value:!accessing!public! !
!StsXmlWriter categoriesFor: #tag:cData:!accessing!public! !
!StsXmlWriter categoriesFor: #tag:do:!accessing!public! !
!StsXmlWriter categoriesFor: #tag:value:!accessing!public! !
!StsXmlWriter categoriesFor: #untag:!accessing!public! !

!StsXmlWriter class methodsFor!

on: aStream 
	^self new stream: aStream! !
!StsXmlWriter class categoriesFor: #on:!instance creation!public! !

