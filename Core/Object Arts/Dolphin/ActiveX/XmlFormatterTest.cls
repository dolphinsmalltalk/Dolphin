"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #XmlFormatterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
XmlFormatterTest guid: (GUID fromString: '{834290a8-1967-49c5-ad9f-f47cb1ed5d12}')!
XmlFormatterTest comment: ''!
!XmlFormatterTest categoriesForClass!Unclassified! !
!XmlFormatterTest methodsFor!

assertReformat: text toCanonical: canonical 
	| formatter reformatted dom |
	dom := self parseXml: text.
	formatter := XmlFormatter new.
	reformatted := formatter format: dom.
	self assert: reformatted = canonical
	"
DiffBrowser compare: reformatted with: canonical
"!

newDocument
	| dom |
	dom := IXMLDOMDocument3 new.
	dom setProperty_: 'ProhibitDTD' value: false.
	^dom!

parseXml: text
	| dom |
	dom := self newDocument.
	dom
		preserveWhiteSpace: false;
		validateOnParse: false;
		resolveExternals: false.
	dom loadText: text.
	^dom!

testCanonicalExample3_1
	"
DiffBrowser compare: reformatted with: canonical
"

	| text canonical |
	text := '<?xml version="1.0"?>

<?xml-stylesheet   href="doc.xsl" type="text/xsl"   ?>

<!!DOCTYPE doc SYSTEM "doc.dtd">

<doc>Hello, world!!<!!-- Comment 1 --></doc>

<?pi-without-data     ?>

<!!-- Comment 2 -->

<!!-- Comment 3 -->'.
	"Normalization of whitespace outside of document element (first character of canonical form is '<'; single line breaks separate PIs and comments outside of document element) "
	canonical := '<?xml version="1.0"?>
<?xml-stylesheet href="doc.xsl" type="text/xsl"   ?>
<!!DOCTYPE doc SYSTEM "doc.dtd">
<doc>Hello, world!!<!!-- Comment 1 --></doc>
<?pi-without-data?>
<!!-- Comment 2 -->
<!!-- Comment 3 -->'.
	self assertReformat: text toCanonical: canonical!

testCanonicalExample3_2
	"
DiffBrowser compare: reformatted with: canonical
"

	| canonical |
	canonical := '<doc>
	<clean></clean>
	<dirty>   A   B   </dirty>
	<mixed>
      A
      <clean></clean>
      B
      <dirty>   A   B   </dirty>
      C
	</mixed>
</doc>'.
	self assertReformat: canonical toCanonical: canonical!

testCanonicalExample3_3
	| text canonical |
	text := '<!!DOCTYPE doc [<!!ATTLIST e9 attr CDATA "default">]>
<doc>
	<e1   /><e2   ></e2>
          <e3   name = "elem3"   id="elem3"   />
	<e4   name="elem4"   id="elem4"   ></e4>
	<e5 a:attr="out" b:attr="sorted" attr2="all" attr="I''m"
      xmlns:b="http://www.ietf.org"
      xmlns:a="http://www.w3.org"
      xmlns="http://example.org"/>
   <e6 xmlns="" xmlns:a="http://www.w3.org">
      <e7 xmlns="http://www.ietf.org">
         <e8 xmlns="" xmlns:a="http://www.w3.org">
            <e9 xmlns="" xmlns:a="http://www.ietf.org"/>
         </e8>
      </e7>
   </e6>
</doc>'.
	canonical := '<!!DOCTYPE doc [<!!ATTLIST e9 attr CDATA "default">]>
<doc>
	<e1/>
	<e2></e2>
	<e3 id="elem3" name="elem3"/>
	<e4 id="elem4" name="elem4"></e4>
	<e5 xmlns:a="http://www.w3.org" xmlns:b="http://www.ietf.org" attr="I''m" attr2="all" b:attr="sorted" a:attr="out" xmlns="http://example.org"/>
	<e6 xmlns:a="http://www.w3.org">
		<e7 xmlns="http://www.ietf.org">
			<e8 xmlns:a="http://www.w3.org" xmlns="">
				<e9 xmlns:a="http://www.ietf.org" attr="default"/>
			</e8>
		</e7>
	</e6>
</doc>'.
	self assertReformat: text toCanonical: canonical!

testDocumentType
	| text dom formatter reformatted |
	text := '<?xml version="1.0"?>
<!!DOCTYPE COLLECTION [ 
<!!ELEMENT COLLECTION    (DATE? , BOOK+) >
<!!ATTLIST COLLECTION
    xmlns:dt CDATA #FIXED "urn:schemas-microsoft-com:datatypes">
<!!ELEMENT BOOK         (TITLE, AUTHOR, PUBLISHER) >
<!!ELEMENT DATE         (#PCDATA) >
<!!ELEMENT TITLE         (#PCDATA)  >
<!!ELEMENT AUTHOR        (#PCDATA)  >
<!!ELEMENT PUBLISHER     (#PCDATA)  >
]>
<COLLECTION xmlns:dt="urn:schemas-microsoft-com:datatypes">
	<BOOK>
		<TITLE>Lover Birds</TITLE>
		<AUTHOR>Cynthia Randall</AUTHOR>
		<PUBLISHER>Lucerne Publishing</PUBLISHER>
	</BOOK>
	<BOOK>
		<TITLE>The Sundered Grail</TITLE>
		<AUTHOR>Eva Corets</AUTHOR>
		<PUBLISHER>Lucerne Publishing</PUBLISHER>
	</BOOK>
	<BOOK>
		<TITLE>Splish Splash</TITLE>
		<AUTHOR>Paula Thurman</AUTHOR>
		<PUBLISHER>Scootney</PUBLISHER>
	</BOOK>
</COLLECTION>'.
	dom := self newDocument.
	dom loadText: text.
	formatter := XmlFormatter new.
	reformatted := formatter format: dom.

	self assert: reformatted = text
"
DiffBrowser compare: reformatted with: text
"! !
!XmlFormatterTest categoriesFor: #assertReformat:toCanonical:!helpers!private! !
!XmlFormatterTest categoriesFor: #newDocument!helpers!private! !
!XmlFormatterTest categoriesFor: #parseXml:!helpers!private! !
!XmlFormatterTest categoriesFor: #testCanonicalExample3_1!public!unit tests! !
!XmlFormatterTest categoriesFor: #testCanonicalExample3_2!public!unit tests! !
!XmlFormatterTest categoriesFor: #testCanonicalExample3_3!public!unit tests! !
!XmlFormatterTest categoriesFor: #testDocumentType!public!unit tests! !

