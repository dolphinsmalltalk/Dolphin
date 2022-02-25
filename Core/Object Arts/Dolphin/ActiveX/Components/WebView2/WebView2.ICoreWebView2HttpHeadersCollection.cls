"Filed out from Dolphin Smalltalk"!

ICoreWebView2IterableCollection subclass: #ICoreWebView2HttpHeadersCollection
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ICoreWebView2HttpHeadersCollection guid: (OS.COM.IID fromString: '{5b5d8e75-be21-4d21-9843-509bd2c0a429}')!
ICoreWebView2HttpHeadersCollection isNonInstantiable: true!
ICoreWebView2HttpHeadersCollection comment: '`ICoreWebView2HttpHeadersCollection` is not defined in the WebView2 IDL, but is defined here for economy of mechanism, providing a common implmentaton of most of the Smalltalk `<abstractDictionary>` protocol.'!
!ICoreWebView2HttpHeadersCollection categoriesForClass!COM-Interfaces! !
!ICoreWebView2HttpHeadersCollection methodsFor!

add: anAssociation
	self at: anAssociation key put: anAssociation value.
	^anAssociation!

addAll: newElements
	"Include all the elements of the <collection> argument, newElements, as the receiver's elements. 
	Answer newElements. 
	Note that this modifies the and answers the receiver, not a copy.
	newElements can actually be any object which understands #do:."

	newElements do: [:each | self add: each].
	^newElements!

asDictionary
	| answer |
	answer := Dictionary new.
	self associationsDo: [:each | answer add: each].
	^answer!

asLookupTable
	| answer |
	answer := LookupTable new.
	self keysAndValuesDo: [:eachKey :eachValue | answer at: eachKey put: eachValue].
	^answer!

associationsDo: aMonadicValuable
	^self keysAndValuesDo: [:eachKey :eachValue | aMonadicValuable value: eachKey -> eachValue]!

at: aString 
	^self getHeader: aString!

at: aString ifAbsent: aNiladicValuable
	^(self includesKey: aString) ifTrue: [self at: aString] ifFalse: [aNiladicValuable value]!

at: aString ifAbsentPut: aNiladicValuable
	^(self at: aString ifAbsent: nil) ifNil: [self at: aString put: aNiladicValuable value]!

at: nameString put: headerString
	^self subclassResponsibility!

collect: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's values. Answer a new collection like the receiver containing the same keys, and the values returned by the transformer on each evaluation."

	| answer |
	answer := LookupTable new.
	self keysAndValuesDo: [:key :value | answer at: key put: (aMonadicValuable value: value)].
	^answer!

Contains: name contains: contains
	self subclassResponsibility!

errorKeyNotFound: aKey
	"Private - Report that an attempt was made to look up a key which was not in the receiver"

	^self errorNotFound: aKey
!

errorValueNotFound: aValue
	"Private - Report that an attempt was made to look up the key for a value which was not
	in receiver"

	^self error: ('value not found: <1p>' expandMacrosWith: aValue)
!

getHeader: name
	"Answer the <Utf16String> result of invoking the GetHeader() method of the COM object."

	| ptr answer |
	ptr := COMTaskMemory new.
	self GetHeader: name asUtf16String value: ptr.
	answer := Utf16String fromAddress: ptr.
	ptr free.
	^answer!

GetHeader: name value: value
	self subclassResponsibility!

getHeaders: name
	"Answer the <ICoreWebView2HttpHeadersCollectionIterator> result of invoking the GetHeaders() method of the COM object."

	| answer |
	answer := ICoreWebView2HttpHeadersCollectionIterator newPointer.
	self GetHeaders: name asUtf16String iterator: answer.
	^answer asObject!

GetHeaders: name iterator: iterator
	self subclassResponsibility!

includesKey: aString
	| answer |
	answer := BOOL newBuffer.
	self Contains: aString asUtf16String contains: answer.
	^answer asObject!

iteratorClass
	^ICoreWebView2HttpHeadersCollectionIterator!

keyAtValue: aString
	"Answer the <String> name of one of the receiver's headers that is equal to the <String> argument. If there is no such value, send #errorValueNotFound: to the receiver with value as its argument."

	^(self keyAtValue: aString ifAbsent: nil) ifNil: [self errorValueNotFound: aString]!

keyAtValue: aString ifAbsent: aNiladicValuable
	"Answer the <readableString> key (name) of the first of the receiver's headers equal to the <readableString> first argument. If there is no such value, answer the result of evaluating the <niladicValuable> second argument."

	self keysAndValuesDo: [:eachKey :eachValue | eachValue = aString ifTrue: [^eachKey]].
	^aNiladicValuable value!

keys
	"Answer an array of the receiver's header name strings."

	| names |
	names := Array writeStream: 2.
	self keysAndValuesDo: [:eachKey :eachValue | names nextPut: eachKey].
	^names grabContents!

keysAndValuesDo: aDyadicValuable
	| iterator |
	iterator := self getIterator.
	iterator keysAndValuesDo: aDyadicValuable.
	iterator free!

keysDo: aMonadicValuable
	self keysAndValuesDo: [:key :value | aMonadicValuable value: key]!

printPropertiesOn: aStream
	"Print any properties of the receiver that might be useful for debugging, and which are not too verbose. Emit nothing by default."

	self keys do: [:each | aStream nextPutAll: each] separatedBy: [aStream nextPutAll: ', ']!

removeAllKeys: aCollection
	"Remove any headers from the receiver with the names in the <collection> argument.
	If any of the keys are not present in the receiver, or there are duplicates in keys, then raise an exception."

	aCollection do: [:each | self removeKey: each]!

removeAllKeys: aCollection ifAbsent: aMonadicValuable
	"Remove any elements from the receiver with the keys in the <collection> first argument. If any of the keys are not present in the receiver, or there are duplicates in keys, then evaluate the <niladicValuable>|<monadicValuable> second argument, but do not stop the enumeration."

	aCollection do: [:k | self removeKey: k ifAbsent: [aMonadicValuable cull: k]]!

RemoveHeader: name
	self subclassResponsibility!

removeKey: aString
	"Remove the header named by the <readableString> argument from the receiver. If key is not in the receiver, report an error. Otherwise, answer the value named by key."

	| removed |
	removed := self at: aString.
	self RemoveHeader: aString.
	^removed!

removeKey: aString ifAbsent: aNiladicValuable
	^(self at: aString ifAbsent: nil)
		ifNil: [aNiladicValuable value]
		ifNotNil: 
			[:removed |
			self RemoveHeader: aString.
			removed]!

select: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the receiver's header strings. Answer a new <collection> like the receiver containing only those elements for which 
	the discriminator evaluates to true."

	| answer |
	answer := LookupTable new.
	self keysAndValuesDo: [:k :v | (aMonadicValuable value: v) ifTrue: [answer at: k put: v]].
	^answer!

values
	"Answer an array of the receiver's header strings."

	| names |
	names := Array writeStream: 2.
	self keysAndValuesDo: [:eachKey :eachValue | names nextPut: eachValue].
	^names grabContents! !
!ICoreWebView2HttpHeadersCollection categoriesForMethods!
add:!adding!public! !
addAll:!adding!public! !
asDictionary!converting!public! !
asLookupTable!converting!public! !
associationsDo:!enumerating!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:ifAbsentPut:!accessing!public! !
at:put:!accessing!public! !
collect:!enumerating!public! !
Contains:contains:!COM Interfaces-ICoreWebView2HttpRequestHeaders!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
errorKeyNotFound:!exceptions!private! !
errorValueNotFound:!exceptions!private! !
getHeader:!methods!public! !
GetHeader:value:!COM Interfaces-ICoreWebView2HttpRequestHeaders!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
getHeaders:!methods!public! !
GetHeaders:iterator:!COM Interfaces-ICoreWebView2HttpRequestHeaders!COM Interfaces-ICoreWebView2HttpResponseHeaders!private! !
includesKey:!public!searching! !
iteratorClass!methods!private! !
keyAtValue:!accessing!public! !
keyAtValue:ifAbsent:!accessing!public! !
keys!accessing!public! !
keysAndValuesDo:!enumerating!public! !
keysDo:!enumerating!public! !
printPropertiesOn:!development!printing!private! !
removeAllKeys:!public!removing! !
removeAllKeys:ifAbsent:!public!removing! !
RemoveHeader:!COM Interfaces-ICoreWebView2HttpRequestHeaders!private! !
removeKey:!public!removing! !
removeKey:ifAbsent:!public!removing! !
select:!enumerating!public! !
values!accessing!public! !
!

ICoreWebView2HttpHeadersCollection methodProtocol: #abstractDictionary attributes: #(#ansi #readOnly) selectors: #(#addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:ifAbsentPut: #at:put: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #includesKey: #inject:into: #isEmpty #keyAtValue: #keyAtValue:ifAbsent: #keys #keysAndValuesDo: #keysDo: #notEmpty #occurrencesOf: #rehash #reject: #removeAllKeys: #removeAllKeys:ifAbsent: #removeKey: #removeKey:ifAbsent: #select: #size #values)!

