"======================================================================
|
|   Attribute protocols to existing Smalltalk classes
|
|   This file is in the public domain.
|
 ======================================================================"

| dict |

dict := Dictionary new.

dict at: 'Fundamental' put: #(
	('ANY'				('Object') 'inst' 'NoTst')
	('Object'			('Object') 'inst' 'UT')
	('nil'				('UndefinedObject') 'inst' 'UT')
	('boolean'			('Boolean') 'inst' 'UT')
	('Character'			('Character') 'inst' 'UT')	"StdGbl"
	('Character factory'		('Character') 'class' 'UT')
	('failedMessage'		('Message') 'inst' 'UT')
	('selector'			('Symbol') 'inst' 'UT')
	('classDescription'		('ClassDescription') 'inst' 'NoTst')
	('instantiator'			('Object') 'class' 'NoTst')
	('Object class'			('Object') 'class' 'UT')	"StdGbl"
).

dict at: 'Valuable' put: #(
	('valuable'			('BlockClosure') 'inst' 'NoTst')
	('niladicValuable'		('BlockClosure') 'inst' 'NoTst')
	('niladicBlock'			('BlockClosure') 'inst' 'UT')
	('monadicValuable'		('BlockClosure') 'inst' 'NoTst')
	('monadicBlock'			('BlockClosure') 'inst' 'UT')
	('dyadicValuable'		('BlockClosure') 'inst' 'UT')
).

dict at: 'Exception' put: #(
	('exceptionDescription'		('Exception') 'inst' 'NoTst')
	('exceptionSignaler'		('Exception') 'inst' 'NoTst')
	('exceptionBuilder'		('Exception') 'inst' 'NoTst')
	('signaledException'		('Exception') 'inst' 'NoTst')
	('exceptionSelector'		('Exception') 'class' 'NoTst')
	('exceptionInstantiator'	('Exception') 'class' 'NoTst')
	('Exception class'		('Exception') 'class' 'UT')	"StdGbl"
	('Exception'			('Exception') 'inst' 'UT')
	('Notification class'		('Notification') 'class' 'UT')	"StdGbl"
	('Notification'			('Notification') 'inst' 'UT')
	('Warning class'		('Warning') 'class' 'UT')	"StdGbl"
	('Warning'			('Warning') 'inst' 'UT')
	('Error class'			('Error') 'class' 'UT')	"StdGbl"
	('Error'			('Error') 'inst' 'UT')
	('ZeroDivide factory'		('ZeroDivide') 'class' 'UT')	"StdGbl"
	('ZeroDivide'			('ZeroDivide') 'inst' 'UT')
	('MessageNotUnderstoodSelector'	('MessageNotUnderstood') 'class' 'UT')
	('MessageNotUnderstood'		('MessageNotUnderstood') 'inst' 'UT')	"StdGbl"
	('exceptionSet'			('ExceptionSet') 'inst' 'UT')
).

dict at: 'Numeric' put: #(
	('magnitude'			('Magnitude') 'inst' 'NoTst')
	('number'			('Number') 'inst' 'NoTst')	"StdGbl"
	('rational'			('Fraction' 'Integer') 'inst' 'NoTst')
	('Fraction'			('Fraction') 'inst' 'UT')
	('integer'			('Integer') 'inst' 'UT')	"StdGbl"
	('scaledDecimal'		('ScaledDecimal') 'inst' 'UT')		"StdGbl"
	('Float'			('Float') 'inst' 'UT')
	('floatCharacterization'	('Float') 'class' 'UT')	"StdGbl"
	('Fraction factory'		('Fraction') 'class' 'UT')	"StdGbl"
).

dict at: 'Collection' put: #(
	('collection'			('Collection') 'inst' 'NoTst')
	('abstractDictionary'		('Dictionary') 'inst' 'NoTst')
	('Dictionary'			('Dictionary') 'inst' 'UT')
	('IdentityDictionary'		('IdentityDictionary') 'inst' 'UT')
	('extensibleCollection' 	('Bag' 'OrderedCollection' 'Set' 'String') 'inst' 'NoTst')
	('Bag'				('Bag')  'inst' 'UT')
	('Set'				('Set')  'inst' 'UT')
	('sequencedReadableCollection'	('SequenceableCollection') 'inst' 'NoTst')
	('Interval'			('Interval')  'inst' 'UT')
	('readableString'		('String') 'inst' 'NoTst')
	('symbol'			('Symbol') 'inst' 'UT')	"StdGbl"
	('sequencedCollection'		('SequenceableCollection') 'inst' 'NoTst')
	('String'			('String') 'inst' 'UT')
	('Array'			('Array') 'inst' 'UT')
	('ByteArray'			('ByteArray') 'inst' 'UT')
	('sequencedContractibleCollection' ('SequenceableCollection') 'inst' 'NoTst')
	('SortedCollection'		('SortedCollection') 'inst' 'UT')
	('OrderedCollection'		('OrderedCollection') 'inst' 'UT')
	('Interval factory'		('Interval') 'class' 'UT')		"StdGbl"
	('collection factory'		('Collection') 'class' 'NoTst')
	('Dictionary factory'		('Dictionary') 'class' 'UT')	"StdGbl"
	('IdentityDictionary factory'	('IdentityDictionary') 'class' 'UT')	"StdGbl"
	('initializableCollection factory' ('ArrayedCollection' 'Bag' 'OrderedCollection' 'Set') 'class' 'NoTst')
	('Array factory'		('Array') 'class' 'UT')	"StdGbl"
	('Bag factory'			('Bag') 'class' 'UT')		"StdGbl"
	('ByteArray factory'		('ByteArray') 'class' 'UT')	"StdGbl"
	('OrderedCollection factory'	('OrderedCollection') 'class' 'UT')	"StdGbl"
	('Set factory'			('Set') 'class' 'UT')	"StdGbl"
	('SortedCollection factory' 	('SortedCollection') 'class' 'UT')	"StdGbl"
	('String factory'		('String') 'class' 'UT')	"StdGbl"
).

dict at: 'Date and Time' put: #(
	('DateAndTime'			('DateAndTime') 'inst' 'UT')
	('Duration'			('Duration') 'inst' 'UT')
	('Duration factory'		('Duration') 'class' 'UT')	"StdGbl"
	('DateAndTime factory' 		('DateAndTime') 'class' 'UT')	"StdGbl"
).

dict at: 'Stream' put: #(
	('sequencedStream'		('PositionableStream') 'inst' 'NoTst')
	('gettableStream'		('PositionableStream') 'inst' 'NoTst')
	('collectionStream'		('PositionableStream') 'inst' 'NoTst')
	('puttableStream'		('WriteStream') 'inst' 'NoTst')
	('ReadStream'			('ReadStream') 'inst' 'UT')
	('WriteStream'			('WriteStream') 'inst' 'UT')
	('ReadWriteStream'		('ReadWriteStream') 'inst' 'UT')
	"('Transcript'			('Transcript') 'class' 'UT')	???StdGbl??
		?? ??? Transcript is instance of TranscriptStream ???"
	('ReadStream factory'		('ReadStream') 'class' 'UT')	"StdGbl"
	('ReadWriteStream factory'	('ReadWriteStream') 'class' 'UT')	"StdGbl"
	('WriteStream factory'		('WriteStream') 'class' 'UT')	"StdGbl"
).

dict at: 'File Stream' put: #(
	('FileStream'			('FileStream') 'inst' 'NoTst')
	('readFileStream'		('FileStream') 'inst' 'UT')
	('writeFileStream'		('FileStream') 'inst' 'UT')
	('FileStream factory'		('FileStream') 'class' 'UT')	"StdGbl"
).

dict keysAndValuesDo: [ :protocolGroupName :groupProtocols |
    groupProtocols do: [ :protocolClassesIsCls || protocol class side |
	protocol := protocolClassesIsCls at: 1.
	class := protocolClassesIsCls at: 2.
	side := protocolClassesIsCls at: 3.

	"Gosh, how awful a test is this!!"
	class := class select: [ :each || symbol |
		symbol := Symbol findInterned: each.
		symbol notNil 
			and: [ (symbol asQualifiedReference valueOrNil) notNil ]
	].

	ProtocolSpec
	    wrkAssocProtocolNamed: protocol asSymbol
	    toClassesNamed: class
	    isClassSideProtocol: side = 'class'
    ]
]!
