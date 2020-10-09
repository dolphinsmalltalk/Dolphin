"Filed out from Dolphin Smalltalk 7"!

Kernel.Namespace subclass: #STON
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Core private} #{Kernel private})
	classInstanceVariableNames: ''
	classConstants: {}!
STON guid: (Core.GUID fromString: '{9f4c50c0-4b3c-4c6c-b0b5-98940098a150}')!
STON isNonInstantiable: true!
STON comment: 'STON implements serialization and materialization using the Smalltalk Object Notation format.

I am a class side facade offering a high level API to write and read objects using STON.

U s a g e

Basic operations

  #toString:
  #fromString:

  STON toString: DisplayScreen boundingBox.
  STON fromString:  ''Rectangle{#origin:Point[0,0],#corner:Point[1920,1030]}''.

  STON toString: { DateAndTime now. Float pi. 1 to: 10 by: 2. 3 days }.
  STON fromString:  ''[DateAndTime[''''2016-03-15T13:57:59.462422+01:00''''],3.141592653589793,Interval{#start:1,#stop:10,#step:2},Duration{#nanos:0,#seconds:259200}]''

You can also read from or write to streams

  #fromStream:
  #put:onStream:

There is also the option to do pretty printing (indenting, multi line output) 

  #toStringPretty:
  #put:onStreamPretty:

STON is more or less a superset of JSON and is backwards compatible with JSON while parsing, and can be compatible with it while writing. The important differences (and the whole reason why STON exists in the first place) are 

  - class information (except for lists (Array) and maps (Dictionary))
  - proper handling of shared and circular references
  - more Smalltalk like syntax (Symbols with #, single qouted Strings, nil instead of null)
  - more defined special types (Date, Time, DataAndTime, ByteArray, Point)

Parsing JSON is done using #fromString: or #fromStream: with the results being composed of Arrays and Dictionaries.

Writing objects as JSON is done using: 

  #toJsonString[Pretty]:
  #put:asJsonOnStream[Pretty]:

Note that you can only write Arrays and Dictionaries !!

For a much more sophisticated JSON parser/writer implementation, have a look at NeoJSON.

Like JSON, STON does not allow for comments. However, a preprocessor option can skip C style comments before parsing.

I also define some contants used in the implementation: the class used as list, map and association, as well as the optional class name key (used when reading objects using an unknown class).


I m p l e m e n t a t i o n

The 2 key methods are

  #stonOn:
  #fromSton:

which work together with STONWriter and STONReader; read their class comments for all configuration options (you can use the #reader and #writer methods to avoid referring to these classes directly).

Several methods are used to support and/or control the implementation

  #stonName - defines the external name for a class
  #stonAllInstVarNames - defines which instance variable to write
  #stonContainSubObjects - shortcut looking into objects for subobjects
  #stonShouldWriteNilInstVars - option to skip writing nil valued instance variables


S y n t a x

	value
	  primitive-value
	  object-value
	  reference
	  nil
	primitive-value
	  number
	  true
	  false
	  symbol
	  string
	object-value
	  object
	  map
	  list
	object
	  classname map
	  classname list
	reference
	  @ int-index-previous-object-value
	map
	  {}
	  { members }
	members
	  pair
	  pair , members
	pair
	  string : value
	  symbol : value
	  number : value
	list
	  []
	  [ elements ]
	elements
	  value 
	  value , elements
	string
	  ''''
	  '' chars ''
	chars
	  char
	  char chars
	char
	  any-printable-ASCII-character-
	    except-''-"-or-\
	  \''
	  \"
	  \\
	  \/
	  \b
	  \f
	  \n
	  \r
	  \t
	  \u four-hex-digits
	symbol
	  # chars-limited
	  # '' chars ''
	chars-limited
	  char-limited
	  char-limited chars-limited
	char-limited
	  a-z A-Z 0-9 - _ . /
	classname
	  uppercase-alpha-char alphanumeric-char
	number
	  int
	  int frac
	  int exp
	  int frac exp
	int
	  digit
	  digit1-9 digits 
	  - digit
	  - digit1-9 digits
	frac
	  . digits
	exp
	  e digits
	digits
	  digit
	  digit digits
	e
	  e
	  e+
	  e-
	  E
	  E+
	  E-
'!
!STON categoriesForClass!STON-Core-Base! !
!STON class methodsFor!

associationClass
	^ Association!

classNameKey
	^ #className!

fromStream: readStream
	^ (self reader on: readStream) next!

fromStreamWithComments: readStream
	^ (self reader on: (CStyleCommentsSkipStream on: readStream)) next!

fromString: string
	^ self fromStream: string readStream!

fromStringWithComments: string
	^ self fromStreamWithComments: string readStream!

listClass
	^ Array!

mapClass
	^ Dictionary!

prettyPrinter
	^PrettyPrinter new!

put: object onStream: stream
	(self writer on: stream) nextPut: object!

put: object onStreamPretty: stream
	(self prettyPrinter on: stream)
		nextPut: object!

reader
	^ Reader new!

readFrom: aReadStream
	^self fromStream: aReadStream!

toString: object
	^ String streamContents: [ :stream |
		self put: object onStream: stream ]!

toStringPretty: object
	^ String streamContents: [ :stream |
		self put: object onStreamPretty: stream ]!

writer
	^Writer new! !
!STON class categoriesFor: #associationClass!accessing!public! !
!STON class categoriesFor: #classNameKey!accessing!public! !
!STON class categoriesFor: #fromStream:!convenience!public! !
!STON class categoriesFor: #fromStreamWithComments:!convenience!public! !
!STON class categoriesFor: #fromString:!convenience!public! !
!STON class categoriesFor: #fromStringWithComments:!convenience!public! !
!STON class categoriesFor: #listClass!accessing!public! !
!STON class categoriesFor: #mapClass!accessing!public! !
!STON class categoriesFor: #prettyPrinter!private! !
!STON class categoriesFor: #put:onStream:!convenience!public! !
!STON class categoriesFor: #put:onStreamPretty:!convenience!public! !
!STON class categoriesFor: #reader!accessing!public! !
!STON class categoriesFor: #readFrom:!convenience!public! !
!STON class categoriesFor: #toString:!convenience!public! !
!STON class categoriesFor: #toStringPretty:!convenience!public! !
!STON class categoriesFor: #writer!accessing!public! !

